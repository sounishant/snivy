import 'package:flutter/foundation.dart';
import 'config_client.dart';
import '../sse_listener.dart';

class ConfigNotifier extends ChangeNotifier {
  final ConfigClient _client;
  late final SSEListener _listener;

  ConfigNotifier({required String baseUrl})
      : _client = ConfigClient(baseUrl: baseUrl) {
    _listener = SSEListener(
      baseUrl: baseUrl,
      client: _client,
      onUpdate: (_) => notifyListeners(),
    );
  }

  Future<void> init() async {
    await _client.init();
    _listener.listen();
  }

  bool getBool(String category, String key, {bool fallback = false}) =>
      _client.getBool(category, key, fallback: fallback);

  String getString(String category, String key, {String fallback = ''}) =>
      _client.getString(category, key, fallback: fallback);

  int getInt(String category, String key, {int fallback = 0}) =>
      _client.getInt(category, key, fallback: fallback);
}