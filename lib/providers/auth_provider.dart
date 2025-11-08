import 'package:flutter/foundation.dart';
import '../core/services/oauth_service.dart';
import '../core/models/user.dart';
import '../core/interfaces/auth_token_provider.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier implements AuthTokenProvider {
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
  @override
  bool get isAuthenticated => _authState == AuthState.authenticated;
  bool get isLoading => _authState == AuthState.loading;
  bool get hasError => _authState == AuthState.error;
  String? get error => _error;
  @override
  UserDto? get currentUser => _currentUser;
  OAuthToken? get currentToken => _currentToken;
  @override
  bool get isDemoMode => _isDemoMode;

  /// Initialize authentication state
  Future<void> initialize() async {
    _setLoading();

    try {
      final token = await _oauthService.getCurrentToken();
      if (token != null && !token.isExpired) {
        _currentToken = token;
        _isDemoMode = false;

        // Try to fetch user data and validate authentication
        try {
          final user = await _oauthService.getUserData();
          if (user != null) {
            _currentUser = user;
            _setAuthenticated();
            if (kDebugMode) {
              debugPrint('✅ User authenticated successfully: ${user.name}');
              debugPrint('📧 User email: ${user.email}');
              debugPrint('🔐 Authenticated: ${user.authenticated}');
            }
          } else {
            // User data indicates not authenticated, clear token and logout
            if (kDebugMode) {
              debugPrint('❌ User authentication validation failed - clearing token');
            }
            await _oauthService.logout();
            _currentToken = null;
            _setUnauthenticated();
          }
        } catch (userDataError) {
          // User data fetch failed (network error, server down, etc.)
          // but we have a valid token, so stay authenticated with limited user info
          if (kDebugMode) {
            debugPrint('⚠️ User data fetch failed but token is valid: $userDataError');
            debugPrint('   Staying authenticated with limited token-based info');
          }

          // Create basic user info from token if possible
          _currentUser = const UserDto(
            id: 'token_user',
            name: 'Authenticated User',
            email: 'user@token.auth',
            authenticated: true,
          );
          _setAuthenticated();
        }
      } else {
        if (kDebugMode) {
          if (token != null && token.isExpired) {
            debugPrint('🔄 Token expired, logging out');
          } else {
            debugPrint('🔄 No token found, setting unauthenticated');
          }
        }
        _setUnauthenticated();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Authentication initialization failed: $e');
      }
      _setError('Failed to initialize authentication: $e');
    }
  }

  /// Login with OAuth provider
  Future<bool> login(OAuthProvider provider) async {
    _setLoading();
    _clearError();

    try {
      // Step 1: Initiate OAuth flow
      final initResult = await _oauthService.initiateLogin(provider);
      if (initResult == null) {
        _setError('Failed to initiate OAuth login');
        return false;
      }

      final authUrl = initResult['auth_url'] as String?;
      if (authUrl == null) {
        _setError('No auth URL received from server');
        return false;
      }

      // Step 2: Launch OAuth URL in browser
      final launchSuccess = await _oauthService.launchOAuthUrl(authUrl);
      if (!launchSuccess) {
        _setError('Failed to launch OAuth URL');
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
      // Step 3: Handle OAuth callback and exchange code for token
      final success = await _oauthService.handleCallback(callbackUri);
      if (success) {
        // Step 4: Get updated token
        final token = await _oauthService.getCurrentToken();
        if (token != null) {
          _currentToken = token;
          _isDemoMode = false;

          // Step 5: Fetch user data and validate authentication
          final user = await _oauthService.getUserData();
          if (user != null) {
            _currentUser = user;
            _setAuthenticated();
            if (kDebugMode) {
              debugPrint('🎉 OAuth authentication successful');
              debugPrint('👤 User: ${user.name} (${user.email})');
              debugPrint('🔐 Authenticated: ${user.authenticated}');
              debugPrint('🏢 Provider: ${user.provider}');
            }
            return true;
          } else {
            _setError('User authentication validation failed');
            return false;
          }
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
          debugPrint('❌ Token refresh failed: $e');
        }
        await logout();
        return false;
      }
    }
    return true;
  }

  /// Get valid access token for API calls
  @override
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
      debugPrint('✅ User info set externally: ${_currentUser?.name}');
      debugPrint('📧 User email: ${_currentUser?.email}');
    }
    notifyListeners();
  }

  /// Toggle demo mode
  void toggleDemoMode() {
    _isDemoMode = !_isDemoMode;
    if (kDebugMode) {
      debugPrint('🔄 Demo mode toggled: $_isDemoMode');
    }
    notifyListeners();
  }

  /// Force reset demo mode (internal method)
  void _forceResetDemoMode() {
    if (_isDemoMode) {
      _isDemoMode = false;
      if (kDebugMode) {
        debugPrint('🔄 Demo mode force reset to false');
      }
    }
  }

  /// Check if should use mock data
  @override
  bool get shouldUseMockData => _isDemoMode;

  /// Enable demo mode with mock data
  Future<void> enableDemoMode() async {
    _setLoading();
    _isDemoMode = true;

    // Set mock user data
    _currentUser = const UserDto(
      id: 'demo_user_123',
      name: 'Demo User',
      email: 'demo@dmtools.com',
      authenticated: true,
    );

    _setAuthenticated();

    if (kDebugMode) {
      debugPrint('✅ Demo mode enabled');
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

  // Private state management methods
  void _setLoading() {
    _authState = AuthState.loading;
    notifyListeners();
  }

  void _setAuthenticated() {
    _authState = AuthState.authenticated;
    _error = null;
    notifyListeners();
  }

  void _setUnauthenticated() {
    _authState = AuthState.unauthenticated;
    _error = null;
    notifyListeners();
  }

  void _setError(String message) {
    _authState = AuthState.error;
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }
}
