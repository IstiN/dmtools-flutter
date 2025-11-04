import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class SavedCredentials {
  final String username;
  final String password;

  const SavedCredentials({
    required this.username,
    required this.password,
  });

  factory SavedCredentials.fromMap(Map<String, String> map) {
    return SavedCredentials(
      username: map['username'] ?? '',
      password: map['password'] ?? '',
    );
  }

  Map<String, String> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class CredentialsService {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
    mOptions: MacOsOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  static const String _usernameKey = 'local_auth_username';
  static const String _passwordKey = 'local_auth_password';
  static const String _localTokenKey = 'local_auth_token';
  static const String _saveCredentialsKey = 'save_local_credentials';

  /// Save user credentials securely
  Future<void> saveCredentials(String username, String password) async {
    print('[CREDENTIALS] Attempting to save credentials for: $username');
    try {
      await Future.wait([
        _secureStorage.write(key: _usernameKey, value: username),
        _secureStorage.write(key: _passwordKey, value: password),
        _setSaveCredentialsFlag(true),
      ]);

      print('[CREDENTIALS] ✅ Credentials saved to secure storage');
    } catch (e) {
      print('[CREDENTIALS] ❌ Secure storage failed: $e');
      print('[CREDENTIALS] ⚠️ Trying SharedPreferences fallback...');
      // Fallback to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_usernameKey, username);
        await prefs.setString(_passwordKey, password);
        await prefs.setBool(_saveCredentialsKey, true);
        print('[CREDENTIALS] ✅ Credentials saved to SharedPreferences (fallback)');
      } catch (fallbackError) {
        print('[CREDENTIALS] ❌ Fallback also failed: $fallbackError');
        // Don't rethrow - credentials saving is not critical
      }
    }
  }

  /// Get saved credentials
  Future<SavedCredentials?> getSavedCredentials() async {
    print('[CREDENTIALS] Loading saved credentials...');
    
    // First, check the flag
    final shouldSave = await getSaveCredentialsFlag();
    print('[CREDENTIALS] Save credentials flag: $shouldSave');
    if (!shouldSave) {
      print('[CREDENTIALS] Save flag is false, returning null');
      return null;
    }

    String? username;
    String? password;

    // Try secure storage first
    try {
      print('[CREDENTIALS] Trying to read from secure storage...');
      final results = await Future.wait([
        _secureStorage.read(key: _usernameKey),
        _secureStorage.read(key: _passwordKey),
      ]);

      username = results[0];
      password = results[1];
      print('[CREDENTIALS] Secure storage result: username=${username != null ? "found" : "null"}, password=${password != null ? "found" : "null"}');
    } catch (e) {
      print('[CREDENTIALS] ❌ Secure storage read failed: $e');
    }

    // If secure storage didn't work (null or exception), try SharedPreferences fallback
    if (username == null || password == null) {
      print('[CREDENTIALS] Secure storage empty/failed, trying SharedPreferences fallback...');
      try {
        final prefs = await SharedPreferences.getInstance();
        username = prefs.getString(_usernameKey);
        password = prefs.getString(_passwordKey);
        print('[CREDENTIALS] SharedPreferences result: username=${username != null ? "found" : "null"}, password=${password != null ? "found" : "null"}');
      } catch (fallbackError) {
        print('[CREDENTIALS] ❌ SharedPreferences fallback failed: $fallbackError');
      }
    }

    // Return credentials if found
    if (username != null && password != null && username.isNotEmpty && password.isNotEmpty) {
      print('[CREDENTIALS] ✅ Credentials loaded successfully for: $username');
      return SavedCredentials(username: username, password: password);
    }

    print('[CREDENTIALS] ❌ No credentials found in any storage');
    return null;
  }

  /// Clear saved credentials
  Future<void> clearSavedCredentials() async {
    try {
      await Future.wait([
        _secureStorage.delete(key: _usernameKey),
        _secureStorage.delete(key: _passwordKey),
        _secureStorage.delete(key: _localTokenKey),
        _setSaveCredentialsFlag(false),
      ]);

      if (kDebugMode) {
        print('🗑️ Saved credentials cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to clear saved credentials from keychain: $e');
      }
    }
    
    // Also clear from SharedPreferences fallback
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_usernameKey);
      await prefs.remove(_passwordKey);
      await prefs.remove(_localTokenKey);
      await prefs.setBool(_saveCredentialsKey, false);
      if (kDebugMode) {
        print('🗑️ Credentials cleared from SharedPreferences (fallback)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to clear credentials from SharedPreferences: $e');
      }
    }
  }

  /// Check if user has chosen to save credentials
  Future<bool> getSaveCredentialsFlag() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_saveCredentialsKey) ?? false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to get save credentials flag: $e');
      }
      return false;
    }
  }

  /// Set the save credentials preference
  Future<void> _setSaveCredentialsFlag(bool value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_saveCredentialsKey, value);
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to set save credentials flag: $e');
      }
      rethrow;
    }
  }

  /// Check if any credentials are currently saved
  Future<bool> hasCredentials() async {
    final credentials = await getSavedCredentials();
    return credentials != null;
  }

  /// Save local authentication token securely
  Future<void> saveLocalToken(String token) async {
    try {
      await _secureStorage.write(key: _localTokenKey, value: token);
      if (kDebugMode) {
        print('✅ Local token saved securely');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to save local token to keychain: $e');
        print('⚠️ Falling back to SharedPreferences for debug mode');
      }
      // Fallback to SharedPreferences for macOS debug mode without code signing
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_localTokenKey, token);
        if (kDebugMode) {
          print('✅ Local token saved to SharedPreferences (fallback)');
        }
      } catch (fallbackError) {
        if (kDebugMode) {
          print('❌ Fallback also failed: $fallbackError');
        }
        rethrow;
      }
    }
  }

  /// Get saved local authentication token
  Future<String?> getSavedLocalToken() async {
    try {
      final token = await _secureStorage.read(key: _localTokenKey);
      if (token != null && token.isNotEmpty) {
        if (kDebugMode) {
          print('✅ Retrieved saved local token: ${token.substring(0, 20)}...');
        }
        return token;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to get saved local token from keychain: $e');
        print('⚠️ Trying SharedPreferences fallback');
      }
      // Fallback to SharedPreferences
      try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString(_localTokenKey);
        if (token != null && token.isNotEmpty) {
          if (kDebugMode) {
            print('✅ Retrieved token from SharedPreferences (fallback): ${token.substring(0, 20)}...');
          }
          return token;
        }
      } catch (fallbackError) {
        if (kDebugMode) {
          print('❌ Fallback also failed: $fallbackError');
        }
      }
      return null;
    }
  }

  /// Clear saved local authentication token
  Future<void> clearSavedLocalToken() async {
    try {
      await _secureStorage.delete(key: _localTokenKey);
      if (kDebugMode) {
        print('🗑️ Saved local token cleared');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to clear saved local token from keychain: $e');
      }
    }
    
    // Also clear from SharedPreferences fallback
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_localTokenKey);
      if (kDebugMode) {
        print('🗑️ Token cleared from SharedPreferences (fallback)');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to clear token from SharedPreferences: $e');
      }
    }
  }

  /// Check if a local token is currently saved
  Future<bool> hasLocalToken() async {
    final token = await getSavedLocalToken();
    return token != null;
  }
}
