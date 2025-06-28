import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/cards/feature_card.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Feature Card Golden Tests', () {
    goldenTest(
      'Feature Card - Light Mode',
      fileName: 'feature_card_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'feature_card_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildFeatureCard()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Feature Card - Dark Mode',
      fileName: 'feature_card_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'feature_card_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildFeatureCard(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildFeatureCard() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: FeatureCard(
        title: 'Sample Feature',
        description: 'This is a sample feature card that demonstrates the design system.',
        icon: Icons.star,
      ),
    ),
  );
}
