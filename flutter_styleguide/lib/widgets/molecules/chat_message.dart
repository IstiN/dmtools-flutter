import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

enum MessageSender { user, agent, system }

class ChatMessage extends StatelessWidget {
  final String text;
  final MessageSender sender;
  final bool enableMarkdown;

  const ChatMessage({required this.text, required this.sender, this.enableMarkdown = true, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (sender == MessageSender.system) {
      return _buildSystemMessage(context);
    }

    final isUser = sender == MessageSender.user;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[const CircleAvatar(child: Icon(Icons.smart_toy_outlined)), const SizedBox(width: 8)],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: _getBackgroundColor(theme, context),
                borderRadius: BorderRadius.circular(20),
                border: sender == MessageSender.agent ? Border.all(color: theme.dividerColor) : null,
              ),
              child: enableMarkdown
                  ? MarkdownRenderer(
                      data: text,
                      shrinkWrap: true,
                      selectable: false,
                      styleSheet: _buildMarkdownStyleSheet(context),
                    )
                  : Text(text, style: TextStyle(color: _getTextColor(theme))),
            ),
          ),
          if (isUser) ...[const SizedBox(width: 8), const CircleAvatar(child: Icon(Icons.person_outline))],
        ],
      ),
    );
  }

  Widget _buildSystemMessage(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      alignment: Alignment.center,
      child: enableMarkdown
          ? MarkdownRenderer(
              data: text,
              shrinkWrap: true,
              selectable: false,
              styleSheet: _buildSystemMarkdownStyleSheet(context),
            )
          : Text(text, style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor)),
    );
  }

  Color _getBackgroundColor(ThemeData theme, BuildContext context) {
    final colors = context.colors;

    switch (sender) {
      case MessageSender.user:
        return colors.secondaryColor;
      case MessageSender.agent:
        return theme.cardColor;
      case MessageSender.system:
        return Colors.transparent;
    }
  }

  Color? _getTextColor(ThemeData theme) {
    switch (sender) {
      case MessageSender.user:
        return theme.colorScheme.onPrimary;
      default:
        return theme.textTheme.bodyLarge?.color;
    }
  }

  MarkdownStyleSheet _buildMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    final colors = context.colors;
    final textColor = _getTextColor(theme);

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: theme.textTheme.bodyLarge?.copyWith(color: textColor),
      h1: theme.textTheme.headlineLarge?.copyWith(color: textColor, fontWeight: FontWeight.bold),
      h2: theme.textTheme.headlineMedium?.copyWith(color: textColor, fontWeight: FontWeight.bold),
      h3: theme.textTheme.headlineSmall?.copyWith(color: textColor, fontWeight: FontWeight.w600),
      h4: theme.textTheme.titleLarge?.copyWith(color: textColor, fontWeight: FontWeight.w600),
      h5: theme.textTheme.titleMedium?.copyWith(color: textColor, fontWeight: FontWeight.w600),
      h6: theme.textTheme.titleSmall?.copyWith(color: textColor, fontWeight: FontWeight.w600),
      code: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontFamily: 'monospace',
        backgroundColor: Colors.transparent,
      ),
      codeblockDecoration: BoxDecoration(
        color: sender == MessageSender.user ? Colors.black.withValues(alpha: 0.2) : colors.inputBg,
        borderRadius: BorderRadius.circular(4),
      ),
      blockquote: theme.textTheme.bodyLarge?.copyWith(
        color: textColor?.withValues(alpha: 0.8),
        fontStyle: FontStyle.italic,
      ),
      listBullet: theme.textTheme.bodyLarge?.copyWith(color: textColor),
    );
  }

  MarkdownStyleSheet _buildSystemMarkdownStyleSheet(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = theme.textTheme.bodySmall?.copyWith(color: theme.hintColor);

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p: baseStyle,
      h1: baseStyle?.copyWith(fontWeight: FontWeight.bold, fontSize: (baseStyle.fontSize ?? 12) * 1.4),
      h2: baseStyle?.copyWith(fontWeight: FontWeight.bold, fontSize: (baseStyle.fontSize ?? 12) * 1.3),
      h3: baseStyle?.copyWith(fontWeight: FontWeight.w600, fontSize: (baseStyle.fontSize ?? 12) * 1.2),
      h4: baseStyle?.copyWith(fontWeight: FontWeight.w600, fontSize: (baseStyle.fontSize ?? 12) * 1.1),
      h5: baseStyle?.copyWith(fontWeight: FontWeight.w600),
      h6: baseStyle?.copyWith(fontWeight: FontWeight.w600),
      code: baseStyle?.copyWith(fontFamily: 'monospace'),
      blockquote: baseStyle?.copyWith(fontStyle: FontStyle.italic),
      listBullet: baseStyle,
    );
  }
}
