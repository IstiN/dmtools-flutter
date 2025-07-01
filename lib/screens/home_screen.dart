import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;
import '../core/routing/app_router.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  final Widget? child;

  const HomeScreen({this.child, super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final authProvider = Provider.of<AuthProvider>(context);
    final colors = context.colorsListening;

    return Scaffold(
      body: Column(
        children: [
          // App Header
          AppHeader(
            showTitle: false,
            searchHintText: 'Search agents, workspaces, and apps...',
            searchWidth: 400,
            onSearch: (query) {
              debugPrint('Searching for: $query');
            },
            onThemeToggle: () => themeProvider.toggleTheme(),
            onLogoPressed: () {
              context.go('/dashboard');
            },
            profileButton: UserProfileButton(
              userName: authProvider.currentUser?.name ?? 'User',
              email: authProvider.currentUser?.email,
              avatarUrl: authProvider.currentUser?.picture,
              loginState: authProvider.isAuthenticated ? LoginState.loggedIn : LoginState.loggedOut,
              dropdownItems: authProvider.isAuthenticated
                  ? [
                      UserProfileDropdownItem(
                        icon: Icons.account_circle,
                        label: 'Profile',
                        onTap: () {
                          debugPrint('Profile clicked');
                        },
                      ),
                      UserProfileDropdownItem(
                        icon: Icons.settings,
                        label: 'Settings',
                        onTap: () {
                          context.go('/settings');
                        },
                      ),
                      UserProfileDropdownItem(
                        icon: Icons.exit_to_app,
                        label: 'Logout',
                        onTap: () async {
                          await authProvider.logout();
                        },
                      ),
                    ]
                  : [],
              onPressed: !authProvider.isAuthenticated
                  ? () {
                      // This shouldn't happen as unauthenticated users should be on a different screen
                      context.go('/unauthenticated');
                    }
                  : null,
            ),
          ),

          // Main Content
          Expanded(
            child: Row(
              children: [
                _buildSidebar(context, isMobile: false),
                Container(
                  width: 1,
                  color: colors.borderColor,
                ),
                Expanded(
                  child: _buildPageContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: [
          // App Header
          AppHeader(
            showSearch: false,
            showTitle: false,
            showHamburgerMenu: true,
            onHamburgerPressed: () => _scaffoldKey.currentState?.openDrawer(),
            onThemeToggle: () => themeProvider.toggleTheme(),
            onLogoPressed: () {
              context.go('/dashboard');
            },
            profileButton: UserProfileButton(
              userName: authProvider.currentUser?.name ?? 'User',
              email: authProvider.currentUser?.email,
              avatarUrl: authProvider.currentUser?.picture,
              loginState: authProvider.isAuthenticated ? LoginState.loggedIn : LoginState.loggedOut,
              dropdownItems: authProvider.isAuthenticated
                  ? [
                      UserProfileDropdownItem(
                        icon: Icons.account_circle,
                        label: 'Profile',
                        onTap: () {
                          debugPrint('Profile clicked');
                        },
                      ),
                      UserProfileDropdownItem(
                        icon: Icons.settings,
                        label: 'Settings',
                        onTap: () {
                          context.go('/settings');
                          Navigator.of(context).pop();
                        },
                      ),
                      UserProfileDropdownItem(
                        icon: Icons.exit_to_app,
                        label: 'Logout',
                        onTap: () async {
                          await authProvider.logout();
                        },
                      ),
                    ]
                  : [],
              onPressed: !authProvider.isAuthenticated
                  ? () {
                      // This shouldn't happen as unauthenticated users should be on a different screen
                      context.go('/unauthenticated');
                    }
                  : null,
            ),
          ),

          // Main Content
          Expanded(
            child: _buildPageContent(),
          ),
        ],
      ),
      drawer: Drawer(
        child: _buildSidebar(context, isMobile: true),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, {required bool isMobile}) {
    final colors = context.colorsListening;

    return Container(
      width: 240,
      color: colors.cardBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile) ...[
            Container(
              padding: const EdgeInsets.all(16),
              child: NetworkNodesLogo(
                size: LogoSize.small,
                isDarkMode: context.isDarkMode,
              ),
            ),
            Divider(color: colors.borderColor, height: 1),
          ],
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                for (int i = 0; i < navigationItems.length; i++) _buildNavItem(i, context, isMobile: isMobile),
              ],
            ),
          ),
          if (!isMobile) ...[
            Divider(color: colors.borderColor, height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '© 2025 DMTools. All rights reserved.',
                style: TextStyle(
                  fontSize: 11,
                  color: colors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, BuildContext context, {required bool isMobile}) {
    final item = navigationItems[index];
    final colors = context.colorsListening;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final isSelected = currentLocation == item.route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected ? colors.accentColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          item.icon,
          color: isSelected ? colors.accentColor : colors.textSecondary,
          size: 20,
        ),
        title: Text(
          item.label,
          style: TextStyle(
            color: isSelected ? colors.accentColor : colors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () {
          context.go(item.route);
          if (isMobile) {
            Navigator.of(context).pop();
          }
        },
        dense: true,
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Widget _buildPageContent() {
    final colors = context.colorsListening;
    final currentLocation = GoRouterState.of(context).uri.toString();
    final currentRoute = navigationItems.firstWhere(
      (item) => item.route == currentLocation,
      orElse: () => navigationItems.first,
    );

    return Container(
      color: colors.bgColor,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Title
          Text(
            currentRoute.label,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 24),

          // Page Content from router - constrained to available height
          Expanded(
            child: widget.child ?? const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
