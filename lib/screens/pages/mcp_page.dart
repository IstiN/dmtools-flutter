import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../providers/mcp_provider.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../../providers/integration_provider.dart';

enum PageLoadingState {
  loading,
  loaded,
  error,
  empty,
}

class McpPage extends StatefulWidget {
  const McpPage({super.key});

  @override
  State<McpPage> createState() => _McpPageState();
}

class _McpPageState extends State<McpPage> {
  PageLoadingState _loadingState = PageLoadingState.loading;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Also try to load data when dependencies change (e.g., when navigating to this page)
    if (_loadingState == PageLoadingState.loading) {
      _loadData();
    }
  }

  Future<void> _loadData() async {
    if (_loadingState == PageLoadingState.loading) {
      print('🔧 McpPage: Already loading, skipping duplicate load request');
      return;
    }

    if (!mounted) return;

    print('🔧 McpPage: Starting data load...');
    
    // Set loading state immediately
    setState(() {
      _loadingState = PageLoadingState.loading;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
      
      if (authProvider.isAuthenticated) {
        // Production data loading for authenticated users
        print('🔧 McpPage: Loading production data for authenticated user...');
        
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

        // Determine final state based on data
        final mcpProvider = context.read<McpProvider>();
        final hasConfigurations = mcpProvider.configurations.isNotEmpty;
        
        setState(() {
          _loadingState = hasConfigurations ? PageLoadingState.loaded : PageLoadingState.empty;
        });

        print('🔧 McpPage: Production data loading completed - state: $_loadingState');
      } else {
        // Demo mode - no actual loading needed, just show demo state
        print('🔧 McpPage: Demo mode - setting loaded state with demo data...');
        
        // Small delay to simulate loading for demo purposes
        await Future.delayed(const Duration(milliseconds: 500));
        
        if (!mounted) return;
        
        setState(() {
          _loadingState = PageLoadingState.loaded; // Demo always shows loaded state
        });

        print('🔧 McpPage: Demo mode setup completed');
      }
    } catch (e) {
      print('🔧 McpPage: Error loading data: $e');
      if (mounted) {
        setState(() {
          _loadingState = PageLoadingState.error;
          _errorMessage = e.toString();
        });
      }
    }
  }

  List<IntegrationOption> _getAvailableIntegrations() {
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);

    if (!authProvider.isAuthenticated) {
      // Demo mode - return demo integrations only
      print('🔧 McpPage: Demo mode - returning demo integrations');
      return [
        const IntegrationOption(
          id: 'demo_jira_1',
          displayName: 'Demo Jira',
          description: 'Demo Jira integration for testing',
        ),
        const IntegrationOption(
          id: 'demo_confluence_1',
          displayName: 'Demo Confluence',
          description: 'Demo Confluence integration for testing',
        ),
      ];
    }

    // Production mode - return actual integrations
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
        // Check if user just became authenticated and we need to start loading
        if (authProvider.isAuthenticated && _loadingState == PageLoadingState.loading) {
          print('🔧 McpPage: User is authenticated and in loading state');
        }

        print('🔧 McpPage: Building with state: $_loadingState, configurations: ${mcpProvider.configurations.length}, auth: ${authProvider.isAuthenticated}');

        // Handle different loading states
        switch (_loadingState) {
          case PageLoadingState.loading:
            return _buildLoadingState();
          case PageLoadingState.error:
            return _buildErrorState();
          case PageLoadingState.empty:
            return _buildEmptyState(authProvider.isAuthenticated);
          case PageLoadingState.loaded:
            return _buildLoadedState(mcpProvider, authProvider);
        }
      },
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading MCP configurations...',
            style: TextStyle(
              fontSize: 16,
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: context.colors.dangerColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading MCP configurations',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.colors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _errorMessage ?? 'Unknown error occurred',
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _loadingState = PageLoadingState.loading;
              _loadData();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isAuthenticated) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No MCP configurations found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.colors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isAuthenticated
                ? 'Create your first MCP configuration to get started'
                : 'Sign in to create and manage MCP configurations',
            style: TextStyle(
              fontSize: 14,
              color: context.colors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadedState(McpProvider mcpProvider, app_auth.AuthProvider authProvider) {
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

    // For demo mode, show demo configurations if no real configurations exist
    if (!authProvider.isAuthenticated && styleguideConfigs.isEmpty) {
      styleguideConfigs.add(const McpConfiguration(
        id: 'demo-config-1',
        name: 'Demo MCP Configuration',
        integrationIds: ['demo_jira_1', 'demo_confluence_1'],
        createdAt: null,
        updatedAt: null,
      ));
    }

    return McpManagement(
      configurations: styleguideConfigs,
      availableIntegrations: _getAvailableIntegrations(),
      onGenerateCode: (configId, format) async {
        if (!authProvider.isAuthenticated) {
          // Return demo code for demo mode
          return 'Demo code for configuration: $configId (format: $format)';
        }
        return await mcpProvider.generateConfigurationCode(configId, format: format);
      },
      onCreateConfiguration: (name, integrations) async {
        if (!authProvider.isAuthenticated) {
          // Demo mode - simulate success
          print('🔧 McpPage: Demo mode - simulating configuration creation');
          return true;
        }
        
        print('🔧 McpPage: onCreateConfiguration called with name: $name, integrations: $integrations');
        try {
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
        if (!authProvider.isAuthenticated) {
          // Demo mode - simulate success
          print('🔧 McpPage: Demo mode - simulating configuration update');
          return true;
        }
        
        print('🔧 McpPage: onUpdateConfiguration called with id: $id, name: $name, integrations: $integrations');
        try {
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
      onDeleteConfiguration: (id) async {
        if (!authProvider.isAuthenticated) {
          // Demo mode - simulate success
          print('🔧 McpPage: Demo mode - simulating configuration deletion');
          return true;
        }
        return await mcpProvider.deleteConfiguration(id);
      },
    );
  }
}
