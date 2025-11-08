# Google Analytics Integration Guide

This guide explains how to track button clicks and events in your Flutter web application using Google Analytics.

## Overview

The `AnalyticsService` provides a simple API to track user interactions, button clicks, and screen views. It automatically uses the web implementation on web platforms and a stub (no-op) implementation on mobile/desktop platforms.

## Setup

Google Analytics has already been added to your HTML files:
- `web/index.html` - Main app
- `flutter_styleguide/web/index.html` - Styleguide

The Google Analytics Measurement ID is: `G-SETFFT4EWQ`

## Usage

### Import the Service

```dart
import 'package:dmtools/core/services/analytics_service.dart';
```

### Track Button Clicks

The easiest way to track button clicks is using the `trackButtonClick` method:

```dart
import 'package:dmtools/core/services/analytics_service.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

// Example: Track a submit button click
PrimaryButton(
  text: 'Submit',
  onPressed: () {
    // Track the button click
    AnalyticsService.trackButtonClick(
      buttonName: 'submit_form',
      screenName: 'login_page',
      additionalParams: {
        'form_type': 'login',
        'user_type': 'new',
      },
    );
    
    // Your button logic here
    submitForm();
  },
)
```

### Track Custom Events

For more complex tracking, use `trackEvent`:

```dart
// Track a custom event
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

Track when users navigate to different screens:

```dart
// In your screen's initState or build method
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

## Examples

### Example 1: Login Button

```dart
PrimaryButton(
  text: 'Sign In',
  onPressed: () {
    AnalyticsService.trackButtonClick(
      buttonName: 'sign_in',
      screenName: 'login_page',
    );
    
    // Perform login
    _performLogin();
  },
)
```

### Example 2: Navigation Button

```dart
SecondaryButton(
  text: 'Go to Dashboard',
  onPressed: () {
    AnalyticsService.trackButtonClick(
      buttonName: 'navigate_to_dashboard',
      screenName: 'home_page',
    );
    
    // Navigate
    context.go('/dashboard');
  },
)
```

### Example 3: Form Submission

```dart
PrimaryButton(
  text: 'Create Account',
  onPressed: () {
    AnalyticsService.trackButtonClick(
      buttonName: 'create_account',
      screenName: 'signup_page',
      additionalParams: {
        'form_completion': '100%',
        'validation_passed': 'true',
      },
    );
    
    // Submit form
    _submitForm();
  },
)
```

### Example 4: Delete Action

```dart
TextButton(
  text: 'Delete',
  onPressed: () {
    AnalyticsService.trackEvent(
      eventName: 'delete_action',
      parameters: {
        'item_type': 'agent',
        'item_id': agentId,
        'confirmation': 'confirmed',
      },
    );
    
    // Delete item
    _deleteAgent(agentId);
  },
)
```

## Best Practices

### Button Naming Convention

Use descriptive, consistent names:
- ✅ `submit_form`, `cancel_form`, `save_settings`
- ❌ `btn1`, `click`, `button`

### Screen Naming Convention

Use clear screen identifiers:
- ✅ `login_page`, `dashboard`, `settings_page`
- ❌ `screen1`, `page`, `view`

### Parameter Naming

Use snake_case for parameter names:
- ✅ `user_id`, `form_type`, `file_size`
- ❌ `userId`, `formType`, `fileSize`

## Viewing Analytics Data

1. Go to [Google Analytics](https://analytics.google.com)
2. Select your property (DMTools)
3. Navigate to **Reports** → **Engagement** → **Events**
4. Look for events like:
   - `button_click` - All button clicks
   - `page_view` - Screen views
   - Custom events you've defined

### Event Parameters

In Google Analytics, you can see:
- **Event name**: e.g., `button_click`
- **Event parameters**: 
  - `button_name`: The name of the button clicked
  - `screen_name`: The screen where the click occurred
  - Any additional parameters you provided

## Testing

### Debug Mode

In debug mode, the service will log events to the console:
- Web: Events are sent to Google Analytics
- Mobile/Desktop: Events are logged to console (stub implementation)

### Verify Tracking

1. Open your app in Chrome
2. Open Chrome DevTools (F12)
3. Go to **Network** tab
4. Filter by `google-analytics.com` or `googletagmanager.com`
5. Click a button you're tracking
6. You should see a request to Google Analytics

### Real-Time Testing

1. Go to Google Analytics
2. Navigate to **Reports** → **Realtime**
3. Perform actions in your app
4. You should see events appear within a few seconds

## Platform Support

- ✅ **Web**: Full Google Analytics tracking
- ✅ **Mobile/Desktop**: Stub implementation (logs to console in debug mode)

The service automatically detects the platform and uses the appropriate implementation.

## Troubleshooting

### Events Not Appearing

1. **Check Google Analytics is loaded**:
   ```dart
   if (AnalyticsService.isAvailable) {
     print('Analytics is available');
   } else {
     print('Analytics not available');
   }
   ```

2. **Check browser console** for errors

3. **Verify Measurement ID** is correct in `web/index.html`

4. **Check ad blockers** - They may block Google Analytics

5. **Wait a few minutes** - There can be a delay in Google Analytics reporting

### Common Issues

- **Events not tracked**: Make sure you're on web platform (not mobile/desktop)
- **Wrong data**: Check parameter names and values
- **Too many events**: Consider throttling or batching events

## Advanced Usage

### Conditional Tracking

```dart
if (AnalyticsService.isAvailable) {
  AnalyticsService.trackButtonClick(
    buttonName: 'premium_feature',
    screenName: 'dashboard',
  );
}
```

### Tracking with Error Handling

```dart
try {
  AnalyticsService.trackEvent(
    eventName: 'critical_action',
    parameters: {'action': 'delete_all'},
  );
} catch (e) {
  // Don't let analytics errors break your app
  debugPrint('Analytics error: $e');
}
```

## References

- [Google Analytics Documentation](https://developers.google.com/analytics)
- [Google Analytics Events](https://developers.google.com/analytics/devguides/collection/ga4/events)
- [Flutter Web JavaScript Interop](https://dart.dev/guides/web/js-interop)

