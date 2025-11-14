import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../analytics/analytics_event_helpers.dart';
import '../analytics/analytics_route_observer.dart';
import '../../providers/enhanced_auth_provider.dart';
import '../../screens/home_screen.dart';
import '../../screens/loading_screen.dart';
import '../../screens/oauth_callback_screen.dart';
import '../../screens/pages/ai_jobs_page.dart';
import '../../screens/pages/api_demo_page.dart';
import '../../screens/pages/applications_page.dart';
import '../../screens/pages/chat_page.dart';
import '../../screens/pages/dashboard_page.dart';
import '../../screens/pages/integrations_page.dart';
import '../../screens/pages/mcp_page.dart';
import '../../screens/pages/settings_page.dart';
import '../../screens/pages/users_page.dart';
import '../../screens/pages/workspaces_page.dart';
import '../../screens/unauthenticated_home_screen.dart';

// Conditional import for web-specific OAuth handling
import '../../screens/oauth_callback_web.dart' if (dart.library.io) '../../screens/oauth_callback_stub.dart';

class EnhancedAppRouter {
  static bool _oauthCallbackProcessed = false;

  static GoRouter createRouter(EnhancedAuthProvider authProvider) {
    return GoRouter(
      refreshListenable: authProvider,
      observers: [AnalyticsRouteObserver()],
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
          name: 'root_redirect',
          path: '/',
          redirect: (context, state) {
            // Always redirect to auth, let main redirect logic handle auth
            if (kDebugMode) debugPrint('🔄 Root route redirect: / → /auth');
            return '/auth';
          },
        ),

        // OAuth processing route - handles OAuth parameters from window
        GoRoute(
          name: 'oauth_processing',
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
          name: 'loading_screen',
          path: '/loading',
          builder: (context, state) => const LoadingScreen(),
        ),

        // Dynamic authentication route
        GoRoute(
          name: 'auth_page',
          path: '/auth',
          builder: (context, state) => const UnauthenticatedHomeScreen(),
        ),

        // Dashboard route - directly accessible
        GoRoute(
          name: 'dashboard_page',
          path: '/dashboard',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: DashboardPage()),
          ),
        ),

        // AI Jobs route
        GoRoute(
          name: 'ai_jobs_page',
          path: '/ai-jobs',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: AiJobsPage()),
          ),
        ),

        // Workspaces route
        GoRoute(
          name: 'workspaces_page',
          path: '/workspaces',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: WorkspacesPage()),
          ),
        ),

        // Applications route
        GoRoute(
          name: 'applications_page',
          path: '/applications',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: ApplicationsPage()),
          ),
        ),

        // Integrations route
        GoRoute(
          name: 'integrations_page',
          path: '/integrations',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: IntegrationsPage()),
          ),
        ),

        // Users route
        GoRoute(
          name: 'users_page',
          path: '/users',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: UsersPage()),
          ),
        ),

        // Settings route
        GoRoute(
          name: 'settings_page',
          path: '/settings',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: SettingsPage()),
          ),
        ),

        // API Demo route
        GoRoute(
          name: 'api_demo_page',
          path: '/api-demo',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: ApiDemoPage()),
          ),
        ),

        // MCP route
        GoRoute(
          name: 'mcp_page',
          path: '/mcp',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: McpPage()),
          ),
        ),

        // Chat route
        GoRoute(
          name: 'chat_page',
          path: '/chat',
          pageBuilder: (context, state) => _buildFadePage(
            state,
            const HomeScreen(child: ChatPage()),
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
                onPressed: () {
                  trackManualButtonClick('go_home_button');
                  context.go('/ai-jobs');
                },
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
/// Supports both SVG icons (preferred) and Material icons (fallback)
class NavigationItem {
  final IconData? icon;
  final String? svgIconPath;
  final String label;
  final String route;

  const NavigationItem({
    required this.label,
    required this.route,
    this.icon,
    this.svgIconPath,
  }) : assert(
          icon != null || svgIconPath != null,
          'Either icon or svgIconPath must be provided',
        );
}

const List<NavigationItem> navigationItems = [
  // Core functional pages - Chat first as requested
  NavigationItem(label: 'Chat', route: '/chat', svgIconPath: 'packages/dmtools_styleguide/assets/img/nav-icon-chat.svg'),
  NavigationItem(label: 'AI Jobs', route: '/ai-jobs', svgIconPath: 'packages/dmtools_styleguide/assets/img/nav-icon-ai-jobs.svg'),
  NavigationItem(label: 'Integrations', route: '/integrations', svgIconPath: 'packages/dmtools_styleguide/assets/img/nav-icon-integrations.svg'),
  NavigationItem(label: 'MCP', route: '/mcp', svgIconPath: 'packages/dmtools_styleguide/assets/img/nav-icon-mcp.svg'),
  
  // Admin-only pages (filtered by role in home_screen.dart)
  NavigationItem(label: 'Users', route: '/users', icon: Icons.people_outline),
  
  // Temporarily hidden pages (not needed for now)
  // NavigationItem(icon: Icons.workspaces_outlined, label: 'Workspaces', route: '/workspaces'),
  // NavigationItem(icon: Icons.api_outlined, label: 'API Demo', route: '/api-demo'),
  
  // Placeholder pages (TODO: implement and uncomment when ready)
  // NavigationItem(icon: Icons.dashboard_outlined, label: 'Dashboard', route: '/dashboard'),
  // NavigationItem(icon: Icons.apps_outlined, label: 'Applications', route: '/applications'),
  // NavigationItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
];
