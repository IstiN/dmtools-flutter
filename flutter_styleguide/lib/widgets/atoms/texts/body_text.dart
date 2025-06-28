import 'package:flutter/material.dart';
import 'base_text.dart';

/// Body text components for regular paragraph text
/// Used for paragraphs, descriptions, and general text content

class LargeBodyText extends BaseText {
  const LargeBodyText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.bodyLarge!;
}

class MediumBodyText extends BaseText {
  const MediumBodyText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.bodyMedium!;
}

class SmallBodyText extends BaseText {
  const SmallBodyText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.bodySmall!;
} 