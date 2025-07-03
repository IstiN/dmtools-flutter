import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../core/services/oauth_service.dart';
import '../core/models/user.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final OAuthService _oauthService;

  AuthState _authState = AuthState.initial;
  OAuthToken? _currentToken;
  UserDto? _currentUser;
  String? _error;
  bool _isDemoMode = false;

  AuthProvider({
    OAuthService? oauthService,
  }) : _oauthService = oauthService ?? OAuthService();

  // Getters
  AuthState get authState => _authState;
  bool get isAuthenticated => _authState == AuthState.authenticated;
  bool get isLoading => _authState == AuthState.loading;
  bool get hasError => _authState == AuthState.error;
  String? get error => _error;
  UserDto? get currentUser => _currentUser;
  OAuthToken? get currentToken => _currentToken;
  bool get isDemoMode => _isDemoMode;

  /// Initialize authentication state
  Future<void> initialize() async {
    _setLoading();

    try {
      final token = await _oauthService.getCurrentToken();
      if (token != null) {
        _currentToken = token;
        _isDemoMode = false; // Disable demo mode for real authentication
        if (kDebugMode) {
          print('🔄 Demo mode disabled - real authentication detected');
        }
        _decodeJwtAndSetUser();
        _setAuthenticated();
      } else {
        _setUnauthenticated();
      }
    } catch (e) {
      _setError('Failed to initialize authentication: $e');
    }
  }

  /// Login with OAuth provider
  Future<bool> login(OAuthProvider provider) async {
    _setLoading();
    _clearError();

    try {
      final success = await _oauthService.initiateLogin(provider);
      if (!success) {
        _setError('Failed to initiate OAuth login');
        return false;
      }

      // The actual authentication completion happens in handleCallback
      // For now, we stay in loading state
      return true;
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    }
  }

  /// Handle OAuth callback
  Future<bool> handleCallback(Uri callbackUri) async {
    _setLoading();
    _clearError();

    try {
      final success = await _oauthService.handleCallback(callbackUri);
      if (success) {
        final token = await _oauthService.getCurrentToken();
        if (token != null) {
          _currentToken = token;
          _isDemoMode = false; // Disable demo mode for real authentication
          if (kDebugMode) {
            print('🔄 Demo mode disabled - OAuth callback successful');
          }
          _decodeJwtAndSetUser();
          _setAuthenticated();
          return true;
        }
      }

      _setError('OAuth callback handling failed');
      return false;
    } catch (e) {
      _setError('Callback handling failed: $e');
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    _setLoading();

    try {
      await _oauthService.logout();
      _currentToken = null;
      _currentUser = null;
      _isDemoMode = false;
      _setUnauthenticated();
    } catch (e) {
      _setError('Logout failed: $e');
    }
  }

  /// Refresh token if needed
  Future<bool> refreshTokenIfNeeded() async {
    if (_currentToken?.isExpired == true) {
      try {
        final newToken = await _oauthService.getCurrentToken();
        if (newToken != null) {
          _currentToken = newToken;
          notifyListeners();
          return true;
        } else {
          // Token refresh failed, user needs to re-authenticate
          await logout();
          return false;
        }
      } catch (e) {
        if (kDebugMode) {
          print('❌ Token refresh failed: $e');
        }
        await logout();
        return false;
      }
    }
    return true;
  }

  /// Get valid access token for API calls
  Future<String?> getAccessToken() async {
    if (await refreshTokenIfNeeded()) {
      return _currentToken?.accessToken;
    }
    return null;
  }

  /// Set user information (to be called externally after API service is available)
  void setUserInfo(UserDto user) {
    _currentUser = user;
    _forceResetDemoMode(); // Force reset demo mode when real user data is loaded
    if (kDebugMode) {
      print('✅ User info set externally: ${_currentUser?.name}');
      print('📧 User email: ${_currentUser?.email}');
    }
    notifyListeners();
  }

  /// Decode JWT and set a partial user object
  void _decodeJwtAndSetUser() {
    try {
      if (_currentToken?.accessToken != null) {
        final userInfo = _extractUserInfoFromJWT(_currentToken!.accessToken);
        _currentUser = UserDto(
          id: userInfo['sub'] as String?,
          name: userInfo['name'] as String? ?? userInfo['preferred_username'] as String?,
          email: userInfo['email'] as String?,
          picture: userInfo['picture'] as String?,
        );
        _forceResetDemoMode(); // Force reset demo mode when real JWT is decoded
        if (kDebugMode) {
          print('✅ User info loaded from JWT:');
          print('   - Name: ${_currentUser?.name}');
          print('   - Email: ${_currentUser?.email}');
          print('   - ID: ${_currentUser?.id}');
          print('   - Picture: ${_currentUser?.picture}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to load user info from JWT: $e');
      }
    }
  }

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

      if (kDebugMode) {
        print('🔍 JWT Claims: $claims');
      }

      return claims;
    } catch (e) {
      if (kDebugMode) {
        print('❌ JWT decode error: $e');
      }
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

  /// Set loading state
  void _setLoading() {
    _authState = AuthState.loading;
    notifyListeners();
  }

  /// Set authenticated state
  void _setAuthenticated() {
    _authState = AuthState.authenticated;
    _error = null;
    notifyListeners();
  }

  /// Set unauthenticated state
  void _setUnauthenticated() {
    _authState = AuthState.unauthenticated;
    _error = null;
    notifyListeners();
  }

  /// Set error state
  void _setError(String error) {
    _authState = AuthState.error;
    _error = error;
    if (kDebugMode) {
      print('❌ Auth error: $error');
    }
    notifyListeners();
  }

  /// Clear error state
  void _clearError() {
    _error = null;
    _currentUser = null;
  }

  /// Check if user has specific scope
  bool hasScope(String scope) {
    return _currentToken?.scopes.contains(scope) ?? false;
  }

  /// Get token type for Authorization header
  String get authorizationHeader {
    final token = _currentToken;
    if (token != null) {
      return '${token.tokenType} ${token.accessToken}';
    }
    return '';
  }

  /// Enable demo mode with mock data
  Future<void> enableDemoMode() async {
    _setLoading();
    _isDemoMode = true;

    // Set mock user data
    _currentUser = const UserDto(
      id: 'demo_user_123',
      name: 'Demo User',
      email: 'demo@dmtools.com',
    );

    _setAuthenticated();

    if (kDebugMode) {
      print('✅ Demo mode enabled');
    }
  }

  /// Disable demo mode and logout
  Future<void> disableDemoMode() async {
    _isDemoMode = false;
    await logout();
  }

  /// Force reset demo mode (public method for debugging)
  void forceResetDemoMode() {
    _forceResetDemoMode();
    notifyListeners();
  }

  /// Force reset demo mode for real authentication
  void _forceResetDemoMode() {
    if (_isDemoMode) {
      _isDemoMode = false;
      if (kDebugMode) {
        print('🔄 Demo mode forcefully disabled - real auth detected');
      }
    }
  }

  /// Check if app should use mock data
  bool get shouldUseMockData {
    if (kDebugMode) {
      print('🔍 AuthProvider shouldUseMockData check:');
      print('   - _isDemoMode: $_isDemoMode');
      print('   - isAuthenticated: $isAuthenticated');
      print('   - currentUser: ${_currentUser?.name} (${_currentUser?.email})');
      print('   - Will use mock data: $_isDemoMode');
    }
    return _isDemoMode;
  }
}
