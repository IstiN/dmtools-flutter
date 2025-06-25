import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
    super.key,
    required this.title,
    required this.onThemeToggle,
    this.actions = const [],
    this.isTestMode = false,
    this.testDarkMode = false,
  });

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
    
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: colors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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