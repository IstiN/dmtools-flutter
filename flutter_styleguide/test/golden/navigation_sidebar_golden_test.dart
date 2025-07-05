import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../golden_test_helper.dart';

void main() {
  group('NavigationSidebar Golden Tests', () {
    // Sample navigation items for testing
    const List<NavigationItem> testItems = [
      NavigationItem(
        icon: Icons.dashboard_outlined,
        label: 'Dashboard',
        route: '/dashboard',
      ),
      NavigationItem(
        icon: Icons.smart_toy_outlined,
        label: 'Agents',
        route: '/agents',
      ),
      NavigationItem(
        icon: Icons.folder_outlined,
        label: 'Workspaces',
        route: '/workspaces',
      ),
      NavigationItem(
        icon: Icons.apps_outlined,
        label: 'Applications',
        route: '/applications',
      ),
      NavigationItem(
        icon: Icons.extension_outlined,
        label: 'Integrations',
        route: '/integrations',
      ),
      NavigationItem(
        icon: Icons.people_outlined,
        label: 'Users',
        route: '/users',
      ),
      NavigationItem(
        icon: Icons.settings_outlined,
        label: 'Settings',
        route: '/settings',
      ),
    ];

    testWidgets('NavigationSidebar - Light Theme - Desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 300,
            height: 500,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/dashboard',
              isTestMode: true,
              testDarkMode: false,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_light_desktop.png'),
      );
    });

    testWidgets('NavigationSidebar - Dark Theme - Desktop', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 300,
            height: 500,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/dashboard',
              isTestMode: true,
              testDarkMode: true,
            ),
          ),
          darkMode: true,
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_dark_desktop.png'),
      );
    });

    testWidgets('NavigationSidebar - Light Theme - Mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 300,
            height: 500,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/agents',
              isTestMode: true,
              testDarkMode: false,
              isMobile: true,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_light_mobile.png'),
      );
    });

    testWidgets('NavigationSidebar - Dark Theme - Mobile', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 300,
            height: 500,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/agents',
              isTestMode: true,
              testDarkMode: true,
              isMobile: true,
            ),
          ),
          darkMode: true,
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_dark_mobile.png'),
      );
    });

    testWidgets('NavigationSidebar - Different Selected States', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 300,
            height: 500,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/integrations',
              isTestMode: true,
              testDarkMode: false,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_integrations_selected.png'),
      );
    });

    testWidgets('NavigationSidebar - No Footer', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 300,
            height: 400,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/settings',
              isTestMode: true,
              testDarkMode: false,
              showFooter: false,
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_no_footer.png'),
      );
    });
  });
}
