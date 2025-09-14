import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/user.dart';

class LocalAuthResponse {
  final String token;
  final UserDto user;

  const LocalAuthResponse({
    required this.token,
    required this.user,
  });

  factory LocalAuthResponse.fromJson(Map<String, dynamic> json) {
    return LocalAuthResponse(
      token: json['token'] as String,
      user: UserDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
    };
  }
}

class LocalAuthService {
  final String _baseUrl;

  LocalAuthService({String? baseUrl}) : _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Authenticate user with username and password
  Future<LocalAuthResponse> login(String username, String password) async {
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
        print('🔐 LocalAuthService.login() - Response:');
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
        print('❌ LocalAuthService.login() failed: $e');
      }
      rethrow;
    }
  }
}
