import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    Key? key,
    required this.label,
    this.variant = TagChipVariant.primary,
    this.isOutlined = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    ThemeColorSet colors;
    
    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }
    
    // Define colors based on variant
    Color bgColor;
    Color textColor;
    Color borderColor;
    
    switch (variant) {
      case TagChipVariant.primary:
        bgColor = isOutlined ? Colors.transparent : colors.accentColor.withOpacity(0.1);
        textColor = colors.accentColor;
        borderColor = colors.accentColor;
        break;
      case TagChipVariant.secondary:
        bgColor = isOutlined ? Colors.transparent : colors.textMuted.withOpacity(0.1);
        textColor = colors.textMuted;
        borderColor = colors.textMuted;
        break;
      case TagChipVariant.success:
        bgColor = isOutlined ? Colors.transparent : colors.successColor.withOpacity(0.1);
        textColor = colors.successColor;
        borderColor = colors.successColor;
        break;
      case TagChipVariant.warning:
        bgColor = isOutlined ? Colors.transparent : colors.warningColor.withOpacity(0.1);
        textColor = colors.warningColor;
        borderColor = colors.warningColor;
        break;
      case TagChipVariant.danger:
        bgColor = isOutlined ? Colors.transparent : colors.dangerColor.withOpacity(0.1);
        textColor = colors.dangerColor;
        borderColor = colors.dangerColor;
        break;
      case TagChipVariant.info:
        bgColor = isOutlined ? Colors.transparent : colors.infoColor.withOpacity(0.1);
        textColor = colors.infoColor;
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