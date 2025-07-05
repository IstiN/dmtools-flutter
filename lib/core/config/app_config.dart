enum Environment {
  development('development'),
  production('production');

  final String value;

  const Environment(this.value);
}

class AppConfig {
  static const String _environment = String.fromEnvironment('environment', defaultValue: 'development');
  static const String _baseUrl = String.fromEnvironment('baseUrl', defaultValue: 'http://localhost:8080');
  static const String _appName = String.fromEnvironment('appName', defaultValue: 'DMTools');
  static const String _appVersion = String.fromEnvironment('appVersion', defaultValue: '1.0.0');
  static const String _enableLogging = String.fromEnvironment('enableLogging', defaultValue: 'true');
  static const String _enableMockData = String.fromEnvironment('enableMockData', defaultValue: 'false');
  static const String _timeoutDuration = String.fromEnvironment('timeoutDuration', defaultValue: '30');

  static Environment get environment => Environment.values.firstWhere(
        (v) => v.value == _environment,
        orElse: () => Environment.development,
      );
  static String get baseUrl => _baseUrl;
  static String get appName => _appName;
  static String get appVersion => _appVersion;
  static bool get enableLogging => _enableLogging.toLowerCase() == 'true';
  static bool get enableMockData => _enableMockData.toLowerCase() == 'true';
  static int get timeoutDuration => int.tryParse(_timeoutDuration) ?? 30;
}
