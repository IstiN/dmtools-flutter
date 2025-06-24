import 'package:flutter/material.dart';
import 'base_card.dart';
import '../../../theme/app_dimensions.dart';

/// Standard card implementation with default styling
class StandardCard extends BaseCard {
  const StandardCard({
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
    return AppDimensions.cardPaddingM;
  }
} 