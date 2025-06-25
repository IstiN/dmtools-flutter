import 'package:flutter/material.dart';
import 'base_text.dart';

/// Special text components for code, bold, italic, etc.
/// These components apply specific styling to text

class CodeText extends BaseText {
  const CodeText(
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
  TextStyle getBaseStyle(ThemeData theme) {
    return theme.textTheme.bodyMedium!.copyWith(
      fontFamily: 'Courier',
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      letterSpacing: -0.5,
    );
  }
}

class BoldText extends BaseText {
  final TextStyle? baseStyle;

  const BoldText(
    String text, {
    Key? key,
    this.baseStyle,
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
  TextStyle getBaseStyle(ThemeData theme) {
    final baseTextStyle = baseStyle ?? theme.textTheme.bodyMedium!;
    return baseTextStyle.copyWith(
      fontWeight: FontWeight.bold,
    );
  }
}

class ItalicText extends BaseText {
  final TextStyle? baseStyle;

  const ItalicText(
    String text, {
    Key? key,
    this.baseStyle,
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
  TextStyle getBaseStyle(ThemeData theme) {
    final baseTextStyle = baseStyle ?? theme.textTheme.bodyMedium!;
    return baseTextStyle.copyWith(
      fontStyle: FontStyle.italic,
    );
  }
} 