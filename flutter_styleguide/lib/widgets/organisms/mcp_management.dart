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
  final Function(String, List<String>) onCreateConfiguration;
  final Function(String, String, List<String>) onUpdateConfiguration;
  final Function(String) onDeleteConfiguration;

  final bool? isTestMode;
  final bool? testDarkMode;

  const McpManagement({
    required this.configurations,
    required this.availableIntegrations,
    required this.onCreateConfiguration,
    required this.onUpdateConfiguration,
    required this.onDeleteConfiguration,
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
                border: Border(bottom: BorderSide(color: colors.borderColor.withOpacity(0.1))),
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
        return 'MCP Powered Jobs';
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
            onPressed: () => _switchToView(McpManagementView.create),
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
    switch (_currentView) {
      case McpManagementView.list:
        return _buildListView(colors);
      case McpManagementView.create:
        return _buildCreateView(colors);
      case McpManagementView.edit:
        return _buildEditView(colors);
      case McpManagementView.details:
        return _buildDetailsView(colors);
    }
  }

  Widget _buildListView(ThemeColorSet colors) {
    return McpListView(
      configurations: widget.configurations,
      state: widget.configurations.isEmpty ? McpListState.empty : McpListState.populated,
      onCreateNew: () => _switchToView(McpManagementView.create),
      onConfigurationTap: (config) {
        _viewingConfiguration = config;
        _switchToView(McpManagementView.details);
      },
      onEdit: (config) {
        _editingConfiguration = config;
        _switchToView(McpManagementView.edit);
      },
      onDelete: (config) {
        widget.onDeleteConfiguration(config.id ?? '');
      },
      onViewCode: (config) {
        _viewingConfiguration = config;
        _switchToView(McpManagementView.details);
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: McpCreationForm(
        availableIntegrations: widget.availableIntegrations,
        onSubmit: (name, integrations) {
          widget.onCreateConfiguration(name, integrations);
          _switchToView(McpManagementView.list);
        },
        onCancel: () => _switchToView(McpManagementView.list),
      ),
    );
  }

  Widget _buildEditView(ThemeColorSet colors) {
    if (_editingConfiguration == null) {
      return _buildErrorView('No configuration selected for editing');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: McpCreationForm(
        availableIntegrations: widget.availableIntegrations,
        initialName: _editingConfiguration!.name,
        initialSelectedIntegrations: _editingConfiguration!.integrations.map((e) => e.name).toList(),
        submitButtonText: 'Update Configuration',
        onSubmit: (name, integrations) {
          widget.onUpdateConfiguration(_editingConfiguration!.id ?? '', name, integrations);
          _switchToView(McpManagementView.list);
        },
        onCancel: () => _switchToView(McpManagementView.list),
      ),
    );
  }

  Widget _buildDetailsView(ThemeColorSet colors) {
    if (_viewingConfiguration == null) {
      return _buildErrorView('No configuration selected for viewing');
    }

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: McpConfigurationDisplay(
        configuration: _viewingConfiguration!,
        onEdit: () {
          _editingConfiguration = _viewingConfiguration;
          _switchToView(McpManagementView.edit);
        },
        onDelete: () {
          widget.onDeleteConfiguration(_viewingConfiguration!.id ?? '');
          _switchToView(McpManagementView.list);
        },
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

  void _switchToView(McpManagementView view) {
    setState(() {
      _currentView = view;

      // Clear editing state when switching away from edit/create
      if (view == McpManagementView.list) {
        _editingConfiguration = null;
        _viewingConfiguration = null;
      }
    });
  }
}
