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

    // Extract language information from markdown before parsing
    final languageMap = _extractLanguagesFromMarkdown(data);

    // Extract and process details/summary blocks
    final detailsBlocks = _extractDetailsBlocks(data);
    final processedData = _replaceDetailsBlocksWithPlaceholders(data, detailsBlocks);

    return _MarkdownWithDetailsWidget(
      markdown: processedData,
      detailsBlocks: detailsBlocks,
      effectiveStyleSheet: effectiveStyleSheet,
      languageMap: languageMap,
      selectable: selectable,
      shrinkWrap: shrinkWrap,
      onTapLink: onTapLink,
      codeTheme: codeTheme,
      showCodeCopyButton: showCodeCopyButton,
      maxCodeHeight: maxCodeHeight,
    );
  }

  /// Extract all details blocks from markdown (handles nested blocks)
  List<_DetailsBlock> _extractDetailsBlocks(String markdown) {
    final blocks = <_DetailsBlock>[];
    
    // Find all opening and closing tags (case-insensitive and handle whitespace)
    final openPattern = RegExp(r'<details(\s+open)?\s*>', caseSensitive: false, multiLine: true);
    final closePattern = RegExp(r'</details\s*>', caseSensitive: false, multiLine: true);
    final summaryPattern = RegExp(r'<summary\s*>([\s\S]*?)</summary\s*>', caseSensitive: false, multiLine: true);
    
    // Find all tag positions
    final openMatches = openPattern.allMatches(markdown).toList();
    final closeMatches = closePattern.allMatches(markdown).toList();
    
    if (openMatches.isEmpty || openMatches.length != closeMatches.length) {
      // No matches or mismatched tags
      return blocks;
    }
    
    // Process tags to find matching pairs (handling nesting)
    var openIndex = 0;
    
    while (openIndex < openMatches.length) {
      // Find the next opening tag
      final openMatch = openMatches[openIndex];
      final openStart = openMatch.start;
      final openEnd = openMatch.end;
      
      // Check if this tag has 'open' attribute
      final openAttr = openMatch.group(1);
      final isOpen = openAttr != null && openAttr.trim().contains('open');
      
      // Find the corresponding closing tag (accounting for nesting)
      var depth = 1;
      var searchCloseIndex = 0;
      
      // Find the first closing tag after this opening tag
      while (searchCloseIndex < closeMatches.length) {
        if (closeMatches[searchCloseIndex].start <= openStart) {
          searchCloseIndex++;
          continue;
        }
        break;
      }
      
      // Now search for the matching closing tag
      var currentOpenIndex = openIndex;
      while (searchCloseIndex < closeMatches.length && depth > 0) {
        final nextOpen = currentOpenIndex + 1 < openMatches.length 
            ? openMatches[currentOpenIndex + 1] 
            : null;
        final nextClose = closeMatches[searchCloseIndex];
        
        if (nextOpen != null && nextOpen.start < nextClose.start) {
          // Nested opening tag found
          depth++;
          currentOpenIndex++;
        } else {
          // Closing tag found
          depth--;
          if (depth == 0) {
            // Found matching closing tag
            final closeStart = nextClose.start;
            final closeEnd = nextClose.end;
            final fullMatch = markdown.substring(openStart, closeEnd);
            
            // Extract summary - search within the full match
            final summaryMatch = summaryPattern.firstMatch(fullMatch);
            final summary = summaryMatch?.group(1)?.trim() ?? 'Details';
            
            // Extract content (everything after </summary> and before </details>)
            // This content may contain nested details blocks, which will be processed
            // recursively when rendered through MarkdownRenderer
            int contentStart;
            if (summaryMatch != null) {
              // summaryMatch.start and end are relative to fullMatch start
              // Calculate absolute position: openStart + relative position
              final summaryEndRelative = summaryMatch.end;
              contentStart = openStart + summaryEndRelative;
            } else {
              contentStart = openEnd;
            }
            final contentEnd = closeStart;
            
            var content = '';
            if (contentEnd > contentStart && contentEnd <= markdown.length && contentStart >= 0) {
              content = markdown.substring(contentStart, contentEnd);
              // Clean up content: remove leading/trailing whitespace but preserve structure
              content = content.replaceAll(RegExp(r'^\s+'), '').replaceAll(RegExp(r'\s+$'), '');
            }
            
            blocks.add(_DetailsBlock(
              fullMatch: fullMatch,
              summary: summary,
              content: content,
              isOpen: isOpen,
            ));
            
            break;
          }
          searchCloseIndex++;
        }
      }
      
      openIndex++;
    }

    return blocks;
  }

  /// Replace details blocks with placeholders
  /// Process from end to start to handle nested blocks correctly
  String _replaceDetailsBlocksWithPlaceholders(String markdown, List<_DetailsBlock> blocks) {
    if (blocks.isEmpty) {
      return markdown;
    }
    
    // Create a list of blocks with their indices, sorted by position (end to start)
    final blocksWithIndices = <({int index, _DetailsBlock block, int start})>[];
    for (var i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      // Use indexOf to find the first occurrence, but we need exact match
      // Escape special regex characters in fullMatch for exact matching
      final escapedMatch = RegExp.escape(block.fullMatch);
      final match = RegExp(escapedMatch, multiLine: true).firstMatch(markdown);
      if (match != null) {
        blocksWithIndices.add((index: i, block: block, start: match.start));
      }
    }
    
    // Sort by start position in reverse order (end to start)
    // This ensures nested blocks are replaced before outer blocks
    blocksWithIndices.sort((a, b) => b.start.compareTo(a.start));
    
    String processed = markdown;
    for (final item in blocksWithIndices) {
      // Replace the exact match at the found position
      final before = processed.substring(0, item.start);
      final after = processed.substring(item.start + item.block.fullMatch.length);
      processed = '$before\n\n__DETAILS_PLACEHOLDER_${item.index}__\n\n$after';
    }
    return processed;
  }

  /// Extract language information from markdown fenced code blocks
  /// Returns a map of code content to language identifier
  Map<String, String?> _extractLanguagesFromMarkdown(String markdown) {
    final languageMap = <String, String?>{};
    
    // Pattern to match fenced code blocks: ```language\ncode\n```
    final pattern = RegExp(r'```(\w+)?\n([\s\S]*?)```', multiLine: true);
    final matches = pattern.allMatches(markdown);
    
    for (final match in matches) {
      final language = match.group(1);
      final code = match.group(2);
      if (code != null) {
        // Normalize code by removing leading/trailing whitespace for matching
        final normalizedCode = code.trim();
        languageMap[normalizedCode] = language?.trim();
      }
    }
    
    return languageMap;
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

      // Body text - improved line height and spacing
      p: textTheme.bodyLarge?.copyWith(
        color: colors.textColor,
        height: 1.6,
        fontSize: (textTheme.bodyLarge?.fontSize ?? 16),
      ),

      // Links
      a: TextStyle(color: colors.accentColor, decoration: TextDecoration.underline),

      // Lists
      listBullet: textTheme.bodyLarge?.copyWith(color: colors.textColor),

      // Code inline - improved styling with gray background
      code: TextStyle(
        color: colors.textColor,
        backgroundColor: colors.textColor.withValues(alpha: 0.1),
        fontFamily: 'monospace',
        fontSize: (textTheme.bodyMedium?.fontSize ?? 14) * 0.9,
      ),

      // Code blocks (handled by custom builder, no fallback decoration to avoid gray background)
      codeblockDecoration: const BoxDecoration(
        color: Colors.transparent,
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

/// Widget that builds markdown with details blocks inserted
class _MarkdownWithDetailsWidget extends StatelessWidget {
  const _MarkdownWithDetailsWidget({
    required this.markdown,
    required this.detailsBlocks,
    required this.effectiveStyleSheet,
    required this.languageMap,
    required this.selectable,
    required this.shrinkWrap,
    required this.codeTheme,
    required this.showCodeCopyButton,
    this.onTapLink,
    this.maxCodeHeight,
  });

  final String markdown;
  final List<_DetailsBlock> detailsBlocks;
  final MarkdownStyleSheet effectiveStyleSheet;
  final Map<String, String?> languageMap;
  final bool selectable;
  final bool shrinkWrap;
  final void Function(String text, String? href, String title)? onTapLink;
  final CodeDisplayTheme codeTheme;
  final bool showCodeCopyButton;
  final double? maxCodeHeight;

  @override
  Widget build(BuildContext context) {
    if (detailsBlocks.isEmpty) {
      // No details blocks, render normally
      return MarkdownBody(
        data: markdown,
        selectable: selectable,
        shrinkWrap: shrinkWrap,
        onTapLink: onTapLink,
        styleSheet: effectiveStyleSheet,
        builders: {
          'pre': _PreElementBuilder(
            codeTheme: codeTheme,
            showCopyButton: showCodeCopyButton,
            maxHeight: maxCodeHeight,
            languageMap: languageMap,
          ),
          'code': _CodeElementBuilder(
            codeTheme: codeTheme,
            showCopyButton: showCodeCopyButton,
            maxHeight: maxCodeHeight,
            languageMap: languageMap,
          ),
        },
        extensionSet: md.ExtensionSet(md.ExtensionSet.gitHubFlavored.blockSyntaxes, <md.InlineSyntax>[
          md.EmojiSyntax(),
          ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
        ]),
      );
    }

    // Split markdown by placeholders and build widgets
    final placeholderPattern = RegExp(r'__DETAILS_PLACEHOLDER_(\d+)__');
    final segments = <_MarkdownSegment>[];
    
    var lastIndex = 0;
    for (final match in placeholderPattern.allMatches(markdown)) {
      // Add text before placeholder
      if (match.start > lastIndex) {
        final text = markdown.substring(lastIndex, match.start).trim();
        if (text.isNotEmpty) {
          segments.add(_MarkdownSegment(isPlaceholder: false, content: text));
        }
      }
      
      // Extract block index and add placeholder
      final blockIndex = int.tryParse(match.group(1) ?? '');
      if (blockIndex != null) {
        segments.add(_MarkdownSegment(isPlaceholder: true, blockIndex: blockIndex));
      }
      
      lastIndex = match.end;
    }
    
    // Add remaining text
    if (lastIndex < markdown.length) {
      final text = markdown.substring(lastIndex).trim();
      if (text.isNotEmpty) {
        segments.add(_MarkdownSegment(isPlaceholder: false, content: text));
      }
    }

    final widgets = <Widget>[];

    for (final segment in segments) {
      if (segment.isPlaceholder) {
        // Add details block
        final blockIndex = segment.blockIndex!;
        if (blockIndex < detailsBlocks.length) {
          widgets.add(
            _CollapsibleDetails(
              summary: detailsBlocks[blockIndex].summary,
              contentMarkdown: detailsBlocks[blockIndex].content,
              initiallyExpanded: detailsBlocks[blockIndex].isOpen,
            ),
          );
        }
      } else {
        // Add markdown content
        widgets.add(
          MarkdownBody(
            data: segment.content!,
            selectable: selectable,
            shrinkWrap: shrinkWrap,
            onTapLink: onTapLink,
            styleSheet: effectiveStyleSheet,
            builders: {
              'pre': _PreElementBuilder(
                codeTheme: codeTheme,
                showCopyButton: showCodeCopyButton,
                maxHeight: maxCodeHeight,
                languageMap: languageMap,
              ),
              'code': _CodeElementBuilder(
                codeTheme: codeTheme,
                showCopyButton: showCodeCopyButton,
                maxHeight: maxCodeHeight,
                languageMap: languageMap,
              ),
            },
            extensionSet: md.ExtensionSet(md.ExtensionSet.gitHubFlavored.blockSyntaxes, <md.InlineSyntax>[
              md.EmojiSyntax(),
              ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
            ]),
          ),
        );
      }
    }

    if (widgets.isEmpty) {
      return const SizedBox.shrink();
    }

    if (widgets.length == 1) {
      return widgets.first;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: widgets,
    );
  }
}

/// Custom builder for pre elements (code blocks)
class _PreElementBuilder extends MarkdownElementBuilder {
  _PreElementBuilder({
    required this.codeTheme,
    required this.showCopyButton,
    this.maxHeight,
    this.languageMap,
  });

  final CodeDisplayTheme codeTheme;
  final bool showCopyButton;
  final double? maxHeight;
  final Map<String, String?>? languageMap;
  final Map<md.Element, String?> _languageCache = {};

  @override
  void visitElementBefore(md.Element element) {
    // Try to extract language from info string before processing
    // Check both 'pre' and 'code' elements
    if (element.tag == 'pre' || element.tag == 'code') {
      // Check info attribute
      if (element.attributes.containsKey('info')) {
        final info = element.attributes['info'];
        if (info != null && info.isNotEmpty) {
          final parts = info.split(RegExp(r'[\s:]'));
          if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
            _languageCache[element] = parts[0].trim();
          }
        }
      }
      // Also check class attribute for language-xxx pattern
      final classAttr = element.attributes['class'];
      if (classAttr != null) {
        final match = RegExp(r'language-(\w+)').firstMatch(classAttr);
        if (match != null) {
          _languageCache[element] = match.group(1);
        }
      }
    }
  }

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    // Pre elements contain code blocks
    if (element.tag == 'pre') {
      // Find the code element inside
      md.Element? codeElement;
      if (element.children != null) {
        for (final child in element.children!) {
          if (child is md.Element && child.tag == 'code') {
            codeElement = child;
            break;
          }
        }
      }

      if (codeElement != null && codeElement.textContent.contains('\n')) {
        final code = codeElement.textContent.trim();
        
        // Try to get language from pre-extracted map first
        final language = languageMap?[code] ??
        
                         _languageCache[codeElement] ?? 
                         _languageCache[element] ?? 
                         _extractLanguage(codeElement, element);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
          child: CodeDisplayBlock(
            code: code,
            language: language,
            theme: codeTheme,
            size: CodeDisplaySize.small,
            showCopyButton: showCopyButton,
            maxHeight: maxHeight,
            transparentBackground: true, // Remove frame in chat messages
          ),
        );
      }
    }

    return null;
  }

  String? _extractLanguage(md.Element codeElement, md.Element preElement) {
    // Try multiple methods to extract language:
    // 1. Check the pre element's class attribute (most common)
    final preClass = preElement.attributes['class'];
    if (preClass != null) {
      final match = RegExp(r'language-(\w+)').firstMatch(preClass);
      if (match != null) {
        return match.group(1);
      }
    }

    // 2. Check the code element's class attribute
    final codeClass = codeElement.attributes['class'];
    if (codeClass != null) {
      final match = RegExp(r'language-(\w+)').firstMatch(codeClass);
      if (match != null) {
        return match.group(1);
      }
    }

    // 3. Check for language in data-language attribute
    final dataLanguage = codeElement.attributes['data-language'] ?? preElement.attributes['data-language'];
    if (dataLanguage != null && dataLanguage.isNotEmpty) {
      return dataLanguage;
    }

    // 4. Check info attribute on both elements
    final preInfo = preElement.attributes['info'];
    if (preInfo != null && preInfo.isNotEmpty) {
      final parts = preInfo.split(RegExp(r'[\s:]'));
      if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
        return parts[0].trim();
      }
    }
    
    final codeInfo = codeElement.attributes['info'];
    if (codeInfo != null && codeInfo.isNotEmpty) {
      final parts = codeInfo.split(RegExp(r'[\s:]'));
      if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
        return parts[0].trim();
      }
    }

    return null;
  }
}

/// Custom builder for code elements that uses our CodeDisplayBlock component
class _CodeElementBuilder extends MarkdownElementBuilder {
  _CodeElementBuilder({
    required this.codeTheme,
    required this.showCopyButton,
    this.maxHeight,
    this.languageMap,
  });

  final CodeDisplayTheme codeTheme;
  final bool showCopyButton;
  final double? maxHeight;
  final Map<String, String?>? languageMap;

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    // Handle code blocks (not inline code)
    if (element.tag == 'code' && element.textContent.contains('\n')) {
      final code = element.textContent.trim();
      
      // Try to get language from pre-extracted map first, then fallback to extraction
      final language = languageMap?[code] ?? _extractLanguage(element);

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
        child: CodeDisplayBlock(
          code: code,
          language: language,
          theme: codeTheme,
          size: CodeDisplaySize.small,
          showCopyButton: showCopyButton,
          maxHeight: maxHeight,
          transparentBackground: true, // Remove frame in chat messages
        ),
      );
    }

    return null;
  }

  String? _extractLanguage(md.Element element) {
    // Try multiple methods to extract language:
    // 1. Check the code element's class attribute (e.g., "language-dart")
    final classAttribute = element.attributes['class'];
    if (classAttribute != null) {
      final match = RegExp(r'language-(\w+)').firstMatch(classAttribute);
      if (match != null) {
        return match.group(1);
      }
    }

    // 2. Check for language in data-language attribute
    final dataLanguage = element.attributes['data-language'];
    if (dataLanguage != null && dataLanguage.isNotEmpty) {
      return dataLanguage;
    }

    // 3. Check for language in info attribute (used by some markdown parsers)
    final info = element.attributes['info'];
    if (info != null && info.isNotEmpty) {
      // Info string might be like "dart" or "dart:main.dart"
      final parts = info.split(':');
      if (parts.isNotEmpty && parts[0].trim().isNotEmpty) {
        return parts[0].trim();
      }
    }

    return null;
  }
}

/// Represents a details block extracted from markdown
class _DetailsBlock {
  const _DetailsBlock({
    required this.fullMatch,
    required this.summary,
    required this.content,
    required this.isOpen,
  });

  final String fullMatch;
  final String summary;
  final String content;
  final bool isOpen;
}

/// Represents a segment of markdown (either text or placeholder)
class _MarkdownSegment {
  const _MarkdownSegment({
    required this.isPlaceholder,
    this.content,
    this.blockIndex,
  });

  final bool isPlaceholder;
  final String? content;
  final int? blockIndex;
}


/// Widget that renders a collapsible details section
class _CollapsibleDetails extends StatefulWidget {
  const _CollapsibleDetails({
    required this.summary,
    required this.contentMarkdown,
    this.initiallyExpanded = false,
  });

  final String summary;
  final String contentMarkdown;
  final bool initiallyExpanded;

  @override
  State<_CollapsibleDetails> createState() => _CollapsibleDetailsState();
}

class _CollapsibleDetailsState extends State<_CollapsibleDetails> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.spacingXs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.inputBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          border: Border.all(color: colors.borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Summary header (clickable)
            InkWell(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(AppDimensions.radiusS),
                topRight: const Radius.circular(AppDimensions.radiusS),
                bottomLeft: _isExpanded ? Radius.zero : const Radius.circular(AppDimensions.radiusS),
                bottomRight: _isExpanded ? Radius.zero : const Radius.circular(AppDimensions.radiusS),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingM,
                  vertical: AppDimensions.spacingS,
                ),
                child: Row(
                  children: [
                    Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                    const SizedBox(width: AppDimensions.spacingXs),
                    Expanded(
                      child: Text(
                        widget.summary,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colors.textColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content (collapsible) - render as markdown
            if (_isExpanded && widget.contentMarkdown.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppDimensions.spacingM,
                  0,
                  AppDimensions.spacingM,
                  AppDimensions.spacingM,
                ),
                child: MarkdownRenderer(
                  data: widget.contentMarkdown,
                  shrinkWrap: true,
                  selectable: false,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
