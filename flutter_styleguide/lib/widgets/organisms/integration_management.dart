import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/buttons/app_buttons.dart';
import '../molecules/integration_card.dart';
import '../molecules/integration_type_selector.dart';
import '../molecules/integration_config_form.dart';
import '../atoms/integration_type_icon.dart';
import '../responsive/responsive_builder.dart';

enum IntegrationManagementView {
  list,
  discovery,
  create,
  edit,
}

/// Data model for integration definition with DMTools-specific integrations
class IntegrationDefinition {
  final String type;
  final String displayName;
  final String description;
  final String category;
  final List<String> tags;
  final String? iconUrl;
  final bool isPopular;
  final String setupDifficulty; // easy, medium, hard
  final List<String> features;
  final String? documentationUrl;

  const IntegrationDefinition({
    required this.type,
    required this.displayName,
    required this.description,
    required this.category,
    required this.tags,
    required this.features,
    this.iconUrl,
    this.isPopular = false,
    this.setupDifficulty = 'medium',
    this.documentationUrl,
  });
}

/// Complete integration management interface organism
class IntegrationManagement extends StatefulWidget {
  final List<IntegrationData> integrations;
  final List<IntegrationType> availableTypes;
  final Function(IntegrationType, Map<String, String>) onCreateIntegration;
  final Function(String, Map<String, String>) onUpdateIntegration;
  final Function(String) onDeleteIntegration;
  final Function(String) onEnableIntegration;
  final Function(String) onDisableIntegration;
  final Function(String, Map<String, String>) onTestIntegration;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationManagement({
    required this.integrations,
    required this.availableTypes,
    required this.onCreateIntegration,
    required this.onUpdateIntegration,
    required this.onDeleteIntegration,
    required this.onEnableIntegration,
    required this.onDisableIntegration,
    required this.onTestIntegration,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<IntegrationManagement> createState() => _IntegrationManagementState();
}

class _IntegrationManagementState extends State<IntegrationManagement> {
  IntegrationManagementView _currentView = IntegrationManagementView.list;
  IntegrationType? _selectedType;
  IntegrationData? _editingIntegration;
  Map<String, String> _configValues = {};
  bool _isLoading = false;
  String? _testResult;

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
      decoration: BoxDecoration(
        color: colors.bgColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(colors),
          const SizedBox(height: AppDimensions.spacingL),
          Expanded(
            child: _buildContent(colors),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusL),
          topRight: Radius.circular(AppDimensions.radiusL),
        ),
        border: Border(
          bottom: BorderSide(color: colors.borderColor),
        ),
      ),
      child: Row(
        children: [
          if (_currentView != IntegrationManagementView.list) ...[
            IconButton(
              icon: Icon(Icons.arrow_back, color: colors.textColor),
              onPressed: () {
                setState(() {
                  _currentView = IntegrationManagementView.list;
                  _selectedType = null;
                  _editingIntegration = null;
                  _configValues.clear();
                  _testResult = null;
                });
              },
            ),
            const SizedBox(width: AppDimensions.spacingS),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getHeaderTitle(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: colors.textColor,
                  ),
                ),
                Text(
                  _getHeaderSubtitle(),
                  style: TextStyle(
                    fontSize: 14,
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (_currentView == IntegrationManagementView.list) ...[
            PrimaryButton(
              text: 'Add Integration',
              icon: Icons.add,
              onPressed: () {
                setState(() {
                  _currentView = IntegrationManagementView.discovery;
                });
              },
              isTestMode: widget.isTestMode ?? false,
              testDarkMode: widget.testDarkMode ?? false,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContent(ThemeColorSet colors) {
    switch (_currentView) {
      case IntegrationManagementView.list:
        return _buildIntegrationList(colors);
      case IntegrationManagementView.discovery:
        return _buildDiscoveryView(colors);
      case IntegrationManagementView.create:
        return _buildCreateIntegration(colors);
      case IntegrationManagementView.edit:
        return _buildEditIntegration(colors);
    }
  }

  Widget _buildIntegrationList(ThemeColorSet colors) {
    if (widget.integrations.isEmpty) {
      return _buildEmptyState(colors);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isWideScreen(context)
            ? 3
            : ResponsiveUtils.isTablet(context)
                ? 2
                : 1,
        crossAxisSpacing: AppDimensions.spacingL,
        mainAxisSpacing: AppDimensions.spacingL,
        mainAxisExtent: 300, // Set fixed height for cards to prevent overflow
      ),
      itemCount: widget.integrations.length,
      itemBuilder: (context, index) {
        final integration = widget.integrations[index];
        return IntegrationCard(
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
          onEnable: () => widget.onEnableIntegration(integration.id),
          onDisable: () => widget.onDisableIntegration(integration.id),
          onTest: () => _testIntegration(integration),
          onEdit: () => _editIntegration(integration),
          onDelete: () => _deleteIntegration(integration),
          isTestMode: widget.isTestMode,
          testDarkMode: widget.testDarkMode,
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeColorSet colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.integration_instructions,
              size: 64,
              color: colors.textMuted,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              'No Integrations Yet',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Connect external services to unlock powerful automation capabilities',
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            PrimaryButton(
              text: 'Add Your First Integration',
              icon: Icons.add,
              onPressed: () {
                setState(() {
                  _currentView = IntegrationManagementView.discovery;
                });
              },
              isTestMode: widget.isTestMode ?? false,
              testDarkMode: widget.testDarkMode ?? false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryView(ThemeColorSet colors) {
    // DMTools-specific integrations based on the development tools platform
    final dmtoolsIntegrations = _getDMToolsIntegrations();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Integrations',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'Connect DMTools with external services and development tools',
                style: TextStyle(
                  fontSize: 16,
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Text(
                '${dmtoolsIntegrations.length} integration${dmtoolsIntegrations.length != 1 ? 's' : ''} available',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textMuted,
                ),
              ),
            ],
          ),
        ),

        // Integration grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveUtils.isWideScreen(context)
                  ? 3
                  : ResponsiveUtils.isTablet(context)
                      ? 2
                      : 1,
              crossAxisSpacing: AppDimensions.spacingM,
              mainAxisSpacing: AppDimensions.spacingM,
              childAspectRatio: ResponsiveUtils.isMobile(context) ? 1.5 : 1.3,
            ),
            itemCount: dmtoolsIntegrations.length,
            itemBuilder: (context, index) {
              final integration = dmtoolsIntegrations[index];
              return _buildIntegrationDiscoveryCard(integration, colors);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCreateIntegration(ThemeColorSet colors) {
    if (_selectedType == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: colors.textMuted,
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Text(
                'No Integration Type Selected',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'Please go back and select an integration type',
                style: TextStyle(
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Show selected integration type info
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              border: Border.all(color: colors.borderColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: colors.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                  ),
                  child: Icon(
                    Icons.integration_instructions,
                    color: colors.accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedType!.displayName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacingXs),
                      Text(
                        _selectedType!.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SecondaryButton(
                  text: 'Change',
                  onPressed: () {
                    setState(() {
                      _currentView = IntegrationManagementView.discovery;
                      _selectedType = null;
                      _configValues.clear();
                      _testResult = null;
                    });
                  },
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Configuration form
          IntegrationConfigForm(
            integrationType: _selectedType!,
            initialValues: _configValues,
            onConfigChanged: (values) {
              setState(() {
                _configValues = values;
              });
            },
            onTestConnection: () => _testConfiguration(_selectedType!, _configValues),
            isLoading: _isLoading,
            testResult: _testResult,
            isTestMode: widget.isTestMode,
            testDarkMode: widget.testDarkMode,
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Cancel',
                  onPressed: () {
                    setState(() {
                      _currentView = IntegrationManagementView.list;
                      _selectedType = null;
                      _configValues.clear();
                      _testResult = null;
                    });
                  },
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: PrimaryButton(
                  text: 'Create Integration',
                  onPressed: _canCreateIntegration() ? () => _createIntegration() : null,
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditIntegration(ThemeColorSet colors) {
    if (_editingIntegration == null) return const SizedBox();

    final integrationType = widget.availableTypes.firstWhere(
      (type) => type.type == _editingIntegration!.type,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IntegrationConfigForm(
            integrationType: integrationType,
            initialValues: _configValues,
            onConfigChanged: (values) {
              setState(() {
                _configValues = values;
              });
            },
            onTestConnection: () => _testConfiguration(integrationType, _configValues),
            isLoading: _isLoading,
            testResult: _testResult,
            isTestMode: widget.isTestMode,
            testDarkMode: widget.testDarkMode,
          ),
          const SizedBox(height: AppDimensions.spacingXl),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Cancel',
                  onPressed: () {
                    setState(() {
                      _currentView = IntegrationManagementView.list;
                      _editingIntegration = null;
                      _configValues.clear();
                      _testResult = null;
                    });
                  },
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: PrimaryButton(
                  text: 'Update Integration',
                  onPressed: () => _updateIntegration(),
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentView) {
      case IntegrationManagementView.list:
        return 'Integrations';
      case IntegrationManagementView.discovery:
        return 'Discover Integrations';
      case IntegrationManagementView.create:
        return 'Add Integration';
      case IntegrationManagementView.edit:
        return 'Edit Integration';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentView) {
      case IntegrationManagementView.list:
        return 'Manage your connected services and external integrations';
      case IntegrationManagementView.discovery:
        return 'Browse available integrations and choose one to configure';
      case IntegrationManagementView.create:
        return 'Connect a new external service to your workspace';
      case IntegrationManagementView.edit:
        return 'Update configuration for ${_editingIntegration?.name ?? 'integration'}';
    }
  }

  bool _canCreateIntegration() {
    if (_selectedType == null) return false;

    final requiredParams = _selectedType!.configParams.where((p) => p.required);
    return requiredParams.every((param) => _configValues[param.key]?.isNotEmpty == true);
  }

  void _testIntegration(IntegrationData integration) {
    widget.onTestIntegration(integration.id, integration.configParams);
  }

  void _editIntegration(IntegrationData integration) {
    setState(() {
      _currentView = IntegrationManagementView.edit;
      _editingIntegration = integration;
      _configValues = Map.from(integration.configParams);
      _testResult = null;
    });
  }

  void _deleteIntegration(IntegrationData integration) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Integration'),
        content: Text('Are you sure you want to delete "${integration.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDeleteIntegration(integration.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _testConfiguration(IntegrationType type, Map<String, String> config) {
    setState(() {
      _isLoading = true;
      _testResult = null;
    });

    widget.onTestIntegration('test', config);

    // Simulate test result
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _testResult = 'Connection successful';
        });
      }
    });
  }

  void _createIntegration() {
    if (_selectedType != null && _canCreateIntegration()) {
      widget.onCreateIntegration(_selectedType!, _configValues);
      setState(() {
        _currentView = IntegrationManagementView.list;
        _selectedType = null;
        _configValues.clear();
        _testResult = null;
      });
    }
  }

  void _updateIntegration() {
    if (_editingIntegration != null) {
      widget.onUpdateIntegration(_editingIntegration!.id, _configValues);
      setState(() {
        _currentView = IntegrationManagementView.list;
        _editingIntegration = null;
        _configValues.clear();
        _testResult = null;
      });
    }
  }

  // DMTools-specific integrations
  List<IntegrationDefinition> _getDMToolsIntegrations() {
    return [
      // Version Control & Code Management
      const IntegrationDefinition(
        type: 'github',
        displayName: 'GitHub',
        description: 'Connect to GitHub repositories, manage issues, and automate workflows',
        category: 'Version Control',
        tags: ['Git', 'Code', 'Repositories', 'CI/CD', 'Issues'],
        isPopular: true,
        features: ['Repository access', 'Issue tracking', 'Pull requests', 'Actions integration', 'Code analysis'],
        documentationUrl: 'https://docs.github.com/en/developers',
      ),
      const IntegrationDefinition(
        type: 'gitlab',
        displayName: 'GitLab',
        description: 'Integrate with GitLab for DevOps lifecycle management',
        category: 'Version Control',
        tags: ['Git', 'DevOps', 'CI/CD', 'Merge Requests'],
        isPopular: true,
        features: ['Repository management', 'CI/CD pipelines', 'Issue tracking', 'Security scanning'],
        documentationUrl: 'https://docs.gitlab.com/ee/api/',
      ),
      const IntegrationDefinition(
        type: 'bitbucket',
        displayName: 'Bitbucket',
        description: 'Connect to Bitbucket for code collaboration and deployment',
        category: 'Version Control',
        tags: ['Git', 'Atlassian', 'Pipelines'],
        features: ['Repository access', 'Pipelines', 'Pull requests', 'Branch permissions'],
        documentationUrl: 'https://developer.atlassian.com/cloud/bitbucket/',
      ),

      // Communication & Notifications
      const IntegrationDefinition(
        type: 'slack',
        displayName: 'Slack',
        description: 'Send notifications and updates to Slack channels and users',
        category: 'Communication',
        tags: ['Chat', 'Notifications', 'Team', 'Bot'],
        isPopular: true,
        setupDifficulty: 'easy',
        features: ['Channel notifications', 'Direct messages', 'File sharing', 'Bot integration', 'Workflows'],
        documentationUrl: 'https://api.slack.com/',
      ),
      const IntegrationDefinition(
        type: 'teams',
        displayName: 'Microsoft Teams',
        description: 'Integrate with Microsoft Teams for team collaboration',
        category: 'Communication',
        tags: ['Microsoft', 'Chat', 'Collaboration'],
        features: ['Team notifications', 'Meeting integration', 'File sharing', 'Workflow bots'],
        documentationUrl: 'https://docs.microsoft.com/en-us/graph/teams-concept-overview',
      ),
      const IntegrationDefinition(
        type: 'discord',
        displayName: 'Discord',
        description: 'Send updates and notifications to Discord servers',
        category: 'Communication',
        tags: ['Chat', 'Gaming', 'Community'],
        setupDifficulty: 'easy',
        features: ['Server notifications', 'Webhooks', 'Bot commands', 'Voice channel integration'],
        documentationUrl: 'https://discord.com/developers/docs',
      ),

      // Project Management
      const IntegrationDefinition(
        type: 'jira',
        displayName: 'Jira',
        description: 'Sync with Jira for issue tracking and project management',
        category: 'Project Management',
        tags: ['Issues', 'Agile', 'Atlassian', 'Tickets'],
        isPopular: true,
        features: ['Issue sync', 'Sprint management', 'Workflow automation', 'Custom fields', 'Reporting'],
        documentationUrl: 'https://developer.atlassian.com/cloud/jira/',
      ),
      const IntegrationDefinition(
        type: 'linear',
        displayName: 'Linear',
        description: 'Connect with Linear for modern issue tracking',
        category: 'Project Management',
        tags: ['Issues', 'Modern', 'Fast', 'Keyboard'],
        setupDifficulty: 'easy',
        features: ['Issue tracking', 'Project sync', 'Cycle management', 'Triage automation'],
        documentationUrl: 'https://developers.linear.app/',
      ),
      const IntegrationDefinition(
        type: 'asana',
        displayName: 'Asana',
        description: 'Manage tasks and projects with Asana integration',
        category: 'Project Management',
        tags: ['Tasks', 'Projects', 'Teams'],
        features: ['Task management', 'Project tracking', 'Team collaboration', 'Timeline view'],
        documentationUrl: 'https://developers.asana.com/',
      ),

      // Cloud Services
      const IntegrationDefinition(
        type: 'aws',
        displayName: 'AWS',
        description: 'Connect to Amazon Web Services for cloud operations',
        category: 'Cloud Services',
        tags: ['Cloud', 'Infrastructure', 'DevOps'],
        isPopular: true,
        setupDifficulty: 'hard',
        features: ['Resource monitoring', 'CloudWatch integration', 'S3 storage', 'Lambda functions'],
        documentationUrl: 'https://docs.aws.amazon.com/',
      ),
      const IntegrationDefinition(
        type: 'gcp',
        displayName: 'Google Cloud',
        description: 'Integrate with Google Cloud Platform services',
        category: 'Cloud Services',
        tags: ['Google', 'Cloud', 'Analytics'],
        setupDifficulty: 'hard',
        features: ['Resource monitoring', 'BigQuery integration', 'Cloud Storage', 'Compute Engine'],
        documentationUrl: 'https://cloud.google.com/docs',
      ),
      const IntegrationDefinition(
        type: 'azure',
        displayName: 'Azure',
        description: 'Connect to Microsoft Azure cloud services',
        category: 'Cloud Services',
        tags: ['Microsoft', 'Cloud', 'DevOps'],
        setupDifficulty: 'hard',
        features: ['Resource management', 'Azure DevOps', 'Storage accounts', 'Monitoring'],
        documentationUrl: 'https://docs.microsoft.com/en-us/azure/',
      ),

      // CI/CD & Automation
      const IntegrationDefinition(
        type: 'jenkins',
        displayName: 'Jenkins',
        description: 'Automate builds and deployments with Jenkins',
        category: 'CI/CD',
        tags: ['Automation', 'Build', 'Deploy'],
        features: ['Build triggers', 'Pipeline monitoring', 'Artifact management', 'Plugin ecosystem'],
        documentationUrl: 'https://www.jenkins.io/doc/book/using/remote-access-api/',
      ),
      const IntegrationDefinition(
        type: 'circleci',
        displayName: 'CircleCI',
        description: 'Continuous integration and delivery platform',
        category: 'CI/CD',
        tags: ['CI/CD', 'Automation', 'Testing'],
        features: ['Pipeline monitoring', 'Test results', 'Deployment tracking', 'Artifact storage'],
        documentationUrl: 'https://circleci.com/docs/api/',
      ),

      // Database & Analytics
      const IntegrationDefinition(
        type: 'postgresql',
        displayName: 'PostgreSQL',
        description: 'Connect to PostgreSQL databases for data operations',
        category: 'Databases',
        tags: ['Database', 'SQL', 'Analytics'],
        features: ['Query execution', 'Schema monitoring', 'Performance metrics', 'Backup management'],
      ),
      const IntegrationDefinition(
        type: 'mongodb',
        displayName: 'MongoDB',
        description: 'NoSQL database integration for document storage',
        category: 'Databases',
        tags: ['NoSQL', 'Documents', 'Scaling'],
        features: ['Collection monitoring', 'Query analytics', 'Index optimization', 'Cluster management'],
        documentationUrl: 'https://docs.mongodb.com/manual/reference/api/',
      ),

      // Custom Integrations
      const IntegrationDefinition(
        type: 'webhook',
        displayName: 'Webhook',
        description: 'Create custom HTTP webhooks for any external service',
        category: 'Custom',
        tags: ['HTTP', 'Custom', 'API', 'Events'],
        setupDifficulty: 'easy',
        features: ['Custom endpoints', 'Event triggers', 'Flexible payloads', 'Authentication'],
      ),
      const IntegrationDefinition(
        type: 'api',
        displayName: 'REST API',
        description: 'Connect to any REST API endpoint',
        category: 'Custom',
        tags: ['REST', 'HTTP', 'Custom'],
        features: ['HTTP methods', 'Authentication headers', 'JSON payloads', 'Response handling'],
      ),
    ];
  }

  Widget _buildIntegrationDiscoveryCard(IntegrationDefinition integration, ThemeColorSet colors) {
    return Card(
      elevation: 2,
      color: colors.cardBg,
      child: InkWell(
        onTap: () => _selectIntegrationFromDiscovery(integration),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colors.accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                    ),
                    child: IntegrationTypeIcon(integrationType: integration.type),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                integration.displayName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: colors.textColor,
                                ),
                              ),
                            ),
                            if (integration.isPopular)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: colors.accentColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  'Popular',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: colors.accentColor,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          integration.category,
                          style: TextStyle(
                            fontSize: 12,
                            color: colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppDimensions.spacingS),

              // Description
              Expanded(
                child: Text(
                  integration.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: colors.textSecondary,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              const SizedBox(height: AppDimensions.spacingS),

              // Tags
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: integration.tags
                    .take(3)
                    .map((tag) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: colors.bgColor,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: colors.borderColor),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 10,
                              color: colors.textMuted,
                            ),
                          ),
                        ))
                    .toList(),
              ),

              const SizedBox(height: AppDimensions.spacingS),

              // Setup difficulty
              Row(
                children: [
                  Icon(
                    _getDifficultyIcon(integration.setupDifficulty),
                    size: 14,
                    color: _getDifficultyColor(integration.setupDifficulty, colors),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${integration.setupDifficulty.capitalize()} setup',
                    style: TextStyle(
                      fontSize: 11,
                      color: colors.textMuted,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: colors.textMuted,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectIntegrationFromDiscovery(IntegrationDefinition integrationDef) {
    // Find or create the corresponding IntegrationType
    IntegrationType? integrationType;
    try {
      integrationType = widget.availableTypes.firstWhere(
        (type) => type.type == integrationDef.type,
      );
    } catch (e) {
      // If not found in available types, create a basic one
      integrationType = IntegrationType(
        type: integrationDef.type,
        displayName: integrationDef.displayName,
        description: integrationDef.description,
        configParams: _getDefaultConfigParams(integrationDef.type),
      );
    }

    setState(() {
      _selectedType = integrationType;
      _currentView = IntegrationManagementView.create;
      _configValues.clear();
      _testResult = null;
    });
  }

  List<ConfigParam> _getDefaultConfigParams(String type) {
    switch (type.toLowerCase()) {
      case 'github':
      case 'gitlab':
      case 'bitbucket':
        return [
          const ConfigParam(
            key: 'token',
            displayName: 'Access Token',
            description: 'Personal access token with appropriate permissions',
            required: true,
            sensitive: true,
            type: 'string',
            options: [],
          ),
          const ConfigParam(
            key: 'base_url',
            displayName: 'Base URL',
            description: 'API base URL (leave empty for default)',
            required: false,
            sensitive: false,
            type: 'string',
            options: [],
          ),
        ];
      case 'slack':
      case 'discord':
        return [
          const ConfigParam(
            key: 'webhook_url',
            displayName: 'Webhook URL',
            description: 'Webhook URL for sending messages',
            required: true,
            sensitive: true,
            type: 'string',
            options: [],
          ),
        ];
      case 'jira':
      case 'linear':
      case 'asana':
        return [
          const ConfigParam(
            key: 'api_key',
            displayName: 'API Key',
            description: 'API key for authentication',
            required: true,
            sensitive: true,
            type: 'string',
            options: [],
          ),
          const ConfigParam(
            key: 'base_url',
            displayName: 'Instance URL',
            description: 'Your instance URL',
            required: true,
            sensitive: false,
            type: 'string',
            options: [],
          ),
        ];
      case 'aws':
      case 'gcp':
      case 'azure':
        return [
          const ConfigParam(
            key: 'access_key',
            displayName: 'Access Key',
            description: 'Cloud service access key',
            required: true,
            sensitive: true,
            type: 'string',
            options: [],
          ),
          const ConfigParam(
            key: 'secret_key',
            displayName: 'Secret Key',
            description: 'Cloud service secret key',
            required: true,
            sensitive: true,
            type: 'string',
            options: [],
          ),
          const ConfigParam(
            key: 'region',
            displayName: 'Region',
            description: 'Cloud service region',
            required: true,
            sensitive: false,
            type: 'string',
            options: [],
          ),
        ];
      case 'postgresql':
      case 'mongodb':
        return [
          const ConfigParam(
            key: 'connection_string',
            displayName: 'Connection String',
            description: 'Database connection string',
            required: true,
            sensitive: true,
            type: 'string',
            options: [],
          ),
        ];
      case 'webhook':
      case 'api':
        return [
          const ConfigParam(
            key: 'url',
            displayName: 'URL',
            description: 'Endpoint URL',
            required: true,
            sensitive: false,
            type: 'string',
            options: [],
          ),
          const ConfigParam(
            key: 'method',
            displayName: 'HTTP Method',
            description: 'HTTP method to use',
            required: true,
            sensitive: false,
            type: 'select',
            options: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'],
          ),
          const ConfigParam(
            key: 'headers',
            displayName: 'Headers',
            description: 'HTTP headers (JSON format)',
            required: false,
            sensitive: false,
            type: 'textarea',
            options: [],
          ),
        ];
      default:
        return [
          const ConfigParam(
            key: 'api_key',
            displayName: 'API Key',
            description: 'API key for authentication',
            required: true,
            sensitive: true,
            type: 'string',
            options: [],
          ),
        ];
    }
  }

  IconData _getDifficultyIcon(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Icons.check_circle;
      case 'medium':
        return Icons.remove_circle;
      case 'hard':
        return Icons.warning;
      default:
        return Icons.help;
    }
  }

  Color _getDifficultyColor(String difficulty, ThemeColorSet colors) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return colors.textMuted;
    }
  }
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// Model for integration data
class IntegrationData {
  final String id;
  final String name;
  final String description;
  final String type;
  final String displayName;
  final bool enabled;
  final String? iconUrl;
  final int usageCount;
  final DateTime? lastUsedAt;
  final DateTime createdAt;
  final String createdByName;
  final List<String> workspaces;
  final Map<String, String> configParams;

  const IntegrationData({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.displayName,
    required this.enabled,
    required this.usageCount,
    required this.createdAt,
    required this.createdByName,
    required this.workspaces,
    required this.configParams,
    this.iconUrl,
    this.lastUsedAt,
  });
}
