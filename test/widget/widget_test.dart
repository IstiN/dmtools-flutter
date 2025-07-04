// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dmtools/network/services/dm_tools_api_service_mock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;

import 'package:dmtools/main.dart';
import 'package:dmtools/providers/auth_provider.dart';

void main() {
  testWidgets('DMTools app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          Provider<DmToolsApiServiceMock>(create: (_) => DmToolsApiServiceMock()),
        ],
        child: const DMToolsApp(),
      ),
    );

    // Verify that our app starts with the basic Material app structure
    expect(find.byType(MaterialApp), findsOneWidget);

    // Wait for initial app loading with specific duration to avoid timeout from continuous CSS animations
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));

    // The app should show a loading screen during theme initialization
    // This is the expected behavior in the test environment
    expect(find.text('Loading DMTools...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
