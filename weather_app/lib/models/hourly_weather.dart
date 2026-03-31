import 'package:intl/intl.dart'; // Cần thêm dependency intl vào pubspec.yaml

class HourlyWeather {
  final int dt; // Unix timestamp
  final String iconCode; // Mã icon thời tiết
  final double temperature; // Nhiệt độ
  final double pop; // Xác suất mưa (Probability of Precipitation)

  HourlyWeather({
    required this.dt,
    required this.iconCode,
    required this.temperature,
    required this.pop,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      dt: json['dt'],
      iconCode: json['weather'][0]['icon'],
      temperature: json['main']['temp'].toDouble(),
      pop: json['pop'].toDouble(),
    );
  }

  // Helper method để lấy thời gian định dạng (ví dụ: 9 a.m)
  String get formattedTime {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    return DateFormat('EEE h a').format(dateTime).toLowerCase();
  }

  // Helper method để lấy URL icon
  String get iconUrl {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // Helper method để lấy xác suất mưa dưới dạng phần trăm
  String get popPercentage {
    return '${(pop * 100).toInt()}%';
  }

  // Helper method để lấy nhiệt độ dưới dạng số nguyên và có ký hiệu độ C
  String get temperatureString {
    return '${temperature.round()}°';
  }
}
