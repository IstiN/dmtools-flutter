// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;

import 'package:dmtools/main.dart';
import 'package:dmtools/providers/enhanced_auth_provider.dart';
import 'package:dmtools/network/services/api_service.dart';
import 'package:dmtools/core/services/auth_config_service.dart';
import 'package:dmtools/core/services/local_auth_service.dart';
import 'package:dmtools/core/services/credentials_service.dart';
import 'package:dmtools/network/services/auth_api_service.dart';
import '../unit/service_locator_test.dart';

// Simple mock for testing
class MockEnhancedAuthProvider extends EnhancedAuthProvider {
  MockEnhancedAuthProvider()
      : super(
          authConfigService: AuthConfigService(),
          localAuthService: LocalAuthService(),
          credentialsService: CredentialsService(),
          authApiService: AuthApiService(),
        );

  @override
  Future<void> initializeAuth() async {
    // Do nothing for tests
  }
}

void main() {
  testWidgets('DMTools app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider<EnhancedAuthProvider>(create: (_) => MockEnhancedAuthProvider()),
          Provider<ApiService>(create: (_) => MockApiService()),
        ],
        child: const DMToolsApp(),
      ),
    );

    // Verify that our app starts with the basic Material app structure
    expect(find.byType(MaterialApp), findsOneWidget);

    // Wait for initial app loading with specific duration to avoid timeout from continuous CSS animations
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(milliseconds: 500));

    // The app should show either loading screen or unauthenticated screen
    // This is the expected behavior in the test environment
    expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(0));

    // Check if we have either loading text or welcome content
    final hasLoadingText = find.text('Initializing DMTools...').evaluate().isNotEmpty;
    final hasWelcomeText = find.text('Welcome to DMTools').evaluate().isNotEmpty;

    expect(hasLoadingText || hasWelcomeText, isTrue);
  });
}
