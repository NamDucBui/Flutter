import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/next_day_weather.dart';
import 'package:weather_app/models/weather.dart';

class CityWeatherData {
  final Weather current;
  final List<HourlyWeather> hourly;
  final List<NextDayWeather> daily;

  const CityWeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
  });
}
