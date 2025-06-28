import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/app_buttons.dart';
import 'package:dmtools_styleguide/widgets/atoms/form_elements.dart';
import 'package:dmtools_styleguide/widgets/atoms/status_dot.dart';
import 'package:dmtools_styleguide/widgets/atoms/tag_chip.dart';
import 'package:dmtools_styleguide/widgets/atoms/texts/app_text.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  setUpAll(() async {
    await helper.GoldenTestHelper.loadAppFonts();
  });

  group('Atoms Golden Tests', () {
    goldenTest(
      'All Buttons - Light Mode',
      fileName: 'all_buttons_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'all_buttons_light',
            child: SizedBox(
              width: 600,
              height: 500,
              child: helper.createTestApp(_buildAllButtons()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'All Buttons - Dark Mode',
      fileName: 'all_buttons_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'all_buttons_dark',
            child: SizedBox(
              width: 600,
              height: 500,
              child: helper.createTestApp(_buildAllButtons(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'All Form Elements - Light Mode',
      fileName: 'all_form_elements_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'all_form_elements_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildAllFormElements()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'All Form Elements - Dark Mode',
      fileName: 'all_form_elements_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'all_form_elements_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildAllFormElements(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'All Text Elements - Light Mode',
      fileName: 'all_text_elements_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'all_text_elements_light',
            child: SizedBox(
              width: 500,
              height: 600,
              child: helper.createTestApp(_buildAllTextElements()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'All Text Elements - Dark Mode',
      fileName: 'all_text_elements_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'all_text_elements_dark',
            child: SizedBox(
              width: 500,
              height: 600,
              child: helper.createTestApp(_buildAllTextElements(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'All Tags & Status - Light Mode',
      fileName: 'all_tags_status_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'all_tags_status_light',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildAllTagsAndStatus()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'All Tags & Status - Dark Mode',
      fileName: 'all_tags_status_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'all_tags_status_dark',
            child: SizedBox(
              width: 500,
              height: 400,
              child: helper.createTestApp(_buildAllTagsAndStatus(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildAllButtons() {
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary Buttons
          const PrimaryButton(text: 'Primary'),
          const SizedBox(height: 8),
          const PrimaryButton(
            text: 'Primary Small',
            size: ButtonSize.small,
          ),
          const SizedBox(height: 8),
          const PrimaryButton(
            text: 'Primary Medium',
          ),
          const SizedBox(height: 8),
          const PrimaryButton(
            text: 'Primary Large',
            size: ButtonSize.large,
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Primary with Icon',
            icon: Icons.star,
            onPressed: () {},
          ),
          const SizedBox(height: 16),

          // Secondary Buttons
          const SecondaryButton(text: 'Secondary'),
          const SizedBox(height: 8),
          const SecondaryButton(
            text: 'Secondary Small',
            size: ButtonSize.small,
          ),
          const SizedBox(height: 8),
          const SecondaryButton(
            text: 'Secondary Medium',
          ),
          const SizedBox(height: 8),
          const SecondaryButton(
            text: 'Secondary Large',
            size: ButtonSize.large,
          ),
          const SizedBox(height: 8),
          SecondaryButton(
            text: 'Secondary with Icon',
            icon: Icons.info,
            onPressed: () {},
          ),
          const SizedBox(height: 16),

          // Other button types
          const OutlineButton(text: 'Outline'),
          const SizedBox(height: 8),
          const AppTextButton(text: 'Text Button', isTestMode: true),
          const SizedBox(height: 8),
          const RunButton(text: 'Run', icon: Icons.play_arrow),
        ],
      ),
    ),
  );
}

Widget _buildAllFormElements() {
  return const Scaffold(
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FormElementsWidget(),
        ],
      ),
    ),
  );
}

Widget _buildAllTextElements() {
  return const Scaffold(
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LargeDisplayText('Display Text'),
          SizedBox(height: 8),
          LargeHeadlineText('Headline Text'),
          SizedBox(height: 8),
          LargeTitleText('Title Text'),
          SizedBox(height: 8),
          LargeBodyText('Body Text'),
          SizedBox(height: 8),
          LargeLabelText('Label Text'),
          SizedBox(height: 8),
          CodeText('Special Text'),
        ],
      ),
    ),
  );
}

Widget _buildAllTagsAndStatus() {
  return const Scaffold(
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusDot(status: StatusType.online, showLabel: true),
          SizedBox(height: 8),
          StatusDot(status: StatusType.offline, showLabel: true),
          SizedBox(height: 8),
          StatusDot(status: StatusType.warning, showLabel: true),
          SizedBox(height: 8),
          StatusDot(status: StatusType.error, showLabel: true),
          SizedBox(height: 16),
          TagChip(label: 'Default'),
          SizedBox(height: 8),
          TagChip(label: 'Primary'),
          SizedBox(height: 8),
          TagChip(label: 'Success', variant: TagChipVariant.success),
          SizedBox(height: 8),
          TagChip(label: 'Warning', variant: TagChipVariant.warning),
          SizedBox(height: 8),
          TagChip(label: 'Danger', variant: TagChipVariant.danger),
        ],
      ),
    ),
  );
}
