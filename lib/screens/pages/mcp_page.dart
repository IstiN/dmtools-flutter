import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../providers/mcp_provider.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../../providers/integration_provider.dart';

class McpPage extends StatefulWidget {
  const McpPage({super.key});

  @override
  State<McpPage> createState() => _McpPageState();
}

class _McpPageState extends State<McpPage> {
  bool _hasLoadedData = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Also try to load data when dependencies change (e.g., when navigating to this page)
    if (!_hasLoadedData) {
      _loadData();
    }
  }

  void _loadData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        print('🔧 McpPage: Loading MCP configurations and integrations...');
        // Use read to avoid listening in initState
        context.read<McpProvider>().loadConfigurations();
        context.read<IntegrationProvider>().forceReinitialize();
        _hasLoadedData = true;
      } else {
        print('🔧 McpPage: User not authenticated, skipping data load');
        // Reset the flag so we can retry when user becomes authenticated
        _hasLoadedData = false;
      }
    });
  }

  List<IntegrationOption> _getAvailableIntegrations() {
    final integrationProvider = Provider.of<IntegrationProvider>(context, listen: false);

    // Force integration service to reload if needed
    if (integrationProvider.integrations.isEmpty || integrationProvider.service.mcpReadyIntegrations.isEmpty) {
      print('🔧 McpPage: Forcing integration service to reload');
      integrationProvider.forceReinitialize();
    }

    final mcpReadyIntegrations = integrationProvider.service.mcpReadyIntegrations;

    print('🔧 McpPage: Available MCP-ready integrations: ${mcpReadyIntegrations.length}');
    for (final integration in mcpReadyIntegrations) {
      print('🔧 McpPage: - ${integration.name} (${integration.type}) [${integration.id}]');
    }

    // Create test integrations if none are available (for development)
    if (mcpReadyIntegrations.isEmpty) {
      print('🔧 McpPage: No MCP-ready integrations found, creating test ones');
      return [
        const IntegrationOption(
          id: 'test-jira-id',
          displayName: 'Test Jira',
          description: 'Test Jira integration for development',
        ),
        const IntegrationOption(
          id: 'test-confluence-id',
          displayName: 'Test Confluence',
          description: 'Test Confluence integration for development',
        ),
      ];
    }

    return mcpReadyIntegrations
        .map((integration) => IntegrationOption(
              id: integration.id,
              displayName: integration.name,
              description: integration.description,
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<McpProvider, app_auth.AuthProvider>(
      builder: (context, mcpProvider, authProvider, child) {
        // Check if user just became authenticated and we haven't loaded data yet
        if (authProvider.isAuthenticated && !_hasLoadedData) {
          print('🔧 McpPage: User is now authenticated, loading data...');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasLoadedData) {
              _loadData();
            }
          });
        }

        // Ensure data is loaded if it hasn't been loaded yet
        if (!_hasLoadedData && authProvider.isAuthenticated) {
          print('🔧 McpPage: Data not loaded yet, triggering load from build method');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasLoadedData) {
              _loadData();
            }
          });
        }

        print(
            '🔧 McpPage: Building with ${mcpProvider.configurations.length} configurations, auth: ${authProvider.isAuthenticated}');

        // Convert main app configurations to styleguide format
        final styleguideConfigs = mcpProvider.configurations.map((config) {
          return McpConfiguration(
            id: config.id,
            name: config.name,
            integrationIds: config.integrationIds,
            createdAt: config.createdAt,
            updatedAt: config.updatedAt,
          );
        }).toList();

        return McpManagement(
          configurations: styleguideConfigs,
          availableIntegrations: _getAvailableIntegrations(),
          onGenerateCode: (configId, format) async {
            return await mcpProvider.generateConfigurationCode(configId, format: format);
          },
          onCreateConfiguration: (name, integrations) async {
            print('🔧 McpPage: onCreateConfiguration called with name: $name, integrations: $integrations');
            try {
              print('🔧 McpPage: mcpProvider is null? ${mcpProvider == null}');
              print('🔧 McpPage: mcpProvider.createConfiguration exists? ${mcpProvider.createConfiguration != null}');
              print('🔧 McpPage: mcpProvider.createConfiguration type: ${mcpProvider.createConfiguration.runtimeType}');

              // Force a small delay to ensure UI updates properly
              await Future.delayed(const Duration(milliseconds: 100));

              print('🔧 McpPage: About to call mcpProvider.createConfiguration');
              final success = await mcpProvider.createConfiguration(
                name: name,
                integrationIds: integrations,
              );
              print('🔧 McpPage: createConfiguration result: $success');
              return success;
            } catch (e, stackTrace) {
              print('🔧 McpPage: Error in createConfiguration: $e');
              print('🔧 McpPage: Stack trace: $stackTrace');
              return false;
            }
          },
          onUpdateConfiguration: (id, name, integrations) async {
            print('🔧 McpPage: onUpdateConfiguration called with id: $id, name: $name, integrations: $integrations');
            try {
              print('🔧 McpPage: mcpProvider is null? ${mcpProvider == null}');
              print('🔧 McpPage: mcpProvider.updateConfiguration exists? ${mcpProvider.updateConfiguration != null}');

              // Force a small delay to ensure UI updates properly
              await Future.delayed(const Duration(milliseconds: 100));

              print('🔧 McpPage: About to call mcpProvider.updateConfiguration');
              final success = await mcpProvider.updateConfiguration(
                id: id,
                name: name,
                integrationIds: integrations,
              );
              print('🔧 McpPage: updateConfiguration result: $success');
              return success;
            } catch (e, stackTrace) {
              print('🔧 McpPage: Error in updateConfiguration: $e');
              print('🔧 McpPage: Stack trace: $stackTrace');
              return false;
            }
          },
          onDeleteConfiguration: (id) async => await mcpProvider.deleteConfiguration(id),
        );
      },
    );
  }
}
