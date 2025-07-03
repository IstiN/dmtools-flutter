import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

enum IntegrationStatus {
  enabled,
  disabled,
  error,
  testing,
  connected,
  disconnected,
}

/// Badge component for displaying integration status with appropriate colors and icons
class IntegrationStatusBadge extends StatelessWidget {
  final IntegrationStatus status;
  final String? customLabel;
  final bool showIcon;
  final bool? isTestMode;
  final bool? testDarkMode;

  const IntegrationStatusBadge({
    required this.status,
    this.customLabel,
    this.showIcon = true,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isTestMode == true ? (testDarkMode == true ? AppColors.dark : AppColors.light) : context.colors;

    final statusConfig = _getStatusConfig(colors);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusConfig.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusConfig.borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(
              statusConfig.icon,
              size: 12,
              color: statusConfig.textColor,
            ),
            const SizedBox(width: 4),
          ],
          Text(
            customLabel ?? statusConfig.label,
            style: TextStyle(
              color: statusConfig.textColor,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(ThemeColorSet colors) {
    switch (status) {
      case IntegrationStatus.enabled:
        return _StatusConfig(
          label: 'Enabled',
          icon: Icons.check_circle,
          backgroundColor: colors.successColor.withValues(alpha: 0.1),
          borderColor: colors.successColor.withValues(alpha: 0.3),
          textColor: colors.successColor,
        );
      case IntegrationStatus.disabled:
        return _StatusConfig(
          label: 'Disabled',
          icon: Icons.pause_circle,
          backgroundColor: colors.textMuted.withValues(alpha: 0.1),
          borderColor: colors.textMuted.withValues(alpha: 0.3),
          textColor: colors.textMuted,
        );
      case IntegrationStatus.error:
        return _StatusConfig(
          label: 'Error',
          icon: Icons.error,
          backgroundColor: colors.dangerColor.withValues(alpha: 0.1),
          borderColor: colors.dangerColor.withValues(alpha: 0.3),
          textColor: colors.dangerColor,
        );
      case IntegrationStatus.testing:
        return _StatusConfig(
          label: 'Testing',
          icon: Icons.sync,
          backgroundColor: colors.infoColor.withValues(alpha: 0.1),
          borderColor: colors.infoColor.withValues(alpha: 0.3),
          textColor: colors.infoColor,
        );
      case IntegrationStatus.connected:
        return _StatusConfig(
          label: 'Connected',
          icon: Icons.link,
          backgroundColor: colors.successColor.withValues(alpha: 0.1),
          borderColor: colors.successColor.withValues(alpha: 0.3),
          textColor: colors.successColor,
        );
      case IntegrationStatus.disconnected:
        return _StatusConfig(
          label: 'Disconnected',
          icon: Icons.link_off,
          backgroundColor: colors.warningColor.withValues(alpha: 0.1),
          borderColor: colors.warningColor.withValues(alpha: 0.3),
          textColor: colors.warningColor,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  const _StatusConfig({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}
