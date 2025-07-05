import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';
import '../../screens/home_screen.dart';
import '../../screens/loading_screen.dart';
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

// Conditional import for web-specific OAuth handling
import '../../screens/oauth_callback_web.dart' if (dart.library.io) '../../screens/oauth_callback_stub.dart';

class AppRouter {
  static bool _oauthCallbackProcessed = false;

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      // Don't force initial location, let it use the current URL
      // initialLocation: '/',
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
          print('   🛡️ Is protected route: ${_isProtectedRoute(currentPath)}');
        }

        // Check for OAuth parameters on any route - only if not authenticated
        if (kIsWeb && !isAuthenticated && !_oauthCallbackProcessed) {
          final oauthParams = getOAuthParamsFromWindow();

          if (kDebugMode) {
            print('🔍 OAuth params object: $oauthParams');
            print('🔍 Checking OAuth params on path: $currentPath');
            print('🔍 OAuth params from window: $oauthParams');
          }

          if (oauthParams != null && oauthParams.containsKey('code')) {
            if (kDebugMode) {
              print('🚫 OAuth callback detected - processing callback');
            }
            _oauthCallbackProcessed = true;
            return '/oauth-processing';
          }
        }

        // Reset flag when authenticated or not processing OAuth
        if (isAuthenticated || currentPath != '/oauth-processing') {
          _oauthCallbackProcessed = false;
        }

        // Never redirect during OAuth processing
        if (currentPath.contains('/oauth-processing')) {
          return null;
        }

        // Show loading screen during initial authentication check or loading state
        if (authState == AuthState.initial || isLoading) {
          if (currentPath != '/loading') {
            // By returning null, we prevent the router from navigating to the '/loading'
            // screen, which would obscure our HTML pre-loader. The UI will simply
            // show nothing until authentication is complete.
            return null;
          }
          return null;
        }

        // If not authenticated and trying to access protected routes, redirect to unauthenticated
        if (!isAuthenticated && _isProtectedRoute(currentPath)) {
          if (kDebugMode) print('🚫 Redirecting to unauthenticated: not authenticated on protected route');
          return '/unauthenticated';
        }

        // If authenticated and on unauthenticated page, redirect to dashboard
        if (isAuthenticated && currentPath == '/unauthenticated') {
          if (kDebugMode) print('🏠 Redirecting to dashboard: authenticated on unauthenticated page');
          return '/dashboard';
        }

        // If authenticated and on root path, redirect to dashboard
        if (isAuthenticated && (currentPath == '/' || currentPath == '')) {
          if (kDebugMode) print('🏠 Redirecting to dashboard: authenticated on root path ($currentPath)');
          return '/dashboard';
        }

        if (kDebugMode) {
          print('✅ No redirect needed');
        }
        return null; // No redirect needed
      },
      routes: [
        // Root route - redirect to unauthenticated by default
        GoRoute(
          path: '/',
          redirect: (context, state) {
            // Always redirect to unauthenticated, let main redirect logic handle auth
            if (kDebugMode) print('🔄 Root route redirect: / → /unauthenticated');
            return '/unauthenticated';
          },
        ),

        // OAuth processing route - handles OAuth parameters from window
        GoRoute(
          path: '/oauth-processing',
          builder: (context, state) {
            // Create a mock URI with OAuth parameters from window
            if (kIsWeb) {
              final oauthParams = getOAuthParamsFromWindow();
              if (oauthParams != null) {
                final uri = Uri(
                  scheme: 'https',
                  host: 'callback',
                  path: '/oauth-processing',
                  queryParameters: oauthParams,
                );
                return OAuthCallbackScreen(callbackUri: uri);
              }
            }

            // Fallback if no OAuth params found
            return const Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('OAuth callback error: No parameters found'),
                  ],
                ),
              ),
            );
          },
        ),

        // Loading route - shown during authentication initialization
        GoRoute(
          path: '/loading',
          builder: (context, state) => const LoadingScreen(),
        ),

        // Unauthenticated route
        GoRoute(
          path: '/unauthenticated',
          builder: (context, state) => const UnauthenticatedHomeScreen(),
        ),

        // Dashboard route - directly accessible
        GoRoute(
          path: '/dashboard',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: DashboardPage()),
          ),
        ),

        // Agents route
        GoRoute(
          path: '/agents',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: AgentsPage()),
          ),
        ),

        // Workspaces route
        GoRoute(
          path: '/workspaces',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: WorkspacesPage()),
          ),
        ),

        // Applications route
        GoRoute(
          path: '/applications',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: ApplicationsPage()),
          ),
        ),

        // Integrations route
        GoRoute(
          path: '/integrations',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: IntegrationsPage()),
          ),
        ),

        // Users route
        GoRoute(
          path: '/users',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: UsersPage()),
          ),
        ),

        // Settings route
        GoRoute(
          path: '/settings',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: SettingsPage()),
          ),
        ),

        // API Demo route
        GoRoute(
          path: '/api-demo',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: ApiDemoPage()),
          ),
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

  // Helper method to check if a route is protected
  static bool _isProtectedRoute(String path) {
    const protectedRoutes = [
      '/dashboard',
      '/agents',
      '/workspaces',
      '/applications',
      '/integrations',
      '/users',
      '/settings',
      '/api-demo',
    ];
    return protectedRoutes.contains(path);
  }

  // Helper method to create a fade transition page
  static Page<void> _buildFadePage(GoRouterState state, Widget child) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
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
