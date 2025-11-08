import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';

enum AuthMode {
  external,
  standalone,
}

class AuthConfig {
  final List<String> enabledProviders;
  final AuthMode authenticationMode;

  const AuthConfig({
    required this.enabledProviders,
    required this.authenticationMode,
  });

  factory AuthConfig.fromJson(Map<String, dynamic> json) {
    return AuthConfig(
      enabledProviders: List<String>.from(json['enabledProviders'] ?? []),
      authenticationMode: _parseAuthMode(json['authenticationMode']),
    );
  }

  static AuthMode _parseAuthMode(dynamic mode) {
    if (mode == 'standalone') {
      return AuthMode.standalone;
    }
    return AuthMode.external;
  }

  Map<String, dynamic> toJson() {
    return {
      'enabledProviders': enabledProviders,
      'authenticationMode': authenticationMode == AuthMode.standalone ? 'standalone' : 'external',
    };
  }

  bool get hasOAuthProviders => enabledProviders.isNotEmpty;
  bool get isStandaloneMode => authenticationMode == AuthMode.standalone;
  bool get hasLocalLogin => authenticationMode == AuthMode.standalone;
}

class AuthConfigService {
  final String _baseUrl;

  AuthConfigService({String? baseUrl}) : _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Fetch authentication configuration from the backend
  Future<AuthConfig> getAuthConfig({int maxRetries = 3, Duration retryDelay = const Duration(seconds: 2)}) async {
    int attempts = 0;
    Exception? lastError;

    while (attempts < maxRetries) {
      attempts++;
      try {
        debugPrint('[AUTH_CONFIG] Attempt $attempts/$maxRetries to fetch config from $_baseUrl/api/auth/config');
        
        final response = await http.get(
          Uri.parse('$_baseUrl/api/auth/config'),
          headers: {
            'accept': '*/*',
          },
        ).timeout(const Duration(seconds: 5));

        debugPrint('[AUTH_CONFIG] Response status: ${response.statusCode}');
        debugPrint('[AUTH_CONFIG] Response body: ${response.body}');

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final config = AuthConfig.fromJson(data);
          debugPrint('[AUTH_CONFIG] ✅ Config loaded: mode=${config.authenticationMode}, providers=${config.enabledProviders}');
          return config;
        } else {
          lastError = Exception('Failed to fetch auth config: ${response.statusCode}');
        }
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        debugPrint('[AUTH_CONFIG] ❌ Attempt $attempts failed: $e');
        
        if (attempts < maxRetries) {
          debugPrint('[AUTH_CONFIG] Retrying in ${retryDelay.inSeconds}s...');
          await Future.delayed(retryDelay);
        }
      }
    }

    debugPrint('[AUTH_CONFIG] ❌ All $maxRetries attempts failed');
    throw lastError ?? Exception('Failed to fetch auth config after $maxRetries attempts');
  }
}
