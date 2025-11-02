import 'package:flutter/foundation.dart';
import '../core/services/oauth_service.dart';
import '../core/services/auth_config_service.dart';
import '../core/services/local_auth_service.dart';
import '../core/services/credentials_service.dart';
import '../network/services/auth_api_service.dart';
import '../core/models/user.dart';
import '../core/interfaces/auth_token_provider.dart';

enum AuthState {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class EnhancedAuthProvider with ChangeNotifier implements AuthTokenProvider {
  final OAuthService _oauthService;
  final AuthConfigService _authConfigService;
  final LocalAuthService _localAuthService;
  final CredentialsService _credentialsService;
  // Note: _authApiService is available for future use when integrating with API calls
  // ignore: unused_field
  final AuthApiService _authApiService;

  AuthState _authState = AuthState.initial;
  AuthConfig? _authConfig;
  OAuthToken? _currentToken;
  String? _localToken; // Token from local authentication
  UserDto? _currentUser;
  String? _error;
  bool _isDemoMode = false;

  EnhancedAuthProvider({
    OAuthService? oauthService,
    AuthConfigService? authConfigService,
    LocalAuthService? localAuthService,
    CredentialsService? credentialsService,
    AuthApiService? authApiService,
  })  : _oauthService = oauthService ?? OAuthService(),
        _authConfigService = authConfigService ?? AuthConfigService(),
        _localAuthService = localAuthService ?? LocalAuthService(),
        _credentialsService = credentialsService ?? CredentialsService(),
        _authApiService = authApiService ?? AuthApiService();

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
  String? get localToken => _localToken;
  @override
  bool get isDemoMode => _isDemoMode;
  AuthConfig? get authConfig => _authConfig;

  // Convenience getters
  bool get hasLocalAuth => _authConfig?.hasLocalLogin ?? false;
  bool get hasOAuthProviders => _authConfig?.hasOAuthProviders ?? false;
  List<String> get enabledProviders => _authConfig?.enabledProviders ?? [];
  bool get isStandaloneMode => _authConfig?.isStandaloneMode ?? false;

  /// Initialize authentication state
  Future<void> initializeAuth() async {
    _setLoading();

    try {
      // Step 1: Fetch authentication configuration with fallback
      try {
        _authConfig = await _authConfigService.getAuthConfig();

        if (kDebugMode) {
          print('✅ Auth config loaded:');
          print('   Mode: ${_authConfig!.authenticationMode}');
          print('   Providers: ${_authConfig!.enabledProviders}');
          print('   Has local auth: ${_authConfig!.hasLocalLogin}');
        }
      } catch (configError) {
        if (kDebugMode) {
          print('⚠️ Auth config endpoint unavailable, using OAuth-only fallback: $configError');
        }
        // Fallback: Assume OAuth authentication is available
        _authConfig = const AuthConfig(
          enabledProviders: ['google', 'github', 'microsoft'],
          authenticationMode: AuthMode.external,
        );
      }

      // Step 2: Check for existing OAuth token if OAuth providers are available
      if (_authConfig!.hasOAuthProviders) {
        final token = await _oauthService.getCurrentToken();
        if (token != null && !token.isExpired) {
          _currentToken = token;

          // Try to fetch user data and validate authentication
          try {
            final user = await _oauthService.getUserData();
            if (user != null) {
              _currentUser = user;
              _setAuthenticated();
              if (kDebugMode) {
                print('✅ OAuth user authenticated: ${user.name}');
              }
              return;
            }
          } catch (userDataError) {
            if (kDebugMode) {
              print('⚠️ OAuth user data fetch failed: $userDataError');
            }
            // Continue to check local auth
          }
        }
      }

      // Step 3: Check for saved local token first
      if (_authConfig!.hasLocalLogin) {
        // First try to restore from saved token
        final savedToken = await _credentialsService.getSavedLocalToken();
        if (savedToken != null) {
          try {
            // Validate the token by trying to get user data
            // This will throw an exception if user.authenticated is false
            final user = await _authApiService.getCurrentUser(savedToken);
            _localToken = savedToken;
            _currentUser = user;
            _setAuthenticated();
            if (kDebugMode) {
              print('✅ Local token restored and validated: ${user.name}');
            }
            return;
          } catch (tokenValidationError) {
            if (kDebugMode) {
              print('⚠️ Saved token validation failed: $tokenValidationError');
              print('   Clearing invalid token and saved credentials');
            }
            // Clear invalid token and credentials
            await _credentialsService.clearSavedLocalToken();
            await _credentialsService.clearSavedCredentials();
          }
        }

        // If no valid token, try saved credentials
        final savedCredentials = await _credentialsService.getSavedCredentials();
        if (savedCredentials != null) {
          try {
            final response = await _localAuthService.login(
              savedCredentials.username,
              savedCredentials.password,
            );
            _localToken = response.token;
            _currentUser = response.user;
            _setAuthenticated();
            if (kDebugMode) {
              print('✅ Local user authenticated with saved credentials: ${response.user.name}');
            }
            return;
          } catch (e) {
            if (kDebugMode) {
              print('⚠️ Saved credentials login failed: $e');
            }
            // Clear invalid saved credentials
            await _credentialsService.clearSavedCredentials();
          }
        }
      }

      // Step 4: No valid authentication found
      _setUnauthenticated();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Auth initialization failed: $e');
      }
      _setError('Failed to initialize authentication: $e');
    }
  }

  /// Login with OAuth provider
  Future<bool> loginWithOAuth(OAuthProvider provider) async {
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

      // The actual authentication completion happens in handleOAuthCallback
      return true;
    } catch (e) {
      _setError('OAuth login failed: $e');
      return false;
    }
  }

  /// Handle OAuth callback
  Future<bool> handleOAuthCallback(Uri callbackUri) async {
    _setLoading();
    _clearError();

    try {
      final success = await _oauthService.handleCallback(callbackUri);
      if (success) {
        final token = await _oauthService.getCurrentToken();
        if (token != null) {
          _currentToken = token;
          _localToken = null; // Clear any local token

          final user = await _oauthService.getUserData();
          if (user != null) {
            _currentUser = user;
            _setAuthenticated();
            if (kDebugMode) {
              print('🎉 OAuth authentication successful: ${user.name}');
            }
            return true;
          }
        }
      }

      _setError('OAuth callback handling failed');
      return false;
    } catch (e) {
      _setError('OAuth callback failed: $e');
      return false;
    }
  }

  /// Login with username and password
  Future<bool> loginWithCredentials(String username, String password, {bool saveCredentials = false}) async {
    _setLoading();
    _clearError();

    try {
      final response = await _localAuthService.login(username, password);

      // Validate that the user is authenticated
      if (response.user.authenticated != true) {
        if (kDebugMode) {
          print('❌ Login failed: User is not authenticated');
        }
        _setError('Authentication validation failed');
        return false;
      }

      _localToken = response.token;
      _currentToken = null; // Clear any OAuth token
      _currentUser = response.user;

      // Always save the token for session persistence across refreshes
      await _credentialsService.saveLocalToken(response.token);

      // Save credentials if requested
      if (saveCredentials) {
        await _credentialsService.saveCredentials(username, password);
      } else {
        // Clear any previously saved credentials if user chose not to save
        // But keep the token for the current session
        await _credentialsService.clearSavedCredentials();
        // Re-save the token since clearSavedCredentials also clears the token
        await _credentialsService.saveLocalToken(response.token);
      }

      _setAuthenticated();

      if (kDebugMode) {
        print('🎉 Local authentication successful: ${response.user.name}');
        print('   Credentials saved: $saveCredentials');
      }

      return true;
    } catch (e) {
      _setError('Login failed: $e');
      return false;
    }
  }

  /// Get saved credentials
  Future<SavedCredentials?> getSavedCredentials() async {
    return await _credentialsService.getSavedCredentials();
  }

  /// Clear saved credentials
  Future<void> clearSavedCredentials() async {
    await _credentialsService.clearSavedCredentials();
  }

  /// Check if credentials are saved
  Future<bool> hasCredentials() async {
    return await _credentialsService.hasCredentials();
  }

  /// Logout user
  Future<void> logout() async {
    _setLoading();

    try {
      // Clear OAuth session
      if (_currentToken != null) {
        await _oauthService.logout();
        _currentToken = null;
      }

      // Clear local session
      _localToken = null;
      _currentUser = null;
      _isDemoMode = false;

      // Clear saved token and credentials to prevent auto-login
      await _credentialsService.clearSavedLocalToken();
      await _credentialsService.clearSavedCredentials();

      if (kDebugMode) {
        print('🔓 Logout: Cleared token and saved credentials');
      }

      _setUnauthenticated();
    } catch (e) {
      _setError('Logout failed: $e');
    }
  }

  /// Get valid access token for API calls
  @override
  Future<String?> getAccessToken() async {
    if (kDebugMode) {
      print('🔐 EnhancedAuthProvider.getAccessToken() called');
      print('   - Local token: ${_localToken != null ? '${_localToken!.substring(0, 20)}...' : 'null'}');
      print(
          '   - OAuth token: ${_currentToken?.accessToken != null ? '${_currentToken!.accessToken.substring(0, 20)}...' : 'null'}');
    }

    // For local auth, return the local token
    if (_localToken != null) {
      if (kDebugMode) {
        print('✅ EnhancedAuthProvider: Returning local token');
      }
      return _localToken;
    }

    // For OAuth, check if token needs refresh
    if (_currentToken != null) {
      if (_currentToken!.isExpired) {
        try {
          final newToken = await _oauthService.getCurrentToken();
          if (newToken != null) {
            _currentToken = newToken;
            notifyListeners();
            return newToken.accessToken;
          } else {
            // Token refresh failed, user needs to re-authenticate
            await logout();
            return null;
          }
        } catch (e) {
          if (kDebugMode) {
            print('❌ Token refresh failed: $e');
          }
          await logout();
          return null;
        }
      }
      return _currentToken!.accessToken;
    }

    return null;
  }

  /// Set user information (external API call)
  void setUserInfo(UserDto user) {
    _currentUser = user;
    _forceResetDemoMode();
    if (kDebugMode) {
      print('✅ User info updated: ${user.name}');
    }
    notifyListeners();
  }

  /// Toggle demo mode
  void toggleDemoMode() {
    _isDemoMode = !_isDemoMode;
    if (kDebugMode) {
      print('🔄 Demo mode toggled: $_isDemoMode');
    }
    notifyListeners();
  }

  /// Enable demo mode
  Future<void> enableDemoMode() async {
    _setLoading();
    _isDemoMode = true;

    _currentUser = const UserDto(
      id: 'demo_user_123',
      name: 'Demo User',
      email: 'demo@dmtools.com',
      authenticated: true,
    );

    _setAuthenticated();

    if (kDebugMode) {
      print('✅ Demo mode enabled');
    }
  }

  /// Disable demo mode
  Future<void> disableDemoMode() async {
    _isDemoMode = false;
    await logout();
  }

  /// Force reset demo mode (public method for debug purposes)
  void forceResetDemoMode() {
    _forceResetDemoMode();
  }

  /// Force reset demo mode
  void _forceResetDemoMode() {
    if (_isDemoMode) {
      _isDemoMode = false;
      if (kDebugMode) {
        print('🔄 Demo mode force reset');
      }
    }
  }

  /// Check if should use mock data
  @override
  bool get shouldUseMockData => _isDemoMode;

  /// Check if user has specific scope (OAuth only)
  bool hasScope(String scope) {
    return _currentToken?.scopes.contains(scope) ?? false;
  }

  /// Handle authentication failure from API interceptor
  Future<void> handleAuthenticationFailure() async {
    if (kDebugMode) {
      print('🚨 EnhancedAuthProvider: Authentication failure detected');
      print('   Logging out user and clearing session');
    }
    
    // Prevent multiple simultaneous logout calls
    if (_authState == AuthState.loading) {
      if (kDebugMode) {
        print('⚠️ EnhancedAuthProvider: Logout already in progress, skipping');
      }
      return;
    }

    await logout();
  }

  /// Get authorization header
  String get authorizationHeader {
    if (_localToken != null) {
      return 'Bearer $_localToken';
    }
    if (_currentToken != null) {
      return '${_currentToken!.tokenType} ${_currentToken!.accessToken}';
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
