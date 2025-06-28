import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alchemist/alchemist.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/app_buttons.dart';
import 'package:dmtools_styleguide/widgets/atoms/form_elements.dart';
import 'package:dmtools_styleguide/widgets/atoms/texts/app_text.dart';
import 'package:dmtools_styleguide/widgets/molecules/cards/feature_card.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import '../golden_test_helper.dart' as helper;

void main() {
  group('Theme Components Golden Tests', () {
    goldenTest(
      'Theme Showcase - Light Mode',
      fileName: 'theme_showcase_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'theme_showcase_light',
            child: SizedBox(
              width: 500,
              height: 800,
              child: helper.createTestApp(_buildThemeShowcase()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Theme Showcase - Dark Mode',
      fileName: 'theme_showcase_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'theme_showcase_dark',
            child: SizedBox(
              width: 500,
              height: 800,
              child: helper.createTestApp(_buildThemeShowcase(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Button Variations - Light Mode',
      fileName: 'button_variations_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'button_variations_light',
            child: SizedBox(
              width: 600,
              height: 400,
              child: helper.createTestApp(_buildButtonVariations()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Button Variations - Dark Mode',
      fileName: 'button_variations_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'button_variations_dark',
            child: SizedBox(
              width: 600,
              height: 400,
              child: helper.createTestApp(_buildButtonVariations(), darkMode: true),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Typography Showcase - Light Mode',
      fileName: 'typography_showcase_light',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'typography_showcase_light',
            child: SizedBox(
              width: 500,
              height: 600,
              child: helper.createTestApp(_buildTypographyShowcase()),
            ),
          ),
        ],
      ),
    );

    goldenTest(
      'Typography Showcase - Dark Mode',
      fileName: 'typography_showcase_dark',
      builder: () => GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'typography_showcase_dark',
            child: SizedBox(
              width: 500,
              height: 600,
              child: helper.createTestApp(_buildTypographyShowcase(), darkMode: true),
            ),
          ),
        ],
      ),
    );
  });
}

Widget _buildThemeShowcase() {
  return const Scaffold(
    body: SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buttons section
          Row(
            children: [
              PrimaryButton(text: 'Primary'),
              SizedBox(width: 8),
              SecondaryButton(text: 'Secondary'),
              SizedBox(width: 8),
              OutlineButton(text: 'Outline'),
            ],
          ),
          SizedBox(height: 16),

          // Text elements
          LargeDisplayText('Display Text Large'),
          SizedBox(height: 8),
          LargeHeadlineText('Headline Text Large'),
          SizedBox(height: 8),
          LargeTitleText('Title Text Large'),
          SizedBox(height: 8),
          LargeBodyText('Body Text Large'),
          SizedBox(height: 8),
          LargeLabelText('Label Text Large'),
          SizedBox(height: 16),

          // Form elements
          TextInput(
            placeholder: 'Enter text here',
          ),
          SizedBox(height: 16),

          // Cards
          FeatureCard(
            title: 'Feature Card',
            description: 'This is a sample feature card demonstrating the theme.',
            icon: Icons.star,
          ),
        ],
      ),
    ),
  );
}

Widget _buildButtonVariations() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Primary buttons in different sizes
          Text('Primary Buttons'),
          SizedBox(height: 8),
          Row(
            children: [
              PrimaryButton(text: 'Small', size: ButtonSize.small),
              SizedBox(width: 8),
              PrimaryButton(text: 'Medium'),
              SizedBox(width: 8),
              PrimaryButton(text: 'Large', size: ButtonSize.large),
            ],
          ),
          SizedBox(height: 16),

          // Secondary buttons
          Text('Secondary Buttons'),
          SizedBox(height: 8),
          Row(
            children: [
              SecondaryButton(text: 'Small', size: ButtonSize.small),
              SizedBox(width: 8),
              SecondaryButton(text: 'Medium'),
              SizedBox(width: 8),
              SecondaryButton(text: 'Large', size: ButtonSize.large),
            ],
          ),
          SizedBox(height: 16),

          // Outline buttons
          Text('Outline Buttons'),
          SizedBox(height: 8),
          Row(
            children: [
              OutlineButton(text: 'Small', size: ButtonSize.small),
              SizedBox(width: 8),
              OutlineButton(text: 'Medium'),
              SizedBox(width: 8),
              OutlineButton(text: 'Large', size: ButtonSize.large),
            ],
          ),
          SizedBox(height: 16),

          // Text buttons
          Text('Text Buttons'),
          SizedBox(height: 8),
          Row(
            children: [
              AppTextButton(text: 'Small', size: ButtonSize.small, isTestMode: true),
              SizedBox(width: 8),
              AppTextButton(text: 'Medium', isTestMode: true),
              SizedBox(width: 8),
              AppTextButton(text: 'Large', size: ButtonSize.large, isTestMode: true),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildTypographyShowcase() {
  return const Scaffold(
    body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display texts
          LargeDisplayText('Display Large'),
          SizedBox(height: 4),
          MediumDisplayText('Display Medium'),
          SizedBox(height: 4),
          SmallDisplayText('Display Small'),
          SizedBox(height: 16),

          // Headline texts
          LargeHeadlineText('Headline Large'),
          SizedBox(height: 4),
          MediumHeadlineText('Headline Medium'),
          SizedBox(height: 4),
          SmallHeadlineText('Headline Small'),
          SizedBox(height: 16),

          // Title texts
          LargeTitleText('Title Large'),
          SizedBox(height: 4),
          MediumTitleText('Title Medium'),
          SizedBox(height: 4),
          SmallTitleText('Title Small'),
          SizedBox(height: 16),

          // Body texts
          LargeBodyText('Body Large'),
          SizedBox(height: 4),
          MediumBodyText('Body Medium'),
          SizedBox(height: 4),
          SmallBodyText('Body Small'),
          SizedBox(height: 16),

          // Label texts
          LargeLabelText('Label Large'),
          SizedBox(height: 4),
          MediumLabelText('Label Medium'),
          SizedBox(height: 4),
          SmallLabelText('Label Small'),
        ],
      ),
    ),
  );
}
