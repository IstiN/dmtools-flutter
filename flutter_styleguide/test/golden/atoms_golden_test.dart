import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/app_buttons.dart';
import 'package:dmtools_styleguide/widgets/atoms/status_dot.dart';
import 'package:dmtools_styleguide/widgets/atoms/tag_chip.dart';
import 'package:dmtools_styleguide/widgets/atoms/form_elements.dart';
import 'package:dmtools_styleguide/widgets/atoms/view_all_link.dart';
import '../golden_test_helper.dart';

void main() {
  group('Atoms Golden Tests - Individual Components', () {
    testGoldens('PrimaryButton', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'app_button_primary',
        widget: PrimaryButton(
          text: 'Primary Button',
          onPressed: () {},
          isTestMode: true,
          testDarkMode: false,
        ),
      );
    });

    testGoldens('SecondaryButton', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'app_button_secondary',
        widget: SecondaryButton(
          text: 'Secondary Button',
          onPressed: () {},
          isTestMode: true,
          testDarkMode: false,
        ),
      );
    });

    testGoldens('OutlineButton', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'app_button_outline',
        widget: OutlineButton(
          text: 'Outline Button',
          onPressed: () {},
          isTestMode: true,
          testDarkMode: false,
        ),
      );
    });

    testGoldens('TextButton', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'app_button_text',
        widget: AppTextButton(
          text: 'Text Button',
          onPressed: () {},
          isTestMode: true,
          testDarkMode: false,
        ),
      );
    });

    testGoldens('Status Dot - Online', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'status_dot_online',
        widget: StatusDot(
          status: StatusType.online,
          isTestMode: true,
          testDarkMode: false,
        ),
        width: 100,
        height: 100,
      );
    });

    testGoldens('Status Dot - Warning', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'status_dot_warning',
        widget: StatusDot(
          status: StatusType.warning,
          isTestMode: true,
          testDarkMode: false,
        ),
        width: 100,
        height: 100,
      );
    });

    testGoldens('Status Dot - Error', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'status_dot_error',
        widget: StatusDot(
          status: StatusType.error,
          isTestMode: true,
          testDarkMode: false,
        ),
        width: 100,
        height: 100,
      );
    });

    testGoldens('Tag Chip', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'tag_chip',
        widget: TagChip(
          label: 'Tag Label',
          isTestMode: true,
          testDarkMode: false,
        ),
        width: 150,
        height: 100,
      );
    });

    testGoldens('Form Elements - Text Input', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'form_text_input',
        widget: TextInput(
          controller: TextEditingController(text: 'Input text'),
          placeholder: 'Placeholder text',
          isTestMode: true,
          testDarkMode: false,
        ),
        height: 100,
      );
    });

    testGoldens('Form Elements - Password Input', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'form_password_input',
        widget: PasswordInput(
          controller: TextEditingController(text: 'password'),
          placeholder: 'Enter password',
          isTestMode: true,
          testDarkMode: false,
        ),
        height: 100,
      );
    });

    testGoldens('View All Link', (WidgetTester tester) async {
      await GoldenTestHelper.testWidgetInBothThemes(
        tester: tester,
        name: 'view_all_link',
        widget: ViewAllLink(
          text: 'View all items',
          onTap: () {},
          isTestMode: true,
          testDarkMode: false,
        ),
        width: 150,
        height: 50,
      );
    });

    testGoldens('WhiteOutlineButton renders correctly in light mode', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WhiteOutlineButton(
                text: 'Learn More',
                size: ButtonSize.small,
              ),
              const SizedBox(height: 16),
              const WhiteOutlineButton(
                text: 'Learn More',
                size: ButtonSize.medium,
              ),
              const SizedBox(height: 16),
              const WhiteOutlineButton(
                text: 'Learn More',
                size: ButtonSize.large,
              ),
              const SizedBox(height: 16),
              const WhiteOutlineButton(
                text: 'Learn More',
                icon: Icons.info_outline,
                size: ButtonSize.medium,
              ),
            ],
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.light.accentColor,
            ),
          ),
        ),
        surfaceSize: const Size(300, 400),
      );

      await screenMatchesGolden(tester, 'white_outline_button_light');
    });

    testGoldens('WhiteOutlineButton renders correctly in dark mode', (tester) async {
      await tester.pumpWidgetBuilder(
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const WhiteOutlineButton(
                text: 'Learn More',
                size: ButtonSize.small,
              ),
              const SizedBox(height: 16),
              const WhiteOutlineButton(
                text: 'Learn More',
                size: ButtonSize.medium,
              ),
              const SizedBox(height: 16),
              const WhiteOutlineButton(
                text: 'Learn More',
                size: ButtonSize.large,
              ),
              const SizedBox(height: 16),
              const WhiteOutlineButton(
                text: 'Learn More',
                icon: Icons.info_outline,
                size: ButtonSize.medium,
              ),
            ],
          ),
        ),
        wrapper: materialAppWrapper(
          theme: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.dark.accentColor,
            ),
          ),
          background: Colors.grey[900],
        ),
        surfaceSize: const Size(300, 400),
      );

      await screenMatchesGolden(tester, 'white_outline_button_dark');
    });
  });
} 