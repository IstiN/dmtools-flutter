import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import '../../../widgets/styleguide/component_display.dart';
import '../../../widgets/organisms/panel_base.dart';

class PanelBasePage extends StatelessWidget {
  const PanelBasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel Base'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        children: [
          Text(
            'Panel Base',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Foundational panel structure with header and content area. Base for other modules.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          
          // Primary Style Panel
          ComponentDisplay(
            title: 'Primary Style Panel',
            description: 'Panel with primary color header.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                PanelBase(
                  title: 'Panel Title',
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                  content: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Panel Content',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? AppColors.dark.textColor : AppColors.light.textColor,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacingS),
                        Text(
                          'This is the content area of the panel. It can contain any widgets or components.',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? AppColors.dark.textSecondary : AppColors.light.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingXl),
          
          // Secondary Style Panel
          ComponentDisplay(
            title: 'Secondary Style Panel',
            description: 'Panel with secondary color header.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                PanelBase(
                  title: 'Secondary Panel',
                  headerStyle: PanelHeaderStyle.secondary,
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                  content: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    child: Text(
                      'This panel uses a secondary header style.',
                      style: TextStyle(
                        color: isDarkMode ? AppColors.dark.textColor : AppColors.light.textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingXl),
          
          // Neutral Style Panel
          ComponentDisplay(
            title: 'Neutral Style Panel',
            description: 'Panel with neutral color header.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                PanelBase(
                  title: 'Neutral Panel',
                  headerStyle: PanelHeaderStyle.neutral,
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                  content: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    child: Text(
                      'This panel uses a neutral header style.',
                      style: TextStyle(
                        color: isDarkMode ? AppColors.dark.textColor : AppColors.light.textColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingXl),
          
          // Collapsible Panel
          ComponentDisplay(
            title: 'Collapsible Panel',
            description: 'Panel that can be collapsed and expanded.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                PanelBase(
                  title: 'Collapsible Panel',
                  isCollapsible: true,
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                  content: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spacingM),
                    child: Text(
                      'This panel can be collapsed by clicking the expand/collapse icon in the header.',
                      style: TextStyle(
                        color: isDarkMode ? AppColors.dark.textColor : AppColors.light.textColor,
                      ),
                    ),
                  ),
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
            'The PanelBase component is a foundational organism that provides a consistent structure for panels throughout the application. It includes:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Styled header with title', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Optional action buttons in the header', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Collapsible content area', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Multiple header style options', style: Theme.of(context).textTheme.bodyMedium),
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
PanelBase(
  title: 'Panel Title',
  headerStyle: PanelHeaderStyle.primary,
  isCollapsible: true,
  actions: [
    IconButton(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onPressed: () {},
    ),
  ],
  content: Padding(
    padding: const EdgeInsets.all(16),
    child: Text('Panel content goes here'),
  ),
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