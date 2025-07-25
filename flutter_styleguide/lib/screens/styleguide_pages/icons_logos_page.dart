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
