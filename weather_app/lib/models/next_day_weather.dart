import 'package:intl/intl.dart';

class NextDayWeather {
  final int dt;
  final String icon;
  final double maxTemp;
  final double minTemp;

  NextDayWeather({
    required this.dt,
    required this.icon,
    required this.maxTemp,
    required this.minTemp,
  });

  // Đọc từ map đã được xử lý bởi WeatherService._groupByDay():
  // temp_max/temp_min là giá trị min/max đã tính từ các mốc 3h trong ngày,
  // không phải trực tiếp từ /forecast API (vốn không có daily summary).
  factory NextDayWeather.fromJson(Map<String, dynamic> json) {
    return NextDayWeather(
      dt: json['dt'] as int,
      icon: json['weather'][0]['icon'] as String,
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
    );
  }

  // Tên ngày viết tắt: Mon, Tue, Wed...
  String get dayLabel {
    final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    return DateFormat('EEE').format(date);
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$icon@2x.png';
}
