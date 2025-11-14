import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/analytics/analytics_event_helpers.dart';
import '../core/services/webhook_api_service.dart';
import '../providers/webhook_state_provider.dart';
import '../widgets/webhook/webhook_management_section.dart';

/// Job Configuration Detail Screen with Webhook Management
class JobConfigurationDetailScreen extends StatefulWidget {
  final String jobConfigurationId;
  final String jobConfigurationName;

  const JobConfigurationDetailScreen({
    required this.jobConfigurationId,
    required this.jobConfigurationName,
    super.key,
  });

  @override
  State<JobConfigurationDetailScreen> createState() => _JobConfigurationDetailScreenState();
}

class _JobConfigurationDetailScreenState extends State<JobConfigurationDetailScreen> {
  late WebhookApiService _webhookApiService;

  @override
  void initState() {
    super.initState();
    _webhookApiService = WebhookApiService();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ChangeNotifierProvider(
      create: (_) => WebhookStateProvider(_webhookApiService, widget.jobConfigurationId),
      child: Scaffold(
        backgroundColor: colors.bgColor,
        appBar: AppBar(
          title: const Text('Job Configuration Details'),
          backgroundColor: colors.cardBg,
          foregroundColor: colors.textColor,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Subtitle container like MCP details
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingL,
                vertical: AppDimensions.spacingM,
              ),
              decoration: BoxDecoration(
                color: colors.cardBg,
                border: Border(
                  bottom: BorderSide(color: colors.borderColor.withValues(alpha: 0.1)),
                ),
              ),
              child: Text(
                'View detailed configuration and webhook management',
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
              ),
            ),
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spacingL,
                    vertical: AppDimensions.spacingM,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(colors),
                      const SizedBox(height: AppDimensions.spacingL),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildOverviewSection(colors),
                            const SizedBox(height: AppDimensions.spacingXl),
                            _buildWebhookSection(),
                            const SizedBox(height: AppDimensions.spacingXl),
                            _buildExecutionHistorySection(colors),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeColorSet colors) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.jobConfigurationName,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: colors.textColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppDimensions.spacingXs),
              Text(
                'ID: ${widget.jobConfigurationId}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colors.textColor.withValues(alpha: 0.6),
                    ),
              ),
            ],
          ),
        ),
        _buildActionButtons(colors),
      ],
    );
  }

  Widget _buildActionButtons(ThemeColorSet colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppIconButton(
          text: 'Edit',
          icon: Icons.edit_outlined,
          onPressed: () {
            // TODO: Navigate to edit screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Edit functionality coming soon')),
            );
          },
        ),
        const SizedBox(width: AppDimensions.spacingS),
        AppIconButton(
          text: 'Delete',
          icon: Icons.delete_outline,
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Configuration?'),
                content: Text(
                  'Are you sure you want to delete "${widget.jobConfigurationName}"? This action cannot be undone.',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      trackManualButtonClick('job_detail_delete_cancel_button');
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      trackManualButtonClick('job_detail_delete_confirm_button');
                      Navigator.of(context).pop(true);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              // TODO: Implement delete functionality
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delete functionality coming soon')),
                );
              }
            }
          },
        ),
      ],
    );
  }

  Widget _buildOverviewSection(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Overview',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingM),
            _buildInfoRow('Status', 'Active', colors, Icons.check_circle, colors.successColor),
            const SizedBox(height: AppDimensions.spacingS),
            _buildInfoRow('Type', 'Expert Analysis', colors, Icons.psychology, colors.accentColor),
            const SizedBox(height: AppDimensions.spacingS),
            _buildInfoRow('Created', 'Jan 15, 2024', colors, Icons.calendar_today, colors.textMuted),
            const SizedBox(height: AppDimensions.spacingS),
            _buildInfoRow('Last Executed', '2 hours ago', colors, Icons.schedule, colors.textMuted),
            const SizedBox(height: AppDimensions.spacingS),
            _buildInfoRow('Execution Count', '47 times', colors, Icons.play_arrow, colors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, ThemeColorSet colors, IconData icon, Color iconColor) {
    return Row(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: AppDimensions.spacingS),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textMuted,
          ),
        ),
        const SizedBox(width: AppDimensions.spacingS),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: colors.textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWebhookSection() {
    return Consumer<WebhookStateProvider>(
      builder: (context, webhookProvider, _) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(color: context.colors.borderColor.withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Webhook Configuration',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: context.colors.textColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Text(
                  'Manage API keys and view integration examples for webhook execution',
                  style: TextStyle(
                    fontSize: 14,
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                WebhookManagementSectionWrapper(
                  jobConfigurationId: widget.jobConfigurationId,
                  webhookUrl: _generateWebhookUrl(widget.jobConfigurationId),
                  apiKeys: webhookProvider.apiKeys
                      .map((key) => WebhookKeyItemData(
                            id: key.id,
                            name: key.name,
                            description: key.description ?? '',
                            maskedValue: key.maskedValue,
                            createdAt: key.createdAt,
                            lastUsedAt: key.lastUsedAt,
                          ))
                      .toList(),
                  onGenerateKey: (name, description) async {
                    await webhookProvider.generateApiKey(name: name, description: description);
                  },
                  onCopyKey: (keyId) async {
                    await webhookProvider.copyApiKey(keyId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('API key copied to clipboard')),
                      );
                    }
                  },
                  onDeleteKey: (keyId) async {
                    await webhookProvider.deleteApiKey(keyId);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('API key deleted')),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExecutionHistorySection(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Execution History',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colors.textColor,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Recent job executions and webhook calls',
              style: TextStyle(
                fontSize: 14,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppDimensions.spacingL),
              decoration: BoxDecoration(
                color: colors.bgColor,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(color: colors.borderColor.withValues(alpha: 0.1)),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.history,
                    size: 48,
                    color: colors.textMuted,
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    'No execution history yet',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: colors.textMuted,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Text(
                    'Execution logs and webhook calls will appear here',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateWebhookUrl(String jobConfigurationId) {
    // TODO: Get this from configuration or environment
    const baseUrl = 'https://api.dmtools.example.com';
    return '$baseUrl/api/v1/job-configurations/$jobConfigurationId/webhook';
  }
}
