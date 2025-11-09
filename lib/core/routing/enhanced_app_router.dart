import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../providers/enhanced_auth_provider.dart';

import '../../screens/home_screen.dart';
import '../../screens/loading_screen.dart';
import '../../screens/unauthenticated_home_screen.dart';
import '../../screens/oauth_callback_screen.dart';
import '../../screens/pages/dashboard_page.dart';
import '../../screens/pages/ai_jobs_page.dart';
import '../../screens/pages/workspaces_page.dart';
import '../../screens/pages/applications_page.dart';
import '../../screens/pages/integrations_page.dart';
import '../../screens/pages/users_page.dart';
import '../../screens/pages/settings_page.dart';
import '../../screens/pages/api_demo_page.dart';
import '../../screens/pages/mcp_page.dart';
import '../../screens/pages/chat_page.dart';
import '../../screens/pages/components_demo_page.dart';

// Conditional import for web-specific OAuth handling
import '../../screens/oauth_callback_web.dart' if (dart.library.io) '../../screens/oauth_callback_stub.dart';

class EnhancedAppRouter {
  static bool _oauthCallbackProcessed = false;

  static GoRouter createRouter(EnhancedAuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
      redirect: (context, state) {
        final authState = authProvider.authState;
        final isAuthenticated = authProvider.isAuthenticated;
        final isLoading = authProvider.isLoading;
        final currentPath = state.uri.toString();
        final location = state.uri.toString();
        final matchedLocation = state.matchedLocation;

        if (kDebugMode) {
          debugPrint('🔄 Enhanced Router redirect check:');
          debugPrint('   📍 Full URI: $currentPath');
          debugPrint('   📍 Location: $location');
          debugPrint('   📍 Matched Location: $matchedLocation');
          debugPrint('   🔐 Auth state: $authState, isAuthenticated: $isAuthenticated, isLoading: $isLoading');
          debugPrint('   🛡️ Is protected route: ${_isProtectedRoute(currentPath)}');
        }

        // Check for OAuth parameters on any route - only if not authenticated
        if (kIsWeb && !isAuthenticated && !_oauthCallbackProcessed) {
          final oauthParams = getOAuthParamsFromWindow();

          if (kDebugMode) {
            debugPrint('🔍 OAuth params object: $oauthParams');
            debugPrint('🔍 Checking OAuth params on path: $currentPath');
            debugPrint('🔍 OAuth params from window: $oauthParams');
          }

          if (oauthParams != null && oauthParams.containsKey('code')) {
            if (kDebugMode) {
              debugPrint('🚫 OAuth callback detected - processing callback');
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

        // If not authenticated and trying to access protected routes, redirect to auth
        if (!isAuthenticated && _isProtectedRoute(currentPath)) {
          if (kDebugMode) debugPrint('🚫 Redirecting to auth: not authenticated on protected route');
          return '/auth';
        }

        // Check for admin-only routes
        if (isAuthenticated && _isAdminOnlyRoute(currentPath)) {
          final user = authProvider.currentUser;
          final isAdmin = user?.role == 'ADMIN';
          if (!isAdmin) {
            if (kDebugMode) debugPrint('🚫 Redirecting to ai-jobs: non-admin user trying to access admin route');
            return '/ai-jobs';
          }
        }

        // If authenticated and on auth page, redirect to ai-jobs (first available page)
        if (isAuthenticated && currentPath == '/auth') {
          if (kDebugMode) debugPrint('🏠 Redirecting to ai-jobs: authenticated on auth page');
          return '/ai-jobs';
        }

        // If authenticated and on root path, redirect to ai-jobs (first available page)
        if (isAuthenticated && (currentPath == '/' || currentPath == '')) {
          if (kDebugMode) debugPrint('🏠 Redirecting to ai-jobs: authenticated on root path ($currentPath)');
          return '/ai-jobs';
        }

        if (kDebugMode) {
          debugPrint('✅ No redirect needed');
        }
        return null; // No redirect needed
      },
      routes: [
        // Root route - redirect to auth by default
        GoRoute(
          path: '/',
          redirect: (context, state) {
            // Always redirect to auth, let main redirect logic handle auth
            if (kDebugMode) debugPrint('🔄 Root route redirect: / → /auth');
            return '/auth';
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

        // Dynamic authentication route
        GoRoute(
          path: '/auth',
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

        // AI Jobs route
        GoRoute(
          path: '/ai-jobs',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: AiJobsPage()),
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

        // MCP route
        GoRoute(
          path: '/mcp',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: McpPage()),
          ),
        ),

        // Chat route
        GoRoute(
          path: '/chat',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: ChatPage()),
          ),
        ),

        // Components Demo route
        GoRoute(
          path: '/components-demo',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: ComponentsDemoPage()),
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
                onPressed: () => context.go('/ai-jobs'),
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
      '/ai-jobs',
      '/workspaces',
      '/applications',
      '/integrations',
      '/users',
      '/settings',
      '/api-demo',
      '/mcp',
      '/chat',
      '/components-demo',
    ];
    return protectedRoutes.contains(path);
  }

  // Helper method to check if a route requires admin role
  static bool _isAdminOnlyRoute(String path) {
    const adminOnlyRoutes = [
      '/users',
    ];
    return adminOnlyRoutes.contains(path);
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

// Navigation items for the main app
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
  // Core functional pages
  NavigationItem(icon: Icons.smart_toy_outlined, label: 'AI Jobs', route: '/ai-jobs'),
  NavigationItem(icon: Icons.integration_instructions_outlined, label: 'Integrations', route: '/integrations'),
  NavigationItem(icon: Icons.chat_outlined, label: 'Chat', route: '/chat'),
  NavigationItem(icon: Icons.hub_outlined, label: 'MCP', route: '/mcp'),
  
  // Admin-only pages (filtered by role in home_screen.dart)
  NavigationItem(icon: Icons.people_outline, label: 'Users', route: '/users'),
  
  // Demo/Examples pages
  NavigationItem(icon: Icons.widgets_outlined, label: 'Components', route: '/components-demo'),
  
  // Temporarily hidden pages (not needed for now)
  // NavigationItem(icon: Icons.workspaces_outlined, label: 'Workspaces', route: '/workspaces'),
  // NavigationItem(icon: Icons.api_outlined, label: 'API Demo', route: '/api-demo'),
  
  // Placeholder pages (TODO: implement and uncomment when ready)
  // NavigationItem(icon: Icons.dashboard_outlined, label: 'Dashboard', route: '/dashboard'),
  // NavigationItem(icon: Icons.apps_outlined, label: 'Applications', route: '/applications'),
  // NavigationItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
];
