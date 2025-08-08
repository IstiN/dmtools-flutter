import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool enableMarkdown;

  ChatMessage({required this.message, required this.isUser, DateTime? timestamp, this.enableMarkdown = true})
    : timestamp = timestamp ?? DateTime.now();
}

/// Interactive chat interface widget with message display and input functionality.
/// Provides a complete chat experience with message bubbles, input field, and optional header.
class ChatInterface extends StatefulWidget {
  final List<ChatMessage> messages;
  final Function(String) onSendMessage;
  final VoidCallback? onAttachmentPressed;
  final bool showHeader;
  final String title;
  final bool isLoading;

  /// Used in tests to override theme detection for predictable rendering
  final bool? isTestMode;

  /// Theme to use when isTestMode is true
  final bool? testDarkMode;

  const ChatInterface({
    required this.messages,
    required this.onSendMessage,
    super.key,
    this.onAttachmentPressed,
    this.showHeader = true,
    this.title = 'Chat',
    this.isLoading = false,
    this.isTestMode,
    this.testDarkMode,
  });

  @override
  ChatInterfaceState createState() => ChatInterfaceState();
}

class ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(ChatInterface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      widget.onSendMessage(message);
      _messageController.clear();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          // Header
          if (widget.showHeader)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.accentColor,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.chat, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    widget.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),

          // Messages area
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: widget.messages.length,
              itemBuilder: (context, index) {
                final message = widget.messages[index];
                return _buildMessageBubble(message, colors);
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.cardBg,
              border: Border(top: BorderSide(color: colors.borderColor)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.attach_file, color: colors.textSecondary),
                  onPressed: widget.onAttachmentPressed,
                ),
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    style: TextStyle(color: colors.textColor),
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(color: colors.textMuted),
                      filled: true,
                      fillColor: colors.inputBg,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 16),
                PrimaryButton(
                  text: 'Send',
                  onPressed: _sendMessage,
                  icon: Icons.send,
                  isLoading: _isLoading,
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: context.isDarkMode,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, dynamic colors) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: message.isUser ? colors.secondaryColor : colors.bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * ResponsiveBreakpoints.chatMaxWidthBreakpoint,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            message.enableMarkdown
                ? MarkdownRenderer(
                    data: message.message,
                    shrinkWrap: true,
                    selectable: false,
                    styleSheet: _buildMessageMarkdownStyleSheet(context, message.isUser, colors),
                  )
                : Text(message.message, style: TextStyle(color: message.isUser ? Colors.white : colors.textColor)),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: message.isUser ? Colors.white.withValues(alpha: 0.7) : colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  MarkdownStyleSheet _buildMessageMarkdownStyleSheet(BuildContext context, bool isUser, dynamic colors) {
    final theme = Theme.of(context);
    final textColor = isUser ? Colors.white : colors.textColor;

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
        color: isUser ? Colors.black.withValues(alpha: 0.2) : colors.inputBg,
        borderRadius: BorderRadius.circular(4),
      ),
      blockquote: theme.textTheme.bodyLarge?.copyWith(
        color: textColor.withValues(alpha: 0.8),
        fontStyle: FontStyle.italic,
      ),
      listBullet: theme.textTheme.bodyLarge?.copyWith(color: textColor),
      a: theme.textTheme.bodyLarge?.copyWith(
        color: isUser ? Colors.white : colors.accentColor,
        decoration: TextDecoration.underline,
      ),
    );
  }
}
