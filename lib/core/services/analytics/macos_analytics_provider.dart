import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'analytics_provider.dart';

/// macOS analytics provider that logs events locally
///
/// This provider stores analytics events locally and can be extended
/// to send them to a backend service or use macOS-specific analytics solutions
class MacOSAnalyticsProvider implements AnalyticsProvider {
  static const String _prefsKey = 'macos_analytics_events';
  static const int _maxStoredEvents = 1000;

  bool _initialized = false;
  List<Map<String, dynamic>> _eventBuffer = [];

  @override
  Future<void> initialize() async {
    if (_initialized) return;

    if (!Platform.isMacOS) {
      if (kDebugMode) {
        debugPrint('⚠️ MacOSAnalyticsProvider: Not running on macOS');
      }
      return;
    }

    // Load stored events
    await _loadStoredEvents();

    _initialized = true;
    if (kDebugMode) {
      debugPrint('✅ MacOSAnalyticsProvider: Initialized');
    }
  }

  @override
  bool get isAvailable => Platform.isMacOS && _initialized;

  @override
  void trackEvent({required String eventName, Map<String, dynamic>? parameters}) {
    if (!isAvailable) {
      if (kDebugMode) {
        debugPrint('⚠️ MacOSAnalyticsProvider: Not available');
      }
      return;
    }

    final event = {
      'event_name': eventName,
      'parameters': parameters ?? {},
      'timestamp': DateTime.now().toIso8601String(),
      'platform': 'macos',
    };

    _eventBuffer.add(event);

    // Keep buffer size manageable
    if (_eventBuffer.length > _maxStoredEvents) {
      _eventBuffer.removeAt(0);
    }

    // Store events asynchronously
    _storeEvents();

    if (kDebugMode) {
      debugPrint(
        '📊 MacOSAnalytics: Tracked event "$eventName" ${parameters != null ? "with params: $parameters" : ""}',
      );
    }
  }

  @override
  void trackButtonClick({required String buttonName, String? screenName, Map<String, dynamic>? additionalParams}) {
    final params = <String, dynamic>{
      'button_name': buttonName,
      if (screenName != null) 'screen_name': screenName,
      if (additionalParams != null) ...additionalParams,
    };

    trackEvent(eventName: 'button_click', parameters: params);
  }

  @override
  void trackScreenView({required String screenName, Map<String, dynamic>? parameters}) {
    final params = <String, dynamic>{
      'screen_name': screenName,
      'page_title': screenName,
      if (parameters != null) ...parameters,
    };

    trackEvent(eventName: 'page_view', parameters: params);
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    if (kDebugMode) {
      debugPrint('📊 MacOSAnalytics: Set user properties: $properties');
    }
    // Store user properties if needed
  }

  @override
  void setUserId(String? userId) {
    if (kDebugMode) {
      debugPrint('📊 MacOSAnalytics: Set user ID: $userId');
    }
    // Store user ID if needed
  }

  @override
  void clearUserData() {
    if (kDebugMode) {
      debugPrint('📊 MacOSAnalytics: Cleared user data');
    }
    // Clear user data if needed
  }

  /// Get stored events (useful for syncing to backend)
  List<Map<String, dynamic>> getStoredEvents() => List.unmodifiable(_eventBuffer);

  /// Clear stored events
  Future<void> clearStoredEvents() async {
    _eventBuffer.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_prefsKey);
  }

  Future<void> _loadStoredEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = prefs.getStringList(_prefsKey);
      if (eventsJson != null) {
        // Note: In a real implementation, you'd deserialize JSON properly
        // For now, we'll just clear old events on startup
        await prefs.remove(_prefsKey);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ MacOSAnalyticsProvider: Error loading stored events: $e');
      }
    }
  }

  Future<void> _storeEvents() async {
    try {
      // Store only recent events (last 100) to avoid storage bloat
      if (_eventBuffer.length > 100) {
        _eventBuffer = _eventBuffer.sublist(_eventBuffer.length - 100);
      }

      // In a real implementation, you'd serialize to JSON and store in SharedPreferences
      // For now, we'll just keep them in memory
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setStringList(_prefsKey, recentEvents.map((e) => jsonEncode(e)).toList());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ MacOSAnalyticsProvider: Error storing events: $e');
      }
    }
  }
}
