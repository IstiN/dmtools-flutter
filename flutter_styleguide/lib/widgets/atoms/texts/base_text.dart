import 'package:flutter/material.dart';

/// Base class for all text components
/// This provides common functionality and properties for all text components
abstract class BaseText extends StatelessWidget {
  final String text;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final Color? color;
  final TextStyle? style;

  const BaseText({
    Key? key,
    required this.text,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.color,
    this.style,
  }) : super(key: key);

  /// Get the base text style from the theme
  /// Subclasses must implement this to provide their specific text style
  TextStyle getBaseStyle(ThemeData theme);

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle baseStyle = getBaseStyle(theme);
    
    // Apply color and custom style overrides if provided
    final TextStyle effectiveStyle = (style != null)
        ? baseStyle.merge(style)
        : (color != null)
            ? baseStyle.copyWith(color: color)
            : baseStyle;

    return Text(
      text,
      style: effectiveStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
} 