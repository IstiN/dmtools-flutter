import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Demonstration page for MCP (Model Context Protocol) components
///
/// This page showcases all MCP-related atoms and molecules including
/// status chips, cards, checkboxes, copy buttons, and code display blocks.
class McpPage extends StatefulWidget {
  const McpPage({super.key});

  @override
  State<McpPage> createState() => _McpPageState();
}

class _McpPageState extends State<McpPage> {
  Set<String> selectedIntegrations = {'jira'};

  // Sample data for demonstrations
  final List<IntegrationOption> availableIntegrations = [
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
    const IntegrationOption(id: 'slack', displayName: 'Slack', description: 'Connect with Slack channels and messages'),
  ];

  final String sampleCode = '''
{
  "name": "My Development Setup",
  "integrations": [
    {
      "type": "jira",
      "enabled": true,
      "config": {
        "server": "https://mycompany.atlassian.net",
        "project": "DEV"
      }
    },
    {
      "type": "confluence",
      "enabled": true,
      "config": {
        "server": "https://mycompany.atlassian.net",
        "space": "DOCS"
      }
    }
  ],
  "created_at": "2024-01-15T10:30:00Z",
  "token": "mcp_abc123def456"
}''';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('MCP Components'),
        backgroundColor: colors.cardBg,
        foregroundColor: colors.textColor,
      ),
      backgroundColor: colors.bgColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPageHeader(),
            const SizedBox(height: 32),
            _buildStatusChipsSection(),
            const SizedBox(height: 32),
            _buildCopyButtonsSection(),
            const SizedBox(height: 32),
            _buildIntegrationCheckboxesSection(),
            const SizedBox(height: 32),
            _buildIntegrationSelectionGroupSection(),
            const SizedBox(height: 32),
            _buildMcpCardsSection(),
            const SizedBox(height: 32),
            _buildCodeDisplaySection(),
            const SizedBox(height: 32),
            _buildOrganismsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader() {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MCP Components Showcase',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        Text(
          'This page demonstrates all MCP (Model Context Protocol) related components including atoms and molecules.',
          style: TextStyle(fontSize: 16, color: colors.textColor.withValues(alpha: 0.7), height: 1.4),
        ),
      ],
    );
  }

  Widget _buildStatusChipsSection() {
    return _buildSection(
      title: 'MCP Status Chips',
      description: 'Status chips show the current state of MCP configurations with integration counts.',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildSizeVariations<McpStatusChipSize>(
            title: 'Small',
            items: [
              const McpStatusChip(status: McpStatus.active, integrationCount: 3, size: McpStatusChipSize.small),
              const McpStatusChip(status: McpStatus.inactive, integrationCount: 0, size: McpStatusChipSize.small),
              const McpStatusChip(status: McpStatus.error, integrationCount: 1, size: McpStatusChipSize.small),
              const McpStatusChip(status: McpStatus.pending, integrationCount: 2, size: McpStatusChipSize.small),
            ],
          ),
          _buildSizeVariations<McpStatusChipSize>(
            title: 'Medium',
            items: [
              const McpStatusChip(status: McpStatus.active, integrationCount: 3),
              const McpStatusChip(status: McpStatus.inactive, integrationCount: 0),
              const McpStatusChip(status: McpStatus.error, integrationCount: 1),
              const McpStatusChip(status: McpStatus.pending, integrationCount: 2),
            ],
          ),
          _buildSizeVariations<McpStatusChipSize>(
            title: 'Large',
            items: [
              const McpStatusChip(status: McpStatus.active, integrationCount: 3, size: McpStatusChipSize.large),
              const McpStatusChip(status: McpStatus.inactive, integrationCount: 0, size: McpStatusChipSize.large),
              const McpStatusChip(status: McpStatus.error, integrationCount: 1, size: McpStatusChipSize.large),
              const McpStatusChip(status: McpStatus.pending, integrationCount: 2, size: McpStatusChipSize.large),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCopyButtonsSection() {
    return _buildSection(
      title: 'Copy Buttons',
      description: 'Copy buttons provide one-click copying with visual feedback and multiple variants.',
      child: Column(
        children: [
          _buildCopyButtonVariant('Filled Buttons', CopyButtonVariant.filled),
          const SizedBox(height: 16),
          _buildCopyButtonVariant('Outlined Buttons', CopyButtonVariant.outlined),
          const SizedBox(height: 16),
          _buildCopyButtonVariant('Text Buttons', CopyButtonVariant.text),
          const SizedBox(height: 16),
          _buildCopyButtonVariant('Icon Only Buttons', CopyButtonVariant.iconOnly),
        ],
      ),
    );
  }

  Widget _buildCopyButtonVariant(String title, CopyButtonVariant variant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            CopyButton(textToCopy: 'Sample text to copy', variant: variant, size: CopyButtonSize.small),
            CopyButton(textToCopy: 'Sample text to copy', variant: variant),
            CopyButton(textToCopy: 'Sample text to copy', variant: variant, size: CopyButtonSize.large),
          ],
        ),
      ],
    );
  }

  Widget _buildIntegrationCheckboxesSection() {
    return _buildSection(
      title: 'Integration Checkboxes',
      description: 'Styled checkboxes for integration selection with optional descriptions.',
      child: Column(
        children: [
          IntegrationCheckbox(
            label: 'Jira Integration',
            description: 'Access Jira issues, projects, and workflows',
            value: true,
            onChanged: (value) {},
            size: IntegrationCheckboxSize.small,
          ),
          const SizedBox(height: 12),
          IntegrationCheckbox(
            label: 'Confluence Integration',
            description: 'Access Confluence pages, spaces, and content',
            value: false,
            onChanged: (value) {},
          ),
          const SizedBox(height: 12),
          const IntegrationCheckbox(
            label: 'Slack Integration (Disabled)',
            description: 'Connect with Slack channels and messages',
            value: false,
            enabled: false,
            onChanged: null,
            size: IntegrationCheckboxSize.large,
          ),
        ],
      ),
    );
  }

  Widget _buildIntegrationSelectionGroupSection() {
    return _buildSection(
      title: 'Integration Selection Group',
      description: 'Grouped checkboxes for selecting multiple integrations with validation.',
      child: Column(
        children: [
          IntegrationSelectionGroup(
            title: 'Available Integrations',
            description: 'Select the integrations you want to include in your MCP configuration.',
            integrations: availableIntegrations,
            selectedIntegrations: selectedIntegrations,
            onIntegrationChanged: (integrationId) {
              setState(() {
                if (selectedIntegrations.contains(integrationId)) {
                  selectedIntegrations.remove(integrationId);
                } else {
                  selectedIntegrations.add(integrationId);
                }
              });
            },
            minSelections: 1,
          ),
        ],
      ),
    );
  }

  Widget _buildMcpCardsSection() {
    return _buildSection(
      title: 'MCP Cards',
      description: 'Cards displaying MCP configurations with actions and status information.',
      child: Column(
        children: [
          McpCard(
            name: 'Development Environment',
            description: 'MCP configuration for development workflow with Jira and Confluence integration.',
            status: McpStatus.active,
            integrations: const [McpIntegrationType.jira, McpIntegrationType.confluence],
            createdAt: DateTime.now().subtract(const Duration(days: 3)),
            onTap: () => _showSnackBar('Card tapped'),
            onEdit: () => _showSnackBar('Edit clicked'),
            onDelete: () => _showSnackBar('Delete clicked'),
            onViewCode: () => _showSnackBar('View code clicked'),
            onCopyCode: () => _showSnackBar('Copy code clicked'),
            isTestMode: true,
            testDarkMode: context.isDarkMode,
          ),
          const SizedBox(height: 16),
          McpCard(
            name: 'Production Monitoring',
            status: McpStatus.error,
            integrations: const [McpIntegrationType.jira],
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            onTap: () => _showSnackBar('Card tapped'),
            onEdit: () => _showSnackBar('Edit clicked'),
            onDelete: () => _showSnackBar('Delete clicked'),
            size: McpCardSize.small,
            isTestMode: true,
            testDarkMode: context.isDarkMode,
          ),
          const SizedBox(height: 16),
          McpCard(
            name: 'Documentation Hub',
            description: 'Comprehensive documentation setup with multiple integrations for team collaboration.',
            status: McpStatus.pending,
            integrations: const [McpIntegrationType.confluence],
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
            onTap: () => _showSnackBar('Card tapped'),
            size: McpCardSize.large,
            isTestMode: true,
            testDarkMode: context.isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildCodeDisplaySection() {
    return _buildSection(
      title: 'Code Display Blocks',
      description: 'Formatted code display with syntax highlighting and copy functionality.',
      child: Column(
        children: [
          CodeDisplayBlock(
            title: 'MCP Configuration',
            language: 'json',
            code: sampleCode,
            showLineNumbers: true,
            maxHeight: 300,
            onCopy: () => _showSnackBar('Code copied to clipboard'),
          ),
          const SizedBox(height: 16),
          CodeDisplayBlock(
            code: 'npm install @modelcontextprotocol/cli',
            language: 'bash',
            theme: CodeDisplayTheme.light,
            size: CodeDisplaySize.small,
            onCopy: () => _showSnackBar('Command copied'),
          ),
          const SizedBox(height: 16),
          const CodeDisplayBlock(
            title: 'Large Code Block',
            code: '''
// Example MCP client configuration
const mcpClient = new McpClient({
  name: "my-mcp-config",
  integrations: [
    {
      type: "jira",
      config: { server: "https://company.atlassian.net" }
    }
  ]
});

await mcpClient.connect();
''',
            language: 'javascript',
            theme: CodeDisplayTheme.auto,
            size: CodeDisplaySize.large,
            showLineNumbers: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSection({required String title, required String description, required Widget child}) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(fontSize: 14, color: colors.textColor.withValues(alpha: 0.7), height: 1.4),
          ),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildSizeVariations<T>({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: items),
      ],
    );
  }

  Widget _buildOrganismsSection() {
    return _buildSection(
      title: 'Organisms',
      description: 'Complex UI patterns combining multiple molecules and atoms',
      child: Column(
        children: [
          _buildOrganismDemo('MCP List View', _buildMcpListViewDemo()),
          const SizedBox(height: 24),
          _buildOrganismDemo('MCP Creation Form', _buildMcpCreationFormDemo()),
          const SizedBox(height: 24),
          _buildOrganismDemo('MCP Edit Form', _buildMcpEditFormDemo()),
          const SizedBox(height: 24),
          _buildOrganismDemo('MCP Configuration Display', _buildMcpConfigurationDisplayDemo()),
        ],
      ),
    );
  }

  Widget _buildOrganismDemo(String title, Widget demo) {
    final colors = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          height: 400,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: demo,
        ),
      ],
    );
  }

  Widget _buildMcpListViewDemo() {
    return McpListView(
      configurations: _sampleConfigurations,
      state: McpListState.populated,
      onConfigurationTap: (config) => _showSnackBar('Tapped: ${config.name}'),
      onCreateNew: () => _showSnackBar('Create new MCP'),
      onDelete: (config) => _showSnackBar('Delete: ${config.name}'),
      onEdit: (config) => _showSnackBar('Edit: ${config.name}'),
      onViewCode: (config) => _showSnackBar('View code: ${config.name}'),
      onCopyCode: (context, config) => _showSnackBar('Copy code: ${config.name}'),
      showSearch: false,
      showFilters: false,
      showSort: false,
      isTestMode: true,
      testDarkMode: context.isDarkMode,
    );
  }

  Widget _buildMcpCreationFormDemo() {
    return McpCreationForm(
      availableIntegrations: _sampleIntegrations,
      onSubmit: (name, integrations) => _showSnackBar('Create: $name with ${integrations.length} integrations'),
      onCancel: () => _showSnackBar('Form cancelled'),
    );
  }

  Widget _buildMcpEditFormDemo() {
    return McpCreationForm(
      availableIntegrations: _sampleIntegrations,
      initialName: 'Development Environment',
      initialSelectedIntegrations: const ['tracker', 'ai'],
      submitButtonText: 'Update Configuration',
      onSubmit: (name, integrations) => _showSnackBar('Update: $name with ${integrations.length} integrations'),
      onCancel: () => _showSnackBar('Edit cancelled'),
    );
  }

  Widget _buildMcpConfigurationDisplayDemo() {
    return McpConfigurationDisplay(
      configuration: _sampleConfigurations.first,
      generatedCode: _sampleCodeDisplay,
      onEdit: () => _showSnackBar('Edit configuration'),
      onDelete: () => _showSnackBar('Delete configuration'),
      onDuplicate: () => _showSnackBar('Duplicate configuration'),
      onRefreshCode: () => _showSnackBar('Refresh code'),
      onCopyCode: () => _showSnackBar('Copy code'),
      onDownloadCode: () => _showSnackBar('Download code'),
    );
  }

  List<IntegrationOption> get _sampleIntegrations => [
    const IntegrationOption(
      id: 'tracker',
      displayName: 'Project Tracker',
      description: 'Integration with project management tools like Jira',
      isRequired: true,
    ),
    const IntegrationOption(
      id: 'ai',
      displayName: 'AI Service',
      description: 'AI analysis and generation capabilities',
      isRequired: true,
    ),
    const IntegrationOption(
      id: 'confluence',
      displayName: 'Confluence',
      description: 'Access Confluence pages, spaces, and content',
    ),
    const IntegrationOption(id: 'slack', displayName: 'Slack', description: 'Connect with Slack channels and messages'),
  ];

  String get _sampleCodeDisplay => '''
{
  "mcpServers": {
    "development-environment": {
      "command": "npx",
      "args": ["@dmtools/mcp-server"],
      "env": {
        "DMTOOLS_TOKEN": "mcp_dev_abc123",
        "DMTOOLS_INTEGRATIONS": "tracker,ai,confluence"
      }
    }
  }
}''';

  List<McpConfiguration> get _sampleConfigurations => [
    McpConfiguration(
      id: 'mcp-1',
      name: 'Development Environment',
      integrations: [McpIntegrationType.jira, McpIntegrationType.confluence],
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      token: 'mcp_dev_abc123',
    ),
    McpConfiguration(
      id: 'mcp-2',
      name: 'Production Setup',
      integrations: [McpIntegrationType.jira],
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      token: 'mcp_prod_xyz789',
    ),
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), duration: const Duration(seconds: 2)));
  }
}
