import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class WebhookKeyGenerateModal extends StatefulWidget {
  final Function(String name, String? description)? onGenerate;
  final VoidCallback? onCancel;
  final bool isLoading;

  const WebhookKeyGenerateModal({this.onGenerate, this.onCancel, this.isLoading = false, super.key});

  @override
  State<WebhookKeyGenerateModal> createState() => _WebhookKeyGenerateModalState();
}

class _WebhookKeyGenerateModalState extends State<WebhookKeyGenerateModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleGenerate() {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text.trim();
      final description = _descriptionController.text.trim();
      widget.onGenerate?.call(name, description.isEmpty ? null : description);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.cardBg,
      title: Text(
        'Generate New API Key',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
      ),
      content: SizedBox(
        width: 500,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSecurityWarning(colors),
              const SizedBox(height: 24),
              _buildNameField(colors),
              const SizedBox(height: 16),
              _buildDescriptionField(colors),
              const SizedBox(height: 24),
              _buildSecurityGuidelines(colors),
            ],
          ),
        ),
      ),
      actions: [
        SecondaryButton(text: 'Cancel', onPressed: widget.isLoading ? null : widget.onCancel),
        const SizedBox(width: 8),
        PrimaryButton(
          text: 'Generate Key',
          onPressed: widget.isLoading ? null : _handleGenerate,
          icon: Icons.key,
          isLoading: widget.isLoading,
        ),
      ],
    );
  }

  Widget _buildSecurityWarning(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.warningColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.warningColor.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.security, color: colors.warningColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Security Notice',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'The API key will be displayed only once after generation. Make sure to copy and store it securely.',
                    style: TextStyle(fontSize: 13, color: colors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNameField(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name *',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nameController,
          enabled: !widget.isLoading,
          style: TextStyle(color: colors.textColor),
          decoration: InputDecoration(
            hintText: 'e.g., Production Webhook Key',
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Name is required';
            }
            if (value.trim().length < 3) {
              return 'Name must be at least 3 characters';
            }
            if (value.trim().length > 50) {
              return 'Name must be less than 50 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description (Optional)',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _descriptionController,
          enabled: !widget.isLoading,
          maxLines: 3,
          style: TextStyle(color: colors.textColor),
          decoration: InputDecoration(
            hintText: 'What will this key be used for?',
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.inputBg,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4),
              borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
            ),
          ),
          validator: (value) {
            if (value != null && value.trim().length > 200) {
              return 'Description must be less than 200 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSecurityGuidelines(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Security Best Practices',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        ..._securityGuidelines.map((guideline) => _buildGuidelineItem(guideline, colors)),
      ],
    );
  }

  Widget _buildGuidelineItem(String guideline, ThemeColorSet colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 4, color: colors.textSecondary),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(guideline, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
          ),
        ],
      ),
    );
  }

  static const List<String> _securityGuidelines = [
    'Store the API key in a secure location (password manager, environment variables)',
    'Never commit API keys to version control systems',
    'Use environment-specific keys for different deployment stages',
    'Rotate keys regularly and delete unused ones',
    'Monitor key usage and set up alerts for suspicious activity',
  ];
}
