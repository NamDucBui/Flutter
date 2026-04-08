import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/models/hourly_weather.dart';

class HourlyWeatherList extends StatelessWidget {
  final List<HourlyWeather> hourlyForecast;

  const HourlyWeatherList({super.key, required this.hourlyForecast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      // 1 frosted panel bọc toàn section — ít BackdropFilter hơn, GPU hiệu quả hơn
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
                // Section header
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  child: Row(
                    children: [
                      Icon(Icons.access_time_rounded,
                          color: Colors.white.withValues(alpha: 0.65), size: 13),
                      const SizedBox(width: 6),
                      Text(
                        'HOURLY FORECAST',
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
                SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                    itemCount: hourlyForecast.length,
                    itemBuilder: (context, index) =>
                        _HourlyItem(data: hourlyForecast[index]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HourlyItem extends StatelessWidget {
  final HourlyWeather data;
  const _HourlyItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            data.formattedTime,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Image.network(
            data.iconUrl,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            errorBuilder: (_, e, s) => const Icon(
              Icons.wb_sunny_outlined,
              color: Colors.white70,
              size: 32,
            ),
          ),
          Text(
            data.popPercentage,
            style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12),
          ),
          Text(
            data.temperatureString,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
