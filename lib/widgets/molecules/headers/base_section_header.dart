import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';

/// Base class for section header components
abstract class BaseSectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;
  final Widget? trailing;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;

  const BaseSectionHeader({
    Key? key,
    required this.title,
    this.onViewAll,
    this.trailing,
    this.titleStyle,
    this.padding,
  }) : super(key: key);

  /// Get the default padding for the section header
  EdgeInsetsGeometry getDefaultPadding() {
    return EdgeInsets.symmetric(
      vertical: AppDimensions.spacingS,
      horizontal: AppDimensions.spacingS,
    );
  }

  /// Get the default title style
  TextStyle getDefaultTitleStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge ?? const TextStyle();
  }

  /// Build the view all link if onViewAll is provided
  Widget? buildViewAllLink(BuildContext context) {
    if (onViewAll == null) {
      return null;
    }
    
    return GestureDetector(
      onTap: onViewAll,
      child: Text(
        'View All',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Build the section header
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? getDefaultPadding(),
      child: buildHeader(context),
    );
  }

  /// Build the header content
  Widget buildHeader(BuildContext context);
} 