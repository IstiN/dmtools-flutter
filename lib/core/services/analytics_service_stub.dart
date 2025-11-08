import 'package:flutter/foundation.dart';

/// Stub implementation of AnalyticsService for non-web platforms
/// This file is used when dart:js is not available (mobile, desktop, tests)
class AnalyticsService {
  /// Track an event
  static void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Event "$eventName" ${parameters != null ? "with params: $parameters" : ""}');
    }
    // No-op on non-web platforms
  }

  /// Track a button click
  static void trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? additionalParams,
  }) {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Button click "$buttonName" on screen "${screenName ?? "unknown"}"');
    }
    // No-op on non-web platforms
  }

  /// Track a screen view
  static void trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Screen view "$screenName"');
    }
    // No-op on non-web platforms
  }

  /// Check if analytics is available
  static bool get isAvailable => false;
}

