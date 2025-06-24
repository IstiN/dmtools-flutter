import 'package:flutter/material.dart';
import 'base_text.dart';

/// Body text components for regular paragraph text
/// Used for paragraphs, descriptions, and general text content

class LargeBodyText extends BaseText {
  const LargeBodyText(
    String text, {
    Key? key,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          color: color,
          style: style,
        );

  @override
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.bodyLarge!;
}

class MediumBodyText extends BaseText {
  const MediumBodyText(
    String text, {
    Key? key,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          color: color,
          style: style,
        );

  @override
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.bodyMedium!;
}

class SmallBodyText extends BaseText {
  const SmallBodyText(
    String text, {
    Key? key,
    TextAlign? textAlign,
    TextOverflow? overflow,
    int? maxLines,
    Color? color,
    TextStyle? style,
  }) : super(
          key: key,
          text: text,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          color: color,
          style: style,
        );

  @override
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.bodySmall!;
} 