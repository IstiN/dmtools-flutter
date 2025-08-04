import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../core/models/webhook_key.dart';
import '../core/services/webhook_api_service.dart';

/// State management for webhook operations and API key management
class WebhookStateProvider extends ChangeNotifier {
  final WebhookApiService _webhookApiService;
  final String _jobConfigurationId;

  WebhookStateProvider(this._webhookApiService, this._jobConfigurationId) {
    // Automatically load API keys when the provider is created
    loadApiKeys();
  }

  // State variables
  List<WebhookKey> _apiKeys = [];
  bool _isLoading = false;
  String? _loadingKeyId;
  String? _error;
  String? _generatedApiKey;
  String? _generatedKeyName;

  // Getters
  List<WebhookKey> get apiKeys => _apiKeys;
  bool get isLoading => _isLoading;
  String? get loadingKeyId => _loadingKeyId;
  String? get error => _error;
  String? get generatedApiKey => _generatedApiKey;
  String? get generatedKeyName => _generatedKeyName;

  /// Load API keys from the server
  Future<void> loadApiKeys() async {
    debugPrint('🔄 WebhookStateProvider: Starting to load API keys...');
    _setLoading(true);
    _clearError();

    try {
      _apiKeys = await _webhookApiService.listApiKeys(_jobConfigurationId);
      debugPrint('✅ WebhookStateProvider: Successfully loaded ${_apiKeys.length} API keys');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ WebhookStateProvider: Failed to load API keys: $e');
      _setError('Failed to load API keys: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Generate a new API key
  Future<void> generateApiKey({
    required String name,
    String? description,
  }) async {
    debugPrint('🔄 WebhookStateProvider: Starting to generate API key "$name"...');
    _setLoading(true);
    _clearError();

    try {
      final response = await _webhookApiService.generateApiKey(
        jobConfigurationId: _jobConfigurationId,
        name: name,
        description: description,
      );

      debugPrint(
          '✅ WebhookStateProvider: Successfully generated API key "${response.name}" with ID: ${response.keyId}');

      // Store the generated key for one-time display
      _generatedApiKey = response.apiKey;
      _generatedKeyName = response.name;

      // Add the new key to the list (without the actual key value)
      final newKey = WebhookKey(
        id: response.keyId ?? 'unknown',
        name: response.name ?? name,
        description: response.description,
        maskedValue: _maskApiKey(response.apiKey ?? ''),
        createdAt: response.createdAt ?? DateTime.now(),
      );

      _apiKeys = [..._apiKeys, newKey];
      notifyListeners();
    } catch (e) {
      debugPrint('❌ WebhookStateProvider: Failed to generate API key: $e');
      _setError('Failed to generate API key: $e');
    } finally {
      _setLoading(false);
    }
  }

  /// Delete an API key
  Future<void> deleteApiKey(String keyId) async {
    debugPrint('🔄 WebhookStateProvider: Starting to delete API key $keyId...');
    _setLoadingKey(keyId);
    _clearError();

    try {
      await _webhookApiService.deleteApiKey(_jobConfigurationId, keyId);
      _apiKeys = _apiKeys.where((key) => key.id != keyId).toList();
      debugPrint('✅ WebhookStateProvider: Successfully deleted API key $keyId');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ WebhookStateProvider: Failed to delete API key: $e');
      _setError('Failed to delete API key: $e');
    } finally {
      _clearLoadingKey();
    }
  }

  /// Copy API key to clipboard
  Future<void> copyApiKey(String keyId) async {
    try {
      // For actual implementation, you might need to fetch the full key
      // For now, show a placeholder message
      final key = _apiKeys.firstWhere((k) => k.id == keyId);

      if (_generatedApiKey != null && _generatedKeyName == key.name) {
        // Copy the actual generated key if it's available
        await Clipboard.setData(ClipboardData(text: _generatedApiKey!));
      } else {
        // In real implementation, this would either:
        // 1. Fetch the full key from the server (if supported)
        // 2. Show an error that the key cannot be retrieved again
        throw Exception('API key cannot be retrieved again. Please generate a new one if needed.');
      }
    } catch (e) {
      _setError('Failed to copy API key: $e');
    }
  }

  /// Copy webhook URL to clipboard
  Future<void> copyWebhookUrl(String jobConfigurationId) async {
    try {
      final webhookUrl = _webhookApiService.getWebhookUrl(jobConfigurationId);
      await Clipboard.setData(ClipboardData(text: webhookUrl));
    } catch (e) {
      _setError('Failed to copy webhook URL: $e');
    }
  }

  /// Get webhook URL for a job configuration
  String getWebhookUrl(String jobConfigurationId) {
    return _webhookApiService.getWebhookUrl(jobConfigurationId);
  }

  /// Generate integration examples
  Map<String, String> generateIntegrationExamples({
    required String jobConfigurationId,
    String? sampleApiKey,
    Map<String, dynamic>? sampleParameters,
  }) {
    final webhookUrl = getWebhookUrl(jobConfigurationId);
    final apiKey = sampleApiKey ?? 'your-api-key-here';

    return _webhookApiService.generateIntegrationExamples(
      webhookUrl: webhookUrl,
      apiKey: apiKey,
      sampleParameters: sampleParameters,
    );
  }

  /// Clear the generated API key (after user has saved it)
  void clearGeneratedApiKey() {
    _generatedApiKey = null;
    _generatedKeyName = null;
    notifyListeners();
  }

  /// Clear error state
  void clearError() {
    _clearError();
  }

  /// Refresh API keys (reload from server)
  Future<void> refresh() async {
    await loadApiKeys();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setLoadingKey(String keyId) {
    _loadingKeyId = keyId;
    notifyListeners();
  }

  void _clearLoadingKey() {
    _loadingKeyId = null;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Mask an API key for display (show first 4 and last 4 characters)
  String _maskApiKey(String apiKey) {
    if (apiKey.length <= 8) return apiKey; // Don't mask short keys

    final start = apiKey.substring(0, 4);
    final end = apiKey.substring(apiKey.length - 4);
    final middle = '*' * (apiKey.length - 8);

    return '$start$middle$end';
  }
}
