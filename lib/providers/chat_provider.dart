import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/chat_service.dart';
import '../core/services/integration_service.dart';
import '../network/generated/api.swagger.dart' as api;
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Enumeration of possible chat states
enum ChatState {
  initial, // No conversation started
  loading, // Processing message or loading AI integrations
  success, // Message sent/received successfully
  error, // Error occurred
  aiSelecting, // User is selecting AI integration
}

/// Provider for managing chat state and operations
class ChatProvider with ChangeNotifier {
  static const String _selectedAiIntegrationKey = 'selected_ai_integration_id';

  final ChatService _chatService;
  final IntegrationService _integrationService;

  ChatState _currentState = ChatState.initial;
  final List<ChatMessage> _messages = [];
  List<AiIntegration> _availableAiIntegrations = [];
  AiIntegration? _selectedAiIntegration;
  List<FileAttachment> _attachments = [];
  bool _isUploadingFiles = false;
  double? _uploadProgress;
  String? _error;

  ChatProvider(this._chatService, this._integrationService) {
    _initializeAiIntegrations();

    // Listen to auth changes to reload integrations when user becomes authenticated
    final authProvider = _integrationService.authProvider;
    authProvider?.addListener(_onAuthChanged);
  }

  // Getters
  ChatState get currentState => _currentState;
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<AiIntegration> get availableAiIntegrations => List.unmodifiable(_availableAiIntegrations);
  AiIntegration? get selectedAiIntegration => _selectedAiIntegration;
  List<FileAttachment> get attachments => List.unmodifiable(_attachments);
  bool get isUploadingFiles => _isUploadingFiles;
  double? get uploadProgress => _uploadProgress;
  String? get error => _error;
  bool get isLoading => _currentState == ChatState.loading;
  bool get hasError => _currentState == ChatState.error;
  bool get isEmpty => _messages.isEmpty;

  void _setState(ChatState state) {
    _currentState = state;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _setState(ChatState.error);
  }

  void _clearError() {
    _error = null;
    if (_currentState == ChatState.error) {
      _setState(_messages.isEmpty ? ChatState.initial : ChatState.success);
    }
  }

  /// Initialize available AI integrations from IntegrationService
  Future<void> _initializeAiIntegrations() async {
    try {
      _setState(ChatState.loading);

      // Get AI-capable integrations from IntegrationService
      await _integrationService.loadIntegrations();
      final integrations = _integrationService.integrations;

      // Convert IntegrationModel to AiIntegration for chat interface
      _availableAiIntegrations = integrations
          .where((integration) => _isAiCapable(integration.type) && integration.enabled)
          .map((integration) => AiIntegration(
                id: integration.id,
                type: integration.type,
                displayName: integration.name,
                isActive: integration.enabled,
              ))
          .toList();

      // Auto-select first available AI integration (only if no saved preference)
      if (_availableAiIntegrations.isNotEmpty && _selectedAiIntegration == null) {
        _selectedAiIntegration = _availableAiIntegrations.first;
        if (kDebugMode) {
          print('🤖 Auto-selected AI integration: ${_selectedAiIntegration?.displayName}');
        }
      }

      _setState(_messages.isEmpty ? ChatState.initial : ChatState.success);

      if (kDebugMode) {
        print('✅ Loaded ${_availableAiIntegrations.length} AI integrations');
      }
    } catch (e) {
      _setError('Failed to load AI integrations: ${e.toString()}');
      if (kDebugMode) {
        print('❌ Error loading AI integrations: $e');
      }
    }
  }

  /// Check if integration type supports AI chat functionality
  bool _isAiCapable(String integrationType) {
    const aiCapableTypes = {
      'openai',
      'gemini',
      'claude',
      'anthropic',
      'azure-openai',
      'huggingface',
      'dial', // Add dial support for Dial Claude
    };
    return aiCapableTypes.contains(integrationType.toLowerCase());
  }

  /// Send a chat message
  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) {
      _setError('Message cannot be empty');
      return;
    }

    if (_selectedAiIntegration == null) {
      _setError('Please select an AI integration first');
      return;
    }

    try {
      _setState(ChatState.loading);
      _clearError();

      // Add user message to conversation with attachments
      final userMessage = ChatMessage(
        message: message,
        isUser: true,
        timestamp: DateTime.now(),
        attachments: List.from(_attachments), // Copy current attachments
      );
      _messages.add(userMessage);
      notifyListeners(); // Update UI immediately with user message

      api.ChatResponse? response;

      if (kDebugMode) {
        print('🔍 Sending message - attachments count: ${_attachments.length}');
        for (int i = 0; i < _attachments.length; i++) {
          print('📎 Attachment [$i]: ${_attachments[i].name} (${_attachments[i].size} bytes)');
        }
      }

      if (_attachments.isNotEmpty) {
        // Send message with files if attachments exist
        if (kDebugMode) {
          print('🔄 Using completions-with-files endpoint');
        }
        response = await _sendMessageWithFiles(message);
      } else {
        // Send chat completion with full conversation history
        if (kDebugMode) {
          print('🔄 Using regular completions endpoint');
        }
        response = await _sendChatCompletion(message);
      }

      if (response != null && response.success == true && response.content != null) {
        // Add AI response to conversation
        final aiMessage = ChatMessage(
          message: response.content!,
          isUser: false,
          timestamp: DateTime.now(),
        );
        _messages.add(aiMessage);

        // Clear attachments after successful send
        _attachments.clear();

        _setState(ChatState.success);

        if (kDebugMode) {
          print('✅ Message sent successfully: ${response.model}');
        }
      } else {
        // Remove user message if API call failed
        if (_messages.isNotEmpty && _messages.last.isUser) {
          _messages.removeLast();
        }
        _setError(response?.error ?? 'Failed to get response from AI');
      }
    } catch (e) {
      // Remove user message if error occurred
      if (_messages.isNotEmpty && _messages.last.isUser) {
        _messages.removeLast();
      }
      _setError('Failed to send message: ${e.toString()}');
      if (kDebugMode) {
        print('❌ Error sending message: $e');
      }
    }
  }

  /// Send chat completion with full conversation history
  Future<api.ChatResponse?> _sendChatCompletion(String message) async {
    // Convert local ChatMessage list to API ChatMessage format
    final apiMessages = _messages
        .map((msg) => api.ChatMessage(
              role: msg.isUser ? 'user' : 'assistant',
              content: msg.message,
            ))
        .toList();

    return await _chatService.sendChatCompletion(
      messages: apiMessages,
      aiIntegrationId: _selectedAiIntegration?.id,
    );
  }

  /// Send message with file attachments
  Future<api.ChatResponse?> _sendMessageWithFiles(String message) async {
    try {
      _isUploadingFiles = true;
      _uploadProgress = 0.0;
      notifyListeners();

      // Convert full conversation history to API format, including current message with files
      final apiMessages = _messages
          .map((msg) => api.ChatMessage(
                role: msg.isUser ? 'user' : 'assistant',
                content: msg.message,
              ))
          .toList();

      // Add file names to the last user message (current message)
      final lastMessage = apiMessages.last;
      final updatedLastMessage = api.ChatMessage(
        role: lastMessage.role,
        content: lastMessage.content,
        fileNames: _attachments.map((attachment) => attachment.name).toList(),
      );
      apiMessages[apiMessages.length - 1] = updatedLastMessage;

      // Convert file attachments to byte arrays
      final files = _attachments.map((attachment) => attachment.bytes).toList();

      // Simulate upload progress
      for (int i = 0; i <= 100; i += 20) {
        _uploadProgress = i / 100.0;
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 100));
      }

      final response = await _chatService.sendChatWithFiles(
        messages: apiMessages,
        files: files,
        fileNames: _attachments.map((attachment) => attachment.name).toList(),
        aiIntegrationId: _selectedAiIntegration?.id,
      );

      _isUploadingFiles = false;
      _uploadProgress = null;
      notifyListeners();

      return response;
    } catch (e) {
      _isUploadingFiles = false;
      _uploadProgress = null;
      notifyListeners();
      rethrow;
    }
  }

  /// Change selected AI integration
  void selectAiIntegration(AiIntegration? integration) {
    if (integration != _selectedAiIntegration) {
      _selectedAiIntegration = integration;
      _saveSelectedAiIntegration(integration?.id);
      _clearError();

      if (kDebugMode) {
        print('🔄 AI integration changed to: ${integration?.displayName ?? 'None'}');
      }

      notifyListeners();
    }
  }

  /// Add file attachments
  void addAttachments(List<FileAttachment> newAttachments) {
    _attachments.addAll(newAttachments);
    _clearError();
    notifyListeners();

    if (kDebugMode) {
      print('📎 Added ${newAttachments.length} attachments, total: ${_attachments.length}');
    }
  }

  /// Update attachments list
  void updateAttachments(List<FileAttachment> newAttachments) {
    _attachments = newAttachments.toList();
    _clearError();
    notifyListeners();

    if (kDebugMode) {
      print('📎 Updated attachments: ${_attachments.length}');
    }
  }

  /// Remove attachment by index
  void removeAttachment(int index) {
    if (index >= 0 && index < _attachments.length) {
      final removed = _attachments.removeAt(index);
      notifyListeners();

      if (kDebugMode) {
        print('🗑️ Removed attachment: ${removed.name}');
      }
    }
  }

  /// Clear all attachments
  void clearAttachments() {
    _attachments.clear();
    notifyListeners();

    if (kDebugMode) {
      print('🗑️ Cleared all attachments');
    }
  }

  /// Edit a message at the specified index
  void editMessage(int messageIndex, String newContent) {
    if (messageIndex < 0 || messageIndex >= _messages.length) {
      if (kDebugMode) {
        print('❌ Invalid message index: $messageIndex');
      }
      return;
    }

    final message = _messages[messageIndex];

    if (kDebugMode) {
      print('✏️ Editing message at index $messageIndex');
      print('📝 Original: ${message.message}');
      print('📝 New: $newContent');
    }

    // Update the message content
    _messages[messageIndex] = ChatMessage(
      message: newContent,
      isUser: message.isUser,
      timestamp: message.timestamp,
      enableMarkdown: message.enableMarkdown,
      attachments: message.attachments, // Preserve original attachments
    );

    // If editing a user message, remove all messages after it and resend
    if (message.isUser) {
      final messagesToRemove = _messages.length - messageIndex - 1;
      if (messagesToRemove > 0) {
        _messages.removeRange(messageIndex + 1, _messages.length);
        if (kDebugMode) {
          print('🗑️ Removed $messagesToRemove messages after edited user message');
        }
      }

      // Resend the conversation to get new AI response
      _resendConversation();
    }

    notifyListeners();
  }

  /// Resend the entire conversation to get a new AI response
  Future<void> _resendConversation() async {
    if (_messages.isEmpty || _selectedAiIntegration == null) {
      return;
    }

    if (kDebugMode) {
      print('🔄 Resending conversation after edit...');
      print('📨 Current conversation length: ${_messages.length}');
    }

    // Set loading state
    _setState(ChatState.loading);

    try {
      // Send the conversation without adding a new user message
      if (_attachments.isNotEmpty) {
        await _resendWithFiles();
      } else {
        await _resendChatCompletion();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error resending conversation: $e');
      }
      _setError('Failed to get AI response after editing message');
    }
  }

  /// Resend chat completion with existing conversation history
  Future<void> _resendChatCompletion() async {
    // Convert existing messages to API format
    final apiMessages = _messages
        .map((msg) => api.ChatMessage(
              role: msg.isUser ? 'user' : 'assistant',
              content: msg.message,
            ))
        .toList();

    if (kDebugMode) {
      print('🔄 Resending chat completion with ${apiMessages.length} messages');
    }

    final response = await _chatService.sendChatCompletion(
      messages: apiMessages,
      aiIntegrationId: _selectedAiIntegration!.id,
    );

    if (response?.success == true && response?.content != null) {
      // Add AI response to conversation
      final aiMessage = ChatMessage(
        message: response!.content!,
        isUser: false,
      );

      _messages.add(aiMessage);
      _setState(ChatState.success);

      if (kDebugMode) {
        print('✅ AI response received and added after edit');
      }
    } else {
      throw Exception('Invalid response from AI service');
    }
  }

  /// Resend message with files using existing conversation
  Future<void> _resendWithFiles() async {
    // Convert existing messages to API format
    final apiMessages = _messages
        .map((msg) => api.ChatMessage(
              role: msg.isUser ? 'user' : 'assistant',
              content: msg.message,
            ))
        .toList();

    if (kDebugMode) {
      print('🔄 Resending with files: ${_attachments.length} attachments, ${apiMessages.length} messages');
    }

    final response = await _chatService.sendChatWithFiles(
      messages: apiMessages,
      files: _attachments.map((a) => a.bytes).toList(),
      fileNames: _attachments.map((a) => a.name).toList(),
      aiIntegrationId: _selectedAiIntegration!.id,
    );

    if (response?.success == true && response?.content != null) {
      // Add AI response to conversation
      final aiMessage = ChatMessage(
        message: response!.content!,
        isUser: false,
      );

      _messages.add(aiMessage);
      _setState(ChatState.success);

      if (kDebugMode) {
        print('✅ AI response with files received and added after edit');
      }
    } else {
      throw Exception('Invalid response from AI service');
    }

    // Clear attachments after successful send
    _attachments.clear();
    _isUploadingFiles = false;
    _uploadProgress = null;
  }

  /// Clear conversation history
  void clearConversation() {
    _messages.clear();
    _attachments.clear();
    _clearError();
    _setState(ChatState.initial);

    if (kDebugMode) {
      print('🧹 Cleared conversation history');
    }
  }

  /// Refresh AI integrations
  Future<void> refreshAiIntegrations() async {
    await _initializeAiIntegrations();
    await _loadSelectedAiIntegration();
  }

  /// Clear error state
  void clearError() {
    _clearError();
  }

  /// Reset provider to initial state
  void reset() {
    _messages.clear();
    _attachments.clear();
    _selectedAiIntegration = null;
    _isUploadingFiles = false;
    _uploadProgress = null;
    _clearError();
    _setState(ChatState.initial);

    if (kDebugMode) {
      print('🔄 Reset ChatProvider to initial state');
    }
  }

  /// Save selected AI integration to client preferences
  Future<void> _saveSelectedAiIntegration(String? integrationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (integrationId != null) {
        await prefs.setString(_selectedAiIntegrationKey, integrationId);
        if (kDebugMode) {
          print('💾 Saved AI integration preference: $integrationId');
        }
      } else {
        await prefs.remove(_selectedAiIntegrationKey);
        if (kDebugMode) {
          print('🗑️ Cleared AI integration preference');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to save AI integration preference: $e');
      }
    }
  }

  /// Load selected AI integration from client preferences
  Future<void> _loadSelectedAiIntegration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIntegrationId = prefs.getString(_selectedAiIntegrationKey);

      if (savedIntegrationId != null && _availableAiIntegrations.isNotEmpty) {
        final savedIntegration = _availableAiIntegrations
            .where(
              (integration) => integration.id == savedIntegrationId,
            )
            .firstOrNull;

        if (savedIntegration != null) {
          _selectedAiIntegration = savedIntegration;

          if (kDebugMode) {
            print('📥 Loaded saved AI integration: ${savedIntegration.displayName}');
          }
        } else {
          // Fallback to first available if saved one not found
          _selectedAiIntegration = _availableAiIntegrations.first;
          if (kDebugMode) {
            print('⚠️ Saved integration not found, using: ${_selectedAiIntegration?.displayName}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Failed to load AI integration preference: $e');
      }
    }
  }

  /// Handle authentication state changes
  void _onAuthChanged() {
    final authProvider = _integrationService.authProvider;
    if (authProvider?.isAuthenticated == true && _availableAiIntegrations.isEmpty) {
      if (kDebugMode) {
        print('🔄 User authenticated, reloading AI integrations...');
      }
      // Reload integrations when user becomes authenticated
      _initializeAiIntegrations();
    }
  }

  @override
  void dispose() {
    // Clean up auth listener
    final authProvider = _integrationService.authProvider;
    authProvider?.removeListener(_onAuthChanged);
    super.dispose();
  }
}
