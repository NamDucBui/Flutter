import 'package:shared_preferences/shared_preferences.dart';

/// Lưu/đọc danh sách city names người dùng đã thêm vào app.
/// Dữ liệu persist qua shared_preferences, không bị mất khi restart.
class CityStorageService {
  static const String _key = 'saved_cities';

  /// Đọc danh sách city names đã lưu. Trả về [] nếu chưa có gì.
  static Future<List<String>> loadCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  /// Ghi đè toàn bộ danh sách city names.
  static Future<void> saveCities(List<String> cities) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, cities);
  }
}
