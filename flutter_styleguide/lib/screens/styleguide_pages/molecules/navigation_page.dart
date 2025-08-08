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
            'Sidebar navigation menus and drawers',
            _buildSideNavigationExample(context),
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

    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        children: [
          // Sidebar
          Container(
            width: 200,
            decoration: BoxDecoration(
              color: colors.bgColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
            ),
            child: Column(
              children: [
                _buildNavItem(context, 'Dashboard', Icons.dashboard, true),
                _buildNavItem(context, 'Projects', Icons.folder, false),
                _buildNavItem(context, 'Integrations', Icons.link, false),
                _buildNavItem(context, 'Settings', Icons.settings, false),
              ],
            ),
          ),
          // Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingM),
              child: Center(
                child: Text('Main content area', style: TextStyle(color: colors.textColor.withValues(alpha: 0.6))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, String title, IconData icon, bool isActive) {
    final colors = context.colors;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? colors.accentColor.withValues(alpha: 0.1) : null,
        borderRadius: BorderRadius.circular(6),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(icon, size: 20, color: isActive ? colors.accentColor : colors.textColor.withValues(alpha: 0.6)),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? colors.accentColor : colors.textColor,
            fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
        onTap: () {},
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
