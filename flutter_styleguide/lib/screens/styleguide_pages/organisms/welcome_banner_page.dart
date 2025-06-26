import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import '../../../widgets/organisms/welcome_banner.dart';
import '../../../widgets/styleguide/component_display.dart';

class WelcomeBannerPage extends StatelessWidget {
  const WelcomeBannerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Banner'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        children: [
          Text(
            'Welcome Banner',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Prominent banner component for main page headers with logo, text, and call-to-action buttons.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spacingL),
          
          // Standard Welcome Banner
          ComponentDisplay(
            title: 'Standard Welcome Banner',
            description: 'Default banner with title, subtitle, and action buttons.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                WelcomeBanner(
                  title: 'Welcome to DMTools',
                  subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
                  onPrimaryAction: () {},
                  onSecondaryAction: () {},
                  primaryActionText: 'Get Started',
                  secondaryActionText: 'Learn More',
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingXl),
          
          // Welcome Banner with Logo
          ComponentDisplay(
            title: 'Welcome Banner with Connected Logo',
            description: 'Banner with connected network logo, text, and action buttons.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                WelcomeBanner(
                  title: 'Welcome to DMTools',
                  subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
                  onPrimaryAction: () {},
                  onSecondaryAction: () {},
                  primaryActionText: 'Get Started',
                  secondaryActionText: 'Learn More',
                  logoAssetPath: 'assets/img/dmtools-logo-connected-jai-dark-fusion.svg',
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingXl),
          
          // Welcome Banner with Wordmark Logo
          ComponentDisplay(
            title: 'Welcome Banner with Wordmark Logo',
            description: 'Banner with wordmark logo, text, and action buttons.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                WelcomeBanner(
                  title: 'Welcome to DMTools',
                  subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
                  onPrimaryAction: () {},
                  onSecondaryAction: () {},
                  primaryActionText: 'Get Started',
                  secondaryActionText: 'Learn More',
                  logoAssetPath: 'assets/img/dmtools-logo-wordmark-white.svg',
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingXl),
          
          // Welcome Banner with Combined Logo
          ComponentDisplay(
            title: 'Welcome Banner with Combined Logo',
            description: 'Banner with combined icon and wordmark logo for full branding.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                WelcomeBanner(
                  title: 'Welcome to DMTools',
                  subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
                  onPrimaryAction: () {},
                  onSecondaryAction: () {},
                  primaryActionText: 'Get Started',
                  secondaryActionText: 'Learn More',
                  logoAssetPath: 'assets/img/dmtools-logo-combined.svg',
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: AppDimensions.spacingXl),
          
          // Custom Welcome Banner
          ComponentDisplay(
            title: 'Custom Welcome Banner',
            description: 'Banner with custom text and button labels.',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimensions.spacingM),
                WelcomeBanner(
                  title: 'Introducing DMTools Pro',
                  subtitle: 'Upgrade to our premium plan for advanced features, priority support, and unlimited access to all tools.',
                  onPrimaryAction: () {},
                  onSecondaryAction: () {},
                  primaryActionText: 'Upgrade Now',
                  secondaryActionText: 'View Plans',
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
            'The WelcomeBanner component is a prominent organism designed to be used at the top of landing pages or dashboard screens. It includes:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('• Optional logo displayed at the top (centered)', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Gradient background with accent color', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Large title and descriptive subtitle', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Primary and secondary action buttons', style: Theme.of(context).textTheme.bodyMedium),
                Text('• Responsive layout that adapts to different screen sizes', style: Theme.of(context).textTheme.bodyMedium),
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
WelcomeBanner(
  title: 'Welcome to DMTools',
  subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
  onPrimaryAction: () {
    // Handle primary action
  },
  onSecondaryAction: () {
    // Handle secondary action
  },
  primaryActionText: 'Get Started',
  secondaryActionText: 'Learn More',
  logoAssetPath: 'assets/img/dmtools-logo-combined.svg', // Optional logo
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