import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/styleguide/component_item.dart';
import '../../widgets/atoms/logos/logos.dart';

class LogosPage extends StatelessWidget {
  const LogosPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(AppDimensions.spacingM),
      children: [
        // Logo Components Section
        ComponentDisplay(
          title: 'Logo Components',
          child: Column(
            children: [
              ComponentItem(
                title: 'Icon Logo',
                child: _buildLogoComponentExample(
                  logoBuilder: (size, isDarkMode) => IconLogo(
                    size: size,
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                  description: 'The square icon/favicon logo used for app icons and small spaces.',
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Network Nodes Logo (Primary)',
                child: _buildLogoComponentExample(
                  logoBuilder: (size, isDarkMode) => NetworkNodesLogo(
                    size: size,
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                  description: 'The primary logo used in headers and main branding.',
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Wordmark Logo',
                child: _buildLogoComponentExample(
                  logoBuilder: (size, isDarkMode) => WordmarkLogo(
                    size: size,
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                  description: 'Text-only logo for use in specific contexts.',
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        
        // Logo Sizes Section
        ComponentDisplay(
          title: 'Logo Sizes',
          child: Column(
            children: [
              ComponentItem(
                title: 'Network Nodes Logo Sizes',
                child: _buildLogoSizesExample(
                  logoBuilder: (size, isDarkMode) => NetworkNodesLogo(
                    size: size,
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Icon Logo Sizes',
                child: _buildLogoSizesExample(
                  logoBuilder: (size, isDarkMode) => IconLogo(
                    size: size,
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingXl),
        
        // Logo Usage Section
        ComponentDisplay(
          title: 'Logo Usage',
          child: Column(
            children: [
              ComponentItem(
                title: 'Header Usage',
                child: _buildHeaderUsageExample(),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Color Variations',
                child: _buildColorVariationsExample(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Build a logo component example with light and dark theme
  Widget _buildLogoComponentExample({
    required Widget Function(LogoSize, bool) logoBuilder,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
              child: logoBuilder(LogoSize.medium, false),
            ),
            SizedBox(width: AppDimensions.spacingM),
            Container(
              padding: EdgeInsets.all(AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: const Color(0xFF333333),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
              ),
              child: logoBuilder(LogoSize.medium, true),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spacingS),
        Text(
          description,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  /// Build a logo sizes example
  Widget _buildLogoSizesExample({
    required Widget Function(LogoSize, bool) logoBuilder,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppDimensions.spacingM,
          runSpacing: AppDimensions.spacingM,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            _buildSizeExample('XS (24px)', logoBuilder(LogoSize.xs, false)),
            _buildSizeExample('Small (32px)', logoBuilder(LogoSize.small, false)),
            _buildSizeExample('Medium (48px)', logoBuilder(LogoSize.medium, false)),
            _buildSizeExample('Large (64px)', logoBuilder(LogoSize.large, false)),
            _buildSizeExample('XL (96px)', logoBuilder(LogoSize.xl, false)),
          ],
        ),
      ],
    );
  }

  /// Build a single size example with label
  Widget _buildSizeExample(String label, Widget logo) {
    return Column(
      children: [
        logo,
        SizedBox(height: AppDimensions.spacingXs),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  /// Build a header usage example
  Widget _buildHeaderUsageExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.all(AppDimensions.spacingM),
          child: Row(
            children: [
              const NetworkNodesLogo(
                size: LogoSize.small,
                color: Colors.white,
              ),
              SizedBox(width: AppDimensions.spacingS),
              const Text(
                'DMTools',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(foregroundColor: Colors.white),
                child: const Text('Menu Item'),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spacingS),
        const Text(
          'The Network Nodes logo is used in the header with white color for optimal visibility.',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  /// Build color variations example
  Widget _buildColorVariationsExample() {
    return Wrap(
      spacing: AppDimensions.spacingM,
      runSpacing: AppDimensions.spacingM,
      children: [
        _buildColorVariation('Primary', Theme.of(context).colorScheme.primary),
        _buildColorVariation('Secondary', Theme.of(context).colorScheme.secondary),
        _buildColorVariation('Error', Theme.of(context).colorScheme.error),
        _buildColorVariation('Black', Colors.black),
        _buildColorVariation('White', Colors.white, bgColor: Colors.black),
      ],
    );
  }

  /// Build a single color variation
  Widget _buildColorVariation(String label, Color color, {Color? bgColor}) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(AppDimensions.spacingM),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
            border: bgColor == null ? Border.all(color: Colors.grey.shade300) : null,
          ),
          child: IconLogo(
            size: LogoSize.medium,
            color: color,
          ),
        ),
        SizedBox(height: AppDimensions.spacingXs),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
} 