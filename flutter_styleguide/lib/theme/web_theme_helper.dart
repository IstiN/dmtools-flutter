// Web-specific helper for theme notifications
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

class WebThemeHelper {
  /// Get stored theme preference from localStorage
  static String? getStoredTheme() {
    try {
      // Use the same key as JavaScript: 'flutter.theme_preference'
      return html.window.localStorage['flutter.theme_preference'];
    } catch (e) {
      debugPrint('WebThemeHelper: Error reading localStorage: $e');
      return null;
    }
  }

  /// Get system theme preference
  static String getSystemTheme() {
    try {
      final prefersDark = html.window.matchMedia('(prefers-color-scheme: dark)').matches;
      return prefersDark ? 'dark' : 'light';
    } catch (e) {
      debugPrint('WebThemeHelper: Error reading system theme: $e');
      return 'light';
    }
  }
}

/// Notify HTML layer about theme changes (web only)
void notifyHtmlThemeChange(bool isDarkMode) {
  try {
    final themeString = isDarkMode ? 'dark' : 'light';
    html.window.postMessage({'type': 'flutter-theme-change', 'theme': themeString}, '*');
    debugPrint('ThemeProvider: Notified HTML of theme change: $themeString');
  } catch (e) {
    debugPrint('ThemeProvider: Error notifying HTML of theme change: $e');
  }
}
