import 'package:flutter/material.dart';
import '../../../theme/app_dimensions.dart';

/// Base class for card components
abstract class BaseCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool hasShadow;
  final bool hasBorder;

  const BaseCard({
    Key? key,
    required this.child,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.elevation,
    this.borderRadius,
    this.hasShadow = true,
    this.hasBorder = true,
  }) : super(key: key);

  /// Get the default padding for the card
  EdgeInsetsGeometry getDefaultPadding() {
    return AppDimensions.cardPaddingM;
  }

  /// Get the default border radius for the card
  BorderRadius getDefaultBorderRadius() {
    return BorderRadius.circular(AppDimensions.radiusS);
  }

  /// Get the default elevation for the card
  double getDefaultElevation() {
    return 2.0;
  }

  /// Build the card container with appropriate styling
  Widget buildCardContainer(BuildContext context, Widget child) {
    final theme = Theme.of(context);
    
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? theme.cardColor,
        borderRadius: borderRadius ?? getDefaultBorderRadius(),
        border: hasBorder 
            ? Border.all(
                color: borderColor ?? theme.dividerColor,
                width: 1,
              )
            : null,
        boxShadow: hasShadow 
            ? [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: elevation ?? getDefaultElevation(),
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: padding ?? getDefaultPadding(),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildCardContainer(context, child);
  }
} 