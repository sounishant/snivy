import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'config_client.dart';

class SSEListener {
  final String baseUrl;
  final ConfigClient client;
  final void Function(Map<String, dynamic>)? onUpdate;

  SSEListener({required this.baseUrl, required this.client, this.onUpdate});

  Future<void> listen() async {
    while (true) {
      try {
        final request = http.Request('GET', Uri.parse('$baseUrl/stream'));
        final response = await http.Client().send(request);

        response.stream
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen((line) {
          if (line.startsWith('data: ')) {
            final data = jsonDecode(line.substring(6));
            client.updateFromSSE(data);
            onUpdate?.call(data);
          }
        });

        break; // connected — exit retry loop
      } catch (_) {
        await Future.delayed(const Duration(seconds: 3)); // retry
      }
    }
  }
}