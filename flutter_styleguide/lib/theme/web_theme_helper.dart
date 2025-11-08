// Web-specific helper for theme notifications
import 'package:flutter/foundation.dart';
import 'dart:html' as html;

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
