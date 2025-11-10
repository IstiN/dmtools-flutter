import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
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

/// Clean chat interface without header, background, or borders.
/// Provides a minimal chat experience suitable for embedding in other components.
class CleanChatInterface extends StatefulWidget {
  final List<ChatMessage> messages;
  final Function(String) onSendMessage;
  final VoidCallback? onAttachmentPressed;
  final bool isLoading;

  /// AI integration selection
  final List<AiIntegration> aiIntegrations;
  final AiIntegration? selectedAiIntegration;
  final ValueChanged<AiIntegration?>? onAiIntegrationChanged;

  /// MCP Configuration selection
  final List<McpConfigOption> mcpConfigurations;
  final McpConfigOption? selectedMcpConfiguration;
  final ValueChanged<McpConfigOption?>? onMcpConfigurationChanged;
  final bool isMcpInitialized;

  /// File attachment support
  final List<FileAttachment> attachments;
  final ValueChanged<List<FileAttachment>>? onAttachmentsChanged;
  final bool isUploadingFiles;
  final double? uploadProgress;

  /// Text insertion callback
  final ValueChanged<String>? onTextInsert;

  /// Message editing callbacks
  final Function(int messageIndex, String newContent)? onMessageEdit;

  /// Message deletion callbacks
  final Function(int messageIndex)? onMessageDelete;

  /// Message resend callbacks
  final Function(int messageIndex)? onMessageResend;

  /// Test mode flags
  final bool? isTestMode;
  final bool? testDarkMode;

  /// Chat theme configuration
  final ChatTheme? chatTheme;
  final Color? userMessageColorOverride;
  final Color? aiMessageColorOverride;
  final Color? userMessageTextColorOverride;
  final Color? aiMessageTextColorOverride;

  const CleanChatInterface({
    required this.messages,
    required this.onSendMessage,
    super.key,
    this.onAttachmentPressed,
    this.isLoading = false,
    this.aiIntegrations = const [],
    this.selectedAiIntegration,
    this.onAiIntegrationChanged,
    this.mcpConfigurations = const [],
    this.selectedMcpConfiguration,
    this.onMcpConfigurationChanged,
    this.isMcpInitialized = false,
    this.attachments = const [],
    this.onAttachmentsChanged,
    this.isUploadingFiles = false,
    this.uploadProgress,
    this.onTextInsert,
    this.onMessageEdit,
    this.onMessageDelete,
    this.onMessageResend,
    this.isTestMode,
    this.testDarkMode,
    this.chatTheme,
    this.userMessageColorOverride,
    this.aiMessageColorOverride,
    this.userMessageTextColorOverride,
    this.aiMessageTextColorOverride,
  });

  @override
  CleanChatInterfaceState createState() => CleanChatInterfaceState();
}

class CleanChatInterfaceState extends State<CleanChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

  /// Check if the chat input field is currently focused
  bool get isInputFocused => _messageFocusNode.hasFocus;

  void insertText(String text) {
    final currentText = _messageController.text;
    final currentSelection = _messageController.selection;

    String newText;
    int newCursorPosition;

    if (currentSelection.isValid) {
      newText = currentText.replaceRange(currentSelection.start, currentSelection.end, text);
      newCursorPosition = currentSelection.start + text.length;
    } else {
      newText = currentText + text;
      newCursorPosition = newText.length;
    }

    _messageController.text = newText;
    _messageController.selection = TextSelection.collapsed(offset: newCursorPosition);
    widget.onTextInsert?.call(text);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
      if (mounted && _messageFocusNode.canRequestFocus) {
        _messageFocusNode.requestFocus();
      }
    });
  }

  @override
  void didUpdateWidget(CleanChatInterface oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.messages.length > oldWidget.messages.length || widget.isLoading != oldWidget.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
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
      buttonPosition.dx,
      buttonPosition.dy + buttonSize.height + 4,
      buttonPosition.dx + 200,
      buttonPosition.dy + buttonSize.height + 300,
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

  void _showMcpConfigurationMenu(BuildContext buttonContext) {
    if (kDebugMode) {
      debugPrint('🔄 CleanChatInterface._showMcpConfigurationMenu() called');
      debugPrint('🔄 widget.mcpConfigurations.length: ${widget.mcpConfigurations.length}');
      debugPrint('🔄 widget.isMcpInitialized: ${widget.isMcpInitialized}');
      for (var config in widget.mcpConfigurations) {
        debugPrint('🔄   - ${config.name} (${config.id})');
      }
    }

    final RenderBox button = buttonContext.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(buttonContext).overlay!.context.findRenderObject() as RenderBox;

    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = button.size;

    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy + buttonSize.height + 4,
      buttonPosition.dx + 220,
      buttonPosition.dy + buttonSize.height + 300,
    );

    final noneOption = const McpConfigOption.none();
    final allConfigurations = [noneOption, ...widget.mcpConfigurations];

    if (kDebugMode) {
      debugPrint('🔄 CleanChatInterface allConfigurations.length: ${allConfigurations.length}');
      for (var config in allConfigurations) {
        debugPrint('🔄   - ${config.name} (${config.id})');
      }
    }

    showMenu<McpConfigOption>(
      context: buttonContext,
      position: position,
      items: allConfigurations.map((config) {
        return PopupMenuItem<McpConfigOption>(
          value: config,
          child: Row(
            children: [
              Icon(
                config.isNone ? Icons.block : Icons.cable_outlined,
                size: 16,
                color: config.isNone ? context.colorsListening.textMuted : context.colorsListening.accentColor,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(config.name)),
              if (widget.selectedMcpConfiguration == config) ...[
                const Spacer(),
                Icon(Icons.check, size: 16, color: context.colorsListening.accentColor),
              ],
            ],
          ),
        );
      }).toList(),
    ).then((selectedConfig) {
      if (selectedConfig != null) {
        widget.onMcpConfigurationChanged?.call(selectedConfig);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;
    final isDarkMode = context.isDarkMode;
    final theme = widget.chatTheme ?? ChatTheme.day();
    // Use theme backgroundColor based on current theme mode, otherwise transparent
    final backgroundColor = theme.getBackgroundColor(isDarkMode) ?? Colors.transparent;

    // Clean layout with background color from theme
    return Container(
      height: 400,
      width: double.infinity,
      color: backgroundColor,
      child: Column(
        children: [
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
                  return _buildLoadingBubble(colors);
                }
              },
            ),
          ),

          // Divider before input area
          Divider(
            height: 1,
            thickness: 1,
            color: colors.textMuted.withValues(alpha: AppDimensions.headerBorderOpacity),
          ),

          // Input area - clean design without top border
          Padding(
            padding: const EdgeInsets.only(
              left: AppDimensions.spacingXs,
              right: AppDimensions.spacingXs,
              top: AppDimensions.spacingM,
              bottom: AppDimensions.spacingM,
            ),
            child: Column(
              children: [
                // Attachments display
                FileAttachmentPicker(
                  attachments: widget.attachments,
                  onAttachmentsChanged: widget.onAttachmentsChanged,
                  onAttachmentPressed: widget.onAttachmentPressed,
                  isLoading: widget.isUploadingFiles,
                  uploadProgress: widget.uploadProgress,
                  isTestMode: widget.isTestMode,
                  testDarkMode: widget.testDarkMode,
                ),

                // Input row
                Row(
                  children: [
                    // AI integration selector
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

                    // MCP Configuration selector (only show after MCP is initialized)
                    if (widget.isMcpInitialized) ...[
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Builder(
                          builder: (context) {
                            final bool hasActiveSelection =
                                widget.selectedMcpConfiguration != null && !widget.selectedMcpConfiguration!.isNone;
                            final iconColor = hasActiveSelection ? colors.accentColor : colors.textSecondary;

                            return IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.cable_outlined, color: iconColor, size: 20),
                              onPressed: () => _showMcpConfigurationMenu(context),
                              tooltip: widget.selectedMcpConfiguration?.name ?? 'Select MCP Configuration',
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],

                    // File attachment button
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

                    // Message input field
                    Expanded(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minHeight: 40, maxHeight: 120),
                        child: CallbackShortcuts(
                          bindings: <ShortcutActivator, VoidCallback>{
                            const SingleActivator(LogicalKeyboardKey.enter): () {
                              _sendMessage();
                            },
                          },
                          child: TextField(
                            controller: _messageController,
                            focusNode: _messageFocusNode,
                            autofocus: true,
                            style: TextStyle(color: colors.textColor, fontSize: 14),
                            textAlignVertical: TextAlignVertical.center,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (value) {
                              _sendMessage();
                            },
                            onChanged: (value) {
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

  /// Get TextStyle with font family from theme, using GoogleFonts for non-local fonts
  TextStyle? _getFontTextStyle(String? fontFamilyName, {double? fontSize, Color? color}) {
    if (fontFamilyName == null) return null;

    // Inter is loaded locally, use it directly
    if (fontFamilyName == 'Inter') {
      return TextStyle(fontFamily: 'Inter', fontSize: fontSize, color: color);
    }

    // For other fonts, use GoogleFonts directly
    try {
      TextStyle? baseStyle;
      switch (fontFamilyName) {
        case 'Roboto':
          baseStyle = GoogleFonts.roboto();
          break;
        case 'Open Sans':
          baseStyle = GoogleFonts.openSans();
          break;
        case 'Lato':
          baseStyle = GoogleFonts.lato();
          break;
        case 'Montserrat':
          baseStyle = GoogleFonts.montserrat();
          break;
        case 'Poppins':
          baseStyle = GoogleFonts.poppins();
          break;
        case 'Nunito':
          baseStyle = GoogleFonts.nunito();
          break;
        case 'Raleway':
          baseStyle = GoogleFonts.raleway();
          break;
        case 'Source Sans 3':
          baseStyle = GoogleFonts.sourceSans3();
          break;
        case 'Source Sans Pro':
          baseStyle = GoogleFonts.sourceSans3(); // Fallback to Source Sans 3
          break;
        case 'Ubuntu':
          baseStyle = GoogleFonts.ubuntu();
          break;
        case 'Noto Sans':
          baseStyle = GoogleFonts.notoSans();
          break;
        case 'Work Sans':
          baseStyle = GoogleFonts.workSans();
          break;
        case 'Playfair Display':
          baseStyle = GoogleFonts.playfairDisplay();
          break;
        case 'Merriweather':
          baseStyle = GoogleFonts.merriweather();
          break;
        case 'Oswald':
          baseStyle = GoogleFonts.oswald();
          break;
        case 'Roboto Condensed':
          baseStyle = GoogleFonts.robotoCondensed();
          break;
        default:
          return TextStyle(fontFamily: fontFamilyName, fontSize: fontSize, color: color);
      }
      // Merge with custom fontSize and color if provided
      // Explicitly preserve fontFamily from baseStyle
      return baseStyle.copyWith(
        fontSize: fontSize,
        color: color,
        fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
      );
    } catch (e) {
      // If GoogleFonts fails, return null to use system default
      return null;
    }
  }

  Widget _buildMessageBubble(ChatMessage message, dynamic colors, int index) {
    // Get theme colors with override priority: override > theme > default
    final theme = widget.chatTheme ?? ChatTheme.day();
    final isDarkMode = context.isDarkMode;
    final userMessageColor = widget.userMessageColorOverride ?? theme.userMessageColor;
    final aiMessageColor = widget.aiMessageColorOverride ?? theme.aiMessageColor;
    final textSize = theme.textSize;
    final showAgentName = theme.showAgentName;

    final messageColor = message.isUser ? userMessageColor : aiMessageColor;
    final messageTextColor = message.isUser
        ? (widget.userMessageTextColorOverride ?? theme.getUserMessageTextColor(isDarkMode))
        : (widget.aiMessageTextColorOverride ?? theme.getAiMessageTextColor(isDarkMode));

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * ResponsiveBreakpoints.chatMaxWidthBreakpoint,
        ),
        child: Column(
          crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Show agent name for AI messages if enabled
            if (!message.isUser && showAgentName) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 16),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 16,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(color: theme.nameColor, borderRadius: BorderRadius.circular(2)),
                    ),
                    Text(
                      theme.agentName,
                      style: () {
                        final baseStyle = _getFontTextStyle(
                          theme.fontFamily,
                          fontSize: 14 * textSize,
                          color: theme.nameColor,
                        );
                        return baseStyle?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
                            ) ??
                            TextStyle(fontSize: 14 * textSize, fontWeight: FontWeight.w500, color: theme.nameColor);
                      }(),
                    ),
                  ],
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: messageColor == Colors.transparent ? null : messageColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SelectionArea(
                          child: message.enableMarkdown
                              ? MarkdownRenderer(
                                  data: message.message,
                                  shrinkWrap: true,
                                  selectable: false,
                                  styleSheet: _buildMessageMarkdownStyleSheet(context, message.isUser, colors),
                                )
                              : Text(
                                  message.message,
                                  style:
                                      _getFontTextStyle(
                                        theme.fontFamily,
                                        fontSize: 14 * textSize,
                                        color: messageTextColor,
                                      ) ??
                                      TextStyle(color: messageTextColor, fontSize: 14 * textSize),
                                ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          size: 16,
                          color: message.isUser ? messageTextColor.withValues(alpha: 0.7) : colors.textSecondary,
                        ),
                        tooltip: 'Message actions',
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context) {
                          final items = <PopupMenuItem<String>>[
                            const PopupMenuItem<String>(
                              value: 'copy',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Icon(Icons.copy, size: 16), SizedBox(width: 8), Text('Copy')],
                              ),
                            ),
                          ];

                          if (message.isUser) {
                            items.add(
                              const PopupMenuItem<String>(
                                value: 'resend',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Icon(Icons.refresh, size: 16), SizedBox(width: 8), Text('Re-send')],
                                ),
                              ),
                            );
                          }

                          items.addAll([
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit')],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Icon(Icons.delete, size: 16), SizedBox(width: 8), Text('Delete')],
                              ),
                            ),
                          ]);

                          return items;
                        },
                        onSelected: (value) => _handleMessageAction(value, index, message),
                      ),
                    ],
                  ),
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
                    style:
                        _getFontTextStyle(
                          theme.fontFamily,
                          fontSize: 10 * textSize,
                          color: message.isUser
                              ? const Color(0xFFE0F2FE) // Light cyan/blue for better visibility on cyan background
                              : theme.dateTextColor, // Use theme date color for AI messages
                        ) ??
                        TextStyle(
                          fontSize: 10 * textSize,
                          color: message.isUser ? const Color(0xFFE0F2FE) : theme.dateTextColor,
                        ),
                  ),
                ],
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

  void _copyMessageToClipboard(String message) {
    Clipboard.setData(ClipboardData(text: message));

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

  void _handleMessageAction(String action, int messageIndex, ChatMessage message) {
    switch (action) {
      case 'copy':
        _copyMessageToClipboard(message.message);
        break;
      case 'resend':
        widget.onMessageResend?.call(messageIndex);
        break;
      case 'edit':
        _showEditMessageDialog(messageIndex, message);
        break;
      case 'delete':
        _showDeleteMessageConfirmation(messageIndex, message);
        break;
    }
  }

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

  void _showDeleteMessageConfirmation(int messageIndex, ChatMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onMessageDelete?.call(messageIndex);
            },
            style: TextButton.styleFrom(foregroundColor: context.colorsListening.dangerColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _buildFileTag(FileAttachment attachment, dynamic colors) {
    Color tagColor;
    IconData icon;

    if (attachment.type.startsWith('image/')) {
      tagColor = const Color(0xFF9333EA);
      icon = Icons.image_outlined;
    } else if (attachment.type.contains('pdf')) {
      tagColor = const Color(0xFFDC2626);
      icon = Icons.picture_as_pdf_outlined;
    } else if (attachment.type.contains('text') ||
        attachment.type.contains('json') ||
        attachment.type.contains('code')) {
      tagColor = const Color(0xFF2563EB);
      icon = Icons.code_outlined;
    } else if (attachment.type.contains('zip') || attachment.type.contains('archive')) {
      tagColor = const Color(0xFFEA580C);
      icon = Icons.folder_zip_outlined;
    } else if (attachment.type.contains('video')) {
      tagColor = const Color(0xFFDB2777);
      icon = Icons.videocam_outlined;
    } else if (attachment.type.contains('audio')) {
      tagColor = const Color(0xFF0891B2);
      icon = Icons.audiotrack_outlined;
    } else {
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

  MarkdownStyleSheet _buildMessageMarkdownStyleSheet(BuildContext context, bool isUser, dynamic colors) {
    final theme = Theme.of(context);
    final isDarkMode = context.isDarkMode;
    final chatTheme = widget.chatTheme ?? ChatTheme.day();
    final textSize = chatTheme.textSize;
    final textColor = isUser
        ? (widget.userMessageTextColorOverride ?? chatTheme.getUserMessageTextColor(isDarkMode))
        : (widget.aiMessageTextColorOverride ?? chatTheme.getAiMessageTextColor(isDarkMode));
    final userMessageColor = widget.userMessageColorOverride ?? chatTheme.userMessageColor;

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p:
          _getFontTextStyle(
            chatTheme.fontFamily,
            fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
            color: textColor,
          ) ??
          theme.textTheme.bodyLarge?.copyWith(
            color: textColor,
            fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
          ),
      h1: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.headlineLarge?.fontSize ?? 32) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.headlineLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: (theme.textTheme.headlineLarge?.fontSize ?? 32) * textSize,
            );
      }(),
      h2: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 28) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.headlineMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 28) * textSize,
            );
      }(),
      h3: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.headlineSmall?.fontSize ?? 24) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.headlineSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.headlineSmall?.fontSize ?? 24) * textSize,
            );
      }(),
      h4: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * textSize,
            );
      }(),
      h5: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.titleMedium?.fontSize ?? 20) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.titleMedium?.fontSize ?? 20) * textSize,
            );
      }(),
      h6: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.titleSmall?.fontSize ?? 18) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.titleSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.titleSmall?.fontSize ?? 18) * textSize,
            );
      }(),
      code: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontFamily: 'monospace',
        backgroundColor: textColor.withValues(alpha: 0.1),
        fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * textSize * 0.9,
      ),
      codeblockDecoration: BoxDecoration(
        color: isUser ? userMessageColor.withValues(alpha: 0.2) : colors.codeBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
      ),
      blockquote: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
          color: textColor.withValues(alpha: 0.8),
        );
        return baseStyle?.copyWith(
              fontStyle: FontStyle.italic,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.bodyLarge?.copyWith(
              color: textColor.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
              fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
            );
      }(),
      listBullet:
          _getFontTextStyle(
            chatTheme.fontFamily,
            fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
            color: textColor,
          ) ??
          theme.textTheme.bodyLarge?.copyWith(
            color: textColor,
            fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
          ),
      a: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
          color: isUser ? textColor : colors.accentColor,
        );
        return baseStyle?.copyWith(
              decoration: TextDecoration.underline,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.bodyLarge?.copyWith(
              color: isUser ? textColor : colors.accentColor,
              decoration: TextDecoration.underline,
              fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
            );
      }(),
    );
  }
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

  /// MCP Configuration selection
  final List<McpConfigOption> mcpConfigurations;
  final McpConfigOption? selectedMcpConfiguration;
  final ValueChanged<McpConfigOption?>? onMcpConfigurationChanged;
  final bool isMcpInitialized;

  /// File attachment support
  final List<FileAttachment> attachments;
  final ValueChanged<List<FileAttachment>>? onAttachmentsChanged;
  final bool isUploadingFiles;
  final double? uploadProgress;

  /// Text insertion callback (called when text should be inserted into input field)
  final ValueChanged<String>? onTextInsert;

  /// Message editing callbacks
  final Function(int messageIndex, String newContent)? onMessageEdit;

  /// Message deletion callbacks
  final Function(int messageIndex)? onMessageDelete;

  /// Message resend callbacks
  final Function(int messageIndex)? onMessageResend;

  /// Used in tests to override theme detection for predictable rendering
  final bool? isTestMode;

  /// Theme to use when isTestMode is true
  final bool? testDarkMode;

  /// Chat theme configuration
  final ChatTheme? chatTheme;
  final Color? userMessageColorOverride;
  final Color? aiMessageColorOverride;
  final Color? userMessageTextColorOverride;
  final Color? aiMessageTextColorOverride;

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
    this.mcpConfigurations = const [],
    this.selectedMcpConfiguration,
    this.onMcpConfigurationChanged,
    this.isMcpInitialized = false,
    this.attachments = const [],
    this.onAttachmentsChanged,
    this.isUploadingFiles = false,
    this.uploadProgress,
    this.onTextInsert,
    this.onMessageEdit,
    this.onMessageDelete,
    this.onMessageResend,
    this.isTestMode,
    this.testDarkMode,
    this.chatTheme,
    this.userMessageColorOverride,
    this.aiMessageColorOverride,
    this.userMessageTextColorOverride,
    this.aiMessageTextColorOverride,
  });

  @override
  ChatInterfaceState createState() => ChatInterfaceState();
}

class ChatInterfaceState extends State<ChatInterface> {
  final TextEditingController _messageController = TextEditingController();
  final FocusNode _messageFocusNode = FocusNode();

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
      // Focus the message input field when chat appears
      if (mounted && _messageFocusNode.canRequestFocus) {
        _messageFocusNode.requestFocus();
      }
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

  @override
  void dispose() {
    _messageController.dispose();
    _messageFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
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

  void _showMcpConfigurationMenu(BuildContext buttonContext) {
    if (kDebugMode) {
      debugPrint('🔄 ChatInterface._showMcpConfigurationMenu() called');
      debugPrint('🔄 widget.mcpConfigurations.length: ${widget.mcpConfigurations.length}');
      debugPrint('🔄 widget.isMcpInitialized: ${widget.isMcpInitialized}');
      for (var config in widget.mcpConfigurations) {
        debugPrint('🔄   - ${config.name} (${config.id})');
      }
    }

    final RenderBox button = buttonContext.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(buttonContext).overlay!.context.findRenderObject() as RenderBox;

    final Offset buttonPosition = button.localToGlobal(Offset.zero, ancestor: overlay);
    final Size buttonSize = button.size;

    final RelativeRect position = RelativeRect.fromLTRB(
      buttonPosition.dx,
      buttonPosition.dy + buttonSize.height + 4,
      buttonPosition.dx + 220,
      buttonPosition.dy + buttonSize.height + 300,
    );

    final noneOption = const McpConfigOption.none();
    final allConfigurations = [noneOption, ...widget.mcpConfigurations];

    if (kDebugMode) {
      debugPrint('🔄 ChatInterface allConfigurations.length: ${allConfigurations.length}');
      for (var config in allConfigurations) {
        debugPrint('🔄   - ${config.name} (${config.id})');
      }
    }

    showMenu<McpConfigOption>(
      context: buttonContext,
      position: position,
      items: allConfigurations.map((config) {
        return PopupMenuItem<McpConfigOption>(
          value: config,
          child: Row(
            children: [
              Icon(
                config.isNone ? Icons.block : Icons.cable_outlined,
                size: 16,
                color: config.isNone ? context.colorsListening.textMuted : context.colorsListening.accentColor,
              ),
              const SizedBox(width: 8),
              Expanded(child: Text(config.name)),
              if (widget.selectedMcpConfiguration == config) ...[
                const Spacer(),
                Icon(Icons.check, size: 16, color: context.colorsListening.accentColor),
              ],
            ],
          ),
        );
      }).toList(),
    ).then((selectedConfig) {
      if (selectedConfig != null) {
        widget.onMcpConfigurationChanged?.call(selectedConfig);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;
    final isDarkMode = context.isDarkMode;
    final theme = widget.chatTheme ?? ChatTheme.day();
    // Use theme backgroundColor based on current theme mode, otherwise transparent
    final backgroundColor = theme.getBackgroundColor(isDarkMode) ?? Colors.transparent;

    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
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

          // Divider before input area
          Divider(
            height: 1,
            thickness: 1,
            color: colors.textMuted.withValues(alpha: AppDimensions.headerBorderOpacity),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.only(
              left: AppDimensions.spacingXs,
              right: AppDimensions.spacingXs,
              top: AppDimensions.spacingM,
              bottom: AppDimensions.spacingM,
            ),
            decoration: BoxDecoration(color: colors.cardBg),
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

                // Input row with enhanced layout: [🤖 AI ▼] [🔧 MCP ▼] [📎] [Type a message... 📤]
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

                    // MCP Configuration selector icon (always visible, menu includes "None" option)
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Builder(
                        builder: (context) {
                          // Determine icon color based on selection
                          final bool hasActiveSelection =
                              widget.selectedMcpConfiguration != null && !widget.selectedMcpConfiguration!.isNone;
                          final iconColor = hasActiveSelection ? colors.accentColor : colors.textSecondary;

                          return IconButton(
                            padding: EdgeInsets.zero,
                            icon: Icon(Icons.cable_outlined, color: iconColor, size: 20),
                            onPressed: () => _showMcpConfigurationMenu(context),
                            tooltip: widget.selectedMcpConfiguration?.name ?? 'Select MCP Configuration',
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    // File attachment button (third)
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
                            focusNode: _messageFocusNode,
                            autofocus: true,
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

  /// Get TextStyle with font family from theme, using GoogleFonts for non-local fonts
  TextStyle? _getFontTextStyle(String? fontFamilyName, {double? fontSize, Color? color}) {
    if (fontFamilyName == null) return null;

    // Inter is loaded locally, use it directly
    if (fontFamilyName == 'Inter') {
      return TextStyle(fontFamily: 'Inter', fontSize: fontSize, color: color);
    }

    // For other fonts, use GoogleFonts directly
    try {
      TextStyle? baseStyle;
      switch (fontFamilyName) {
        case 'Roboto':
          baseStyle = GoogleFonts.roboto();
          break;
        case 'Open Sans':
          baseStyle = GoogleFonts.openSans();
          break;
        case 'Lato':
          baseStyle = GoogleFonts.lato();
          break;
        case 'Montserrat':
          baseStyle = GoogleFonts.montserrat();
          break;
        case 'Poppins':
          baseStyle = GoogleFonts.poppins();
          break;
        case 'Nunito':
          baseStyle = GoogleFonts.nunito();
          break;
        case 'Raleway':
          baseStyle = GoogleFonts.raleway();
          break;
        case 'Source Sans 3':
          baseStyle = GoogleFonts.sourceSans3();
          break;
        case 'Source Sans Pro':
          baseStyle = GoogleFonts.sourceSans3(); // Fallback to Source Sans 3
          break;
        case 'Ubuntu':
          baseStyle = GoogleFonts.ubuntu();
          break;
        case 'Noto Sans':
          baseStyle = GoogleFonts.notoSans();
          break;
        case 'Work Sans':
          baseStyle = GoogleFonts.workSans();
          break;
        case 'Playfair Display':
          baseStyle = GoogleFonts.playfairDisplay();
          break;
        case 'Merriweather':
          baseStyle = GoogleFonts.merriweather();
          break;
        case 'Oswald':
          baseStyle = GoogleFonts.oswald();
          break;
        case 'Roboto Condensed':
          baseStyle = GoogleFonts.robotoCondensed();
          break;
        default:
          return TextStyle(fontFamily: fontFamilyName, fontSize: fontSize, color: color);
      }
      // Merge with custom fontSize and color if provided
      // Explicitly preserve fontFamily from baseStyle
      return baseStyle.copyWith(
        fontSize: fontSize,
        color: color,
        fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
      );
    } catch (e) {
      // If GoogleFonts fails, return null to use system default
      return null;
    }
  }

  Widget _buildMessageBubble(ChatMessage message, dynamic colors, int index) {
    // Get theme colors with override priority: override > theme > default
    final theme = widget.chatTheme ?? ChatTheme.day();
    final isDarkMode = context.isDarkMode;
    final userMessageColor = widget.userMessageColorOverride ?? theme.userMessageColor;
    final aiMessageColor = widget.aiMessageColorOverride ?? theme.aiMessageColor;
    final textSize = theme.textSize;
    final showAgentName = theme.showAgentName;

    final messageColor = message.isUser ? userMessageColor : aiMessageColor;
    final messageTextColor = message.isUser
        ? (widget.userMessageTextColorOverride ?? theme.getUserMessageTextColor(isDarkMode))
        : (widget.aiMessageTextColorOverride ?? theme.getAiMessageTextColor(isDarkMode));

    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * ResponsiveBreakpoints.chatMaxWidthBreakpoint,
        ),
        child: Column(
          crossAxisAlignment: message.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Show agent name for AI messages if enabled
            if (!message.isUser && showAgentName) ...[
              Padding(
                padding: const EdgeInsets.only(bottom: 4, left: 16),
                child: Row(
                  children: [
                    Container(
                      width: 3,
                      height: 16,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(color: theme.nameColor, borderRadius: BorderRadius.circular(2)),
                    ),
                    Text(
                      theme.agentName,
                      style: () {
                        final baseStyle = _getFontTextStyle(
                          theme.fontFamily,
                          fontSize: 14 * textSize,
                          color: theme.nameColor,
                        );
                        return baseStyle?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
                            ) ??
                            TextStyle(fontSize: 14 * textSize, fontWeight: FontWeight.w500, color: theme.nameColor);
                      }(),
                    ),
                  ],
                ),
              ),
            ],
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: messageColor == Colors.transparent ? null : messageColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content with copy button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SelectionArea(
                          child: message.enableMarkdown
                              ? MarkdownRenderer(
                                  data: message.message,
                                  shrinkWrap: true,
                                  selectable: false,
                                  styleSheet: _buildMessageMarkdownStyleSheet(context, message.isUser, colors),
                                )
                              : Text(
                                  message.message,
                                  style:
                                      _getFontTextStyle(
                                        theme.fontFamily,
                                        fontSize: 14 * textSize,
                                        color: messageTextColor,
                                      ) ??
                                      TextStyle(color: messageTextColor, fontSize: 14 * textSize),
                                ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Message actions menu
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          size: 16,
                          color: message.isUser ? messageTextColor.withValues(alpha: 0.7) : colors.textSecondary,
                        ),
                        tooltip: 'Message actions',
                        constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                        padding: EdgeInsets.zero,
                        itemBuilder: (context) {
                          final items = <PopupMenuItem<String>>[
                            const PopupMenuItem<String>(
                              value: 'copy',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Icon(Icons.copy, size: 16), SizedBox(width: 8), Text('Copy')],
                              ),
                            ),
                          ];

                          if (message.isUser) {
                            items.add(
                              const PopupMenuItem<String>(
                                value: 'resend',
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [Icon(Icons.refresh, size: 16), SizedBox(width: 8), Text('Re-send')],
                                ),
                              ),
                            );
                          }

                          items.addAll([
                            const PopupMenuItem<String>(
                              value: 'edit',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text('Edit')],
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [Icon(Icons.delete, size: 16), SizedBox(width: 8), Text('Delete')],
                              ),
                            ),
                          ]);

                          return items;
                        },
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
                    style:
                        _getFontTextStyle(
                          theme.fontFamily,
                          fontSize: 10 * textSize,
                          color: message.isUser
                              ? const Color(0xFFE0F2FE) // Light cyan/blue for better visibility on cyan background
                              : theme.dateTextColor, // Use theme date color for AI messages
                        ) ??
                        TextStyle(
                          fontSize: 10 * textSize,
                          color: message.isUser ? const Color(0xFFE0F2FE) : theme.dateTextColor,
                        ),
                  ),
                ],
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
      case 'resend':
        widget.onMessageResend?.call(messageIndex);
        break;
      case 'edit':
        _showEditMessageDialog(messageIndex, message);
        break;
      case 'delete':
        _showDeleteMessageConfirmation(messageIndex, message);
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

  void _showDeleteMessageConfirmation(int messageIndex, ChatMessage message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onMessageDelete?.call(messageIndex);
            },
            style: TextButton.styleFrom(foregroundColor: context.colorsListening.dangerColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  MarkdownStyleSheet _buildMessageMarkdownStyleSheet(BuildContext context, bool isUser, dynamic colors) {
    final theme = Theme.of(context);
    final isDarkMode = context.isDarkMode;
    final chatTheme = widget.chatTheme ?? ChatTheme.day();
    final textSize = chatTheme.textSize;
    final textColor = isUser
        ? (widget.userMessageTextColorOverride ?? chatTheme.getUserMessageTextColor(isDarkMode))
        : (widget.aiMessageTextColorOverride ?? chatTheme.getAiMessageTextColor(isDarkMode));
    final userMessageColor = widget.userMessageColorOverride ?? chatTheme.userMessageColor;

    return MarkdownStyleSheet.fromTheme(theme).copyWith(
      p:
          _getFontTextStyle(
            chatTheme.fontFamily,
            fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
            color: textColor,
          ) ??
          theme.textTheme.bodyLarge?.copyWith(
            color: textColor,
            fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
          ),
      h1: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.headlineLarge?.fontSize ?? 32) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.headlineLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: (theme.textTheme.headlineLarge?.fontSize ?? 32) * textSize,
            );
      }(),
      h2: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 28) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.headlineMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: (theme.textTheme.headlineMedium?.fontSize ?? 28) * textSize,
            );
      }(),
      h3: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.headlineSmall?.fontSize ?? 24) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.headlineSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.headlineSmall?.fontSize ?? 24) * textSize,
            );
      }(),
      h4: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.titleLarge?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.titleLarge?.fontSize ?? 22) * textSize,
            );
      }(),
      h5: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.titleMedium?.fontSize ?? 20) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.titleMedium?.fontSize ?? 20) * textSize,
            );
      }(),
      h6: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.titleSmall?.fontSize ?? 18) * textSize,
          color: textColor,
        );
        return baseStyle?.copyWith(
              fontWeight: FontWeight.w600,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.titleSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: (theme.textTheme.titleSmall?.fontSize ?? 18) * textSize,
            );
      }(),
      code: theme.textTheme.bodyMedium?.copyWith(
        color: textColor,
        fontFamily: 'monospace',
        backgroundColor: textColor.withValues(alpha: 0.1),
        fontSize: (theme.textTheme.bodyMedium?.fontSize ?? 14) * textSize * 0.9,
      ),
      codeblockDecoration: BoxDecoration(
        color: isUser ? userMessageColor.withValues(alpha: 0.2) : colors.codeBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.borderColor.withValues(alpha: 0.3)),
      ),
      blockquote: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
          color: textColor.withValues(alpha: 0.8),
        );
        return baseStyle?.copyWith(
              fontStyle: FontStyle.italic,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.bodyLarge?.copyWith(
              color: textColor.withValues(alpha: 0.8),
              fontStyle: FontStyle.italic,
              fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
            );
      }(),
      listBullet:
          _getFontTextStyle(
            chatTheme.fontFamily,
            fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
            color: textColor,
          ) ??
          theme.textTheme.bodyLarge?.copyWith(
            color: textColor,
            fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
          ),
      a: () {
        final baseStyle = _getFontTextStyle(
          chatTheme.fontFamily,
          fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
          color: isUser ? textColor : colors.accentColor,
        );
        return baseStyle?.copyWith(
              decoration: TextDecoration.underline,
              fontFamily: baseStyle.fontFamily, // Explicitly preserve fontFamily
            ) ??
            theme.textTheme.bodyLarge?.copyWith(
              color: isUser ? textColor : colors.accentColor,
              decoration: TextDecoration.underline,
              fontSize: (theme.textTheme.bodyLarge?.fontSize ?? 14) * textSize,
            );
      }(),
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
