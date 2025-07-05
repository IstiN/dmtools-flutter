import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dmtools/core/services/oauth_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Manual mock classes
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockHttpClient extends Mock implements http.Client {}

void main() {
  group('OAuthService', () {
    late OAuthService oauthService;
    late MockFlutterSecureStorage mockSecureStorage;

    setUp(() {
      mockSecureStorage = MockFlutterSecureStorage();
      oauthService = OAuthService(secureStorage: mockSecureStorage);
    });

    group('getCurrentToken', () {
      test('should return valid token when stored', () async {
        // Arrange
        final tokenData = {
          'access_token': 'test_token',
          'token_type': 'Bearer',
          'expires_in': 3600,
          'refresh_token': 'test_refresh',
          'scope': 'read write',
          'created_at': DateTime.now().millisecondsSinceEpoch,
        };

        when(mockSecureStorage.read(key: 'oauth_token')).thenAnswer((_) async => jsonEncode(tokenData));

        // Act
        final result = await oauthService.getCurrentToken();

        // Assert
        expect(result, isNotNull);
        expect(result!.accessToken, equals('test_token'));
        expect(result.tokenType, equals('Bearer'));
        expect(result.scopes, equals(['read', 'write']));
        expect(result.isExpired, isFalse);
      });

      test('should return null when no token stored', () async {
        // Arrange
        when(mockSecureStorage.read(key: 'oauth_token')).thenAnswer((_) async => null);

        // Act
        final result = await oauthService.getCurrentToken();

        // Assert
        expect(result, isNull);
      });

      test('should handle expired token correctly', () async {
        // Arrange
        final expiredTokenData = {
          'access_token': 'expired_token',
          'token_type': 'Bearer',
          'expires_in': 3600,
          'created_at': DateTime.now().subtract(const Duration(hours: 2)).millisecondsSinceEpoch,
        };

        when(mockSecureStorage.read(key: 'oauth_token')).thenAnswer((_) async => jsonEncode(expiredTokenData));

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
        when(mockSecureStorage.delete(key: 'oauth_token')).thenAnswer((_) async {});

        // Act
        await oauthService.logout();

        // Assert
        verify(mockSecureStorage.delete(key: 'oauth_token')).called(1);
      });
    });

    group('getUserData', () {
      test('should return null when no token exists', () async {
        // Arrange
        when(mockSecureStorage.read(key: 'oauth_token')).thenAnswer((_) async => null);

        // Act
        final result = await oauthService.getUserData();

        // Assert
        expect(result, isNull);
      });

      test('should return null when user is not authenticated', () async {
        // Arrange
        final tokenData = {
          'access_token': 'test_token',
          'token_type': 'Bearer',
          'expires_in': 3600,
          'created_at': DateTime.now().millisecondsSinceEpoch,
        };

        when(mockSecureStorage.read(key: 'oauth_token')).thenAnswer((_) async => jsonEncode(tokenData));

        when(mockSecureStorage.delete(key: 'oauth_token')).thenAnswer((_) async {});

        // Act
        final result = await oauthService.getUserData();

        // Assert
        expect(result, isNull);
      });
    });

    group('handleCallback', () {
      test('should fail on invalid callback URI', () async {
        // Arrange
        final callbackUri = Uri.parse('https://app.com/callback?error=access_denied');

        // Act
        final result = await oauthService.handleCallback(callbackUri);

        // Assert
        expect(result, isFalse);
      });

      test('should fail when missing code parameter', () async {
        // Arrange
        final callbackUri = Uri.parse('https://app.com/callback?state=test_state');

        // Act
        final result = await oauthService.handleCallback(callbackUri);

        // Assert
        expect(result, isFalse);
      });

      test('should fail when missing state parameter', () async {
        // Arrange
        final callbackUri = Uri.parse('https://app.com/callback?code=test_code');

        // Act
        final result = await oauthService.handleCallback(callbackUri);

        // Assert
        expect(result, isFalse);
      });
    });
  });
}
