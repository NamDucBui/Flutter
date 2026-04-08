import 'package:intl/intl.dart';

class HourlyWeather {
  final int dt;
  final String iconCode;
  final double temperature;
  final double pop; // Xác suất mưa (Probability of Precipitation)

  HourlyWeather({
    required this.dt,
    required this.iconCode,
    required this.temperature,
    required this.pop,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    // Guard: 'weather' list có thể rỗng, 'pop' là optional trong OWM /forecast
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final iconCode = weatherList.isNotEmpty
        ? (weatherList[0] as Map<String, dynamic>)['icon'] as String? ?? '01d'
        : '01d';

    final main = json['main'] as Map<String, dynamic>? ?? {};

    return HourlyWeather(
      dt: (json['dt'] as int?) ?? 0,
      iconCode: iconCode,
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      pop: (json['pop'] as num?)?.toDouble() ?? 0.0,
    );
  }

  String get formattedTime {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    return DateFormat('EEE h a').format(dateTime).toLowerCase();
  }

  String get iconUrl => 'https://openweathermap.org/img/wn/$iconCode@2x.png';

  String get popPercentage => '${(pop * 100).toInt()}%';

  String get temperatureString => '${temperature.round()}°';
}
