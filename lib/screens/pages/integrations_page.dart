import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../providers/integration_provider.dart';
import '../../core/services/integration_service.dart';
import '../../core/pages/authenticated_page.dart';

class IntegrationsPage extends StatefulWidget {
  const IntegrationsPage({super.key});

  @override
  State<IntegrationsPage> createState() => _IntegrationsPageState();
}

class _IntegrationsPageState extends AuthenticatedPage<IntegrationsPage> {
  @override
  String get loadingMessage => 'Loading integrations...';

  @override
  String get errorTitle => 'Error loading integrations';

  @override
  String get emptyTitle => 'No integrations found';

  @override
  String get emptyMessage => 'Create your first integration to get started';

  @override
  bool get requiresIntegrations => true;

  @override
  Future<void> loadAuthenticatedData() async {
    print('🔧 IntegrationsPage: Loading integrations...');

    final integrations = await authService.executeWithIntegrations(() async {
      final integrationProvider = context.read<IntegrationProvider>();
      // Don't call refresh() - executeWithIntegrations already loaded them
      return integrationProvider.integrations;
    });

    print('🔧 IntegrationsPage: Loaded ${integrations.length} integrations');

    if (integrations.isEmpty) {
      setEmpty();
    } else {
      setLoaded();
    }
  }

  @override
  Widget buildAuthenticatedContent(BuildContext context) {
    return Consumer<IntegrationProvider>(
      builder: (context, integrationProvider, child) {
        print(
            '🔧 IntegrationsPage: Building authenticated content with ${integrationProvider.integrations.length} integrations');

        // Convert models for styleguide compatibility
        final integrationDataList = _convertIntegrationsToStyleguideFormat(integrationProvider.integrations);
        final integrationTypesList = _convertIntegrationTypesToStyleguideFormat(integrationProvider.availableTypes);

        return IntegrationManagement(
          integrations: integrationDataList,
          availableTypes: integrationTypesList,
          onCreateIntegration: (integrationType, name, configParams) => _handleCreateIntegration(
            integrationProvider,
            integrationType,
            name,
            configParams,
          ),
          onUpdateIntegration: (integrationId, name, configParams) => _handleUpdateIntegration(
            integrationProvider,
            integrationId,
            name,
            configParams,
          ),
          onDeleteIntegration: (integrationId) => _handleDeleteIntegration(
            integrationProvider,
            integrationId,
          ),
          onEnableIntegration: (integrationId) => _handleEnableIntegration(
            integrationProvider,
            integrationId,
          ),
          onDisableIntegration: (integrationId) => _handleDisableIntegration(
            integrationProvider,
            integrationId,
          ),
          onTestIntegration: (integrationId, configParams) => _handleTestIntegration(
            integrationProvider,
            integrationId,
            configParams,
          ),
          onGetIntegrationDetails: (integrationId) => _handleGetIntegrationDetails(
            integrationProvider,
            integrationId,
          ),
        );
      },
    );
  }

  // Convert our IntegrationModel list to styleguide IntegrationData list
  List<IntegrationData> _convertIntegrationsToStyleguideFormat(List<IntegrationModel> integrations) {
    return integrations.map((integration) {
      return IntegrationData(
        id: integration.id,
        name: integration.name,
        description: integration.description,
        type: integration.type,
        displayName: _getDisplayNameForType(integration.type),
        enabled: integration.enabled,
        iconUrl: _getIconUrlForType(integration.type),
        usageCount: integration.usageCount,
        lastUsedAt: integration.lastUsedAt,
        createdAt: integration.createdAt ?? DateTime.now(),
        createdByName: integration.createdByName ?? 'Unknown User',
        workspaces: integration.workspaces.map((w) => w.name).toList(),
        configParams: Map.fromEntries(
          integration.configParams.map((config) => MapEntry(config.paramKey, config.paramValue)),
        ),
      );
    }).toList();
  }

  // Convert our IntegrationTypeModel list to styleguide IntegrationType list
  List<IntegrationType> _convertIntegrationTypesToStyleguideFormat(List<IntegrationTypeModel> types) {
    return types.map((type) {
      return IntegrationType(
        type: type.type,
        displayName: type.displayName,
        description: type.description,
        iconUrl: type.iconUrl,
        configParams: type.configParams.map((param) {
          return ConfigParam(
            key: param.key,
            displayName: param.displayName,
            description: param.description,
            required: param.required,
            sensitive: param.sensitive,
            defaultValue: param.defaultValue,
            type: param.type,
            options: param.options,
          );
        }).toList(),
      );
    }).toList();
  }

  // Helper methods for integration display
  String _getDisplayNameForType(String type) {
    switch (type.toLowerCase()) {
      case 'jira':
        return 'Jira';
      case 'confluence':
        return 'Confluence';
      case 'github':
        return 'GitHub';
      case 'gitlab':
        return 'GitLab';
      case 'slack':
        return 'Slack';
      case 'teams':
        return 'Microsoft Teams';
      case 'discord':
        return 'Discord';
      case 'aws':
        return 'AWS';
      case 'gcp':
        return 'Google Cloud';
      case 'azure':
        return 'Azure';
      default:
        return type.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
    }
  }

  String? _getIconUrlForType(String type) {
    // TODO: Add proper integration icon assets
    // For now, return null to use the default icons from IntegrationTypeIcon
    return null;
  }

  // Event handlers for integration management actions
  Future<void> _handleCreateIntegration(
    IntegrationProvider integrationProvider,
    IntegrationType integrationType,
    String name,
    Map<String, String> configParams,
  ) async {
    try {
      final result = await integrationProvider.createIntegration(
        name: name,
        description: 'New ${integrationType.displayName} integration',
        type: integrationType.type,
        configParams: configParams,
      );

      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Integration "${result.name}" created successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload integrations list to show the new integration
        retry();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to create integration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleUpdateIntegration(
    IntegrationProvider integrationProvider,
    String integrationId,
    String name,
    Map<String, String> configParams,
  ) async {
    try {
      final integration = integrationProvider.getIntegration(integrationId);
      if (integration == null) {
        throw Exception('Integration not found');
      }

      final result = await integrationProvider.updateIntegration(
        integrationId: integrationId,
        name: name,
        description: integration.description,
        configParams: configParams,
      );

      if (result && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Integration "${integration.name}" updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload integrations list to show the updates
        retry();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to update integration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDeleteIntegration(
    IntegrationProvider integrationProvider,
    String integrationId,
  ) async {
    try {
      final integration = integrationProvider.getIntegration(integrationId);
      final integrationName = integration?.name ?? 'Integration';

      final result = await integrationProvider.deleteIntegration(integrationId);

      if (result && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Integration "$integrationName" deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload integrations list to remove the deleted integration
        retry();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to delete integration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleEnableIntegration(
    IntegrationProvider integrationProvider,
    String integrationId,
  ) async {
    try {
      final integration = integrationProvider.getIntegration(integrationId);
      final integrationName = integration?.name ?? 'Integration';

      final result = await integrationProvider.enableIntegration(integrationId);

      if (result && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Integration "$integrationName" enabled'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload integrations list to show status change
        retry();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to enable integration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDisableIntegration(
    IntegrationProvider integrationProvider,
    String integrationId,
  ) async {
    try {
      final integration = integrationProvider.getIntegration(integrationId);
      final integrationName = integration?.name ?? 'Integration';

      final result = await integrationProvider.disableIntegration(integrationId);

      if (result && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Integration "$integrationName" disabled'),
            backgroundColor: Colors.orange,
          ),
        );
        // Reload integrations list to show status change
        retry();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to disable integration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleTestIntegration(
    IntegrationProvider integrationProvider,
    String integrationId,
    Map<String, String> configParams,
  ) async {
    try {
      // If integrationId starts with 'test:', this is a configuration test with embedded type
      if (integrationId.startsWith('test:')) {
        // Extract the integration type from the format "test:<type>"
        final integrationType = integrationId.substring(5); // Remove "test:" prefix

        final result = await integrationProvider.testIntegration(
          type: integrationType,
          configParams: configParams,
        );

        if (result != null && mounted) {
          final success = result['success'] ?? false;
          final message = result['message'] ?? 'Test completed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${success ? '✅' : '❌'} $message'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      } else if (integrationId == 'test') {
        // Legacy format for configuration testing - fallback to generic
        final result = await integrationProvider.testIntegration(
          type: 'generic',
          configParams: configParams,
        );

        if (result != null && mounted) {
          final success = result['success'] ?? false;
          final message = result['message'] ?? 'Test completed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${success ? '✅' : '❌'} $message'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      } else {
        // This is testing an existing integration - fetch detailed data if config params are empty
        Map<String, dynamic> testConfigParams = configParams;
        String integrationType = '';
        String integrationName = 'Integration';

        if (configParams.isEmpty) {
          // Need to fetch detailed integration data to get actual config parameters
          final detailedIntegration = await integrationProvider.getIntegrationById(integrationId);
          if (detailedIntegration == null) {
            throw Exception('Integration not found');
          }

          testConfigParams = Map.fromEntries(
            detailedIntegration.configParams.map((config) => MapEntry(config.paramKey, config.paramValue)),
          );
          integrationType = detailedIntegration.type;
          integrationName = detailedIntegration.name;
        } else {
          // We have config params, but still need the integration type and name
          final integration = integrationProvider.getIntegration(integrationId);
          if (integration == null) {
            throw Exception('Integration not found');
          }
          integrationType = integration.type;
          integrationName = integration.name;
        }

        final result = await integrationProvider.testIntegration(
          type: integrationType,
          configParams: testConfigParams,
        );

        if (result != null && mounted) {
          final success = result['success'] ?? false;
          final message = result['message'] ?? 'Test completed';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${success ? '✅' : '❌'} Test $integrationName: $message'),
              backgroundColor: success ? Colors.green : Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to test integration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Fetch detailed integration data with full config parameters
  Future<IntegrationData?> _handleGetIntegrationDetails(
    IntegrationProvider integrationProvider,
    String integrationId,
  ) async {
    try {
      final detailedIntegration = await integrationProvider.getIntegrationById(integrationId);

      if (detailedIntegration != null) {
        // Convert the detailed integration to styleguide format
        return IntegrationData(
          id: detailedIntegration.id,
          name: detailedIntegration.name,
          description: detailedIntegration.description,
          type: detailedIntegration.type,
          displayName: _getDisplayNameForType(detailedIntegration.type),
          enabled: detailedIntegration.enabled,
          iconUrl: _getIconUrlForType(detailedIntegration.type),
          usageCount: detailedIntegration.usageCount,
          lastUsedAt: detailedIntegration.lastUsedAt,
          createdAt: detailedIntegration.createdAt ?? DateTime.now(),
          createdByName: detailedIntegration.createdByName ?? 'Unknown User',
          workspaces: detailedIntegration.workspaces.map((w) => w.name).toList(),
          configParams: Map.fromEntries(
            detailedIntegration.configParams.map((config) => MapEntry(config.paramKey, config.paramValue)),
          ),
        );
      }

      return null;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to fetch integration details: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }
}
