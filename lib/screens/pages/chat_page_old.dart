import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../providers/chat_provider.dart';

import '../../core/services/file_service.dart';
import '../../core/services/web_paste_service.dart' if (dart.library.io) '../../core/services/web_paste_service_stub.dart';
import '../../service_locator.dart';
import 'dart:async';

/// Main chat page that integrates with the DMTools app
/// Uses ChatInterface from styleguide with ChatProvider for state management
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final FileService _fileService;
  final GlobalKey<ChatInterfaceState> _chatInterfaceKey = GlobalKey<ChatInterfaceState>();
  StreamSubscription<ClipboardContent>? _pasteSubscription;
  Timer? _pasteCheckTimer;

  @override
  void initState() {
    super.initState();
    _fileService = ServiceLocator.get<FileService>();

    // Initialize chat provider when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = Provider.of<ChatProvider>(context, listen: false);
      chatProvider.refreshAiIntegrations();

      // Set up automatic paste listener for web
      _setupPasteListener(chatProvider);
    });
  }

  @override
  void dispose() {
    _pasteSubscription?.cancel();
    _pasteCheckTimer?.cancel();
    WebPasteService.cleanup();
    super.dispose();
  }

  /// Set up automatic paste listener using WebPasteService
  void _setupPasteListener(ChatProvider chatProvider) {
    try {
      if (kDebugMode) {
        print('📋 Setting up paste listener...');
      }

      // Use WebPasteService which handles all JavaScript integration
      _pasteSubscription = WebPasteService.setupPasteListener().listen((data) {
        _processPasteData(data, chatProvider);
      });

      if (kDebugMode) {
        print('✅ Paste listener setup complete');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to setup paste listener: $e');
      }
    }
  }

  /// Process pasted content from JavaScript using direct property access
  void _processPastedContent(dynamic jsContent, ChatProvider chatProvider) {
    if (!kIsWeb) return; // Only process on web platform
    
    try {
      if (kDebugMode) {
        print('🔧 Processing pasted content from JavaScript...');
      }

      // Use direct property access instead of eval
      final type = js.context['lastPastedContent']?['type'];

      if (type == 'image') {
        final content = js.context['lastPastedContent']?['content'];
        final name = content?['name'] ?? 'pasted_image_${DateTime.now().millisecondsSinceEpoch}.png';
        final size = content?['size'] ?? 0;
        final extension = content?['extension'] ?? 'png';
        final jsBytes = content?['bytes'];

        if (jsBytes != null) {
          // Convert JS array to Dart list
          final bytes = <int>[];
          final length = jsBytes['length'] ?? 0;

          for (int i = 0; i < (length as num).toInt(); i++) {
            final byte = jsBytes[i];
            if (byte != null) {
              bytes.add((byte as num).toInt());
            }
          }

          if (bytes.isNotEmpty) {
            final attachment = FileAttachment(
              name: name.toString(),
              size: (size as num).toInt(),
              type: extension.toString(),
              bytes: bytes,
              uploadedAt: DateTime.now(),
            );

            chatProvider.addAttachments([attachment]);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('📎 Image pasted: ${attachment.name}'),
                  duration: const Duration(seconds: 2),
                ),
              );
            }

            if (kDebugMode) {
              print('✅ Image attachment added: ${attachment.name} (${attachment.size} bytes)');
            }
          }
        }
      } else if (type == 'text') {
        final text = js.context['lastPastedContent']?['content'];
        if (text != null && text.toString().trim().isNotEmpty) {
          _chatInterfaceKey.currentState?.insertText(text.toString());

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('📝 Text pasted: ${text.toString().length} characters'),
                duration: const Duration(seconds: 1),
              ),
            );
          }

          if (kDebugMode) {
            print('✅ Text inserted: ${text.toString().length} chars');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error processing pasted content: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Note: No manual paste shortcuts needed - JavaScript paste listener handles everything automatically!
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        // Show loading state while initializing
        if (chatProvider.currentState == ChatState.loading && chatProvider.messages.isEmpty) {
          return _buildLoadingState();
        }

        // Show loading state if integrations are still loading (to prevent empty state flash)
        if (chatProvider.availableAiIntegrations.isEmpty) {
          return _buildLoadingState();
        }

        // Main chat interface
        return ChatInterface(
          key: _chatInterfaceKey,
          messages: chatProvider.messages,
          onSendMessage: (message) => chatProvider.sendMessage(message),
          onAttachmentPressed: () => _handleAttachmentPressed(chatProvider),

          title: 'AI Chat',
          isLoading: chatProvider.isLoading,

          // AI Integration support
          aiIntegrations: chatProvider.availableAiIntegrations,
          selectedAiIntegration: chatProvider.selectedAiIntegration,
          onAiIntegrationChanged: (integration) => chatProvider.selectAiIntegration(integration),

          // File attachment support
          attachments: chatProvider.attachments,
          onAttachmentsChanged: (attachments) => chatProvider.updateAttachments(attachments),
          isUploadingFiles: chatProvider.isUploadingFiles,
          uploadProgress: chatProvider.uploadProgress,

          // Text insertion callback
          onTextInsert: (text) {
            // Text was inserted into input field
          },

          // Message editing support
          onMessageEdit: (messageIndex, newContent) {
            chatProvider.editMessage(messageIndex, newContent);
          },
        );
      },
    );
  }

  /// Build loading state UI
  Widget _buildLoadingState() {
    final colors = context.colorsListening;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: colors.accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading AI integrations...',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Build empty state when no AI integrations are configured
  Widget _buildEmptyState() {
    return Center(
      child: EmptyState(
        icon: Icons.smart_toy_outlined,
        title: 'No AI Integrations Available',
        message: 'To start chatting, you need to configure at least one AI integration. '
            'Visit the Integrations page to set up OpenAI, Gemini, Claude, or other AI providers.',
        onPressed: () => _navigateToIntegrations(),
      ),
    );
  }

  /// Handle attachment button press - open file picker directly
  Future<void> _handleAttachmentPressed(ChatProvider chatProvider) async {
    try {
      await _pickFiles(chatProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to select files: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  /// Pick any files using file picker
  Future<void> _pickFiles(ChatProvider chatProvider) async {
    try {
      final files = await _fileService.pickFiles();
      if (files != null && files.isNotEmpty) {
        chatProvider.addAttachments(files);
        _showSuccessMessage('Added ${files.length} file(s)');
      }
    } catch (e) {
      _showErrorMessage('Failed to pick files: $e');
    }
  }

  /// Pick only image files
  Future<void> _pickImages(ChatProvider chatProvider) async {
    try {
      final images = await _fileService.pickImages();
      if (images != null && images.isNotEmpty) {
        chatProvider.addAttachments(images);
        _showSuccessMessage('Added ${images.length} image(s)');
      }
    } catch (e) {
      _showErrorMessage('Failed to pick images: $e');
    }
  }

  /// Paste content from clipboard
  Future<void> _pasteFromClipboard(ChatProvider chatProvider) async {
    try {
      final clipboardContent = await _fileService.handlePasteEvent();
      if (clipboardContent != null) {
        final type = clipboardContent['type'] as String;
        final content = clipboardContent['content'];

        if (type == 'file') {
          // Add as file attachment
          final attachment = content as FileAttachment;
          chatProvider.addAttachments([attachment]);
          final category = _fileService.getFileCategory(attachment.type);
          _showSuccessMessage('Pasted $category from clipboard');
        } else if (type == 'text') {
          // Insert text directly into input field
          final text = content as String;
          _chatInterfaceKey.currentState?.insertText(text);
          _showSuccessMessage('Pasted text into message input');
        }
      } else {
        _showErrorMessage('No valid content found in clipboard');
      }
    } catch (e) {
      _showErrorMessage('Failed to paste from clipboard: $e');
    }
  }

  // Note: Manual paste handling removed - JavaScript paste listener handles everything automatically!

  /// Show success message
  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: context.colorsListening.accentColor,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  /// Show error message
  void _showErrorMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  /// Navigate to integrations page
  void _navigateToIntegrations() {
    // Use the navigation context to go to integrations page
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/integrations');
    }
  }
}
