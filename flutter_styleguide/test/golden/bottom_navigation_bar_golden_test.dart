import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../golden_test_helper.dart';

void main() {
  group('BottomNavigationBarWidget Golden Tests', () {
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

    testWidgets('BottomNavigationBar - Dark Theme - Chat Selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 400,
            height: 100,
            child: BottomNavigationBarWidget(
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
        matchesGoldenFile('goldens/bottom_navigation_bar_dark_chat_selected.png'),
      );
    });

    testWidgets('BottomNavigationBar - Dark Theme - AI Jobs Selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 400,
            height: 100,
            child: BottomNavigationBarWidget(
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
        matchesGoldenFile('goldens/bottom_navigation_bar_dark_ai_jobs_selected.png'),
      );
    });

    testWidgets('BottomNavigationBar - Dark Theme - Integrations Selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestApp(
          const SizedBox(
            width: 400,
            height: 100,
            child: BottomNavigationBarWidget(
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
        matchesGoldenFile('goldens/bottom_navigation_bar_dark_integrations_selected.png'),
      );
    });
  });
}

