import 'package:flutter/material.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/next_day_weather.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/background_widget.dart';
import 'package:weather_app/widgets/current_weather.dart';
import 'package:weather_app/widgets/daily_weather_list.dart';
import 'package:weather_app/widgets/hourly_weather_list.dart';
import 'package:weather_app/widgets/search_bar.dart';
import 'package:weather_app/widgets/weather_infor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _service = WeatherService();

  Weather? _currentWeather;
  List<HourlyWeather> _hourlyForecast = [];
  List<NextDayWeather> _dailyForecast = [];

  bool _isLoading = true;
  String _currentCity = 'Hanoi';

  @override
  void initState() {
    super.initState();
    _fetchData(_currentCity);
  }

  Future<void> _fetchData(String city) async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait([
        _service.fetchWeather(city),
        _service.fetchForecastWeather(city),
      ]);
      print(results);

      final current = results[0] as Weather;
      final forecast = results[1] as Map<String, dynamic>;

      if (!mounted) return;
      setState(() {
        _currentCity = city;
        _currentWeather = current;
        _hourlyForecast = forecast['hourly'] as List<HourlyWeather>;
        _dailyForecast = forecast['daily'] as List<NextDayWeather>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy thành phố: $city')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentWeather == null) {
      return const Scaffold(
        body: Center(
          child: Text('Không có dữ liệu. Hãy thử tìm kiếm thành phố.'),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(icon: _currentWeather!.icon),
          Container(color: Colors.black.withOpacity(0.3)),
          SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
                const Spacer(),
                DailyWeatherList(dailyForecast: _dailyForecast),
                Expanded(
                  flex: 12,
                  child: CurrentWeather(weather: _currentWeather!),
                ),
                HourlyWeatherList(hourlyForecast: _hourlyForecast),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: WeatherInforCard(weather: _currentWeather!),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(child: SearchBarWidget(onSearch: _fetchData)),
        ],
      ),
    );
  }
}
