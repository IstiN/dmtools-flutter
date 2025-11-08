import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/buttons/app_buttons.dart';
import '../molecules/headers/page_action_bar.dart';
import '../molecules/integration_selection_group.dart';

import 'mcp_list_view.dart';
import 'mcp_creation_form.dart';
import 'mcp_configuration_display.dart';
import '../../models/mcp_configuration.dart';

enum McpManagementView { list, create, edit, details }

/// Complete MCP (Model Context Protocol) management interface organism
///
/// This organism provides a unified interface for managing MCP configurations
/// with the same header structure as AI Job Configuration management.
/// Features:
/// - Consistent PageActionBar header
/// - Multiple views: list, create, edit, details
/// - No search functionality (as requested)
/// - Theme-aware design
/// - Responsive layout
class McpManagement extends StatefulWidget {
  final List<McpConfiguration> configurations;
  final List<IntegrationOption> availableIntegrations;
  final Future<bool> Function(String, List<String>) onCreateConfiguration;
  final Future<bool> Function(String, String, List<String>) onUpdateConfiguration;
  final Future<bool> Function(String) onDeleteConfiguration;
  final Future<String?> Function(String, String)? onGenerateCode;

  final bool? isTestMode;
  final bool? testDarkMode;

  const McpManagement({
    required this.configurations,
    required this.availableIntegrations,
    required this.onCreateConfiguration,
    required this.onUpdateConfiguration,
    required this.onDeleteConfiguration,
    this.onGenerateCode,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<McpManagement> createState() => _McpManagementState();
}

class _McpManagementState extends State<McpManagement> {
  McpManagementView _currentView = McpManagementView.list;
  McpConfiguration? _editingConfiguration;
  McpConfiguration? _viewingConfiguration;
  String? _generatedCode;
  bool _isLoadingCode = false;
  String _selectedFormat = 'json'; // Default format

  @override
  void didUpdateWidget(McpManagement oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.configurations != oldWidget.configurations) {
      // If configurations change, reset the view
      if (_currentView != McpManagementView.list) {
        _switchToView(McpManagementView.list);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeColorSet colors;

    if (widget.isTestMode == true) {
      final isDarkMode = widget.testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      colors = context.colors;
    }

    return Container(
      decoration: BoxDecoration(color: colors.bgColor, borderRadius: BorderRadius.circular(AppDimensions.radiusL)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          PageActionBar(
            title: _getHeaderTitle(),
            showBorder: true,
            actions: _getHeaderActions(),
            isTestMode: widget.isTestMode ?? false,
          ),

          // Show subtitle below the header for better UX
          if (_currentView != McpManagementView.list)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL, vertical: AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: colors.cardBg,
                border: Border(bottom: BorderSide(color: colors.borderColor.withValues(alpha: 0.1))),
              ),
              child: Text(_getHeaderSubtitle(), style: TextStyle(fontSize: 14, color: colors.textSecondary)),
            ),

          Flexible(child: _buildCurrentView(colors)),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentView) {
      case McpManagementView.list:
        return 'MCP Configurations';
      case McpManagementView.create:
        return 'Add MCP Configuration';
      case McpManagementView.edit:
        return 'Edit MCP Configuration';
      case McpManagementView.details:
        return 'MCP Configuration Details';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentView) {
      case McpManagementView.list:
        return 'Manage your MCP (Model Context Protocol) configurations and integration workflows';
      case McpManagementView.create:
        return 'Configure a new MCP setup with selected integrations';
      case McpManagementView.edit:
        return 'Update configuration for ${_editingConfiguration?.name ?? 'MCP'}';
      case McpManagementView.details:
        return 'View detailed configuration and generated code';
    }
  }

  List<Widget> _getHeaderActions() {
    switch (_currentView) {
      case McpManagementView.list:
        return [
          PrimaryButton(
            text: 'Add MCP Configuration',
            icon: Icons.add,
            onPressed: () {
              debugPrint('🔧 McpManagement: Add MCP Configuration button pressed');
              _switchToView(McpManagementView.create);
            },
            size: ButtonSize.small,
            isTestMode: widget.isTestMode ?? false,
          ),
        ];
      case McpManagementView.create:
      case McpManagementView.edit:
      case McpManagementView.details:
        return [
          AppIconButton(
            text: 'Back',
            icon: Icons.arrow_back,
            onPressed: () => _switchToView(McpManagementView.list),
            size: ButtonSize.small,
            isTestMode: widget.isTestMode ?? false,
          ),
        ];
    }
  }

  Widget _buildCurrentView(ThemeColorSet colors) {
    debugPrint('🔧 McpManagement: Building current view: $_currentView');

    switch (_currentView) {
      case McpManagementView.list:
        return _buildListView(colors);
      case McpManagementView.create:
        return _buildCreateView(colors);
      case McpManagementView.edit:
        return _buildEditView(colors);
      case McpManagementView.details:
        return _buildDetailsView(
          configuration: _viewingConfiguration!,
          generatedCode: _generatedCode,
          isLoadingCode: _isLoadingCode,
          selectedFormat: _selectedFormat,
          onFormatChanged: (newFormat) {
            if (newFormat != null) {
              setState(() {
                _selectedFormat = newFormat;
              });
            }
          },
          onRefreshCode: () => _fetchGeneratedCode(_viewingConfiguration!.id),
          onEdit: () => _switchToView(McpManagementView.edit, configuration: _viewingConfiguration!),
          onDelete: () async {
            try {
              final success = await widget.onDeleteConfiguration(_viewingConfiguration!.id ?? '');
              debugPrint('🔧 McpManagement: Delete from details result: $success');
              if (success) {
                _switchToView(McpManagementView.list);
              }
              return success;
            } catch (e) {
              debugPrint('🔧 McpManagement: Exception in onDeleteConfiguration from details: $e');
              return false;
            }
          },
        );
    }
  }

  Widget _buildListView(ThemeColorSet colors) {
    return McpListView(
      configurations: widget.configurations,
      state: widget.configurations.isEmpty ? McpListState.empty : McpListState.populated,
      availableIntegrations: widget.availableIntegrations,
      onCreateNew: () => _switchToView(McpManagementView.create),
      onConfigurationTap: (config) {
        _switchToView(McpManagementView.details, configuration: config);
      },
      onEdit: (config) {
        _switchToView(McpManagementView.edit, configuration: config);
      },
      onDelete: (config) async {
        try {
          final success = await widget.onDeleteConfiguration(config.id ?? '');
          debugPrint('🔧 McpManagement: Delete result: $success');
          return success;
        } catch (e) {
          debugPrint('🔧 McpManagement: Exception in onDeleteConfiguration: $e');
          return false;
        }
      },
      onViewCode: (config) {
        _switchToView(McpManagementView.details, configuration: config);
      },
      onCopyCode: (context, config) {
        // Handle copy functionality - this could trigger a snackbar
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Configuration code copied to clipboard')));
      },
      // Disable search and filter components
      showSearch: false,
      showFilters: false,
      showSort: false,
      isTestMode: widget.isTestMode ?? false,
      testDarkMode: widget.testDarkMode ?? false,
    );
  }

  Widget _buildCreateView(ThemeColorSet colors) {
    debugPrint('🔧 McpManagement: Building create view');
    debugPrint('🔧 McpManagement: Available integrations: ${widget.availableIntegrations.length}');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: McpCreationForm(
        availableIntegrations: widget.availableIntegrations,
        onSubmit: (name, integrations) async {
                debugPrint('🔧 McpManagement: onSubmit called from McpCreationForm');
                debugPrint('🔧 McpManagement: name = "$name", integrations = $integrations');
                try {
                  debugPrint('🔧 McpManagement: About to call widget.onCreateConfiguration');
                  debugPrint('🔧 McpManagement: onCreateConfiguration type: ${widget.onCreateConfiguration.runtimeType}');
                  debugPrint('🔧 McpManagement: onCreateConfiguration function: ${widget.onCreateConfiguration}');

                  // Force a small delay to ensure UI updates properly
                  await Future.delayed(const Duration(milliseconds: 100));

                  debugPrint('🔧 McpManagement: Calling widget.onCreateConfiguration directly');
                  final success = await widget.onCreateConfiguration(name, integrations);
                  debugPrint('🔧 McpManagement: onCreateConfiguration returned: $success');
                  if (success) {
                    // Wait a bit for the configurations list to update, then find the new config
                    await Future.delayed(const Duration(milliseconds: 200));

                    // Find the newly created configuration to navigate to its details
                    final matchingConfigs = widget.configurations.where((config) => config.name == name).toList();
                    debugPrint('🔧 McpManagement: Found ${matchingConfigs.length} configurations with name "$name"');

                    if (matchingConfigs.isNotEmpty) {
                      // Find the most recently created one
                      final newConfig = matchingConfigs.reduce(
                        (a, b) => (a.createdAt?.isAfter(b.createdAt ?? DateTime(1900)) == true) ? a : b,
                      );
                      debugPrint('🔧 McpManagement: Navigating to details for newly created config: ${newConfig.id}');
                      _switchToView(McpManagementView.details, configuration: newConfig);
                    } else {
                      debugPrint('🔧 McpManagement: Could not find newly created configuration, staying on list view');
                      _switchToView(McpManagementView.list);
                    }
                  } else {
                    debugPrint('🔧 McpManagement: Creation failed, staying on create view');
                  }
                  return success;
                } catch (e, stackTrace) {
                  debugPrint('🔧 McpManagement: Exception in onCreateConfiguration: $e');
                  debugPrint('🔧 McpManagement: Stack trace: $stackTrace');
                  return false;
                }
              },
        onCancel: () {
          debugPrint('🔧 McpManagement: onCancel called from McpCreationForm');
          _switchToView(McpManagementView.list);
        },
      ),
    );
  }

  Widget _buildEditView(ThemeColorSet colors) {
    if (_editingConfiguration == null) {
      return _buildErrorView('No configuration selected for editing');
    }

    // Use the integration IDs directly since the model now stores them
    final selectedIntegrationIds = _editingConfiguration!.integrationIds;

    debugPrint('🔧 McpManagement: Edit view - configuration: ${_editingConfiguration!.name}');
    debugPrint('🔧 McpManagement: Edit view - integration IDs: $selectedIntegrationIds');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: McpCreationForm(
        availableIntegrations: widget.availableIntegrations,
        initialName: _editingConfiguration!.name,
        initialSelectedIntegrations: selectedIntegrationIds,
        submitButtonText: 'Update Configuration',
        onSubmit: (name, integrations) async {
          try {
            final configId = _editingConfiguration!.id ?? '';
            final success = await widget.onUpdateConfiguration(configId, name, integrations);
            if (success) {
              _switchToView(McpManagementView.list);
            }
            return success;
          } catch (e) {
            debugPrint('🔧 McpManagement: Exception in onUpdateConfiguration: $e');
            return false;
          }
        },
        onCancel: () => _switchToView(McpManagementView.list),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: context.colors.textSecondary),
          const SizedBox(height: AppDimensions.spacingM),
          Text(message, style: TextStyle(fontSize: 16, color: context.colors.textSecondary)),
          const SizedBox(height: AppDimensions.spacingL),
          PrimaryButton(text: 'Back to List', onPressed: () => _switchToView(McpManagementView.list)),
        ],
      ),
    );
  }

  void _fetchGeneratedCode(String? configId) async {
    if (configId == null || widget.onGenerateCode == null) return;

    setState(() {
      _isLoadingCode = true;
      _generatedCode = null;
    });

    try {
      final code = await widget.onGenerateCode!(configId, _selectedFormat);
      if (mounted) {
        setState(() {
          _generatedCode = code;
          _isLoadingCode = false;
        });
      }
    } catch (e) {
      debugPrint('🔧 McpManagement: Error fetching generated code: $e');
      if (mounted) {
        setState(() {
          _generatedCode = 'Error: Failed to load code.';
          _isLoadingCode = false;
        });
      }
    }
  }

  void _switchToView(McpManagementView newView, {McpConfiguration? configuration}) {
    setState(() {
      _currentView = newView;
      switch (newView) {
        case McpManagementView.list:
          _viewingConfiguration = null;
          _editingConfiguration = null;
          break;
        case McpManagementView.details:
          assert(configuration != null);
          _viewingConfiguration = configuration;
          _editingConfiguration = null;
          _generatedCode = null; // Reset generated code when switching
          _isLoadingCode = false;
          _selectedFormat = 'cursor'; // Set Cursor as default format
          if (configuration?.id != null) {
            _fetchGeneratedCode(configuration!.id);
          }
          break;
        case McpManagementView.edit:
          assert(configuration != null);
          _editingConfiguration = configuration;
          _viewingConfiguration = null;
          break;
        case McpManagementView.create:
          _editingConfiguration = null;
          _viewingConfiguration = null;
          break;
      }
    });
    debugPrint('🔧 McpManagement: View switched to: $_currentView');
  }

  Widget _buildDetailsView({
    required McpConfiguration configuration,
    required String? generatedCode,
    required bool isLoadingCode,
    required String selectedFormat,
    required ValueChanged<String?> onFormatChanged,
    required VoidCallback onRefreshCode,
    required VoidCallback onEdit,
    required Future<bool> Function() onDelete,
  }) {
    return McpConfigurationDisplay(
      configuration: configuration,
      generatedCode: generatedCode,
      isLoading: isLoadingCode,
      selectedFormat: selectedFormat,
      onFormatChanged: onFormatChanged,
      onRefreshCode: onRefreshCode,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
