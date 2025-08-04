import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class WebhookKeyDisplayModal extends StatefulWidget {
  final String keyName;
  final String apiKey;
  final VoidCallback? onClose;

  const WebhookKeyDisplayModal({required this.keyName, required this.apiKey, this.onClose, super.key});

  @override
  State<WebhookKeyDisplayModal> createState() => _WebhookKeyDisplayModalState();
}

class _WebhookKeyDisplayModalState extends State<WebhookKeyDisplayModal> {
  bool _isCopied = false;

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: widget.apiKey));
    setState(() {
      _isCopied = true;
    });

    // Reset copied state after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isCopied = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.cardBg,
      title: Text(
        'API Key Generated',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
      ),
      content: SizedBox(
        width: 600,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSuccessMessage(colors),
            const SizedBox(height: 24),
            _buildKeyDisplay(colors),
            const SizedBox(height: 24),
            _buildSecurityWarning(colors),
            const SizedBox(height: 24),
            _buildUsageInstructions(colors),
          ],
        ),
      ),
      actions: [PrimaryButton(text: 'I\'ve Saved the Key', onPressed: widget.onClose)],
    );
  }

  Widget _buildSuccessMessage(ThemeColorSet colors) {
    return Row(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Icon(Icons.check_circle, color: colors.successColor, size: 24),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'API Key Created Successfully',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Key "${widget.keyName}" is ready to use',
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildKeyDisplay(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your API Key',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: colors.inputBg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colors.borderColor),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        widget.apiKey,
                        style: TextStyle(fontSize: 14, fontFamily: 'monospace', color: colors.textColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryButton(
                      text: _isCopied ? 'Copied!' : 'Copy to Clipboard',
                      onPressed: _isCopied ? null : _copyToClipboard,
                      icon: _isCopied ? Icons.check : Icons.copy,
                      size: ButtonSize.small,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityWarning(ThemeColorSet colors) {
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
            Icon(Icons.warning, color: colors.dangerColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Important: Save This Key Now',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'This is the only time you will see this API key. Once you close this dialog, you will not be able to retrieve it again.',
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

  Widget _buildUsageInstructions(ThemeColorSet colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to Use This Key',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        _buildInstructionStep('1.', 'Include the key in webhook requests using the X-API-Key header', colors),
        _buildInstructionStep('2.', 'Store the key securely in your environment variables or secrets manager', colors),
        _buildInstructionStep('3.', 'Use the integration examples below to see how to format your requests', colors),
      ],
    );
  }

  Widget _buildInstructionStep(String number, String instruction, ThemeColorSet colors) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              number,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.accentColor),
            ),
          ),
          Expanded(
            child: Text(instruction, style: TextStyle(fontSize: 13, color: colors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
