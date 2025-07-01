/// A class to hold application-level configuration.
class AppConfig {
  /// The base URL for the backend server.
  ///
  /// This value can be overridden at compile time by passing the
  /// `--dart-define` flag. For example:
  /// flutter run --dart-define=BACKEND_BASE_URL=https://api.example.com
  static const String backendBaseUrl = String.fromEnvironment(
    'BACKEND_BASE_URL',
    defaultValue: 'https://dmtools-431977789017.us-central1.run.app',
  );
}
