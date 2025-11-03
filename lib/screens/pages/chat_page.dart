import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../providers/chat_provider.dart';
import '../../providers/enhanced_auth_provider.dart';
import '../../core/services/file_service.dart';
import '../../core/services/web_paste_service.dart'
    if (dart.library.io) '../../core/services/web_paste_service_stub.dart';
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
  StreamSubscription<Map<String, dynamic>>? _pasteSubscription;

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

  /// Process paste data from WebPasteService
  void _processPasteData(Map<String, dynamic> data, ChatProvider chatProvider) {
    try {
      final type = data['type'] as String;
      final content = data['content'];

      if (type == 'image') {
        final imageData = content as Map<String, dynamic>;
        final attachment = FileAttachment(
          name: imageData['name'] as String,
          type: imageData['mimeType'] as String,
          size: imageData['size'] as int,
          bytes: List<int>.from(imageData['bytes'] as List),
          uploadedAt: DateTime.now(),
        );

        chatProvider.addAttachments([attachment]);

        if (kDebugMode) {
          print('✅ Image attachment added: ${attachment.name} (${attachment.size} bytes)');
        }
      } else if (type == 'text') {
        final text = content as String;
        _chatInterfaceKey.currentState?.insertText(text);

        if (kDebugMode) {
          print('✅ Text inserted into chat input: ${text.length} characters');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error processing paste data: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ChatProvider, EnhancedAuthProvider>(
      builder: (context, chatProvider, authProvider, child) {
        // Show loading state only during initial load (no integrations loaded yet)
        // Don't show full-screen loading during message sending/receiving
        if (chatProvider.isLoading && chatProvider.availableAiIntegrations.isEmpty && chatProvider.messages.isEmpty) {
          return _buildLoadingState();
        }

        // Show empty state if no integrations are available after loading is complete
        if (chatProvider.availableAiIntegrations.isEmpty && !chatProvider.isLoading) {
          return _buildEmptyState();
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

          // MCP Configuration support
          mcpConfigurations: chatProvider.availableMcpConfigurations,
          selectedMcpConfiguration: chatProvider.selectedMcpConfiguration,
          onMcpConfigurationChanged: (configuration) => chatProvider.selectMcpConfiguration(configuration),

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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading...',
            style: TextStyle(color: context.colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: context.colors.textSecondary,
          ),
          const SizedBox(height: 16),
          Text(
            'No AI integrations available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: context.colors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please configure AI integrations to start chatting.',
            style: TextStyle(color: context.colors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          OutlineButton(
            text: 'Go to Integrations',
            onPressed: () {
              // Navigate to integrations page
              // Using the same router context
              if (context.mounted) {
                context.go('/integrations');
              }
            },
          ),
        ],
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

  void _showSuccessMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

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
}
