import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/city_weather.dart';
import 'package:weather_app/widgets/current_weather.dart';
import 'package:weather_app/widgets/daily_weather_list.dart';
import 'package:weather_app/widgets/hourly_weather_list.dart';
import 'package:weather_app/widgets/map_widget.dart';
import 'package:weather_app/widgets/weather_infor_card.dart';

class CityPage extends StatelessWidget {
  const CityPage({super.key, required this.data});

  final CityWeatherData data;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(), // scroll mượt hơn (iOS style)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🌡️ Current weather
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                CurrentWeather(weather: data.current),

                const SizedBox(height: 4),

                // Last updated timestamp
                Text(
                  'Updated: ${DateFormat('HH:mm dd/MM').format(data.updatedAt)}',
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),

                const SizedBox(height: 12),

                Align(
                  alignment: Alignment.centerRight,
                  child: WeatherInforCard(weather: data.current),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ⏰ Hourly
          HourlyWeatherList(hourlyForecast: data.hourly),

          const SizedBox(height: 16),

          // 📅 Daily
          DailyWeatherList(dailyForecast: data.daily),

          const SizedBox(height: 20),

          // 🗺️ Map title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Map',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 🗺️ Map
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: MapWidget(
                lat: data.current.latitude,
                lon: data.current.longitude,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
