import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';

class WeatherInforCard extends StatelessWidget {
  const WeatherInforCard({super.key, required this.weather});

  final Weather weather;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.13),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.info_outline_rounded,
                          color: Colors.white.withValues(alpha: 0.65), size: 13),
                      const SizedBox(width: 6),
                      Text(
                        'TODAY\'S DETAILS',
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
                  indent: 12,
                  endIndent: 12,
                ),
                // 2×2 grid
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _InfoTile(
                            icon: Icons.arrow_upward_rounded,
                            iconColor: Colors.redAccent,
                            label: 'Highest',
                            value: '${weather.maxTemp}°C',
                          ),
                          const SizedBox(width: 8),
                          _InfoTile(
                            icon: Icons.arrow_downward_rounded,
                            iconColor: Colors.lightBlueAccent,
                            label: 'Lowest',
                            value: '${weather.minTemp}°C',
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _InfoTile(
                            icon: Icons.thermostat_rounded,
                            iconColor: Colors.orangeAccent,
                            label: 'Feels like',
                            value: '${weather.temperature.round()}°C',
                          ),
                          const SizedBox(width: 8),
                          _InfoTile(
                            icon: Icons.access_time_rounded,
                            iconColor: Colors.white60,
                            label: 'Updated',
                            value: weather.time.length > 11
                                ? weather.time.substring(11)
                                : weather.time,
                          ),
                        ],
                      ),
                    ],
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 10,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
