import 'package:flutter/material.dart';
import 'base_card.dart';
import '../../../theme/app_dimensions.dart';

/// Compact card implementation with smaller padding and radius
class CompactCard extends BaseCard {
  const CompactCard({
    super.key,
    required super.child,
    super.padding,
    super.backgroundColor,
    super.borderColor,
    super.elevation,
    super.borderRadius,
    super.hasShadow = true,
    super.hasBorder = true,
  });

  @override
  EdgeInsetsGeometry getDefaultPadding() {
    return AppDimensions.cardPaddingS;
  }

  @override
  BorderRadius getDefaultBorderRadius() {
    return BorderRadius.circular(AppDimensions.radiusXs);
  }

  @override
  double getDefaultElevation() {
    return 1.0;
  }
} 