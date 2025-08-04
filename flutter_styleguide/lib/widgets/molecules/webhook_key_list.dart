import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class WebhookKeyList extends StatelessWidget {
  final List<WebhookKeyItemData> keys;
  final Function(String keyId)? onCopyKey;
  final Function(String keyId)? onDeleteKey;
  final VoidCallback? onGenerateNew;
  final bool isLoading;
  final String? deletingKeyId;

  const WebhookKeyList({
    required this.keys,
    this.onCopyKey,
    this.onDeleteKey,
    this.onGenerateNew,
    this.isLoading = false,
    this.deletingKeyId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    if (keys.isEmpty) {
      return _buildEmptyState(colors);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildHeader(colors), const SizedBox(height: 16), _buildKeysList()],
    );
  }

  Widget _buildHeader(ThemeColorSet colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'API Keys',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
            ),
            const SizedBox(height: 4),
            Text(
              '${keys.length} ${keys.length == 1 ? 'key' : 'keys'} configured',
              style: TextStyle(fontSize: 14, color: colors.textSecondary),
            ),
          ],
        ),
        PrimaryButton(
          text: 'Generate New Key',
          onPressed: isLoading ? null : onGenerateNew,
          icon: Icons.add,
          isLoading: isLoading,
        ),
      ],
    );
  }

  Widget _buildKeysList() {
    return Column(
      children: keys.asMap().entries.map((entry) {
        final index = entry.key;
        final keyData = entry.value;
        final isItemLoading = deletingKeyId == keyData.id;

        return Column(
          children: [
            WebhookKeyItem(
              id: keyData.id,
              name: keyData.name,
              description: keyData.description,
              maskedValue: keyData.maskedValue,
              createdAt: keyData.createdAt,
              lastUsedAt: keyData.lastUsedAt,
              onCopy: () => onCopyKey?.call(keyData.id),
              onDelete: () => onDeleteKey?.call(keyData.id),
              isLoading: isItemLoading,
            ),
            if (index < keys.length - 1) const SizedBox(height: 12),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.key_off, size: 48, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              'No API Keys Yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
            ),
            const SizedBox(height: 8),
            Text(
              'Generate your first API key to start using webhook integrations',
              style: TextStyle(fontSize: 14, color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'Generate First Key',
              onPressed: isLoading ? null : onGenerateNew,
              icon: Icons.key,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class WebhookKeyItemData {
  final String id;
  final String name;
  final String? description;
  final String maskedValue;
  final DateTime createdAt;
  final DateTime? lastUsedAt;

  const WebhookKeyItemData({
    required this.id,
    required this.name,
    required this.maskedValue,
    required this.createdAt,
    this.description,
    this.lastUsedAt,
  });

  factory WebhookKeyItemData.fromWebhookKey(WebhookKey key) {
    return WebhookKeyItemData(
      id: key.id,
      name: key.name,
      description: key.description,
      maskedValue: key.maskedValue,
      createdAt: key.createdAt,
      lastUsedAt: key.lastUsedAt,
    );
  }
}
