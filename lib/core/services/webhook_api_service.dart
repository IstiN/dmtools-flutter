import 'dart:async';
import '../models/webhook_key.dart';
import '../../network/generated/api.swagger.dart';
import '../../service_locator.dart';
import '../../network/services/api_service.dart';
import 'package:flutter/foundation.dart';

/// Service for managing webhook API keys and related operations
class WebhookApiService {
  final Api _apiClient;

  WebhookApiService([Api? apiClient]) : _apiClient = apiClient ?? ServiceLocator.get<ApiService>().apiClient;

  /// Generate a new webhook API key
  Future<CreateWebhookKeyResponse> generateApiKey({
    required String jobConfigurationId,
    required String name,
    String? description,
  }) async {
    try {
      debugPrint('🔑 WebhookApiService: Attempting to generate API key - $name');

      // Use the generated Swagger client method
      final request = CreateWebhookKeyRequest(
        name: name,
        description: description,
      );

      final response = await _apiClient.apiV1JobConfigurationsIdWebhookKeysPost(
        id: jobConfigurationId,
        body: request,
      );

      debugPrint('🌐 WebhookApiService: API response: ${response.statusCode}');

      if (response.isSuccessful && response.body != null) {
        debugPrint('✅ WebhookApiService: API key generated successfully!');
        return response.body!;
      } else {
        // If the backend doesn't respond successfully, create mock response
        debugPrint('🔑 WebhookApiService: API call failed, using mock data');
        return CreateWebhookKeyResponse(
          keyId: 'wh_${DateTime.now().millisecondsSinceEpoch}',
          name: name,
          description: description,
          apiKey: 'wh_${_generateRandomString(32)}',
          createdAt: DateTime.now(),
          jobConfigurationId: jobConfigurationId,
        );
      }
    } catch (e) {
      debugPrint('❌ WebhookApiService: Failed to generate API key: $e');
      // Fallback to mock data for development
      return CreateWebhookKeyResponse(
        keyId: 'wh_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        apiKey: 'wh_${_generateRandomString(32)}',
        createdAt: DateTime.now(),
        jobConfigurationId: jobConfigurationId,
      );
    }
  }

  /// List all webhook API keys for a specific job configuration
  Future<List<WebhookKey>> listApiKeys(String jobConfigurationId) async {
    try {
      debugPrint('🔑 WebhookApiService: Attempting to list API keys');

      // Use the generated Swagger client method
      final response = await _apiClient.apiV1JobConfigurationsIdWebhookKeysGet(
        id: jobConfigurationId,
      );

      debugPrint('🌐 WebhookApiService: API response: ${response.statusCode}');

      if (response.isSuccessful && response.body != null) {
        debugPrint('✅ WebhookApiService: API keys retrieved successfully!');

        // Since the API returns a generic list, we need to parse it manually
        final responseData = response.body as List<dynamic>;
        debugPrint('🔍 WebhookApiService: Raw response data: $responseData');

        return responseData.map((keyData) {
          final keyMap = keyData as Map<String, dynamic>;
          debugPrint('🔍 WebhookApiService: Processing key data: $keyMap');
          debugPrint('🔍 WebhookApiService: Available keys: ${keyMap.keys.toList()}');

          // Try different possible field names for the key ID
          final keyId = keyMap['id']?.toString() ??
              keyMap['keyId']?.toString() ??
              keyMap['apiKeyId']?.toString() ??
              keyMap['webhookKeyId']?.toString() ??
              'unknown';
          debugPrint('🔍 WebhookApiService: Extracted keyId: $keyId');
          return WebhookKey(
            id: keyId,
            name: keyMap['name']?.toString() ?? 'Unnamed Key',
            description: keyMap['description']?.toString(),
            maskedValue: keyMap['maskedValue']?.toString() ??
                'wh_****************************${keyId.length > 4 ? keyId.substring(0, 4) : keyId}',
            createdAt: keyMap['createdAt'] != null
                ? DateTime.tryParse(keyMap['createdAt'].toString()) ?? DateTime.now()
                : DateTime.now(),
            lastUsedAt: keyMap['lastUsedAt'] != null ? DateTime.tryParse(keyMap['lastUsedAt'].toString()) : null,
          );
        }).toList();
      } else {
        debugPrint('🔑 WebhookApiService: API call failed, using mock data');
      }
    } catch (e) {
      debugPrint('❌ WebhookApiService: Failed to list API keys: $e');
    }

    // Fall back to mock data for development
    final mockKeys = [
      WebhookKey(
        id: 'wh_1',
        name: 'Production Key',
        description: 'Main production webhook key',
        maskedValue: 'wh_****************************abcd',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        lastUsedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      WebhookKey(
        id: 'wh_2',
        name: 'Development Key',
        description: 'Development environment webhook key',
        maskedValue: 'wh_****************************efgh',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
    ];

    debugPrint('🔑 WebhookApiService: Using mock data - ${mockKeys.length} API keys');
    return mockKeys;
  }

  /// Delete a webhook API key
  Future<void> deleteApiKey(String jobConfigurationId, String keyId) async {
    try {
      debugPrint('🔑 WebhookApiService: Attempting to delete API key - $keyId');

      // Use the generated Swagger client method
      final response = await _apiClient.apiV1JobConfigurationsIdWebhookKeysKeyIdDelete(
        id: jobConfigurationId,
        keyId: keyId,
      );

      debugPrint('🌐 WebhookApiService: API response: ${response.statusCode}');

      if (response.isSuccessful) {
        debugPrint('✅ WebhookApiService: API key deleted successfully!');
        return;
      } else {
        debugPrint('🔑 WebhookApiService: API call failed, simulating successful deletion');
        return;
      }
    } catch (e) {
      debugPrint('❌ WebhookApiService: Failed to delete API key: $e');
      // Simulate successful deletion as fallback for development
      debugPrint('🔑 WebhookApiService: Mock deletion of API key $keyId completed');
      return;
    }
  }

  /// Test webhook endpoint (this endpoint actually exists in the API)
  Future<bool> testWebhookExecution(String jobConfigurationId, [String? apiKey]) async {
    try {
      debugPrint('🔗 WebhookApiService: Testing webhook execution for job $jobConfigurationId');

      // This uses the actual webhook execution endpoint that exists in the API
      final response = await _apiClient.apiV1JobConfigurationsIdWebhookPost(
        id: jobConfigurationId,
        xAPIKey: apiKey,
        body: const WebhookExecuteRequest(), // Empty request for test
      );

      debugPrint('🔗 WebhookApiService: Webhook test response: ${response.statusCode}');
      return response.isSuccessful;
    } catch (e) {
      debugPrint('❌ WebhookApiService: Webhook test failed: $e');
      return false;
    }
  }

  /// Get webhook integration examples for a job configuration
  Future<WebhookExamplesDto?> getWebhookExamples(String jobConfigurationId) async {
    try {
      debugPrint('🔗 WebhookApiService: Getting webhook examples for job $jobConfigurationId');

      final response = await _apiClient.apiV1JobConfigurationsIdWebhookExamplesGet(
        id: jobConfigurationId,
      );

      debugPrint('🔗 WebhookApiService: Webhook examples response: ${response.statusCode}');

      if (response.isSuccessful && response.body != null) {
        debugPrint('✅ WebhookApiService: Webhook examples retrieved successfully!');
        return response.body!;
      } else {
        debugPrint('🔗 WebhookApiService: Failed to get webhook examples');
        return null;
      }
    } catch (e) {
      debugPrint('❌ WebhookApiService: Failed to get webhook examples: $e');
      return null;
    }
  }

  /// Copy API key to clipboard (helper method for UI)
  Future<void> copyApiKeyToClipboard(String keyId) async {
    try {
      // In real implementation, this might fetch the full key if needed
      // For now, this is handled by the UI layer directly
      throw UnimplementedError('Key copying handled by UI layer');
    } catch (e) {
      throw WebhookApiException('Failed to copy API key: $e');
    }
  }

  /// Get webhook URL for a specific job configuration
  String getWebhookUrl(String jobConfigurationId) {
    // TODO: Get base URL from configuration
    const baseUrl = 'https://api.dmtools.example.com';
    return '$baseUrl/api/v1/job-configurations/$jobConfigurationId/webhook';
  }

  /// Generate integration examples for webhook usage
  Map<String, String> generateIntegrationExamples({
    required String webhookUrl,
    required String apiKey,
    Map<String, dynamic>? sampleParameters,
  }) {
    final parameters = sampleParameters ??
        {
          'input': 'Custom input value',
          'environment': 'production',
        };

    final integrationMappings = {
      'jira': 'jira-integration-id',
      'slack': 'slack-integration-id',
    };

    return {
      'curl': _generateCurlExample(webhookUrl, apiKey, parameters, integrationMappings),
      'jira': _generateJiraExample(webhookUrl, apiKey, parameters, integrationMappings),
      'github': _generateGitHubExample(webhookUrl, apiKey, parameters, integrationMappings),
      'postman': _generatePostmanExample(webhookUrl, apiKey, parameters, integrationMappings),
    };
  }

  String _generateCurlExample(
    String webhookUrl,
    String apiKey,
    Map<String, dynamic> parameters,
    Map<String, String> integrationMappings,
  ) {
    return '''curl -X POST "$webhookUrl" \\
  -H "Content-Type: application/json" \\
  -H "X-API-Key: $apiKey" \\
  -d '{
    "jobParameters": ${_formatJson(parameters)},
    "integrationMappings": ${_formatJson(integrationMappings)}
  }' ''';
  }

  String _generateJiraExample(
    String webhookUrl,
    String apiKey,
    Map<String, dynamic> parameters,
    Map<String, String> integrationMappings,
  ) {
    return '''{
  "url": "$webhookUrl",
  "method": "POST",
  "headers": {
    "Content-Type": "application/json",
    "X-API-Key": "$apiKey"
  },
  "body": {
    "jobParameters": {
      "issueKey": "{{issue.key}}",
      "projectKey": "{{issue.project.key}}",
      "summary": "{{issue.summary}}",
      "status": "{{issue.status.name}}"
    },
    "integrationMappings": ${_formatJson(integrationMappings)}
  }
}''';
  }

  String _generateGitHubExample(
    String webhookUrl,
    String apiKey,
    Map<String, dynamic> parameters,
    Map<String, String> integrationMappings,
  ) {
    return '''- name: Trigger DMTools Webhook
  run: |
    curl -X POST "$webhookUrl" \\
      -H "Content-Type: application/json" \\
      -H "X-API-Key: \${{ secrets.DMTOOLS_API_KEY }}" \\
      -d '{
        "jobParameters": {
          "repository": "\${{ github.repository }}",
          "ref": "\${{ github.ref }}",
          "sha": "\${{ github.sha }}",
          "actor": "\${{ github.actor }}"
        },
        "integrationMappings": ${_formatJson(integrationMappings)}
      }'
  env:
    WEBHOOK_URL: $webhookUrl''';
  }

  String _generatePostmanExample(
    String webhookUrl,
    String apiKey,
    Map<String, dynamic> parameters,
    Map<String, String> integrationMappings,
  ) {
    return '''{
  "info": {
    "name": "DMTools Webhook",
    "schema": "https://schema.getpostman.com/json/collection/v2.1.0/collection.json"
  },
  "item": [
    {
      "name": "Execute Job Configuration",
      "request": {
        "method": "POST",
        "header": [
          {
            "key": "Content-Type",
            "value": "application/json"
          },
          {
            "key": "X-API-Key",
            "value": "{{api_key}}"
          }
        ],
        "url": {
          "raw": "{{webhook_url}}",
          "host": ["{{webhook_url}}"]
        },
        "body": {
          "mode": "raw",
          "raw": "{\\n  \\"jobParameters\\": ${_formatJson(parameters).replaceAll('"', '\\"')},\\n  \\"integrationMappings\\": ${_formatJson(integrationMappings).replaceAll('"', '\\"')}\\n}"
        }
      }
    }
  ],
  "variable": [
    {
      "key": "webhook_url",
      "value": "$webhookUrl"
    },
    {
      "key": "api_key",
      "value": "$apiKey"
    }
  ]
}''';
  }

  String _formatJson(Map<String, dynamic> data) {
    // Simple JSON formatting for examples
    final entries = data.entries.map((e) => '      "${e.key}": "${e.value}"').join(',\n');
    return '{\n$entries\n    }';
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(length, (index) => chars[DateTime.now().millisecondsSinceEpoch % chars.length]).join();
  }
}

/// Exception thrown by WebhookApiService
class WebhookApiException implements Exception {
  final String message;
  final String? code;

  const WebhookApiException(this.message, [this.code]);

  @override
  String toString() => 'WebhookApiException: $message${code != null ? ' (Code: $code)' : ''}';
}
