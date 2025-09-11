import 'package:flutter/foundation.dart' show kIsWeb;
import 'runtime_config.dart';

enum Environment {
  development('development'),
  production('production');

  final String value;

  const Environment(this.value);
}

class AppConfig {
  // Compile-time fallbacks for non-web platforms
  static const String _environment = String.fromEnvironment('environment', defaultValue: 'development');
  static const String _baseUrl = String.fromEnvironment('baseUrl', defaultValue: 'http://localhost:8080');
  static const String _appName = String.fromEnvironment('appName', defaultValue: 'DMTools');
  static const String _appVersion = String.fromEnvironment('appVersion', defaultValue: '1.0.0');
  static const String _enableLogging = String.fromEnvironment('enableLogging', defaultValue: 'true');
  static const String _enableMockData = String.fromEnvironment('enableMockData', defaultValue: 'false');
  static const String _timeoutDuration = String.fromEnvironment('timeoutDuration', defaultValue: '30');

  static Environment get environment {
    final envString = kIsWeb ? RuntimeConfig.getEnvironment() : _environment;
    return Environment.values.firstWhere(
      (v) => v.value == envString,
      orElse: () => Environment.development,
    );
  }

  static String get baseUrl {
    return kIsWeb ? RuntimeConfig.getApiBaseUrl() : _baseUrl;
  }

  static String get appName {
    return kIsWeb ? RuntimeConfig.getAppName() : _appName;
  }

  static String get appVersion {
    return kIsWeb ? RuntimeConfig.getAppVersion() : _appVersion;
  }

  static bool get enableLogging {
    return kIsWeb ? RuntimeConfig.isLoggingEnabled() : _enableLogging.toLowerCase() == 'true';
  }

  static bool get enableMockData {
    return kIsWeb ? RuntimeConfig.isMockDataEnabled() : _enableMockData.toLowerCase() == 'true';
  }

  static int get timeoutDuration {
    return kIsWeb ? RuntimeConfig.getTimeoutDuration() : (int.tryParse(_timeoutDuration) ?? 30);
  }
}
