import 'dart:async';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;

class LocationService {
  static Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw Exception("Không có quyền vị trí");
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<String>> searchPlaces(String query) async {
    if (query.isEmpty) return [];

    final nominatimUrl =
        'https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=5';

    try {
      http.Response response;

      if (kIsWeb) {
        // allorigins.win là CORS proxy free, không có SLA — dùng timeout ngắn để không block UI
        final proxyUrl = Uri.parse(
          'https://api.allorigins.win/get?url=${Uri.encodeComponent(nominatimUrl)}',
        );
        final res = await http
            .get(proxyUrl)
            .timeout(const Duration(seconds: 5), onTimeout: () => http.Response('', 408));

        if (res.statusCode != 200 || res.body.isEmpty) {
          debugPrint('[LocationService] proxy unavailable (${res.statusCode})');
          return [];
        }

        final wrapper = json.decode(res.body);
        final List data = json.decode(wrapper['contents']);
        return data
            .map<String>((item) => item['display_name'] as String)
            .toList();
      } else {
        // Mobile/desktop: gọi thẳng
        response = await http.get(
          Uri.parse(nominatimUrl),
          headers: {'User-Agent': 'WeatherApp/1.0'},
        );

        if (response.statusCode != 200) {
          debugPrint('[LocationService] error: ${response.statusCode}');
          return [];
        }

        final List data = json.decode(response.body);
        return data
            .map<String>((item) => item['display_name'] as String)
            .toList();
      }
    } catch (e) {
      debugPrint('[LocationService] searchPlaces exception: $e');
      return [];
    }
  }
}
