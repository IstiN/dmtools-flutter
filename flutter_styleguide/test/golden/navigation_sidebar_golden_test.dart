import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../golden_test_helper.dart';

void main() {
  group('NavigationSidebar Golden Tests', () {
    // Sample navigation items for testing - Chat first as per new design
    const List<NavigationItem> testItems = [
      NavigationItem(
        label: 'Chat',
        route: '/chat',
        svgIconPath: 'assets/img/nav-icon-chat.svg',
      ),
      NavigationItem(
        label: 'AI Jobs',
        route: '/ai-jobs',
        svgIconPath: 'assets/img/nav-icon-ai-jobs.svg',
      ),
      NavigationItem(
        label: 'Integrations',
        route: '/integrations',
        svgIconPath: 'assets/img/nav-icon-integrations.svg',
      ),
      NavigationItem(
        label: 'MCP',
        route: '/mcp',
        svgIconPath: 'assets/img/nav-icon-mcp.svg',
      ),
    ];

    testWidgets('NavigationSidebar - Dark Theme - Desktop - Chat Selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 130,
            height: 500,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/chat',
              isTestMode: true,
              testDarkMode: true,
            ),
          ),
          darkMode: true,
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_dark_desktop_chat_selected.png'),
      );
    });

    testWidgets('NavigationSidebar - Dark Theme - Desktop - AI Jobs Selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 130,
            height: 500,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/ai-jobs',
              isTestMode: true,
              testDarkMode: true,
            ),
          ),
          darkMode: true,
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_dark_desktop_ai_jobs_selected.png'),
      );
    });

    testWidgets('NavigationSidebar - Dark Theme - Integrations Selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 130,
            height: 500,
            child: NavigationSidebar(
              items: testItems,
              currentRoute: '/integrations',
              isTestMode: true,
              testDarkMode: true,
            ),
          ),
          darkMode: true,
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/navigation_sidebar_dark_desktop_integrations_selected.png'),
      );
    });
  });
}
