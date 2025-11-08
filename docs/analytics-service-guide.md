# Analytics Service Guide

This guide explains how to use the extensible analytics service with enable/disable functionality and support for multiple platforms and providers.

## Overview

The analytics service has been redesigned to be:
- **Extensible**: Easy to add new analytics providers (Google Analytics, Mixpanel, Amplitude, etc.)
- **Configurable**: Enable/disable analytics at runtime
- **Multi-platform**: Supports web, macOS, and other platforms
- **Multi-provider**: Can use multiple analytics services simultaneously

## Architecture

```
AnalyticsService (convenience wrapper)
    ↓
AnalyticsManager (coordinates providers)
    ↓
AnalyticsProvider (interface)
    ├── GoogleAnalyticsProvider (web)
    ├── MacOSAnalyticsProvider (macOS)
    └── StubAnalyticsProvider (other platforms)
```

## Setup

### 1. Initialize Analytics

Call `initialize()` once at app startup (already done in `main.dart`):

```dart
import 'package:dmtools/core/services/analytics_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize analytics
  await AnalyticsService.initialize();
  
  runApp(MyApp());
}
```

### 2. Enable/Disable Analytics

Users can enable or disable analytics:

```dart
// Disable analytics
await AnalyticsService.setEnabled(false);

// Enable analytics
await AnalyticsService.setEnabled(true);

// Check if enabled
if (AnalyticsService.isEnabled) {
  print('Analytics is enabled');
}
```

The enabled state is persisted using `SharedPreferences`, so it persists across app restarts.

## Usage

### Track Button Clicks

```dart
import 'package:dmtools/core/services/analytics_service.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

PrimaryButton(
  text: 'Submit',
  onPressed: () {
    // Track the button click (only if analytics is enabled)
    AnalyticsService.trackButtonClick(
      buttonName: 'submit_form',
      screenName: 'login_page',
      additionalParams: {
        'form_type': 'login',
      },
    );
    
    // Your button logic
    _handleSubmit();
  },
)
```

### Track Custom Events

```dart
AnalyticsService.trackEvent(
  eventName: 'file_download',
  parameters: {
    'file_name': 'document.pdf',
    'file_type': 'pdf',
    'file_size': '2.5MB',
  },
);
```

### Track Screen Views

```dart
@override
void initState() {
  super.initState();
  
  AnalyticsService.trackScreenView(
    screenName: 'dashboard',
    parameters: {
      'user_role': 'admin',
    },
  );
}
```

### Set User Properties

```dart
// Set user properties when user logs in
AnalyticsService.setUserProperties({
  'user_type': 'premium',
  'subscription_tier': 'pro',
  'signup_date': '2024-01-01',
});
```

### Set User ID

```dart
// Set user ID when user logs in
AnalyticsService.setUserId('user123');

// Clear user ID on logout
AnalyticsService.setUserId(null);
// or
AnalyticsService.clearUserData();
```

## Platform Support

### Web Platform

- **Provider**: `GoogleAnalyticsProvider`
- **Service**: Google Analytics (gtag.js)
- **Measurement ID**: `G-SETFFT4EWQ`
- **Features**: Full Google Analytics tracking

### macOS Platform

- **Provider**: `MacOSAnalyticsProvider`
- **Service**: Local event logging (can be extended to send to backend)
- **Features**: 
  - Events stored locally
  - Can be synced to backend service
  - Debug logging in development

### Other Platforms

- **Provider**: `StubAnalyticsProvider`
- **Service**: No-op (logs to console in debug mode)
- **Features**: Safe to call, does nothing

## Adding Custom Providers

You can easily add support for additional analytics services:

### Example: Adding Mixpanel

```dart
import 'package:dmtools/core/services/analytics/analytics_provider.dart';
import 'package:dmtools/core/services/analytics_service.dart';

class MixpanelAnalyticsProvider implements AnalyticsProvider {
  @override
  Future<void> initialize() async {
    // Initialize Mixpanel SDK
  }

  @override
  bool get isAvailable => true; // Check if Mixpanel is available

  @override
  void trackEvent({
    required String eventName,
    Map<String, dynamic>? parameters,
  }) {
    // Send event to Mixpanel
    // mixpanel.track(eventName, properties: parameters);
  }

  // Implement other required methods...
}

// Add the provider
await AnalyticsService.addProvider(MixpanelAnalyticsProvider());
```

### Example: Adding Amplitude

```dart
class AmplitudeAnalyticsProvider implements AnalyticsProvider {
  // Implement AnalyticsProvider interface
  // ...
}

// Add multiple providers
await AnalyticsService.addProvider(GoogleAnalyticsProvider());
await AnalyticsService.addProvider(AmplitudeAnalyticsProvider());
```

When you call `AnalyticsService.trackEvent()`, it will send the event to **all** enabled providers automatically.

## Advanced Usage

### Access AnalyticsManager Directly

For advanced use cases, you can access the manager directly:

```dart
final manager = AnalyticsService.manager;

// Get all providers
final providers = manager.providers;

// Add/remove providers
await manager.addProvider(myCustomProvider);
manager.removeProvider(oldProvider);

// Check availability
if (manager.isAvailable) {
  // Analytics is available
}
```

### Conditional Tracking

```dart
// Only track if analytics is enabled and available
if (AnalyticsService.isEnabled && AnalyticsService.isAvailable) {
  AnalyticsService.trackEvent(
    eventName: 'premium_feature_used',
    parameters: {'feature': 'advanced_search'},
  );
}
```

### Error Handling

The analytics service handles errors gracefully. If one provider fails, others continue to work:

```dart
// Safe to call - errors are caught internally
AnalyticsService.trackButtonClick(
  buttonName: 'submit',
  screenName: 'form',
);
```

## Configuration

### Runtime Configuration

You can configure analytics via `RuntimeConfig` (for web) or environment variables:

```javascript
// web/config.js
window.dmtoolsConfig = {
  // ... other config
  enableAnalytics: true, // Can be added to config
};
```

### Compile-time Configuration

```bash
# Disable analytics at compile time
flutter build web --dart-define=enableAnalytics=false
```

## Best Practices

### 1. Initialize Early

Initialize analytics as early as possible in your app lifecycle:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AnalyticsService.initialize(); // Early initialization
  runApp(MyApp());
}
```

### 2. Respect User Privacy

Always provide a way for users to disable analytics:

```dart
// In settings screen
Switch(
  value: AnalyticsService.isEnabled,
  onChanged: (enabled) {
    AnalyticsService.setEnabled(enabled);
  },
  title: Text('Enable Analytics'),
)
```

### 3. Use Consistent Naming

- **Events**: Use snake_case (`button_click`, `form_submit`)
- **Parameters**: Use snake_case (`button_name`, `screen_name`)
- **Screen names**: Use descriptive names (`login_page`, `dashboard`)

### 4. Don't Track Sensitive Data

Never track:
- Passwords
- Credit card numbers
- Personal identification numbers
- Other sensitive user data

### 5. Batch Events (Future Enhancement)

For high-frequency events, consider batching:

```dart
// Future: Batch events for better performance
// AnalyticsService.trackEventBatch([event1, event2, event3]);
```

## Testing

### Debug Mode

In debug mode, all analytics calls are logged to the console:

```
📊 Analytics (stub): Button click "submit" on screen "login_page"
📊 GoogleAnalytics: Tracked event "button_click" with params: {...}
```

### Disable for Testing

```dart
// In tests, disable analytics
await AnalyticsService.setEnabled(false);

// Run your tests
// Analytics calls will be ignored
```

### Mock Providers

You can create mock providers for testing:

```dart
class MockAnalyticsProvider implements AnalyticsProvider {
  final List<Map<String, dynamic>> events = [];
  
  @override
  void trackEvent({required String eventName, Map<String, dynamic>? parameters}) {
    events.add({'event': eventName, 'params': parameters});
  }
  
  // Implement other methods...
}
```

## Troubleshooting

### Analytics Not Working

1. **Check initialization**: Make sure `AnalyticsService.initialize()` was called
2. **Check enabled state**: Verify `AnalyticsService.isEnabled` is `true`
3. **Check availability**: Verify `AnalyticsService.isAvailable` is `true`
4. **Check browser console**: Look for errors in the browser console (web)
5. **Check debug logs**: Enable debug mode to see analytics logs

### Events Not Appearing in Google Analytics

1. **Wait a few minutes**: There can be a delay in Google Analytics reporting
2. **Check Real-Time reports**: Use Google Analytics Real-Time to verify events
3. **Check ad blockers**: Ad blockers may block Google Analytics
4. **Verify Measurement ID**: Ensure `G-SETFFT4EWQ` is correct in `web/index.html`

### macOS Events Not Stored

The macOS provider stores events in memory by default. To persist them:

1. Implement JSON serialization in `MacOSAnalyticsProvider._storeEvents()`
2. Or extend the provider to send events to a backend service

## Migration from Old API

The new API is backward compatible. If you were using the old `AnalyticsService`, your code will continue to work:

```dart
// Old code (still works)
AnalyticsService.trackButtonClick(
  buttonName: 'submit',
  screenName: 'form',
);

// New code (same API, more features)
AnalyticsService.trackButtonClick(
  buttonName: 'submit',
  screenName: 'form',
);

// New features
await AnalyticsService.setEnabled(false);
await AnalyticsService.addProvider(myProvider);
```

## Future Enhancements

Potential future improvements:

1. **Event batching**: Batch events for better performance
2. **Offline support**: Queue events when offline, send when online
3. **Event filtering**: Filter events before sending
4. **Custom providers**: More built-in providers (Mixpanel, Amplitude, etc.)
5. **Analytics dashboard**: Built-in analytics dashboard in the app
6. **A/B testing**: Built-in A/B testing support

## References

- [Google Analytics Documentation](https://developers.google.com/analytics)
- [Analytics Best Practices](https://developers.google.com/analytics/devguides/collection/ga4/best-practices)
- [Flutter Web JavaScript Interop](https://dart.dev/guides/web/js-interop)

