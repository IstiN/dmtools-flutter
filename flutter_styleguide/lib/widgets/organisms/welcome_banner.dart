import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/accessibility_utils.dart';
import '../atoms/buttons/app_buttons.dart';

class WelcomeBanner extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onPrimaryAction;
  final VoidCallback? onSecondaryAction;
  final String primaryActionText;
  final String secondaryActionText;
  final bool isTestMode;
  final bool testDarkMode;
  final String? logoAssetPath;
  final Widget? logoWidget;

  const WelcomeBanner({
    required this.title,
    required this.subtitle,
    super.key,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.primaryActionText = 'Get Started',
    this.secondaryActionText = 'Learn More',
    this.isTestMode = false,
    this.testDarkMode = false,
    this.logoAssetPath,
    this.logoWidget,
  }) : assert(logoAssetPath == null || logoWidget == null, 'Cannot provide both a logoAssetPath and a logoWidget.');

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isTestMode ? testDarkMode : Provider.of<ThemeProvider>(context).isDarkMode;

    final lightThemeGradient = [
      const Color(0xFF5E72EB),
      const Color(0xFF00C6FB),
    ];

    final darkThemeGradient = [
      const Color(0xFF667eea),
      const Color(0xFF764ba2),
    ];

    final gradientColors = isDarkMode ? darkThemeGradient : lightThemeGradient;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode
                ? Colors.black.withAlpha(80) // ~30% opacity
                : gradientColors.last.withAlpha(100), // ~40% opacity
            blurRadius: 25,
            spreadRadius: -5,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        child: Stack(
          children: [
            // Subtle geometric patterns
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(13), // ~5% opacity
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -50,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withAlpha(18), // ~7% opacity
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (logoWidget != null) ...[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: logoWidget,
                    ),
                    const SizedBox(height: 32),
                  ] else if (logoAssetPath != null) ...[
                    SizedBox(
                      height: 70,
                      child: logoAssetPath!.endsWith('.svg')
                          ? SvgPicture.asset(
                              logoAssetPath!,
                              alignment: Alignment.centerLeft,
                            )
                          : Image.asset(
                              logoAssetPath!,
                              fit: BoxFit.contain,
                              alignment: Alignment.centerLeft,
                            ),
                    ),
                    const SizedBox(height: 32),
                  ],
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 19,
                      color: Colors.white.withAlpha(230), // ~90% opacity
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      PrimaryButton(
                        text: primaryActionText,
                        onPressed: onPrimaryAction,
                        testId: generateTestId('button', {'action': primaryActionText.toLowerCase().replaceAll(' ', '-')}),
                        semanticLabel: '$primaryActionText button',
                        isTestMode: isTestMode,
                        testDarkMode: testDarkMode,
                      ),
                      const SizedBox(width: 16),
                      WhiteOutlineButton(
                        text: secondaryActionText,
                        onPressed: onSecondaryAction,
                        testId: generateTestId('button', {'action': secondaryActionText.toLowerCase().replaceAll(' ', '-')}),
                        semanticLabel: '$secondaryActionText button',
                        isTestMode: isTestMode,
                        testDarkMode: testDarkMode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
