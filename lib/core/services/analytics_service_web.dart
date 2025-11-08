// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'package:flutter/foundation.dart';

/// Web implementation of AnalyticsService using Google Analytics gtag
/// This file is used only on web platforms where dart:js is available
class AnalyticsService {
  /// Check if Google Analytics is available
  static bool get isAvailable {
    try {
      return js.context.hasProperty('gtag') || js.context.hasProperty('dataLayer');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ AnalyticsService: Error checking availability: $e');
      }
      return false;
    }
  }

  /// Track an event using Google Analytics
  /// 
  /// Example:
  /// ```dart
  /// AnalyticsService.trackEvent(
  ///   eventName: 'button_click',
  ///   parameters: {'button_name': 'submit', 'screen': 'login'},
  /// );
  /// ```
  static void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    if (!isAvailable) {
      if (kDebugMode) {
        debugPrint('⚠️ AnalyticsService: Google Analytics not available');
      }
      return;
    }

    try {
      final gtag = js.context['gtag'];
      if (gtag == null) {
        if (kDebugMode) {
          debugPrint('⚠️ AnalyticsService: gtag function not found');
        }
        return;
      }

      // Convert Dart Map to JavaScript object
      final jsParams = parameters != null ? _convertToJsObject(parameters) : null;

      if (jsParams != null) {
        gtag.apply(['event', eventName, jsParams]);
      } else {
        gtag.apply(['event', eventName]);
      }

      if (kDebugMode) {
        debugPrint('📊 Analytics: Tracked event "$eventName" ${parameters != null ? "with params: $parameters" : ""}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ AnalyticsService: Error tracking event "$eventName": $e');
      }
    }
  }

  /// Track a button click event
  /// 
  /// This is a convenience method that tracks button clicks with standardized parameters
  /// 
  /// Example:
  /// ```dart
  /// AnalyticsService.trackButtonClick(
  ///   buttonName: 'submit_form',
  ///   screenName: 'login_page',
  ///   additionalParams: {'form_type': 'login'},
  /// );
  /// ```
  static void trackButtonClick({
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

  /// Track a screen view/page view
  /// 
  /// Example:
  /// ```dart
  /// AnalyticsService.trackScreenView(
  ///   screenName: 'login_page',
  ///   parameters: {'user_type': 'new'},
  /// );
  /// ```
  static void trackScreenView({
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

