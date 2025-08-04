import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  setUpAll(() async {
    await helper.GoldenTestHelper.loadAppFonts();
  });

  group('Webhook Components Golden Tests', () {
    goldenTest(
      'Webhook Key Item - Light Mode',
      fileName: 'webhook_key_item_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'webhook_key_item_light',
            child: SizedBox(width: 600, height: 300, child: helper.createTestApp(_buildWebhookKeyItem())),
          ),
        ],
      ),
    );

    goldenTest(
      'Webhook Key Item - Dark Mode',
      fileName: 'webhook_key_item_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'webhook_key_item_dark',
            child: SizedBox(
              width: 600,
              height: 300,
              child: helper.createTestApp(_buildWebhookKeyItem(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Webhook Key List With Keys - Light Mode',
      fileName: 'webhook_key_list_with_keys_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'webhook_key_list_with_keys_light',
            child: SizedBox(width: 800, height: 700, child: helper.createTestApp(_buildWebhookKeyListWithKeys())),
          ),
        ],
      ),
    );

    goldenTest(
      'Webhook Key List With Keys - Dark Mode',
      fileName: 'webhook_key_list_with_keys_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'webhook_key_list_with_keys_dark',
            child: SizedBox(
              width: 800,
              height: 700,
              child: helper.createTestApp(_buildWebhookKeyListWithKeys(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Webhook Key List Empty - Light Mode',
      fileName: 'webhook_key_list_empty_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'webhook_key_list_empty_light',
            child: SizedBox(width: 800, height: 400, child: helper.createTestApp(_buildWebhookKeyListEmpty())),
          ),
        ],
      ),
    );

    goldenTest(
      'Webhook Key List Empty - Dark Mode',
      fileName: 'webhook_key_list_empty_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'webhook_key_list_empty_dark',
            child: SizedBox(
              width: 800,
              height: 400,
              child: helper.createTestApp(_buildWebhookKeyListEmpty(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Webhook Examples Section - Light Mode',
      fileName: 'webhook_examples_section_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'webhook_examples_section_light',
            child: SizedBox(width: 1000, height: 900, child: helper.createTestApp(_buildWebhookExamplesSection())),
          ),
        ],
      ),
    );

    goldenTest(
      'Webhook Examples Section - Dark Mode',
      fileName: 'webhook_examples_section_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'webhook_examples_section_dark',
            child: SizedBox(
              width: 1000,
              height: 900,
              child: helper.createTestApp(_buildWebhookExamplesSection(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildWebhookKeyItem() {
  return Container(
    padding: const EdgeInsets.all(16),
    child: WebhookKeyItem(
      id: 'wh_test_123',
      name: 'Production API Key',
      description: 'Main production webhook key for CI/CD pipeline',
      maskedValue: 'wh_****************************abcd',
      createdAt: DateTime(2024, 1, 15, 10, 30),
      lastUsedAt: DateTime(2024, 1, 20, 14, 45),
      onCopy: () {},
      onDelete: () {},
    ),
  );
}

Widget _buildWebhookKeyListWithKeys() {
  final sampleKeys = [
    WebhookKeyItemData(
      id: 'wh_1',
      name: 'Production Key',
      description: 'Main production webhook key',
      maskedValue: 'wh_****************************abcd',
      createdAt: DateTime(2024, 1, 15, 10, 30),
      lastUsedAt: DateTime(2024, 1, 20, 14, 45),
    ),
    WebhookKeyItemData(
      id: 'wh_2',
      name: 'Development Key',
      description: 'Development environment webhook key',
      maskedValue: 'wh_****************************efgh',
      createdAt: DateTime(2024, 1, 10, 9, 15),
    ),
  ];

  return Container(
    padding: const EdgeInsets.all(16),
    child: WebhookKeyList(keys: sampleKeys, onCopyKey: (keyId) {}, onDeleteKey: (keyId) {}, onGenerateNew: () {}),
  );
}

Widget _buildWebhookKeyListEmpty() {
  return Container(
    padding: const EdgeInsets.all(16),
    child: WebhookKeyList(keys: const [], onCopyKey: (keyId) {}, onDeleteKey: (keyId) {}, onGenerateNew: () {}),
  );
}

Widget _buildWebhookExamplesSection() {
  return Container(
    padding: const EdgeInsets.all(16),
    child: const WebhookExamplesSection(
      jobConfigurationId: 'job_123',
      webhookUrl: 'https://api.dmtools.example.com/api/v1/job-configurations/job_123/webhook',
      sampleApiKey: 'wh_sample1234567890abcdef1234567890',
    ),
  );
}
