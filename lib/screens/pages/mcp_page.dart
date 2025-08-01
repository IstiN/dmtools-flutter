import 'package:flutter/material.dart';
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
  bool _isLoadingIntegrations = false;

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

  Future<void> _loadData() async {
    if (_hasLoadedData || _isLoadingIntegrations) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;

      final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
      if (authProvider.isAuthenticated) {
        print('🔧 McpPage: Loading MCP configurations and integrations...');

        setState(() {
          _isLoadingIntegrations = true;
        });

        try {
          // Load integrations first and wait for completion
          final integrationProvider = context.read<IntegrationProvider>();
          if (!integrationProvider.isInitialized) {
            print('🔧 McpPage: Integration provider not initialized, forcing reinitialize...');
            await integrationProvider.forceReinitialize();
          } else {
            print('🔧 McpPage: Integration provider already initialized, refreshing...');
            await integrationProvider.refresh();
          }

          // Check if widget is still mounted before proceeding
          if (!mounted) return;

          // Then load MCP configurations
          await context.read<McpProvider>().loadConfigurations();

          // Check if widget is still mounted before updating state
          if (!mounted) return;

          setState(() {
            _hasLoadedData = true;
            _isLoadingIntegrations = false;
          });

          print('🔧 McpPage: Data loading completed successfully');
        } catch (e) {
          print('🔧 McpPage: Error loading data: $e');
          if (mounted) {
            setState(() {
              _isLoadingIntegrations = false;
            });
          }
        }
      } else {
        print('🔧 McpPage: User not authenticated, skipping data load');
        // Reset the flag so we can retry when user becomes authenticated
        _hasLoadedData = false;
      }
    });
  }

  List<IntegrationOption> _getAvailableIntegrations() {
    final integrationProvider = Provider.of<IntegrationProvider>(context, listen: false);
    final mcpProvider = Provider.of<McpProvider>(context, listen: false);

    // Check if integrations are properly loaded
    if (!integrationProvider.isInitialized || integrationProvider.isLoading) {
      print(
          '🔧 McpPage: Integration provider not ready - initialized: ${integrationProvider.isInitialized}, loading: ${integrationProvider.isLoading}');

      // If we have MCP configurations with integration IDs but integrations aren't loaded yet,
      // create placeholder integrations based on the MCP configuration data
      if (mcpProvider.configurations.isNotEmpty) {
        print('🔧 McpPage: Creating placeholder integrations from MCP configuration IDs');
        final placeholderIntegrations = <IntegrationOption>[];
        final usedIds = <String>{};

        for (final config in mcpProvider.configurations) {
          for (final integrationId in config.integrationIds) {
            if (!usedIds.contains(integrationId)) {
              usedIds.add(integrationId);
              placeholderIntegrations.add(IntegrationOption(
                id: integrationId,
                displayName: _getIntegrationDisplayName(integrationId),
                description: 'Integration used in MCP configuration',
              ));
            }
          }
        }

        if (placeholderIntegrations.isNotEmpty) {
          print('🔧 McpPage: Created ${placeholderIntegrations.length} placeholder integrations');
          return placeholderIntegrations;
        }
      }

      return [];
    }

    final mcpReadyIntegrations = integrationProvider.service.mcpReadyIntegrations;

    print('🔧 McpPage: Available MCP-ready integrations: ${mcpReadyIntegrations.length}');
    for (final integration in mcpReadyIntegrations) {
      print('🔧 McpPage: - ${integration.name} (${integration.type}) [${integration.id}]');
    }

    // If we have real MCP configurations, we should make sure we have integrations for their IDs
    final allRequiredIds = <String>{};
    for (final config in mcpProvider.configurations) {
      allRequiredIds.addAll(config.integrationIds);
    }

    final result = <IntegrationOption>[];

    // Add all loaded integrations
    result.addAll(mcpReadyIntegrations.map((integration) => IntegrationOption(
          id: integration.id,
          displayName: integration.name,
          description: integration.description,
        )));

    // Add any missing integrations based on MCP configuration IDs
    final existingIds = result.map((i) => i.id).toSet();
    for (final requiredId in allRequiredIds) {
      if (!existingIds.contains(requiredId)) {
        print('🔧 McpPage: Adding missing integration for ID: $requiredId');
        result.add(IntegrationOption(
          id: requiredId,
          displayName: _getIntegrationDisplayName(requiredId),
          description: 'Integration from MCP configuration',
        ));
      }
    }

    // Create test integrations if we still have none (for pure development)
    if (result.isEmpty && allRequiredIds.isEmpty) {
      print('🔧 McpPage: No integrations found, creating test ones');
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

    print('🔧 McpPage: Returning ${result.length} available integrations');
    return result;
  }

  /// Get a display name for an integration ID
  String _getIntegrationDisplayName(String integrationId) {
    // Try to infer type from common patterns
    if (integrationId.contains('jira') || integrationId.toLowerCase().contains('jira')) {
      return 'Jira Integration';
    } else if (integrationId.contains('confluence') || integrationId.toLowerCase().contains('confluence')) {
      return 'Confluence Integration';
    } else if (integrationId.contains('figma') || integrationId.toLowerCase().contains('figma')) {
      return 'Figma Integration';
    } else if (integrationId.startsWith('demo_')) {
      // Handle demo IDs
      final parts = integrationId.split('_');
      if (parts.length > 1) {
        return '${parts[1].substring(0, 1).toUpperCase()}${parts[1].substring(1)} Integration';
      }
    }

    // Fallback to generic name with shortened ID
    final shortId = integrationId.length > 8 ? integrationId.substring(0, 8) : integrationId;
    return 'Integration ($shortId)';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<McpProvider, app_auth.AuthProvider>(
      builder: (context, mcpProvider, authProvider, child) {
        // Check if user just became authenticated and we haven't loaded data yet
        if (authProvider.isAuthenticated && !_hasLoadedData && !_isLoadingIntegrations) {
          print('🔧 McpPage: User is now authenticated, loading data...');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasLoadedData && !_isLoadingIntegrations) {
              _loadData();
            }
          });
        }

        // Show loading state while integrations are being loaded
        if (_isLoadingIntegrations) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'Loading integrations...',
                  style: TextStyle(
                    fontSize: 16,
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }

        // Ensure data is loaded if it hasn't been loaded yet
        if (!_hasLoadedData && authProvider.isAuthenticated) {
          print('🔧 McpPage: Data not loaded yet, triggering load from build method');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_hasLoadedData && !_isLoadingIntegrations) {
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
              print('🔧 McpPage: mcpProvider type: ${mcpProvider.runtimeType}');
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
              print('🔧 McpPage: mcpProvider type: ${mcpProvider.runtimeType}');

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
