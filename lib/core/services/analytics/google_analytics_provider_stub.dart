import 'analytics_provider.dart';

/// Stub implementation of GoogleAnalyticsProvider for non-web platforms
/// This file is used when dart:js is not available
class GoogleAnalyticsProvider implements AnalyticsProvider {
  @override
  Future<void> initialize() async {
    // No-op on non-web platforms
  }

  @override
  bool get isAvailable => false;

  @override
  void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    // No-op on non-web platforms
  }

  @override
  void trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? additionalParams,
  }) {
    // No-op on non-web platforms
  }

  @override
  void trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) {
    // No-op on non-web platforms
  }

  @override
  void setUserProperties(Map<String, dynamic> properties) {
    // No-op on non-web platforms
  }

  @override
  void setUserId(String? userId) {
    // No-op on non-web platforms
  }

  @override
  void clearUserData() {
    // No-op on non-web platforms
  }
}

