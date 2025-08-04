import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class WebhookKeyItem extends StatelessWidget {
  final String id;
  final String name;
  final String? description;
  final String maskedValue;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final bool isLoading;

  const WebhookKeyItem({
    required this.id,
    required this.name,
    required this.maskedValue,
    required this.createdAt,
    this.description,
    this.lastUsedAt,
    this.onCopy,
    this.onDelete,
    this.isLoading = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
            _buildHeader(colors),
            const SizedBox(height: 8),
            _buildKeyValue(colors),
            const SizedBox(height: 12),
            _buildMetadata(colors),
            const SizedBox(height: 12),
            _buildActions(colors),
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
                name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: colors.textColor),
              ),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(description!, style: TextStyle(fontSize: 14, color: colors.textSecondary)),
              ],
            ],
          ),
        ),
        _StatusIndicator(isActive: lastUsedAt != null, colors: colors),
      ],
    );
  }

  Widget _buildKeyValue(ThemeColorSet colors) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.inputBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(Icons.key, size: 16, color: colors.textSecondary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                maskedValue,
                style: TextStyle(fontSize: 14, fontFamily: 'monospace', color: colors.textColor),
              ),
            ),
            AppIconButton(text: 'Copy', icon: Icons.copy, onPressed: isLoading ? null : onCopy, size: ButtonSize.small),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadata(ThemeColorSet colors) {
    return Row(
      children: [
        _MetadataItem(
          icon: Icons.schedule,
          label: 'Created',
          value: '${createdAt.toString().substring(0, 10)} at ${createdAt.toString().substring(11, 16)}',
          colors: colors,
        ),
        const SizedBox(width: 24),
        if (lastUsedAt != null)
          _MetadataItem(
            icon: Icons.access_time,
            label: 'Last used',
            value: '${lastUsedAt!.toString().substring(0, 10)} at ${lastUsedAt!.toString().substring(11, 16)}',
            colors: colors,
          )
        else
          _MetadataItem(icon: Icons.access_time, label: 'Last used', value: 'Never', colors: colors),
      ],
    );
  }

  Widget _buildActions(ThemeColorSet colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppIconButton(
          text: 'Delete',
          icon: Icons.delete_outline,
          onPressed: isLoading ? null : onDelete,
          size: ButtonSize.small,
        ),
      ],
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final bool isActive;
  final ThemeColorSet colors;

  const _StatusIndicator({required this.isActive, required this.colors});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive ? colors.successColor : colors.textSecondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          isActive ? 'Used' : 'Unused',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.cardBg),
        ),
      ),
    );
  }
}

class _MetadataItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeColorSet colors;

  const _MetadataItem({required this.icon, required this.label, required this.value, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: colors.textSecondary),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: colors.textSecondary)),
            Text(
              value,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: colors.textColor),
            ),
          ],
        ),
      ],
    );
  }
}
