# remote_config_sdk

Minimal Flutter package scaffold for remote configuration with HTTP fetch, local cache via `shared_preferences`, and SSE updates via `eventsource`.

Usage

1. Add this package to your project (if published) or add as a local package.
2. Import and instantiate:

```dart
import 'package:remote_config_sdk/remote_config_sdk.dart';

final sdk = RemoteConfigSdk('https://api.example.com');
final config = await sdk.fetchConfig();
```

Run `flutter pub get` to fetch dependencies.
