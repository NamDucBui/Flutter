import 'package:intl/intl.dart';

// WeatherType enum đã xóa — không được dùng ở bất kỳ đâu trong codebase

class Weather {
  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.maxTemp,
    required this.minTemp,
    required this.time,
    required this.latitude,
    required this.longitude,
  });
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final int maxTemp;
  final int minTemp;
  final String time;
  final double latitude;
  final double longitude;

  factory Weather.fromJson(Map<String, dynamic> json) {
    // Guard: OWM trả 'weather' list có thể rỗng trong edge cases
    final weatherList = json['weather'] as List<dynamic>? ?? [];
    final weatherData = weatherList.isNotEmpty
        ? weatherList[0] as Map<String, dynamic>
        : <String, dynamic>{};

    final main = json['main'] as Map<String, dynamic>? ?? {};
    final coord = json['coord'] as Map<String, dynamic>? ?? {};

    return Weather(
      cityName: (json['name'] as String?) ?? 'Unknown',
      temperature: (main['temp'] as num?)?.toDouble() ?? 0.0,
      description: (weatherData['description'] as String?) ?? '',
      icon: (weatherData['icon'] as String?) ?? '01d',
      maxTemp: (main['temp_max'] as num?)?.round() ?? 0,
      minTemp: (main['temp_min'] as num?)?.round() ?? 0,
      time: json['dt'] != null
          ? DateFormat('dd/MM/yyyy HH:mm').format(
              DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
            )
          : '',
      latitude: (coord['lat'] as num?)?.toDouble() ?? 0.0,
      longitude: (coord['lon'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
