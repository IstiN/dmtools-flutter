import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/app_buttons.dart';
import 'package:dmtools_styleguide/widgets/atoms/form_elements.dart';
import 'package:dmtools_styleguide/widgets/atoms/status_dot.dart';
import 'package:dmtools_styleguide/widgets/atoms/tag_chip.dart';
import 'package:dmtools_styleguide/widgets/atoms/texts/app_text.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  setUpAll(() async {
    await helper.loadAppFonts();
  });

  group('Atoms Golden Tests', () {
    testGoldens('All Buttons - Light Mode', (tester) async {
      const devices = [Device.phone];
      final wrapper = materialAppWrapper(
        theme: ThemeData.light(),
      );

      await tester.pumpWidgetBuilder(
        _buildAllButtons(),
        wrapper: wrapper,
        surfaceSize: const Size(400, 600),
      );

      await multiScreenGolden(
        tester,
        'all_buttons_light',
        devices: devices,
      );
    });

    testGoldens('All Buttons - Dark Mode', (tester) async {
      const devices = [Device.phone];
      final wrapper = materialAppWrapper(
        theme: ThemeData.dark(),
      );

      await tester.pumpWidgetBuilder(
        _buildAllButtons(),
        wrapper: wrapper,
        surfaceSize: const Size(400, 600),
      );

      await multiScreenGolden(
        tester,
        'all_buttons_dark',
        devices: devices,
      );
    });

    testGoldens('All Form Elements - Light Mode', (tester) async {
      const devices = [Device.phone];
      final wrapper = materialAppWrapper(
        theme: ThemeData.light(),
      );

      await tester.pumpWidgetBuilder(
        _buildAllFormElements(),
        wrapper: wrapper,
        surfaceSize: const Size(400, 600),
      );

      await multiScreenGolden(
        tester,
        'all_form_elements_light',
        devices: devices,
      );
    });

    testGoldens('All Form Elements - Dark Mode', (tester) async {
      const devices = [Device.phone];
      final wrapper = materialAppWrapper(
        theme: ThemeData.dark(),
      );

      await tester.pumpWidgetBuilder(
        _buildAllFormElements(),
        wrapper: wrapper,
        surfaceSize: const Size(400, 600),
      );

      await multiScreenGolden(
        tester,
        'all_form_elements_dark',
        devices: devices,
      );
    });

    testGoldens('All Text Elements - Light Mode', (tester) async {
      const devices = [Device.phone];
      final wrapper = materialAppWrapper(
        theme: ThemeData.light(),
      );

      await tester.pumpWidgetBuilder(
        _buildAllTextElements(),
        wrapper: wrapper,
        surfaceSize: const Size(400, 600),
      );

      await multiScreenGolden(
        tester,
        'all_text_elements_light',
        devices: devices,
      );
    });

    testGoldens('All Text Elements - Dark Mode', (tester) async {
      const devices = [Device.phone];
      final wrapper = materialAppWrapper(
        theme: ThemeData.dark(),
      );

      await tester.pumpWidgetBuilder(
        _buildAllTextElements(),
        wrapper: wrapper,
        surfaceSize: const Size(400, 600),
      );

      await multiScreenGolden(
        tester,
        'all_text_elements_dark',
        devices: devices,
      );
    });

    testGoldens('All Tags & Status - Light Mode', (tester) async {
      const devices = [Device.phone];
      final wrapper = materialAppWrapper(
        theme: ThemeData.light(),
      );

      await tester.pumpWidgetBuilder(
        _buildAllTagsAndStatus(),
        wrapper: wrapper,
        surfaceSize: const Size(400, 600),
      );

      await multiScreenGolden(
        tester,
        'all_tags_status_light',
        devices: devices,
      );
    });

    testGoldens('All Tags & Status - Dark Mode', (tester) async {
      const devices = [Device.phone];
      final wrapper = materialAppWrapper(
        theme: ThemeData.dark(),
      );

      await tester.pumpWidgetBuilder(
        _buildAllTagsAndStatus(),
        wrapper: wrapper,
        surfaceSize: const Size(400, 600),
      );

      await multiScreenGolden(
        tester,
        'all_tags_status_dark',
        devices: devices,
      );
    });
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
            size: ButtonSize.medium,
          ),
          const SizedBox(height: 8),
          const PrimaryButton(
            text: 'Primary Large',
            size: ButtonSize.large,
          ),
          const SizedBox(height: 8),
          PrimaryButton(
            text: 'Primary with Icon',
            size: ButtonSize.medium,
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
            size: ButtonSize.medium,
          ),
          const SizedBox(height: 8),
          const SecondaryButton(
            text: 'Secondary Large',
            size: ButtonSize.large,
          ),
          const SizedBox(height: 8),
          SecondaryButton(
            text: 'Secondary with Icon',
            size: ButtonSize.medium,
            icon: Icons.info,
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          
          // Other button types
          const OutlineButton(text: 'Outline'),
          const SizedBox(height: 8),
          const AppTextButton(text: 'Text Button'),
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
  return Scaffold(
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LargeDisplayText('Display Text'),
          const SizedBox(height: 8),
          LargeHeadlineText('Headline Text'),
          const SizedBox(height: 8),
          LargeTitleText('Title Text'),
          const SizedBox(height: 8),
          LargeBodyText('Body Text'),
          const SizedBox(height: 8),
          LargeLabelText('Label Text'),
          const SizedBox(height: 8),
          const CodeText('Special Text'),
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
          TagChip(label: 'Primary', variant: TagChipVariant.primary),
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