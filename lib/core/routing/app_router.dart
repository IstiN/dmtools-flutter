import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/home_screen.dart';
import '../../screens/unauthenticated_home_screen.dart';
import '../../screens/oauth_callback_screen.dart';
import '../../screens/pages/dashboard_page.dart';
import '../../screens/pages/agents_page.dart';
import '../../screens/pages/workspaces_page.dart';
import '../../screens/pages/applications_page.dart';
import '../../screens/pages/integrations_page.dart';
import '../../screens/pages/users_page.dart';
import '../../screens/pages/settings_page.dart';
import '../../screens/pages/api_demo_page.dart';

class AppRouter {
  static bool _oauthCallbackProcessed = false;

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/unauthenticated',
      refreshListenable: authProvider,
      redirect: (context, state) {
        final authState = authProvider.authState;
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoading = authProvider.isLoading;
        final currentPath = state.uri.toString();
        final location = state.uri.toString();
        final matchedLocation = state.matchedLocation;

        if (kDebugMode) {
          print('🔄 Router redirect check:');
          print('   📍 Full URI: $currentPath');
          print('   📍 Location: $location');
          print('   📍 Matched Location: $matchedLocation');
          print('   🔐 Auth state: $authState, isAuthenticated: $isAuthenticated, isLoading: $isLoading');
        }

        // Check browser URL directly for OAuth callback - only if not authenticated
        if (kIsWeb && !isAuthenticated && !_oauthCallbackProcessed) {
          final browserUrl = Uri.base.toString();

          if (browserUrl.contains('/auth/callback') && !location.contains('/auth/callback')) {
            if (kDebugMode) {
              print('🚫 OAuth callback detected - navigating to callback route');
            }
            _oauthCallbackProcessed = true;
            return '/auth/callback';
          }
        }

        // Reset flag when authenticated or not on callback route
        if (isAuthenticated || !location.contains('/auth/callback')) {
          _oauthCallbackProcessed = false;
        }

        // Never redirect during OAuth callback handling - this is critical!
        if (currentPath.contains('/auth/callback') || location.contains('/auth/callback')) {
          return null;
        }

        // If still initializing and not on unauthenticated page, go to unauthenticated
        if (authState == AuthState.initial && currentPath != '/unauthenticated') {
          return '/unauthenticated';
        }

        // Don't redirect during loading unless we know the user should be redirected
        if (isLoading) {
          return null;
        }

        // If not authenticated and trying to access protected routes, redirect to unauthenticated
        if (!isAuthenticated && currentPath != '/unauthenticated') {
          return '/unauthenticated';
        }

        // If authenticated and on unauthenticated page, redirect to dashboard
        if (isAuthenticated && currentPath == '/unauthenticated') {
          return '/dashboard';
        }

        if (kDebugMode) {
          print('✅ No redirect needed');
        }
        return null; // No redirect needed
      },
      routes: [
        // High-priority OAuth callback route - catches callbacks even with fragments
        GoRoute(
          path: '/',
          redirect: (context, state) {
            if (kIsWeb) {
              final browserUrl = Uri.base.toString();
              if (kDebugMode) {
                print('🔍 Root route check - Browser URL: $browserUrl');
              }

              // If browser URL contains OAuth callback, redirect to callback route
              if (browserUrl.contains('/auth/callback')) {
                if (kDebugMode) {
                  print('🔄 Root route detected OAuth callback, redirecting...');
                }
                return '/auth/callback';
              }
            }

            // Otherwise redirect to unauthenticated
            return '/unauthenticated';
          },
        ),

        // OAuth callback route - handle fragments and query params explicitly
        GoRoute(
          path: '/auth/callback',
          builder: (context, state) {
            Uri callbackUri;

            // Try to get the real callback URI from browser if available
            if (kIsWeb) {
              final browserUri = Uri.base;

              // If browser URL contains callback info, use that
              if (browserUri.path.contains('/auth/callback') || browserUri.toString().contains('/auth/callback')) {
                callbackUri = browserUri;
              } else {
                callbackUri = state.uri;
              }
            } else {
              callbackUri = state.uri;
            }

            return OAuthCallbackScreen(callbackUri: callbackUri);
          },
        ),
        // Unauthenticated route
        GoRoute(
          path: '/unauthenticated',
          builder: (context, state) => const UnauthenticatedHomeScreen(),
        ),
        // Protected routes - wrapped in shell route
        ShellRoute(
          builder: (context, state, child) {
            return HomeScreen(child: child);
          },
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
            GoRoute(
              path: '/agents',
              builder: (context, state) => const AgentsPage(),
            ),
            GoRoute(
              path: '/workspaces',
              builder: (context, state) => const WorkspacesPage(),
            ),
            GoRoute(
              path: '/applications',
              builder: (context, state) => const ApplicationsPage(),
            ),
            GoRoute(
              path: '/integrations',
              builder: (context, state) => const IntegrationsPage(),
            ),
            GoRoute(
              path: '/users',
              builder: (context, state) => const UsersPage(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsPage(),
            ),
            GoRoute(
              path: '/api-demo',
              builder: (context, state) => const ApiDemoPage(),
            ),
          ],
        ),
      ],
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Page not found: ${state.uri}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Navigation items configuration
class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}

const List<NavigationItem> navigationItems = [
  NavigationItem(icon: Icons.dashboard_outlined, label: 'Dashboard', route: '/dashboard'),
  NavigationItem(icon: Icons.smart_toy_outlined, label: 'Agents', route: '/agents'),
  NavigationItem(icon: Icons.folder_outlined, label: 'Workspaces', route: '/workspaces'),
  NavigationItem(icon: Icons.apps_outlined, label: 'Applications', route: '/applications'),
  NavigationItem(icon: Icons.extension_outlined, label: 'Integrations', route: '/integrations'),
  NavigationItem(icon: Icons.people_outlined, label: 'Users', route: '/users'),
  NavigationItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
  NavigationItem(icon: Icons.api_outlined, label: 'API Demo', route: '/api-demo'),
];

// Home Screen Shell that wraps all main app pages
class HomeScreenShell extends StatelessWidget {
  final Widget child;

  const HomeScreenShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return HomeScreen(child: child);
  }
}
