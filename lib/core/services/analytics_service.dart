import 'analytics/analytics_manager.dart';
import 'analytics/analytics_provider.dart';

export 'analytics/analytics_manager.dart';
export 'analytics/analytics_provider.dart';
// Don't export platform-specific providers directly - they're used internally by AnalyticsManager
// export 'analytics/google_analytics_provider.dart' if (dart.library.js) 'analytics/google_analytics_provider.dart';
// export 'analytics/macos_analytics_provider.dart';
// export 'analytics/analytics_service_stub.dart';

/// Convenience wrapper for AnalyticsManager
/// 
/// This provides a simple API that matches the original AnalyticsService
/// while using the new extensible AnalyticsManager under the hood.
/// 
/// Usage examples:
/// 
/// Initialize (call once at app startup):
/// ```dart
/// await AnalyticsService.initialize();
/// ```
/// 
/// Track a button click:
/// ```dart
/// AnalyticsService.trackButtonClick(
///   buttonName: 'submit_form',
///   screenName: 'login_page',
/// );
/// ```
/// 
/// Enable/disable analytics:
/// ```dart
/// await AnalyticsService.setEnabled(false); // Disable
/// await AnalyticsService.setEnabled(true);  // Enable
/// ```
class AnalyticsService {
  /// Initialize the analytics service
  /// 
  /// Call this once at app startup, typically in main() or app initialization
  static Future<void> initialize() async {
    await AnalyticsManager.instance.initialize();
  }

  /// Enable or disable analytics tracking
  /// 
  /// When disabled, all tracking calls are ignored
  static Future<void> setEnabled(bool enabled) async {
    await AnalyticsManager.instance.setEnabled(enabled);
  }

  /// Check if analytics is enabled
  static bool get isEnabled => AnalyticsManager.instance.isEnabled;

  /// Check if analytics is available
  static bool get isAvailable => AnalyticsManager.instance.isAvailable;

  /// Track an event using analytics
  /// 
  /// [eventName] - The name of the event (e.g., 'button_click', 'form_submit')
  /// [parameters] - Optional parameters to send with the event
  static void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    AnalyticsManager.instance.trackEvent(
      eventName: eventName,
      parameters: parameters,
    );
  }

  /// Track a button click event
  /// 
  /// This is a convenience method that tracks button clicks with standardized parameters.
  /// The event will be tracked as 'button_click' with 'button_name' and optional 'screen_name'.
  /// 
  /// [buttonName] - The name/identifier of the button (required)
  /// [screenName] - The screen/page where the button is located (optional)
  /// [additionalParams] - Any additional parameters to track (optional)
  static void trackButtonClick({
    required String buttonName,
    String? screenName,
    Map<String, dynamic>? additionalParams,
  }) {
    AnalyticsManager.instance.trackButtonClick(
      buttonName: buttonName,
      screenName: screenName,
      additionalParams: additionalParams,
    );
  }

  /// Track a screen view/page view
  /// 
  /// [screenName] - The name of the screen/page being viewed
  /// [parameters] - Optional parameters to send with the screen view
  static void trackScreenView({
    required String screenName,
    Map<String, dynamic>? parameters,
  }) {
    AnalyticsManager.instance.trackScreenView(
      screenName: screenName,
      parameters: parameters,
    );
  }

  /// Set user properties
  /// 
  /// [properties] - User properties to set
  static void setUserProperties(Map<String, dynamic> properties) {
    AnalyticsManager.instance.setUserProperties(properties);
  }

  /// Set user ID
  /// 
  /// [userId] - The user ID to set
  static void setUserId(String? userId) {
    AnalyticsManager.instance.setUserId(userId);
  }

  /// Clear user data (for logout)
  static void clearUserData() {
    AnalyticsManager.instance.clearUserData();
  }

  /// Add a custom analytics provider
  /// 
  /// Useful for adding additional providers like Mixpanel, Amplitude, etc.
  static Future<void> addProvider(AnalyticsProvider provider) async {
    await AnalyticsManager.instance.addProvider(provider);
  }

  /// Get the analytics manager instance (for advanced usage)
  static AnalyticsManager get manager => AnalyticsManager.instance;
}
