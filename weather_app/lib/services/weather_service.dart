import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey = "9a1185626c5878c08b8be6786dec046a";

  // 🔥 1. Hàm gọi API cho 1 city
  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse(
      "https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric",
    );

    final response = await http.get(url);
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Weather.fromJson(data);
    } else {
      throw Exception("Failed to load weather for $city");
    }
  }

  // 🔥 2. Gọi nhiều city (song song)
  Future<List<Weather>> fetchMultipleWeather(List<String> cities) async {
    return await Future.wait(cities.map((city) => fetchWeather(city)));
  }
}
