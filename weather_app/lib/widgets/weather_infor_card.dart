import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class WeatherInforCard extends StatelessWidget {
  const WeatherInforCard({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(color: Colors.white);
    const titleStyle = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Today's weather", style: titleStyle),
              const SizedBox(width: 12),
              Text(weather.time, style: textStyle),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Max ${weather.maxTemp}°", style: textStyle),
              const SizedBox(width: 12),
              Text("Min ${weather.minTemp}°", style: textStyle),
            ],
          ),
        ],
      ),
    );
  }
}
