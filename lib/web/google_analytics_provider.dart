// ignore_for_file: avoid_web_libraries_in_flutter
// This file should only be imported on web platforms where dart:js is available
// It is imported conditionally via: import 'google_analytics_provider_stub.dart' if (dart.library.js) 'google_analytics_provider.dart'
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import '../core/services/analytics/analytics_provider.dart';

/// Google Analytics provider implementation for web platforms
class GoogleAnalyticsProvider implements AnalyticsProvider {
  bool _initialized = false;

  @override
  Future<void> initialize() async {
    if (_initialized) return;
    
    // Check if Google Analytics is available
    if (!isAvailable) {
      if (kDebugMode) {
        debugPrint('⚠️ GoogleAnalyticsProvider: Google Analytics not available');
      }
      return;
    }

    _initialized = true;
    if (kDebugMode) {
      debugPrint('✅ GoogleAnalyticsProvider: Initialized');
    }
  }

  @override
  bool get isAvailable {
    try {
      return js.context.hasProperty('gtag') || js.context.hasProperty('dataLayer');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ GoogleAnalyticsProvider: Error checking availability: $e');
      }
      return false;
    }
  }

  @override
  void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    if (!isAvailable) {
      if (kDebugMode) {
        debugPrint('⚠️ GoogleAnalyticsProvider: Google Analytics not available');
      }
      return;
    }

    try {
      final gtag = js.context['gtag'];
      if (gtag == null) {
        if (kDebugMode) {
          debugPrint('⚠️ GoogleAnalyticsProvider: gtag function not found');
        }
        return;
      }

      final jsParams = parameters != null ? _convertToJsObject(parameters) : null;

      if (jsParams != null) {
        gtag.apply(['event', eventName, jsParams]);
      } else {
        gtag.apply(['event', eventName]);
      }

      if (kDebugMode) {
        debugPrint('📊 GoogleAnalytics: Tracked event "$eventName" ${parameters != null ? "with params: $parameters" : ""}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ GoogleAnalyticsProvider: Error tracking event "$eventName": $e');
      }
    }
  }

  @override
  void trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? additionalParams,
  }) {
    final params = <String, dynamic>{
      'button_name': buttonName,
      if (screenName != null) 'screen_name': screenName,
      if (additionalParams != null) ...additionalParams,
    };

    trackEvent(
      eventName: 'button_click',
      parameters: params,
    );
  }

  @override
  void trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) {
    final params = <String, dynamic>{
      'screen_name': screenName,
      'page_title': screenName,
      if (parameters != null) ...parameters,
    };

    trackEvent(
      eventName: 'page_view',
      parameters: params,
    );
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    if (!isAvailable) return;

    try {
      final gtag = js.context['gtag'];
      if (gtag == null) return;

      final jsParams = _convertToJsObject(properties);
      gtag.apply(['set', 'user_properties', jsParams]);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ GoogleAnalyticsProvider: Error setting user properties: $e');
      }
    }
  }

  @override
  void setUserId(String? userId) {
    if (!isAvailable) return;

    try {
      final gtag = js.context['gtag'];
      if (gtag == null) return;

      if (userId != null) {
        gtag.apply(['set', 'user_id', userId]);
      } else {
        gtag.apply(['set', 'user_id', null]);
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ GoogleAnalyticsProvider: Error setting user ID: $e');
      }
    }
  }

  @override
  void clearUserData() {
    setUserId(null);
  }

  /// Convert Dart Map to JavaScript object
  static js.JsObject _convertToJsObject(Map<String, dynamic> map) {
    final jsObject = js.JsObject.jsify({});
    map.forEach((key, value) {
      if (value is Map) {
        jsObject[key] = _convertToJsObject(value as Map<String, dynamic>);
      } else if (value is List) {
        jsObject[key] = js.JsArray.from(value);
      } else {
        jsObject[key] = value;
      }
    });
    return jsObject;
  }
}

