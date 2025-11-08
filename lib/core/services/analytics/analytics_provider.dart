/// Abstract base class for analytics providers
/// 
/// Implement this interface to add support for different analytics services
/// (Google Analytics, Mixpanel, Amplitude, etc.)
abstract class AnalyticsProvider {
  /// Initialize the analytics provider
  Future<void> initialize();

  /// Check if the provider is available and ready to use
  bool get isAvailable;

  /// Track an event
  /// 
  /// [eventName] - The name of the event
  /// [parameters] - Optional parameters to send with the event
  void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  });

  /// Track a button click event
  /// 
  /// [buttonName] - The name/identifier of the button
  /// [screenName] - The screen/page where the button is located
  /// [additionalParams] - Any additional parameters to track
  void trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? additionalParams,
  });

  /// Track a screen view/page view
  /// 
  /// [screenName] - The name of the screen/page being viewed
  /// [parameters] - Optional parameters to send with the screen view
  void trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  });

  /// Set user properties
  /// 
  /// [properties] - User properties to set
  void setUserProperties(Map<String, dynamic> properties);

  /// Set user ID
  /// 
  /// [userId] - The user ID to set
  void setUserId(String? userId);

  /// Clear user data (for logout)
  void clearUserData();
}

