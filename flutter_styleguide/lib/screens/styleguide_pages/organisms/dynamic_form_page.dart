import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class DynamicFormPage extends StatefulWidget {
  const DynamicFormPage({super.key});

  @override
  State<DynamicFormPage> createState() => _DynamicFormPageState();
}

class _DynamicFormPageState extends State<DynamicFormPage> {
  Map<String, dynamic> _formValues = {};
  String _configName = '';
  List<String> _selectedIntegrations = [];

  final List<ConfigParameter> _sampleParameters = const [
    ConfigParameter(
      key: 'title',
      displayName: 'Configuration Title',
      description: 'Enter a descriptive title for this configuration',
      required: true,
      placeholder: 'My Configuration',
    ),
    ConfigParameter(
      key: 'enabled',
      displayName: 'Enable Configuration',
      description: 'Whether this configuration should be active',
      required: false,
      type: 'boolean',
      defaultValue: true,
    ),
    ConfigParameter(
      key: 'priority',
      displayName: 'Priority Level',
      description: 'Select the priority level for this configuration',
      required: true,
      type: 'select',
      options: ['Low', 'Medium', 'High', 'Critical'],
      defaultValue: 'Medium',
    ),
    ConfigParameter(
      key: 'maxRetries',
      displayName: 'Maximum Retries',
      description: 'Number of retry attempts allowed',
      required: true,
      type: 'number',
      defaultValue: 3,
    ),
    ConfigParameter(
      key: 'description',
      displayName: 'Description',
      description: 'Detailed description of the configuration purpose',
      required: false,
      type: 'textarea',
      placeholder: 'Enter a detailed description...',
    ),
    ConfigParameter(
      key: 'apiKey',
      displayName: 'API Key',
      description: 'Secret API key for authentication',
      required: true,
      sensitive: true,
      placeholder: 'Enter your API key...',
    ),
    ConfigParameter(
      key: 'agentParams.instructions',
      displayName: 'Agent Instructions',
      description: 'List of instructions for the AI agent to follow',
      required: true,
      type: 'array',
      placeholder: 'Add instruction',
    ),
    ConfigParameter(
      key: 'tags',
      displayName: 'Configuration Tags',
      description: 'Tags to categorize this configuration',
      required: false,
      type: 'array',
      placeholder: 'Add tag',
    ),
    ConfigParameter(
      key: 'allowedDomains',
      displayName: 'Allowed Domains',
      description: 'List of domains that are allowed to access this configuration',
      required: true,
      type: 'array',
      placeholder: 'example.com',
    ),
  ];

  final List<AvailableIntegration> _sampleIntegrations = const [
    AvailableIntegration(
      id: 'github-1',
      name: 'GitHub Production',
      type: 'github',
      displayName: 'GitHub Integration',
      enabled: true,
      description: 'Production GitHub integration for code repositories',
    ),
    AvailableIntegration(
      id: 'slack-1',
      name: 'Slack Workspace',
      type: 'slack',
      displayName: 'Slack Integration',
      enabled: true,
      description: 'Main workspace Slack integration',
    ),
    AvailableIntegration(
      id: 'jira-1',
      name: 'JIRA Project',
      type: 'jira',
      displayName: 'JIRA Integration',
      enabled: true,
      description: 'Primary JIRA project integration',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic Config Form'),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComponentDisplay(
              title: 'Dynamic Config Form with Array Support',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This demonstrates the DynamicConfigForm organism with full array parameter support. '
                    'The form includes various field types including the new array input functionality.',
                  ),
                  const SizedBox(height: AppDimensions.spacingL),

                  // Form demonstration
                  DynamicConfigForm(
                    title: 'AI Agent Configuration',
                    subtitle: 'Configure your AI agent with custom parameters and instructions',
                    parameters: _sampleParameters,
                    initialValues: const {
                      'title': 'Sample AI Agent',
                      'enabled': true,
                      'priority': 'High',
                      'maxRetries': 5,
                      'description': 'This is a sample configuration demonstrating array support.',
                      'agentParams.instructions': [
                        'Always be helpful and informative',
                        'Provide accurate and up-to-date information',
                        'Be concise but thorough in responses',
                      ],
                      'tags': ['ai', 'assistant', 'demo'],
                      'allowedDomains': ['example.com', 'demo.org'],
                    },
                    initialName: _configName,
                    requiredIntegrationTypes: const ['github', 'slack'],
                    availableIntegrations: _sampleIntegrations,
                    selectedIntegrations: _selectedIntegrations,
                    onConfigChanged: (values) {
                      setState(() {
                        _formValues = values;
                      });
                    },
                    onNameChanged: (name) {
                      setState(() {
                        _configName = name;
                      });
                    },
                    onIntegrationsChanged: (integrations) {
                      setState(() {
                        _selectedIntegrations = integrations;
                      });
                    },
                    onTestConfiguration: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Test configuration functionality triggered!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: AppDimensions.spacingXl),

                  // Current form values display
                  ComponentDisplay(
                    title: 'Current Form Values',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Real-time form state (including array values):'),
                        const SizedBox(height: AppDimensions.spacingM),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppDimensions.spacingM),
                          decoration: BoxDecoration(
                            color: context.colors.bgColor,
                            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                            border: Border.all(color: context.colors.borderColor.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Configuration Name: $_configName',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: AppDimensions.spacingS),
                              Text(
                                'Selected Integrations: ${_selectedIntegrations.join(", ")}',
                                style: const TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: AppDimensions.spacingS),
                              const Text('Form Values:', style: TextStyle(fontWeight: FontWeight.w500)),
                              const SizedBox(height: AppDimensions.spacingXs),
                              ..._formValues.entries.map((entry) {
                                final value = entry.value;
                                String displayValue;

                                if (value is List) {
                                  displayValue = '[${value.join(", ")}]';
                                } else if (value is bool) {
                                  displayValue = value ? 'true' : 'false';
                                } else {
                                  displayValue = value?.toString() ?? 'null';
                                }

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${entry.key}: $displayValue',
                                    style: TextStyle(
                                      fontFamily: 'monospace',
                                      fontSize: 12,
                                      color: context.colors.textSecondary,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
