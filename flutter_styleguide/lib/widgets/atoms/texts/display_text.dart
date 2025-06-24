import 'package:flutter/material.dart';
import 'base_text.dart';

/// Display text components for largest text styles
/// Used for page headings and major section titles

class LargeDisplayText extends BaseText {
  const LargeDisplayText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.displayLarge!;
}

class MediumDisplayText extends BaseText {
  const MediumDisplayText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.displayMedium!;
}

class SmallDisplayText extends BaseText {
  const SmallDisplayText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.displaySmall!;
} 