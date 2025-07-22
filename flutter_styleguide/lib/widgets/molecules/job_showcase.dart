import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Showcase widget for AI Job Configuration molecules
class JobConfigurationShowcase extends StatefulWidget {
  const JobConfigurationShowcase({super.key});

  @override
  State<JobConfigurationShowcase> createState() => _JobConfigurationShowcaseState();
}

class _JobConfigurationShowcaseState extends State<JobConfigurationShowcase> {
  JobType? _selectedJobType;
  Map<String, dynamic> _configValues = {};
  List<String> _selectedIntegrations = [];
  bool _isLoading = false;
  String? _testResult;

  // Sample data for demonstrations
  static const List<JobType> _sampleJobTypes = [
    JobType(
      type: 'expert',
      displayName: 'Expert Analysis',
      description: 'AI-powered expert analysis and recommendations for project issues',
      parameters: [
        JobParameter(
          key: 'ticketKey',
          displayName: 'Ticket Key',
          description: 'The key of the ticket to analyze',
          required: true,
          type: 'string',
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
    ),
    JobType(
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
      ],
      requiredIntegrations: ['TrackerClient', 'AI'],
    ),
  ];

  static const List<IntegrationCategory> _sampleIntegrations = [
    IntegrationCategory(
      type: 'TrackerClient',
      displayName: 'Project Tracker',
      description: 'Integration with project management tools like Jira',
      available: true,
    ),
    IntegrationCategory(
      type: 'AI',
      displayName: 'AI Service',
      description: 'AI analysis and generation capabilities',
      available: true,
    ),
    IntegrationCategory(
      type: 'SourceCode',
      displayName: 'Source Code',
      description: 'Access to source code repositories',
      available: true,
    ),
  ];

  static final List<JobConfigurationData> _sampleConfigurations = [
    JobConfigurationData(
      id: '1',
      name: 'Bug Analysis Configuration',
      description: 'Comprehensive analysis of bug reports with code examination and recommendations',
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
        'ticketKey': 'DMC-123',
      },
    ),
    JobConfigurationData(
      id: '2',
      name: 'Test Cases Generator',
      description: 'Generate comprehensive test cases for user stories and requirements',
      jobType: 'testcasesgenerator',
      enabled: false,
      executionCount: 8,
      lastExecutedAt: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
      createdByName: 'Jane Tester',
      requiredIntegrations: ['TrackerClient', 'AI'],
      parameters: {
        'testCaseType': 'both',
        'includeEdgeCases': true,
        'maxTestCases': 25,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
            'Job Configuration Cards', 'Individual configuration cards with execution controls and status tracking'),
        _buildJobCards(),
        const SizedBox(height: AppDimensions.spacingXl),
        _buildSectionHeader('Job Type Selector',
            'Interactive grid selector for choosing AI job types when creating new configurations'),
        _buildJobTypeSelector(),
        const SizedBox(height: AppDimensions.spacingXl),
        _buildSectionHeader('Job Configuration Form',
            'Dynamic configuration form that generates fields based on job type parameters and integration requirements'),
        _buildJobConfigForm(),
      ],
    );
  }

  Widget _buildSectionHeader(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.colors.textColor,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingS),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colors.textSecondary,
              ),
        ),
        const SizedBox(height: AppDimensions.spacingM),
      ],
    );
  }

  Widget _buildJobCards() {
    return SizedBox(
      height: 360, // Increased from 320px to accommodate content better
      child: Row(
        children: [
          Expanded(
            child: JobConfigurationCard(
              id: _sampleConfigurations[0].id,
              name: _sampleConfigurations[0].name,
              description: _sampleConfigurations[0].description,
              jobType: _sampleConfigurations[0].jobType,
              enabled: _sampleConfigurations[0].enabled,
              executionCount: _sampleConfigurations[0].executionCount,
              lastExecutedAt: _sampleConfigurations[0].lastExecutedAt,
              createdAt: _sampleConfigurations[0].createdAt,
              createdByName: _sampleConfigurations[0].createdByName,
              requiredIntegrations: _sampleConfigurations[0].requiredIntegrations,
              onExecute: () => _showAction('Execute ${_sampleConfigurations[0].name}'),
              onTest: () => _showAction('Test ${_sampleConfigurations[0].name}'),
              onEdit: () => _showAction('Edit ${_sampleConfigurations[0].name}'),
              onDelete: () => _showAction('Delete ${_sampleConfigurations[0].name}'),
              isTestMode: true,
              testDarkMode: context.isDarkMode,
            ),
          ),
          const SizedBox(width: AppDimensions.spacingM),
          Expanded(
            child: JobConfigurationCard(
              id: _sampleConfigurations[1].id,
              name: _sampleConfigurations[1].name,
              description: _sampleConfigurations[1].description,
              jobType: _sampleConfigurations[1].jobType,
              enabled: _sampleConfigurations[1].enabled,
              executionCount: _sampleConfigurations[1].executionCount,
              lastExecutedAt: _sampleConfigurations[1].lastExecutedAt,
              createdAt: _sampleConfigurations[1].createdAt,
              createdByName: _sampleConfigurations[1].createdByName,
              requiredIntegrations: _sampleConfigurations[1].requiredIntegrations,
              onExecute: () => _showAction('Execute ${_sampleConfigurations[1].name}'),
              onTest: () => _showAction('Test ${_sampleConfigurations[1].name}'),
              onEdit: () => _showAction('Edit ${_sampleConfigurations[1].name}'),
              onDelete: () => _showAction('Delete ${_sampleConfigurations[1].name}'),
              isTestMode: true,
              testDarkMode: context.isDarkMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobTypeSelector() {
    return SizedBox(
      height: 300,
      child: JobTypeSelector(
        jobTypes: _sampleJobTypes,
        selectedType: _selectedJobType ?? _sampleJobTypes.first,
        onSelectionChanged: (type) {
          setState(() {
            _selectedJobType = type;
          });
          _showAction('Selected job type: ${type.displayName}');
        },
        isTestMode: true,
        testDarkMode: context.isDarkMode,
      ),
    );
  }

  Widget _buildJobConfigForm() {
    final jobType = _selectedJobType ?? _sampleJobTypes.first;

    return Container(
      height: 700, // Increased from 600px to prevent overflow
      decoration: BoxDecoration(
        border: Border.all(color: context.colors.borderColor.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
      ),
      child: JobConfigForm(
        jobType: jobType,
        availableIntegrations: _sampleIntegrations,
        initialValues: _configValues.isNotEmpty
            ? _configValues
            : {
                'ticketKey': 'DMC-123',
                'includeCodeAnalysis': true,
                'outputFormat': 'comment',
              },
        initialIntegrations: _selectedIntegrations.isNotEmpty ? _selectedIntegrations : ['TrackerClient', 'AI'],
        onConfigChanged: (values) {
          setState(() {
            _configValues = values;
          });
        },
        onNameChanged: (name) {
          // Handle name change
        },
        onIntegrationsChanged: (integrations) {
          setState(() {
            _selectedIntegrations = integrations;
          });
        },
        onTestConfiguration: () {
          setState(() {
            _isLoading = true;
            _testResult = null;
          });

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _testResult = 'Configuration test successful';
              });
              _showAction('Configuration tested successfully');
            }
          });
        },
        onCreateIntegration: () => _showAction('Create Integration requested'),
        isLoading: _isLoading,
        testResult: _testResult,
        isTestMode: true,
        testDarkMode: context.isDarkMode,
      ),
    );
  }

  void _showAction(String action) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(action),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
