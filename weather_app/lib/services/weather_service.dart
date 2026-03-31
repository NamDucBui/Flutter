import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/models/hourly_weather.dart';
import 'package:weather_app/models/next_day_weather.dart';
import '../models/weather.dart';

class WeatherService {
  final String apiKey = dotenv.env['OWM_API_KEY'] ?? '';

  // 1. Lấy thời tiết hiện tại cho 1 city
  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception("Failed to load weather for $city");
    }
  }

  // 2. Gọi nhiều city song song
  Future<List<Weather>> fetchMultipleWeather(List<String> cities) async {
    return await Future.wait(cities.map((city) => fetchWeather(city)));
  }

  // 3. Hàm chính: lấy hourly + daily từ /forecast (free tier)
  //
  // /forecast trả về 40 mốc thời gian, mỗi mốc cách nhau 3 giờ (5 ngày).
  // Không có daily sẵn → tự group các mốc cùng ngày để tính min/max temp.
  Future<Map<String, dynamic>> fetchForecastWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast"
      "?q=$city&appid=$apiKey&units=metric&lang=vi",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> rawList = data['list'] as List;

      // --- Hourly: lấy 24 mốc đầu (= 72 giờ tới, mỗi mốc 3h) ---
      final List<HourlyWeather> hourlyList = rawList
          .take(24)
          .map((item) => HourlyWeather.fromJson(item as Map<String, dynamic>))
          .toList();

      // --- Daily: group theo ngày, tính min/max, lấy icon của 12:00 ---
      final List<NextDayWeather> dailyList = _groupByDay(rawList);

      return {'hourly': hourlyList, 'daily': dailyList};
    } else {
      throw Exception(
        "Không thể tải dữ liệu forecast cho $city. Mã lỗi: ${response.statusCode}",
      );
    }
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
