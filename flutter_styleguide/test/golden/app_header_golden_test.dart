import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/molecules/headers/app_header.dart';
import 'package:dmtools_styleguide/widgets/molecules/user_profile_button.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('App Header Golden Tests', () {
    goldenTest(
      'App Header - Light Mode',
      fileName: 'app_header_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'app_header_light',
            child: SizedBox(
              width: 1000,
              height: 150,
              child: helper.createTestApp(_buildAppHeader()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'App Header - Dark Mode',
      fileName: 'app_header_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'app_header_dark',
            child: SizedBox(
              width: 1000,
              height: 150,
              child: helper.createTestApp(_buildAppHeader(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'App Header with Title - Light Mode',
      fileName: 'app_header_with_title_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'app_header_with_title_light',
            child: SizedBox(
              width: 1000,
              height: 150,
              child: helper.createTestApp(_buildAppHeaderWithTitle()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'App Header with Title - Dark Mode',
      fileName: 'app_header_with_title_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'app_header_with_title_dark',
            child: SizedBox(
              width: 1000,
              height: 150,
              child: helper.createTestApp(_buildAppHeaderWithTitle(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'App Header without Search - Light Mode',
      fileName: 'app_header_no_search_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'app_header_no_search_light',
            child: SizedBox(
              width: 1000,
              height: 150,
              child: helper.createTestApp(_buildAppHeaderNoSearch()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'App Header without Search - Dark Mode',
      fileName: 'app_header_no_search_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'app_header_no_search_dark',
            child: SizedBox(
              width: 1000,
              height: 150,
              child: helper.createTestApp(_buildAppHeaderNoSearch(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildAppHeader() {
  return Scaffold(
    body: AppHeader(
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
  );
}

Widget _buildAppHeaderWithTitle() {
  return Scaffold(
    body: AppHeader(
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
  );
}

Widget _buildAppHeaderNoSearch() {
  return Scaffold(
    body: AppHeader(
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
  );
}
