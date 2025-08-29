import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
/// Provides a complete chat experience with message bubbles, input field, AI integration selection, and optional header.
class ChatInterface extends StatefulWidget {
  final List<ChatMessage> messages;
  final Function(String) onSendMessage;
  final VoidCallback? onAttachmentPressed;
  final bool showHeader;
  final String title;
  final bool isLoading;

  /// AI integration selection
  final List<AiIntegration> aiIntegrations;
  final AiIntegration? selectedAiIntegration;
  final ValueChanged<AiIntegration?>? onAiIntegrationChanged;

  /// File attachment support
  final List<FileAttachment> attachments;
  final ValueChanged<List<FileAttachment>>? onAttachmentsChanged;
  final bool isUploadingFiles;
  final double? uploadProgress;

  /// Text insertion callback (called when text should be inserted into input field)
  final ValueChanged<String>? onTextInsert;

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
    this.aiIntegrations = const [],
    this.selectedAiIntegration,
    this.onAiIntegrationChanged,
    this.attachments = const [],
    this.onAttachmentsChanged,
    this.isUploadingFiles = false,
    this.uploadProgress,
    this.onTextInsert,
    this.isTestMode,
    this.testDarkMode,
  });

  @override
  ChatInterfaceState createState() => ChatInterfaceState();
}

class ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _messageController = TextEditingController();

  /// Insert text into the message input field
  void insertText(String text) {
    final currentText = _messageController.text;
    final currentSelection = _messageController.selection;

    String newText;
    int newCursorPosition;

    if (currentSelection.isValid) {
      // Replace selected text or insert at cursor position
      newText = currentText.replaceRange(currentSelection.start, currentSelection.end, text);
      newCursorPosition = currentSelection.start + text.length;
    } else {
      // Append to end
      newText = currentText + text;
      newCursorPosition = newText.length;
    }

    _messageController.text = newText;
    _messageController.selection = TextSelection.collapsed(offset: newCursorPosition);

    // Notify parent if callback is provided
    widget.onTextInsert?.call(text);
  }

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

  void _showAiIntegrationMenu(BuildContext buttonContext) {
    final RenderBox button = buttonContext.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(buttonContext).overlay!.context.findRenderObject() as RenderBox;

    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = button.size;

    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx, // Left edge aligned with button
      buttonPosition.dy + buttonSize.height + 4, // Below button with small gap
      buttonPosition.dx + 200, // Right edge 200px from left (menu width)
      buttonPosition.dy + buttonSize.height + 300, // Bottom edge (max menu height)
    );

    showMenu<AiIntegration>(
      context: buttonContext,
      position: position,
      items: widget.aiIntegrations.map((integration) {
        return PopupMenuItem<AiIntegration>(
          value: integration,
          child: Row(
            children: [
              IntegrationTypeIcon(
                integrationType: integration.type,
                size: 16,
                isTestMode: widget.isTestMode,
                testDarkMode: widget.testDarkMode,
              ),
              const SizedBox(width: 8),
              Text(integration.displayName),
              if (widget.selectedAiIntegration?.id == integration.id) ...[
                const Spacer(),
                Icon(Icons.check, size: 16, color: context.colorsListening.accentColor),
              ],
            ],
          ),
        );
      }).toList(),
    ).then((selectedIntegration) {
      if (selectedIntegration != null) {
        widget.onAiIntegrationChanged?.call(selectedIntegration);
      }
    });
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
            child: Column(
              children: [
                // Attachments display (only shows when there are attachments or uploading)
                FileAttachmentPicker(
                  attachments: widget.attachments,
                  onAttachmentsChanged: widget.onAttachmentsChanged,
                  onAttachmentPressed: widget.onAttachmentPressed,
                  isLoading: widget.isUploadingFiles,
                  uploadProgress: widget.uploadProgress,
                  isTestMode: widget.isTestMode,
                  testDarkMode: widget.testDarkMode,
                ),

                // Input row with enhanced layout: [📎] [🤖 AI ▼] [Type a message... 📤]
                Row(
                  children: [
                    // AI integration selector icon (first)
                    if (widget.aiIntegrations.isNotEmpty || widget.selectedAiIntegration != null) ...[
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Builder(
                          builder: (context) => IconButton(
                            padding: EdgeInsets.zero,
                            icon: SizedBox(
                              height: 20,
                              width: 20,
                              child: widget.selectedAiIntegration != null
                                  ? IntegrationTypeIcon(
                                      integrationType: widget.selectedAiIntegration!.type,
                                      size: 20,
                                      isTestMode: widget.isTestMode,
                                      testDarkMode: widget.testDarkMode,
                                    )
                                  : Icon(Icons.smart_toy_outlined, color: colors.textSecondary, size: 20),
                            ),
                            onPressed: () => _showAiIntegrationMenu(context),
                            tooltip: widget.selectedAiIntegration?.displayName ?? 'Select AI Integration',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // File attachment button (second)
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.attach_file, color: colors.textSecondary, size: 20),
                        onPressed: widget.onAttachmentPressed,
                        tooltip: 'Attach files',
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Message input field with integrated send icon
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minHeight: 40,
                          maxHeight: 120, // Max 3 lines approximately
                        ),
                        child: CallbackShortcuts(
                          bindings: <ShortcutActivator, VoidCallback>{
                            const SingleActivator(LogicalKeyboardKey.enter): () {
                              // Enter alone - send message
                              _sendMessage();
                            },
                          },
                          child: TextField(
                            controller: _messageController,
                            style: TextStyle(color: colors.textColor, fontSize: 14),
                            // Single line input - Enter sends message
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              // Enter pressed - send message (backup)
                              _sendMessage();
                            },
                            onChanged: (value) {
                              // Trigger rebuild to show/hide send icon based on text
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: colors.textMuted, fontSize: 14),
                              filled: true,
                              fillColor: colors.inputBg,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                borderSide: BorderSide(color: colors.borderColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                borderSide: BorderSide(color: colors.borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                                borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
                              ),
                              suffixIcon: _messageController.text.trim().isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.send, color: colors.accentColor, size: 20),
                                      onPressed: (_isLoading || widget.isLoading) ? null : _sendMessage,
                                      tooltip: 'Send message',
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
            // Message content with copy button
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: message.enableMarkdown
                      ? MarkdownRenderer(
                          data: message.message,
                          shrinkWrap: true,
                          selectable: false,
                          styleSheet: _buildMessageMarkdownStyleSheet(context, message.isUser, colors),
                        )
                      : Text(
                          message.message,
                          style: TextStyle(color: message.isUser ? Colors.white : colors.textColor),
                        ),
                ),
                const SizedBox(width: 8),
                // Copy button
                IconButton(
                  icon: Icon(
                    Icons.copy,
                    size: 16,
                    color: message.isUser ? Colors.white.withValues(alpha: 0.7) : colors.textSecondary,
                  ),
                  onPressed: () => _copyMessageToClipboard(message.message),
                  tooltip: 'Copy message',
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
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

  /// Copy message content to clipboard
  void _copyMessageToClipboard(String message) {
    Clipboard.setData(ClipboardData(text: message));

    // Show a brief confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Message copied to clipboard'),
        duration: const Duration(seconds: 2),
        backgroundColor: context.colorsListening.accentColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
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
