import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

/// A feature card component used to showcase features with an icon, title, and description
/// 
/// This component is typically used on landing pages to highlight product features
class FeatureCard extends StatelessWidget {
  /// The icon to display at the top of the card
  final IconData icon;
  
  /// The title of the feature
  final String title;
  
  /// The description of the feature
  final String description;
  
  /// Optional width of the card
  final double? width;
  
  /// Optional height of the card
  final double? height;
  
  /// Optional padding inside the card
  final EdgeInsetsGeometry padding;
  
  /// For testing purposes
  final bool isTestMode;
  
  /// For testing purposes
  final bool testDarkMode;

  const FeatureCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    this.width = 300,
    this.height = 220,
    this.padding = const EdgeInsets.all(24),
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    if (isTestMode) {
      isDarkMode = testDarkMode;
    } else {
      try {
        isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
      } catch (e) {
        isDarkMode = Theme.of(context).brightness == Brightness.dark;
      }
    }
    
    final ThemeColorSet colors = isDarkMode ? AppColors.dark : AppColors.light;

    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
        border: Border.all(color: colors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 48,
            color: colors.accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
} 