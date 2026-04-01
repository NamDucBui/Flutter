import 'package:flutter/material.dart';
import 'package:weather_app/models/city_weather.dart';
import 'package:weather_app/widgets/current_weather.dart';
import 'package:weather_app/widgets/daily_weather_list.dart';
import 'package:weather_app/widgets/hourly_weather_list.dart';
import 'package:weather_app/widgets/weather_infor_card.dart';

class CityPage extends StatelessWidget {
  const CityPage({super.key, required this.data});

  final CityWeatherData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 🌡️ Current weather — chiếm phần lớn không gian
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CurrentWeather(weather: data.current),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: WeatherInforCard(weather: data.current),
                ),
              ],
            ),
          ),
        ),

        // ⏰ Hourly list
        HourlyWeatherList(hourlyForecast: data.hourly),
        const SizedBox(height: 12),

        // 📅 Daily list
        DailyWeatherList(dailyForecast: data.daily),
        const SizedBox(height: 16),
      ],
    );
  }
}
