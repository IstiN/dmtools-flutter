import 'dart:js' as js;
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;

/// Runtime configuration that can be set via JavaScript without rebuilding the app
class RuntimeConfig {
  static Map<String, dynamic>? _config;
  static bool _initialized = false;

  /// Initialize the runtime configuration by reading from JavaScript
  static void initialize() {
    if (_initialized) return;

    // Only attempt to read JavaScript config on web platform
    if (!kIsWeb) {
      _initialized = true;
      return;
    }

    try {
      // Try to read configuration from window.dmtoolsConfig
      final jsConfig = js.context['dmtoolsConfig'];
      if (jsConfig != null) {
        _config = {
          'apiBaseUrl': jsConfig['apiBaseUrl'],
          'environment': jsConfig['environment'],
          'enableLogging': jsConfig['enableLogging'],
          'enableMockData': jsConfig['enableMockData'],
          'timeoutDuration': jsConfig['timeoutDuration'],
          'appName': jsConfig['appName'],
          'appVersion': jsConfig['appVersion'],
        };

        if (_isLoggingEnabled()) {
          debugPrint('🔧 RuntimeConfig: Loaded configuration from JavaScript');
          debugPrint('   API Base URL: ${getApiBaseUrl()}');
          debugPrint('   Environment: ${getEnvironment()}');
          debugPrint('   Logging: ${isLoggingEnabled()}');
          debugPrint('   Mock Data: ${isMockDataEnabled()}');
        }
      } else {
        if (_isLoggingEnabled()) {
          debugPrint('⚠️ RuntimeConfig: No JavaScript configuration found, using defaults');
        }
      }
    } catch (e) {
      if (_isLoggingEnabled()) {
        debugPrint('❌ RuntimeConfig: Error reading JavaScript configuration: $e');
      }
    }

    _initialized = true;
  }

  /// Get the API base URL with fallback to compile-time configuration
  static String getApiBaseUrl() {
    initialize();

    // Priority: JavaScript config > compile-time config > default
    final jsBaseUrl = _config?['apiBaseUrl'] as String?;
    if (jsBaseUrl != null && jsBaseUrl.isNotEmpty) {
      return jsBaseUrl;
    }

    // Fallback to compile-time configuration
    const compileTimeBaseUrl = String.fromEnvironment('baseUrl');
    if (compileTimeBaseUrl.isNotEmpty) {
      return compileTimeBaseUrl;
    }

    // Final fallback
    return 'http://localhost:8080';
  }

  /// Get the environment setting
  static String getEnvironment() {
    initialize();

    final jsEnvironment = _config?['environment'] as String?;
    if (jsEnvironment != null && jsEnvironment.isNotEmpty) {
      return jsEnvironment;
    }

    const compileTimeEnv = String.fromEnvironment('environment');
    if (compileTimeEnv.isNotEmpty) {
      return compileTimeEnv;
    }

    return 'development';
  }

  /// Check if logging is enabled
  static bool isLoggingEnabled() {
    initialize();

    final jsLogging = _config?['enableLogging'] as bool?;
    if (jsLogging != null) {
      return jsLogging;
    }

    const compileTimeLogging = String.fromEnvironment('enableLogging', defaultValue: 'true');
    return compileTimeLogging.toLowerCase() == 'true';
  }

  /// Check if mock data is enabled
  static bool isMockDataEnabled() {
    initialize();

    final jsMockData = _config?['enableMockData'] as bool?;
    if (jsMockData != null) {
      return jsMockData;
    }

    const compileTimeMockData = String.fromEnvironment('enableMockData', defaultValue: 'false');
    return compileTimeMockData.toLowerCase() == 'true';
  }

  /// Get timeout duration in seconds
  static int getTimeoutDuration() {
    initialize();

    final jsTimeout = _config?['timeoutDuration'] as int?;
    if (jsTimeout != null && jsTimeout > 0) {
      return jsTimeout;
    }

    const compileTimeTimeout = String.fromEnvironment('timeoutDuration', defaultValue: '30');
    return int.tryParse(compileTimeTimeout) ?? 30;
  }

  /// Get app name
  static String getAppName() {
    initialize();

    final jsAppName = _config?['appName'] as String?;
    if (jsAppName != null && jsAppName.isNotEmpty) {
      return jsAppName;
    }

    const compileTimeAppName = String.fromEnvironment('appName', defaultValue: 'DMTools');
    return compileTimeAppName;
  }

  /// Get app version
  static String getAppVersion() {
    initialize();

    final jsAppVersion = _config?['appVersion'] as String?;
    if (jsAppVersion != null && jsAppVersion.isNotEmpty) {
      return jsAppVersion;
    }

    const compileTimeAppVersion = String.fromEnvironment('appVersion', defaultValue: '1.0.0');
    return compileTimeAppVersion;
  }

  /// Reset configuration (useful for testing)
  static void reset() {
    _config = null;
    _initialized = false;
  }

  /// Get all configuration as a map (for debugging)
  static Map<String, dynamic> getAllConfig() {
    initialize();
    return {
      'apiBaseUrl': getApiBaseUrl(),
      'environment': getEnvironment(),
      'enableLogging': isLoggingEnabled(),
      'enableMockData': isMockDataEnabled(),
      'timeoutDuration': getTimeoutDuration(),
      'appName': getAppName(),
      'appVersion': getAppVersion(),
    };
  }

  // Helper to check logging without infinite recursion
  static bool _isLoggingEnabled() {
    final jsLogging = _config?['enableLogging'] as bool?;
    if (jsLogging != null) {
      return jsLogging;
    }
    return true; // Default to true for setup phase
  }
}
