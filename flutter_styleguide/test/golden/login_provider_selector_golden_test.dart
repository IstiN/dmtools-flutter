import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/widgets/molecules/login_provider_selector.dart';

void main() {
  group('Login Provider Selector Tests', () {
    testWidgets('Login Provider Selector - Light Mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: Center(
              child: LoginProviderSelector(),
            ),
          ),
        ),
      );

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Choose your preferred login method'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Microsoft'), findsOneWidget);
      expect(find.text('Continue with GitHub'), findsOneWidget);
      expect(find.text('Custom OAuth Provider'), findsOneWidget);
    });

    testWidgets('Login Provider Selector - Dark Mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const Scaffold(
            body: Center(
              child: LoginProviderSelector(),
            ),
          ),
        ),
      );

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Choose your preferred login method'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Microsoft'), findsOneWidget);
      expect(find.text('Continue with GitHub'), findsOneWidget);
      expect(find.text('Custom OAuth Provider'), findsOneWidget);
    });

    testWidgets('Login Provider Selector - Custom Title', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          home: const Scaffold(
            body: Center(
              child: LoginProviderSelector(
                title: 'Sign In',
                subtitle: 'Select your authentication method',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Sign In'), findsOneWidget);
      expect(find.text('Select your authentication method'), findsOneWidget);
      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.text('Continue with Microsoft'), findsOneWidget);
      expect(find.text('Continue with GitHub'), findsOneWidget);
      expect(find.text('Custom OAuth Provider'), findsOneWidget);
    });
  });
} 