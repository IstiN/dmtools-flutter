import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class WebhookManagementSection extends StatefulWidget {
  final String jobConfigurationId;
  final String webhookUrl;
  final List<WebhookKeyItemData> apiKeys;
  final Function(String name, String? description)? onGenerateKey;
  final Function(String keyId)? onCopyKey;
  final Function(String keyId)? onDeleteKey;
  final Future<List<WebhookExampleData>?> Function()? onLoadExamples;
  final bool isLoading;
  final String? loadingKeyId;
  final WebhookError? error;

  const WebhookManagementSection({
    required this.jobConfigurationId,
    required this.webhookUrl,
    required this.apiKeys,
    this.onGenerateKey,
    this.onCopyKey,
    this.onDeleteKey,
    this.onLoadExamples,
    this.isLoading = false,
    this.loadingKeyId,
    this.error,
    super.key,
  });

  @override
  State<WebhookManagementSection> createState() => _WebhookManagementSectionState();
}

class _WebhookManagementSectionState extends State<WebhookManagementSection> {
  void _handleGenerateKey() {
    _showGenerateKeyDialog();
  }

  void _handleConfirmGenerate(String name, String? description) {
    widget.onGenerateKey?.call(name, description);
  }

  void _handleDeleteKey(String keyId) {
    _showDeleteConfirmation(keyId);
  }

  void _showGenerateKeyDialog() {
    showDialog(
      context: context,
      builder: (context) => WebhookKeyGenerateModal(
        onGenerate: (name, description) {
          Navigator.of(context).pop();
          _handleConfirmGenerate(name, description);
        },
        onCancel: () => Navigator.of(context).pop(),
        isLoading: widget.isLoading,
      ),
    );
  }

  void _showDeleteConfirmation(String keyId) {
    final keyToDelete = widget.apiKeys.firstWhere((key) => key.id == keyId);

    showDialog(
      context: context,
      builder: (context) => _DeleteConfirmationDialog(
        keyName: keyToDelete.name,
        onConfirm: () {
          Navigator.of(context).pop();
          widget.onDeleteKey?.call(keyId);
        },
        onCancel: () => Navigator.of(context).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(colors),
        if (widget.error != null) ...[const SizedBox(height: 16), _buildErrorBanner(colors)],
        const SizedBox(height: 24),
        _buildKeyManagement(),
        const SizedBox(height: 32),
        _buildWebhookExamples(),
      ],
    );
  }

  Widget _buildSectionHeader(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.webhook, size: 24, color: colors.accentColor),
            const SizedBox(width: 8),
            Text(
              'Webhook Management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: colors.textColor),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Manage API keys and integration examples for webhook access to this job configuration',
          style: TextStyle(fontSize: 14, color: colors.textSecondary),
        ),
        const SizedBox(height: 12),
        _buildWebhookUrl(colors),
      ],
    );
  }

  Widget _buildWebhookUrl(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.inputBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.link, size: 16, color: colors.textSecondary),
            const SizedBox(width: 8),
            Text(
              'Webhook URL: ',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
            ),
            Expanded(
              child: SelectableText(
                widget.webhookUrl,
                style: TextStyle(fontSize: 14, fontFamily: 'monospace', color: colors.textSecondary),
              ),
            ),
            AppIconButton(text: 'Copy', icon: Icons.copy, onPressed: () => _copyWebhookUrl(), size: ButtonSize.small),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorBanner(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.dangerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.dangerColor.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: colors.dangerColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Error',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(widget.error!.message, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyManagement() {
    return WebhookKeyList(
      keys: widget.apiKeys,
      onCopyKey: widget.onCopyKey,
      onDeleteKey: _handleDeleteKey,
      onGenerateNew: _handleGenerateKey,
      isLoading: widget.isLoading,
      deletingKeyId: widget.loadingKeyId,
    );
  }

  Widget _buildWebhookExamples() {
    final sampleApiKey = widget.apiKeys.isNotEmpty ? widget.apiKeys.first.maskedValue.replaceAll('*', 'x') : null;

    return WebhookExamplesSection(
      jobConfigurationId: widget.jobConfigurationId,
      webhookUrl: widget.webhookUrl,
      sampleApiKey: sampleApiKey,
      onLoadExamples: widget.onLoadExamples,
    );
  }

  void _copyWebhookUrl() {
    // Implementation would copy webhook URL to clipboard
    // This would be implemented in the actual integration
  }
}

class _DeleteConfirmationDialog extends StatelessWidget {
  final String keyName;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _DeleteConfirmationDialog({required this.keyName, required this.onConfirm, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.cardBg,
      title: Text(
        'Delete API Key',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Are you sure you want to delete the API key "$keyName"?',
            style: TextStyle(fontSize: 14, color: colors.textColor),
          ),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colors.warningColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.warningColor.withValues(alpha: 0.3)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.warning, size: 16, color: colors.warningColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'This action cannot be undone. Any integrations using this key will stop working.',
                      style: TextStyle(fontSize: 13, color: colors.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        SecondaryButton(text: 'Cancel', onPressed: onCancel),
        const SizedBox(width: 8),
        PrimaryButton(text: 'Delete Key', onPressed: onConfirm, icon: Icons.delete),
      ],
    );
  }
}

class WebhookError {
  final String message;
  final String? code;

  const WebhookError({required this.message, this.code});
}
