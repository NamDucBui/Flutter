import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:weather_app/models/city_weather.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/next_day_weather.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/widgets/background_widget.dart';
import 'package:weather_app/widgets/city.dart';
import 'package:weather_app/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _service = WeatherService();
  final PageController _pageController = PageController();

  // Danh sách thành phố mặc định
  final List<String> _defaultCities = ['Thai Binh'];

  // Data theo từng thành phố
  List<CityWeatherData> _cityDataList = [];

  bool _isLoading = true;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _fetchAllCities();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fetch tất cả thành phố mặc định song song
  Future<void> _fetchAllCities() async {
    setState(() => _isLoading = true);

    try {
      final results = await Future.wait(
        _defaultCities.map((city) => _fetchCityData(city)),
      );

      if (!mounted) return;
      setState(() {
        _cityDataList = results.whereType<CityWeatherData>().toList();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  // Fetch data cho 1 thành phố, trả về null nếu lỗi
  Future<CityWeatherData?> _fetchCityData(String city) async {
    try {
      final results = await Future.wait([
        _service.fetchWeather(city),
        _service.fetchForecastWeather(city),
      ]);

      final current = results[0] as Weather;
      final forecast = results[1] as Map<String, dynamic>;

      return CityWeatherData(
        current: current,
        hourly: forecast['hourly'] as List<HourlyWeather>,
        daily: forecast['daily'] as List<NextDayWeather>,
      );
    } catch (e) {
      return null;
    }
  }

  // Tìm kiếm thêm thành phố mới → thêm vào cuối danh sách
  Future<void> _handleSearch(String query) async {
    final city = query.trim();
    if (city.isEmpty) return;

    // Kiểm tra đã có chưa
    final exists = _cityDataList.any(
      (d) => d.current.cityName.toLowerCase() == city.toLowerCase(),
    );
    if (exists) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$city đã có trong danh sách')));
      return;
    }

    final data = await _fetchCityData(city);

    if (data == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy thành phố: $city')),
      );
      return;
    }

    if (!mounted) return;
    setState(() => _cityDataList.add(data));

    // Trượt sang trang vừa thêm
    _pageController.animateToPage(
      _cityDataList.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_cityDataList.isEmpty) {
      return const Scaffold(body: Center(child: Text('Không có dữ liệu.')));
    }

    final currentData = _cityDataList[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          // Background đổi theo thành phố đang xem
          BackgroundWidget(icon: currentData.current.icon),
          Container(color: Colors.black.withOpacity(0.3)),

          SafeArea(
            child: Column(
              children: [
                // 🔍 Search bar
                _buildSearchBar(),
                const SizedBox(height: 8),

                // 🔵 Dot indicator
                _buildDotIndicator(),

                // 📄 PageView — swipe trái/phải (hỗ trợ cả chuột trên web)
                Expanded(
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      dragDevices: {
                        PointerDeviceKind.touch,
                        PointerDeviceKind.mouse,
                      },
                    ),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _cityDataList.length,
                      onPageChanged: (index) {
                        setState(() => _currentPage = index);
                      },
                      itemBuilder: (context, index) {
                        return CityPage(data: _cityDataList[index]);
                      },
                    ),
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
          Expanded(child: SearchBarWidget(onSearch: _handleSearch)),
        ],
      ),
    );
  }

  // Dot nhỏ ở trên cho biết đang ở trang nào, dot active sẽ dài hơn
  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_cityDataList.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(isActive ? 1 : 0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
