import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  setUpAll(() async {
    await helper.GoldenTestHelper.loadAppFonts();
  });

  group('PageActionBar Golden Tests', () {
    goldenTest(
      'PageActionBar - Light Theme',
      fileName: 'page_action_bar_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'title_only',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                const PageActionBar(
                  title: 'Page Title',
                  isTestMode: true,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'with_actions',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                PageActionBar(
                  title: 'Page Title',
                  actions: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Primary'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Secondary'),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                  ],
                  isTestMode: true,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'loading_state',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                PageActionBar(
                  title: 'Page Title',
                  isLoading: true,
                  actions: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Action'),
                    ),
                  ],
                  isTestMode: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'PageActionBar - Dark Theme',
      fileName: 'page_action_bar_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'title_only_dark',
            child: SizedBox(
              width: 800,
              height: 100,
              child: helper.createTestApp(
                const PageActionBar(
                  title: 'Page Title',
                  isTestMode: true,
                  testDarkMode: true,
                ),
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
                PageActionBar(
                  title: 'Page Title',
                  actions: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Primary'),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Secondary'),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                    ),
                  ],
                  isTestMode: true,
                  testDarkMode: true,
                ),
                darkMode: true,
              ),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'PageActionBar - Mobile Layout',
      fileName: 'page_action_bar_mobile',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'mobile_inline',
            child: SizedBox(
              width: 400,
              height: 120,
              child: helper.createTestApp(
                PageActionBar(
                  title: 'Mobile Page',
                  actions: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Action'),
                    ),
                  ],
                  isTestMode: true,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'mobile_overflow',
            child: SizedBox(
              width: 350,
              height: 120,
              child: helper.createTestApp(
                PageActionBar(
                  title: 'Page with Many Actions',
                  actions: [
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Act 1'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Act 2'),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Act 3'),
                    ),
                  ],
                  isTestMode: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  });
}
