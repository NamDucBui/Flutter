import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/models/next_day_weather.dart';
import 'package:weather_app/widgets/day_card.dart';

class DailyWeatherList extends StatelessWidget {
  const DailyWeatherList({super.key, required this.dailyForecast});

  final List<NextDayWeather> dailyForecast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          color: Colors.white.withValues(alpha: 0.65), size: 13),
                      const SizedBox(width: 6),
                      Text(
                        '7-DAY FORECAST',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.65),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Colors.white.withValues(alpha: 0.18),
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dailyForecast.length,
                  separatorBuilder: (_, _) => Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                  ),
                  itemBuilder: (context, index) =>
                      DayCard(day: dailyForecast[index]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
