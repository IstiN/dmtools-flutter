import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class ChatMessage {
  final String message;
  final bool isUser;
  final DateTime timestamp;
  final bool enableMarkdown;
  final List<FileAttachment> attachments;

  ChatMessage({
    required this.message,
    required this.isUser,
    DateTime? timestamp,
    this.enableMarkdown = true,
    this.attachments = const [],
  }) : timestamp = timestamp ?? DateTime.now();
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

  /// Message editing callbacks
  final Function(int messageIndex, String newContent)? onMessageEdit;

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
    this.onMessageEdit,
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
    // Scroll to bottom when new messages are added or loading state changes
    if (widget.messages.length > oldWidget.messages.length || widget.isLoading != oldWidget.isLoading) {
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
              itemCount: widget.messages.length + (widget.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index < widget.messages.length) {
                  final message = widget.messages[index];
                  return _buildMessageBubble(message, colors, index);
                } else {
                  // Show loading indicator as the last item
                  return _buildLoadingBubble(colors);
                }
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

  Widget _buildMessageBubble(ChatMessage message, dynamic colors, int index) {
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
                // Message actions menu
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 16,
                    color: message.isUser ? Colors.white.withValues(alpha: 0.7) : colors.textSecondary,
                  ),
                  tooltip: 'Message actions',
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context) => [
                    const PopupMenuItem<String>(
                      value: 'copy',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.copy, size: 16), SizedBox(width: 8), Text('Copy')],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit')],
                      ),
                    ),
                  ],
                  onSelected: (value) => _handleMessageAction(value, index, message),
                ),
              ],
            ),
            // Show file attachments if any
            if (message.attachments.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: message.attachments.map((attachment) => _buildFileTag(attachment, colors)).toList(),
              ),
            ],
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

  Widget _buildLoadingBubble(dynamic colors) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(color: colors.borderColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const BouncingDotsIndicator(size: 8.0),
            const SizedBox(width: 8.0),
            Text(
              'AI is thinking...',
              style: TextStyle(color: colors.textSecondary, fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFileTag(FileAttachment attachment, dynamic colors) {
    // Beautiful, modern color scheme for different file types
    Color tagColor;
    IconData icon;

    if (attachment.type.startsWith('image/')) {
      // Vibrant purple for images - eye-catching and modern
      tagColor = const Color(0xFF9333EA);
      icon = Icons.image_outlined;
    } else if (attachment.type.contains('pdf')) {
      // Bold red for PDFs - professional and recognizable
      tagColor = const Color(0xFFDC2626);
      icon = Icons.picture_as_pdf_outlined;
    } else if (attachment.type.contains('text') ||
        attachment.type.contains('json') ||
        attachment.type.contains('code')) {
      // Rich blue for code/text files - tech and trustworthy
      tagColor = const Color(0xFF2563EB);
      icon = Icons.code_outlined;
    } else if (attachment.type.contains('zip') || attachment.type.contains('archive')) {
      // Bright orange for archives - highly visible
      tagColor = const Color(0xFFEA580C);
      icon = Icons.folder_zip_outlined;
    } else if (attachment.type.contains('video')) {
      // Hot pink for videos - creative and energetic
      tagColor = const Color(0xFFDB2777);
      icon = Icons.videocam_outlined;
    } else if (attachment.type.contains('audio')) {
      // Strong teal for audio - distinctive and calming
      tagColor = const Color(0xFF0891B2);
      icon = Icons.audiotrack_outlined;
    } else {
      // Deep slate for unknown files - visible but not overwhelming
      tagColor = const Color(0xFF475569);
      icon = Icons.insert_drive_file_outlined;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: tagColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            _truncateFileName(attachment.name),
            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  String _truncateFileName(String fileName) {
    if (fileName.length <= 20) return fileName;

    final parts = fileName.split('.');
    if (parts.length > 1) {
      final name = parts.sublist(0, parts.length - 1).join('.');
      final extension = parts.last;

      if (name.length > 15) {
        return '${name.substring(0, 12)}....$extension';
      }
    }

    return fileName.length > 20 ? '${fileName.substring(0, 17)}...' : fileName;
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

  /// Handle message action menu selection
  void _handleMessageAction(String action, int messageIndex, ChatMessage message) {
    switch (action) {
      case 'copy':
        _copyMessageToClipboard(message.message);
        break;
      case 'edit':
        _showEditMessageDialog(messageIndex, message);
        break;
    }
  }

  /// Show dialog to edit message content
  void _showEditMessageDialog(int messageIndex, ChatMessage message) {
    showDialog(
      context: context,
      builder: (context) => _MessageEditDialog(
        message: message,
        onSave: (newContent) {
          widget.onMessageEdit?.call(messageIndex, newContent);
        },
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

/// Dialog for editing message content with markdown support
class _MessageEditDialog extends StatefulWidget {
  final ChatMessage message;
  final ValueChanged<String> onSave;

  const _MessageEditDialog({required this.message, required this.onSave});

  @override
  State<_MessageEditDialog> createState() => _MessageEditDialogState();
}

class _MessageEditDialogState extends State<_MessageEditDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message.message);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _insertMarkdown(String before, String after, {String? placeholder}) {
    final text = _controller.text;
    final selection = _controller.selection;

    String selectedText = '';
    if (selection.isValid && !selection.isCollapsed) {
      selectedText = text.substring(selection.start, selection.end);
    } else if (placeholder != null) {
      selectedText = placeholder;
    }

    final newText = text.substring(0, selection.start) + before + selectedText + after + text.substring(selection.end);

    _controller.value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: selection.start + before.length + selectedText.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AlertDialog(
      backgroundColor: colors.cardBg,
      title: Text('Edit Message', style: TextStyle(color: colors.textColor)),
      content: SizedBox(
        width: 600,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Markdown formatting toolbar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: colors.cardBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusS),
                border: Border.all(color: colors.borderColor),
              ),
              child: Wrap(
                spacing: 8,
                children: [
                  _buildToolbarButton(
                    icon: Icons.format_bold,
                    tooltip: 'Bold',
                    onPressed: () => _insertMarkdown('**', '**', placeholder: 'bold text'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.format_italic,
                    tooltip: 'Italic',
                    onPressed: () => _insertMarkdown('*', '*', placeholder: 'italic text'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.code,
                    tooltip: 'Inline Code',
                    onPressed: () => _insertMarkdown('`', '`', placeholder: 'code'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.code_off,
                    tooltip: 'Code Block',
                    onPressed: () => _insertMarkdown('```\n', '\n```', placeholder: 'code block'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.format_list_bulleted,
                    tooltip: 'Bullet List',
                    onPressed: () => _insertMarkdown('- ', '', placeholder: 'list item'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.format_list_numbered,
                    tooltip: 'Numbered List',
                    onPressed: () => _insertMarkdown('1. ', '', placeholder: 'list item'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.format_quote,
                    tooltip: 'Quote',
                    onPressed: () => _insertMarkdown('> ', '', placeholder: 'quote'),
                  ),
                  _buildToolbarButton(
                    icon: Icons.link,
                    tooltip: 'Link',
                    onPressed: () => _insertMarkdown('[', '](url)', placeholder: 'link text'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // Text editor
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Enter your message in markdown format...',
                  hintStyle: TextStyle(color: colors.textSecondary),
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
                    borderSide: BorderSide(color: colors.accentColor),
                  ),
                  filled: true,
                  fillColor: colors.inputBg,
                ),
                style: TextStyle(color: colors.textColor, fontFamily: 'monospace'),
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
        ),
        ElevatedButton(
          onPressed: () {
            final newContent = _controller.text.trim();
            if (newContent.isNotEmpty) {
              widget.onSave(newContent);
              Navigator.of(context).pop();
            }
          },
          style: ElevatedButton.styleFrom(backgroundColor: colors.accentColor, foregroundColor: Colors.white),
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildToolbarButton({required IconData icon, required String tooltip, required VoidCallback onPressed}) {
    final colors = context.colors;

    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: Container(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 18, color: colors.textSecondary),
        ),
      ),
    );
  }
}
