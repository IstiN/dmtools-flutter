import 'package:flutter/material.dart';
import 'package:highlight/highlight.dart' as hl;

/// Syntax highlighter with color scheme matching modern code editors
/// Uses flutter_highlight package (works on all platforms including macOS)
/// Colors inspired by the second screen design and Andromeda theme
class SyntaxHighlighter {
  /// Color scheme for syntax highlighting
  static const Color keywordColor = Color(0xFFC678DD); // Vibrant pink/magenta
  static const Color classColor = Color(0xFF61AFEF); // Light blue
  static const Color methodColor = Color(0xFFE5C07B); // Light orange/yellow
  static const Color stringColor = Color(0xFF98C379); // Light green
  static const Color punctuationColorDark = Color(0xFFFFFFFF); // White for dark theme
  static const Color punctuationColorLight = Color(0xFF24292E); // Dark for light theme
  static const Color commentColor = Color(0xFF5C6370); // Gray for comments
  static const Color numberColor = Color(0xFFD19A66); // Orange for numbers
  static const Color defaultColor = Color(0xFFE1E4E8); // Default text color (dark theme)
  static const Color defaultColorLight = Color(0xFF24292E); // Default text color (light theme)
  
  // Make defaultColor accessible for comparison
  static Color get defaultTextColor => defaultColor;

  /// Get custom theme map for syntax highlighting
  /// Based on flutter_highlight's theme structure but with our custom colors
  static Map<String, TextStyle> _getCustomTheme({required bool isLight}) {
    final punctuationColor = isLight ? punctuationColorLight : punctuationColorDark;
    final defaultTextColor = isLight ? defaultColorLight : defaultColor;
    
    return {
      'keyword': TextStyle(color: isLight ? const Color(0xFFA626A4) : keywordColor),
      'built_in': TextStyle(color: isLight ? const Color(0xFFA626A4) : keywordColor),
      'literal': TextStyle(color: isLight ? const Color(0xFFA626A4) : keywordColor),
      'type': TextStyle(color: isLight ? const Color(0xFFA626A4) : keywordColor),
      'boolean': TextStyle(color: isLight ? const Color(0xFFA626A4) : keywordColor),
      'class': TextStyle(color: isLight ? const Color(0xFF005CC5) : classColor),
      'title.class': TextStyle(color: isLight ? const Color(0xFF005CC5) : classColor),
      'title.class.inherited': TextStyle(color: isLight ? const Color(0xFF005CC5) : classColor),
      'title': TextStyle(color: isLight ? const Color(0xFF005CC5) : classColor),
      'function': TextStyle(color: isLight ? const Color(0xFFE36209) : methodColor),
      'title.function': TextStyle(color: isLight ? const Color(0xFFE36209) : methodColor),
      'title.function.invoke': TextStyle(color: isLight ? const Color(0xFFE36209) : methodColor),
      'property': TextStyle(color: isLight ? const Color(0xFFE36209) : methodColor),
      'attr': TextStyle(color: isLight ? const Color(0xFF005CC5) : stringColor), // JSON keys
      'string': TextStyle(color: isLight ? const Color(0xFF032F62) : stringColor),
      'char': TextStyle(color: isLight ? const Color(0xFF032F62) : stringColor),
      'template-string': TextStyle(color: isLight ? const Color(0xFF032F62) : stringColor),
      'comment': const TextStyle(color: commentColor),
      'number': TextStyle(color: isLight ? const Color(0xFF005CC5) : numberColor),
      'punctuation': TextStyle(color: punctuationColor),
      'operator': TextStyle(color: punctuationColor),
      'symbol': TextStyle(color: punctuationColor),
      // Default text color
      '': TextStyle(color: defaultTextColor),
    };
  }

  /// Highlight code with syntax highlighting using flutter_highlight package
  static List<TextSpan> highlight(String code, String? language, {bool isLightTheme = false}) {
    if (language == null || language.isEmpty) {
      final defaultTextColor = isLightTheme ? defaultColorLight : defaultColor;
      return [TextSpan(text: code, style: TextStyle(color: defaultTextColor))];
    }

    try {
      // Normalize language name
      final normalizedLanguage = language.toLowerCase().trim();
      
      // For bash/shell, use fallback highlighting
      if (normalizedLanguage == 'bash' || normalizedLanguage == 'sh' || normalizedLanguage == 'shell') {
        return _highlightBashFallback(code, isLightTheme);
      }
      
      // Map common language aliases
      final mappedLanguage = _mapLanguage(normalizedLanguage);
      
      // Parse code using highlight package
      final result = hl.highlight.parse(code, language: mappedLanguage);
      final nodes = result.nodes ?? [];
      
      if (nodes.isEmpty) {
        final defaultTextColor = isLightTheme ? defaultColorLight : defaultColor;
        return [TextSpan(text: code, style: TextStyle(color: defaultTextColor))];
      }
      
      // Get custom theme
      final theme = _getCustomTheme(isLight: isLightTheme);
      
      // Convert nodes to TextSpans with our custom theme
      final spans = _convertNodes(nodes, theme, isLightTheme);
      
      // Debug: log first few class names to see what we're getting
      if (spans.isNotEmpty && spans.length <= 5) {
        debugPrint('SyntaxHighlighter: Language $mappedLanguage generated ${spans.length} spans');
        for (var i = 0; i < spans.length && i < 3; i++) {
          final span = spans[i];
          debugPrint('  Span $i: text="${span.text?.substring(0, span.text!.length > 20 ? 20 : span.text!.length)}", color=${span.style?.color}');
        }
      }
      
      return spans;
    } catch (e) {
      // If highlighting fails, return plain text
      final defaultTextColor = isLightTheme ? defaultColorLight : defaultColor;
      return [TextSpan(text: code, style: TextStyle(color: defaultTextColor))];
    }
  }

  /// Convert highlight nodes to TextSpans with custom theme
  /// Based on flutter_highlight's internal conversion logic
  static List<TextSpan> _convertNodes(
    List<hl.Node> nodes,
    Map<String, TextStyle> theme,
    bool isLightTheme,
  ) {
    final spans = <TextSpan>[];
    final defaultTextColor = isLightTheme ? defaultColorLight : defaultColor;

    void traverse(hl.Node node, {String? parentClassName}) {
      // Get class name from this node or use parent's class name
      final className = node.className ?? parentClassName;
      
      if (node.value != null) {
        // Leaf node with text
        // Debug: log class names for first few nodes
        if (spans.length < 10 && className != null && className.isNotEmpty) {
          debugPrint('SyntaxHighlighter: Node className="$className", value="${node.value?.substring(0, node.value!.length > 30 ? 30 : node.value!.length)}"');
        }
        
        // Try to find style for this class, or use default
        TextStyle? style;
        if (className != null && className.isNotEmpty) {
          // Try exact match first
          style = theme[className];
          // If not found, try partial matches (e.g., "title.class" for "class")
          if (style == null) {
            final parts = className.split('.');
            for (var i = parts.length; i > 0; i--) {
              final key = parts.sublist(0, i).join('.');
              style = theme[key];
              if (style != null) break;
            }
          }
          // If still not found, try common aliases
          if (style == null) {
            if (className.contains('keyword')) {
              style = theme['keyword'];
            } else if (className.contains('string')) {
              style = theme['string'];
            } else if (className.contains('number')) {
              style = theme['number'];
            } else if (className.contains('comment')) {
              style = theme['comment'];
            } else if (className.contains('class') || className.contains('type')) {
              style = theme['class'];
            } else if (className.contains('function') || className.contains('method')) {
              style = theme['function'];
            }
          }
        }
        
        // Always create a span with a style (even if it's default)
        // This ensures we have a style object for color comparison
        final finalStyle = style ?? TextStyle(color: defaultTextColor);
        spans.add(
          TextSpan(
            text: node.value,
            style: finalStyle,
          ),
        );
      } else if (node.children != null) {
        // Node with children - process recursively, passing class name down
        final currentClassName = node.className ?? parentClassName;
        for (final child in node.children!) {
          traverse(child, parentClassName: currentClassName);
        }
      }
    }

    for (final node in nodes) {
      traverse(node);
    }

    // If no spans were created, return plain text
    if (spans.isEmpty) {
      return [TextSpan(text: '', style: TextStyle(color: defaultTextColor))];
    }
    
    // Filter out empty spans
    final filteredSpans = spans.where((span) => span.text != null && span.text!.isNotEmpty).toList();
    
    return filteredSpans.isEmpty 
        ? [TextSpan(text: '', style: TextStyle(color: defaultTextColor))] 
        : filteredSpans;
  }

  /// Map common language names to highlight package supported names
  static String _mapLanguage(String language) {
    final languageMap = {
      'js': 'javascript',
      'ts': 'typescript',
      'py': 'python',
      'kt': 'kotlin',
      'yml': 'yaml',
      'json': 'json',
      'dart': 'dart',
      'java': 'java',
      'html': 'xml', // highlight uses 'xml' for HTML
      'css': 'css',
      'sql': 'sql',
      'go': 'go',
      'rust': 'rust',
      'swift': 'swift',
      'cpp': 'cpp',
      'c': 'c',
      'csharp': 'cs',
      'cs': 'cs',
      'php': 'php',
      'ruby': 'ruby',
      'scala': 'scala',
    };
    
    return languageMap[language] ?? language;
  }

  /// Fallback highlighting for bash/shell scripts
  static List<TextSpan> _highlightBashFallback(String code, bool isLight) {
    final spans = <TextSpan>[];
    final bashKeywordColor = isLight ? const Color(0xFFA626A4) : keywordColor;
    final bashStringColor = isLight ? const Color(0xFF032F62) : stringColor;
    final bashDefaultTextColor = isLight ? defaultColorLight : defaultColor;
    
    // Simple regex-based highlighting for bash
    final keywordPattern = RegExp(r'\b(curl|echo|export|if|then|else|fi|for|while|do|done|function|return|POST|GET|PUT|DELETE|HEAD|OPTIONS|PATCH|X|H|d)\b');
    final stringPattern = RegExp('"[^"]*"|\'[^\']*\'');
    
    var lastIndex = 0;
    
    // Find all matches
    final allMatches = <_BashMatch>[];
    for (final match in keywordPattern.allMatches(code)) {
      allMatches.add(_BashMatch(match.start, match.end, 'keyword'));
    }
    for (final match in stringPattern.allMatches(code)) {
      allMatches.add(_BashMatch(match.start, match.end, 'string'));
    }
    
    // Sort by position
    allMatches.sort((a, b) => a.start.compareTo(b.start));
    
    // Build spans
    for (final match in allMatches) {
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: code.substring(lastIndex, match.start), style: TextStyle(color: bashDefaultTextColor)));
      }
      final color = match.type == 'keyword' ? bashKeywordColor : bashStringColor;
      spans.add(TextSpan(text: code.substring(match.start, match.end), style: TextStyle(color: color)));
      lastIndex = match.end;
    }
    
    if (lastIndex < code.length) {
      spans.add(TextSpan(text: code.substring(lastIndex), style: TextStyle(color: bashDefaultTextColor)));
    }
    
    return spans.isEmpty ? [TextSpan(text: code, style: TextStyle(color: bashDefaultTextColor))] : spans;
  }
}

class _BashMatch {
  final int start;
  final int end;
  final String type;
  _BashMatch(this.start, this.end, this.type);
}
