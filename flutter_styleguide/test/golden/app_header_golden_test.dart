import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:dmtools_styleguide/widgets/molecules/headers/app_header.dart';
import 'package:dmtools_styleguide/widgets/molecules/user_profile_button.dart';
import '../golden_test_helper.dart';

void main() {
  group('AppHeader Golden Tests', () {
    testGoldens('AppHeader with search and title', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'app_header_with_title',
        widget: AppHeader(
          searchHintText: 'Search agents and apps...',
          searchWidth: 400,
          onSearch: (_) {},
          onProfilePressed: () {},
          onLogoPressed: () {},
          onThemeToggle: () {},
          isTestMode: true,
          profileButton: const UserProfileButton(
            userName: 'Test User',
            isTestMode: true,
          ),
        ),
        width: 800,
        height: 80,
      );
    });

    testGoldens('AppHeader with search without title', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'app_header_without_title',
        widget: AppHeader(
          searchHintText: 'Search agents and apps...',
          searchWidth: 400,
          showTitle: false,
          onSearch: (_) {},
          onProfilePressed: () {},
          onLogoPressed: () {},
          onThemeToggle: () {},
          isTestMode: true,
          profileButton: const UserProfileButton(
            userName: 'Test User',
            isTestMode: true,
          ),
        ),
        width: 800,
        height: 80,
      );
    });

    testGoldens('AppHeader without search', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'app_header_no_search',
        widget: AppHeader(
          showSearch: false,
          onProfilePressed: () {},
          onLogoPressed: () {},
          onThemeToggle: () {},
          isTestMode: true,
          profileButton: const UserProfileButton(
            userName: 'Test User',
            isTestMode: true,
          ),
        ),
        width: 800,
        height: 80,
      );
    });

    testGoldens('AppHeader with hamburger menu', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'app_header_hamburger_menu',
        widget: AppHeader(
          showSearch: false,
          showTitle: false,
          showHamburgerMenu: true,
          onHamburgerPressed: () {},
          onThemeToggle: () {},
          isTestMode: true,
          profileButton: const UserProfileButton(
            userName: 'Test User',
            isTestMode: true,
          ),
        ),
        width: 400,
        height: 80,
      );
    });
  });
}
