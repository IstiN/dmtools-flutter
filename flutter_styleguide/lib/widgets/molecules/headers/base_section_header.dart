import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';

class BaseSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? viewAllText;
  final VoidCallback? onViewAll;
  final Widget? leading;
  final List<Widget>? actions;
  final bool isTestMode;
  final bool testDarkMode;

  const BaseSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.viewAllText,
    this.onViewAll,
    this.leading,
    this.actions,
    this.isTestMode = false,
    this.testDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = isTestMode ? (testDarkMode ? AppColors.dark : AppColors.light) : context.colorsListening;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingM),
      child: Row(
        children: [
          // Leading widget (if provided)
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppDimensions.spacingM),
          ],

          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppDimensions.spacingXs),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Actions (if provided)
          if (actions != null) ...actions!,

          // View all button (if provided)
          if (viewAllText != null && onViewAll != null) ...[
            TextButton(
              onPressed: onViewAll,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    viewAllText!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colors.accentColor,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: colors.accentColor,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
