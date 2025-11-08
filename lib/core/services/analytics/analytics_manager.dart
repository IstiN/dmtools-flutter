import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode, debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics_provider.dart';
import 'google_analytics_provider_stub.dart' if (dart.library.js) 'google_analytics_provider.dart' as web_provider;
import 'macos_analytics_provider.dart';
import 'analytics_service_stub.dart';

/// Analytics manager that coordinates multiple analytics providers
/// 
/// This manager:
/// - Supports enable/disable functionality
/// - Can use multiple providers simultaneously
/// - Automatically selects the right provider based on platform
class AnalyticsManager {
  static const String _prefsKeyEnabled = 'analytics_enabled';
  
  static AnalyticsManager? _instance;
  static AnalyticsManager get instance => _instance ??= AnalyticsManager._();
  
  AnalyticsManager._();

  bool _initialized = false;
  bool _enabled = true; // Default to enabled
  final List<AnalyticsProvider> _providers = [];

  /// Initialize the analytics manager
  /// 
  /// Call this once at app startup
  Future<void> initialize() async {
    if (_initialized) return;

    // Load enabled state from preferences
    await _loadEnabledState();

    // Initialize providers based on platform
    if (kIsWeb) {
      final googleProvider = web_provider.GoogleAnalyticsProvider();
      await googleProvider.initialize();
      _providers.add(googleProvider);
    } else if (Platform.isMacOS) {
      final macosProvider = MacOSAnalyticsProvider();
      await macosProvider.initialize();
      _providers.add(macosProvider);
    } else {
      // Use stub for other platforms
      final stubProvider = StubAnalyticsProvider();
      await stubProvider.initialize();
      _providers.add(stubProvider);
    }

    _initialized = true;
    
    if (kDebugMode) {
      debugPrint('✅ AnalyticsManager: Initialized with ${_providers.length} provider(s)');
      debugPrint('   Enabled: $_enabled');
    }
  }

  /// Enable or disable analytics tracking
  /// 
  /// When disabled, all tracking calls are ignored
  Future<void> setEnabled(bool enabled) async {
    _enabled = enabled;
    await _saveEnabledState();
    
    if (kDebugMode) {
      debugPrint('📊 AnalyticsManager: ${enabled ? "Enabled" : "Disabled"}');
    }
  }

  /// Check if analytics is enabled
  bool get isEnabled => _enabled;

  /// Check if analytics is available (at least one provider is available)
  bool get isAvailable {
    if (!_initialized) return false;
    return _providers.any((p) => p.isAvailable);
  }

  /// Add a custom analytics provider
  /// 
  /// Useful for adding additional providers like Mixpanel, Amplitude, etc.
  Future<void> addProvider(AnalyticsProvider provider) async {
    await provider.initialize();
    _providers.add(provider);
    
    if (kDebugMode) {
      debugPrint('✅ AnalyticsManager: Added provider ${provider.runtimeType}');
    }
  }

  /// Remove a provider
  void removeProvider(AnalyticsProvider provider) {
    _providers.remove(provider);
    
    if (kDebugMode) {
      debugPrint('📊 AnalyticsManager: Removed provider ${provider.runtimeType}');
    }
  }

  /// Get all active providers
  List<AnalyticsProvider> get providers => List.unmodifiable(_providers);

  /// Track an event across all enabled providers
  void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    if (!_enabled || !_initialized) return;

    for (final provider in _providers) {
      if (provider.isAvailable) {
        try {
          provider.trackEvent(
            eventName: eventName,
            parameters: parameters,
          );
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ AnalyticsManager: Error tracking event in ${provider.runtimeType}: $e');
          }
        }
      }
    }
  }

  /// Track a button click across all enabled providers
  void trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? additionalParams,
  }) {
    if (!_enabled || !_initialized) return;

    for (final provider in _providers) {
      if (provider.isAvailable) {
        try {
          provider.trackButtonClick(
            buttonName: buttonName,
            screenName: screenName,
            additionalParams: additionalParams,
          );
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ AnalyticsManager: Error tracking button click in ${provider.runtimeType}: $e');
          }
        }
      }
    }
  }

  /// Track a screen view across all enabled providers
  void trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) {
    if (!_enabled || !_initialized) return;

    for (final provider in _providers) {
      if (provider.isAvailable) {
        try {
          provider.trackScreenView(
            screenName: screenName,
            parameters: parameters,
          );
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ AnalyticsManager: Error tracking screen view in ${provider.runtimeType}: $e');
          }
        }
      }
    }
  }

  /// Set user properties across all enabled providers
  void setUserProperties(Map<String, dynamic> properties) {
    if (!_enabled || !_initialized) return;

    for (final provider in _providers) {
      if (provider.isAvailable) {
        try {
          provider.setUserProperties(properties);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ AnalyticsManager: Error setting user properties in ${provider.runtimeType}: $e');
          }
        }
      }
    }
  }

  /// Set user ID across all enabled providers
  void setUserId(String? userId) {
    if (!_enabled || !_initialized) return;

    for (final provider in _providers) {
      if (provider.isAvailable) {
        try {
          provider.setUserId(userId);
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ AnalyticsManager: Error setting user ID in ${provider.runtimeType}: $e');
          }
        }
      }
    }
  }

  /// Clear user data across all enabled providers
  void clearUserData() {
    if (!_initialized) return;

    for (final provider in _providers) {
      if (provider.isAvailable) {
        try {
          provider.clearUserData();
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ AnalyticsManager: Error clearing user data in ${provider.runtimeType}: $e');
          }
        }
      }
    }
  }

  Future<void> _loadEnabledState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _enabled = prefs.getBool(_prefsKeyEnabled) ?? true; // Default to enabled
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AnalyticsManager: Error loading enabled state: $e');
      }
      _enabled = true; // Default to enabled on error
    }
  }

  Future<void> _saveEnabledState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKeyEnabled, _enabled);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AnalyticsManager: Error saving enabled state: $e');
      }
    }
  }
}

