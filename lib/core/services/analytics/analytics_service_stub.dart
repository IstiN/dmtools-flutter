import 'package:flutter/foundation.dart';
import 'analytics_provider.dart';

/// Stub analytics provider for platforms without analytics support
class StubAnalyticsProvider implements AnalyticsProvider {
  @override
  Future<void> initialize() async {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Initialized');
    }
  }

  @override
  bool get isAvailable => false;

  @override
  void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Event "$eventName" ${parameters != null ? "with params: $parameters" : ""}');
    }
  }

  @override
  void trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? additionalParams,
  }) {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Button click "$buttonName" on screen "${screenName ?? "unknown"}"');
    }
  }

  @override
  void trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Screen view "$screenName"');
    }
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Set user properties: $properties');
    }
  }

  @override
  void setUserId(String? userId) {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Set user ID: $userId');
    }
  }

  @override
  void clearUserData() {
    if (kDebugMode) {
      debugPrint('📊 Analytics (stub): Cleared user data');
    }
  }
}

