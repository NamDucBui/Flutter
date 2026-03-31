import 'package:flutter/material.dart';
import 'package:weather_app/models/hourly_weather.dart'; // Import model HourlyWeather

class HourlyWeatherList extends StatelessWidget {
  final List<HourlyWeather> hourlyForecast;

  const HourlyWeatherList({super.key, required this.hourlyForecast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Chiều cao cố định cho danh sách cuộn ngang
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourlyForecast.length, // Hiển thị tất cả 48 giờ
        itemBuilder: (context, index) {
          final hourlyData = hourlyForecast[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: _buildHourlyItem(hourlyData),
          );
        },
      ),
    );
  }

  Widget _buildHourlyItem(HourlyWeather hourlyData) {
    return Container(
      width: 100, // Chiều rộng cố định cho mỗi item
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Màu nền trong suốt nhẹ
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            hourlyData.formattedTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Image.network(
            hourlyData.iconUrl,
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
          Text(
            hourlyData.popPercentage,
            style: const TextStyle(color: Colors.lightBlueAccent, fontSize: 12),
          ),
          Text(
            hourlyData.temperatureString,
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
