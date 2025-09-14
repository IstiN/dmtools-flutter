import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../../core/config/app_config.dart';
import '../../core/models/user.dart';
import '../../core/services/auth_config_service.dart';
import '../../core/services/local_auth_service.dart';

class AuthApiService {
  final String _baseUrl;

  AuthApiService({String? baseUrl}) : _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Get authentication configuration
  Future<AuthConfig> getAuthConfig() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/auth/config'),
        headers: {
          'accept': '*/*',
        },
      );

      if (kDebugMode) {
        print('🔧 AuthApiService.getAuthConfig() - Response:');
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
        print('❌ AuthApiService.getAuthConfig() failed: $e');
      }
      rethrow;
    }
  }

  /// Login with username and password
  Future<LocalAuthResponse> loginWithCredentials(String username, String password) async {
    try {
      final requestBody = {
        'username': username,
        'password': password,
      };

      final response = await http.post(
        Uri.parse('$_baseUrl/api/auth/local-login'),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      if (kDebugMode) {
        print('🔐 AuthApiService.loginWithCredentials() - Response:');
        print('   Status: ${response.statusCode}');
        print('   Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return LocalAuthResponse.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else {
        throw Exception('Login failed: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ AuthApiService.loginWithCredentials() failed: $e');
      }
      rethrow;
    }
  }

  /// Get current user information
  Future<UserDto> getCurrentUser(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/auth/user'),
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (kDebugMode) {
        print('👤 AuthApiService.getCurrentUser() - Response:');
        print('   Status: ${response.statusCode}');
        print('   Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return UserDto.fromJson(data);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid or expired token');
      } else {
        throw Exception('Failed to get user: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ AuthApiService.getCurrentUser() failed: $e');
      }
      rethrow;
    }
  }
}
