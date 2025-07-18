import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../styleguide/theme_switch.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final VoidCallback onThemeToggle;
  final List<Widget> actions;
  final bool? isTestMode;
  final bool? testDarkMode;

  const PageHeader({
    required this.title,
    required this.onThemeToggle,
    this.actions = const [],
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors =
        isTestMode == true ? (testDarkMode == true ? AppColors.dark : AppColors.light) : context.colorsListening;
    final isDarkMode = isTestMode == true ? testDarkMode == true : context.isDarkMode;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
            const Spacer(),
            // Actions
            ...actions,
            const SizedBox(width: 16),
            // Theme toggle
            ThemeSwitch(
              isDarkMode: isDarkMode,
              onToggle: onThemeToggle,
            ),
          ],
        ),
      ),
    );
  }
}
