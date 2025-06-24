import 'package:flutter/material.dart';
import 'base_text.dart';

/// Headline text components for section headings
/// Used for section titles and sub-headings

class LargeHeadlineText extends BaseText {
  const LargeHeadlineText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.headlineLarge!;
}

class MediumHeadlineText extends BaseText {
  const MediumHeadlineText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.headlineMedium!;
}

class SmallHeadlineText extends BaseText {
  const SmallHeadlineText(
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
  TextStyle getBaseStyle(ThemeData theme) => theme.textTheme.headlineSmall!;
} 