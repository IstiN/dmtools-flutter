import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:chopper/chopper.dart';
import '../models/mcp_configuration.dart';
import '../../network/generated/api.swagger.dart';
import '../../network/generated/api.models.swagger.dart' as api;
import '../../network/clients/api_client.dart';
import '../../core/interfaces/auth_token_provider.dart';

/// Service for managing MCP (Model Context Protocol) configurations
class McpService {
  late final ChopperClient _client;
  late final Api _apiService;

  McpService({String? baseUrl, AuthTokenProvider? authProvider, bool enableLogging = true}) {
    _client = ApiClientConfig.createClient(baseUrl: baseUrl, authProvider: authProvider, enableLogging: enableLogging);
    _apiService = _client.getService<Api>();
  }

  /// Get all MCP configurations for the current user
  Future<List<McpConfiguration>> getMcpConfigurations() async {
    debugPrint('🔧 McpService: Getting MCP configurations via manual request...');
    try {
      // Manually create and send the request to get the raw response
      final request = Request('GET', Uri.parse('/api/mcp/configurations'), _client.baseUrl);
      final response = await _client.send<dynamic, dynamic>(request);

      debugPrint('🔧 McpService: Manual API response received, successful: ${response.isSuccessful}');
      debugPrint('🔧 McpService: Manual API response status code: ${response.statusCode}');

      if (response.isSuccessful) {
        // Use bodyString to get the raw JSON and parse it manually
        final rawJsonString = response.bodyString;
        debugPrint('🔧 McpService: Raw JSON response: $rawJsonString');
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is List) {
          final configs = decodedJson
              .map((json) {
                try {
                  return _mapJsonToModel(json as Map<String, dynamic>);
                } catch (e) {
                  debugPrint('🔧 McpService: Error parsing single configuration from JSON: $e');
                  return null;
                }
              })
              .whereType<McpConfiguration>()
              .toList();

          debugPrint('🔧 McpService: Manually mapped ${configs.length} configurations');
          return configs;
        } else {
          debugPrint('🔧 McpService: Decoded JSON is not a List.');
          return [];
        }
      } else {
        debugPrint('🔧 McpService: Manual API error: ${response.error}');
        throw Exception('Failed to fetch MCP configurations: ${response.error}');
      }
    } catch (e) {
      debugPrint('🔧 McpService: Exception in getMcpConfigurations: $e');
      throw Exception('Error fetching MCP configurations: $e');
    }
  }

  /// Get a specific MCP configuration by ID
  Future<McpConfiguration> getMcpConfiguration(String id) async {
    try {
      debugPrint('🔧 McpService: Getting MCP configuration with ID: $id');
      final response = await _apiService.apiMcpConfigurationsConfigIdGet(configId: id);
      debugPrint('🔧 McpService: API response received, successful: ${response.isSuccessful}');

      if (response.isSuccessful) {
        final rawJsonString = response.bodyString;
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is Map<String, dynamic>) {
          return _mapJsonToModel(decodedJson);
        } else {
          throw Exception('Invalid response format: Expected a JSON object');
        }
      } else {
        debugPrint('🔧 McpService: API error: ${response.error}');
        throw Exception('Failed to fetch MCP configuration: ${response.error}');
      }
    } catch (e) {
      debugPrint('🔧 McpService: Exception in getMcpConfiguration: $e');
      throw Exception('Error fetching MCP configuration: $e');
    }
  }

  /// Create a new MCP configuration
  Future<McpConfiguration> createMcpConfiguration({
    required String name,
    required List<String> integrationIds,
    String? description, // Note: API doesn't support description yet
  }) async {
    try {
      debugPrint('🔧 McpService: Creating MCP with integrationIds: $integrationIds');

      final request = api.CreateMcpConfigurationRequest(name: name, integrationIds: integrationIds);

      debugPrint('🔧 McpService: Request created: $request');
      debugPrint('🔧 McpService: Request JSON: ${request.toJson()}');
      debugPrint('🔧 McpService: About to call API');

      final response = await _apiService.apiMcpConfigurationsPost(body: request);

      debugPrint('🔧 McpService: API response received');
      debugPrint('🔧 McpService: Response successful: ${response.isSuccessful}');
      debugPrint('🔧 McpService: Response status code: ${response.statusCode}');

      if (response.isSuccessful) {
        final rawJsonString = response.bodyString;
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is Map<String, dynamic>) {
          final model = _mapJsonToModel(decodedJson);
          debugPrint('🔧 McpService: Model created from manual parse: $model');
          return model;
        } else {
          throw Exception('Failed to create MCP configuration: Invalid response format');
        }
      } else {
        debugPrint('🔧 McpService: API error: ${response.error}');
        debugPrint('🔧 McpService: Response body: ${response.bodyString}');
        throw Exception('Failed to create MCP configuration: ${response.error}');
      }
    } catch (e, stackTrace) {
      debugPrint('🔧 McpService: Exception in createMcpConfiguration: $e');
      debugPrint('🔧 McpService: Stack trace: $stackTrace');
      throw Exception('Error creating MCP configuration: $e');
    }
  }

  /// Update an existing MCP configuration
  Future<McpConfiguration> updateMcpConfiguration({
    required String id,
    required String name,
    required List<String> integrationIds,
    String? description, // Note: API doesn't support description yet
  }) async {
    try {
      debugPrint('🔧 McpService: Updating MCP configuration $id with name: $name, integrationIds: $integrationIds');

      final request = api.CreateMcpConfigurationRequest(name: name, integrationIds: integrationIds);

      debugPrint('🔧 McpService: Update request created: $request');
      debugPrint('🔧 McpService: Update request JSON: ${request.toJson()}');
      debugPrint('🔧 McpService: About to call update API');

      final response = await _apiService.apiMcpConfigurationsConfigIdPut(configId: id, body: request);

      debugPrint('🔧 McpService: Update API response received');
      debugPrint('🔧 McpService: Update response successful: ${response.isSuccessful}');
      debugPrint('🔧 McpService: Update response status code: ${response.statusCode}');

      if (response.isSuccessful) {
        final rawJsonString = response.bodyString;
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is Map<String, dynamic>) {
          final model = _mapJsonToModel(decodedJson);
          debugPrint('🔧 McpService: Updated model created from manual parse: $model');
          return model;
        } else {
          throw Exception('Failed to update MCP configuration: Invalid response format');
        }
      } else {
        debugPrint('🔧 McpService: Update API error: ${response.error}');
        debugPrint('🔧 McpService: Update response body: ${response.bodyString}');
        throw Exception('Failed to update MCP configuration: ${response.error}');
      }
    } catch (e, stackTrace) {
      debugPrint('🔧 McpService: Exception in updateMcpConfiguration: $e');
      debugPrint('🔧 McpService: Stack trace: $stackTrace');
      throw Exception('Error updating MCP configuration: $e');
    }
  }

  /// Delete an MCP configuration
  Future<void> deleteMcpConfiguration(String id) async {
    try {
      final response = await _apiService.apiMcpConfigurationsConfigIdDelete(configId: id);

      if (!response.isSuccessful) {
        throw Exception('Failed to delete MCP configuration: ${response.error}');
      }
    } catch (e) {
      throw Exception('Error deleting MCP configuration: $e');
    }
  }

  /// Generate configuration code for an MCP configuration
  Future<String> generateMcpConfigurationCode(String id, {String format = 'json'}) async {
    debugPrint('🔧 McpService: Generating code for config $id with format $format');
    try {
      final response = await _apiService.apiMcpConfigurationsConfigIdAccessCodeGet(
        configId: id,
        format: format,
      );

      if (response.isSuccessful && response.body != null) {
        final rawJsonString = response.bodyString;
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is Map<String, dynamic> && decodedJson.containsKey('code')) {
          final code = decodedJson['code'] as String;
          debugPrint('🔧 McpService: Successfully generated code for format: $format');
          return code;
        } else {
          debugPrint('🔧 McpService: Invalid code response format');
          return 'Error: Invalid response format from server.';
        }
      } else {
        debugPrint('🔧 McpService: API error generating code: ${response.error}');
        throw Exception('Failed to generate MCP configuration code: ${response.error}');
      }
    } catch (e) {
      debugPrint('🔧 McpService: Exception in generateMcpConfigurationCode: $e');
      throw Exception('Error generating MCP configuration code: $e');
    }
  }

  /// Maps raw JSON to local model, bypassing the generated DTO
  McpConfiguration _mapJsonToModel(Map<String, dynamic> json) {
    debugPrint('🔧 McpService: Mapping JSON: $json');

    // Safely parse integration IDs
    List<String> integrationIds = [];
    if (json['integrationIds'] != null) {
      try {
        if (json['integrationIds'] is List) {
          integrationIds = (json['integrationIds'] as List).map((item) => item.toString()).toList();
        } else {
          integrationIds = [json['integrationIds'].toString()];
        }
      } catch (e) {
        debugPrint('🔧 McpService: Error parsing integrationIds from JSON: $e');
      }
    }

    // Safely parse date arrays
    DateTime? parseDate(dynamic dateValue) {
      if (dateValue is List) {
        try {
          if (dateValue.length >= 3) {
            return DateTime(
              (dateValue[0] as num).toInt(),
              (dateValue[1] as num).toInt(),
              (dateValue[2] as num).toInt(),
              dateValue.length > 3 ? (dateValue[3] as num).toInt() : 0,
              dateValue.length > 4 ? (dateValue[4] as num).toInt() : 0,
              dateValue.length > 5 ? (dateValue[5] as num).toInt() : 0,
            );
          }
        } catch (e) {
          debugPrint('🔧 McpService: Error parsing date list: $e');
        }
      } else if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          debugPrint('🔧 McpService: Error parsing date string: $e');
        }
      }
      return null;
    }

    final createdAt = parseDate(json['createdAt']);
    final updatedAt = parseDate(json['updatedAt']);

    return McpConfiguration(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      integrationIds: integrationIds,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Removed _parseIntegrations, _parseIntegrationType, and _parseStatus methods
  // as we now work with integration IDs directly and API doesn't provide status yet

  /// Dispose resources
  void dispose() {
    _client.dispose();
  }
}
