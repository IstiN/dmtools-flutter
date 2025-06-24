import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
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

  const WelcomeBanner({
    Key? key,
    required this.title,
    required this.subtitle,
    this.onPrimaryAction,
    this.onSecondaryAction,
    this.primaryActionText = 'Get Started',
    this.secondaryActionText = 'Learn More',
    this.isTestMode = false,
    this.testDarkMode = false,
    this.logoAssetPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = isTestMode ? testDarkMode : Provider.of<ThemeProvider>(context).isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.bannerGradientStart,
            colors.bannerGradientEnd,
          ],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (logoAssetPath != null) ...[
            Center(
              child: logoAssetPath!.endsWith('.svg')
                ? SvgPicture.asset(
                    logoAssetPath!,
                    height: 80,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  )
                : Image.asset(
                    logoAssetPath!,
                    height: 80,
                    fit: BoxFit.contain,
                  ),
            ),
            const SizedBox(height: 32),
          ],
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              PrimaryButton(
                text: primaryActionText,
                onPressed: onPrimaryAction,
                size: ButtonSize.medium,
                isTestMode: isTestMode,
                testDarkMode: testDarkMode,
              ),
              const SizedBox(width: 16),
              WhiteOutlineButton(
                text: secondaryActionText,
                onPressed: onSecondaryAction,
                size: ButtonSize.medium,
                isTestMode: isTestMode,
                testDarkMode: testDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }
} 