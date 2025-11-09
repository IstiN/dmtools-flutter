import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/chat_service.dart';
import '../core/services/integration_service.dart';
import '../core/models/mcp_configuration.dart' as main_app;
import '../providers/mcp_provider.dart';
import '../network/generated/api.swagger.dart' as api;
import '../network/generated/api.enums.swagger.dart' as enums;
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Enumeration of possible chat states
enum ChatState {
  initial, // No conversation started
  loading, // Processing message or loading AI integrations
  success, // Message sent/received successfully
  error, // Error occurred
  aiSelecting, // User is selecting AI integration
}

/// State for individual chat tab
class ChatTabState {
  final String id;
  final List<ChatMessage> messages = [];
  final List<FileAttachment> attachments = [];
  AiIntegration? selectedAiIntegration;
  McpConfigOption? selectedMcpConfiguration;
  bool isLoading = false;
  bool isUploadingFiles = false;
  double? uploadProgress;

  ChatTabState({required this.id});
}

/// Provider for managing chat state and operations
class ChatProvider with ChangeNotifier {
  static const String _selectedAiIntegrationKey = 'selected_ai_integration_id';
  static const String _selectedMcpConfigurationKey = 'selected_mcp_configuration_id';
  static const String _chatThemeTypeKey = 'chat_theme_type';
  static const String _chatThemeUserColorKey = 'chat_theme_user_color';
  static const String _chatThemeAiColorKey = 'chat_theme_ai_color';
  static const String _chatThemeUserTextColorKey = 'chat_theme_user_text_color';
  static const String _chatThemeAiTextColorKey = 'chat_theme_ai_text_color';
  static const String _chatThemeNameColorKey = 'chat_theme_name_color';
  static const String _chatThemeDateColorKey = 'chat_theme_date_color';
  static const String _chatThemeBubbleModeKey = 'chat_theme_bubble_mode';
  static const String _chatThemeTextSizeKey = 'chat_theme_text_size';
  static const String _chatThemeShowAgentNameKey = 'chat_theme_show_agent_name';
  static const String _chatThemeFontFamilyKey = 'chat_theme_font_family';
  static const String _chatThemeBackgroundColorLightKey = 'chat_theme_background_color_light';
  static const String _chatThemeBackgroundColorDarkKey = 'chat_theme_background_color_dark';

  final ChatService _chatService;
  final IntegrationService _integrationService;
  final McpProvider _mcpProvider;

  ChatState _currentState = ChatState.initial;
  final List<ChatMessage> _messages = [];
  List<AiIntegration> _availableAiIntegrations = [];
  AiIntegration? _selectedAiIntegration;
  List<McpConfigOption> _availableMcpConfigurations = [];
  McpConfigOption? _selectedMcpConfiguration;
  bool _mcpInitialized = false;
  List<FileAttachment> _attachments = [];
  bool _isUploadingFiles = false;
  double? _uploadProgress;
  String? _error;

  // Chat theme
  ChatTheme _chatTheme = ChatTheme.defaultTheme();

  // Tab management
  final List<HeaderTab> _tabs = [];
  String? _selectedTabId;
  int _tabCounter = 1;
  final Map<String, ChatTabState> _tabStates = {};

  ChatProvider(this._chatService, this._integrationService, this._mcpProvider) {
    _initializeAiIntegrations();
    _initializeMcpConfigurations();
    _loadChatTheme();

    // Listen to auth changes to reload integrations when user becomes authenticated
    final authProvider = _integrationService.authProvider;
    authProvider?.addListener(_onAuthChanged);

    // Listen to MCP configurations changes
    _mcpProvider.addListener(_onMcpConfigurationsChanged);

    // Initialize first tab if none exists
    if (_tabs.isEmpty) {
      _addNewTab();
    }
  }

  // Getters
  ChatState get currentState => _currentState;
  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<AiIntegration> get availableAiIntegrations => List.unmodifiable(_availableAiIntegrations);
  AiIntegration? get selectedAiIntegration => _selectedAiIntegration;
  List<McpConfigOption> get availableMcpConfigurations => List.unmodifiable(_availableMcpConfigurations);
  McpConfigOption? get selectedMcpConfiguration => _selectedMcpConfiguration;
  bool get isMcpInitialized => _mcpInitialized;
  List<FileAttachment> get attachments => List.unmodifiable(_attachments);
  bool get isUploadingFiles => _isUploadingFiles;
  double? get uploadProgress => _uploadProgress;
  String? get error => _error;
  bool get isLoading => _currentState == ChatState.loading;
  bool get hasError => _currentState == ChatState.error;
  bool get isEmpty => _messages.isEmpty;

  // Tab management getters
  List<HeaderTab> get tabs => List.unmodifiable(_tabs);
  String? get selectedTabId => _selectedTabId;
  ChatTabState? getSelectedTabState() => _selectedTabId != null ? _tabStates[_selectedTabId] : null;
  ChatTabState? getTabState(String tabId) => _tabStates[tabId];

  // Chat theme getter
  ChatTheme get chatTheme => _chatTheme;

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
      // Filter by categories - only integrations with "AI" category
      _availableAiIntegrations = integrations
          .where((integration) => integration.categories.contains('AI') && integration.enabled)
          .map((integration) {
            // Get icon URL from integration type
            final integrationType = _integrationService.getIntegrationType(integration.type);
            return AiIntegration(
              id: integration.id,
              type: integration.type,
              displayName: integration.name,
              iconUrl: integrationType?.iconUrl,
              isActive: integration.enabled,
            );
          })
          .toList();

      // Auto-select first available AI integration (only if no saved preference)
      if (_availableAiIntegrations.isNotEmpty && _selectedAiIntegration == null) {
        _selectedAiIntegration = _availableAiIntegrations.first;
        if (kDebugMode) {
          debugPrint('🤖 Auto-selected AI integration: ${_selectedAiIntegration?.displayName}');
        }
      }

      _setState(_messages.isEmpty ? ChatState.initial : ChatState.success);

      if (kDebugMode) {
        debugPrint('✅ Loaded ${_availableAiIntegrations.length} AI integrations');
      }
    } catch (e) {
      _setError('Failed to load AI integrations: ${e.toString()}');
      if (kDebugMode) {
        debugPrint('❌ Error loading AI integrations: $e');
      }
    }
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
        debugPrint('🔍 Sending message - attachments count: ${_attachments.length}');
        for (int i = 0; i < _attachments.length; i++) {
          debugPrint('📎 Attachment [$i]: ${_attachments[i].name} (${_attachments[i].size} bytes)');
        }
      }

      if (_attachments.isNotEmpty) {
        // Send message with files if attachments exist
        if (kDebugMode) {
          debugPrint('🔄 Using completions-with-files endpoint');
        }
        response = await _sendMessageWithFiles(message);
      } else {
        // Send chat completion with full conversation history
        if (kDebugMode) {
          debugPrint('🔄 Using regular completions endpoint');
        }
        response = await _sendChatCompletion(message);
      }

      if (response != null && response.success == true && response.content != null) {
        // Add AI response to conversation
        final aiMessage = ChatMessage(message: response.content!, isUser: false, timestamp: DateTime.now());
        _messages.add(aiMessage);

        // Clear attachments after successful send
        _attachments.clear();

        _setState(ChatState.success);

        if (kDebugMode) {
          debugPrint('✅ Message sent successfully: ${response.success}');
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
        debugPrint('❌ Error sending message: $e');
      }
    }
  }

  /// Send chat completion with full conversation history
  Future<api.ChatResponse?> _sendChatCompletion(String message) async {
    // Convert local ChatMessage list to API ChatMessage format
    final apiMessages = _messages
        .map(
          (msg) => api.ChatMessage(
            role: msg.isUser ? enums.ChatMessageRole.user : enums.ChatMessageRole.assistant,
            content: msg.message,
          ),
        )
        .toList();

    return await _chatService.sendChatCompletion(
      messages: apiMessages,
      aiIntegrationId: _selectedAiIntegration?.id,
      mcpConfigurationId: _selectedMcpConfiguration?.id,
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
          .map(
            (msg) => api.ChatMessage(
              role: msg.isUser ? enums.ChatMessageRole.user : enums.ChatMessageRole.assistant,
              content: msg.message,
            ),
          )
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
        mcpConfigurationId: _selectedMcpConfiguration?.id,
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
        debugPrint('🔄 AI integration changed to: ${integration?.displayName ?? 'None'}');
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
      debugPrint('📎 Added ${newAttachments.length} attachments, total: ${_attachments.length}');
    }
  }

  /// Update attachments list
  void updateAttachments(List<FileAttachment> newAttachments) {
    _attachments = newAttachments.toList();
    _clearError();
    notifyListeners();

    if (kDebugMode) {
      debugPrint('📎 Updated attachments: ${_attachments.length}');
    }
  }

  /// Remove attachment by index
  void removeAttachment(int index) {
    if (index >= 0 && index < _attachments.length) {
      final removed = _attachments.removeAt(index);
      notifyListeners();

      if (kDebugMode) {
        debugPrint('🗑️ Removed attachment: ${removed.name}');
      }
    }
  }

  /// Clear all attachments
  void clearAttachments() {
    _attachments.clear();
    notifyListeners();

    if (kDebugMode) {
      debugPrint('🗑️ Cleared all attachments');
    }
  }

  /// Edit a message at the specified index
  void editMessage(int messageIndex, String newContent) {
    if (messageIndex < 0 || messageIndex >= _messages.length) {
      if (kDebugMode) {
        debugPrint('❌ Invalid message index: $messageIndex');
      }
      return;
    }

    final message = _messages[messageIndex];

    if (kDebugMode) {
      debugPrint('✏️ Editing message at index $messageIndex');
      debugPrint('📝 Original: ${message.message}');
      debugPrint('📝 New: $newContent');
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
          debugPrint('🗑️ Removed $messagesToRemove messages after edited user message');
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
      debugPrint('🔄 Resending conversation after edit...');
      debugPrint('📨 Current conversation length: ${_messages.length}');
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
        debugPrint('❌ Error resending conversation: $e');
      }
      _setError('Failed to get AI response after editing message');
    }
  }

  /// Resend chat completion with existing conversation history
  Future<void> _resendChatCompletion() async {
    // Convert existing messages to API format
    final apiMessages = _messages
        .map(
          (msg) => api.ChatMessage(
            role: msg.isUser ? enums.ChatMessageRole.user : enums.ChatMessageRole.assistant,
            content: msg.message,
          ),
        )
        .toList();

    if (kDebugMode) {
      debugPrint('🔄 Resending chat completion with ${apiMessages.length} messages');
    }

    final response = await _chatService.sendChatCompletion(
      messages: apiMessages,
      aiIntegrationId: _selectedAiIntegration!.id,
      mcpConfigurationId: _selectedMcpConfiguration?.id,
    );

    if (response?.success == true && response?.content != null) {
      // Add AI response to conversation
      final aiMessage = ChatMessage(message: response!.content!, isUser: false);

      _messages.add(aiMessage);
      _setState(ChatState.success);

      if (kDebugMode) {
        debugPrint('✅ AI response received and added after edit');
      }
    } else {
      throw Exception('Invalid response from AI service');
    }
  }

  /// Resend message with files using existing conversation
  Future<void> _resendWithFiles() async {
    // Convert existing messages to API format
    final apiMessages = _messages
        .map(
          (msg) => api.ChatMessage(
            role: msg.isUser ? enums.ChatMessageRole.user : enums.ChatMessageRole.assistant,
            content: msg.message,
          ),
        )
        .toList();

    if (kDebugMode) {
      debugPrint('🔄 Resending with files: ${_attachments.length} attachments, ${apiMessages.length} messages');
    }

    final response = await _chatService.sendChatWithFiles(
      messages: apiMessages,
      files: _attachments.map((a) => a.bytes).toList(),
      fileNames: _attachments.map((a) => a.name).toList(),
      aiIntegrationId: _selectedAiIntegration!.id,
      mcpConfigurationId: _selectedMcpConfiguration?.id,
    );

    if (response?.success == true && response?.content != null) {
      // Add AI response to conversation
      final aiMessage = ChatMessage(message: response!.content!, isUser: false);

      _messages.add(aiMessage);
      _setState(ChatState.success);

      if (kDebugMode) {
        debugPrint('✅ AI response with files received and added after edit');
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
      debugPrint('🧹 Cleared conversation history');
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
      debugPrint('🔄 Reset ChatProvider to initial state');
    }
  }

  /// Save selected AI integration to client preferences
  Future<void> _saveSelectedAiIntegration(String? integrationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (integrationId != null) {
        await prefs.setString(_selectedAiIntegrationKey, integrationId);
        if (kDebugMode) {
          debugPrint('💾 Saved AI integration preference: $integrationId');
        }
      } else {
        await prefs.remove(_selectedAiIntegrationKey);
        if (kDebugMode) {
          debugPrint('🗑️ Cleared AI integration preference');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to save AI integration preference: $e');
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
            .where((integration) => integration.id == savedIntegrationId)
            .firstOrNull;

        if (savedIntegration != null) {
          _selectedAiIntegration = savedIntegration;

          if (kDebugMode) {
            debugPrint('📥 Loaded saved AI integration: ${savedIntegration.displayName}');
          }
        } else {
          // Fallback to first available if saved one not found
          _selectedAiIntegration = _availableAiIntegrations.first;
          if (kDebugMode) {
            debugPrint('⚠️ Saved integration not found, using: ${_selectedAiIntegration?.displayName}');
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load AI integration preference: $e');
      }
    }
  }

  /// Handle authentication state changes
  void _onAuthChanged() {
    final authProvider = _integrationService.authProvider;
    if (authProvider?.isAuthenticated == true) {
      if (kDebugMode) {
        debugPrint('🔄 User authenticated, reloading AI integrations and MCP configurations...');
      }
      // Reload integrations when user becomes authenticated
      if (_availableAiIntegrations.isEmpty) {
        _initializeAiIntegrations();
      }
      // Always reload MCP configurations when authenticated (they might have failed before auth)
      _initializeMcpConfigurations();
    }
  }

  /// Initialize available MCP configurations from McpProvider
  Future<void> _initializeMcpConfigurations() async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 ChatProvider._initializeMcpConfigurations() called');
        debugPrint('🔄 McpProvider.configurations.length: ${_mcpProvider.configurations.length}');
        debugPrint('🔄 McpProvider.configurations.isEmpty: ${_mcpProvider.configurations.isEmpty}');
      }

      // Check if McpProvider already has configurations loaded (e.g., from MCP page)
      if (_mcpProvider.configurations.isNotEmpty) {
        if (kDebugMode) {
          debugPrint('🔄 MCP configurations already loaded in McpProvider, syncing...');
          debugPrint('🔄 McpProvider has ${_mcpProvider.configurations.length} configurations');
          for (var config in _mcpProvider.configurations) {
            debugPrint('🔄   - ${config.name} (${config.id})');
          }
        }
        // Sync immediately without reloading
        _updateMcpConfigurationsFromProvider();
      } else {
        if (kDebugMode) {
          debugPrint('🔄 Loading MCP configurations from McpProvider...');
        }
        // Load MCP configurations from McpProvider
        await _mcpProvider.loadConfigurations();
        if (kDebugMode) {
          debugPrint(
            '🔄 After loadConfigurations(), McpProvider has ${_mcpProvider.configurations.length} configurations',
          );
        }
        _updateMcpConfigurationsFromProvider();
      }

      // Load saved preference for selected MCP configuration
      await _loadSelectedMcpConfiguration();

      _mcpInitialized = true;
      notifyListeners();

      if (kDebugMode) {
        debugPrint('✅ ChatProvider loaded ${_availableMcpConfigurations.length} MCP configurations');
        for (var config in _availableMcpConfigurations) {
          debugPrint('✅   - ${config.name} (${config.id})');
        }
      }
    } catch (e) {
      _mcpInitialized = true; // Mark as initialized even on error
      notifyListeners();
      if (kDebugMode) {
        debugPrint('❌ Error loading MCP configurations: $e');
      }
    }
  }

  /// Convert main app McpConfiguration to styleguide McpConfigOption
  McpConfigOption _convertMcpConfiguration(main_app.McpConfiguration config) {
    return McpConfigOption.fromConfig(id: config.id ?? '', name: config.name);
  }

  /// Update MCP configurations from provider
  void _updateMcpConfigurationsFromProvider() {
    if (kDebugMode) {
      debugPrint('🔄 ChatProvider._updateMcpConfigurationsFromProvider() called');
      debugPrint('🔄 McpProvider.configurations.length: ${_mcpProvider.configurations.length}');
    }
    _availableMcpConfigurations = _mcpProvider.configurations
        .map((config) => _convertMcpConfiguration(config))
        .toList();
    if (kDebugMode) {
      debugPrint('🔄 ChatProvider._availableMcpConfigurations.length: ${_availableMcpConfigurations.length}');
    }
    notifyListeners();
  }

  /// Handle MCP configurations changes
  void _onMcpConfigurationsChanged() {
    if (kDebugMode) {
      debugPrint('🔄 ChatProvider._onMcpConfigurationsChanged() called');
      debugPrint('🔄 McpProvider.configurations.length: ${_mcpProvider.configurations.length}');
    }
    _updateMcpConfigurationsFromProvider();
    if (kDebugMode) {
      debugPrint(
        '🔄 ChatProvider._availableMcpConfigurations.length after update: ${_availableMcpConfigurations.length}',
      );
    }
  }

  /// Select MCP configuration
  void selectMcpConfiguration(McpConfigOption? configuration) {
    _selectedMcpConfiguration = configuration;
    _saveMcpConfigurationPreference(configuration?.id);
    notifyListeners();

    if (kDebugMode) {
      debugPrint('🔧 Selected MCP configuration: ${configuration?.name ?? "None"}');
    }
  }

  /// Save selected MCP configuration to client preferences
  Future<void> _saveMcpConfigurationPreference(String? configurationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (configurationId != null && configurationId.isNotEmpty) {
        await prefs.setString(_selectedMcpConfigurationKey, configurationId);
        if (kDebugMode) {
          debugPrint('💾 Saved MCP configuration preference: $configurationId');
        }
      } else {
        await prefs.remove(_selectedMcpConfigurationKey);
        if (kDebugMode) {
          debugPrint('🗑️ Cleared MCP configuration preference');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to save MCP configuration preference: $e');
      }
    }
  }

  /// Load selected MCP configuration from client preferences
  Future<void> _loadSelectedMcpConfiguration() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedConfigurationId = prefs.getString(_selectedMcpConfigurationKey);

      if (savedConfigurationId != null && _availableMcpConfigurations.isNotEmpty) {
        final savedConfiguration = _availableMcpConfigurations
            .where((config) => config.id == savedConfigurationId)
            .firstOrNull;

        if (savedConfiguration != null) {
          _selectedMcpConfiguration = savedConfiguration;
          if (kDebugMode) {
            debugPrint('📥 Loaded saved MCP configuration: ${savedConfiguration.name}');
          }
        } else {
          // Default to "None" if saved configuration not found
          _selectedMcpConfiguration = const McpConfigOption.none();
          if (kDebugMode) {
            debugPrint('⚠️ Saved MCP configuration not found, defaulting to None');
          }
        }
      } else {
        // Default to "None" if no saved preference
        _selectedMcpConfiguration = const McpConfigOption.none();
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load MCP configuration preference: $e');
      }
      // Default to "None" on error
      _selectedMcpConfiguration = const McpConfigOption.none();
    }
  }

  /// Load chat theme from preferences
  Future<void> _loadChatTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeTypeStr = prefs.getString(_chatThemeTypeKey);

      // Load theme type
      ChatThemeType? themeType;
      if (themeTypeStr != null) {
        themeType = ChatThemeType.values.firstWhere(
          (e) => e.toString() == themeTypeStr,
          orElse: () => ChatThemeType.defaultTheme,
        );
      }

      // Load custom colors if saved
      final userColorStr = prefs.getString(_chatThemeUserColorKey);
      final aiColorStr = prefs.getString(_chatThemeAiColorKey);
      final userTextColorStr = prefs.getString(_chatThemeUserTextColorKey);
      final aiTextColorStr = prefs.getString(_chatThemeAiTextColorKey);
      final nameColorStr = prefs.getString(_chatThemeNameColorKey);
      final dateColorStr = prefs.getString(_chatThemeDateColorKey);
      final bubbleMode = prefs.getBool(_chatThemeBubbleModeKey) ?? true;
      final textSize = prefs.getDouble(_chatThemeTextSizeKey) ?? 1.0;
      final showAgentName = prefs.getBool(_chatThemeShowAgentNameKey) ?? true;
      final fontFamily = prefs.getString(_chatThemeFontFamilyKey);
      final backgroundColorLightStr = prefs.getString(_chatThemeBackgroundColorLightKey);
      final backgroundColorDarkStr = prefs.getString(_chatThemeBackgroundColorDarkKey);

      // Start with base theme
      _chatTheme = themeType?.toTheme() ?? ChatTheme.defaultTheme();

      // Apply custom colors if saved
      if (userColorStr != null) {
        _chatTheme = _chatTheme.copyWith(userMessageColor: Color(int.parse(userColorStr)));
      }
      if (aiColorStr != null) {
        _chatTheme = _chatTheme.copyWith(aiMessageColor: Color(int.parse(aiColorStr)));
      }
      if (userTextColorStr != null) {
        _chatTheme = _chatTheme.copyWith(userMessageTextColor: Color(int.parse(userTextColorStr)));
      }
      if (aiTextColorStr != null) {
        _chatTheme = _chatTheme.copyWith(aiMessageTextColor: Color(int.parse(aiTextColorStr)));
      }
      if (nameColorStr != null) {
        _chatTheme = _chatTheme.copyWith(nameColor: Color(int.parse(nameColorStr)));
      }
      if (dateColorStr != null) {
        _chatTheme = _chatTheme.copyWith(dateTextColor: Color(int.parse(dateColorStr)));
      }

      // Apply bubble mode, text size, showAgentName, fontFamily, and background colors
      _chatTheme = _chatTheme.copyWith(
        bubbleMode: bubbleMode,
        textSize: textSize,
        showAgentName: showAgentName,
        fontFamily: fontFamily,
        backgroundColorLight: backgroundColorLightStr != null ? Color(int.parse(backgroundColorLightStr)) : null,
        backgroundColorDark: backgroundColorDarkStr != null ? Color(int.parse(backgroundColorDarkStr)) : null,
      );

      if (kDebugMode) {
        debugPrint('📥 Loaded chat theme: ${themeType ?? ChatThemeType.defaultTheme}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to load chat theme: $e');
      }
      // Default to default theme on error
      _chatTheme = ChatTheme.defaultTheme();
    }
  }

  /// Save chat theme to preferences
  Future<void> _saveChatTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save theme type (try to detect from current theme)
      ChatThemeType? detectedType;
      if (_chatTheme.userMessageColor.value == ChatTheme.defaultTheme().userMessageColor.value &&
          _chatTheme.aiMessageColor.value == ChatTheme.defaultTheme().aiMessageColor.value) {
        detectedType = ChatThemeType.defaultTheme;
      } else if (_chatTheme.userMessageColor.value == ChatTheme.day().userMessageColor.value &&
          _chatTheme.aiMessageColor.value == ChatTheme.day().aiMessageColor.value) {
        detectedType = ChatThemeType.day;
      } else if (_chatTheme.userMessageColor.value == ChatTheme.nightAccent().userMessageColor.value) {
        detectedType = ChatThemeType.nightAccent;
      } else if (_chatTheme.userMessageColor.value == ChatTheme.dayClassic().userMessageColor.value) {
        detectedType = ChatThemeType.dayClassic;
      } else if (_chatTheme.userMessageColor.value == ChatTheme.system().userMessageColor.value) {
        detectedType = ChatThemeType.system;
      }

      if (detectedType != null) {
        await prefs.setString(_chatThemeTypeKey, detectedType.toString());
      }

      // Save all colors
      await prefs.setString(_chatThemeUserColorKey, _chatTheme.userMessageColor.value.toString());
      await prefs.setString(_chatThemeAiColorKey, _chatTheme.aiMessageColor.value.toString());
      await prefs.setString(_chatThemeUserTextColorKey, _chatTheme.userMessageTextColor.value.toString());
      await prefs.setString(_chatThemeAiTextColorKey, _chatTheme.aiMessageTextColor.value.toString());
      await prefs.setString(_chatThemeNameColorKey, _chatTheme.nameColor.value.toString());
      await prefs.setString(_chatThemeDateColorKey, _chatTheme.dateTextColor.value.toString());
      await prefs.setBool(_chatThemeBubbleModeKey, _chatTheme.bubbleMode);
      await prefs.setDouble(_chatThemeTextSizeKey, _chatTheme.textSize);
      await prefs.setBool(_chatThemeShowAgentNameKey, _chatTheme.showAgentName);
      if (_chatTheme.fontFamily != null) {
        await prefs.setString(_chatThemeFontFamilyKey, _chatTheme.fontFamily!);
      } else {
        await prefs.remove(_chatThemeFontFamilyKey);
      }

      // Save background colors
      if (_chatTheme.backgroundColorLight != null) {
        await prefs.setString(_chatThemeBackgroundColorLightKey, _chatTheme.backgroundColorLight!.value.toString());
      } else {
        await prefs.remove(_chatThemeBackgroundColorLightKey);
      }
      if (_chatTheme.backgroundColorDark != null) {
        await prefs.setString(_chatThemeBackgroundColorDarkKey, _chatTheme.backgroundColorDark!.value.toString());
      } else {
        await prefs.remove(_chatThemeBackgroundColorDarkKey);
      }

      if (kDebugMode) {
        debugPrint('💾 Saved chat theme');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to save chat theme: $e');
      }
    }
  }

  /// Update chat theme
  void updateChatTheme(ChatTheme theme) {
    _chatTheme = theme;
    _saveChatTheme();
    notifyListeners();
  }

  /// Add a new chat tab
  void addTab() {
    final tabId = 'chat_$_tabCounter';
    _tabs.add(
      HeaderTab(
        id: tabId,
        title: 'Chat $_tabCounter',
        icon: Icons.chat,
        closeable: _tabs.isNotEmpty, // First tab is not closeable
      ),
    );
    _selectedTabId = tabId;
    _tabStates[tabId] = ChatTabState(id: tabId);
    _tabCounter++;
    notifyListeners();

    if (kDebugMode) {
      debugPrint('➕ Added new tab: $tabId');
    }
  }

  /// Close a chat tab
  void closeTab(String tabId) {
    if (_tabs.length <= 1) return; // Don't close last tab

    final index = _tabs.indexWhere((tab) => tab.id == tabId);
    if (index == -1) return;

    _tabs.removeWhere((tab) => tab.id == tabId);
    _tabStates.remove(tabId);

    // Select previous or next tab
    if (_selectedTabId == tabId) {
      if (index > 0) {
        _selectedTabId = _tabs[index - 1].id;
      } else if (_tabs.isNotEmpty) {
        _selectedTabId = _tabs[0].id;
      } else {
        _selectedTabId = null;
      }
    }

    notifyListeners();

    if (kDebugMode) {
      debugPrint('❌ Closed tab: $tabId');
    }
  }

  /// Select a chat tab
  void selectTab(String tabId) {
    if (_tabs.any((tab) => tab.id == tabId)) {
      _selectedTabId = tabId;
      notifyListeners();

      if (kDebugMode) {
        debugPrint('🔍 Selected tab: $tabId');
      }
    }
  }

  /// Send message for a specific tab
  Future<void> sendMessageForTab(String tabId, String message) async {
    final tabState = _tabStates[tabId];
    if (tabState == null) return;

    if (message.trim().isEmpty) {
      return;
    }

    final selectedAiIntegration = tabState.selectedAiIntegration ?? _selectedAiIntegration;
    if (selectedAiIntegration == null) {
      if (kDebugMode) {
        debugPrint('❌ No AI integration selected for tab $tabId');
      }
      return;
    }

    try {
      tabState.isLoading = true;
      notifyListeners();

      // Add user message to tab
      tabState.messages.add(
        ChatMessage(
          message: message,
          isUser: true,
          timestamp: DateTime.now(),
          attachments: List.from(tabState.attachments),
        ),
      );
      notifyListeners();

      // Convert tab messages to API format
      final apiMessages = tabState.messages
          .map(
            (msg) => api.ChatMessage(
              role: msg.isUser ? enums.ChatMessageRole.user : enums.ChatMessageRole.assistant,
              content: msg.message,
            ),
          )
          .toList();

      api.ChatResponse? response;

      if (tabState.attachments.isNotEmpty) {
        // Send message with files
        tabState.isUploadingFiles = true;
        tabState.uploadProgress = 0.0;
        notifyListeners();

        // Simulate upload progress
        for (int i = 0; i <= 100; i += 20) {
          tabState.uploadProgress = i / 100.0;
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 100));
        }

        response = await _chatService.sendChatWithFiles(
          messages: apiMessages,
          files: tabState.attachments.map((a) => a.bytes).toList(),
          fileNames: tabState.attachments.map((a) => a.name).toList(),
          aiIntegrationId: selectedAiIntegration.id,
          mcpConfigurationId: tabState.selectedMcpConfiguration?.id ?? _selectedMcpConfiguration?.id,
        );

        tabState.isUploadingFiles = false;
        tabState.uploadProgress = null;
      } else {
        // Send regular chat completion
        response = await _chatService.sendChatCompletion(
          messages: apiMessages,
          aiIntegrationId: selectedAiIntegration.id,
          mcpConfigurationId: tabState.selectedMcpConfiguration?.id ?? _selectedMcpConfiguration?.id,
        );
      }

      if (response != null && response.success == true && response.content != null) {
        // Add AI response to tab's messages
        tabState.messages.add(ChatMessage(message: response.content!, isUser: false, timestamp: DateTime.now()));
        tabState.attachments.clear(); // Clear attachments after successful send
        tabState.isLoading = false;
        notifyListeners();

        if (kDebugMode) {
          debugPrint('✅ Message sent successfully for tab $tabId');
        }
      } else {
        // Remove user message if API call failed
        if (tabState.messages.isNotEmpty && tabState.messages.last.isUser) {
          tabState.messages.removeLast();
        }
        tabState.isLoading = false;
        notifyListeners();

        if (kDebugMode) {
          debugPrint('❌ Failed to send message for tab $tabId');
        }
      }
    } catch (e) {
      // Remove user message if error occurred
      if (tabState.messages.isNotEmpty && tabState.messages.last.isUser) {
        tabState.messages.removeLast();
      }
      tabState.isLoading = false;
      tabState.isUploadingFiles = false;
      tabState.uploadProgress = null;
      notifyListeners();

      if (kDebugMode) {
        debugPrint('❌ Error sending message for tab $tabId: $e');
      }
    }
  }

  /// Add attachments to a specific tab
  void addAttachmentsToTab(String tabId, List<FileAttachment> attachments) {
    final tabState = _tabStates[tabId];
    if (tabState != null) {
      tabState.attachments.addAll(attachments);
      notifyListeners();

      if (kDebugMode) {
        debugPrint('📎 Added ${attachments.length} attachments to tab $tabId');
      }
    }
  }

  /// Update attachments for a specific tab
  void updateAttachmentsForTab(String tabId, List<FileAttachment> attachments) {
    final tabState = _tabStates[tabId];
    if (tabState != null) {
      tabState.attachments.clear();
      tabState.attachments.addAll(attachments);
      notifyListeners();

      if (kDebugMode) {
        debugPrint('📎 Updated attachments for tab $tabId: ${attachments.length}');
      }
    }
  }

  /// Select AI integration for a specific tab
  void selectAiIntegrationForTab(String tabId, AiIntegration? integration) {
    final tabState = _tabStates[tabId];
    if (tabState != null) {
      tabState.selectedAiIntegration = integration;
      // Also update global selection
      selectAiIntegration(integration);
      notifyListeners();

      if (kDebugMode) {
        debugPrint('🤖 Selected AI integration for tab $tabId: ${integration?.displayName ?? 'None'}');
      }
    }
  }

  /// Select MCP configuration for a specific tab
  void selectMcpConfigurationForTab(String tabId, McpConfigOption? configuration) {
    final tabState = _tabStates[tabId];
    if (tabState != null) {
      tabState.selectedMcpConfiguration = configuration;
      // Also update global selection
      selectMcpConfiguration(configuration);
      notifyListeners();

      if (kDebugMode) {
        debugPrint('🔧 Selected MCP configuration for tab $tabId: ${configuration?.name ?? 'None'}');
      }
    }
  }

  /// Delete message from a specific tab
  void deleteMessageForTab(String tabId, int messageIndex) {
    final tabState = _tabStates[tabId];
    if (tabState == null) return;

    if (messageIndex < 0 || messageIndex >= tabState.messages.length) {
      if (kDebugMode) {
        debugPrint('❌ Invalid message index: $messageIndex');
      }
      return;
    }

    tabState.messages.removeAt(messageIndex);
    notifyListeners();

    if (kDebugMode) {
      debugPrint('🗑️ Deleted message at index $messageIndex from tab $tabId');
    }
  }

  /// Resend message from a specific tab
  /// Removes all messages after the selected message and resends the conversation
  Future<void> resendMessageForTab(String tabId, int messageIndex) async {
    final tabState = _tabStates[tabId];
    if (tabState == null) return;

    if (messageIndex < 0 || messageIndex >= tabState.messages.length) {
      if (kDebugMode) {
        debugPrint('❌ Invalid message index: $messageIndex');
      }
      return;
    }

    final message = tabState.messages[messageIndex];

    // Only allow resend on user messages
    if (!message.isUser) {
      if (kDebugMode) {
        debugPrint('❌ Can only resend user messages');
      }
      return;
    }

    final selectedAiIntegration = tabState.selectedAiIntegration ?? _selectedAiIntegration;
    if (selectedAiIntegration == null) {
      if (kDebugMode) {
        debugPrint('❌ No AI integration selected for tab $tabId');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint('🔄 Resending message at index $messageIndex from tab $tabId');
    }

    // Remove all messages after the selected message
    final messagesToRemove = tabState.messages.length - messageIndex - 1;
    if (messagesToRemove > 0) {
      tabState.messages.removeRange(messageIndex + 1, tabState.messages.length);
      if (kDebugMode) {
        debugPrint('🗑️ Removed $messagesToRemove messages after message at index $messageIndex');
      }
    }

    // Preserve attachments from the message being re-sent
    final messageAttachments = message.attachments.isNotEmpty
        ? List<FileAttachment>.from(message.attachments)
        : <FileAttachment>[];

    // Set loading state
    tabState.isLoading = true;
    notifyListeners();

    try {
      // Convert remaining messages to API format
      final apiMessages = tabState.messages
          .map(
            (msg) => api.ChatMessage(
              role: msg.isUser ? enums.ChatMessageRole.user : enums.ChatMessageRole.assistant,
              content: msg.message,
            ),
          )
          .toList();

      api.ChatResponse? response;

      if (messageAttachments.isNotEmpty) {
        // Send message with files
        tabState.isUploadingFiles = true;
        tabState.uploadProgress = 0.0;
        notifyListeners();

        // Simulate upload progress
        for (int i = 0; i <= 100; i += 20) {
          tabState.uploadProgress = i / 100.0;
          notifyListeners();
          await Future.delayed(const Duration(milliseconds: 100));
        }

        // Add file names to the last user message (the one being re-sent)
        if (apiMessages.isNotEmpty && apiMessages.last.role == enums.ChatMessageRole.user) {
          final lastMessage = apiMessages.last;
          apiMessages[apiMessages.length - 1] = api.ChatMessage(
            role: lastMessage.role,
            content: lastMessage.content,
            fileNames: messageAttachments.map((attachment) => attachment.name).toList(),
          );
        }

        response = await _chatService.sendChatWithFiles(
          messages: apiMessages,
          files: messageAttachments.map((a) => a.bytes).toList(),
          fileNames: messageAttachments.map((a) => a.name).toList(),
          aiIntegrationId: selectedAiIntegration.id,
          mcpConfigurationId: tabState.selectedMcpConfiguration?.id ?? _selectedMcpConfiguration?.id,
        );

        tabState.isUploadingFiles = false;
        tabState.uploadProgress = null;
      } else {
        // Send regular chat completion
        response = await _chatService.sendChatCompletion(
          messages: apiMessages,
          aiIntegrationId: selectedAiIntegration.id,
          mcpConfigurationId: tabState.selectedMcpConfiguration?.id ?? _selectedMcpConfiguration?.id,
        );
      }

      if (response != null && response.success == true && response.content != null) {
        // Add AI response to tab's messages
        tabState.messages.add(ChatMessage(message: response.content!, isUser: false, timestamp: DateTime.now()));
        tabState.isLoading = false;
        notifyListeners();

        if (kDebugMode) {
          debugPrint('✅ Message re-sent successfully for tab $tabId');
        }
      } else {
        tabState.isLoading = false;
        notifyListeners();

        if (kDebugMode) {
          debugPrint('❌ Failed to re-send message for tab $tabId');
        }
      }
    } catch (e) {
      tabState.isLoading = false;
      tabState.isUploadingFiles = false;
      tabState.uploadProgress = null;
      notifyListeners();

      if (kDebugMode) {
        debugPrint('❌ Error re-sending message for tab $tabId: $e');
      }
    }
  }

  /// Initialize first tab (private method)
  void _addNewTab() {
    final tabId = 'chat_$_tabCounter';
    _tabs.add(
      HeaderTab(
        id: tabId,
        title: 'Chat $_tabCounter',
        icon: Icons.chat,
        closeable: false, // First tab is not closeable
      ),
    );
    _selectedTabId = tabId;
    _tabStates[tabId] = ChatTabState(id: tabId);
    _tabCounter++;
  }

  @override
  void dispose() {
    // Clean up listeners
    final authProvider = _integrationService.authProvider;
    authProvider?.removeListener(_onAuthChanged);
    _mcpProvider.removeListener(_onMcpConfigurationsChanged);
    super.dispose();
  }
}
