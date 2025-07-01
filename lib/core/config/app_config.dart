import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

enum Environment {
  development,
  production,
}

class AppConfig {
  final Environment environment;
  final String baseUrl;
  final String appName;
  final String appVersion;
  final bool enableLogging;
  final bool enableMockData;
  final int timeoutDuration;

  const AppConfig({
    required this.environment,
    required this.baseUrl,
    required this.appName,
    required this.appVersion,
    required this.enableLogging,
    required this.enableMockData,
    required this.timeoutDuration,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) {
    return AppConfig(
      environment: Environment.values.firstWhere(
        (e) => e.name == json['environment'],
        orElse: () => Environment.development,
      ),
      baseUrl: json['baseUrl'] as String,
      appName: json['appName'] as String,
      appVersion: json['appVersion'] as String,
      enableLogging: json['enableLogging'] as bool,
      enableMockData: json['enableMockData'] as bool,
      timeoutDuration: json['timeoutDuration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'environment': environment.name,
      'baseUrl': baseUrl,
      'appName': appName,
      'appVersion': appVersion,
      'enableLogging': enableLogging,
      'enableMockData': enableMockData,
      'timeoutDuration': timeoutDuration,
    };
  }

  // Default configurations
  static const AppConfig development = AppConfig(
    environment: Environment.development,
    baseUrl: 'http://localhost:8080',
    appName: 'DMTools',
    appVersion: '1.0.0',
    enableLogging: true,
    enableMockData: true,
    timeoutDuration: 30,
  );

  static const AppConfig production = AppConfig(
    environment: Environment.production,
    baseUrl: 'https://dmtools-431977789017.us-central1.run.app',
    appName: 'DMTools',
    appVersion: '1.0.0',
    enableLogging: false,
    enableMockData: false,
    timeoutDuration: 30,
  );

  @override
  String toString() {
    return 'AppConfig(environment: $environment, baseUrl: $baseUrl, enableMockData: $enableMockData)';
  }
}

class AppConfigManager {
  static AppConfig? _instance;
  static AppConfig get instance => _instance ?? AppConfig.development;

  /// Initialize app configuration
  /// Loads configuration from JSON file based on environment
  static Future<void> initialize({Environment? environment}) async {
    try {
      // Determine environment
      final env = environment ?? _determineEnvironment();

      // Try to load from JSON file first
      final configPath = _getConfigPath(env);
      AppConfig? config;

      try {
        final configString = await rootBundle.loadString(configPath);
        final configJson = json.decode(configString) as Map<String, dynamic>;
        config = AppConfig.fromJson(configJson);

        if (kDebugMode) {
          print('✅ Loaded configuration from $configPath');
          print('🔗 Base URL: ${config.baseUrl}');
          print('🔧 Environment: ${config.environment.name}');
        }
      } catch (e) {
        if (kDebugMode) {
          print('⚠️ Could not load config from $configPath: $e');
          print('🔄 Falling back to default configuration');
        }
        // Fallback to default configuration
        config = env == Environment.production ? AppConfig.production : AppConfig.development;
      }

      _instance = config;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to initialize app config: $e');
      }
      _instance = AppConfig.development;
    }
  }

  /// Get configuration file path based on environment
  static String _getConfigPath(Environment environment) {
    switch (environment) {
      case Environment.development:
        return 'assets/config/app_config_dev.json';
      case Environment.production:
        return 'assets/config/app_config_prod.json';
    }
  }

  /// Determine environment based on various factors
  static Environment _determineEnvironment() {
    // For web, we can't access Platform.environment
    // So we rely on build mode and const String.fromEnvironment
    const envVar = String.fromEnvironment('FLUTTER_ENV');
    if (envVar.isNotEmpty) {
      switch (envVar.toLowerCase()) {
        case 'production':
        case 'prod':
          return Environment.production;
        case 'development':
        case 'dev':
        default:
          return Environment.development;
      }
    }

    // Check for build mode
    if (kReleaseMode) {
      return Environment.production;
    }

    // Default to development
    return Environment.development;
  }

  /// Update configuration at runtime (for testing purposes)
  static void updateConfig(AppConfig config) {
    _instance = config;
  }

  /// Reset to default configuration
  static void reset() {
    _instance = null;
  }
}
