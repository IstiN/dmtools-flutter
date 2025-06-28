import 'package:flutter/material.dart';
import 'base_text.dart';

/// Label text components for form labels, captions, etc.
/// Used for form field labels, captions, and other small text elements

class LargeLabelText extends BaseText {
  const LargeLabelText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.labelLarge!;
}

class MediumLabelText extends BaseText {
  const MediumLabelText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.labelMedium!;
}

class SmallLabelText extends BaseText {
  const SmallLabelText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.labelSmall!;
} 