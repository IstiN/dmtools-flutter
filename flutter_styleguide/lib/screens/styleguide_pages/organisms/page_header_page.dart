import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import '../../../widgets/organisms/page_header.dart';
import '../../../widgets/styleguide/component_display.dart';

class PageHeaderPage extends StatelessWidget {
  const PageHeaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Header'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        children: [
          Text(
            'Page Header',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Main navigation header with logo, theme toggle, and action buttons.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Basic Page Header
          ComponentDisplay(
            title: 'Basic Page Header',
            description: 'Standard page header with title and theme toggle.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                PageHeader(
                  title: 'DMTools',
                  onThemeToggle: () {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Page Header with Actions
          ComponentDisplay(
            title: 'Page Header with Actions',
            description: 'Page header with additional action buttons.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                PageHeader(
                  title: 'DMTools',
                  onThemeToggle: () {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  },
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Implementation Details
          Text(
            'Implementation Details',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'The PageHeader component is an organism that combines various atoms and molecules to create a consistent header across the application. It includes:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Logo/Icon with title', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Theme toggle switch', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Optional action buttons', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Usage:',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? AppColors.dark.cardBg : AppColors.light.cardBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDarkMode ? AppColors.dark.borderColor : AppColors.light.borderColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '''
PageHeader(
  title: 'DMTools',
  onThemeToggle: () {
    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
  },
  actions: [
    IconButton(
      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
      onPressed: () {},
    ),
  ],
)''',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: isDarkMode ? AppColors.dark.textColor : AppColors.light.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
