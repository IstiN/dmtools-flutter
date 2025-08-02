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

class StyleguideRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/welcome',
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/welcome'),
      ShellRoute(
        builder: (context, state, child) {
          return StyleguideShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/welcome',
            pageBuilder: (context, state) => const NoTransitionPage(child: welcome.WelcomePage()),
          ),
          GoRoute(
            path: '/colors-typography',
            pageBuilder: (context, state) => const NoTransitionPage(child: ColorsTypographyPage()),
          ),
          GoRoute(
            path: '/atoms',
            pageBuilder: (context, state) => const NoTransitionPage(child: AtomsPage()),
          ),
          GoRoute(
            path: '/molecules',
            pageBuilder: (context, state) => const NoTransitionPage(child: MoleculesPage()),
          ),
          GoRoute(
            path: '/organisms',
            pageBuilder: (context, state) => const NoTransitionPage(child: OrganismsPage()),
          ),
          GoRoute(
            path: '/icons-logos',
            pageBuilder: (context, state) => const NoTransitionPage(child: IconsLogosPage()),
          ),
          GoRoute(
            path: '/logos-components',
            pageBuilder: (context, state) => const NoTransitionPage(child: LogosPage()),
          ),
          GoRoute(
            path: '/headers',
            pageBuilder: (context, state) => const NoTransitionPage(child: HeadersPage()),
          ),
          GoRoute(
            path: '/user-profile',
            pageBuilder: (context, state) => const NoTransitionPage(child: ProfilePage()),
          ),
          GoRoute(
            path: '/authentication',
            pageBuilder: (context, state) => const NoTransitionPage(child: AuthPage()),
          ),
          GoRoute(
            path: '/loading-indicators',
            pageBuilder: (context, state) => const NoTransitionPage(child: LoadingIndicatorsPage()),
          ),
          GoRoute(
            path: '/loading-states',
            pageBuilder: (context, state) => const NoTransitionPage(child: LoadingStatesPage()),
          ),
          GoRoute(
            path: '/mcp',
            pageBuilder: (context, state) => const NoTransitionPage(child: McpPage()),
          ),
        ],
      ),
    ],
  );
}

// Navigation items configuration for styleguide
class StyleguideNavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const StyleguideNavigationItem({required this.icon, required this.label, required this.route});
}

const List<StyleguideNavigationItem> styleguideNavigationItems = [
  StyleguideNavigationItem(icon: Icons.home_outlined, label: 'Welcome', route: '/welcome'),
  StyleguideNavigationItem(icon: Icons.palette_outlined, label: 'Colors & Typography', route: '/colors-typography'),
  StyleguideNavigationItem(icon: Icons.grain_outlined, label: 'Atoms', route: '/atoms'),
  StyleguideNavigationItem(icon: Icons.view_module_outlined, label: 'Molecules', route: '/molecules'),
  StyleguideNavigationItem(icon: Icons.view_quilt_outlined, label: 'Organisms', route: '/organisms'),
  StyleguideNavigationItem(icon: Icons.image_outlined, label: 'Icons & Logos', route: '/icons-logos'),
  StyleguideNavigationItem(
    icon: Icons.branding_watermark_outlined,
    label: 'Logos Components',
    route: '/logos-components',
  ),
  StyleguideNavigationItem(icon: Icons.view_headline_outlined, label: 'Headers', route: '/headers'),
  StyleguideNavigationItem(icon: Icons.person_outlined, label: 'User Profile', route: '/user-profile'),
  StyleguideNavigationItem(icon: Icons.login_outlined, label: 'Authentication', route: '/authentication'),
  StyleguideNavigationItem(
    icon: Icons.hourglass_empty_outlined,
    label: 'Loading Indicators',
    route: '/loading-indicators',
  ),
  StyleguideNavigationItem(
    icon: Icons.refresh_outlined,
    label: 'Loading States',
    route: '/loading-states',
  ),
  StyleguideNavigationItem(icon: Icons.settings_input_component_outlined, label: 'MCP Components', route: '/mcp'),
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
