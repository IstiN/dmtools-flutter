import 'package:flutter/material.dart';
import '../../../widgets/organisms/integration_management.dart';
import '../../../widgets/molecules/integration_type_selector.dart';
import '../../../theme/app_dimensions.dart';

class IntegrationManagementPage extends StatelessWidget {
  const IntegrationManagementPage({super.key});

  // Sample integration types
  static const List<IntegrationType> _sampleTypes = [
    IntegrationType(
      type: 'github',
      displayName: 'GitHub',
      description: 'Connect to GitHub repositories',
      configParams: [
        ConfigParam(
          key: 'token',
          displayName: 'Personal Access Token',
          description: 'GitHub personal access token with repo access',
          required: true,
          sensitive: true,
          type: 'string',
          options: [],
        ),
      ],
    ),
    IntegrationType(
      type: 'slack',
      displayName: 'Slack',
      description: 'Send notifications to Slack',
      configParams: [
        ConfigParam(
          key: 'webhook_url',
          displayName: 'Webhook URL',
          description: 'Slack webhook URL',
          required: true,
          sensitive: true,
          type: 'string',
          options: [],
        ),
      ],
    ),
  ];

  // Sample integrations
  static final List<IntegrationData> _sampleIntegrations = [
    IntegrationData(
      id: '1',
      name: 'GitHub Integration',
      description: 'Connected to GitHub repositories',
      type: 'github',
      displayName: 'GitHub',
      enabled: true,
      usageCount: 42,
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      createdByName: 'John Doe',
      workspaces: const ['Development Team'],
      configParams: const {'token': 'ghp_example123'},
      lastUsedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    IntegrationData(
      id: '2',
      name: 'Slack Notifications',
      description: 'Send alerts to Slack channels',
      type: 'slack',
      displayName: 'Slack',
      enabled: false,
      usageCount: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      createdByName: 'Jane Smith',
      workspaces: const ['Marketing Team'],
      configParams: const {'webhook_url': 'https://hooks.slack.com/...'},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Integration Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: IntegrationManagement(
          integrations: _sampleIntegrations,
          availableTypes: _sampleTypes,
          onCreateIntegration: (type, config) {
            debugPrint('Creating integration: ${type.displayName} with config: $config');
          },
          onUpdateIntegration: (id, config) {
            debugPrint('Updating integration $id with config: $config');
          },
          onDeleteIntegration: (id) {
            debugPrint('Deleting integration: $id');
          },
          onEnableIntegration: (id) {
            debugPrint('Enabling integration: $id');
          },
          onDisableIntegration: (id) {
            debugPrint('Disabling integration: $id');
          },
          onTestIntegration: (id, config) {
            debugPrint('Testing integration $id with config: $config');
          },
        ),
      ),
    );
  }
}
