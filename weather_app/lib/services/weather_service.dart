import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/next_day_weather.dart';
import '../models/weather.dart';

// Timeout cho tất cả OWM API calls — tránh treo vô hạn khi mất mạng
const _kTimeout = Duration(seconds: 10);

class WeatherService {
  // API key được inject lúc build qua: --dart-define=OWM_API_KEY=xxx
  static const String _apiKey = String.fromEnvironment('OWM_API_KEY');

  Future<Weather> fetchWeatherByLocation(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather"
      "?lat=$lat&lon=$lon&appid=$_apiKey&units=metric",
    );
    final response = await http.get(url).timeout(_kTimeout);
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    }
    throw Exception("Failed to load weather by location (${response.statusCode})");
  }

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric",
    );
    final response = await http.get(url).timeout(_kTimeout);
    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    }
    throw Exception("Failed to load weather for $city (${response.statusCode})");
  }

  // H6: fetch forecast bằng tọa độ để tránh re-resolve city name → khác location
  Future<Map<String, dynamic>> fetchForecastWeatherByCoords(double lat, double lon) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast"
      "?lat=$lat&lon=$lon&appid=$_apiKey&units=metric&lang=en",
    );
    final response = await http.get(url).timeout(_kTimeout);
    if (response.statusCode == 200) {
      return _parseForecastResponse(response.body);
    }
    throw Exception("Failed to load forecast by coords (${response.statusCode})");
  }

  // Geocoding: trả về list "City, State, Country" để suggest khi user gõ
  Future<List<String>> fetchCitySuggestions(String query) async {
    if (query.trim().isEmpty) return [];
    final url = Uri.parse(
      "https://api.openweathermap.org/geo/1.0/direct"
      "?q=${Uri.encodeComponent(query)}&limit=5&appid=$_apiKey",
    );
    try {
      final response = await http.get(url).timeout(_kTimeout);
      if (response.statusCode != 200) return [];
      final List<dynamic> data = json.decode(response.body) as List;
      return data.map((e) {
        final m = e as Map<String, dynamic>;
        final parts = <String>[m['name'] as String];
        if (m['state'] != null) parts.add(m['state'] as String);
        parts.add(m['country'] as String);
        return parts.join(', ');
      }).toList();
    } catch (_) {
      return [];
    }
  }

  // Lấy hourly + daily từ /forecast (free tier) theo city name
  Future<Map<String, dynamic>> fetchForecastWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast"
      "?q=$city&appid=$_apiKey&units=metric&lang=en",
    );
    final response = await http.get(url).timeout(_kTimeout);
    if (response.statusCode == 200) {
      return _parseForecastResponse(response.body);
    }
    throw Exception(
      "Không thể tải forecast cho $city. Mã lỗi: ${response.statusCode}",
    );
  }

  // Parse forecast JSON thành hourly + daily maps (dùng chung cho cả 2 endpoints)
  //
  // /forecast trả về 40 mốc, mỗi mốc cách nhau 3 giờ (5 ngày).
  // Không có daily sẵn → group các mốc cùng ngày để tính min/max temp.
  Map<String, dynamic> _parseForecastResponse(String body) {
    final data = json.decode(body) as Map<String, dynamic>;
    final List<dynamic> rawList = data['list'] as List;

    // Hourly: lấy 24 mốc đầu (= 72 giờ tới, mỗi mốc 3h)
    final List<HourlyWeather> hourlyList = rawList
        .take(24)
        .map((item) => HourlyWeather.fromJson(item as Map<String, dynamic>))
        .toList();

    // Daily: group theo ngày, tính min/max
    final List<NextDayWeather> dailyList = _groupByDay(rawList);

    return {'hourly': hourlyList, 'daily': dailyList};
  }

  // Group 40 mốc (3h/mốc) thành các ngày, mỗi ngày lấy min/max temp
  // và weather icon từ mốc gần 12:00 nhất (đại diện cho cả ngày).
  List<NextDayWeather> _groupByDay(List<dynamic> rawList) {
    // Map<"yyyy-MM-dd", List<item>>
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (final item in rawList) {
      final map = item as Map<String, dynamic>;
      // dt_txt có dạng "2024-01-15 12:00:00"
      final String dateKey = (map['dt_txt'] as String).substring(0, 10);
      grouped.putIfAbsent(dateKey, () => []).add(map);
    }

    final List<NextDayWeather> result = [];

    for (final entry in grouped.entries) {
      final items = entry.value;

      // Tính min/max temp trong ngày
      final double tempMin = items
          .map((e) => (e['main']['temp_min'] as num).toDouble())
          .reduce((a, b) => a < b ? a : b);
      final double tempMax = items
          .map((e) => (e['main']['temp_max'] as num).toDouble())
          .reduce((a, b) => a > b ? a : b);

      // Ưu tiên mốc 12:00:00, nếu không có thì lấy mốc giữa danh sách
      final Map<String, dynamic> representative = items.firstWhere(
        (e) => (e['dt_txt'] as String).contains('12:00:00'),
        orElse: () => items[items.length ~/ 2],
      );

      // Inject min/max đã tính vào để fromJson có thể đọc
      final merged = Map<String, dynamic>.from(representative);
      merged['main'] = Map<String, dynamic>.from(representative['main'])
        ..['temp_min'] = tempMin
        ..['temp_max'] = tempMax;

      result.add(NextDayWeather.fromJson(merged));
    }

    // Bỏ ngày đầu tiên nếu đó là hôm nay (dữ liệu không đủ 1 ngày đầy)
    // và giữ tối đa 7 ngày
    return result.skip(1).take(7).toList();
  }
}
