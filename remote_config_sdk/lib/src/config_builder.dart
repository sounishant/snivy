import 'package:flutter/widgets.dart';
import 'config_notifier.dart';

class ConfigBuilder extends StatelessWidget {
  final ConfigNotifier notifier;
  final Widget Function(BuildContext context, ConfigNotifier config) builder;

  const ConfigBuilder({
    super.key,
    required this.notifier,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: notifier,
      builder: (context, _) => builder(context, notifier),
    );
  }
}