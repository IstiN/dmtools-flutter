import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/texts/app_text.dart';

class ComponentDisplay extends StatelessWidget {
  final String title;
  final String? description;
  final Widget child;

  const ComponentDisplay({
    required this.title, required this.child, super.key,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SmallHeadlineText(
          title,
          color: colors.textColor,
        ),
        if (description != null) ...[
          const SizedBox(height: AppDimensions.spacingXs),
          MediumBodyText(
            description!,
            color: colors.textSecondary,
          ),
        ],
        const SizedBox(height: AppDimensions.spacingM),
        child,
      ],
    );
  }
} 