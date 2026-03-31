import 'package:flutter/material.dart';
import 'package:weather_app/models/next_day_weather.dart';
import 'package:weather_app/widgets/day_card.dart';

class DailyWeatherList extends StatelessWidget {
  const DailyWeatherList({super.key, required this.dailyForecast});

  final List<NextDayWeather> dailyForecast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: dailyForecast.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) => DayCard(day: dailyForecast[index]),
      ),
    );
  }
}
