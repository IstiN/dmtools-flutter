import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/login_provider_selector.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Login Provider Selector Golden Tests', () {
    goldenTest(
      'Login Provider Selector - Light Mode',
      fileName: 'login_provider_selector_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'login_provider_selector_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildLoginProviderSelector()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Login Provider Selector - Dark Mode',
      fileName: 'login_provider_selector_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'login_provider_selector_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildLoginProviderSelector(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildLoginProviderSelector() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: LoginProviderSelector(),
      ),
    ),
  );
}
