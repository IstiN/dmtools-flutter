import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
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
  Future<AuthConfig> getAuthConfig() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/auth/config'),
        headers: {
          'accept': '*/*',
        },
      );

      if (kDebugMode) {
        print('🔧 AuthConfigService.getAuthConfig() - Response:');
        print('   Status: ${response.statusCode}');
        print('   Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return AuthConfig.fromJson(data);
      } else {
        throw Exception('Failed to fetch auth config: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ AuthConfigService.getAuthConfig() failed: $e');
      }
      rethrow;
    }
  }
}
