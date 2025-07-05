import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_dimensions.dart';
import '../../../widgets/styleguide/component_display.dart';
import '../../../widgets/styleguide/component_item.dart';
import '../../../widgets/organisms/navigation_sidebar.dart';

class NavigationSidebarPage extends StatelessWidget {
  const NavigationSidebarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigation Sidebar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        children: [
          Text(
            'Navigation Sidebar',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Consistent navigation component for the application with proper theming and responsive behavior.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Basic Desktop Navigation
          ComponentDisplay(
            title: 'Desktop Navigation',
            description: 'Standard navigation sidebar for desktop layouts',
            child: ComponentItem(
              title: 'Default State',
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: NavigationSidebar(
                  items: _sampleNavigationItems,
                  currentRoute: '/dashboard',
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Mobile Navigation
          ComponentDisplay(
            title: 'Mobile Navigation',
            description: 'Navigation sidebar for mobile layouts with logo header',
            child: ComponentItem(
              title: 'Mobile with Logo',
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: NavigationSidebar(
                  items: _sampleNavigationItems,
                  currentRoute: '/agents',
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                  isMobile: true,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Different Selection States
          ComponentDisplay(
            title: 'Selection States',
            description: 'Different selected states for navigation items',
            child: Column(
              children: [
                ComponentItem(
                  title: 'Settings Selected',
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: NavigationSidebar(
                      items: _sampleNavigationItems,
                      currentRoute: '/settings',
                      isTestMode: true,
                      testDarkMode: isDarkMode,
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                ComponentItem(
                  title: 'Integrations Selected',
                  child: Container(
                    height: 400,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    ),
                    child: NavigationSidebar(
                      items: _sampleNavigationItems,
                      currentRoute: '/integrations',
                      isTestMode: true,
                      testDarkMode: isDarkMode,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Compact Version
          ComponentDisplay(
            title: 'Compact Version',
            description: 'Navigation sidebar without footer for compact layouts',
            child: ComponentItem(
              title: 'No Footer',
              child: Container(
                height: 400,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: NavigationSidebar(
                  items: _sampleNavigationItems,
                  currentRoute: '/dashboard',
                  isTestMode: true,
                  testDarkMode: isDarkMode,
                  showFooter: false,
                ),
              ),
            ),
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Implementation Guide
          ComponentDisplay(
            title: 'Implementation Guide',
            child: ComponentItem(
              title: 'Usage Example',
              child: Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Basic Usage:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'NavigationSidebar(\n'
                      '  items: navigationItems,\n'
                      '  currentRoute: currentRoute,\n'
                      '  isMobile: ResponsiveUtils.isMobile(context),\n'
                      '  onItemTap: () => Navigator.pop(context),\n'
                      ')',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacingM),
                    Text(
                      'Navigation Items Structure:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'const List<NavigationItem> items = [\n'
                      '  NavigationItem(\n'
                      '    icon: Icons.dashboard_outlined,\n'
                      '    label: \'Dashboard\',\n'
                      '    route: \'/dashboard\',\n'
                      '  ),\n'
                      '  // ... more items\n'
                      '];',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sample navigation items for demonstration
const List<NavigationItem> _sampleNavigationItems = [
  NavigationItem(
    icon: Icons.dashboard_outlined,
    label: 'Dashboard',
    route: '/dashboard',
  ),
  NavigationItem(
    icon: Icons.smart_toy_outlined,
    label: 'Agents',
    route: '/agents',
  ),
  NavigationItem(
    icon: Icons.folder_outlined,
    label: 'Workspaces',
    route: '/workspaces',
  ),
  NavigationItem(
    icon: Icons.apps_outlined,
    label: 'Applications',
    route: '/applications',
  ),
  NavigationItem(
    icon: Icons.extension_outlined,
    label: 'Integrations',
    route: '/integrations',
  ),
  NavigationItem(
    icon: Icons.people_outlined,
    label: 'Users',
    route: '/users',
  ),
  NavigationItem(
    icon: Icons.settings_outlined,
    label: 'Settings',
    route: '/settings',
  ),
  NavigationItem(
    icon: Icons.api_outlined,
    label: 'API Demo',
    route: '/api-demo',
  ),
];
