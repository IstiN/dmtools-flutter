import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;
import '../core/routing/app_router.dart' as app_router;
import '../providers/enhanced_auth_provider.dart';

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
    final authProvider = Provider.of<EnhancedAuthProvider>(context);
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
            onThemeToggle: () async => await themeProvider.toggleTheme(),
            onLogoPressed: () {
              context.go('/ai-jobs');
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
                      // Temporarily hidden - Settings
                      // UserProfileDropdownItem(
                      //   icon: Icons.settings,
                      //   label: 'Settings',
                      //   onTap: () {
                      //     context.go('/settings');
                      //   },
                      // ),
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
                NavigationSidebar(
                  items: _convertNavigationItems(app_router.navigationItems),
                  currentRoute: GoRouterState.of(context).uri.toString(),
                ),
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
    final authProvider = Provider.of<EnhancedAuthProvider>(context);

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
            onThemeToggle: () async => await themeProvider.toggleTheme(),
            onLogoPressed: () {
              context.go('/ai-jobs');
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
        child: NavigationSidebar(
          items: _convertNavigationItems(app_router.navigationItems),
          currentRoute: GoRouterState.of(context).uri.toString(),
          isMobile: true,
          onItemTap: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  // Convert app router NavigationItem to styleguide NavigationItem
  List<NavigationItem> _convertNavigationItems(List<app_router.NavigationItem> items) {
    final authProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);
    final isAdmin = authProvider.currentUser?.role == 'ADMIN';

    return items
        .where((item) {
          // Show Users menu only for admin users
          if (item.route == '/users') {
            return isAdmin;
          }
          return true; // Show all other items
        })
        .map((item) => NavigationItem(
              icon: item.icon,
              label: item.label,
              route: item.route,
            ))
        .toList();
  }

  Widget _buildPageContent() {
    final colors = context.colorsListening;

    return Container(
      color: colors.bgColor,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24),
      child: widget.child ?? const SizedBox.shrink(),
    );
  }
}
