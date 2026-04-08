import 'package:flutter/material.dart';
import 'package:weather_app/models/city_weather.dart';
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/next_day_weather.dart';
import 'package:weather_app/models/weather.dart';
import 'package:weather_app/services/city_storage_service.dart';
import 'package:weather_app/services/location_service.dart';
import 'package:weather_app/services/weather_service.dart';

/// Quản lý toàn bộ state và business logic của màn hình thời tiết.
/// HomeScreen chỉ cần listen và render UI.
class WeatherController extends ChangeNotifier {
  final WeatherService _service = WeatherService();

  // L5: private mutable list, expose read-only qua getter để tránh bypass persistence
  final List<CityWeatherData> _cities = [];
  List<CityWeatherData> get cities => List.unmodifiable(_cities);

  bool isLoading = true;
  String? errorMessage;

  // H3: guard để tránh notifyListeners() sau khi đã dispose
  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  /// Khởi động: lấy vị trí hiện tại, sau đó load cities đã lưu
  Future<void> init() async {
    await loadLocationWeather();
    await _loadSavedCities();
  }

  Future<void> loadLocationWeather() async {
    isLoading = true;
    errorMessage = null;
    _notify();

    try {
      final position = await LocationService.getCurrentLocation();
      final current = await _service.fetchWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      // H6: fetch forecast bằng tọa độ để tránh resolve sai city
      final forecast = await _service.fetchForecastWeatherByCoords(
        position.latitude,
        position.longitude,
      );

      _cities
        ..clear()
        ..add(CityWeatherData(
          current: current,
          hourly: forecast['hourly'],
          daily: forecast['daily'],
        ));
      isLoading = false;
      _notify();
    } catch (e) {
      debugPrint('WeatherController location error: $e');
      isLoading = false;
      _notify();
      rethrow;
    }
  }

  /// H2: Fetch các city đã lưu song song thay vì sequential
  Future<void> _loadSavedCities() async {
    final saved = await CityStorageService.loadCities();
    if (saved.isEmpty) return;

    final existing = _cities.map((d) => d.current.cityName.toLowerCase()).toSet();
    final toFetch = saved.where((c) => !existing.contains(c.toLowerCase())).toList();
    if (toFetch.isEmpty) return;

    // Fetch tất cả song song
    final results = await Future.wait(toFetch.map(_fetchCityData));

    for (final data in results) {
      if (data != null) _cities.add(data);
    }
    if (results.any((d) => d != null)) _notify();
  }

  /// Thêm city từ search — trả về false nếu không tìm thấy
  Future<bool> addCity(String cityName) async {
    final data = await _fetchCityData(cityName);
    if (data == null) return false;

    _cities.add(data);
    _notify();
    await _persistCities();
    return true;
  }

  /// Thêm city đầu tiên khi location fail (từ dialog)
  Future<bool> addFirstCity(String cityName) async {
    final data = await _fetchCityData(cityName);
    if (data == null) return false;

    _cities
      ..clear()
      ..add(data);
    errorMessage = null;
    _notify();
    await _persistCities();
    return true;
  }

  /// Refresh city tại index chỉ định
  Future<void> refreshCity(int index) async {
    if (index >= _cities.length) return;
    final cityName = _cities[index].current.cityName;
    final updated = await _fetchCityData(cityName);
    if (updated == null) return;

    _cities[index] = updated;
    _notify();
  }

  bool cityExists(String cityName) {
    return _cities.any((d) => d.current.cityName.toLowerCase() == cityName.toLowerCase());
  }

  Future<List<String>> fetchCitySuggestions(String query) =>
      _service.fetchCitySuggestions(query);

  /// Fetch weather + forecast cho 1 city, trả về null nếu lỗi
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

  Future<void> _persistCities() async {
    await CityStorageService.saveCities(
      _cities.map((d) => d.current.cityName).toList(),
    );
  }
}
