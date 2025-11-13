import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service to fetch the latest release version from GitHub
class ReleaseService {
  static const String _apiUrl = 'https://api.github.com/repos/IstiN/dmtools-flutter/releases/latest';
  static const String _fallbackVersion = 'latest';
  
  static String? _cachedVersion;
  static DateTime? _cacheTimestamp;
  static String? _cachedCliVersion;
  static DateTime? _cacheCliTimestamp;
  static const Duration _cacheDuration = Duration(hours: 1);

  /// Get the latest release tag name
  /// Returns the tag name (e.g., "flutter-v1.7.78") or "latest" as fallback
  static Future<String> getLatestReleaseTag() async {
    // Return cached version if still valid
    if (_cachedVersion != null && 
        _cacheTimestamp != null && 
        DateTime.now().difference(_cacheTimestamp!) < _cacheDuration) {
      return _cachedVersion!;
    }

    try {
      final response = await http.get(
        Uri.parse(_apiUrl),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final tagName = jsonData['tag_name'] as String?;
        
        if (tagName != null && tagName.isNotEmpty) {
          _cachedVersion = tagName;
          _cacheTimestamp = DateTime.now();
          if (kDebugMode) {
            debugPrint('✅ Fetched latest release tag: $tagName');
          }
          return tagName;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to fetch latest release: $e');
      }
    }

    // Fallback to "latest"
    if (kDebugMode) {
      debugPrint('📦 Using fallback version: $_fallbackVersion');
    }
    return _fallbackVersion;
  }

  /// Get the releases page URL for the latest flutter-v* release
  /// Finds the first tag that starts with "flutter-v" and returns its URL
  static Future<String> getReleasesPageUrl() async {
    try {
      // Get all releases to find the latest flutter-v* tag
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/IstiN/dmtools-flutter/releases'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final releases = jsonDecode(response.body) as List<dynamic>;
        
        // Find the first release with tag starting with "flutter-v"
        for (final release in releases) {
          final releaseData = release as Map<String, dynamic>;
          final tagName = releaseData['tag_name'] as String?;
          
          if (tagName != null && tagName.startsWith('flutter-v')) {
            return 'https://github.com/IstiN/dmtools-flutter/releases/tag/$tagName';
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to fetch flutter release URL: $e');
      }
    }

    // Fallback to latest if we can't find a flutter-v* release
    return 'https://github.com/IstiN/dmtools-flutter/releases/latest';
  }

  /// Get the latest CLI release tag from dmtools repository
  /// Finds the first tag that starts with "v" (e.g., "v1.7.82")
  static Future<String> getLatestCliReleaseTag() async {
    // Return cached version if still valid
    if (_cachedCliVersion != null && 
        _cacheCliTimestamp != null && 
        DateTime.now().difference(_cacheCliTimestamp!) < _cacheDuration) {
      return _cachedCliVersion!;
    }

    try {
      // Get all releases from dmtools repository (not dmtools-flutter)
      final response = await http.get(
        Uri.parse('https://api.github.com/repos/IstiN/dmtools/releases'),
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final releases = jsonDecode(response.body) as List<dynamic>;
        
        // Find the first release with tag starting with "v"
        for (final release in releases) {
          final releaseData = release as Map<String, dynamic>;
          final tagName = releaseData['tag_name'] as String?;
          
          if (tagName != null && tagName.startsWith('v')) {
            _cachedCliVersion = tagName;
            _cacheCliTimestamp = DateTime.now();
            if (kDebugMode) {
              debugPrint('✅ Fetched latest CLI release tag: $tagName');
            }
            return tagName;
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to fetch CLI release tag: $e');
      }
    }

    // Fallback to latest version
    if (kDebugMode) {
      debugPrint('📦 Using fallback CLI version: v1.7.82');
    }
    return 'v1.7.82';
  }

  /// Get the CLI installation URL for a specific version
  /// Uses the latest CLI version if version is null or empty
  static Future<String> getCliInstallUrl([String? version]) async {
    final versionTag = version ?? await getLatestCliReleaseTag();
    return 'https://github.com/IstiN/dmtools/releases/download/$versionTag/install.sh';
  }

  /// Get the CLI installation command
  static Future<String> getCliInstallCommand() async {
    final versionTag = await getLatestCliReleaseTag();
    final installUrl = await getCliInstallUrl(versionTag);
    return 'curl -fsSL $installUrl | bash';
  }

  /// Clear the cache (useful for testing or forcing refresh)
  static void clearCache() {
    _cachedVersion = null;
    _cacheTimestamp = null;
    _cachedCliVersion = null;
    _cacheCliTimestamp = null;
  }
}

