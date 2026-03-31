import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key, required this.weather});
  final Weather weather;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(90),
      child: Column(
        children: [
          Text('${weather.temperature}°C', style: TextStyle(fontSize: 60)),
          Text(weather.description),
          Text(weather.cityName),
        ],
      ),
    );
  }
}
