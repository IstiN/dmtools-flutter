import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// A widget that displays code with syntax highlighting and copy functionality
///
/// This molecule provides a formatted code display with optional title,
/// copy button, line numbers, and customizable appearance. Used for
/// showing configuration code, JSON responses, and other text content.
class CodeDisplayBlock extends StatelessWidget {
  const CodeDisplayBlock({
    required this.code,
    this.title,
    this.language,
    this.showLineNumbers = false,
    this.showCopyButton = true,
    this.maxHeight,
    this.theme = CodeDisplayTheme.dark,
    this.size = CodeDisplaySize.medium,
    this.onCopy,
    super.key,
  });

  final String code;
  final String? title;
  final String? language;
  final bool showLineNumbers;
  final bool showCopyButton;
  final double? maxHeight;
  final CodeDisplayTheme theme;
  final CodeDisplaySize size;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimensions = _getDimensions();
    final codeTheme = _getCodeTheme(colors);

    return Container(
      decoration: BoxDecoration(
        color: codeTheme.backgroundColor,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        border: Border.all(color: codeTheme.borderColor, width: dimensions.borderWidth),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || showCopyButton)
            _HeaderSection(
              title: title,
              language: language,
              showCopyButton: showCopyButton,
              code: code,
              codeTheme: codeTheme,
              dimensions: dimensions,
              onCopy: onCopy,
            ),
          _CodeContent(
            code: code,
            showLineNumbers: showLineNumbers,
            maxHeight: maxHeight,
            codeTheme: codeTheme,
            dimensions: dimensions,
          ),
        ],
      ),
    );
  }

  _CodeDimensions _getDimensions() {
    switch (size) {
      case CodeDisplaySize.small:
        return const _CodeDimensions(
          borderRadius: 6,
          borderWidth: 1,
          headerPadding: 12,
          codePadding: 12,
          fontSize: 12,
          lineHeight: 1.4,
          headerSpacing: 8,
          copyButtonSize: CopyButtonSize.small,
        );
      case CodeDisplaySize.medium:
        return const _CodeDimensions(
          borderRadius: 8,
          borderWidth: 1,
          headerPadding: 16,
          codePadding: 16,
          fontSize: 14,
          lineHeight: 1.5,
          headerSpacing: 12,
          copyButtonSize: CopyButtonSize.medium,
        );
      case CodeDisplaySize.large:
        return const _CodeDimensions(
          borderRadius: 12,
          borderWidth: 1,
          headerPadding: 20,
          codePadding: 20,
          fontSize: 16,
          lineHeight: 1.6,
          headerSpacing: 16,
          copyButtonSize: CopyButtonSize.large,
        );
    }
  }

  _CodeTheme _getCodeTheme(ThemeColorSet colors) {
    switch (theme) {
      case CodeDisplayTheme.light:
        return _CodeTheme(
          backgroundColor: colors.cardBg,
          borderColor: colors.borderColor,
          textColor: colors.textColor,
          lineNumberColor: colors.textColor.withOpacity(0.4),
          headerBackgroundColor: colors.cardBg,
          headerTextColor: colors.textColor,
          scrollbarColor: colors.borderColor,
        );
      case CodeDisplayTheme.dark:
        return _CodeTheme(
          backgroundColor: colors.codeBgColor,
          borderColor: colors.borderColor.withOpacity(0.3),
          textColor: const Color(0xFFE1E4E8), // GitHub dark theme text
          lineNumberColor: const Color(0xFF6A737D), // GitHub dark theme line numbers
          headerBackgroundColor: colors.codeBgColor,
          headerTextColor: const Color(0xFFE1E4E8),
          scrollbarColor: const Color(0xFF6A737D),
        );
      case CodeDisplayTheme.auto:
        // Use theme-appropriate colors
        final isDark = colors.codeBgColor.computeLuminance() < 0.5;
        if (isDark) {
          return _CodeTheme(
            backgroundColor: colors.codeBgColor,
            borderColor: colors.borderColor.withOpacity(0.3),
            textColor: const Color(0xFFE1E4E8), // GitHub dark theme text
            lineNumberColor: const Color(0xFF6A737D), // GitHub dark theme line numbers
            headerBackgroundColor: colors.codeBgColor,
            headerTextColor: const Color(0xFFE1E4E8),
            scrollbarColor: const Color(0xFF6A737D),
          );
        } else {
          return _CodeTheme(
            backgroundColor: colors.cardBg,
            borderColor: colors.borderColor,
            textColor: colors.textColor,
            lineNumberColor: colors.textColor.withOpacity(0.4),
            headerBackgroundColor: colors.cardBg,
            headerTextColor: colors.textColor,
            scrollbarColor: colors.borderColor,
          );
        }
    }
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({
    required this.codeTheme,
    required this.dimensions,
    required this.code,
    this.title,
    this.language,
    this.showCopyButton = true,
    this.onCopy,
  });

  final String? title;
  final String? language;
  final bool showCopyButton;
  final String code;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(dimensions.headerPadding),
      decoration: BoxDecoration(
        color: codeTheme.headerBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(dimensions.borderRadius),
          topRight: Radius.circular(dimensions.borderRadius),
        ),
        border: Border(
          bottom: BorderSide(color: codeTheme.borderColor, width: dimensions.borderWidth),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: dimensions.fontSize,
                      fontWeight: FontWeight.w600,
                      color: codeTheme.headerTextColor,
                    ),
                  ),
                  if (language != null) ...[
                    SizedBox(width: dimensions.headerSpacing),
                    _LanguageBadge(language: language!, codeTheme: codeTheme, dimensions: dimensions),
                  ],
                ] else if (language != null) ...[
                  _LanguageBadge(language: language!, codeTheme: codeTheme, dimensions: dimensions),
                ],
              ],
            ),
          ),
          if (showCopyButton)
            CopyButton(
              textToCopy: code,
              variant: CopyButtonVariant.iconOnly,
              size: dimensions.copyButtonSize,
              onCopied: onCopy,
            ),
        ],
      ),
    );
  }
}

class _LanguageBadge extends StatelessWidget {
  const _LanguageBadge({required this.language, required this.codeTheme, required this.dimensions});

  final String language;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: codeTheme.textColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(
        language.toUpperCase(),
        style: TextStyle(
          fontSize: dimensions.fontSize * 0.8,
          fontWeight: FontWeight.w500,
          color: codeTheme.textColor.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _CodeContent extends StatelessWidget {
  const _CodeContent({
    required this.code,
    required this.showLineNumbers,
    required this.codeTheme,
    required this.dimensions,
    this.maxHeight,
  });

  final String code;
  final bool showLineNumbers;
  final double? maxHeight;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n');

    Widget content = showLineNumbers
        ? _CodeWithLineNumbers(lines: lines, codeTheme: codeTheme, dimensions: dimensions)
        : _SimpleCodeDisplay(code: code, codeTheme: codeTheme, dimensions: dimensions);

    if (maxHeight != null) {
      content = SizedBox(
        height: maxHeight,
        child: SingleChildScrollView(child: content),
      );
    }

    return Container(padding: EdgeInsets.all(dimensions.codePadding), child: content);
  }
}

class _CodeWithLineNumbers extends StatelessWidget {
  const _CodeWithLineNumbers({required this.lines, required this.codeTheme, required this.dimensions});

  final List<String> lines;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    final lineNumberWidth = '${lines.length}'.length * 8.0 + 16;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line numbers
        SizedBox(
          width: lineNumberWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: lines.asMap().entries.map((entry) {
              return Container(
                height: dimensions.fontSize * dimensions.lineHeight,
                alignment: Alignment.centerRight,
                child: Text(
                  '${entry.key + 1}',
                  style: TextStyle(
                    fontSize: dimensions.fontSize,
                    color: codeTheme.lineNumberColor,
                    fontFamily: 'monospace',
                    height: dimensions.lineHeight,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(width: dimensions.headerSpacing),
        // Code content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lines.map((line) {
              return SizedBox(
                height: dimensions.fontSize * dimensions.lineHeight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    line.isEmpty ? ' ' : line, // Preserve empty lines
                    style: TextStyle(
                      fontSize: dimensions.fontSize,
                      color: codeTheme.textColor,
                      fontFamily: 'monospace',
                      height: dimensions.lineHeight,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SimpleCodeDisplay extends StatelessWidget {
  const _SimpleCodeDisplay({required this.code, required this.codeTheme, required this.dimensions});

  final String code;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      code,
      style: TextStyle(
        fontSize: dimensions.fontSize,
        color: codeTheme.textColor,
        fontFamily: 'monospace',
        height: dimensions.lineHeight,
      ),
    );
  }
}

/// Theme options for code display
enum CodeDisplayTheme { light, dark, auto }

/// Size variants for code display
enum CodeDisplaySize { small, medium, large }

class _CodeDimensions {
  const _CodeDimensions({
    required this.borderRadius,
    required this.borderWidth,
    required this.headerPadding,
    required this.codePadding,
    required this.fontSize,
    required this.lineHeight,
    required this.headerSpacing,
    required this.copyButtonSize,
  });

  final double borderRadius;
  final double borderWidth;
  final double headerPadding;
  final double codePadding;
  final double fontSize;
  final double lineHeight;
  final double headerSpacing;
  final CopyButtonSize copyButtonSize;
}

class _CodeTheme {
  const _CodeTheme({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.lineNumberColor,
    required this.headerBackgroundColor,
    required this.headerTextColor,
    required this.scrollbarColor,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color lineNumberColor;
  final Color headerBackgroundColor;
  final Color headerTextColor;
  final Color scrollbarColor;

  _CodeTheme copyWith({
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
    Color? lineNumberColor,
    Color? headerBackgroundColor,
    Color? headerTextColor,
    Color? scrollbarColor,
    CodeDisplayTheme? theme,
  }) {
    return _CodeTheme(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderColor: borderColor ?? this.borderColor,
      textColor: textColor ?? this.textColor,
      lineNumberColor: lineNumberColor ?? this.lineNumberColor,
      headerBackgroundColor: headerBackgroundColor ?? this.headerBackgroundColor,
      headerTextColor: headerTextColor ?? this.headerTextColor,
      scrollbarColor: scrollbarColor ?? this.scrollbarColor,
    );
  }
}
