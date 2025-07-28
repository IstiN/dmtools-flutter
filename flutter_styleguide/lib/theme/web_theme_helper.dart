// Web-specific helper for theme notifications
import 'dart:html' as html;

/// Notify HTML layer about theme changes (web only)
void notifyHtmlThemeChange(bool isDarkMode) {
  try {
    final themeString = isDarkMode ? 'dark' : 'light';
    html.window.postMessage({'type': 'flutter-theme-change', 'theme': themeString}, '*');
    print('ThemeProvider: Notified HTML of theme change: $themeString');
  } catch (e) {
    print('ThemeProvider: Error notifying HTML of theme change: $e');
  }
}
