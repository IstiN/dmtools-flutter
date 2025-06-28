import 'package:flutter/material.dart';
import 'base_text.dart';

/// Display text components for largest text styles
/// Used for page headings and major section titles

class LargeDisplayText extends BaseText {
  const LargeDisplayText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.displayLarge!;
}

class MediumDisplayText extends BaseText {
  const MediumDisplayText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.displayMedium!;
}

class SmallDisplayText extends BaseText {
  const SmallDisplayText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.displaySmall!;
} 