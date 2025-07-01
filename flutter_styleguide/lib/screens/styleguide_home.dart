import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../core/routing/styleguide_router.dart';
import '../theme/app_theme.dart';
import '../theme/app_colors.dart';
import '../widgets/molecules/user_profile_button.dart';
import '../widgets/atoms/logos/logos.dart';
import '../widgets/molecules/headers/app_header.dart';
import '../widgets/responsive/responsive_builder.dart';

class StyleguideHome extends StatefulWidget {
  final Widget? child;

  const StyleguideHome({this.child, super.key});

  @override
  State<StyleguideHome> createState() => _StyleguideHomeState();
}

class _StyleguideHomeState extends State<StyleguideHome> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return SimpleResponsiveBuilder(
      mobile: (context, constraints) => _buildMobileLayout(),
      desktop: (context, constraints) => _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppHeader(
          showTitle: false,
          searchHintText: 'Search agents and apps...',
          searchWidth: 400,
          onSearch: (query) {
            // Handle search
            debugPrint('Searching for: $query');
          },
          onThemeToggle: () => themeProvider.toggleTheme(),
          isTestMode: true,
          testDarkMode: isDarkMode,
          profileButton: UserProfileButton(
            userName: 'Vladimir Klyshevich',
            isTestMode: true,
            testDarkMode: isDarkMode,
          ),
        ),
      ),
      body: Row(
        children: [
          _buildSidebar(context, isMobile: false),
          Container(
            width: 1,
            color: colors.dividerColor,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: widget.child ?? const WelcomePage(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppHeader(
          showSearch: false,
          showTitle: false,
          showHamburgerMenu: true,
          onHamburgerPressed: () => _scaffoldKey.currentState?.openDrawer(),
          onThemeToggle: () => themeProvider.toggleTheme(),
          isTestMode: true,
          testDarkMode: isDarkMode,
          profileButton: UserProfileButton(
            userName: 'VK',
            isTestMode: true,
            testDarkMode: isDarkMode,
          ),
        ),
      ),
      drawer: Drawer(
        child: _buildSidebar(context, isMobile: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: widget.child ?? const WelcomePage(),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, {required bool isMobile}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    final Color bgColor = isDarkMode ? AppColors.darkSidebarBg : AppColors.lightSidebarBg;

    final Color textColor = colors.textSecondary;
    final Color dividerColor = colors.dividerColor;

    return Container(
      width: 240,
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            Container(
              padding: const EdgeInsets.all(12),
              child: NetworkNodesLogo(
                isDarkMode: isDarkMode,
                isTestMode: true,
              ),
            ),
            Divider(color: dividerColor, height: 1),
          ],
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < styleguideNavigationItems.length; i++)
                  _buildNavItem(i, context, isMobile: isMobile),
              ],
            ),
          ),
          if (!isMobile) ...[
            Divider(color: dividerColor, height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '© 2025 DMTools. All rights reserved.',
                style: TextStyle(
                  fontSize: 11,
                  color: textColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, BuildContext context, {required bool isMobile}) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;
    final item = styleguideNavigationItems[index];
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isSelected = currentLocation == item.route;

    final Color textColor = colors.textSecondary;
    const Color selectedTextColor = AppColors.primaryTextOnAccent;
    const Color selectedBgColor = AppColors.selectedBgColor;
    final Color hoverBgColor = isDarkMode ? AppColors.darkHoverBgColor : AppColors.lightHoverBgColor;

    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isSelected ? selectedBgColor : Colors.transparent,
        borderRadius: BorderRadius.zero,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.zero,
          hoverColor: isSelected ? Colors.transparent : hoverBgColor,
          onTap: () {
            context.go(item.route);
            if (isMobile) {
              Navigator.pop(context);
            }
          },
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: isSelected ? selectedTextColor : textColor,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected ? selectedTextColor : textColor,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to the DMTools Style Guide',
            style: theme.textTheme.headlineLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'This style guide is a living document that showcases the UI components, design patterns, and visual guidelines for the DMTools application. Use the navigation to explore different categories of components.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          Text(
            'The goal is to create a consistent and high-quality user experience across all parts of DMTools. This guide helps developers and designers to:',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          _buildBulletPoint('Understand the available UI building blocks.', theme),
          _buildBulletPoint('Reuse components to ensure consistency.', theme),
          _buildBulletPoint('Test components in isolation.', theme),
          _buildBulletPoint('Quickly reference design specifications.', theme),
          const SizedBox(height: 24),
          Text(
            'Dependencies',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 12),
          Text(
            'The DMTools component library requires the following external dependencies:',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          _buildBulletPoint('Google Fonts - Used for typography throughout the application.', theme),
          _buildBulletPoint('Flutter SVG - Used for rendering SVG icons.', theme),
          _buildBulletPoint('Provider - Used for state management and theming.', theme),
          const SizedBox(height: 24),
          Text(
            'Default view is Colors & Typography.',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('• ', style: theme.textTheme.bodyLarge),
          Expanded(
            child: Text(text, style: theme.textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
