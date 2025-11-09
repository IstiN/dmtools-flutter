import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  setUpAll(() async {
    await helper.GoldenTestHelper.loadAppFonts();
  });

  group('TabbedHeader Golden Tests', () {
    goldenTest(
      'TabbedHeader - Light Theme',
      fileName: 'tabbed_header_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'basic_tabs',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildBasicTabbedHeader(false),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with_icons',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildTabbedHeaderWithIcons(false),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'many_tabs',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildManyTabsHeader(false),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'no_add_button',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildNoAddButtonHeader(false),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with_actions',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildHeaderWithActions(false),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'TabbedHeader - Dark Theme',
      fileName: 'tabbed_header_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'basic_tabs_dark',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildBasicTabbedHeader(true),
                darkMode: true,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with_icons_dark',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildTabbedHeaderWithIcons(true),
                darkMode: true,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'many_tabs_dark',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildManyTabsHeader(true),
                darkMode: true,
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with_actions_dark',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                _buildHeaderWithActions(true),
                darkMode: true,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'TabbedHeader - Mobile Layout',
      fileName: 'tabbed_header_mobile',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'mobile_basic',
            child: SizedBox(
              width: 400,
              height: 100,
              child: helper.createTestApp(
                _buildBasicTabbedHeader(false),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'mobile_many_tabs',
            child: SizedBox(
              width: 400,
              height: 100,
              child: helper.createTestApp(
                _buildManyTabsHeader(false),
              ),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildBasicTabbedHeader(bool darkMode) {
  return Scaffold(
    body: TabbedHeader(
      tabs: const [
        HeaderTab(id: '1', title: 'Dashboard'),
        HeaderTab(id: '2', title: 'Projects'),
        HeaderTab(id: '3', title: 'Settings', closeable: false),
      ],
      selectedTabId: '1',
      onTabSelected: (_) {},
      onAddTab: () {},
      onCloseTab: (_) {},
      isTestMode: true,
      testDarkMode: darkMode,
    ),
  );
}

Widget _buildTabbedHeaderWithIcons(bool darkMode) {
  return Scaffold(
    body: TabbedHeader(
      tabs: const [
        HeaderTab(id: '1', title: 'Dashboard', icon: Icons.dashboard),
        HeaderTab(id: '2', title: 'Projects', icon: Icons.folder),
        HeaderTab(id: '3', title: 'Analytics', icon: Icons.bar_chart),
        HeaderTab(id: '4', title: 'Settings', icon: Icons.settings, closeable: false),
      ],
      selectedTabId: '2',
      onTabSelected: (_) {},
      onAddTab: () {},
      onCloseTab: (_) {},
      isTestMode: true,
      testDarkMode: darkMode,
    ),
  );
}

Widget _buildManyTabsHeader(bool darkMode) {
  return Scaffold(
    body: TabbedHeader(
      tabs: const [
        HeaderTab(id: '1', title: 'Tab 1', icon: Icons.star),
        HeaderTab(id: '2', title: 'Tab 2', icon: Icons.favorite),
        HeaderTab(id: '3', title: 'Tab 3', icon: Icons.home),
        HeaderTab(id: '4', title: 'Tab 4', icon: Icons.work),
        HeaderTab(id: '5', title: 'Tab 5', icon: Icons.calendar_today),
        HeaderTab(id: '6', title: 'Tab 6', icon: Icons.email),
        HeaderTab(id: '7', title: 'Tab 7', icon: Icons.notifications),
      ],
      selectedTabId: '4',
      onTabSelected: (_) {},
      onAddTab: () {},
      onCloseTab: (_) {},
      isTestMode: true,
      testDarkMode: darkMode,
    ),
  );
}

Widget _buildNoAddButtonHeader(bool darkMode) {
  return Scaffold(
    body: TabbedHeader(
      tabs: const [
        HeaderTab(id: '1', title: 'Tab 1'),
        HeaderTab(id: '2', title: 'Tab 2'),
        HeaderTab(id: '3', title: 'Tab 3'),
      ],
      selectedTabId: '1',
      showAddButton: false,
      onTabSelected: (_) {},
      onCloseTab: (_) {},
      isTestMode: true,
      testDarkMode: darkMode,
    ),
  );
}

Widget _buildHeaderWithActions(bool darkMode) {
  return Scaffold(
    body: TabbedHeader(
      tabs: const [
        HeaderTab(id: '1', title: 'Dashboard', icon: Icons.dashboard),
        HeaderTab(id: '2', title: 'Projects', icon: Icons.folder),
        HeaderTab(id: '3', title: 'Settings', icon: Icons.settings, closeable: false),
      ],
      selectedTabId: '1',
      onTabSelected: (_) {},
      onAddTab: () {},
      onCloseTab: (_) {},
      leading: IconButton(
        icon: const Icon(Icons.history, size: 20),
        onPressed: () {},
        tooltip: 'Recent',
      ),
      actions: const [
        IconButton(
          icon: Icon(Icons.more_vert, size: 20),
          onPressed: null,
          tooltip: 'More options',
        ),
      ],
      isTestMode: true,
      testDarkMode: darkMode,
    ),
  );
}

