import 'package:flutter/material.dart';
import 'package:remote_config_sdk/remote_config_sdk.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notifier = ConfigNotifier(baseUrl: 'http://localhost:8000');
 runApp(MaterialApp(
    home: Scaffold(body: Center(child: CircularProgressIndicator())),
  ));

  await notifier.init();

  runApp(MyApp(notifier: notifier));
}

class MyApp extends StatelessWidget {
  final ConfigNotifier notifier;
  const MyApp({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ConfigBuilder(
      notifier: notifier,
      builder: (context, config) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: config.getBool('ui', 'dark_mode')
            ? ThemeData.dark()
            : ThemeData.light(),
        home: HomeScreen(notifier: notifier),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final ConfigNotifier notifier;
  const HomeScreen({super.key, required this.notifier});

  @override
  Widget build(BuildContext context) {
    return ConfigBuilder(
      notifier: notifier,
      builder: (context, config) {
        final darkMode = config.getBool('ui', 'dark_mode');
        final bannerText = config.getString('ui', 'banner_text', fallback: 'Hello from Snivy!');
        final buttonColor = config.getString('ui', 'button_color', fallback: '#6200EE');
        final showBanner = config.getBool('ui', 'show_banner', fallback: true);

        return Scaffold(
          appBar: AppBar(title: const Text('Snivy Test App')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Connection status
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, color: Colors.green, size: 10),
                      SizedBox(width: 6),
                      Text('Connected to Snivy'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Flag: dark_mode
                _FlagTile(
                  label: 'dark_mode',
                  value: darkMode.toString(),
                  description: 'Controls app theme',
                ),
                const SizedBox(height: 16),

                // Flag: show_banner
                _FlagTile(
                  label: 'show_banner',
                  value: showBanner.toString(),
                  description: 'Shows/hides the banner below',
                ),
                const SizedBox(height: 16),

                // Flag: banner_text
                _FlagTile(
                  label: 'banner_text',
                  value: bannerText,
                  description: 'Banner message content',
                ),
                const SizedBox(height: 32),

                // Live banner — reacts to flags
                if (showBanner)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _hexToColor(buttonColor).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _hexToColor(buttonColor)),
                    ),
                    child: Text(
                      bannerText,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: _hexToColor(buttonColor),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _hexToColor(String hex) {
    final h = hex.replaceAll('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}

class _FlagTile extends StatelessWidget {
  final String label;
  final String value;
  final String description;

  const _FlagTile({
    required this.label,
    required this.value,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'monospace')),
              Text(description, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
          Chip(
            label: Text(value, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
            backgroundColor: Colors.blue.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}