import 'dart:convert';
import 'package:chopper/chopper.dart';
import '../models/mcp_configuration.dart';
import '../../network/generated/openapi.swagger.dart';
import '../../network/generated/openapi.models.swagger.dart' as api;
import '../../network/clients/api_client.dart';
import '../../providers/auth_provider.dart';

/// Service for managing MCP (Model Context Protocol) configurations
class McpService {
  late final ChopperClient _client;
  late final Openapi _apiService;

  McpService({String? baseUrl, AuthProvider? authProvider, bool enableLogging = true}) {
    _client = ApiClientConfig.createClient(baseUrl: baseUrl, authProvider: authProvider, enableLogging: enableLogging);
    _apiService = _client.getService<Openapi>();
  }

  /// Get all MCP configurations for the current user
  Future<List<McpConfiguration>> getMcpConfigurations() async {
    print('🔧 McpService: Getting MCP configurations via manual request...');
    try {
      // Manually create and send the request to get the raw response
      final request = Request('GET', Uri.parse('/api/mcp/configurations'), _client.baseUrl);
      final response = await _client.send<dynamic, dynamic>(request);

      print('🔧 McpService: Manual API response received, successful: ${response.isSuccessful}');
      print('🔧 McpService: Manual API response status code: ${response.statusCode}');

      if (response.isSuccessful) {
        // Use bodyString to get the raw JSON and parse it manually
        final rawJsonString = response.bodyString;
        print('🔧 McpService: Raw JSON response: $rawJsonString');
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is List) {
          final configs = decodedJson
              .map((json) {
                try {
                  return _mapJsonToModel(json as Map<String, dynamic>);
                } catch (e) {
                  print('🔧 McpService: Error parsing single configuration from JSON: $e');
                  return null;
                }
              })
              .whereType<McpConfiguration>()
              .toList();

          print('🔧 McpService: Manually mapped ${configs.length} configurations');
          return configs;
        } else {
          print('🔧 McpService: Decoded JSON is not a List.');
          return [];
        }
      } else {
        print('🔧 McpService: Manual API error: ${response.error}');
        throw Exception('Failed to fetch MCP configurations: ${response.error}');
      }
    } catch (e) {
      print('🔧 McpService: Exception in getMcpConfigurations: $e');
      throw Exception('Error fetching MCP configurations: $e');
    }
  }

  /// Get a specific MCP configuration by ID
  Future<McpConfiguration> getMcpConfiguration(String id) async {
    try {
      print('🔧 McpService: Getting MCP configuration with ID: $id');
      final response = await _apiService.apiMcpConfigurationsConfigIdGet(configId: id);
      print('🔧 McpService: API response received, successful: ${response.isSuccessful}');

      if (response.isSuccessful) {
        final rawJsonString = response.bodyString;
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is Map<String, dynamic>) {
          return _mapJsonToModel(decodedJson);
        } else {
          throw Exception('Invalid response format: Expected a JSON object');
        }
      } else {
        print('🔧 McpService: API error: ${response.error}');
        throw Exception('Failed to fetch MCP configuration: ${response.error}');
      }
    } catch (e) {
      print('🔧 McpService: Exception in getMcpConfiguration: $e');
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
      print('🔧 McpService: Creating MCP with integrationIds: $integrationIds');
      print('🔧 McpService: _apiService is null? ${_apiService == null}');
      print(
        '🔧 McpService: _apiService.apiMcpConfigurationsPost exists? ${_apiService.apiMcpConfigurationsPost != null}',
      );

      final request = api.CreateMcpConfigurationRequest(name: name, integrationIds: integrationIds);

      print('🔧 McpService: Request created: $request');
      print('🔧 McpService: Request JSON: ${request.toJson()}');
      print('🔧 McpService: About to call API');

      final response = await _apiService.apiMcpConfigurationsPost(body: request);

      print('🔧 McpService: API response received');
      print('🔧 McpService: Response successful: ${response.isSuccessful}');
      print('🔧 McpService: Response status code: ${response.statusCode}');

      if (response.isSuccessful) {
        final rawJsonString = response.bodyString;
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is Map<String, dynamic>) {
          final model = _mapJsonToModel(decodedJson);
          print('🔧 McpService: Model created from manual parse: $model');
          return model;
        } else {
          throw Exception('Failed to create MCP configuration: Invalid response format');
        }
      } else {
        print('🔧 McpService: API error: ${response.error}');
        print('🔧 McpService: Response body: ${response.bodyString}');
        throw Exception('Failed to create MCP configuration: ${response.error}');
      }
    } catch (e, stackTrace) {
      print('🔧 McpService: Exception in createMcpConfiguration: $e');
      print('🔧 McpService: Stack trace: $stackTrace');
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
      print('🔧 McpService: Updating MCP configuration $id with name: $name, integrationIds: $integrationIds');
      print('🔧 McpService: _apiService is null? ${_apiService == null}');

      final request = api.CreateMcpConfigurationRequest(name: name, integrationIds: integrationIds);

      print('🔧 McpService: Update request created: $request');
      print('🔧 McpService: Update request JSON: ${request.toJson()}');
      print('🔧 McpService: About to call update API');

      final response = await _apiService.apiMcpConfigurationsConfigIdPut(configId: id, body: request);

      print('🔧 McpService: Update API response received');
      print('🔧 McpService: Update response successful: ${response.isSuccessful}');
      print('🔧 McpService: Update response status code: ${response.statusCode}');

      if (response.isSuccessful) {
        final rawJsonString = response.bodyString;
        final decodedJson = jsonDecode(rawJsonString);

        if (decodedJson is Map<String, dynamic>) {
          final model = _mapJsonToModel(decodedJson);
          print('🔧 McpService: Updated model created from manual parse: $model');
          return model;
        } else {
          throw Exception('Failed to update MCP configuration: Invalid response format');
        }
      } else {
        print('🔧 McpService: Update API error: ${response.error}');
        print('🔧 McpService: Update response body: ${response.bodyString}');
        throw Exception('Failed to update MCP configuration: ${response.error}');
      }
    } catch (e, stackTrace) {
      print('🔧 McpService: Exception in updateMcpConfiguration: $e');
      print('🔧 McpService: Stack trace: $stackTrace');
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
    print('🔧 McpService: Generating code for config $id with format $format');
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
          print('🔧 McpService: Successfully generated code for format: $format');
          return code;
        } else {
          print('🔧 McpService: Invalid code response format');
          return 'Error: Invalid response format from server.';
        }
      } else {
        print('🔧 McpService: API error generating code: ${response.error}');
        throw Exception('Failed to generate MCP configuration code: ${response.error}');
      }
    } catch (e) {
      print('🔧 McpService: Exception in generateMcpConfigurationCode: $e');
      throw Exception('Error generating MCP configuration code: $e');
    }
  }

  /// Maps raw JSON to local model, bypassing the generated DTO
  McpConfiguration _mapJsonToModel(Map<String, dynamic> json) {
    print('🔧 McpService: Mapping JSON: $json');

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
        print('🔧 McpService: Error parsing integrationIds from JSON: $e');
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
          print('🔧 McpService: Error parsing date list: $e');
        }
      } else if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          print('🔧 McpService: Error parsing date string: $e');
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

  /// Maps API DTO to local model
  McpConfiguration _mapDtoToModel(api.McpConfigurationDto dto) {
    print('🔧 McpService: Mapping DTO: $dto');
    print('🔧 McpService: DTO id: ${dto.id}');
    print('🔧 McpService: DTO name: ${dto.name}');
    print('🔧 McpService: DTO integrationIds: ${dto.integrationIds}');
    print('🔧 McpService: DTO integrationIds type: ${dto.integrationIds?.runtimeType}');
    print('🔧 McpService: DTO createdAt: ${dto.createdAt}');
    print('🔧 McpService: DTO createdAt type: ${dto.createdAt?.runtimeType}');
    print('🔧 McpService: DTO updatedAt: ${dto.updatedAt}');
    print('🔧 McpService: DTO updatedAt type: ${dto.updatedAt?.runtimeType}');

    // Handle integration IDs
    List<String> integrationIds = [];
    if (dto.integrationIds != null) {
      try {
        if (dto.integrationIds is List) {
          integrationIds = (dto.integrationIds as List).map((item) => item.toString()).toList();
        } else if (dto.integrationIds is String) {
          integrationIds = [dto.integrationIds.toString()];
        } else {
          // Handle other potential types by attempting to convert to string
          integrationIds = [dto.integrationIds.toString()];
        }
        print('🔧 McpService: Parsed integrationIds: $integrationIds');
      } catch (e) {
        print('🔧 McpService: Error parsing integrationIds: $e');
        // Fallback to an empty list if parsing fails
        integrationIds = [];
      }
    }

    // Convert the date arrays to DateTime objects
    DateTime? createdAt;
    DateTime? updatedAt;

    if (dto.createdAt is List) {
      final dateList = dto.createdAt as List;
      try {
        if (dateList.length >= 3) {
          // Format is [year, month, day, hour, minute, second, nano]
          createdAt = DateTime(
            dateList[0] is int ? dateList[0] as int : int.parse(dateList[0].toString()),
            dateList[1] is int ? dateList[1] as int : int.parse(dateList[1].toString()),
            dateList[2] is int ? dateList[2] as int : int.parse(dateList[2].toString()),
            dateList.length > 3 ? (dateList[3] is int ? dateList[3] as int : int.parse(dateList[3].toString())) : 0,
            dateList.length > 4 ? (dateList[4] is int ? dateList[4] as int : int.parse(dateList[4].toString())) : 0,
            dateList.length > 5 ? (dateList[5] is int ? dateList[5] as int : int.parse(dateList[5].toString())) : 0,
          );
          print('🔧 McpService: Parsed createdAt: $createdAt');
        }
      } catch (e) {
        print('🔧 McpService: Error parsing createdAt: $e');
      }
    } else if (dto.createdAt != null) {
      try {
        createdAt = dto.createdAt is DateTime ? dto.createdAt : DateTime.parse(dto.createdAt.toString());
        print('🔧 McpService: Using direct createdAt: $createdAt');
      } catch (e) {
        print('🔧 McpService: Error using direct createdAt: $e');
      }
    }

    if (dto.updatedAt is List) {
      final dateList = dto.updatedAt as List;
      try {
        if (dateList.length >= 3) {
          // Format is [year, month, day, hour, minute, second, nano]
          updatedAt = DateTime(
            dateList[0] is int ? dateList[0] as int : int.parse(dateList[0].toString()),
            dateList[1] is int ? dateList[1] as int : int.parse(dateList[1].toString()),
            dateList[2] is int ? dateList[2] as int : int.parse(dateList[2].toString()),
            dateList.length > 3 ? (dateList[3] is int ? dateList[3] as int : int.parse(dateList[3].toString())) : 0,
            dateList.length > 4 ? (dateList[4] is int ? dateList[4] as int : int.parse(dateList[4].toString())) : 0,
            dateList.length > 5 ? (dateList[5] is int ? dateList[5] as int : int.parse(dateList[5].toString())) : 0,
          );
          print('🔧 McpService: Parsed updatedAt: $updatedAt');
        }
      } catch (e) {
        print('🔧 McpService: Error parsing updatedAt: $e');
      }
    } else if (dto.updatedAt != null) {
      try {
        updatedAt = dto.updatedAt is DateTime ? dto.updatedAt : DateTime.parse(dto.updatedAt.toString());
        print('🔧 McpService: Using direct updatedAt: $updatedAt');
      } catch (e) {
        print('🔧 McpService: Error using direct updatedAt: $e');
      }
    }

    return McpConfiguration(
      id: dto.id,
      name: dto.name ?? '',
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
