import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:dmtools_styleguide/utils/syntax_highlighter.dart';

/// A widget that displays code with syntax highlighting and copy functionality
///
/// This molecule provides a formatted code display with optional title,
/// copy button, line numbers, and customizable appearance. Used for
/// showing configuration code, JSON responses, and other text content.
class CodeDisplayBlock extends StatefulWidget {
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
    this.initiallyCollapsed = false,
    this.transparentBackground = false,
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
  final bool initiallyCollapsed;
  final bool transparentBackground;

  @override
  State<CodeDisplayBlock> createState() => _CodeDisplayBlockState();
}

class _CodeDisplayBlockState extends State<CodeDisplayBlock> {
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.initiallyCollapsed;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dimensions = _getDimensions();
    final codeTheme = _getCodeTheme(colors);

    // Use adaptive background - no outer gray container, no border
    // If transparentBackground is true, use transparent color to remove frame
    return DecoratedBox(
      decoration: BoxDecoration(
        color: widget.transparentBackground ? Colors.transparent : codeTheme.backgroundColor,
        borderRadius: BorderRadius.circular(dimensions.borderRadius),
        // No border to remove gray frame
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _HeaderSection(
            title: widget.title,
            language: widget.language,
            showCopyButton: widget.showCopyButton,
            code: widget.code,
            codeTheme: codeTheme,
            dimensions: dimensions,
            onCopy: widget.onCopy,
            isCollapsed: _isCollapsed,
            transparentBackground: widget.transparentBackground,
            onToggleCollapse: () {
              setState(() {
                _isCollapsed = !_isCollapsed;
              });
            },
          ),
          if (!_isCollapsed)
            _CodeContent(
              code: widget.code,
              showLineNumbers: widget.showLineNumbers,
              maxHeight: widget.maxHeight,
              codeTheme: codeTheme,
              dimensions: dimensions,
              language: widget.language,
              transparentBackground: widget.transparentBackground,
            ),
        ],
      ),
    );
  }

  _CodeDimensions _getDimensions() {
    switch (widget.size) {
      case CodeDisplaySize.small:
        return const _CodeDimensions(
          borderRadius: 6,
          borderWidth: 1,
          headerPadding: 6,
          codePadding: 6,
          fontSize: 12,
          lineHeight: 1.4,
          headerSpacing: 6,
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
    switch (widget.theme) {
      case CodeDisplayTheme.light:
        return _CodeTheme(
          backgroundColor: colors.cardBg,
          borderColor: colors.borderColor,
          textColor: colors.textColor,
          lineNumberColor: colors.textColor.withValues(alpha: 0.4),
          headerBackgroundColor: colors.cardBg,
          headerTextColor: colors.textColor,
          scrollbarColor: colors.borderColor,
        );
      case CodeDisplayTheme.dark:
        return _CodeTheme(
          backgroundColor: colors.codeBgColor,
          borderColor: colors.borderColor.withValues(alpha: 0.3),
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
            borderColor: colors.borderColor.withValues(alpha: 0.3),
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
            lineNumberColor: colors.textColor.withValues(alpha: 0.4),
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
    this.isCollapsed = false,
    this.transparentBackground = false,
    this.onToggleCollapse,
  });

  final String? title;
  final String? language;
  final bool showCopyButton;
  final String code;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;
  final VoidCallback? onCopy;
  final bool isCollapsed;
  final bool transparentBackground;
  final VoidCallback? onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: dimensions.headerPadding * 0.75,
        vertical: dimensions.headerPadding * 0.5,
      ),
      decoration: BoxDecoration(
        color: transparentBackground ? Colors.transparent : codeTheme.headerBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(dimensions.borderRadius),
          topRight: Radius.circular(dimensions.borderRadius),
        ),
        // No border to remove gray frame
      ),
      child: Row(
        children: [
          if (onToggleCollapse != null)
            GestureDetector(
              onTap: onToggleCollapse,
              child: Icon(
                isCollapsed ? Icons.expand_more : Icons.expand_less,
                size: 16,
                color: codeTheme.headerTextColor, // Adaptive header text color
              ),
            ),
          if (onToggleCollapse != null) SizedBox(width: dimensions.headerSpacing * 0.5),
          Expanded(
            child: Row(
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: dimensions.fontSize * 0.9,
                      fontWeight: FontWeight.w600,
                      color: codeTheme.headerTextColor, // Adaptive header text color
                    ),
                  ),
                  if (language != null) ...[
                    SizedBox(width: dimensions.headerSpacing * 0.75),
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
      decoration: BoxDecoration(
        color: const Color(0xFF6A737D), // Gray background matching the image
        borderRadius: BorderRadius.circular(8), // Smaller pill shape
      ),
      child: Text(
        language.toUpperCase(),
        style: const TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w500,
          color: Colors.white, // White text as shown in image
          letterSpacing: 0.3,
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
    this.language,
    this.transparentBackground = false,
  });

  final String code;
  final bool showLineNumbers;
  final double? maxHeight;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;
  final String? language;
  final bool transparentBackground;

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n');

    Widget content = showLineNumbers
        ? _CodeWithLineNumbers(
            lines: lines,
            codeTheme: codeTheme,
            dimensions: dimensions,
            language: language,
          )
        : _SimpleCodeDisplay(
            code: code,
            codeTheme: codeTheme,
            dimensions: dimensions,
            language: language,
          );

    if (maxHeight != null) {
      content = SizedBox(
        height: maxHeight,
        child: SingleChildScrollView(child: content),
      );
    }

    // Inner container with adaptive background for code content
    // If transparentBackground is true, use transparent color to remove frame
    return Container(
      padding: EdgeInsets.all(dimensions.codePadding),
      decoration: BoxDecoration(
        color: transparentBackground ? Colors.transparent : codeTheme.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(dimensions.borderRadius),
          bottomRight: Radius.circular(dimensions.borderRadius),
        ),
      ),
      child: content,
    );
  }
}

class _CodeWithLineNumbers extends StatefulWidget {
  const _CodeWithLineNumbers({
    required this.lines,
    required this.codeTheme,
    required this.dimensions,
    this.language,
  });

  final List<String> lines;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;
  final String? language;

  @override
  State<_CodeWithLineNumbers> createState() => _CodeWithLineNumbersState();
}

class _CodeWithLineNumbersState extends State<_CodeWithLineNumbers> {
  List<TextSpan>? _cachedSpans;
  String? _cachedCode;
  bool? _cachedIsLightTheme;

  @override
  Widget build(BuildContext context) {
    final lineNumberWidth = '${widget.lines.length}'.length * 8.0 + 16;
    final fullCode = widget.lines.join('\n');
    // Determine if we're using light theme
    final isLightTheme = widget.codeTheme.backgroundColor.computeLuminance() > 0.5;
    
    // Cache syntax highlighting result
    if (_cachedCode != fullCode || _cachedIsLightTheme != isLightTheme) {
      _cachedCode = fullCode;
      _cachedIsLightTheme = isLightTheme;
      _cachedSpans = SyntaxHighlighter.highlight(fullCode, widget.language, isLightTheme: isLightTheme);
    }
    
    final highlightedSpans = _cachedSpans!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Line numbers
        SizedBox(
          width: lineNumberWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: widget.lines.asMap().entries.map((entry) {
              return Container(
                height: widget.dimensions.fontSize * widget.dimensions.lineHeight,
                alignment: Alignment.centerRight,
                child: Text(
                  '${entry.key + 1}',
                  style: TextStyle(
                    fontSize: widget.dimensions.fontSize,
                    color: widget.codeTheme.lineNumberColor,
                    fontFamily: 'monospace',
                    height: widget.dimensions.lineHeight,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(width: widget.dimensions.headerSpacing),
        // Code content with syntax highlighting
        Expanded(
          child: RichText(
            text: TextSpan(
              children: highlightedSpans,
              style: TextStyle(
                fontSize: widget.dimensions.fontSize,
                fontFamily: 'monospace',
                height: widget.dimensions.lineHeight,
                // Don't set color here - let TextSpan colors override
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SimpleCodeDisplay extends StatefulWidget {
  const _SimpleCodeDisplay({
    required this.code,
    required this.codeTheme,
    required this.dimensions,
    this.language,
  });

  final String code;
  final _CodeTheme codeTheme;
  final _CodeDimensions dimensions;
  final String? language;

  @override
  State<_SimpleCodeDisplay> createState() => _SimpleCodeDisplayState();
}

class _SimpleCodeDisplayState extends State<_SimpleCodeDisplay> {
  List<TextSpan>? _cachedSpans;
  String? _cachedCode;
  bool? _cachedIsLightTheme;

  @override
  Widget build(BuildContext context) {
    // Determine if we're using light theme
    final isLightTheme = widget.codeTheme.backgroundColor.computeLuminance() > 0.5;
    
    // Cache syntax highlighting result
    if (_cachedCode != widget.code || _cachedIsLightTheme != isLightTheme) {
      _cachedCode = widget.code;
      _cachedIsLightTheme = isLightTheme;
      _cachedSpans = SyntaxHighlighter.highlight(widget.code, widget.language, isLightTheme: isLightTheme);
    }
    
    final highlightedSpans = _cachedSpans!;

    // If highlighting worked, use the spans; otherwise use plain text
    // Check if we have multiple spans with actual text or if colors are different from default
    final nonEmptySpans = highlightedSpans.where((span) => span.text != null && span.text!.isNotEmpty).toList();
    
    // Check if any span has a different color than default (indicating highlighting worked)
    final hasHighlighting = nonEmptySpans.any((span) => 
      span.style?.color != null && 
      span.style!.color != SyntaxHighlighter.defaultTextColor &&
      span.style!.color != SyntaxHighlighter.defaultColorLight
    ) || nonEmptySpans.length > 1;
    
    if (hasHighlighting && nonEmptySpans.isNotEmpty) {
      return ConstrainedBox(
        constraints: const BoxConstraints(),
        child: SelectableText.rich(
          TextSpan(
            children: nonEmptySpans,
            style: TextStyle(
              fontSize: widget.dimensions.fontSize,
              fontFamily: 'monospace',
              height: widget.dimensions.lineHeight,
              // Don't set color here - let TextSpan colors override
            ),
          ),
        ),
      );
    } else {
      // Fallback to plain text if highlighting didn't work
      return ConstrainedBox(
        constraints: const BoxConstraints(),
        child: SelectableText(
          widget.code,
          style: TextStyle(
            fontSize: widget.dimensions.fontSize,
            fontFamily: 'monospace',
            height: widget.dimensions.lineHeight,
            color: widget.codeTheme.textColor,
          ),
        ),
      );
    }
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
