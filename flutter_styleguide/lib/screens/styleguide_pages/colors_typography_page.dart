import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/color_swatch.dart';
import '../../widgets/atoms/texts/app_text.dart';

class ColorsTypographyPage extends StatelessWidget {
  const ColorsTypographyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final ThemeColorSet colors = isDarkMode ? AppColors.dark : AppColors.light;
    
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppDimensions.cardPaddingL,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MediumHeadlineText('Color Palette (from CSS Variables)'),
                const SizedBox(height: AppDimensions.spacingL),
                
                // Base Colors
                const LargeTitleText('Base Colors'),
                const SizedBox(height: AppDimensions.spacingM),
                Wrap(
                  spacing: AppDimensions.spacingM,
                  runSpacing: AppDimensions.spacingM,
                  children: [
                    ColorSwatchItem(
                      name: '--bg-color',
                      color: colors.bgColor,
                      hexCode: isDarkMode ? '#2D2E30' : '#F8F9FA',
                    ),
                    ColorSwatchItem(
                      name: '--card-bg',
                      color: colors.cardBg,
                      hexCode: isDarkMode ? '#1E1F21' : '#FFFFFF',
                    ),
                    ColorSwatchItem(
                      name: '--text-color',
                      color: colors.textColor,
                      hexCode: isDarkMode ? '#FFFFFF' : '#212529',
                    ),
                    ColorSwatchItem(
                      name: '--text-secondary',
                      color: colors.textSecondary,
                      hexCode: isDarkMode ? '#E9ECEF' : '#343A40',
                    ),
                    ColorSwatchItem(
                      name: '--text-muted',
                      color: colors.textMuted,
                      hexCode: isDarkMode ? '#ADB5BD' : '#6C757D',
                    ),
                    ColorSwatchItem(
                      name: '--border-color',
                      color: colors.borderColor,
                      hexCode: isDarkMode ? '#495057' : '#DFE1E5',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingXl),
                
                // Accent Colors
                const LargeTitleText('Accent Colors'),
                const SizedBox(height: AppDimensions.spacingM),
                Wrap(
                  spacing: AppDimensions.spacingM,
                  runSpacing: AppDimensions.spacingM,
                  children: [
                    ColorSwatchItem(
                      name: '--accent-color',
                      color: colors.accentColor,
                      hexCode: '#6078F0',
                    ),
                    ColorSwatchItem(
                      name: '--accent-light',
                      color: colors.accentLight,
                      hexCode: '#E8EBFD',
                    ),
                    ColorSwatchItem(
                      name: '--accent-hover',
                      color: colors.accentHover,
                      hexCode: '#4A61C0',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingXl),
                
                // Button & Interaction Colors
                const LargeTitleText('Button & Interaction Colors'),
                const SizedBox(height: AppDimensions.spacingM),
                Wrap(
                  spacing: AppDimensions.spacingM,
                  runSpacing: AppDimensions.spacingM,
                  children: [
                    ColorSwatchItem(
                      name: '--button-bg',
                      color: colors.buttonBg,
                      hexCode: '#6078F0',
                    ),
                    ColorSwatchItem(
                      name: '--button-hover',
                      color: colors.buttonHover,
                      hexCode: '#4A61C0',
                    ),
                    ColorSwatchItem(
                      name: '--hover-bg',
                      color: colors.hoverBg,
                      hexCode: isDarkMode ? '#495057' : '#F8F9FA',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingXl),
                
                // Feedback Colors
                const LargeTitleText('Feedback Colors'),
                const SizedBox(height: AppDimensions.spacingM),
                Wrap(
                  spacing: AppDimensions.spacingM,
                  runSpacing: AppDimensions.spacingM,
                  children: [
                    ColorSwatchItem(
                      name: '--success-color',
                      color: colors.successColor,
                      hexCode: '#28A745',
                    ),
                    ColorSwatchItem(
                      name: '--warning-color',
                      color: colors.warningColor,
                      hexCode: '#FFC107',
                    ),
                    ColorSwatchItem(
                      name: '--danger-color',
                      color: colors.dangerColor,
                      hexCode: '#DC3545',
                    ),
                    ColorSwatchItem(
                      name: '--info-color',
                      color: colors.infoColor,
                      hexCode: '#17A2B8',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingXl),
                
                // Input Colors
                const LargeTitleText('Input Colors'),
                const SizedBox(height: AppDimensions.spacingM),
                Wrap(
                  spacing: AppDimensions.spacingM,
                  runSpacing: AppDimensions.spacingM,
                  children: [
                    ColorSwatchItem(
                      name: '--input-bg',
                      color: colors.inputBg,
                      hexCode: isDarkMode ? '#343A40' : '#FFFFFF',
                    ),
                    ColorSwatchItem(
                      name: '--input-focus-border',
                      color: colors.inputFocusBorder,
                      hexCode: '#6078F0',
                    ),
                  ],
                ),
                
                const SizedBox(height: AppDimensions.spacingXxl),
                
                // Typography Section
                const MediumHeadlineText('Typography'),
                const SizedBox(height: AppDimensions.spacingM),
                const MediumBodyText('Base font family: "Inter", "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif'),
                const SizedBox(height: AppDimensions.spacingXl),
                
                // Heading Examples
                Card(
                  color: colors.cardBg,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    side: BorderSide(color: colors.borderColor),
                  ),
                  child: Padding(
                    padding: AppDimensions.cardPaddingL,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LargeDisplayText('Heading 1'),
                        const SizedBox(height: AppDimensions.spacingM),
                        const MediumDisplayText('Heading 2'),
                        const SizedBox(height: AppDimensions.spacingM),
                        Divider(color: colors.borderColor),
                        const SizedBox(height: AppDimensions.spacingM),
                        const SmallDisplayText('Heading 3'),
                        const SizedBox(height: AppDimensions.spacingXs),
                        const LargeHeadlineText('Heading 4'),
                        const SizedBox(height: AppDimensions.spacingXs),
                        const MediumHeadlineText('Heading 5'),
                        const SizedBox(height: AppDimensions.spacingXs),
                        const SmallHeadlineText('Heading 6'),
                        const SizedBox(height: AppDimensions.spacingM),
                        Divider(color: colors.borderColor),
                        const SizedBox(height: AppDimensions.spacingM),
                        const LargeBodyText('This is a standard paragraph. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. It uses '),
                        ItalicText('var(--text-color)', baseStyle: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: AppDimensions.spacingXs),
                        const MediumBodyText('This is small text, often used for less important details or '),
                        MediumBodyText('var(--text-muted)', color: colors.textMuted, style: TextStyle(fontStyle: FontStyle.italic)),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Wrap(
                          children: [
                            const LargeBodyText('This is a hyperlink, typically using '),
                            LargeBodyText('var(--accent-color)', 
                              color: colors.accentColor,
                              style: TextStyle(decoration: TextDecoration.underline),
                            ),
                            const LargeBodyText('.'),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Wrap(
                          children: [
                            const BoldText('This is bold text. '),
                            const ItalicText('This is italic text.'),
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Container(
                          padding: AppDimensions.cardPaddingS,
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF343A40) : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                          ),
                          child: const CodeText('This is inline code.'),
                        ),
                        const SizedBox(height: AppDimensions.spacingXs),
                        Container(
                          width: double.infinity,
                          padding: AppDimensions.cardPaddingM,
                          decoration: BoxDecoration(
                            color: isDarkMode ? const Color(0xFF343A40) : const Color(0xFFF8F9FA),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                            border: Border.all(color: colors.borderColor),
                          ),
                          child: ItalicText(
                            'This is a blockquote. It can be used to highlight a section of text. Often styled with a border or a different background.',
                            baseStyle: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Removed unused _ColorInfo class 