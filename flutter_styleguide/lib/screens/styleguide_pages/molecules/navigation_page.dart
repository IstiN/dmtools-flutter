import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class NavigationPage extends StatelessWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(title: const Text('Navigation'), backgroundColor: colors.cardBg),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          const ComponentDisplay(
            title: 'Navigation',
            description: 'Navigation components including breadcrumbs, tabs, menus, and navigation bars.',
            child: SizedBox.shrink(),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // Breadcrumbs Section
          _buildSection(
            context,
            'Breadcrumbs',
            'Breadcrumb navigation for hierarchical content',
            _buildBreadcrumbsExample(context),
          ),

          // Tab Navigation Section
          _buildSection(
            context,
            'Tab Navigation',
            'Tab components for content organization',
            _buildTabNavigationExample(context),
          ),

          // Side Navigation Section
          _buildSection(
            context,
            'Side Navigation',
            'Modern vertical sidebar navigation with icons above text labels',
            _buildSideNavigationExample(context),
          ),

          // Bottom Navigation Section
          _buildSection(
            context,
            'Bottom Navigation',
            'Mobile bottom navigation bar for horizontal tab navigation',
            _buildBottomNavigationExample(context),
          ),

          // Navigation Menu Section
          _buildSection(
            context,
            'Navigation Menu',
            'Dropdown and context menus for navigation',
            _buildNavigationMenuExample(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, Widget example) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
        const SizedBox(height: AppDimensions.spacingS),
        Text(description, style: TextStyle(fontSize: 14, color: context.colors.textColor.withValues(alpha: 0.8))),
        const SizedBox(height: AppDimensions.spacingM),
        example,
        const SizedBox(height: AppDimensions.spacingL),
      ],
    );
  }

  Widget _buildBreadcrumbsExample(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        InkWell(
          onTap: () {},
          child: Text(
            'Home',
            style: TextStyle(color: colors.accentColor, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.chevron_right, size: 16, color: colors.textColor.withValues(alpha: 0.6)),
        ),
        InkWell(
          onTap: () {},
          child: Text(
            'Styleguide',
            style: TextStyle(color: colors.accentColor, fontWeight: FontWeight.w500),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Icon(Icons.chevron_right, size: 16, color: colors.textColor.withValues(alpha: 0.6)),
        ),
        Text(
          'Navigation',
          style: TextStyle(color: colors.textColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildTabNavigationExample(BuildContext context) {
    final colors = context.colors;

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          TabBar(
            labelColor: colors.accentColor,
            unselectedLabelColor: colors.textColor.withValues(alpha: 0.6),
            indicatorColor: colors.accentColor,
            tabs: const [
              Tab(text: 'Overview'),
              Tab(text: 'Components'),
              Tab(text: 'Examples'),
            ],
          ),
          Container(
            height: 120,
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: const TabBarView(
              children: [
                Center(child: Text('Overview content goes here')),
                Center(child: Text('Components content goes here')),
                Center(child: Text('Examples content goes here')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSideNavigationExample(BuildContext context) {
    final colors = context.colors;

    const sampleItems = [
      NavigationItem(label: 'Chat', route: '/chat', svgIconPath: 'assets/img/nav-icon-chat.svg'),
      NavigationItem(label: 'AI Jobs', route: '/ai-jobs', svgIconPath: 'assets/img/nav-icon-ai-jobs.svg'),
      NavigationItem(label: 'Integrations', route: '/integrations', svgIconPath: 'assets/img/nav-icon-integrations.svg'),
      NavigationItem(label: 'MCP', route: '/mcp', svgIconPath: 'assets/img/nav-icon-mcp.svg'),
    ];

    return Container(
      height: 400,
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        children: [
          // Sidebar
          const NavigationSidebar(
            items: sampleItems,
            currentRoute: '/chat',
            isTestMode: true,
            testDarkMode: true,
          ),
          // Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Navigation Sidebar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Text(
                    'Modern vertical navigation with icons above text labels. Features dark charcoal background (#2C2C2C) with cyan active state (#06B6D4) from logo design.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textColor.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingM),
                  Text(
                    'Active item: Chat (orange)',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationExample(BuildContext context) {
    final colors = context.colors;

    const sampleItems = [
      NavigationItem(label: 'Chat', route: '/chat', svgIconPath: 'assets/img/nav-icon-chat.svg'),
      NavigationItem(label: 'AI Jobs', route: '/ai-jobs', svgIconPath: 'assets/img/nav-icon-ai-jobs.svg'),
      NavigationItem(label: 'Integrations', route: '/integrations', svgIconPath: 'assets/img/nav-icon-integrations.svg'),
      NavigationItem(label: 'MCP', route: '/mcp', svgIconPath: 'assets/img/nav-icon-mcp.svg'),
    ];

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bottom Navigation Bar',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacingS),
                  Text(
                    'Mobile-optimized horizontal navigation bar. Transforms the vertical sidebar into bottom tabs for better mobile UX.',
                    style: TextStyle(
                      fontSize: 14,
                      color: colors.textColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const BottomNavigationBarWidget(
            items: sampleItems,
            currentRoute: '/chat',
            isTestMode: true,
            testDarkMode: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationMenuExample(BuildContext context) {
    final colors = context.colors;

    return Wrap(
      spacing: AppDimensions.spacingM,
      runSpacing: AppDimensions.spacingS,
      children: [
        // Dropdown menu
        PopupMenuButton<String>(
          onSelected: (value) {},
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'profile', child: Text('Profile')),
            const PopupMenuItem(value: 'settings', child: Text('Settings')),
            const PopupMenuItem(value: 'logout', child: Text('Logout')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colors.cardBg,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: colors.borderColor),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('User Menu', style: TextStyle(color: colors.textColor)),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: colors.textColor, size: 20),
              ],
            ),
          ),
        ),
        // Context menu
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colors.borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.more_vert, color: colors.textColor, size: 20),
              const SizedBox(width: 4),
              Text('More Options', style: TextStyle(color: colors.textColor)),
            ],
          ),
        ),
      ],
    );
  }
}
