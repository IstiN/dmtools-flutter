import 'package:flutter/material.dart';
import 'base_text.dart';

/// Headline text components for section headings
/// Used for section titles and sub-headings

class LargeHeadlineText extends BaseText {
  const LargeHeadlineText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.headlineLarge!;
}

class MediumHeadlineText extends BaseText {
  const MediumHeadlineText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.headlineMedium!;
}

class SmallHeadlineText extends BaseText {
  const SmallHeadlineText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.headlineSmall!;
} 