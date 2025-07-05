import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools/providers/auth_provider.dart';
import 'package:dmtools/core/services/oauth_service.dart';
import 'package:dmtools/core/models/user.dart';

void main() {
  group('AuthProvider OAuth Flow', () {
    late AuthProvider authProvider;

    setUp(() {
      authProvider = AuthProvider(oauthService: MockOAuthService());
    });

    group('demo mode integration', () {
      test('should enable demo mode', () async {
        // Act
        await authProvider.enableDemoMode();

        // Assert
        expect(authProvider.authState, AuthState.authenticated);
        expect(authProvider.isAuthenticated, true);
        expect(authProvider.isDemoMode, true);
        expect(authProvider.currentUser?.name, 'Demo User');
        expect(authProvider.currentUser?.email, 'demo@dmtools.com');
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
        expect(authProvider.isAuthenticated, false);
        expect(authProvider.currentUser, null);
      });

      test('should force reset demo mode when setting user info', () async {
        // Arrange
        await authProvider.enableDemoMode();
        expect(authProvider.isDemoMode, true);

        const realUser = UserDto(
          id: 'real_user',
          name: 'Real User',
          email: 'real@example.com',
          authenticated: true,
        );

        // Act
        authProvider.setUserInfo(realUser);

        // Assert
        expect(authProvider.isDemoMode, false);
        expect(authProvider.currentUser, realUser);
      });
    });

    group('state management', () {
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

      test('should have correct authorization header format', () {
        // Test with no token
        expect(authProvider.authorizationHeader, '');

        // Test with demo mode (still empty since no real token)
        authProvider.enableDemoMode();
        expect(authProvider.authorizationHeader, '');
      });

      test('should check scopes correctly', () {
        // Test without token
        expect(authProvider.hasScope('read'), false);
        expect(authProvider.hasScope('write'), false);
      });
    });

    group('error handling', () {
      test('should handle invalid callback URIs', () async {
        // Arrange
        final errorUri = Uri.parse('https://app.com/callback?error=access_denied');

        // Act
        final result = await authProvider.handleCallback(errorUri);

        // Assert
        expect(result, false);
        expect(authProvider.authState, AuthState.error);
        expect(authProvider.hasError, true);
        expect(authProvider.error, isNotNull);
      });

      test('should handle missing code in callback', () async {
        // Arrange
        final invalidUri = Uri.parse('https://app.com/callback?state=test');

        // Act
        final result = await authProvider.handleCallback(invalidUri);

        // Assert
        expect(result, false);
        expect(authProvider.authState, AuthState.error);
        expect(authProvider.hasError, true);
      });

      test('should handle missing state in callback', () async {
        // Arrange
        final invalidUri = Uri.parse('https://app.com/callback?code=test');

        // Act
        final result = await authProvider.handleCallback(invalidUri);

        // Assert
        expect(result, false);
        expect(authProvider.authState, AuthState.error);
        expect(authProvider.hasError, true);
      });
    });

    group('user info management', () {
      test('should set user info and disable demo mode', () {
        // Arrange
        authProvider.enableDemoMode();
        expect(authProvider.isDemoMode, true);

        const newUser = UserDto(
          id: 'api_user_456',
          name: 'Jane Smith',
          email: 'jane.smith@example.com',
          authenticated: true,
          provider: 'github',
          pictureUrl: 'https://avatar.com/jane.jpg',
          givenName: 'Jane',
          familyName: 'Smith',
        );

        // Act
        authProvider.setUserInfo(newUser);

        // Assert
        expect(authProvider.currentUser, newUser);
        expect(authProvider.isDemoMode, false);
        expect(authProvider.currentUser?.provider, 'github');
        expect(authProvider.currentUser?.pictureUrl, 'https://avatar.com/jane.jpg');
        expect(authProvider.currentUser?.givenName, 'Jane');
        expect(authProvider.currentUser?.familyName, 'Smith');
      });

      test('should toggle demo mode', () {
        // Initial state
        expect(authProvider.isDemoMode, false);

        // Toggle on
        authProvider.toggleDemoMode();
        expect(authProvider.isDemoMode, true);

        // Toggle off
        authProvider.toggleDemoMode();
        expect(authProvider.isDemoMode, false);
      });

      test('should force reset demo mode', () {
        // Arrange
        authProvider.enableDemoMode();
        expect(authProvider.isDemoMode, true);

        // Act
        authProvider.forceResetDemoMode();

        // Assert
        expect(authProvider.isDemoMode, false);
      });
    });
  });
}

// Simple mock service for testing
class MockOAuthService extends OAuthService {
  @override
  Future<OAuthToken?> getCurrentToken() async => null;

  @override
  Future<Map<String, dynamic>?> initiateLogin(OAuthProvider provider) async {
    return {
      'auth_url': 'https://example.com/oauth',
      'state': 'test_state',
      'expires_in': 900,
    };
  }

  @override
  Future<bool> launchOAuthUrl(String authUrl) async => true;

  @override
  Future<bool> handleCallback(Uri callbackUri) async {
    final error = callbackUri.queryParameters['error'];
    final code = callbackUri.queryParameters['code'];
    final state = callbackUri.queryParameters['state'];

    if (error != null) return false;
    if (code == null) return false;
    if (state == null) return false;

    return true;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<UserDto?> getUserData() async => const UserDto(
        id: 'test_user',
        name: 'Test User',
        email: 'test@example.com',
        authenticated: true,
        provider: 'github',
      );
}
