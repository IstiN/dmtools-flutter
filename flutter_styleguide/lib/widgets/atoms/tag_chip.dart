import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';

enum TagChipVariant {
  primary,
  secondary,
  success,
  warning,
  danger,
  info,
}

class TagChip extends StatelessWidget {
  final String label;
  final TagChipVariant variant;
  final bool isOutlined;
  final bool? isTestMode;
  final bool? testDarkMode;

  const TagChip({
    required this.label,
    this.variant = TagChipVariant.primary,
    this.isOutlined = false,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        isTestMode == true ? (testDarkMode == true ? AppColors.dark : AppColors.light) : context.colorsListening;

    // Define colors based on variant
    Color bgColor;
    Color textColor;
    Color borderColor;

    switch (variant) {
      case TagChipVariant.primary:
        textColor = colors.accentColor;
        bgColor = isOutlined ? Colors.transparent : colors.accentColor.withValues(alpha: 0.1);
        borderColor = colors.accentColor;
        break;
      case TagChipVariant.secondary:
        textColor = colors.textMuted;
        bgColor = isOutlined ? Colors.transparent : colors.textMuted.withValues(alpha: 0.1);
        borderColor = colors.textMuted;
        break;
      case TagChipVariant.success:
        textColor = colors.successColor;
        bgColor = isOutlined ? Colors.transparent : colors.successColor.withValues(alpha: 0.1);
        borderColor = colors.successColor;
        break;
      case TagChipVariant.warning:
        textColor = colors.warningColor;
        bgColor = isOutlined ? Colors.transparent : colors.warningColor.withValues(alpha: 0.1);
        borderColor = colors.warningColor;
        break;
      case TagChipVariant.danger:
        textColor = colors.dangerColor;
        bgColor = isOutlined ? Colors.transparent : colors.dangerColor.withValues(alpha: 0.1);
        borderColor = colors.dangerColor;
        break;
      case TagChipVariant.info:
        textColor = colors.infoColor;
        bgColor = isOutlined ? Colors.transparent : colors.infoColor.withValues(alpha: 0.1);
        borderColor = colors.infoColor;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: isOutlined ? Border.all(color: borderColor) : null,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
