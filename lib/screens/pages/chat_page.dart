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
/// Uses CleanChatInterface with TabbedHeader for multi-chat support
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final FileService _fileService;
  StreamSubscription<Map<String, dynamic>>? _pasteSubscription;
  
  // Store interface keys for each tab to maintain text field state
  final Map<String, GlobalKey<CleanChatInterfaceState>> _interfaceKeys = {};

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

      // Initialize interface keys for existing tabs
      for (final tab in chatProvider.tabs) {
        _interfaceKeys.putIfAbsent(tab.id, () => GlobalKey<CleanChatInterfaceState>());
      }
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
        debugPrint('📋 Setting up paste listener...');
      }

      // Use WebPasteService which handles all JavaScript integration
      _pasteSubscription = WebPasteService.setupPasteListener().listen((data) {
        _processPasteData(data, chatProvider);
      });

      if (kDebugMode) {
        debugPrint('✅ Paste listener setup complete');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Failed to setup paste listener: $e');
      }
    }
  }

  /// Process paste data from WebPasteService
  void _processPasteData(Map<String, dynamic> data, ChatProvider chatProvider) {
    try {
      final type = data['type'] as String;
      final content = data['content'];
      final selectedTabId = chatProvider.selectedTabId;
      if (selectedTabId == null) return;

      if (type == 'image') {
        final imageData = content as Map<String, dynamic>;
        final attachment = FileAttachment(
          name: imageData['name'] as String,
          type: imageData['mimeType'] as String,
          size: imageData['size'] as int,
          bytes: List<int>.from(imageData['bytes'] as List),
          uploadedAt: DateTime.now(),
        );

        chatProvider.addAttachmentsToTab(selectedTabId, [attachment]);

        if (kDebugMode) {
          debugPrint('✅ Image attachment added: ${attachment.name} (${attachment.size} bytes)');
        }
      } else if (type == 'text') {
        // Skip text insertion - let normal paste work everywhere
        // This allows normal paste to work in all form inputs including chat
        // Images are still handled specially because they need custom processing
        if (kDebugMode) {
          debugPrint('📝 Text paste detected - letting normal paste handle it (no programmatic insertion)');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Error processing paste data: $e');
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

        // Tabbed chat interface with TabbedHeader
        return Column(
          children: [
              // Tabbed header
              TabbedHeader(
                tabs: chatProvider.tabs,
                selectedTabId: chatProvider.selectedTabId,
                onTabSelected: (tabId) {
                  chatProvider.selectTab(tabId);
                  // Initialize interface key for new tabs
                  _interfaceKeys.putIfAbsent(tabId, () => GlobalKey<CleanChatInterfaceState>());
                },
                onAddTab: () {
                  chatProvider.addTab();
                  // Initialize interface key for new tab
                  final newTabId = chatProvider.selectedTabId;
                  if (newTabId != null) {
                    _interfaceKeys.putIfAbsent(newTabId, () => GlobalKey<CleanChatInterfaceState>());
                  }
                },
                onCloseTab: (tabId) {
                  chatProvider.closeTab(tabId);
                  // Clean up interface key
                  _interfaceKeys.remove(tabId);
                },
                leading: IconButton(
                  icon: const Icon(Icons.history, size: 20),
                  onPressed: () {
                    // TODO: Recent functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Recent feature coming soon')),
                    );
                  },
                  tooltip: 'Recent chats',
                ),
                actions: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    tooltip: 'More options',
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'theme',
                        child: Row(
                          children: [
                            Icon(Icons.palette, size: 16),
                            SizedBox(width: 8),
                            Text('Chat Theme'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'settings',
                        child: Row(
                          children: [
                            Icon(Icons.settings, size: 16),
                            SizedBox(width: 8),
                            Text('Settings'),
                          ],
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'clear',
                        child: Row(
                          children: [
                            Icon(Icons.clear_all, size: 16),
                            SizedBox(width: 8),
                            Text('Clear all chats'),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'theme') {
                        _showChatThemeConfig(context, chatProvider);
                      } else {
                        // TODO: Other menu actions
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$value coming soon')),
                        );
                      }
                    },
                  ),
                ],
              ),
              
              // Chat content for selected tab
              Expanded(
                child: chatProvider.selectedTabId != null
                    ? _buildChatForTab(chatProvider.selectedTabId!, chatProvider)
                    : const Center(child: CircularProgressIndicator()),
              ),
          ],
        );
      },
    );
  }
  
  Widget _buildChatForTab(String tabId, ChatProvider chatProvider) {
    final tabState = chatProvider.getTabState(tabId);
    if (tabState == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    // Initialize interface key if not exists
    _interfaceKeys.putIfAbsent(tabId, () => GlobalKey<CleanChatInterfaceState>());
    
    return CleanChatInterface(
      key: _interfaceKeys[tabId],
      messages: tabState.messages,
      onSendMessage: (message) => chatProvider.sendMessageForTab(tabId, message),
      onAttachmentPressed: () => _handleAttachmentPressedForTab(tabId, chatProvider),
      
      isLoading: tabState.isLoading,
      chatTheme: chatProvider.chatTheme,
      
      // AI Integration support
      aiIntegrations: chatProvider.availableAiIntegrations,
      selectedAiIntegration: tabState.selectedAiIntegration ?? chatProvider.selectedAiIntegration,
      onAiIntegrationChanged: (integration) {
        chatProvider.selectAiIntegrationForTab(tabId, integration);
      },
      
      // MCP Configuration support
      mcpConfigurations: chatProvider.availableMcpConfigurations,
      selectedMcpConfiguration: tabState.selectedMcpConfiguration ?? chatProvider.selectedMcpConfiguration,
      onMcpConfigurationChanged: (configuration) {
        chatProvider.selectMcpConfigurationForTab(tabId, configuration);
      },
      isMcpInitialized: chatProvider.isMcpInitialized,
      
      // File attachment support
      attachments: tabState.attachments,
      onAttachmentsChanged: (attachments) {
        chatProvider.updateAttachmentsForTab(tabId, attachments);
      },
      isUploadingFiles: tabState.isUploadingFiles,
      uploadProgress: tabState.uploadProgress,
      
      // Text insertion callback
      onTextInsert: (text) {
        // Text was inserted into input field
      },
      
      // Message editing support
      onMessageEdit: (messageIndex, newContent) {
        // TODO: Implement message editing for tabs
        if (kDebugMode) {
          debugPrint('✏️ Message editing not yet implemented for tabs');
        }
      },
      
      // Message deletion support
      onMessageDelete: (messageIndex) {
        chatProvider.deleteMessageForTab(tabId, messageIndex);
      },
      
      // Message resend support
      onMessageResend: (messageIndex) {
        chatProvider.resendMessageForTab(tabId, messageIndex);
      },
    );
  }

  void _showChatThemeConfig(BuildContext context, ChatProvider chatProvider) {
    showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: Container(
          width: 1200,
          height: 800,
          padding: const EdgeInsets.all(16.0),
          child: ChatThemeConfig(
            initialTheme: chatProvider.chatTheme,
            onThemeChanged: (theme) {
              chatProvider.updateChatTheme(theme);
            },
            onDarkModeChanged: (_) {},
            onBubbleModeChanged: (_) {},
            onTextSizeChanged: (_) {},
            onNameColorChanged: (_) {},
          ),
        ),
      ),
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

  /// Handle attachment button press - open file picker directly for specific tab
  Future<void> _handleAttachmentPressedForTab(String tabId, ChatProvider chatProvider) async {
    try {
      await _pickFilesForTab(tabId, chatProvider);
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

  /// Pick any files using file picker and add to specific tab
  Future<void> _pickFilesForTab(String tabId, ChatProvider chatProvider) async {
    try {
      final files = await _fileService.pickFiles();
      if (files != null && files.isNotEmpty) {
        chatProvider.addAttachmentsToTab(tabId, files);
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
