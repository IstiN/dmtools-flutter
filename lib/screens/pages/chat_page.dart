import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart' as auth;
import '../../core/services/file_service.dart';
import '../../core/services/clipboard_js.dart' if (dart.library.io) '../../core/services/clipboard_stub.dart';
import '../../service_locator.dart';
import 'dart:async';
import 'dart:js' as js;

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
    JSClipboardService.cleanup();
    super.dispose();
  }

  /// Set up automatic paste listener using JavaScript polling
  void _setupPasteListener(ChatProvider chatProvider) {
    try {
      if (kDebugMode) {
        print('🔧 Setting up JavaScript paste polling...');
      }

      if (kIsWeb) {
        // Set up JavaScript paste listener first
        js.context.callMethod('eval', [
          '''
          if (window.ClipboardAPI && !window.pasteListenerSetup) {
            window.ClipboardAPI.setupPasteListener((data) => {
              console.log('📋 JS Callback received:', data.type);
              window.lastPastedContent = data;
              window.lastPastedTimestamp = Date.now();
            });
            window.pasteListenerSetup = true;
            console.log('✅ JavaScript paste listener initialized');
          }
        '''
        ]);

        // Poll for pasted content
        _pasteCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          try {
            final lastContent = js.context['lastPastedContent'];
            final lastTimestamp = js.context['lastPastedTimestamp'];

            if (lastContent != null && lastTimestamp != null) {
              final timestamp = lastTimestamp as num;
              final now = DateTime.now().millisecondsSinceEpoch;

              // Only process if it's recent (within last 2 seconds)
              if (now - timestamp < 2000) {
                _processPastedContent(lastContent, chatProvider);

                // Clear the content to avoid reprocessing
                js.context['lastPastedContent'] = null;
                js.context['lastPastedTimestamp'] = null;
              }
            }
          } catch (e) {
            // Ignore polling errors
          }
        });
      }

      if (kDebugMode) {
        print('✅ JavaScript paste polling setup complete');
      }
    } catch (e) {
      debugPrint('⚠️ Failed to setup paste listener: $e');
    }
  }

  /// Process pasted content from JavaScript using direct property access
  void _processPastedContent(dynamic jsContent, ChatProvider chatProvider) {
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
    return Consumer2<ChatProvider, auth.AuthProvider>(
      builder: (context, chatProvider, authProvider, child) {
        // Show loading state while initializing or during authentication
        if (chatProvider.currentState == ChatState.loading && chatProvider.messages.isEmpty) {
          return _buildLoadingState();
        }

        // Show loading state if user is authenticated but integrations haven't loaded yet
        if (authProvider.isAuthenticated && chatProvider.availableAiIntegrations.isEmpty) {
          return _buildLoadingState();
        }

        // Show empty state only if user is authenticated and no AI integrations are available after loading
        if (chatProvider.availableAiIntegrations.isEmpty &&
            authProvider.isAuthenticated &&
            chatProvider.currentState != ChatState.loading) {
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

          // File attachment support
          attachments: chatProvider.attachments,
          onAttachmentsChanged: (attachments) => chatProvider.updateAttachments(attachments),
          isUploadingFiles: chatProvider.isUploadingFiles,
          uploadProgress: chatProvider.uploadProgress,

          // Text insertion callback
          onTextInsert: (text) {
            // Text was inserted into input field
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

  /// Handle attachment button press - open file picker
  Future<void> _handleAttachmentPressed(ChatProvider chatProvider) async {
    try {
      await _showFileSelectionOptions(chatProvider);
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

  /// Show file selection options
  Future<void> _showFileSelectionOptions(ChatProvider chatProvider) async {
    final colors = context.colorsListening;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attach Files', style: TextStyle(color: colors.textColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose how you want to attach files:',
                style: TextStyle(color: colors.textSecondary),
              ),
              const SizedBox(height: 16),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: colors.textSecondary)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickFiles(chatProvider);
              },
              child: Text('Browse Files', style: TextStyle(color: colors.accentColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickImages(chatProvider);
              },
              child: Text('Images Only', style: TextStyle(color: colors.accentColor)),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pasteFromClipboard(chatProvider);
              },
              child: Text('Paste from Clipboard', style: TextStyle(color: colors.accentColor)),
            ),
          ],
        );
      },
    );
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
