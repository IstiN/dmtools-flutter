import 'package:flutter/material.dart';
import 'base_text.dart';

/// Special text components for code, bold, italic, etc.
/// These components apply specific styling to text

class CodeText extends BaseText {
  const CodeText(
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
    super.key,
    this.baseStyle,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.color,
    super.style,
  }) : super(
          text: text,
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
    super.key,
    this.baseStyle,
    super.textAlign,
    super.overflow,
    super.maxLines,
    super.color,
    super.style,
  }) : super(
          text: text,
        );

  @override
  TextStyle getBaseStyle(ThemeData theme) {
    final baseTextStyle = baseStyle ?? theme.textTheme.bodyMedium!;
    return baseTextStyle.copyWith(
      fontStyle: FontStyle.italic,
    );
  }
} 