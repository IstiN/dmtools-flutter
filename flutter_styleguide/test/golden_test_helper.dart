import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';

/// Helper class for golden tests
class GoldenTestHelper {
  /// Setup fonts for testing
  static Future<void> loadAppFonts() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Disable runtime font fetching for tests
    GoogleFonts.config.allowRuntimeFetching = false;

    // Use system fonts for testing - no need to load assets
    // This ensures consistent rendering across test environments
  }

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

  static Future<void> _testWidgetInTheme({
    required WidgetTester tester,
    required String name,
    required Widget widget,
    required bool isDarkMode,
    double? width,
    double? height,
  }) async {
    final app = ChangeNotifierProvider(
      create: (_) => ThemeProvider()..setTestMode(true, darkMode: isDarkMode),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: themeProvider.isDarkMode
                ? AppTheme.darkTheme.scaffoldBackgroundColor
                : AppTheme.lightTheme.scaffoldBackgroundColor,
            body: SizedBox(
              width: width ?? 800,
              height: height ?? 600,
              child: widget,
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(app);
    await tester.pumpAndSettle(const Duration(seconds: 2));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/$name.png'),
    );
  }
}

/// Create a test app with proper theme setup
Widget createTestApp(Widget child, {bool darkMode = false}) {
  return ChangeNotifierProvider(
    create: (_) => ThemeProvider()..setTestMode(true, darkMode: darkMode),
    child: Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) => MaterialApp(
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        debugShowCheckedModeBanner: false,
        home: Material(
          color: themeProvider.isDarkMode
              ? AppTheme.darkTheme.scaffoldBackgroundColor
              : AppTheme.lightTheme.scaffoldBackgroundColor,
          child: child,
        ),
      ),
    ),
  );
}
