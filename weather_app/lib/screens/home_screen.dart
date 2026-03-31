import 'package:flutter/material.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/background_widget.dart';
import 'package:weather_app/widgets/current_weather.dart';
import 'package:weather_app/widgets/search_bar.dart';
import 'package:weather_app/widgets/weather_infor_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService service = WeatherService();

  List<Weather> weatherList = [];
  bool isLoading = true;

  int currentIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final cities = ["Hanoi", "Ho Chi Minh", "Da Nang"];

      final data = await service.fetchMultipleWeather(cities);

      if (!mounted) return;

      setState(() {
        weatherList = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addCity(String city) async {
    final newWeather = await service.fetchWeather(city);

    setState(() {
      weatherList.add(newWeather);
    });
  }

  // void _handleSearch(String query) {
  //   if (weatherList.isEmpty) return;

  //   final normalizedQuery = query.trim().toLowerCase();
  //   if (normalizedQuery.isEmpty) return;

  //   final foundIndex = weatherList.indexWhere(
  //     (item) => item.cityName.toLowerCase() == normalizedQuery,
  //   );

  //   if (foundIndex == -1) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(const SnackBar(content: Text('City not found')));
  //     return;
  //   }

  //   if (_pageController.hasClients) {
  //     _pageController.animateToPage(
  //       foundIndex,
  //       duration: const Duration(milliseconds: 350),
  //       curve: Curves.easeInOut,
  //     );
  //     return;
  //   }

  //   setState(() {
  //     currentIndex = foundIndex;
  //   });

  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     if (!mounted || !_pageController.hasClients) return;
  //     _pageController.jumpToPage(foundIndex);
  //   });
  // }
  Future<void> _handleSearch(String query) async {
    final city = query.trim();
    if (city.isEmpty) return;

    // 🔍 Kiểm tra đã tồn tại chưa
    final existingIndex = weatherList.indexWhere(
      (item) => item.cityName.toLowerCase() == city.toLowerCase(),
    );

    // ✅ Nếu đã có → chỉ chuyển page
    if (existingIndex != -1) {
      _pageController.animateToPage(
        existingIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      return;
    }

    // 🌐 Nếu chưa có → gọi API
    try {
      final newWeather = await service.fetchWeather(city);

      if (!mounted) return;

      setState(() {
        weatherList.add(newWeather);
      });

      // 👉 chuyển sang page mới
      final newIndex = weatherList.length - 1;

      _pageController.animateToPage(
        newIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      // ❌ City không tồn tại
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('City not found')));
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🔄 Loading
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // ❌ Không có data
    if (weatherList.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No weather data available')),
      );
    }

    final weather = weatherList[currentIndex];

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(icon: weather.icon),

          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: Column(
              children: [
                // 🔍 Search
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Icon(Icons.menu, color: Colors.white),
                      const SizedBox(width: 12),
                      Expanded(child: SearchBarWidget(onSearch: _handleSearch)),
                    ],
                  ),
                ),

                const Spacer(),

                // 🌍 PageView nhiều thành phố
                Expanded(
                  flex: 5,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    itemCount: weatherList.length,
                    itemBuilder: (context, index) {
                      final item = weatherList[index];
                      return CurrentWeather(weather: item);
                    },
                  ),
                ),

                // 📊 Info card
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: WeatherInforCard(weather: weather),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
