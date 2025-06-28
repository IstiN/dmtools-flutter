import 'package:flutter/material.dart';
import 'base_text.dart';

/// Title text components for smaller headings
/// Used for card titles, section subtitles, etc.

class LargeTitleText extends BaseText {
  const LargeTitleText(
    String text, {
    super.key,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.color,
    super.style,
  }) : super(
          text: text,
        );

  @override
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.titleLarge!;
}

class MediumTitleText extends BaseText {
  const MediumTitleText(
    String text, {
    super.key,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.color,
    super.style,
  }) : super(
          text: text,
        );

  @override
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.titleMedium!;
}

class SmallTitleText extends BaseText {
  const SmallTitleText(
    String text, {
    super.key,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.color,
    super.style,
  }) : super(
          text: text,
        );

  @override
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.titleSmall!;
} 