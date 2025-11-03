import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../config/app_config.dart';
import '../models/user.dart';

enum OAuthProvider {
  google,
  microsoft,
  github,
}

class OAuthToken {
  final String accessToken;
  final String? refreshToken;
  final String tokenType;
  final int expiresIn;
  final DateTime createdAt;
  final Set<String> scopes;

  OAuthToken({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.createdAt,
    required this.scopes,
    this.refreshToken,
  });

  bool get isExpired {
    final expiryTime = createdAt.add(Duration(seconds: expiresIn));
    return DateTime.now().isAfter(expiryTime.subtract(const Duration(minutes: 5))); // 5 min buffer
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenType': tokenType,
      'expiresIn': expiresIn,
      'createdAt': createdAt.toIso8601String(),
      'scopes': scopes.toList(),
    };
  }

  factory OAuthToken.fromJson(Map<String, dynamic> json) {
    return OAuthToken(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String?,
      tokenType: json['tokenType'] as String,
      expiresIn: json['expiresIn'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      scopes: Set<String>.from(json['scopes'] as List),
    );
  }
}

class OAuthService {
  static const String _storageKey = 'oauth_token';

  final FlutterSecureStorage _secureStorage;
  final String _clientRedirectUri;
  final String _baseUrl;

  OAuthService({
    FlutterSecureStorage? secureStorage,
  })  : _secureStorage = secureStorage ?? const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
          mOptions: MacOsOptions(
            accessibility: KeychainAccessibility.first_unlock_this_device,
          ),
        ),
        _clientRedirectUri = _getClientRedirectUri(),
        _baseUrl = AppConfig.baseUrl;

  static String _getClientRedirectUri() {
    if (kIsWeb) {
      // Use the current host base URL for SPA deployment
      // OAuth provider will redirect to base URL with query parameters
      // and Flutter will detect them via JavaScript in index.html
      final base = Uri.base;
      return base.origin;
    } else {
      return 'dmtools://auth/callback';
    }
  }

  /// Initiate OAuth flow - Step 1: Call /api/oauth-proxy/initiate
  Future<Map<String, dynamic>?> initiateLogin(OAuthProvider provider) async {
    try {
      // Step 1: Call backend's /api/oauth-proxy/initiate endpoint
      final response = await http.post(
        Uri.parse('$_baseUrl/api/oauth-proxy/initiate'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'provider': provider.name.toLowerCase(),
          'client_redirect_uri': _clientRedirectUri,
          'client_type': 'web',
          'environment': AppConfig.environment.value,
        }),
      );

      if (kDebugMode) {
        print('🔐 Initiating OAuth login for ${provider.name}');
        print('📍 Client Redirect URI: $_clientRedirectUri');
        print('🌍 Environment: ${AppConfig.environment.value}');
        print('📤 Request to: $_baseUrl/api/oauth-proxy/initiate');
        print('📥 Response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final authUrl = responseData['auth_url'] as String?;
        final state = responseData['state'] as String?;
        final expiresIn = responseData['expires_in'] as int?;

        if (authUrl != null) {
          if (kDebugMode) {
            print('🔗 Auth URL received: $authUrl');
            print('🔍 State: ${state?.substring(0, 10)}...');
            print('⏰ Expires in: $expiresIn seconds');
          }

          return {
            'auth_url': authUrl,
            'state': state,
            'expires_in': expiresIn,
          };
        } else {
          throw Exception('No auth_url received from backend');
        }
      } else {
        if (kDebugMode) {
          print('❌ OAuth initiation failed: ${response.statusCode} ${response.body}');
        }
        throw Exception('Backend OAuth initiation failed: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ OAuth initiation failed: $e');
      }
      return null;
    }
  }

  /// Launch OAuth URL in browser
  Future<bool> launchOAuthUrl(String authUrl) async {
    try {
      // Step 2: Redirect user to the auth URL returned by backend
      if (kIsWeb) {
        // For web, use same-window navigation to avoid Safari popup blocking
        if (await canLaunchUrl(Uri.parse(authUrl))) {
          return await launchUrl(
            Uri.parse(authUrl),
            webOnlyWindowName: '_self', // Navigate in same window to avoid popup blockers
          );
        } else {
          throw Exception('Could not launch OAuth URL');
        }
      } else {
        // For mobile, use external application
        if (await canLaunchUrl(Uri.parse(authUrl))) {
          return await launchUrl(
            Uri.parse(authUrl),
            mode: LaunchMode.externalApplication,
          );
        } else {
          throw Exception('Could not launch OAuth URL');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ OAuth URL launch failed: $e');
      }
      return false;
    }
  }

  /// Handle OAuth callback - Step 3: Extract temp code and exchange for JWT
  Future<bool> handleCallback(Uri callbackUri) async {
    try {
      final tempCode = callbackUri.queryParameters['code'];
      final state = callbackUri.queryParameters['state'];
      final error = callbackUri.queryParameters['error'];

      if (error != null) {
        throw Exception('OAuth error: $error');
      }

      if (tempCode == null) {
        throw Exception('Missing temporary code');
      }

      if (state == null) {
        throw Exception('Missing state parameter');
      }

      if (kDebugMode) {
        print('🔄 Handling OAuth callback');
        print('📝 Temp code received: ${tempCode.substring(0, 10)}...');
        print('🔍 State received: ${state.substring(0, 10)}...');
      }

      // Step 4: Exchange temp code for JWT token
      final token = await _exchangeTempCodeForToken(tempCode, state);
      if (token != null) {
        await _storeToken(token);
        return true;
      }

      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ OAuth callback handling failed: $e');
      }
      return false;
    }
  }

  /// Exchange temporary code for JWT token - Step 4
  Future<OAuthToken?> _exchangeTempCodeForToken(String tempCode, String state) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/oauth-proxy/exchange'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'code': tempCode,
          'state': state,
        }),
      );

      if (kDebugMode) {
        print('🔄 Exchanging temp code for JWT token');
        print('📤 Request to: $_baseUrl/api/oauth-proxy/exchange');
        print('📥 Response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;

        // The backend returns JWT tokens in this format
        final accessToken = json['access_token'] as String?;
        final refreshToken = json['refresh_token'] as String?;
        final tokenType = json['token_type'] as String? ?? 'Bearer';
        final expiresIn = json['expires_in'] as int? ?? 3600;

        if (accessToken != null) {
          if (kDebugMode) {
            print('✅ JWT token received successfully');
          }

          return OAuthToken(
            accessToken: accessToken,
            refreshToken: refreshToken,
            tokenType: tokenType,
            expiresIn: expiresIn,
            createdAt: DateTime.now(),
            scopes: Set<String>.from(
              (json['scope'] as String?)?.split(' ') ?? ['openid', 'profile', 'email'],
            ),
          );
        } else {
          throw Exception('No access_token in response');
        }
      } else {
        if (kDebugMode) {
          print('❌ Token exchange failed: ${response.statusCode} ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Token exchange error: $e');
      }
      return null;
    }
  }

  /// Get user data from /api/auth/user endpoint - Step 5
  Future<UserDto?> getUserData() async {
    try {
      final token = await getCurrentToken();
      if (token == null) {
        if (kDebugMode) {
          print('❌ No token available for user data request');
        }
        return null;
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/api/auth/user'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ${token.accessToken}',
        },
      );

      if (kDebugMode) {
        print('🔄 Fetching user data');
        print('📤 Request to: $_baseUrl/api/auth/user');
        print('📥 Response status: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final user = UserDto.fromJson(json);

        if (kDebugMode) {
          print('✅ User data received successfully');
          print('👤 User: ${user.name} (${user.email})');
          print('🔐 Authenticated: ${user.authenticated}');
          print('🏢 Provider: ${user.provider}');
        }

        // Check if user is authenticated
        if (user.authenticated != true) {
          if (kDebugMode) {
            print('❌ User is not authenticated, clearing token');
          }
          await _clearToken();
          return null;
        }

        return user;
      } else {
        if (kDebugMode) {
          print('❌ User data fetch failed: ${response.statusCode} ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ User data fetch error: $e');
      }
      return null;
    }
  }

  /// Get current stored token
  Future<OAuthToken?> getCurrentToken() async {
    try {
      final tokenJson = await _secureStorage.read(key: _storageKey);
      if (tokenJson != null) {
        final token = OAuthToken.fromJson(jsonDecode(tokenJson));

        // Check if token is expired and try to refresh
        if (token.isExpired && token.refreshToken != null) {
          final refreshedToken = await _refreshToken(token.refreshToken!);
          if (refreshedToken != null) {
            await _storeToken(refreshedToken);
            return refreshedToken;
          } else {
            // Refresh failed, remove invalid token
            await _clearToken();
            return null;
          }
        }

        return token;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting current token: $e');
      }
      return null;
    }
  }

  /// Refresh access token using refresh token
  Future<OAuthToken?> _refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/oauth/refresh'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'refresh_token': refreshToken,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return OAuthToken(
          accessToken: json['access_token'] as String,
          refreshToken: json['refresh_token'] as String? ?? refreshToken,
          tokenType: json['token_type'] as String? ?? 'Bearer',
          expiresIn: json['expires_in'] as int? ?? 3600,
          createdAt: DateTime.now(),
          scopes: Set<String>.from(
            (json['scope'] as String?)?.split(' ') ?? [],
          ),
        );
      } else {
        if (kDebugMode) {
          print('❌ Token refresh failed: ${response.statusCode}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Token refresh error: $e');
      }
      return null;
    }
  }

  /// Store token securely
  Future<void> _storeToken(OAuthToken token) async {
    final tokenJson = jsonEncode(token.toJson());
    await _secureStorage.write(key: _storageKey, value: tokenJson);

    if (kDebugMode) {
      print('✅ JWT token stored securely');
    }
  }

  /// Clear stored token
  Future<void> _clearToken() async {
    await _secureStorage.delete(key: _storageKey);
    if (kDebugMode) {
      print('🗑️ Token cleared');
    }
  }

  /// Logout and clear all tokens
  Future<void> logout() async {
    await _clearToken();
    if (kDebugMode) {
      print('📤 Logout completed');
    }
  }
}
