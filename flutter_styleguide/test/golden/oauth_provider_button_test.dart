import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/oauth_provider_button.dart';

void main() {
  group('OAuth Provider Button Tests', () {
    testWidgets('Google OAuth Button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: OAuthProviderButton(
                provider: OAuthProvider.google,
                text: 'Continue with Google',
                onPressed: () {},
                isTestMode: true,
                testDarkMode: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.byType(OAuthProviderButton), findsOneWidget);
    });

    testWidgets('Microsoft OAuth Button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: OAuthProviderButton(
                provider: OAuthProvider.microsoft,
                text: 'Continue with Microsoft',
                onPressed: () {},
                isTestMode: true,
                testDarkMode: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Continue with Microsoft'), findsOneWidget);
      expect(find.byType(OAuthProviderButton), findsOneWidget);
    });

    testWidgets('GitHub OAuth Button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: OAuthProviderButton(
                provider: OAuthProvider.github,
                text: 'Continue with GitHub',
                onPressed: () {},
                isTestMode: true,
                testDarkMode: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Continue with GitHub'), findsOneWidget);
      expect(find.byType(OAuthProviderButton), findsOneWidget);
    });

    testWidgets('Custom OAuth Button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: OAuthProviderButton(
                provider: OAuthProvider.custom,
                text: 'Custom OAuth Provider',
                onPressed: () {},
                isTestMode: true,
                testDarkMode: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom OAuth Provider'), findsOneWidget);
      expect(find.byType(OAuthProviderButton), findsOneWidget);
    });

    testWidgets('Disabled OAuth Button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: OAuthProviderButton(
                provider: OAuthProvider.google,
                text: 'Continue with Google',
                onPressed: () {},
                isDisabled: true,
                isTestMode: true,
                testDarkMode: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.byType(OAuthProviderButton), findsOneWidget);
    });

    testWidgets('Loading OAuth Button', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: OAuthProviderButton(
                provider: OAuthProvider.google,
                text: 'Continue with Google',
                onPressed: () {},
                isLoading: true,
                isTestMode: true,
                testDarkMode: false,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Continue with Google'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(OAuthProviderButton), findsOneWidget);
    });
  });
} 