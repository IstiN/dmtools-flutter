import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/ai_integration_selector.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  setUpAll(() async {
    await helper.GoldenTestHelper.loadAppFonts();
  });

  group('AI Integration Selector Golden Tests', () {
    goldenTest(
      'AI Integration Selector - Light Mode',
      fileName: 'ai_integration_selector_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'ai_integration_selector_light',
            child: SizedBox(width: 400, height: 300, child: helper.createTestApp(_buildAiIntegrationSelector())),
          ),
        ],
      ),
    );

    goldenTest(
      'AI Integration Selector - Dark Mode',
      fileName: 'ai_integration_selector_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'ai_integration_selector_dark',
            child: SizedBox(
              width: 400,
              height: 300,
              child: helper.createTestApp(_buildAiIntegrationSelector(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'AI Integration Selector Empty State - Light Mode',
      fileName: 'ai_integration_selector_empty_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'ai_integration_selector_empty_light',
            child: SizedBox(width: 300, height: 200, child: helper.createTestApp(_buildEmptyAiIntegrationSelector())),
          ),
        ],
      ),
    );

    goldenTest(
      'AI Integration Selector Empty State - Dark Mode',
      fileName: 'ai_integration_selector_empty_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'ai_integration_selector_empty_dark',
            child: SizedBox(
              width: 300,
              height: 200,
              child: helper.createTestApp(_buildEmptyAiIntegrationSelector(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildAiIntegrationSelector() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('AI Integration Selector with Integrations'),
          const SizedBox(height: 16),
          AiIntegrationSelector(
            integrations: const [
              AiIntegration(id: '1', type: 'openai', displayName: 'OpenAI GPT-4'),
              AiIntegration(id: '2', type: 'gemini', displayName: 'Google Gemini'),
              AiIntegration(id: '3', type: 'openai', displayName: 'Claude 3.5', isActive: false),
            ],
            selectedIntegration: const AiIntegration(id: '1', type: 'openai', displayName: 'OpenAI GPT-4'),
            onIntegrationChanged: (integration) {
              // Handle integration change
            },
            isTestMode: true,
          ),
        ],
      ),
    ),
  );
}

Widget _buildEmptyAiIntegrationSelector() {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('AI Integration Selector - Empty State'),
          const SizedBox(height: 16),
          AiIntegrationSelector(
            integrations: const [],
            onIntegrationChanged: (integration) {
              // Handle integration change
            },
            isTestMode: true,
          ),
        ],
      ),
    ),
  );
}
