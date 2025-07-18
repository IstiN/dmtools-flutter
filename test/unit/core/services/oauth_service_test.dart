import 'package:dmtools/core/services/oauth_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {
  static final Map<String, String> _storage = {};

  void clear() {
    _storage.clear();
  }

  @override
  Future<String?> read({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
  }) async {
    return _storage[key];
  }

  @override
  Future<void> write({
    required String key,
    required String? value,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
  }) async {
    if (value != null) {
      _storage[key] = value;
    } else {
      _storage.remove(key);
    }
  }

  @override
  Future<void> delete({
    required String key,
    IOSOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WindowsOptions? wOptions,
    WebOptions? webOptions,
    MacOsOptions? mOptions,
  }) async {
    _storage.remove(key);
  }
}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('OAuthService', () {
    late OAuthService oauthService;
    late MockFlutterSecureStorage mockSecureStorage;

    setUp(() {
      mockSecureStorage = MockFlutterSecureStorage();
      mockSecureStorage.clear();
      oauthService = OAuthService(
        secureStorage: mockSecureStorage,
      );
    });

    group('getCurrentToken', () {
      test('should return valid token when stored', () async {
        // Arrange
        final tokenData = {
          'accessToken': 'test_token',
          'tokenType': 'Bearer',
          'expiresIn': 3600,
          'refreshToken': 'test_refresh',
          'scopes': ['read', 'write'],
          'createdAt': DateTime.now().toIso8601String(),
        };
        await mockSecureStorage.write(key: 'oauth_token', value: jsonEncode(tokenData));

        // Act
        final result = await oauthService.getCurrentToken();

        // Assert
        expect(result, isNotNull);
        expect(result!.accessToken, equals('test_token'));
        expect(result.tokenType, equals('Bearer'));
        expect(result.scopes, equals({'read', 'write'}));
        expect(result.isExpired, isFalse);
      });

      test('should return null when no token stored', () async {
        // Act
        final result = await oauthService.getCurrentToken();

        // Assert
        expect(result, isNull);
      });

      test('should handle expired token correctly', () async {
        // Arrange
        final expiredTokenData = {
          'accessToken': 'expired_token',
          'tokenType': 'Bearer',
          'expiresIn': 3600,
          'refreshToken': null,
          'scopes': ['read'],
          'createdAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        };
        await mockSecureStorage.write(key: 'oauth_token', value: jsonEncode(expiredTokenData));

        // Act
        final result = await oauthService.getCurrentToken();

        // Assert
        expect(result, isNotNull);
        expect(result!.isExpired, isTrue);
      });
    });

    group('logout', () {
      test('should clear stored token', () async {
        // Arrange
        final tokenData = {
          'accessToken': 'test_token',
          'tokenType': 'Bearer',
          'expiresIn': 3600,
          'refreshToken': null,
          'scopes': ['read'],
          'createdAt': DateTime.now().toIso8601String(),
        };
        await mockSecureStorage.write(key: 'oauth_token', value: jsonEncode(tokenData));

        // Act
        await oauthService.logout();

        // Assert
        final token = await mockSecureStorage.read(key: 'oauth_token');
        expect(token, isNull);
      });
    });

    group('getUserData', () {
      test('should return null when no token exists', () async {
        // Act
        final result = await oauthService.getUserData();

        // Assert
        expect(result, isNull);
      });
    });

    group('handleCallback', () {
      test('should fail on invalid callback URI', () async {
        final result = await oauthService.handleCallback(Uri.parse('https://app.com/callback?error=access_denied'));
        expect(result, isFalse);
      });

      test('should fail when missing code parameter', () async {
        final result = await oauthService.handleCallback(Uri.parse('https://app.com/callback?state=test_state'));
        expect(result, isFalse);
      });

      test('should fail when missing state parameter', () async {
        final result = await oauthService.handleCallback(Uri.parse('https://app.com/callback?code=test_code'));
        expect(result, isFalse);
      });
    });
  });
}
