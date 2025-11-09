// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../screens/styleguide_home.dart';
import '../../screens/styleguide_pages/welcome_page.dart' as welcome;
import '../../screens/styleguide_pages/colors_typography_page.dart';
import '../../screens/styleguide_pages/atoms_page.dart';
import '../../screens/styleguide_pages/molecules_page.dart';

import '../../screens/styleguide_pages/organisms_page.dart';
import '../../screens/styleguide_pages/icons_logos_page.dart';
import '../../screens/styleguide_pages/logos_page.dart';
import '../../screens/styleguide_pages/headers_page.dart';
import '../../screens/styleguide_pages/profile_page.dart';
import '../../screens/styleguide_pages/auth_page.dart';
import '../../screens/styleguide_pages/loading_indicators_page.dart';
import '../../screens/styleguide_pages/loading_states_page.dart';
import '../../screens/styleguide_pages/mcp_page.dart';
import '../../screens/styleguide_pages/organisms/webhook_page.dart';
import '../../screens/styleguide_pages/markdown_renderer_page.dart';

// App route paths
class AppRoutes {
  static const String WELCOME = '/welcome';
  static const String COLORS_TYPOGRAPHY = '/colors-typography';
  static const String ATOMS = '/atoms';
  static const String MOLECULES = '/molecules';
  static const String MOLECULES_PAGINATED_DATA_TABLE = '/molecules/paginated-data-table';
  static const String ORGANISMS = '/organisms';
  static const String ICONS_LOGOS = '/icons-logos';
  static const String LOGOS_COMPONENTS = '/logos-components';
  static const String HEADERS = '/headers';
  static const String USER_PROFILE = '/user-profile';
  static const String AUTHENTICATION = '/authentication';
  static const String LOADING_INDICATORS = '/loading-indicators';
  static const String LOADING_STATES = '/loading-states';
  static const String MCP_COMPONENTS = '/mcp';
  static const String WEBHOOK_COMPONENTS = '/webhook';
  static const String MARKDOWN_RENDERER = '/markdown-renderer';
}

class StyleguideRouter {
  static GoRouter createRouter() {
    debugPrint('🚀 Creating StyleguideRouter...');
    debugPrint('📋 Registered routes:');
    debugPrint('  - / (redirect to ${AppRoutes.WELCOME})');
    debugPrint('  - ${AppRoutes.WELCOME}');
    debugPrint('  - ${AppRoutes.HEADERS}');
    debugPrint('  - ${AppRoutes.ATOMS}');
    debugPrint('  - ${AppRoutes.MOLECULES}');
    debugPrint('  - ${AppRoutes.ORGANISMS}');
    debugPrint('  - ${AppRoutes.COLORS_TYPOGRAPHY}');
    debugPrint('  - ${AppRoutes.ICONS_LOGOS}');
    debugPrint('  - ${AppRoutes.LOGOS_COMPONENTS}');
    debugPrint('  - ${AppRoutes.USER_PROFILE}');
    debugPrint('  - ${AppRoutes.AUTHENTICATION}');
    debugPrint('  - ${AppRoutes.LOADING_INDICATORS}');
    debugPrint('  - ${AppRoutes.LOADING_STATES}');
    debugPrint('  - ${AppRoutes.MCP_COMPONENTS}');
    debugPrint('  - ${AppRoutes.WEBHOOK_COMPONENTS}');
    debugPrint('  - ${AppRoutes.MARKDOWN_RENDERER}');
    
    return GoRouter(
      debugLogDiagnostics: true,
      redirect: (context, state) {
        debugPrint('🔵 Global redirect - location: ${state.uri.path}');
        if (state.uri.path == '/') {
          debugPrint('🟡 Root / redirect to ${AppRoutes.WELCOME}');
          return AppRoutes.WELCOME;
        }
        debugPrint('🟢 Allowing navigation to: ${state.uri.path}');
        return null; // Allow navigation to other routes
      },
      errorBuilder: (context, state) {
        debugPrint('🔴 Router Error: ${state.error}');
        debugPrint('🔴 Requested location: ${state.uri}');
        debugPrint('🔴 Error details: ${state.error?.toString()}');
        return const welcome.WelcomePage();
      },
      routes: [
        ShellRoute(
        builder: (context, state, child) {
          debugPrint('🟢 ShellRoute building - location: ${state.uri}');
          return StyleguideShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.WELCOME,
            pageBuilder: (context, state) {
              debugPrint('✅ Navigating to WELCOME');
              return const NoTransitionPage(child: welcome.WelcomePage());
            },
          ),
          GoRoute(
            path: AppRoutes.COLORS_TYPOGRAPHY,
            pageBuilder: (context, state) {
              debugPrint('✅ Navigating to COLORS_TYPOGRAPHY');
              return const NoTransitionPage(child: ColorsTypographyPage());
            },
          ),
          GoRoute(
            path: AppRoutes.ATOMS,
            pageBuilder: (context, state) {
              debugPrint('✅ Navigating to ATOMS');
              return const NoTransitionPage(child: AtomsPage());
            },
          ),
          GoRoute(
            path: AppRoutes.MOLECULES,
            pageBuilder: (context, state) {
              debugPrint('✅ Navigating to MOLECULES');
              return const NoTransitionPage(child: MoleculesPage());
            },
          ),
          GoRoute(
            path: AppRoutes.ORGANISMS,
            pageBuilder: (context, state) {
              debugPrint('✅ Navigating to ORGANISMS');
              return const NoTransitionPage(child: OrganismsPage());
            },
          ),
          GoRoute(
            path: AppRoutes.ICONS_LOGOS,
            pageBuilder: (context, state) {
              debugPrint('✅ Navigating to ICONS_LOGOS');
              return const NoTransitionPage(child: IconsLogosPage());
            },
          ),
          GoRoute(
            path: AppRoutes.LOGOS_COMPONENTS,
            pageBuilder: (context, state) {
              debugPrint('✅ Navigating to LOGOS_COMPONENTS');
              return const NoTransitionPage(child: LogosPage());
            },
          ),
          GoRoute(
            path: AppRoutes.HEADERS,
            pageBuilder: (context, state) {
              debugPrint('✅ Navigating to HEADERS');
              return const NoTransitionPage(child: HeadersPage());
            },
          ),
          GoRoute(
            path: AppRoutes.USER_PROFILE,
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfilePage()),
          ),
          GoRoute(
            path: AppRoutes.AUTHENTICATION,
            pageBuilder: (context, state) => const NoTransitionPage(child: AuthPage()),
          ),
          GoRoute(
            path: AppRoutes.LOADING_INDICATORS,
            pageBuilder: (context, state) => const NoTransitionPage(child: LoadingIndicatorsPage()),
          ),
          GoRoute(
            path: AppRoutes.LOADING_STATES,
            pageBuilder: (context, state) => const NoTransitionPage(child: LoadingStatesPage()),
          ),
          GoRoute(
            path: AppRoutes.MCP_COMPONENTS,
            pageBuilder: (context, state) => const NoTransitionPage(child: McpPage()),
          ),
          GoRoute(
            path: AppRoutes.WEBHOOK_COMPONENTS,
            pageBuilder: (context, state) => const NoTransitionPage(child: WebhookPage()),
          ),
          GoRoute(
            path: AppRoutes.MARKDOWN_RENDERER,
            pageBuilder: (context, state) => const NoTransitionPage(child: MarkdownRendererPage()),
          ),
      ],
    ),
  ],
);
  }
}

// Navigation items configuration for styleguide
class StyleguideNavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const StyleguideNavigationItem({required this.icon, required this.label, required this.route});
}

const List<StyleguideNavigationItem> styleguideNavigationItems = [
  StyleguideNavigationItem(icon: Icons.home_outlined, label: 'Welcome', route: AppRoutes.WELCOME),
  StyleguideNavigationItem(
    icon: Icons.palette_outlined,
    label: 'Colors & Typography',
    route: AppRoutes.COLORS_TYPOGRAPHY,
  ),
  StyleguideNavigationItem(icon: Icons.grain_outlined, label: 'Atoms', route: AppRoutes.ATOMS),
  StyleguideNavigationItem(icon: Icons.view_module_outlined, label: 'Molecules', route: AppRoutes.MOLECULES),
  StyleguideNavigationItem(icon: Icons.view_quilt_outlined, label: 'Organisms', route: AppRoutes.ORGANISMS),
  StyleguideNavigationItem(icon: Icons.image_outlined, label: 'Icons & Logos', route: AppRoutes.ICONS_LOGOS),
  StyleguideNavigationItem(
    icon: Icons.branding_watermark_outlined,
    label: 'Logos Components',
    route: AppRoutes.LOGOS_COMPONENTS,
  ),
  StyleguideNavigationItem(icon: Icons.view_headline_outlined, label: 'Headers', route: AppRoutes.HEADERS),
  StyleguideNavigationItem(icon: Icons.person_outlined, label: 'User Profile', route: AppRoutes.USER_PROFILE),
  StyleguideNavigationItem(icon: Icons.login_outlined, label: 'Authentication', route: AppRoutes.AUTHENTICATION),
  StyleguideNavigationItem(
    icon: Icons.hourglass_empty_outlined,
    label: 'Loading Indicators',
    route: AppRoutes.LOADING_INDICATORS,
  ),
  StyleguideNavigationItem(icon: Icons.refresh_outlined, label: 'Loading States', route: AppRoutes.LOADING_STATES),
  StyleguideNavigationItem(
    icon: Icons.settings_input_component_outlined,
    label: 'MCP Components',
    route: AppRoutes.MCP_COMPONENTS,
  ),
  StyleguideNavigationItem(
    icon: Icons.webhook_outlined,
    label: 'Webhook Components',
    route: AppRoutes.WEBHOOK_COMPONENTS,
  ),
  StyleguideNavigationItem(
    icon: Icons.description_outlined,
    label: 'Markdown Renderer',
    route: AppRoutes.MARKDOWN_RENDERER,
  ),
];

// Shell that wraps all styleguide pages
class StyleguideShell extends StatelessWidget {
  final Widget child;

  const StyleguideShell({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return StyleguideHome(child: child);
  }
}
