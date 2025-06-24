import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/widgets/molecules/cards/feature_card.dart';
import 'package:dmtools_styleguide/theme/app_colors.dart';

void main() {
  group('Feature Card Tests', () {
    testWidgets('Feature Card - Light Mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light().copyWith(
            primaryColor: AppColors.light.accentColor,
          ),
          home: Scaffold(
            body: Center(
              child: FeatureCard(
                icon: Icons.smart_toy,
                title: 'AI-Powered Agents',
                description: 'Automate repetitive tasks with intelligent agents that learn from your workflow',
                isTestMode: true,
                testDarkMode: false,
              ),
            ),
          ),
        ),
      );

      // Verify the card renders correctly
      expect(find.text('AI-Powered Agents'), findsOneWidget);
      expect(find.text('Automate repetitive tasks with intelligent agents that learn from your workflow'), findsOneWidget);
      expect(find.byIcon(Icons.smart_toy), findsOneWidget);
    });

    testWidgets('Feature Card - Dark Mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark().copyWith(
            primaryColor: AppColors.dark.accentColor,
          ),
          home: Scaffold(
            body: Center(
              child: FeatureCard(
                icon: Icons.smart_toy,
                title: 'AI-Powered Agents',
                description: 'Automate repetitive tasks with intelligent agents that learn from your workflow',
                isTestMode: true,
                testDarkMode: true,
              ),
            ),
          ),
        ),
      );

      // Verify the card renders correctly
      expect(find.text('AI-Powered Agents'), findsOneWidget);
      expect(find.text('Automate repetitive tasks with intelligent agents that learn from your workflow'), findsOneWidget);
      expect(find.byIcon(Icons.smart_toy), findsOneWidget);
    });
  });
} 