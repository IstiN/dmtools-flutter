import 'package:flutter/foundation.dart';
import '../../network/services/api_service.dart';
import '../../network/generated/api.swagger.dart' as api;
import '../../core/interfaces/auth_token_provider.dart';
import '../../core/config/app_config.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

/// Service for managing chat operations with AI integrations
class ChatService with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  final ApiService _apiService;
  final AuthTokenProvider? _authProvider;

  bool get isLoading => _isLoading;
  String? get error => _error;
  AuthTokenProvider? get authProvider => _authProvider;

  ChatService({required ApiService apiService, AuthTokenProvider? authProvider})
    : _apiService = apiService,
      _authProvider = authProvider;

  // Check if we should use mock data based on demo mode
  bool get _shouldUseMockData {
    final shouldUseMock = _authProvider?.shouldUseMockData ?? true;
    if (kDebugMode) {
      debugPrint('🔧 ChatService mock mode: $shouldUseMock');
    }
    return shouldUseMock;
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Send a simple text message to chat endpoint
  /// Uses the /api/v1/chat/simple endpoint for basic text-only messages
  Future<api.ChatResponse?> sendSimpleMessage({required String message, String? model, String? aiIntegrationId}) async {
    if (message.trim().isEmpty) {
      throw ArgumentError('Message cannot be empty');
    }

    try {
      _setLoading(true);
      _clearError();

      if (_shouldUseMockData) {
        // Mock response for development
        if (kDebugMode) {
          debugPrint('🤖 Mock ChatService: sendSimpleMessage($message, $model)');
        }
        await Future.delayed(const Duration(milliseconds: 800));

        final mockResponse = api.ChatResponse(content: 'This is a mock response to: "$message"', success: true);

        _setLoading(false);
        return mockResponse;
      } else {
        // Check if user is authenticated before making API calls
        if (_authProvider?.isAuthenticated != true) {
          if (kDebugMode) {
            debugPrint('⏳ User not authenticated yet, waiting for authentication...');
          }
          throw Exception('User not authenticated');
        }

        // Use real API service
        if (kDebugMode) {
          debugPrint('🌐 Making real API call to send simple message');
        }

        final response = await _apiService.apiClient.apiV1ChatSimplePost(
          message: message,
          model: model,
          ai: aiIntegrationId,
        );

        if (response.isSuccessful && response.body != null) {
          if (kDebugMode) {
            debugPrint('✅ Chat response received: ${response.body?.content?.length} chars');
          }
          _setLoading(false);
          return response.body;
        } else {
          throw Exception('Chat API error: ${response.error}');
        }
      }
    } catch (e) {
      _setError('Failed to send message: ${e.toString()}');
      if (kDebugMode) {
        debugPrint('❌ Error sending simple message: $e');
      }
      _setLoading(false);
      return null;
    }
  }

  /// Send a structured chat request with full conversation context
  /// Uses the /api/v1/chat/completions endpoint for advanced chat features
  Future<api.ChatResponse?> sendChatCompletion({
    required List<api.ChatMessage> messages,
    String? aiIntegrationId,
    String? mcpConfigurationId,
    List<Object>? agentTools,
  }) async {
    if (messages.isEmpty) {
      throw ArgumentError('Messages list cannot be empty');
    }

    try {
      _setLoading(true);
      _clearError();

      if (_shouldUseMockData) {
        // Mock response for development
        if (kDebugMode) {
          debugPrint('🤖 Mock ChatService: sendChatCompletion(${messages.length} messages, AI: $aiIntegrationId)');
        }
        await Future.delayed(const Duration(milliseconds: 1000));

        final lastMessage = messages.last.content;
        final mockResponse = api.ChatResponse(
          content: 'This is a mock completion response to: "$lastMessage"',
          success: true,
        );

        _setLoading(false);
        return mockResponse;
      } else {
        // Check if user is authenticated before making API calls
        if (_authProvider?.isAuthenticated != true) {
          if (kDebugMode) {
            debugPrint('⏳ User not authenticated yet, waiting for authentication...');
          }
          throw Exception('User not authenticated');
        }

        // Use real API service
        if (kDebugMode) {
          debugPrint('🌐 Making real API call to send chat completion');
        }

        final chatRequest = api.ChatRequest(messages: messages, ai: aiIntegrationId, mcpConfigId: mcpConfigurationId);

        final response = await _apiService.apiClient.apiV1ChatCompletionsPost(body: chatRequest);

        if (response.isSuccessful && response.body != null) {
          if (kDebugMode) {
            debugPrint('✅ Chat completion response received: ${response.body?.content?.length} chars');
          }
          _setLoading(false);
          return response.body;
        } else {
          throw Exception('Chat completion API error: ${response.error}');
        }
      }
    } catch (e) {
      _setError('Failed to send chat completion: ${e.toString()}');
      if (kDebugMode) {
        debugPrint('❌ Error sending chat completion: $e');
      }
      _setLoading(false);
      return null;
    }
  }

  /// Send chat message with file attachments
  /// Uses the /api/v1/chat/completions-with-files endpoint for multipart uploads
  Future<api.ChatResponse?> sendChatWithFiles({
    required List<api.ChatMessage> messages,
    required List<List<int>> files,
    List<String>? fileNames,
    String? aiIntegrationId,
    String? mcpConfigurationId,
    List<Object>? agentTools,
  }) async {
    if (messages.isEmpty) {
      throw ArgumentError('Messages list cannot be empty');
    }
    if (files.isEmpty) {
      throw ArgumentError('Files list cannot be empty for this endpoint');
    }

    try {
      _setLoading(true);
      _clearError();

      if (_shouldUseMockData) {
        // Mock response for development
        if (kDebugMode) {
          debugPrint(
            '🤖 Mock ChatService: sendChatWithFiles(${messages.length} messages, ${files.length} files, AI: $aiIntegrationId)',
          );
        }
        await Future.delayed(const Duration(milliseconds: 1500));

        final lastMessage = messages.last.content;
        final mockResponse = api.ChatResponse(
          content: 'This is a mock response with ${files.length} file(s) to: "$lastMessage"',
          success: true,
        );

        _setLoading(false);
        return mockResponse;
      } else {
        // Check if user is authenticated before making API calls
        if (_authProvider?.isAuthenticated != true) {
          if (kDebugMode) {
            debugPrint('⏳ User not authenticated yet, waiting for authentication...');
          }
          throw Exception('User not authenticated');
        }

        // Use real API service
        if (kDebugMode) {
          debugPrint('🌐 Making real API call to send chat with files');
        }

        final chatRequest = api.ChatRequest(messages: messages, ai: aiIntegrationId, mcpConfigId: mcpConfigurationId);

        // Convert ChatRequest to JSON string for multipart upload
        final chatRequestJson = jsonEncode(chatRequest.toJson());

        // Try to work around the API generation issue
        // Convert byte arrays to the format that the API expects
        try {
          final response = await _apiService.apiClient.apiV1ChatCompletionsWithFilesPost(
            chatRequest: chatRequestJson,
            files: files,
          );

          if (response.isSuccessful && response.body != null) {
            if (kDebugMode) {
              debugPrint('✅ Chat with files response received: ${response.body?.content?.length} chars');
            }
            _setLoading(false);
            return response.body;
          } else {
            throw Exception('Chat with files API error: ${response.error}');
          }
        } catch (apiError) {
          if (kDebugMode) {
            debugPrint('❌ Generated API failed: $apiError');
            debugPrint('🔄 Attempting manual HTTP request...');
          }

          // Fallback: Use manual HTTP request
          final response = await _makeManualFileUploadRequest(
            chatRequestJson,
            files,
            fileNames ?? List.generate(files.length, (i) => 'file_$i.bin'),
          );

          _setLoading(false);
          return response;
        }
      }
    } catch (e) {
      _setError('Failed to send chat with files: ${e.toString()}');
      if (kDebugMode) {
        debugPrint('❌ Error sending chat with files: $e');
      }
      _setLoading(false);
      return null;
    }
  }

  /// Manual HTTP request for file upload when generated API fails
  Future<api.ChatResponse?> _makeManualFileUploadRequest(
    String chatRequestJson,
    List<List<int>> files,
    List<String> fileNames,
  ) async {
    try {
      // Use http package directly for multipart upload
      final uri = Uri.parse('${AppConfig.baseUrl}/api/v1/chat/completions-with-files');
      final request = http.MultipartRequest('POST', uri);

      // Add authorization header if available
      final token = await _authProvider?.getAccessToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add chat request as a field
      request.fields['chatRequest'] = chatRequestJson;

      // Add files as multipart files
      for (int i = 0; i < files.length; i++) {
        final fileBytes = files[i];
        final fileName = i < fileNames.length ? fileNames[i] : 'file_$i.bin';

        request.files.add(http.MultipartFile.fromBytes('files', fileBytes, filename: fileName));
      }

      if (kDebugMode) {
        debugPrint('🌐 Making manual HTTP multipart request to $uri');
        debugPrint('📎 Uploading ${files.length} files');
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final chatResponse = api.ChatResponse.fromJson(jsonResponse);

        if (kDebugMode) {
          debugPrint('✅ Manual HTTP request successful: ${chatResponse.content?.length} chars');
        }

        return chatResponse;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Manual HTTP request failed: $e');
      }
      rethrow;
    }
  }

  /// Clear any error state
  void clearError() {
    _clearError();
  }

  /// Reset service state
  void reset() {
    _setLoading(false);
    _clearError();
  }
}
