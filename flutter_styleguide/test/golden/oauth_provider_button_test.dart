import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/oauth_provider_button.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('OAuth Provider Button Golden Tests', () {
    goldenTest(
      'OAuth Google - Light Mode',
      fileName: 'oauth_google_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'oauth_google_light',
            child: SizedBox(
              width: 400,
              height: 200,
              child: helper.createTestApp(_buildGoogleButton()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'OAuth Google - Dark Mode',
      fileName: 'oauth_google_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'oauth_google_dark',
            child: SizedBox(
              width: 400,
              height: 200,
              child: helper.createTestApp(_buildGoogleButton(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'OAuth GitHub - Light Mode',
      fileName: 'oauth_github_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'oauth_github_light',
            child: SizedBox(
              width: 400,
              height: 200,
              child: helper.createTestApp(_buildGitHubButton()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'OAuth GitHub - Dark Mode',
      fileName: 'oauth_github_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'oauth_github_dark',
            child: SizedBox(
              width: 400,
              height: 200,
              child: helper.createTestApp(_buildGitHubButton(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'OAuth All Providers - Light Mode',
      fileName: 'oauth_all_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'oauth_all_light',
            child: SizedBox(
              width: 400,
              height: 300,
              child: helper.createTestApp(_buildAllProviders()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'OAuth All Providers - Dark Mode',
      fileName: 'oauth_all_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'oauth_all_dark',
            child: SizedBox(
              width: 400,
              height: 300,
              child: helper.createTestApp(_buildAllProviders(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildGitHubButton() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: OAuthProviderButton(
          provider: OAuthProvider.github,
          text: 'Continue with GitHub',
        ),
      ),
    ),
  );
}

Widget _buildGoogleButton() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: OAuthProviderButton(
          provider: OAuthProvider.google,
          text: 'Continue with Google',
        ),
      ),
    ),
  );
}

Widget _buildAllProviders() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OAuthProviderButton(
            provider: OAuthProvider.github,
            text: 'Continue with GitHub',
          ),
          SizedBox(height: 16),
          OAuthProviderButton(
            provider: OAuthProvider.google,
            text: 'Continue with Google',
          ),
          SizedBox(height: 16),
          OAuthProviderButton(
            provider: OAuthProvider.microsoft,
            text: 'Continue with Microsoft',
          ),
        ],
      ),
    ),
  );
}
