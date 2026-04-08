import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class CurrentWeather extends StatelessWidget {
  const CurrentWeather({super.key, required this.weather});
  final Weather weather;
  @override
  Widget build(BuildContext context) {
    return Padding(
      // M4: padding 90 clips city name trên màn hình nhỏ → giảm xuống hợp lý
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          // M3: dùng .round() để tránh hiển thị 22.340000000000003°C
          Text('${weather.temperature.round()}°C', style: const TextStyle(fontSize: 60)),
          Text(weather.description),
          Text(weather.cityName),
        ],
      ),
    );
  }
}
