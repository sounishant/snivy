import 'dart:convert';
import 'package:http/http.dart' as http;
import 'cache_manager.dart';

class ConfigClient {
  final String baseUrl;
  Map<String, dynamic> _cache = {};
  bool _initialized = false;

  ConfigClient({required this.baseUrl});

  Future<void> init() async {
    _cache = await CacheManager.load();
    await fetchAll();
    _initialized = true;
  }

  Future<void> fetchAll() async {
    try {
     final res = await http.get(Uri.parse('$baseUrl/config'));
      if (res.statusCode == 200) {
        _cache = jsonDecode(res.body);
        await CacheManager.save(_cache);
      }
    } catch (_) {}
  }

  dynamic get(String category, String key) {
    assert(_initialized, 'ConfigClient not initialized. Call init() first.');
    return _cache[category]?[key];
  }

  bool getBool(String category, String key, {bool fallback = false}) =>
      get(category, key) as bool? ?? fallback;

  String getString(String category, String key, {String fallback = ''}) =>
      get(category, key) as String? ?? fallback;

  int getInt(String category, String key, {int fallback = 0}) =>
      get(category, key) as int? ?? fallback;

  void updateFromSSE(Map<String, dynamic> data) {
    _cache = data;
    CacheManager.save(_cache);
  }
}