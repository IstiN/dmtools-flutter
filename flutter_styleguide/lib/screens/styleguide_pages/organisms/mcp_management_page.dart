import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class McpManagementPage extends StatelessWidget {
  const McpManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final sampleConfigurations = [
      McpConfiguration(
        id: '1',
        name: 'Development Setup',
        integrationIds: ['jira'],
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      McpConfiguration(
        id: '2',
        name: 'Documentation Workflow',
        integrationIds: ['confluence', 'jira'],
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];

    final availableIntegrations = [
      const IntegrationOption(
        id: 'jira',
        displayName: 'Jira',
        description: 'Access Jira issues, projects, and workflows',
      ),
      const IntegrationOption(
        id: 'confluence',
        displayName: 'Confluence',
        description: 'Access Confluence pages, spaces, and content',
      ),
      const IntegrationOption(
        id: 'slack',
        displayName: 'Slack',
        description: 'Connect with Slack channels and messages',
        enabled: false,
      ),
    ];

    return Scaffold(
      body: Container(
        color: context.colors.bgColor,
        child: McpManagement(
          configurations: sampleConfigurations,
          availableIntegrations: availableIntegrations,
          onCreateConfiguration: (name, integrations) async {
            _showActionDialog(context, 'Create configuration: $name with ${integrations.length} integrations');
            return true;
          },
          onUpdateConfiguration: (id, name, integrations) async {
            _showActionDialog(context, 'Update configuration $id: $name with ${integrations.length} integrations');
            return true;
          },
          onDeleteConfiguration: (id) async {
            _showActionDialog(context, 'Delete configuration $id');
            return true;
          },
          isTestMode: true,
          testDarkMode: context.isDarkMode,
        ),
      ),
    );
  }

  void _showActionDialog(BuildContext context, String action) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(action),
        duration: const Duration(seconds: 2),
        backgroundColor: context.colors.accentColor,
      ),
    );
  }
}
