import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class WebhookExamplesSection extends StatefulWidget {
  final String jobConfigurationId;
  final String webhookUrl;
  final String? sampleApiKey;
  final List<WebhookIntegrationType> supportedTypes;
  final List<WebhookExampleData>? examplesData;
  final Future<List<WebhookExampleData>?> Function()? onLoadExamples;

  const WebhookExamplesSection({
    required this.jobConfigurationId,
    required this.webhookUrl,
    this.sampleApiKey,
    this.supportedTypes = const [
      WebhookIntegrationType.jiraAutomation,
      WebhookIntegrationType.githubActions,
      WebhookIntegrationType.curl,
      WebhookIntegrationType.postman,
    ],
    this.examplesData,
    this.onLoadExamples,
    super.key,
  });

  @override
  State<WebhookExamplesSection> createState() => _WebhookExamplesSectionState();
}

class _WebhookExamplesSectionState extends State<WebhookExamplesSection> {
  WebhookIntegrationType _selectedType = WebhookIntegrationType.curl;
  List<WebhookExampleData>? _apiExamples;
  bool _isLoadingExamples = false;

  @override
  void initState() {
    super.initState();
    if (widget.supportedTypes.isNotEmpty) {
      _selectedType = widget.supportedTypes.first;
    }

    // Load examples from API if callback is provided
    if (widget.onLoadExamples != null && widget.examplesData == null) {
      _loadApiExamples();
    } else if (widget.examplesData != null) {
      _apiExamples = widget.examplesData;
      _updateSelectedTypeForApiExamples();
    }
  }

  Future<void> _loadApiExamples() async {
    if (_isLoadingExamples) return;

    setState(() {
      _isLoadingExamples = true;
    });

    try {
      final examples = await widget.onLoadExamples!();
      if (mounted) {
        setState(() {
          _apiExamples = examples;
          _isLoadingExamples = false;
        });
        _updateSelectedTypeForApiExamples();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingExamples = false;
        });
      }
    }
  }

  /// Update selected type to match available API examples
  void _updateSelectedTypeForApiExamples() {
    if (_apiExamples != null && _apiExamples!.isNotEmpty) {
      final availableTypes = _apiExamples!.map((example) => example.type).toSet().toList();

      // If current selected type is not available in API examples, switch to the first available one
      if (!availableTypes.contains(_selectedType)) {
        setState(() {
          _selectedType = availableTypes.first;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(colors),
        const SizedBox(height: 16),
        _buildTypeSelector(colors),
        const SizedBox(height: 16),
        _buildExampleContent(colors),
      ],
    );
  }

  Widget _buildHeader(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Integration Examples',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 4),
        Text(
          'Use these examples to integrate webhooks with your external systems',
          style: TextStyle(fontSize: 14, color: colors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildTypeSelector(ThemeColorSet colors) {
    final availableTypes = _getAvailableTypes();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: availableTypes.map((type) {
          final isSelected = type == _selectedType;
          final displayName = _getDisplayNameForType(type);
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _IntegrationTypeChip(
              type: type,
              displayName: displayName,
              isSelected: isSelected,
              onTap: () => setState(() => _selectedType = type),
              colors: colors,
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Get available integration types based on API examples or fallback to supported types
  List<WebhookIntegrationType> _getAvailableTypes() {
    if (_apiExamples != null && _apiExamples!.isNotEmpty) {
      // Use only the types that we have API examples for
      return _apiExamples!.map((example) => example.type).toSet().toList();
    }

    // Fallback to the widget's supported types
    return widget.supportedTypes;
  }

  /// Get display name for type - prefer API response name over hardcoded enum name
  String _getDisplayNameForType(WebhookIntegrationType type) {
    if (_apiExamples != null && _apiExamples!.isNotEmpty) {
      // Find the API example for this type and use its name
      final apiExample = _apiExamples!.firstWhere(
        (example) => example.type == type,
        orElse: () => WebhookExampleData(type: type, name: type.displayName, content: ''),
      );
      return apiExample.name;
    }

    // Fallback to hardcoded enum display name
    return type.displayName;
  }

  Widget _buildExampleContent(ThemeColorSet colors) {
    if (_isLoadingExamples) {
      return _buildLoadingState(colors);
    }

    final example = _getExampleForType(_selectedType);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getIconForType(_selectedType), size: 20, color: colors.accentColor),
                const SizedBox(width: 8),
                Text(
                  example.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textColor),
                ),
                if (_apiExamples != null) ...[
                  const SizedBox(width: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: colors.successColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        'Live',
                        style: TextStyle(fontSize: 11, color: colors.successColor, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(example.description, style: TextStyle(fontSize: 14, color: colors.textSecondary)),
            const SizedBox(height: 16),
            _buildExampleCodeSection(example),
            if (example.additionalNotes != null) ...[
              const SizedBox(height: 12),
              _buildAdditionalNotes(example.additionalNotes!, colors),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: const Padding(
        padding: EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [CircularProgressIndicator(), SizedBox(height: 12), Text('Loading webhook examples...')],
          ),
        ),
      ),
    );
  }

  Widget _buildAdditionalNotes(String notes, ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.infoColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.infoColor.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: colors.infoColor),
            const SizedBox(width: 8),
            Expanded(
              child: Text(notes, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCodeSection(WebhookExample example) {
    // If we have API examples, the content is markdown
    if (_apiExamples != null && _apiExamples!.isNotEmpty) {
      return MarkdownRenderer(data: example.code, shrinkWrap: true);
    }

    // Fallback: use CodeDisplayBlock for non-API examples
    return CodeDisplayBlock(code: example.code, language: example.language, title: example.codeTitle);
  }

  WebhookExample _getExampleForType(WebhookIntegrationType type) {
    // First, try to use API examples if available
    if (_apiExamples != null) {
      final apiExample = _apiExamples!.firstWhere(
        (example) => example.type == type,
        orElse: () => _apiExamples!.first, // fallback to first example
      );

      return WebhookExample(
        title: apiExample.name,
        description: 'Live example generated from your job configuration',
        language: _getLanguageForType(type),
        codeTitle: 'Generated ${apiExample.name} Example',
        code: apiExample.content,
        additionalNotes: 'This is a live example generated from your actual job configuration and webhook settings.',
      );
    }

    // Fallback to hardcoded examples
    final apiKey = widget.sampleApiKey ?? 'your-api-key-here';
    final webhookUrl = widget.webhookUrl;

    switch (type) {
      case WebhookIntegrationType.curl:
        return WebhookExample(
          title: 'cURL Command',
          description: 'Execute webhook using command line',
          language: 'bash',
          codeTitle: 'Webhook Request',
          code:
              '''curl -X POST "$webhookUrl" \\
  -H "Content-Type: application/json" \\
  -H "X-API-Key: $apiKey" \\
  -d '{
    "jobParameters": {
      "input": "Custom input value",
      "configuration": "production"
    },
    "integrationMappings": {
      "jira": "jira-prod-integration-id",
      "slack": "slack-notifications-id"
    }
  }' ''',
          additionalNotes:
              'Replace the API key and parameters with your actual values. The response will include an execution ID for tracking.',
        );

      case WebhookIntegrationType.jiraAutomation:
        return WebhookExample(
          title: 'Jira Automation',
          description: 'Configure Jira automation rule to trigger webhook',
          language: 'json',
          codeTitle: 'Webhook Configuration',
          code:
              '''{
  "url": "$webhookUrl",
  "method": "POST",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "$apiKey"
  },
  "body": {
    "jobParameters": {
      "issueKey": "{{issue.key}}",
      "projectKey": "{{issue.project.key}}",
      "summary": "{{issue.summary}}",
      "status": "{{issue.status.name}}"
    },
    "integrationMappings": {
      "jira": "{{jira.integration.id}}",
      "slack": "{{slack.integration.id}}"
    }
  }
}''',
          additionalNotes:
              'Use this configuration in Jira Automation rules. Variables like {{issue.key}} will be automatically replaced.',
        );

      case WebhookIntegrationType.githubActions:
        return WebhookExample(
          title: 'GitHub Actions',
          description: 'Trigger webhook from GitHub workflow',
          language: 'yaml',
          codeTitle: 'Workflow Step',
          code:
              '''- name: Trigger DMTools Webhook
  run: |
    curl -X POST "$webhookUrl" \\
      -H "Content-Type: application/json" \\
      -H "X-API-Key: \${{ secrets.DMTOOLS_API_KEY }}" \\
      -d '{
        "jobParameters": {
          "repository": "\${{ github.repository }}",
          "ref": "\${{ github.ref }}",
          "sha": "\${{ github.sha }}",
          "actor": "\${{ github.actor }}"
        },
        "integrationMappings": {
          "github": "github-integration-id",
          "slack": "deployment-notifications-id"
        }
      }'
  env:
    WEBHOOK_URL: $webhookUrl''',
          additionalNotes: 'Store your API key in GitHub repository secrets as DMTOOLS_API_KEY for security.',
        );

      case WebhookIntegrationType.postman:
        return WebhookExample(
          title: 'Postman Collection',
          description: 'Import this collection to test webhook in Postman',
          language: 'json',
          codeTitle: 'Collection JSON',
          code:
              '''{
  "info": {
    "name": "DMTools Webhook",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Execute Job Configuration",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          },
          {
            "key": "X-API-Key",
            "value": "{{api_key}}"
          }
        ],
        "url": {
          "raw": "{{webhook_url}}",
          "host": ["{{webhook_url}}"]
        },
        "body": {
          "mode": "raw",
          "raw": "{\\n  \\"jobParameters\\": {\\n    \\"input\\": \\"{{input_value}}\\",\\n    \\"environment\\": \\"{{environment}}\\"\\n  },\\n  \\"integrationMappings\\": {\\n    \\"integration1\\": \\"{{integration1_id}}\\",\\n    \\"integration2\\": \\"{{integration2_id}}\\"\\n  }\\n}"
        }
      }
    }
  ],
  "variable": [
    {
      "key": "webhook_url",
      "value": "$webhookUrl"
    },
    {
      "key": "api_key",
      "value": "$apiKey"
    }
  ]
}''',
          additionalNotes:
              'Import this collection and set environment variables for webhook_url and api_key to get started.',
        );
    }
  }

  IconData _getIconForType(WebhookIntegrationType type) {
    switch (type) {
      case WebhookIntegrationType.curl:
        return Icons.terminal;
      case WebhookIntegrationType.jiraAutomation:
        return Icons.settings;
      case WebhookIntegrationType.githubActions:
        return Icons.code;
      case WebhookIntegrationType.postman:
        return Icons.api;
    }
  }

  String _getLanguageForType(WebhookIntegrationType type) {
    switch (type) {
      case WebhookIntegrationType.curl:
        return 'bash';
      case WebhookIntegrationType.jiraAutomation:
        return 'json';
      case WebhookIntegrationType.githubActions:
        return 'yaml';
      case WebhookIntegrationType.postman:
        return 'json';
    }
  }
}

class _IntegrationTypeChip extends StatelessWidget {
  final WebhookIntegrationType type;
  final String displayName;
  final bool isSelected;
  final VoidCallback onTap;
  final ThemeColorSet colors;

  const _IntegrationTypeChip({
    required this.type,
    required this.displayName,
    required this.isSelected,
    required this.onTap,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected ? colors.accentColor : colors.inputBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? colors.accentColor : colors.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            displayName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? colors.cardBg : colors.textColor,
            ),
          ),
        ),
      ),
    );
  }
}

class WebhookExample {
  final String title;
  final String description;
  final String language;
  final String codeTitle;
  final String code;
  final String? additionalNotes;

  const WebhookExample({
    required this.title,
    required this.description,
    required this.language,
    required this.codeTitle,
    required this.code,
    this.additionalNotes,
  });
}
