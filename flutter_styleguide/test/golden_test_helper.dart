import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart' hide loadAppFonts;
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';

/// Helper class for golden tests
class GoldenTestHelper {
  /// Test a widget in both light and dark themes
  static Future<void> testWidgetInBothThemes({
    required WidgetTester tester,
    required String name,
    required Widget widget,
    double? width,
    double? height,
  }) async {
    // Create goldens directory if it doesn't exist
    final directory = Directory('test/goldens');
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    
    // Test in light theme
    await _testWidgetInTheme(
      tester: tester,
      name: '${name}_light',
      widget: widget,
      isDarkMode: false,
      width: width,
      height: height,
    );

    // Test in dark theme
    await _testWidgetInTheme(
      tester: tester,
      name: '${name}_dark',
      widget: widget,
      isDarkMode: true,
      width: width,
      height: height,
    );
  }
  
  /// Test a widget in a specific theme
  static Future<void> _testWidgetInTheme({
    required WidgetTester tester,
    required String name,
    required Widget widget,
    required bool isDarkMode,
    double? width,
    double? height,
  }) async {
    await tester.pumpWidget(
      _wrapWithTheme(
        Center(
          child: SizedBox(
            width: width,
            height: height,
            child: widget,
          ),
        ),
        isDarkMode: isDarkMode,
      ),
    );

    await screenMatchesGolden(tester, 'goldens/$name');
  }
  
  /// Create a device builder for testing multiple widgets at once
  static DeviceBuilder createDeviceBuilder({
    required List<Widget> widgets,
    required String name,
    required bool isDarkMode,
  }) {
    final deviceBuilder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: [
        Device.phone,
      ])
      ..addScenario(
        widget: _wrapWithTheme(
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widgets,
                  ),
                ),
              ],
            ),
          ),
          isDarkMode: isDarkMode,
        ),
        name: name,
      );

    return deviceBuilder;
  }

  static Widget _wrapWithTheme(Widget child, {required bool isDarkMode}) {
    final themeProvider = ThemeProvider();
    themeProvider.setTestMode(true, darkMode: isDarkMode);
    
    return MaterialApp(
      theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider<ThemeProvider>.value(
        value: themeProvider,
        child: Material(
          color: isDarkMode ? AppTheme.darkTheme.scaffoldBackgroundColor : AppTheme.lightTheme.scaffoldBackgroundColor,
          child: child,
        ),
      ),
    );
  }
}

/// Load app fonts for golden tests
Future<void> loadAppFonts() async {
  // This is a no-op for now, but you can implement font loading logic here if needed
  // The golden_toolkit's loadAppFonts() is not available in this version
}

/// Create a test app with the given child widget
Widget createTestApp(Widget child, {bool darkMode = false}) {
  final themeProvider = ThemeProvider();
  themeProvider.setTestMode(true, darkMode: darkMode);
  
  return MaterialApp(
    theme: darkMode 
        ? AppTheme.darkTheme
        : AppTheme.lightTheme,
    debugShowCheckedModeBanner: false,
    home: ChangeNotifierProvider<ThemeProvider>.value(
      value: themeProvider,
      child: Material(
        color: darkMode 
            ? AppTheme.darkTheme.scaffoldBackgroundColor 
            : AppTheme.lightTheme.scaffoldBackgroundColor,
        child: child,
      ),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void setTestMode(bool testMode, {required bool darkMode}) {
    _isDarkMode = darkMode;
    notifyListeners();
  }
} 