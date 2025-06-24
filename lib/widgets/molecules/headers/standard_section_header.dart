import 'package:flutter/material.dart';
import 'base_section_header.dart';

/// Standard section header implementation
class StandardSectionHeader extends BaseSectionHeader {
  const StandardSectionHeader({
    super.key,
    required super.title,
    super.onViewAll,
    super.trailing,
    super.titleStyle,
    super.padding,
  });

  @override
  Widget buildHeader(BuildContext context) {
    return Row(
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
    );
  }
} 