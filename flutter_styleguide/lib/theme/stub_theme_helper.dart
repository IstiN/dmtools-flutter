// Stub helper for non-web platforms

class WebThemeHelper {
  /// Get stored theme preference from localStorage (stub)
  static String? getStoredTheme() {
    // No-op on non-web platforms
    return null;
  }

  /// Get system theme preference (stub)
  static String getSystemTheme() {
    // No-op on non-web platforms
    return 'light';
  }
}

/// Notify HTML layer about theme changes (stub for non-web platforms)
void notifyHtmlThemeChange(bool isDarkMode) {
  // No-op on non-web platforms
}
