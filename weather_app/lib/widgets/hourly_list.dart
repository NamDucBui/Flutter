import 'package:flutter/material.dart';
import 'package:weather_app/models/hourly_weather.dart';

class HourlyList extends StatelessWidget {
  final List<HourlyWeather> list;

  const HourlyList({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];
          return Column(
            children: [Text(item.time), Text('${item.temperature}°')],
          );
        },
      ),
    );
  }
}
