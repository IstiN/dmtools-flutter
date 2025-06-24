import 'package:flutter/material.dart';
import 'base_section_header.dart';
import '../../../theme/app_dimensions.dart';

/// Section header with an underline
class UnderlinedSectionHeader extends BaseSectionHeader {
  final Color? underlineColor;
  final double underlineHeight;

  const UnderlinedSectionHeader({
    super.key,
    required super.title,
    super.onViewAll,
    super.trailing,
    super.titleStyle,
    super.padding,
    this.underlineColor,
    this.underlineHeight = 1.0,
  });

  @override
  Widget buildHeader(BuildContext context) {
    final theme = Theme.of(context);
    final lineColor = underlineColor ?? theme.dividerColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: titleStyle ?? getDefaultTitleStyle(context),
            ),
            if (trailing != null)
              trailing!
            else if (onViewAll != null)
              buildViewAllLink(context)!,
          ],
        ),
        SizedBox(height: AppDimensions.spacingXs),
        Container(
          height: underlineHeight,
          color: lineColor,
        ),
      ],
    );
  }
} 