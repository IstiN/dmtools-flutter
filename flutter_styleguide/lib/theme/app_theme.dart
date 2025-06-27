import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:google_fonts/google_fonts.dart'; // Unused
import 'app_colors.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;
  bool _isTestMode = false;
  bool _testDarkMode = false;

  bool get isDarkMode => _isTestMode ? _testDarkMode : _isDarkMode;
  bool get isTestMode => _isTestMode;
  bool get testDarkMode => _testDarkMode;
  ThemeMode get currentThemeMode => isDarkMode ? ThemeMode.dark : ThemeMode.light;
  ThemeData get currentTheme => isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
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
