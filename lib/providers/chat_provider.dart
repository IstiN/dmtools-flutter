import 'package:flutter/foundation.dart';
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

      // Auto-select first available AI integration
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

      // Add user message to conversation
      final userMessage = ChatMessage(
        message: message,
        isUser: true,
        timestamp: DateTime.now(),
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
}
