import 'package:flutter/material.dart';
import 'package:weather_app/models/next_day_weather.dart';

class DayCard extends StatelessWidget {
  const DayCard({super.key, required this.day});

  final NextDayWeather day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Row(
        children: [
          // Ngày — cố định width để các col thẳng hàng
          SizedBox(
            width: 80,
            child: Text(
              day.dayLabel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Image.network(
            day.iconUrl,
            width: 32,
            height: 32,
            errorBuilder: (_, e, s) => const Icon(
              Icons.wb_sunny_outlined,
              color: Colors.white70,
              size: 26,
            ),
          ),
          const Spacer(),
          // Min temp — mờ
          Text(
            '${day.minTemp.round()}°',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 10),
          // Temp range bar
          _TempRangeBar(min: day.minTemp, max: day.maxTemp),
          const SizedBox(width: 10),
          // Max temp — sáng
          SizedBox(
            width: 34,
            child: Text(
              '${day.maxTemp.round()}°',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Mini bar gradient thể hiện khoảng nhiệt độ trong ngày
class _TempRangeBar extends StatelessWidget {
  final double min;
  final double max;

  const _TempRangeBar({required this.min, required this.max});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
        gradient: LinearGradient(
          colors: [
            Colors.blue.withValues(alpha: 0.7),
            Colors.orange.withValues(alpha: 0.9),
          ],
        ),
      ),
    );
  }
}
