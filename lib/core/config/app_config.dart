enum Environment {
  development('development'),
  production('production');

  final String value;

  const Environment(this.value);
}

class AppConfig {
  static const String _environment = String.fromEnvironment('environment');
  static const String _baseUrl = String.fromEnvironment('baseUrl');
  static const String _appName = String.fromEnvironment('appName');
  static const String _appVersion = String.fromEnvironment('appVersion');
  static const String _enableLogging = String.fromEnvironment('enableLogging');
  static const String _enableMockData = String.fromEnvironment('enableMockData');
  static const String _timeoutDuration = String.fromEnvironment('timeoutDuration');

  static Environment get environment => Environment.values.firstWhere((v) => v.value == _environment);
  static String get baseUrl => _baseUrl;
  static String get appName => _appName;
  static String get appVersion => _appVersion;
  static bool get enableLogging => _enableLogging == true.toString();
  static bool get enableMockData => _enableMockData == true.toString();
  static int get timeoutDuration => int.parse(_timeoutDuration);
}
