import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// A widget that renders markdown content with custom styling and code block support
///
/// This molecule provides a markdown renderer that integrates seamlessly with
/// the design system, using custom code blocks with copy functionality and
/// proper theming support.
class MarkdownRenderer extends StatelessWidget {
  const MarkdownRenderer({
    required this.data,
    this.selectable = true,
    this.shrinkWrap = false,
    this.onTapLink,
    this.styleSheet,
    this.codeTheme = CodeDisplayTheme.auto,
    this.showCodeCopyButton = true,
    this.maxCodeHeight,
    super.key,
  });

  /// The markdown string to render
  final String data;

  /// Whether the text should be selectable
  final bool selectable;

  /// Whether the markdown should shrink wrap its content
  final bool shrinkWrap;

  /// Callback when a link is tapped
  final void Function(String text, String? href, String title)? onTapLink;

  /// Custom style sheet for markdown elements
  final MarkdownStyleSheet? styleSheet;

  /// Theme for code blocks
  final CodeDisplayTheme codeTheme;

  /// Whether to show copy button on code blocks
  final bool showCodeCopyButton;

  /// Maximum height for code blocks
  final double? maxCodeHeight;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final defaultStyleSheet = _buildStyleSheet(context, colors);
    final effectiveStyleSheet = styleSheet ?? defaultStyleSheet;

    return MarkdownBody(
      data: data,
      selectable: selectable,
      shrinkWrap: shrinkWrap,
      onTapLink: onTapLink,
      styleSheet: effectiveStyleSheet,
      builders: {
        'code': _CodeElementBuilder(codeTheme: codeTheme, showCopyButton: showCodeCopyButton, maxHeight: maxCodeHeight),
      },
      extensionSet: md.ExtensionSet(md.ExtensionSet.gitHubFlavored.blockSyntaxes, <md.InlineSyntax>[
        md.EmojiSyntax(),
        ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
      ]),
    );
  }

  MarkdownStyleSheet _buildStyleSheet(BuildContext context, ThemeColorSet colors) {
    final textTheme = Theme.of(context).textTheme;

    return MarkdownStyleSheet(
      // Headings - use theme-defined font sizes instead of hardcoded values
      h1: textTheme.displayLarge?.copyWith(color: colors.textColor, fontWeight: FontWeight.bold),
      h2: textTheme.displayMedium?.copyWith(color: colors.textColor, fontWeight: FontWeight.bold),
      h3: textTheme.displaySmall?.copyWith(color: colors.textColor, fontWeight: FontWeight.w600),
      h4: textTheme.headlineLarge?.copyWith(color: colors.textColor, fontWeight: FontWeight.w600),
      h5: textTheme.headlineMedium?.copyWith(color: colors.textColor, fontWeight: FontWeight.w600),
      h6: textTheme.headlineSmall?.copyWith(color: colors.textColor, fontWeight: FontWeight.w600),

      // Body text
      p: textTheme.bodyLarge?.copyWith(color: colors.textColor, height: 1.5),

      // Links
      a: TextStyle(color: colors.accentColor, decoration: TextDecoration.underline),

      // Lists
      listBullet: textTheme.bodyLarge?.copyWith(color: colors.textColor),

      // Code inline
      code: TextStyle(
        color: colors.accentColor,
        backgroundColor: colors.inputBg,
        fontFamily: 'monospace',
        fontSize: textTheme.bodyMedium?.fontSize,
      ),

      // Code blocks (handled by custom builder, but fallback styling)
      codeblockDecoration: BoxDecoration(
        color: colors.inputBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        border: Border.all(color: colors.borderColor),
      ),

      // Tables
      tableHead: TextStyle(color: colors.textColor, fontWeight: FontWeight.w600),
      tableBody: TextStyle(color: colors.textColor),
      tableBorder: TableBorder.all(color: colors.borderColor),

      // Blockquotes
      blockquote: TextStyle(color: colors.textSecondary, fontStyle: FontStyle.italic),
      blockquoteDecoration: BoxDecoration(
        color: colors.inputBg.withValues(alpha: AppDimensions.headerBorderOpacity),
        border: Border(
          left: BorderSide(color: colors.accentColor, width: AppDimensions.borderWidthThick * 2),
        ),
      ),

      // Horizontal rule
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.borderColor)),
      ),
    );
  }
}

/// Custom builder for code elements that uses our CodeDisplayBlock component
class _CodeElementBuilder extends MarkdownElementBuilder {
  _CodeElementBuilder({required this.codeTheme, required this.showCopyButton, this.maxHeight});

  final CodeDisplayTheme codeTheme;
  final bool showCopyButton;
  final double? maxHeight;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    // Handle code blocks (not inline code)
    if (element.tag == 'code' && element.textContent.contains('\n')) {
      final language = _extractLanguage(element);
      final code = element.textContent;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
        child: CodeDisplayBlock(
          code: code,
          language: language,
          theme: codeTheme,
          showCopyButton: showCopyButton,
          maxHeight: maxHeight,
        ),
      );
    }

    return null;
  }

  String? _extractLanguage(md.Element element) {
    // Try to extract language from class attribute (e.g., "language-dart")
    final classAttribute = element.attributes['class'];
    if (classAttribute != null) {
      final match = RegExp(r'language-(\w+)').firstMatch(classAttribute);
      if (match != null) {
        return match.group(1);
      }
    }

    return null;
  }
}
