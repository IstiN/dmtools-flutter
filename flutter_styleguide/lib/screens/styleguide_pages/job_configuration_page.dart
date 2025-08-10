import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class JobConfigurationPage extends StatefulWidget {
  const JobConfigurationPage({super.key});

  @override
  State<JobConfigurationPage> createState() => _JobConfigurationPageState();
}

class _JobConfigurationPageState extends State<JobConfigurationPage> {
  // Sample data for demos
  final List<JobType> _sampleJobTypes = [
    const JobType(
      type: 'expert',
      displayName: 'Expert Analysis',
      description: 'AI-powered expert analysis and recommendations for project issues and requirements',
      parameters: [
        JobParameter(
          key: 'ticketKey',
          displayName: 'Ticket Key',
          description: 'The key of the ticket to analyze (e.g., DMC-123)',
          required: true,
          type: 'string',
        ),
        JobParameter(
          key: 'projectContext',
          displayName: 'Project Context',
          description: 'Additional context about the project',
          required: false,
          type: 'textarea',
        ),
        JobParameter(
          key: 'includeCodeAnalysis',
          displayName: 'Include Code Analysis',
          description: 'Whether to include source code analysis',
          required: false,
          type: 'boolean',
          defaultValue: true,
        ),
        JobParameter(
          key: 'outputFormat',
          displayName: 'Output Format',
          description: 'Format for the analysis output',
          required: true,
          type: 'select',
          options: ['comment', 'field', 'creation'],
          defaultValue: 'comment',
        ),
      ],
      requiredIntegrations: ['TrackerClient', 'AI'],
      optionalIntegrations: ['SourceCode'],
    ),
    const JobType(
      type: 'testcasesgenerator',
      displayName: 'Test Cases Generator',
      description: 'Generate comprehensive test cases for user stories and requirements',
      parameters: [
        JobParameter(
          key: 'ticketKey',
          displayName: 'Ticket Key',
          description: 'The key of the ticket to generate test cases for',
          required: true,
          type: 'string',
        ),
        JobParameter(
          key: 'testCaseType',
          displayName: 'Test Case Type',
          description: 'Type of test cases to generate',
          required: false,
          type: 'select',
          options: ['manual', 'automated', 'both'],
          defaultValue: 'both',
        ),
        JobParameter(
          key: 'includeEdgeCases',
          displayName: 'Include Edge Cases',
          description: 'Generate edge cases and negative scenarios',
          required: false,
          type: 'boolean',
          defaultValue: true,
        ),
        JobParameter(
          key: 'maxTestCases',
          displayName: 'Maximum Test Cases',
          description: 'Maximum number of test cases to generate',
          required: false,
          type: 'integer',
          defaultValue: 20,
        ),
      ],
      requiredIntegrations: ['TrackerClient', 'AI'],
      optionalIntegrations: ['Documentation'],
    ),
  ];

  final List<IntegrationCategory> _sampleIntegrations = [
    const IntegrationCategory(
      type: 'TrackerClient',
      displayName: 'Project Tracker',
      description: 'Integration with project management tools like Jira',
      available: true,
    ),
    const IntegrationCategory(
      type: 'AI',
      displayName: 'AI Service',
      description: 'AI analysis and generation capabilities',
      available: true,
    ),
    const IntegrationCategory(
      type: 'Documentation',
      displayName: 'Documentation',
      description: 'Integration with documentation platforms like Confluence',
      available: false,
    ),
    const IntegrationCategory(
      type: 'SourceCode',
      displayName: 'Source Code',
      description: 'Access to source code repositories',
      available: true,
    ),
  ];

  final List<JobConfigurationData> _sampleConfigurations = [
    JobConfigurationData(
      id: '1',
      name: 'Bug Analysis Configuration',
      description: 'Comprehensive analysis of bug reports with code examination',
      jobType: 'expert',
      enabled: true,
      executionCount: 15,
      lastExecutedAt: DateTime.now().subtract(const Duration(hours: 2)),
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      createdByName: 'John Developer',
      requiredIntegrations: ['TrackerClient', 'AI', 'SourceCode'],
      parameters: {
        'includeCodeAnalysis': true,
        'outputFormat': 'comment',
        'projectContext': 'E-commerce platform bug analysis',
      },
    ),
    JobConfigurationData(
      id: '2',
      name: 'API Test Generation',
      description: 'Generate comprehensive test cases for REST API endpoints',
      jobType: 'testcasesgenerator',
      enabled: true,
      executionCount: 8,
      lastExecutedAt: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      createdByName: 'Jane Tester',
      requiredIntegrations: ['TrackerClient', 'AI'],
      parameters: {'testCaseType': 'both', 'includeEdgeCases': true, 'maxTestCases': 25},
    ),
    JobConfigurationData(
      id: '3',
      name: 'Feature Analysis (Disabled)',
      description: 'Analysis of new feature requirements with impact assessment',
      jobType: 'expert',
      enabled: false,
      executionCount: 3,
      lastExecutedAt: DateTime.now().subtract(const Duration(days: 7)),
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      createdByName: 'Alex Analyst',
      requiredIntegrations: ['TrackerClient', 'AI', 'Documentation'],
      parameters: {'includeCodeAnalysis': false, 'outputFormat': 'field'},
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JobConfigurationManagement(
        configurations: _sampleConfigurations,
        availableTypes: _sampleJobTypes,
        availableIntegrations: _sampleIntegrations,
        onCreateConfiguration: (type, name, config, integrations) =>
            _showActionDialog('Create ${type.displayName} configuration: $name'),
        onUpdateConfiguration: (id, name, config, integrations) => _showActionDialog('Update configuration $id: $name'),
        onDeleteConfiguration: (id) => _showActionDialog('Delete configuration $id'),
        onExecuteConfiguration: (id) => _showActionDialog('Execute configuration $id'),
        onTestConfiguration: (id, config) => _showActionDialog('Test configuration $id'),
        onGetConfigurationDetails: (id) async {
          await Future.delayed(const Duration(milliseconds: 300));
          return _sampleConfigurations.firstWhere(
            (config) => config.id == id,
            orElse: () => _sampleConfigurations.first,
          );
        },
        isTestMode: true,
        testDarkMode: context.isDarkMode,
      ),
    );
  }

  void _showActionDialog(String action) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(action), duration: const Duration(seconds: 2)));
  }
}

/// Helper widget for component display
class ComponentDisplay extends StatelessWidget {
  final String title;
  final String description;
  final Widget child;

  const ComponentDisplay({required this.title, required this.description, required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: context.colors.textColor),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: context.colors.textSecondary)),
        const SizedBox(height: AppDimensions.spacingM),
        child,
      ],
    );
  }
}
