library remote_config_sdk;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eventsource/eventsource.dart';

class RemoteConfigSdk {
  final String baseUrl;
  RemoteConfigSdk(this.baseUrl);

  Future<Map<String, dynamic>> fetchConfig() async {
    final resp = await http.get(Uri.parse('$baseUrl/config'));
    if (resp.statusCode != 200) throw Exception('Failed to fetch config');
    final data = json.decode(resp.body) as Map<String, dynamic>;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('remote_config', resp.body);
    return data;
  }

  Future<Map<String, dynamic>?> getCachedConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('remote_config');
    if (raw == null) return null;
    return json.decode(raw) as Map<String, dynamic>;
  }

  Stream<Map<String, dynamic>> subscribe(String sseEndpoint) async* {
    final es = await EventSource.connect(sseEndpoint);
    await for (final event in es.events) {
      if (event.data == null) continue;
      final parsed = json.decode(event.data!) as Map<String, dynamic>;
      yield parsed;
    }
  }
}
