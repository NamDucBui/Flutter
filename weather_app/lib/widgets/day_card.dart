import 'package:flutter/material.dart';
import 'package:weather_app/models/next_day_weather.dart';

class DayCard extends StatelessWidget {
  const DayCard({super.key, required this.day});

  final NextDayWeather day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 290,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            day.dayLabel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          Image.network(
            day.iconUrl,
            width: 36,
            height: 36,
            errorBuilder: (_, __, ___) => const Icon(
              Icons.wb_sunny_outlined,
              color: Colors.white70,
              size: 28,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${day.maxTemp.round()}°',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                '${day.minTemp.round()}°',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
