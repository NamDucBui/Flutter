import 'package:intl/intl.dart';

enum WeatherType { sunny, cloudy, rain, storm }

class Weather {
  const Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.icon,
    required this.maxTemp,
    required this.minTemp,
    required this.time,
  });
  final String cityName;
  final double temperature;
  final String description;
  final String icon;
  final int maxTemp;
  final int minTemp;
  final String time;

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],

      maxTemp: json['main']['temp_max'].round(),

      minTemp: json['main']['temp_min'].round(),

      time: DateFormat(
        'dd/MM/yyyy HH:mm',
      ).format(DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000)),
    );
  }
}
