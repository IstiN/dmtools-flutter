import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:flutter/material.dart';

import '../../core/analytics/analytics_event_helpers.dart';

/// Wrapper widget for the webhook management section from styleguide
///
/// This widget provides integration between the main app and the styleguide
/// webhook components, handling the specific business logic and state management
/// required by the main application.
class WebhookManagementSectionWrapper extends StatefulWidget {
  final String jobConfigurationId;
  final String webhookUrl;
  final List<WebhookKeyItemData> apiKeys;
  final Function(String name, String? description) onGenerateKey;
  final Function(String keyId) onCopyKey;
  final Function(String keyId) onDeleteKey;

  const WebhookManagementSectionWrapper({
    required this.jobConfigurationId,
    required this.webhookUrl,
    required this.apiKeys,
    required this.onGenerateKey,
    required this.onCopyKey,
    required this.onDeleteKey,
    super.key,
  });

  @override
  State<WebhookManagementSectionWrapper> createState() => _WebhookManagementSectionWrapperState();
}

class _WebhookManagementSectionWrapperState extends State<WebhookManagementSectionWrapper> {
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return WebhookManagementSection(
      jobConfigurationId: widget.jobConfigurationId,
      webhookUrl: widget.webhookUrl,
      apiKeys: widget.apiKeys,
      onGenerateKey: _handleGenerateKey,
      onCopyKey: _handleCopyKey,
      onDeleteKey: _handleDeleteKey,
    );
  }

  Future<void> _handleGenerateKey(String name, String? description) async {
    if (_isGenerating) return;

    setState(() {
      _isGenerating = true;
    });

    try {
      await widget.onGenerateKey(name, description);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate API key: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isGenerating = false;
        });
      }
    }
  }

  Future<void> _handleCopyKey(String keyId) async {
    try {
      await widget.onCopyKey(keyId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to copy API key: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<void> _handleDeleteKey(String keyId) async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete API Key'),
        content: const Text('Are you sure you want to delete this API key? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () {
              trackManualButtonClick('webhook_delete_cancel_button');
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              trackManualButtonClick('webhook_delete_confirm_button');
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
      try {
        await widget.onDeleteKey(keyId);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to delete API key: $e'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }
}
