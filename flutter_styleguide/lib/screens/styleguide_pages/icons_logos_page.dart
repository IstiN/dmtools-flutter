import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dmtools_styleguide/theme/app_colors.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import 'package:dmtools_styleguide/widgets/styleguide/component_display.dart';
import 'package:dmtools_styleguide/widgets/styleguide/component_item.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';
import 'package:dmtools_styleguide/widgets/atoms/texts/app_text.dart';
import 'package:dmtools_styleguide/widgets/atoms/logos/dna_logo.dart';

class IconsLogosPage extends StatelessWidget {
  const IconsLogosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        const ComponentDisplay(
          title: 'Logo Usage Guidelines',
          child: ComponentItem(
            title: 'When to Use Each Logo Variant',
            child: LogoUsageGuide(),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: '🔍 READABILITY COMPARISON - Larger ai Badge',
          child: Column(
            children: [
              const ComponentItem(
                title: 'V1: Current Version (ai badge 80x50, font-size 32)',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-dm.svg',
                  description: '⚠️ ai badge too small - hard to read at icon sizes',
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'V2: Improved Version (ai badge 110x70, font-size 48)',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-dm-v2.svg',
                  description: '🔸 Larger badge in bottom-right corner',
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'V3: Extra Large Version (ai badge 140x90, font-size 64)',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-dm-v3.svg',
                  description: '🔸 Extra large badge in bottom-right corner',
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'V4: Maximum Size (ai badge 182x142, font-size 80)',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-dm-v4.svg',
                  description: '🔸 Badge fills all available space to bottom and right edges',
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'V5: V3 Base + Larger Text (badge 125x90, font-size 72)',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-dm-v5.svg',
                  description: '🔸 Narrower badge with larger "ai" text for better readability',
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'V6: Maximum Text Size (badge 115x90, font-size 78) - Cyan Badge',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-dm-v6.svg',
                  description: '🔸 Cyan badge (115px) + large text (78px)',
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'V7: BLACK Badge with ".ai" (badge 115x90, font-size 78)',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-dm-v7.svg',
                  description: '✅ Black badge + dot prefix ".ai" - tech domain extension style',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: '⭐ FINAL SELECTED ICONS - Ready for Deployment',
          child: Column(
            children: [
              const ComponentItem(
                title: 'DM.ai Icon V1 (Based on Variant 2 + DM5 pill element)',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-dm.svg',
                  description: 'Dark slate gradient • Pill icon with DNA dots • Cyan ai badge bottom-aligned',
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'AI.n Icon (Based on Variant 5 with closer spacing)',
                child: _FinalIconPreview(
                  assetPath: 'assets/img/dmtools-icon-final-selected-ain.svg',
                  description: 'Purple gradient • Adobe Illustrator style • Tighter spacing between AI and .n',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: '🆕 REFINED: DM + ai Badge Concepts - 5 Final Variants',
          child: _IconVariantsGrid(
            iconPaths: List.generate(5, (i) => 'assets/img/dmtools-icon-final-dm${i + 1}.svg'),
            showLarger: true,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: '🆕 REFINED: AI.n Closer Spacing - 5 Final Variants',
          child: _IconVariantsGrid(
            iconPaths: List.generate(5, (i) => 'assets/img/dmtools-icon-final-ain${i + 1}.svg'),
            showLarger: true,
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Original Concepts',
          child: ComponentItem(
            title: 'Icon (Favicon) - Intelligent Network Fusion',
            child: LogoDisplay(
              lightAsset: 'assets/img/dmtools-icon.svg',
              darkAsset: 'assets/img/dmtools-icon.svg',
              assetName: '../img/dmtools-icon.svg',
              fixedHeight: 48,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'New AI & Themed Concepts',
          child: Column(
            children: [
              const ComponentItem(
                title: 'Logo - DNA Helix (Interwoven)',
                child: DnaLogo(),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logo - DNA Helix (Interwoven - Custom Colors)',
                child: DnaLogo(
                  color1: Colors.cyan.shade400,
                  color2: Colors.amber.shade600,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'Logo - DMTools Connected Dots',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-connected-dots.svg',
                  darkAsset: 'assets/img/dmtools-logo-connected-dots.svg',
                  assetName: '../img/dmtools-logo-connected-dots.svg',
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const ComponentItem(
                title: 'Logo - JAI Circuitry Monogram',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-jai-circuitry-monogram.svg',
                  darkAsset: 'assets/img/dmtools-logo-jai-circuitry-monogram.svg',
                  assetName: '../img/dmtools-logo-jai-circuitry-monogram.svg',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Dark Theme Enhanced Variants',
          child: Column(
            children: [
              ComponentItem(
                title: 'Logo - Connected Dots Dark Enhanced',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-connected-dots-dark-enhanced.svg',
                  darkAsset: 'assets/img/dmtools-logo-connected-dots-dark-enhanced.svg',
                  assetName: '../img/dmtools-logo-connected-dots-dark-enhanced.svg',
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logo - JAI Circuitry Dark Enhanced',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-jai-circuitry-dark-enhanced.svg',
                  darkAsset: 'assets/img/dmtools-logo-jai-circuitry-dark-enhanced.svg',
                  assetName: '../img/dmtools-logo-jai-circuitry-dark-enhanced.svg',
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logo - Hybrid Dark Matrix',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-hybrid-dark-matrix.svg',
                  darkAsset: 'assets/img/dmtools-logo-hybrid-dark-matrix.svg',
                  assetName: '../img/dmtools-logo-hybrid-dark-matrix.svg',
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logo - Connected JAI Dark Fusion',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-connected-jai-dark-fusion.svg',
                  darkAsset: 'assets/img/dmtools-logo-connected-jai-dark-fusion.svg',
                  assetName: '../img/dmtools-logo-connected-jai-dark-fusion.svg',
                  maxWidth: 320,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Merged Concept Variants',
          child: Column(
            children: [
              const ComponentItem(
                title: 'Logo - Intelligent Network Fusion (Theme Adaptive)',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-intelligent-network-fusion.svg',
                  darkAsset: 'assets/img/dmtools-logo-intelligent-network-fusion.svg',
                  assetName: '../img/dmtools-logo-intelligent-network-fusion.svg',
                  maxWidth: 320,
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logo - Intelligent Network Fusion (White Version)',
                child: CustomLogoPreview(
                  assetName: '../img/dmtools-logo-intelligent-network-fusion-white.svg',
                  previews: [
                    Container(
                      color: const Color(0xFF466AF1),
                      padding: const EdgeInsets.all(AppDimensions.spacingL),
                      child: SvgPicture.asset(
                        'assets/img/dmtools-logo-intelligent-network-fusion-white.svg',
                        width: 320,
                      ),
                    ),
                    Container(
                      color: const Color(0xFF2C3E50),
                      padding: const EdgeInsets.all(AppDimensions.spacingL),
                      child: SvgPicture.asset(
                        'assets/img/dmtools-logo-intelligent-network-fusion-white.svg',
                        width: 320,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Logo - Intelligent Network Fusion (Dark Version)',
                child: CustomLogoPreview(
                  assetName: '../img/dmtools-logo-intelligent-network-fusion-dark.svg',
                  previews: [
                    Container(
                      padding: const EdgeInsets.all(AppDimensions.spacingL),
                      decoration: BoxDecoration(color: Colors.white, border: Border.all(color: Colors.grey.shade300)),
                      child: SvgPicture.asset(
                        'assets/img/dmtools-logo-intelligent-network-fusion-dark.svg',
                        width: 320,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Wordmark Variants (New)',
          child: Column(
            children: [
              ComponentItem(
                title: 'Logo - Wordmark Adaptive (currentColor)',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-wordmark-adaptive.svg',
                  darkAsset: 'assets/img/dmtools-logo-wordmark-adaptive.svg',
                  assetName: '../img/dmtools-logo-wordmark-adaptive.svg',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Experimental Wordmark Concepts',
          child: Column(
            children: [
              ComponentItem(
                title: 'Monospaced Tech',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-mono-tech.svg',
                  darkAsset: 'assets/img/dmtools-logo-mono-tech.svg',
                  assetName: '../img/dmtools-logo-mono-tech.svg',
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Minimalist Bold Circle',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-bold-circle.svg',
                  darkAsset: 'assets/img/dmtools-logo-bold-circle.svg',
                  assetName: '../img/dmtools-logo-bold-circle.svg',
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Network Nodes',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-network-nodes.svg',
                  darkAsset: 'assets/img/dmtools-logo-network-nodes-dark.svg',
                  assetName: '../img/dmtools-logo-network-nodes.svg',
                  maxWidth: 240,
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'JAI Emphasis',
                child: LogoDisplay(
                  lightAsset: 'assets/img/dmtools-logo-jai-emphasis.svg',
                  darkAsset: 'assets/img/dmtools-logo-jai-emphasis.svg',
                  assetName: '../img/dmtools-logo-jai-emphasis.svg',
                  maxWidth: 240,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomLogoPreview extends StatelessWidget {
  final String assetName;
  final List<Widget> previews;

  const CustomLogoPreview({
    required this.assetName,
    required this.previews,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final colors = theme.isDarkMode ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.spacingM,
          runSpacing: AppDimensions.spacingM,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: previews,
        ),
        const SizedBox(height: AppDimensions.spacingM),
        SelectableText(
          assetName,
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 13,
            backgroundColor: colors.borderColor.withValues(alpha: 0.5),
            color: colors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class LogoDisplay extends StatelessWidget {
  final String lightAsset;
  final String darkAsset;
  final String assetName;
  final double? fixedHeight;
  final double maxWidth;

  const LogoDisplay({
    required this.lightAsset,
    required this.darkAsset,
    required this.assetName,
    super.key,
    this.fixedHeight,
    this.maxWidth = 220,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final colors = theme.isDarkMode ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.spacingM,
          runSpacing: AppDimensions.spacingM,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Container(
              padding: AppDimensions.cardPaddingM,
              decoration: BoxDecoration(
                border: Border.all(color: colors.borderColor),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
              child: SvgPicture.asset(
                lightAsset,
                height: fixedHeight,
                width: fixedHeight,
              ),
            ),
            Container(
              padding: AppDimensions.cardPaddingM,
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                border: Border.all(color: colors.borderColor),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
              child: SvgPicture.asset(
                darkAsset,
                height: fixedHeight,
                width: fixedHeight,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacingM),
        CodeText(assetName, color: colors.textSecondary),
      ],
    );
  }
}

class LogoUsageGuide extends StatelessWidget {
  const LogoUsageGuide({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final colors = theme.isDarkMode ? AppColors.dark : AppColors.light;

    return Container(
      padding: AppDimensions.cardPaddingM,
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border.all(color: colors.accentColor, width: AppDimensions.borderWidthRegular),
        borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MediumTitleText('📋 Logo Selection Rules:'),
          const SizedBox(height: AppDimensions.spacingS),
          _buildRuleItem('🤍 White Version:',
              'Use when placing logos on colored backgrounds (blue headers, dark backgrounds, colored banners)'),
          _buildRuleItem('⚫ Dark Version:', 'Use for light/white backgrounds and minimal interfaces'),
          _buildRuleItem('🔄 Theme Adaptive:', 'Use for dynamic interfaces that support theme switching'),
          const SizedBox(height: AppDimensions.spacingS),
          MediumBodyText(
            'Always ensure sufficient contrast between logo and background for accessibility.',
            style: const TextStyle(fontStyle: FontStyle.italic),
            color: colors.textSecondary,
          )
        ],
      ),
    );
  }

  Widget _buildRuleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.spacingXs, bottom: AppDimensions.spacingXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BoldText(title),
          const SizedBox(width: AppDimensions.spacingXs),
          Expanded(child: MediumBodyText(description)),
        ],
      ),
    );
  }
}

class NewIconPreview extends StatelessWidget {
  final String assetPath;
  final String description;

  const NewIconPreview({
    required this.assetPath,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final colors = theme.isDarkMode ? AppColors.dark : AppColors.light;

    const sizes = [16.0, 32.0, 64.0, 128.0, 256.0];
    const backgrounds = [
      _BackgroundConfig('White', Colors.white, Colors.black),
      _BackgroundConfig('Light Gray', Color(0xFFF5F5F5), Colors.black),
      _BackgroundConfig('Dark Gray', Color(0xFF424242), Colors.white),
      _BackgroundConfig('Black', Colors.black, Colors.white),
      _BackgroundConfig('Blue', Color(0xFF466AF1), Colors.white),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumBodyText(description, color: colors.textSecondary),
        const SizedBox(height: AppDimensions.spacingM),
        
        // Size demonstration
        const MediumTitleText('Multiple Sizes:'),
        const SizedBox(height: AppDimensions.spacingS),
        Wrap(
          spacing: AppDimensions.spacingM,
          runSpacing: AppDimensions.spacingM,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: sizes.map((size) {
            return _IconSizePreview(
              assetPath: assetPath,
              size: size,
              colors: colors,
            );
          }).toList(),
        ),
        
        const SizedBox(height: AppDimensions.spacingL),
        
        // Background variations
        const MediumTitleText('Background Variations:'),
        const SizedBox(height: AppDimensions.spacingS),
        Wrap(
          spacing: AppDimensions.spacingM,
          runSpacing: AppDimensions.spacingM,
          children: backgrounds.map((bg) {
            return _IconBackgroundPreview(
              assetPath: assetPath,
              config: bg,
            );
          }).toList(),
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        CodeText(assetPath, color: colors.textSecondary),
      ],
    );
  }
}

class _IconSizePreview extends StatelessWidget {
  final String assetPath;
  final double size;
  final ThemeColorSet colors;

  const _IconSizePreview({
    required this.assetPath,
    required this.size,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: colors.borderColor),
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingS),
            child: SvgPicture.asset(
              assetPath,
              width: size,
              height: size,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        SmallBodyText('${size.toInt()}px', color: colors.textSecondary),
      ],
    );
  }
}

class _IconBackgroundPreview extends StatelessWidget {
  final String assetPath;
  final _BackgroundConfig config;

  const _IconBackgroundPreview({
    required this.assetPath,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            color: config.bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacingM),
            child: SvgPicture.asset(
              assetPath,
              width: 64,
              height: 64,
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXs),
        SmallBodyText(config.label, color: config.labelColor),
      ],
    );
  }
}

class _BackgroundConfig {
  final String label;
  final Color bgColor;
  final Color labelColor;

  const _BackgroundConfig(this.label, this.bgColor, this.labelColor);
}

class _IconVariantsGrid extends StatelessWidget {
  final List<String> iconPaths;
  final bool showLarger;

  const _IconVariantsGrid({
    required this.iconPaths,
    this.showLarger = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final colors = theme.isDarkMode ? AppColors.dark : AppColors.light;

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      child: Wrap(
        spacing: AppDimensions.spacingM,
        runSpacing: AppDimensions.spacingM,
        children: iconPaths.asMap().entries.map((entry) {
          final index = entry.key;
          final path = entry.value;
          
          return _IconVariantCard(
            iconPath: path,
            variantNumber: index + 1,
            colors: colors,
            size: showLarger ? 150 : 120,
          );
        }).toList(),
      ),
    );
  }
}

class _IconVariantCard extends StatelessWidget {
  final String iconPath;
  final int variantNumber;
  final ThemeColorSet colors;
  final double size;

  const _IconVariantCard({
    required this.iconPath,
    required this.variantNumber,
    required this.colors,
    this.size = 120,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.borderColor),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingM),
        child: Column(
          children: [
            SvgPicture.asset(
              iconPath,
              width: size,
              height: size,
            ),
            const SizedBox(height: AppDimensions.spacingS),
            SmallBodyText(
              'Variant $variantNumber',
              color: colors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FinalIconPreview extends StatelessWidget {
  final String assetPath;
  final String description;

  const _FinalIconPreview({
    required this.assetPath,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final colors = theme.isDarkMode ? AppColors.dark : AppColors.light;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MediumBodyText(description, color: colors.textSecondary),
        const SizedBox(height: AppDimensions.spacingM),
        
        // Large preview
        Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: colors.borderColor),
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppDimensions.spacingL),
                child: SvgPicture.asset(
                  assetPath,
                  width: 200,
                  height: 200,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacingL),
            
            // Multiple sizes
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MediumTitleText('Multiple Sizes:'),
                const SizedBox(height: AppDimensions.spacingS),
                Wrap(
                  spacing: AppDimensions.spacingM,
                  runSpacing: AppDimensions.spacingM,
                  children: [16.0, 32.0, 64.0, 128.0].map((size) {
                    return _IconSizePreview(
                      assetPath: assetPath,
                      size: size,
                      colors: colors,
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
        
        const SizedBox(height: AppDimensions.spacingM),
        CodeText(assetPath, color: colors.textSecondary),
      ],
    );
  }
}
