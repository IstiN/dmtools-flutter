import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class WebhookPage extends StatefulWidget {
  const WebhookPage({super.key});

  @override
  State<WebhookPage> createState() => _WebhookPageState();
}

class _WebhookPageState extends State<WebhookPage> {
  bool _showGenerateModal = false;
  bool _showDisplayModal = false;
  final String _sampleApiKey = 'wh_1234567890abcdef1234567890abcdef';

  // Sample data for demonstration
  final List<WebhookKeyItemData> _sampleKeys = [
    WebhookKeyItemData(
      id: 'wh_1',
      name: 'Production Key',
      description: 'Main production webhook key for CI/CD pipeline',
      maskedValue: 'wh_****************************abcd',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      lastUsedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    WebhookKeyItemData(
      id: 'wh_2',
      name: 'Development Key',
      description: 'Development environment webhook key',
      maskedValue: 'wh_****************************efgh',
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    WebhookKeyItemData(
      id: 'wh_3',
      name: 'Testing Key',
      description: 'Key for automated testing',
      maskedValue: 'wh_****************************ijkl',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      lastUsedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: colors.bgColor,
          body: Column(
            children: [
              _buildHeader(colors),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildComponentSection(
                        'Webhook Management Section',
                        'Complete webhook management interface with API key management and integration examples',
                        _buildWebhookManagementExample(),
                      ),
                      const SizedBox(height: 40),
                      _buildComponentSection(
                        'Webhook Key List',
                        'List of webhook API keys with actions',
                        _buildWebhookKeyListExample(),
                      ),
                      const SizedBox(height: 40),
                      _buildComponentSection(
                        'Individual Webhook Key Items',
                        'Individual API key display with metadata and actions',
                        _buildWebhookKeyItemsExample(),
                      ),
                      const SizedBox(height: 40),
                      _buildComponentSection(
                        'Integration Examples',
                        'Code examples for different integration platforms',
                        _buildWebhookExamplesExample(),
                      ),
                      const SizedBox(height: 40),
                      _buildModalExamples(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        _buildOverlays(),
      ],
    );
  }

  Widget _buildHeader(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        boxShadow: [BoxShadow(color: colors.shadowColor.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            Icon(Icons.webhook, size: 32, color: colors.accentColor),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Webhook Components',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: colors.textColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Components for webhook API key management and integration examples',
                  style: TextStyle(fontSize: 16, color: colors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComponentSection(String title, String description, Widget component) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        Text(description, style: TextStyle(fontSize: 14, color: colors.textSecondary)),
        const SizedBox(height: 16),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.borderColor),
          ),
          child: Padding(padding: const EdgeInsets.all(24), child: component),
        ),
      ],
    );
  }

  Widget _buildWebhookManagementExample() {
    return WebhookManagementSection(
      jobConfigurationId: 'job_123',
      webhookUrl: 'https://api.dmtools.example.com/api/v1/job-configurations/job_123/webhook',
      apiKeys: _sampleKeys,
      onGenerateKey: (name, description) {
        // Handle key generation
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Generating key: $name')));
      },
      onCopyKey: (keyId) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API key copied to clipboard')));
      },
      onDeleteKey: (keyId) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleting key: $keyId')));
      },
    );
  }

  Widget _buildWebhookKeyListExample() {
    return WebhookKeyList(
      keys: _sampleKeys,
      onCopyKey: (keyId) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API key copied to clipboard')));
      },
      onDeleteKey: (keyId) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleting key: $keyId')));
      },
      onGenerateNew: () {
        setState(() {
          _showGenerateModal = true;
        });
      },
    );
  }

  Widget _buildWebhookKeyItemsExample() {
    return Column(
      children: _sampleKeys.map((key) {
        return Column(
          children: [
            WebhookKeyItem(
              id: key.id,
              name: key.name,
              description: key.description,
              maskedValue: key.maskedValue,
              createdAt: key.createdAt,
              lastUsedAt: key.lastUsedAt,
              onCopy: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('API key copied to clipboard')));
              },
              onDelete: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleting key: ${key.name}')));
              },
            ),
            if (_sampleKeys.last != key) const SizedBox(height: 16),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildWebhookExamplesExample() {
    return const WebhookExamplesSection(
      jobConfigurationId: 'job_123',
      webhookUrl: 'https://api.dmtools.example.com/api/v1/job-configurations/job_123/webhook',
      sampleApiKey: 'wh_sample1234567890abcdef1234567890',
    );
  }

  Widget _buildModalExamples() {
    final colors = context.colors;

    return _buildComponentSection(
      'Modal Examples',
      'Webhook-related modal dialogs for key generation and display',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PrimaryButton(
                text: 'Show Generate Modal',
                onPressed: () {
                  setState(() {
                    _showGenerateModal = true;
                  });
                },
                icon: Icons.key,
              ),
              const SizedBox(width: 16),
              PrimaryButton(
                text: 'Show Key Display Modal',
                onPressed: () {
                  setState(() {
                    _showDisplayModal = true;
                  });
                },
                icon: Icons.visibility,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Click the buttons above to preview the modal dialogs used for API key generation and one-time key display.',
            style: TextStyle(fontSize: 14, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlays() {
    if (_showGenerateModal) {
      return Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: WebhookKeyGenerateModal(
            onGenerate: (name, description) {
              setState(() {
                _showGenerateModal = false;
                _showDisplayModal = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Generated key: $name')));
            },
            onCancel: () {
              setState(() {
                _showGenerateModal = false;
              });
            },
          ),
        ),
      );
    }

    if (_showDisplayModal) {
      return Material(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: WebhookKeyDisplayModal(
            keyName: 'Sample API Key',
            apiKey: _sampleApiKey,
            onClose: () {
              setState(() {
                _showDisplayModal = false;
              });
            },
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
