import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:provider/provider.dart';
import '../../widgets/atoms/integration_type_icon.dart';
import '../../widgets/atoms/sensitive_field_input.dart';
import '../../widgets/atoms/integration_status_badge.dart';
import '../../widgets/molecules/integration_card.dart';
import '../../widgets/molecules/integration_type_selector.dart';
import '../../widgets/molecules/integration_config_form.dart';
import '../../widgets/organisms/integration_management.dart';

class IntegrationsPage extends StatefulWidget {
  const IntegrationsPage({super.key});

  @override
  State<IntegrationsPage> createState() => _IntegrationsPageState();
}

class _IntegrationsPageState extends State<IntegrationsPage> {
  IntegrationType? _selectedType;
  Map<String, String> _configValues = {};
  bool _isLoading = false;
  String? _testResult;

  // Sample data for demos
  final List<IntegrationType> _sampleIntegrationTypes = [
    const IntegrationType(
      type: 'github',
      displayName: 'GitHub',
      description: 'Connect to GitHub repositories for code management and automation',
      configParams: [
        ConfigParam(
          key: 'access_token',
          displayName: 'Personal Access Token',
          description: 'GitHub personal access token with required permissions',
          required: true,
          sensitive: true,
          type: 'string',
          options: [],
        ),
        ConfigParam(
          key: 'organization',
          displayName: 'Organization',
          description: 'GitHub organization (optional)',
          required: false,
          sensitive: false,
          type: 'string',
          options: [],
        ),
      ],
    ),
    const IntegrationType(
      type: 'slack',
      displayName: 'Slack',
      description: 'Send notifications and interact with Slack workspaces',
      configParams: [
        ConfigParam(
          key: 'bot_token',
          displayName: 'Bot User OAuth Token',
          description: 'Slack bot token starting with xoxb-',
          required: true,
          sensitive: true,
          type: 'string',
          options: [],
        ),
        ConfigParam(
          key: 'channel',
          displayName: 'Default Channel',
          description: 'Default channel for notifications',
          required: false,
          sensitive: false,
          type: 'string',
          options: [],
        ),
      ],
    ),
    const IntegrationType(
      type: 'google',
      displayName: 'Google Cloud',
      description: 'Integrate with Google Cloud Platform services',
      configParams: [
        ConfigParam(
          key: 'api_key',
          displayName: 'API Key',
          description: 'Google Cloud API key',
          required: true,
          sensitive: true,
          type: 'string',
          options: [],
        ),
        ConfigParam(
          key: 'project_id',
          displayName: 'Project ID',
          description: 'Google Cloud project identifier',
          required: true,
          sensitive: false,
          type: 'string',
          options: [],
        ),
        ConfigParam(
          key: 'region',
          displayName: 'Region',
          description: 'Default region for resources',
          required: false,
          sensitive: false,
          type: 'select',
          options: ['us-central1', 'us-east1', 'europe-west1', 'asia-southeast1'],
        ),
      ],
    ),
    const IntegrationType(
      type: 'webhook',
      displayName: 'Webhook',
      description: 'Send HTTP requests to external services',
      configParams: [
        ConfigParam(
          key: 'url',
          displayName: 'Webhook URL',
          description: 'The endpoint URL to send requests to',
          required: true,
          sensitive: false,
          type: 'string',
          options: [],
        ),
        ConfigParam(
          key: 'secret',
          displayName: 'Secret Key',
          description: 'Secret for authenticating webhook requests',
          required: false,
          sensitive: true,
          type: 'string',
          options: [],
        ),
      ],
    ),
  ];

  final List<IntegrationData> _sampleIntegrations = [
    IntegrationData(
      id: '1',
      name: 'GitHub Production',
      description: 'Main GitHub integration for production repositories',
      type: 'github',
      displayName: 'GitHub',
      enabled: true,
      usageCount: 152,
      lastUsedAt: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      createdByName: 'John Doe',
      workspaces: ['Production', 'Staging'],
      configParams: {
        'access_token': 'ghp_xxxxxxxxxxxx',
        'organization': 'my-company',
      },
    ),
    IntegrationData(
      id: '2',
      name: 'Team Slack',
      description: 'Slack integration for development team notifications',
      type: 'slack',
      displayName: 'Slack',
      enabled: true,
      usageCount: 89,
      lastUsedAt: DateTime.now().subtract(const Duration(minutes: 15)),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      createdByName: 'Jane Smith',
      workspaces: ['Development'],
      configParams: {
        'bot_token': 'xoxb-xxxxxxxxxxxx',
        'channel': '#general',
      },
    ),
    IntegrationData(
      id: '3',
      name: 'Analytics Webhook',
      description: 'Webhook for sending analytics data to external system',
      type: 'webhook',
      displayName: 'Webhook',
      enabled: false,
      usageCount: 23,
      lastUsedAt: DateTime.now().subtract(const Duration(days: 7)),
      createdAt: DateTime.now().subtract(const Duration(days: 7)),
      createdByName: 'Mike Johnson',
      workspaces: ['Analytics'],
      configParams: {
        'url': 'https://api.example.com/webhook',
        'secret': 'webhook_secret_key',
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        Text(
          'Integration Components',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'Components for managing external service integrations with comprehensive configuration, testing, and management capabilities.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: AppDimensions.spacingL),

        // Atoms Section
        ComponentDisplay(
          title: 'Atoms - Basic Elements',
          description: 'Fundamental building blocks for integration interfaces',
          child: Column(
            children: [
              ComponentItem(
                title: 'Integration Type Icons',
                child: Wrap(
                  spacing: AppDimensions.spacingM,
                  runSpacing: AppDimensions.spacingM,
                  children: [
                    _buildIconDemo('GitHub', 'github'),
                    _buildIconDemo('Slack', 'slack'),
                    _buildIconDemo('Google', 'google'),
                    _buildIconDemo('Microsoft', 'microsoft'),
                    _buildIconDemo('Webhook', 'webhook'),
                    _buildIconDemo('Database', 'database'),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Integration Status Badges',
                child: Wrap(
                  spacing: AppDimensions.spacingM,
                  runSpacing: AppDimensions.spacingS,
                  children: [
                    IntegrationStatusBadge(
                      status: IntegrationStatus.enabled,
                      isTestMode: true,
                      testDarkMode: context.isDarkMode,
                    ),
                    IntegrationStatusBadge(
                      status: IntegrationStatus.disabled,
                      isTestMode: true,
                      testDarkMode: context.isDarkMode,
                    ),
                    IntegrationStatusBadge(
                      status: IntegrationStatus.error,
                      isTestMode: true,
                      testDarkMode: context.isDarkMode,
                    ),
                    IntegrationStatusBadge(
                      status: IntegrationStatus.testing,
                      isTestMode: true,
                      testDarkMode: context.isDarkMode,
                    ),
                    IntegrationStatusBadge(
                      status: IntegrationStatus.connected,
                      isTestMode: true,
                      testDarkMode: context.isDarkMode,
                    ),
                    IntegrationStatusBadge(
                      status: IntegrationStatus.disconnected,
                      isTestMode: true,
                      testDarkMode: context.isDarkMode,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Sensitive Field Input',
                child: SizedBox(
                  width: 400,
                  child: SensitiveFieldInput(
                    placeholder: 'Enter API key or token',
                    isTestMode: true,
                    testDarkMode: context.isDarkMode,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spacingXl),

        // Molecules Section
        ComponentDisplay(
          title: 'Molecules - Component Groups',
          description: 'Combined components for specific integration workflows',
          child: Column(
            children: [
              ComponentItem(
                title: 'Integration Cards',
                child: Column(
                  children: _sampleIntegrations
                      .take(2)
                      .map((integration) => Padding(
                            padding: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                            child: IntegrationCard(
                              id: integration.id,
                              name: integration.name,
                              description: integration.description,
                              type: integration.type,
                              displayName: integration.displayName,
                              enabled: integration.enabled,
                              iconUrl: integration.iconUrl,
                              usageCount: integration.usageCount,
                              lastUsedAt: integration.lastUsedAt,
                              createdAt: integration.createdAt,
                              createdByName: integration.createdByName,
                              workspaces: integration.workspaces,
                              onEnable: () => _showActionDialog('Enable ${integration.name}'),
                              onDisable: () => _showActionDialog('Disable ${integration.name}'),
                              onTest: () => _showActionDialog('Test ${integration.name}'),
                              onEdit: () => _showActionDialog('Edit ${integration.name}'),
                              onDelete: () => _showActionDialog('Delete ${integration.name}'),
                              onShare: () => _showActionDialog('Share ${integration.name}'),
                              isTestMode: true,
                              testDarkMode: context.isDarkMode,
                            ),
                          ))
                      .toList(),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Integration Type Selector',
                child: IntegrationTypeSelector(
                  integrationTypes: _sampleIntegrationTypes,
                  selectedType: _selectedType,
                  onTypeSelected: (type) {
                    setState(() {
                      _selectedType = type;
                      _configValues.clear();
                    });
                  },
                  isTestMode: true,
                  testDarkMode: context.isDarkMode,
                ),
              ),
              if (_selectedType != null) ...[
                const SizedBox(height: AppDimensions.spacingL),
                ComponentItem(
                  title: 'Configuration Form',
                  child: IntegrationConfigForm(
                    integrationType: _selectedType!,
                    initialValues: _configValues,
                    onConfigChanged: (values) {
                      setState(() {
                        _configValues = values;
                      });
                    },
                    onTestConnection: () {
                      setState(() {
                        _isLoading = true;
                        _testResult = null;
                      });
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                            _testResult = 'Connection successful';
                          });
                        }
                      });
                    },
                    isLoading: _isLoading,
                    testResult: _testResult,
                    isTestMode: true,
                    testDarkMode: context.isDarkMode,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.spacingXl),

        // Organisms Section
        ComponentDisplay(
          title: 'Organisms - Complete Interfaces',
          description: 'Full-featured integration management interfaces',
          child: ComponentItem(
            title: 'Integration Management Interface',
            child: Container(
              height: 600,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              ),
              child: IntegrationManagement(
                integrations: _sampleIntegrations,
                availableTypes: _sampleIntegrationTypes,
                onCreateIntegration: (type, config) => _showActionDialog('Create ${type.displayName} integration'),
                onUpdateIntegration: (id, config) => _showActionDialog('Update integration $id'),
                onDeleteIntegration: (id) => _showActionDialog('Delete integration $id'),
                onEnableIntegration: (id) => _showActionDialog('Enable integration $id'),
                onDisableIntegration: (id) => _showActionDialog('Disable integration $id'),
                onTestIntegration: (id, config) => _showActionDialog('Test integration $id'),
                isTestMode: true,
                testDarkMode: context.isDarkMode,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppDimensions.spacingXl),

        // Implementation Guide
        ComponentDisplay(
          title: 'Implementation Guide',
          description: 'How to implement integration components in your application',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Key Features:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              ..._buildFeatureList([
                'Dynamic configuration forms based on integration type schema',
                'Secure handling of sensitive credentials with masked inputs',
                'Built-in connection testing with visual feedback',
                'Comprehensive integration management with CRUD operations',
                'Clear setup instructions for each integration type',
                'Status tracking and usage analytics',
                'Workspace sharing and permission management',
              ]),
              const SizedBox(height: AppDimensions.spacingM),
              Text(
                'Usage Example:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  border: Border.all(color: Theme.of(context).dividerColor),
                ),
                child: Text(
                  '''// Display integration management interface
IntegrationManagement(
  integrations: userIntegrations,
  availableTypes: supportedTypes,
  onCreateIntegration: (type, config) async {
    final integration = await apiService.createIntegration(type, config);
    // Handle success
  },
  onTestIntegration: (id, config) async {
    final result = await apiService.testIntegration(id, config);
    // Show test results
  },
)''',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIconDemo(String label, String type) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Column(
      children: [
        IntegrationTypeIcon(
          integrationType: type,
          size: 32,
          isTestMode: true,
          testDarkMode: isDarkMode,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  List<Widget> _buildFeatureList(List<String> features) {
    return features
        .map((feature) => Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ', style: Theme.of(context).textTheme.bodyMedium),
                  Expanded(
                    child: Text(feature, style: Theme.of(context).textTheme.bodyMedium),
                  ),
                ],
              ),
            ))
        .toList();
  }

  void _showActionDialog(String action) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Action Triggered'),
        content: Text(action),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
