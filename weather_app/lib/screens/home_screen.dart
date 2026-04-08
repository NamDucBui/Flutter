import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:weather_app/controllers/weather_controller.dart';
import 'package:weather_app/widgets/background_widget.dart';
import 'package:weather_app/widgets/city_page.dart';
import 'package:weather_app/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherController _controller = WeatherController();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate);
    _controller.init().catchError((_) {
      // Location fail → hỏi user nhập city
      if (mounted) _promptUserForCity();
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    // C3: bounds-check _currentPage trước khi render
    final maxPage = _controller.cities.length - 1;
    if (_currentPage > maxPage && maxPage >= 0) {
      _currentPage = maxPage;
    }
    setState(() {});
  }

  // H4: dispose TextEditingController để tránh memory leak
  Future<void> _promptUserForCity() async {
    final textController = TextEditingController();
    try {
      final city = await showDialog<String>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          title: const Text('Location unavailable'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Enter city name...'),
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (v) => Navigator.pop(ctx, v.trim()),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, textController.text.trim()),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (city == null || city.isEmpty) return;
      final ok = await _controller.addFirstCity(city);
      if (!ok && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('City not found: $city')),
        );
      }
    } finally {
      textController.dispose();
    }
  }

  Future<void> _handleSearch(String query) async {
    final city = query.trim();
    if (city.isEmpty) return;

    if (_controller.cityExists(city)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$city is already in the list')),
      );
      return;
    }

    final ok = await _controller.addCity(city);
    if (!mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không tìm thấy thành phố: $city')),
      );
      return;
    }

    // Trượt sang trang vừa thêm
    _pageController.animateToPage(
      _controller.cities.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_controller.errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.cloud_off, size: 64, color: Colors.white54),
                const SizedBox(height: 16),
                Text(
                  _controller.errorMessage!,
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => _controller.init().catchError((_) {
                    if (mounted) _promptUserForCity();
                  }),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_controller.cities.isEmpty) {
      return const Scaffold(body: Center(child: Text('No data available.')));
    }

    final currentData = _controller.cities[_currentPage];

    return Scaffold(
      body: Stack(
        children: [
          BackgroundWidget(icon: currentData.current.icon),
          Container(color: Colors.black.withValues(alpha: 0.3)),
          SafeArea(
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 8),
                _buildDotIndicator(),

                // PageView — swipe trái/phải (hỗ trợ cả chuột trên web)
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
                      itemCount: _controller.cities.length,
                      onPageChanged: (index) =>
                          setState(() => _currentPage = index),
                      itemBuilder: (context, index) {
                        return RefreshIndicator(
                          onRefresh: () => _controller.refreshCity(index),
                          child: CityPage(data: _controller.cities[index]),
                        );
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
          Expanded(
            child: SearchBarWidget(
              onSearch: _handleSearch,
              suggestionsFetcher: _controller.fetchCitySuggestions,
            ),
          ),
        ],
      ),
    );
  }

  // Dot indicator — dot active dài hơn
  Widget _buildDotIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_controller.cities.length, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.4),
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
