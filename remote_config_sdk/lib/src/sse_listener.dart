import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config_client.dart';

class SSEListener {
  final String baseUrl;
  final ConfigClient client;
  final void Function(Map<String, dynamic>)? onUpdate;
  bool _active = true;

  SSEListener({required this.baseUrl, required this.client, this.onUpdate});

  void dispose() => _active = false;

  Future<void> listen() async {
    int retrySeconds = 3;

    while (_active) {
      try {
        final request = http.Request('GET', Uri.parse('$baseUrl/stream'));
        final response = await http.Client().send(request);
        retrySeconds = 3; // reset backoff on success

        await for (final chunk in response.stream.transform(utf8.decoder).transform(const LineSplitter())) {
          if (!_active) return;
          if (chunk.startsWith('data: ')) {
            final data = jsonDecode(chunk.substring(6));
            client.updateFromSSE(data);
            onUpdate?.call(data);
          }
        }
      } catch (_) {
        // mid-session drop — exponential backoff
        await Future.delayed(Duration(seconds: retrySeconds));
        retrySeconds = (retrySeconds * 2).clamp(3, 60);
      }
    }
  }
}