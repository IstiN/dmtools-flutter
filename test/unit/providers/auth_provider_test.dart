import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools/providers/auth_provider.dart';
import 'package:dmtools/core/services/oauth_service.dart';
import 'package:dmtools/core/models/user.dart';
import 'dart:convert';

void main() {
  group('AuthProvider', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider(oauthService: MockOAuthService());
    });

    group('Initialization', () {
      test('should initialize with correct default state', () {
        expect(authProvider.authState, AuthState.initial);
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.isLoading, false);
        expect(authProvider.hasError, false);
        expect(authProvider.error, null);
        expect(authProvider.currentUser, null);
        expect(authProvider.currentToken, null);
        expect(authProvider.isDemoMode, false);
      });
    });

    group('User Info Management', () {
      test('should set user info externally', () {
        // Arrange
        const newUser = UserDto(
          id: 'api_user_456',
          name: 'Jane Smith',
          email: 'jane.smith@example.com',
          picture: 'https://avatar.com/jane.jpg',
        );

        // Act
        authProvider.setUserInfo(newUser);

        // Assert
        expect(authProvider.currentUser, newUser);
        expect(authProvider.isDemoMode, false);
      });

      test('should force reset demo mode when setting user info', () async {
        // Arrange
        await authProvider.enableDemoMode();
        expect(authProvider.isDemoMode, true);

        const realUser = UserDto(
          id: 'real_user',
          name: 'Real User',
          email: 'real@example.com',
        );

        // Act
        authProvider.setUserInfo(realUser);

        // Assert
        expect(authProvider.isDemoMode, false);
        expect(authProvider.currentUser, realUser);
      });
    });

    group('Demo Mode', () {
      test('should enable demo mode', () async {
        // Act
        await authProvider.enableDemoMode();

        // Assert
        expect(authProvider.isDemoMode, true);
        expect(authProvider.authState, AuthState.authenticated);
        expect(authProvider.currentUser?.name, 'Demo User');
        expect(authProvider.currentUser?.email, 'demo@dmtools.com');
        expect(authProvider.shouldUseMockData, true);
      });

      test('should disable demo mode and logout', () async {
        // Arrange
        await authProvider.enableDemoMode();
        expect(authProvider.isDemoMode, true);

        // Act
        await authProvider.disableDemoMode();

        // Assert
        expect(authProvider.isDemoMode, false);
        expect(authProvider.authState, AuthState.unauthenticated);
        expect(authProvider.currentUser, null);
      });

      test('should force reset demo mode', () async {
        // Arrange
        await authProvider.enableDemoMode();
        expect(authProvider.isDemoMode, true);

        // Act
        authProvider.forceResetDemoMode();

        // Assert
        expect(authProvider.isDemoMode, false);
      });
    });

    group('Authorization Header', () {
      test('should return empty string when no token', () {
        // Act
        final header = authProvider.authorizationHeader;

        // Assert
        expect(header, '');
      });
    });

    group('Scopes', () {
      test('should return false when no token', () {
        // Act & Assert
        expect(authProvider.hasScope('read'), false);
      });
    });

    group('Token Expiration', () {
      test('should detect expired tokens', () {
        // Arrange
        final expiredToken = OAuthToken(
          accessToken: 'expired_token',
          tokenType: 'Bearer',
          expiresIn: 3600,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)), // Expired 2 hours ago
          scopes: {'read'},
        );

        // Act & Assert
        expect(expiredToken.isExpired, true);
      });

      test('should detect valid tokens', () {
        // Arrange
        final validToken = OAuthToken(
          accessToken: 'valid_token',
          tokenType: 'Bearer',
          expiresIn: 3600,
          createdAt: DateTime.now(),
          scopes: {'read'},
        );

        // Act & Assert
        expect(validToken.isExpired, false);
      });

      test('should handle token expiration buffer correctly', () {
        // Arrange - Token that expires in 2 minutes (less than 5-minute buffer)
        final almostExpiredToken = OAuthToken(
          accessToken: 'almost_expired_token',
          tokenType: 'Bearer',
          expiresIn: 3600,
          createdAt: DateTime.now().subtract(const Duration(minutes: 58)), // Expires in 2 minutes
          scopes: {'read'},
        );

        // Act & Assert
        expect(almostExpiredToken.isExpired, true); // Should be considered expired due to 5-minute buffer
      });
    });
  });

  group('JWT Helper Functions', () {
    test('should extract user info from valid JWT token', () {
      final validJWT = _createValidJWT();
      final userInfo = _extractUserInfoFromJWT(validJWT);

      expect(userInfo['sub'], 'user123');
      expect(userInfo['name'], 'John Doe');
      expect(userInfo['email'], 'john.doe@example.com');
      expect(userInfo['picture'], 'https://avatar.com/john.jpg');
    });

    test('should handle JWT with preferred_username when name is missing', () {
      final jwtWithPreferredUsername = _createJWTWithClaims({
        'sub': 'user123',
        'preferred_username': 'johndoe',
        'email': 'john.doe@example.com',
      });

      final userInfo = _extractUserInfoFromJWT(jwtWithPreferredUsername);

      expect(userInfo['sub'], 'user123');
      expect(userInfo['preferred_username'], 'johndoe');
      expect(userInfo['email'], 'john.doe@example.com');
    });

    test('should handle malformed JWT gracefully', () {
      const malformedJWT = 'invalid.jwt.token';
      final userInfo = _extractUserInfoFromJWT(malformedJWT);

      expect(userInfo, isEmpty);
    });

    test('should normalize base64 strings correctly', () {
      // Test different padding scenarios
      expect(_normalizeBase64('test'), 'test'); // 4 chars, no padding needed
      expect(_normalizeBase64('test1'), 'test1==='); // 5 chars, need 3 padding
      expect(_normalizeBase64('test12'), 'test12=='); // 6 chars, need 2 padding
      expect(_normalizeBase64('test123'), 'test123='); // 7 chars, need 1 padding
      expect(_normalizeBase64('test1234'), 'test1234'); // 8 chars, no padding needed
    });
  });
}

// Simple mock OAuthService that doesn't do anything
class MockOAuthService extends OAuthService {
  @override
  Future<OAuthToken?> getCurrentToken() async => null;

  @override
  Future<bool> initiateLogin(OAuthProvider provider) async => true;

  @override
  Future<bool> handleCallback(Uri callbackUri) async => true;

  @override
  Future<void> logout() async {}

  @override
  Future<bool> isAuthenticated() async => false;
}

// Helper functions to test JWT parsing logic independently

/// Extract user information from JWT token payload
Map<String, dynamic> _extractUserInfoFromJWT(String token) {
  try {
    // JWT tokens have 3 parts separated by dots: header.payload.signature
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token format');
    }

    // Decode the payload (second part)
    final payload = parts[1];

    // Add padding if needed for base64 decoding
    final normalizedPayload = _normalizeBase64(payload);

    // Decode base64
    final decoded = utf8.decode(base64.decode(normalizedPayload));

    // Parse JSON
    final Map<String, dynamic> claims = jsonDecode(decoded);

    return claims;
  } catch (e) {
    return {};
  }
}

/// Normalize base64 string by adding padding if needed
String _normalizeBase64(String base64) {
  // Base64 strings should be multiples of 4 characters
  final remainder = base64.length % 4;
  if (remainder != 0) {
    final padding = 4 - remainder;
    return base64 + '=' * padding;
  }
  return base64;
}

// Helper methods for creating test JWT tokens

String _createValidJWT() {
  return _createJWTWithClaims({
    'sub': 'user123',
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'picture': 'https://avatar.com/john.jpg',
    'exp': (DateTime.now().millisecondsSinceEpoch / 1000 + 3600).round(),
  });
}

String _createJWTWithClaims(Map<String, dynamic> claims) {
  final header = {'alg': 'HS256', 'typ': 'JWT'};
  final headerEncoded = base64Url.encode(utf8.encode(jsonEncode(header)));
  final payloadEncoded = base64Url.encode(utf8.encode(jsonEncode(claims)));
  const signature = 'fake_signature';

  return '$headerEncoded.$payloadEncoded.$signature';
}
