import 'package:flutter/material.dart';
import 'base_text.dart';

/// Title text components for smaller headings
/// Used for card titles, section subtitles, etc.

class LargeTitleText extends BaseText {
  const LargeTitleText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.titleLarge!;
}

class MediumTitleText extends BaseText {
  const MediumTitleText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.titleMedium!;
}

class SmallTitleText extends BaseText {
  const SmallTitleText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.titleSmall!;
} 