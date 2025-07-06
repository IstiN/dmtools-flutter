import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'package:google_fonts/google_fonts.dart'; // Unused
import 'app_colors.dart';

// Web-only import for HTML messaging
// Conditional imports for web-only functionality
import 'web_theme_helper.dart' if (dart.library.io) 'stub_theme_helper.dart' as theme_helper;

enum ThemePreference {
  system,
  light,
  dark,
}

class ThemeProvider with ChangeNotifier {
  static const String _themePreferenceKey = 'theme_preference';

  bool _isDarkMode = false;
  bool _isTestMode = false;
  bool _testDarkMode = false;
  bool _isInitialized = false;
  ThemePreference _themePreference = ThemePreference.system;

  bool get isDarkMode => _isTestMode ? _testDarkMode : _isDarkMode;
  bool get isTestMode => _isTestMode;
  bool get testDarkMode => _testDarkMode;
  bool get isInitialized => _isInitialized;
  ThemePreference get themePreference => _themePreference;
  ThemeMode get currentThemeMode {
    switch (_themePreference) {
      case ThemePreference.light:
        return ThemeMode.light;
      case ThemePreference.dark:
        return ThemeMode.dark;
      case ThemePreference.system:
        return ThemeMode.system;
    }
  }

  ThemeData get currentTheme => isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  /// Initialize theme from saved preferences and system settings
  Future<void> initializeTheme() async {
    if (_isInitialized) return;

    debugPrint('ThemeProvider: Starting theme initialization...');

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedPreference = prefs.getString(_themePreferenceKey);

      debugPrint('ThemeProvider: Saved preference = $savedPreference');

      if (savedPreference != null) {
        // Load saved user preference
        _themePreference = ThemePreference.values.firstWhere(
          (e) => e.toString() == savedPreference,
          orElse: () => ThemePreference.system,
        );
        debugPrint('ThemeProvider: Using saved preference: $_themePreference');
      } else {
        // No saved preference, use system default
        _themePreference = ThemePreference.system;
        debugPrint('ThemeProvider: No saved preference, using system default');
      }

      // Update dark mode based on preference
      await _updateThemeFromPreference();

      debugPrint('ThemeProvider: Theme initialized - isDarkMode: $_isDarkMode, preference: $_themePreference');

      _isInitialized = true;

      // Notify HTML layer of initial theme
      _notifyHtmlThemeChange();

      notifyListeners();
    } catch (e) {
      // Fallback to system theme if there's an error
      debugPrint('Error initializing theme: $e');
      _themePreference = ThemePreference.system;
      await _updateThemeFromPreference();
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Update theme based on current preference
  Future<void> _updateThemeFromPreference() async {
    switch (_themePreference) {
      case ThemePreference.light:
        _isDarkMode = false;
        debugPrint('ThemeProvider: Set to light mode');
        break;
      case ThemePreference.dark:
        _isDarkMode = true;
        debugPrint('ThemeProvider: Set to dark mode');
        break;
      case ThemePreference.system:
        _isDarkMode = _getSystemTheme();
        debugPrint('ThemeProvider: Set to system mode, isDarkMode = $_isDarkMode');
        break;
    }
  }

  /// Get system theme preference
  bool _getSystemTheme() {
    try {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      final isDark = brightness == Brightness.dark;
      debugPrint('ThemeProvider: System brightness = $brightness, isDark = $isDark');

      return isDark;
    } catch (e) {
      // Fallback to light theme if system theme detection fails
      debugPrint('ThemeProvider: Error getting system theme: $e');
      return false;
    }
  }

  /// Toggle between light and dark themes (sets user preference)
  Future<void> toggleTheme() async {
    if (_isTestMode) return;

    // Toggle between light and dark (not system)
    if (_themePreference == ThemePreference.dark) {
      await setThemePreference(ThemePreference.light);
    } else {
      await setThemePreference(ThemePreference.dark);
    }
  }

  /// Set specific theme preference
  Future<void> setThemePreference(ThemePreference preference) async {
    if (_isTestMode) return;

    _themePreference = preference;
    await _updateThemeFromPreference();
    await _saveThemePreference();
    notifyListeners();
  }

  /// Save theme preference to local storage
  Future<void> _saveThemePreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePreferenceKey, _themePreference.toString());
      debugPrint('ThemeProvider: Saved preference: $_themePreference');

      // Notify HTML layer of theme change (web only)
      _notifyHtmlThemeChange();
    } catch (e) {
      debugPrint('ThemeProvider: Error saving theme preference: $e');
    }
  }

  /// Notify HTML layer about theme changes (web only)
  void _notifyHtmlThemeChange() {
    if (kIsWeb) {
      theme_helper.notifyHtmlThemeChange(_isDarkMode);
    }
  }

  /// Update theme when system theme changes (for system preference)
  Future<void> updateSystemTheme(Brightness systemBrightness) async {
    if (_themePreference == ThemePreference.system && !_isTestMode) {
      final newDarkMode = systemBrightness == Brightness.dark;
      if (_isDarkMode != newDarkMode) {
        _isDarkMode = newDarkMode;

        // Notify HTML layer of system theme change
        _notifyHtmlThemeChange();

        notifyListeners();
      }
    }
  }

  /// Reset to system theme
  Future<void> resetToSystemTheme() async {
    await setThemePreference(ThemePreference.system);
  }

  void setTestMode(bool isTestMode, {bool darkMode = false}) {
    _isTestMode = isTestMode;
    _testDarkMode = darkMode;
    notifyListeners();
  }
}

class AppTheme {
  static ThemeData lightTheme = _buildTheme(AppColors.light, Brightness.light);
  static ThemeData darkTheme = _buildTheme(AppColors.dark, Brightness.dark);

  static ThemeData _buildTheme(ThemeColorSet colors, Brightness brightness) {
    final baseTextTheme = _buildTextTheme(colors);

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: colors.bgColor,
      cardColor: colors.cardBg,
      dividerColor: colors.borderColor,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.accentColor,
        onPrimary: Colors.white,
        secondary: colors.accentColor,
        onSecondary: Colors.white,
        error: colors.dangerColor,
        onError: Colors.white,
        surface: colors.cardBg,
        onSurface: colors.textColor,
      ),
      textTheme: baseTextTheme,
      fontFamily: 'Inter',
      appBarTheme: AppBarTheme(
        backgroundColor: colors.bgColor,
        foregroundColor: colors.textColor,
        elevation: 0,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: colors.accentColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.accentColor,
          side: BorderSide(color: colors.accentColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.accentColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.inputBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.accentColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.dangerColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  static TextTheme _buildTextTheme(ThemeColorSet colors) {
    // Use local Inter font with exact sizes matching the web version
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32, // h1 size
        fontWeight: FontWeight.bold,
        color: colors.textColor,
      ),
      displayMedium: TextStyle(
        fontSize: 28, // h2 size
        fontWeight: FontWeight.bold,
        color: colors.textColor,
      ),
      displaySmall: TextStyle(
        fontSize: 24, // h3 size
        fontWeight: FontWeight.bold,
        color: colors.textColor,
      ),
      headlineLarge: TextStyle(
        fontSize: 20, // h4 size
        fontWeight: FontWeight.bold,
        color: colors.textColor,
      ),
      headlineMedium: TextStyle(
        fontSize: 16, // h5 size
        fontWeight: FontWeight.bold,
        color: colors.textColor,
      ),
      headlineSmall: TextStyle(
        fontSize: 14, // h6 size
        fontWeight: FontWeight.bold,
        color: colors.textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.textColor,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.textColor,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colors.textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16, // Standard paragraph
        color: colors.textColor,
        height: 1.6, // Match line-height: 1.6 from CSS
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: colors.textColor,
        height: 1.6,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        color: colors.textMuted,
        height: 1.6,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.textColor,
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: colors.textColor,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: colors.textMuted,
      ),
    );
  }
}

/// Extension to provide easy access to theme colors from any BuildContext
extension ThemeContext on BuildContext {
  /// Get theme colors without listening to changes (for non-reactive usage)
  ThemeColorSet get colors {
    try {
      final themeProvider = Provider.of<ThemeProvider>(this, listen: false);
      return themeProvider.isDarkMode ? AppColors.dark : AppColors.light;
    } catch (e) {
      // Fallback to theme-based colors if Provider is not available
      final brightness = Theme.of(this).brightness;
      return brightness == Brightness.dark ? AppColors.dark : AppColors.light;
    }
  }

  /// Get theme colors with listening to changes (for reactive usage)
  ThemeColorSet get colorsListening {
    try {
      final themeProvider = Provider.of<ThemeProvider>(this);
      return themeProvider.isDarkMode ? AppColors.dark : AppColors.light;
    } catch (e) {
      // Fallback to theme-based colors if Provider is not available
      final brightness = Theme.of(this).brightness;
      return brightness == Brightness.dark ? AppColors.dark : AppColors.light;
    }
  }

  /// Check if current theme is dark mode
  bool get isDarkMode {
    try {
      return Provider.of<ThemeProvider>(this, listen: false).isDarkMode;
    } catch (e) {
      return Theme.of(this).brightness == Brightness.dark;
    }
  }
}
