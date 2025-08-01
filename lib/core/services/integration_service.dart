import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../../network/generated/openapi.models.swagger.dart' as api;
import '../../network/services/api_service.dart';
import '../../providers/auth_provider.dart';

/// Local model for integration data in the main app
class IntegrationModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final bool enabled;
  final String? createdById;
  final String? createdByName;
  final String? createdByEmail;
  final int usageCount;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastUsedAt;
  final List<IntegrationConfigModel> configParams;
  final List<WorkspaceModel> workspaces;
  final List<IntegrationUserModel> users;

  const IntegrationModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.enabled,
    required this.usageCount,
    required this.configParams,
    required this.workspaces,
    required this.users,
    this.createdById,
    this.createdByName,
    this.createdByEmail,
    this.createdAt,
    this.updatedAt,
    this.lastUsedAt,
  });
}

/// Local model for integration configuration parameters
class IntegrationConfigModel {
  final String id;
  final String paramKey;
  final String paramValue;
  final bool sensitive;

  const IntegrationConfigModel({
    required this.id,
    required this.paramKey,
    required this.paramValue,
    required this.sensitive,
  });
}

/// Local model for workspace reference
class WorkspaceModel {
  final String id;
  final String name;

  const WorkspaceModel({
    required this.id,
    required this.name,
  });
}

/// Local model for integration user
class IntegrationUserModel {
  final String id;
  final String? userId;
  final String? userName;
  final String? userEmail;
  final String? userPictureUrl;
  final String? permissionLevel;
  final DateTime? addedAt;

  const IntegrationUserModel({
    required this.id,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPictureUrl,
    this.permissionLevel,
    this.addedAt,
  });
}

/// Local model for integration type definition
class IntegrationTypeModel {
  final String type;
  final String displayName;
  final String description;
  final String? iconUrl;
  final List<ConfigParamModel> configParams;
  final bool supportsMcp;

  const IntegrationTypeModel({
    required this.type,
    required this.displayName,
    required this.description,
    required this.configParams,
    this.iconUrl,
    this.supportsMcp = false,
  });
}

/// Local model for configuration parameter definition
class ConfigParamModel {
  final String key;
  final String displayName;
  final String description;
  final bool required;
  final bool sensitive;
  final String? defaultValue;
  final String type;
  final List<String> options;

  const ConfigParamModel({
    required this.key,
    required this.displayName,
    required this.description,
    required this.required,
    required this.sensitive,
    required this.type,
    required this.options,
    this.defaultValue,
  });
}

/// Request model for creating integration
class CreateIntegrationRequest {
  final String name;
  final String description;
  final String type;
  final Map<String, dynamic> configParams;

  const CreateIntegrationRequest({
    required this.name,
    required this.description,
    required this.type,
    required this.configParams,
  });
}

/// Request model for updating integration
class UpdateIntegrationRequest {
  final String name;
  final String description;
  final bool? enabled;
  final Map<String, dynamic> configParams;

  const UpdateIntegrationRequest({
    required this.name,
    required this.description,
    required this.configParams,
    this.enabled,
  });
}

/// Request model for testing integration
class TestIntegrationRequest {
  final String type;
  final Map<String, dynamic> configParams;

  const TestIntegrationRequest({
    required this.type,
    required this.configParams,
  });
}

/// Service for managing integrations
class IntegrationService with ChangeNotifier {
  bool _isLoading = false;
  String? _error;
  List<IntegrationModel> _integrations = [];
  List<IntegrationTypeModel> _availableTypes = [];
  final ApiService _apiService;
  final AuthProvider? _authProvider;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<IntegrationModel> get integrations => List.unmodifiable(_integrations);
  List<IntegrationTypeModel> get availableTypes => List.unmodifiable(_availableTypes);
  AuthProvider? get authProvider => _authProvider;

  /// Get all integration types that support MCP
  List<IntegrationTypeModel> get mcpSupportedTypes =>
      List.unmodifiable(_availableTypes.where((type) => type.supportsMcp).toList());

  /// Get user integrations that support MCP (enabled and have MCP-supported types)
  List<IntegrationModel> get mcpReadyIntegrations => List.unmodifiable(_integrations.where((integration) {
        if (!integration.enabled) return false;
        final integrationTypeModel = getIntegrationType(integration.type);
        return integrationTypeModel?.supportsMcp ?? false;
      }).toList());

  IntegrationService({required ApiService apiService, AuthProvider? authProvider})
      : _apiService = apiService,
        _authProvider = authProvider {
    _initializeMockData();
  }

  // Check if we should use mock data based on demo mode
  bool get _shouldUseMockData {
    final shouldUseMock = _authProvider?.shouldUseMockData ?? true;
    if (kDebugMode) {
      debugPrint('🔍 IntegrationService _shouldUseMockData: $shouldUseMock');
      debugPrint('   - AuthProvider exists: ${_authProvider != null}');
      debugPrint('   - ApiService exists: ${_apiService.toString()}');
      debugPrint('   - Demo mode: ${_authProvider?.isDemoMode ?? 'null'}');
    }
    return shouldUseMock;
  }

  /// Initialize mock data for demo mode
  void _initializeMockData() {
    _availableTypes = _getMockIntegrationTypes();
    _integrations = _getMockIntegrations();
  }

  /// Load all integrations
  Future<void> loadIntegrations() async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('🔄 Loading integrations...');
        print('📍 Base URL: ${AppConfig.baseUrl}');
        print('🔧 Environment: ${AppConfig.environment.name}');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 800));
        // Mock data is already initialized
        if (kDebugMode) {
          print('✅ Using mock integrations (${_integrations.length})');
          print('✅ MCP-ready integrations: ${mcpReadyIntegrations.length}');
          for (final integration in mcpReadyIntegrations) {
            print('   - ${integration.name} (${integration.type}) [${integration.id}]');
          }
        }
      } else {
        // Check if user is authenticated before making API calls
        if (_authProvider?.isAuthenticated != true) {
          if (kDebugMode) {
            print('⏳ User not authenticated yet, waiting for authentication...');
          }
          throw Exception('User not authenticated');
        }

        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to get integrations');
        }
        final apiIntegrations = await _apiService.getIntegrations();
        _integrations = apiIntegrations.map(_convertApiIntegrationToLocal).toList();
        if (kDebugMode) {
          print('✅ Loaded ${_integrations.length} integrations from API');
          print('✅ MCP-ready integrations: ${mcpReadyIntegrations.length}');
          for (final integration in mcpReadyIntegrations) {
            print('   - ${integration.name} (${integration.type}) [${integration.id}]');
          }
        }
      }

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load integrations: ${e.toString()}');
      if (kDebugMode) {
        print('❌ Error loading integrations: $e');
      }
      _setLoading(false);
    }
  }

  /// Load available integration types
  Future<void> loadIntegrationTypes() async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('🔄 Loading integration types...');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 500));
        // Mock data is already initialized
        if (kDebugMode) {
          print('✅ Using mock integration types (${_availableTypes.length})');
          print('✅ MCP-supported types: ${_availableTypes.where((type) => type.supportsMcp).length}');
          for (final type in _availableTypes.where((type) => type.supportsMcp)) {
            print('   - ${type.displayName} (${type.type})');
          }
        }
      } else {
        // Check if user is authenticated before making API calls
        if (_authProvider?.isAuthenticated != true) {
          if (kDebugMode) {
            print('⏳ User not authenticated yet, waiting for authentication...');
          }
          throw Exception('User not authenticated');
        }

        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to get integration types');
        }
        final apiTypes = await _apiService.getIntegrationTypes();
        _availableTypes = apiTypes.map(_convertApiIntegrationTypeToLocal).toList();
        if (kDebugMode) {
          print('✅ Loaded ${_availableTypes.length} integration types from API');
          print('✅ MCP-supported types: ${_availableTypes.where((type) => type.supportsMcp).length}');
          for (final type in _availableTypes.where((type) => type.supportsMcp)) {
            print('   - ${type.displayName} (${type.type})');
          }
        }
      }

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load integration types: ${e.toString()}');
      if (kDebugMode) {
        print('❌ Error loading integration types: $e');
      }
      _setLoading(false);
    }
  }

  /// Helper method to convert raw config values to ConfigParam objects
  Map<String, api.ConfigParam> _convertConfigToApiFormat(Map<String, dynamic> rawConfig, String integrationType) {
    final result = <String, api.ConfigParam>{};

    // Get the integration type definition to determine which parameters are sensitive
    final typeDefinition = getIntegrationType(integrationType);

    for (final entry in rawConfig.entries) {
      final paramKey = entry.key;
      final paramValue = entry.value?.toString() ?? '';

      // Determine if this parameter is sensitive based on type definition
      bool isSensitive = false;
      if (typeDefinition != null) {
        final paramDef = typeDefinition.configParams.firstWhere(
          (param) => param.key == paramKey,
          orElse: () => const ConfigParamModel(
            key: '',
            displayName: '',
            description: '',
            required: false,
            sensitive: false,
            type: 'string',
            options: [],
          ),
        );
        isSensitive = paramDef.sensitive;
      } else {
        // Fallback to heuristic detection if no type definition
        isSensitive = _isSensitiveParam(paramKey);
      }

      result[paramKey] = api.ConfigParam(
        $value: paramValue,
        sensitive: isSensitive,
      );
    }

    return result;
  }

  /// Create a new integration
  Future<IntegrationModel?> createIntegration(CreateIntegrationRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('🔄 Creating integration: ${request.name}');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 1000));

        final newIntegration = IntegrationModel(
          id: 'mock_${DateTime.now().millisecondsSinceEpoch}',
          name: request.name,
          description: request.description,
          type: request.type,
          enabled: true,
          usageCount: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          createdByName: 'Demo User',
          createdByEmail: 'demo@dmtools.com',
          configParams: request.configParams.entries
              .map((e) => IntegrationConfigModel(
                    id: '${e.key}_config',
                    paramKey: e.key,
                    paramValue: e.value.toString(),
                    sensitive: _isSensitiveParam(e.key),
                  ))
              .toList(),
          workspaces: [],
          users: [],
        );

        _integrations.add(newIntegration);
        notifyListeners();

        if (kDebugMode) {
          print('✅ Created mock integration: ${newIntegration.id}');
        }

        _setLoading(false);
        return newIntegration;
      } else {
        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to create integration');
        }

        // Convert raw config params to ConfigParam objects
        final formattedConfigParams = _convertConfigToApiFormat(request.configParams, request.type);

        final createRequest = api.CreateIntegrationRequest(
          name: request.name,
          description: request.description,
          type: request.type,
          configParams: formattedConfigParams,
        );
        final apiIntegration = await _apiService.createIntegration(createRequest);
        final newIntegration = _convertApiIntegrationToLocal(apiIntegration);
        _integrations.add(newIntegration);
        notifyListeners();
        if (kDebugMode) {
          print('✅ Created integration via API: ${newIntegration.id}');
        }

        _setLoading(false);
        return newIntegration;
      }
    } catch (e) {
      _setError('Failed to create integration: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }

  /// Update an existing integration
  Future<bool> updateIntegration(String integrationId, UpdateIntegrationRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('🔄 Updating integration: $integrationId');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 800));

        final index = _integrations.indexWhere((integration) => integration.id == integrationId);
        if (index == -1) {
          throw Exception('Integration not found');
        }

        final updatedIntegration = IntegrationModel(
          id: _integrations[index].id,
          name: request.name,
          description: request.description,
          type: _integrations[index].type,
          enabled: request.enabled ?? _integrations[index].enabled,
          usageCount: _integrations[index].usageCount,
          createdAt: _integrations[index].createdAt,
          updatedAt: DateTime.now(),
          createdByName: _integrations[index].createdByName,
          createdByEmail: _integrations[index].createdByEmail,
          configParams: request.configParams.entries
              .map((e) => IntegrationConfigModel(
                    id: '${e.key}_config',
                    paramKey: e.key,
                    paramValue: e.value.toString(),
                    sensitive: _isSensitiveParam(e.key),
                  ))
              .toList(),
          workspaces: _integrations[index].workspaces,
          users: _integrations[index].users,
        );

        _integrations[index] = updatedIntegration;
        notifyListeners();
        if (kDebugMode) {
          print('✅ Updated mock integration: $integrationId');
        }

        _setLoading(false);
        return true;
      } else {
        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to update integration');
        }

        // Get the integration type to determine sensitive parameters
        final integration = getIntegration(integrationId);
        final integrationType = integration?.type ?? 'unknown';

        // Convert raw config params to ConfigParam objects
        final formattedConfigParams = _convertConfigToApiFormat(request.configParams, integrationType);

        final updateRequest = api.UpdateIntegrationRequest(
          name: request.name,
          description: request.description,
          enabled: request.enabled,
          configParams: formattedConfigParams,
        );
        await _apiService.updateIntegration(integrationId, updateRequest);

        // Reload integrations to get updated data
        await loadIntegrations();
        if (kDebugMode) {
          print('✅ Updated integration via API: $integrationId');
        }

        _setLoading(false);
        return true;
      }
    } catch (e) {
      _setError('Failed to update integration: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Delete an integration
  Future<bool> deleteIntegration(String integrationId) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('🗑️ Deleting integration: $integrationId');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 600));

        final index = _integrations.indexWhere((integration) => integration.id == integrationId);
        if (index == -1) {
          throw Exception('Integration not found');
        }

        _integrations.removeAt(index);
        notifyListeners();
        if (kDebugMode) {
          print('✅ Deleted mock integration: $integrationId');
        }
      } else {
        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to delete integration');
        }
        await _apiService.deleteIntegration(integrationId);

        // Remove from local list after successful API call
        final index = _integrations.indexWhere((integration) => integration.id == integrationId);
        if (index != -1) {
          _integrations.removeAt(index);
          notifyListeners();
        }
        if (kDebugMode) {
          print('✅ Deleted integration via API: $integrationId');
        }
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete integration: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Enable an integration
  Future<bool> enableIntegration(String integrationId) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('✅ Enabling integration: $integrationId');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 500));

        final index = _integrations.indexWhere((integration) => integration.id == integrationId);
        if (index != -1) {
          final integration = _integrations[index];
          _integrations[index] = IntegrationModel(
            id: integration.id,
            name: integration.name,
            description: integration.description,
            type: integration.type,
            enabled: true,
            usageCount: integration.usageCount,
            createdAt: integration.createdAt,
            updatedAt: DateTime.now(),
            createdByName: integration.createdByName,
            createdByEmail: integration.createdByEmail,
            configParams: integration.configParams,
            workspaces: integration.workspaces,
            users: integration.users,
          );
          notifyListeners();
        }
        if (kDebugMode) {
          print('✅ Enabled mock integration: $integrationId');
        }
      } else {
        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to enable integration');
        }
        await _apiService.enableIntegration(integrationId);
        await loadIntegrations();
        if (kDebugMode) {
          print('✅ Enabled integration via API: $integrationId');
        }
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to enable integration: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Disable an integration
  Future<bool> disableIntegration(String integrationId) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('❌ Disabling integration: $integrationId');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 500));

        final index = _integrations.indexWhere((integration) => integration.id == integrationId);
        if (index != -1) {
          final integration = _integrations[index];
          _integrations[index] = IntegrationModel(
            id: integration.id,
            name: integration.name,
            description: integration.description,
            type: integration.type,
            enabled: false,
            usageCount: integration.usageCount,
            createdAt: integration.createdAt,
            updatedAt: DateTime.now(),
            createdByName: integration.createdByName,
            createdByEmail: integration.createdByEmail,
            configParams: integration.configParams,
            workspaces: integration.workspaces,
            users: integration.users,
          );
          notifyListeners();
        }
        if (kDebugMode) {
          print('✅ Disabled mock integration: $integrationId');
        }
      } else {
        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to disable integration');
        }
        await _apiService.disableIntegration(integrationId);
        await loadIntegrations();
        if (kDebugMode) {
          print('✅ Disabled integration via API: $integrationId');
        }
      }

      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to disable integration: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Test an integration connection
  Future<Map<String, dynamic>?> testIntegration(TestIntegrationRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('🔧 Testing integration connection: ${request.type}');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 2000));

        // Mock test result
        final testResult = {
          'success': true,
          'message': 'Connection test successful',
          'details': 'All required parameters are valid and connection is established',
          'timestamp': DateTime.now().toIso8601String(),
        };

        if (kDebugMode) {
          print('✅ Mock integration test successful');
        }

        _setLoading(false);
        return testResult;
      } else {
        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to test integration');
        }

        // For test integration, the API expects raw string values according to the swagger schema
        // TestIntegrationRequest configParams is Map<String, dynamic> where values are strings
        final testRequest = api.TestIntegrationRequest(
          type: request.type,
          configParams: request.configParams,
        );
        final testResult = await _apiService.testIntegration(testRequest);
        if (kDebugMode) {
          print('✅ Integration test completed via API');
        }

        _setLoading(false);
        // Convert the Object result to Map<String, dynamic>
        if (testResult is Map<String, dynamic>) {
          return testResult;
        } else {
          return {
            'success': true,
            'message': 'Integration test completed',
            'data': testResult.toString(),
            'timestamp': DateTime.now().toIso8601String(),
          };
        }
      }
    } catch (e) {
      _setError('Failed to test integration: ${e.toString()}');
      _setLoading(false);
      return {
        'success': false,
        'message': 'Connection test failed',
        'error': e.toString(),
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  /// Get integration by ID from local cache
  IntegrationModel? getIntegration(String integrationId) {
    try {
      return _integrations.firstWhere((integration) => integration.id == integrationId);
    } catch (e) {
      return null;
    }
  }

  /// Get integration details by ID with full config parameters from API
  Future<IntegrationModel?> getIntegrationById(String integrationId, {bool includeSensitive = true}) async {
    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        print('🔄 Fetching integration details: $integrationId');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 500));

        final integration = _integrations.firstWhere(
          (integration) => integration.id == integrationId,
          orElse: () => throw Exception('Integration not found'),
        );

        if (kDebugMode) {
          print('✅ Found mock integration: ${integration.name}');
        }

        _setLoading(false);
        return integration;
      } else {
        // Use real API service
        if (kDebugMode) {
          print('🌐 Making real API call to get integration details');
        }
        final apiIntegration = await _apiService.getIntegration(integrationId, includeSensitive: includeSensitive);
        final integration = _convertApiIntegrationToLocal(apiIntegration);

        // Update local cache
        final index = _integrations.indexWhere((i) => i.id == integrationId);
        if (index != -1) {
          _integrations[index] = integration;
          notifyListeners();
        }

        if (kDebugMode) {
          print('✅ Fetched integration details via API: ${integration.name}');
        }

        _setLoading(false);
        return integration;
      }
    } catch (e) {
      _setError('Failed to fetch integration details: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }

  /// Get integration type by type string
  IntegrationTypeModel? getIntegrationType(String type) {
    try {
      return _availableTypes.firstWhere((integrationType) => integrationType.type == type);
    } catch (e) {
      return null;
    }
  }

  /// Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
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

  /// Check if a parameter is sensitive (should be masked in UI)
  bool _isSensitiveParam(String paramKey) {
    final sensitiveKeys = {
      'token',
      'api_key',
      'secret',
      'password',
      'webhook_url',
      'access_token',
      'private_key',
      'client_secret'
    };
    return sensitiveKeys.any((key) => paramKey.toLowerCase().contains(key));
  }

  /// Convert API integration to local model
  IntegrationModel _convertApiIntegrationToLocal(api.IntegrationDto apiIntegration) {
    return IntegrationModel(
      id: apiIntegration.id ?? 'unknown',
      name: apiIntegration.name ?? 'Unnamed Integration',
      description: apiIntegration.description ?? '',
      type: apiIntegration.type ?? 'unknown',
      enabled: apiIntegration.enabled ?? false,
      usageCount: apiIntegration.usageCount ?? 0,
      createdAt: apiIntegration.createdAt ?? DateTime.now(),
      updatedAt: apiIntegration.updatedAt ?? DateTime.now(),
      lastUsedAt: apiIntegration.lastUsedAt,
      createdById: apiIntegration.createdById,
      createdByName: apiIntegration.createdByName ?? 'Unknown User',
      createdByEmail: apiIntegration.createdByEmail,
      configParams: apiIntegration.configParams?.map(_convertApiConfigToLocal).toList() ?? [],
      workspaces: apiIntegration.workspaces?.map(_convertApiWorkspaceToLocal).toList() ?? [],
      users: apiIntegration.users?.map(_convertApiUserToLocal).toList() ?? [],
    );
  }

  /// Convert API config to local model
  IntegrationConfigModel _convertApiConfigToLocal(api.IntegrationConfigDto apiConfig) {
    return IntegrationConfigModel(
      id: apiConfig.id ?? 'unknown',
      paramKey: apiConfig.paramKey ?? '',
      paramValue: apiConfig.paramValue ?? '',
      sensitive: apiConfig.sensitive ?? false,
    );
  }

  /// Convert API workspace to local model
  WorkspaceModel _convertApiWorkspaceToLocal(api.WorkspaceDto apiWorkspace) {
    return WorkspaceModel(
      id: apiWorkspace.id ?? 'unknown',
      name: apiWorkspace.name ?? 'Unnamed Workspace',
    );
  }

  /// Convert API user to local model
  IntegrationUserModel _convertApiUserToLocal(api.IntegrationUserDto apiUser) {
    return IntegrationUserModel(
      id: apiUser.id ?? 'unknown',
      userId: apiUser.userId,
      userName: apiUser.userName,
      userEmail: apiUser.userEmail,
      userPictureUrl: apiUser.userPictureUrl,
      permissionLevel: apiUser.permissionLevel?.toString(),
      addedAt: apiUser.addedAt,
    );
  }

  /// Convert API integration type to local model
  IntegrationTypeModel _convertApiIntegrationTypeToLocal(api.IntegrationTypeDto apiType) {
    return IntegrationTypeModel(
      type: apiType.type ?? 'unknown',
      displayName: apiType.displayName ?? 'Unknown Integration',
      description: apiType.description ?? '',
      iconUrl: apiType.iconUrl,
      configParams: apiType.configParams?.map(_convertApiConfigParamToLocal).toList() ?? [],
      supportsMcp: apiType.supportsMcp ?? false,
    );
  }

  /// Convert API config param to local model
  ConfigParamModel _convertApiConfigParamToLocal(api.ConfigParamDefinition apiParam) {
    return ConfigParamModel(
      key: apiParam.key ?? '',
      displayName: apiParam.displayName ?? '',
      description: apiParam.description ?? '',
      required: apiParam.required ?? false,
      sensitive: apiParam.sensitive ?? false,
      defaultValue: apiParam.defaultValue,
      type: apiParam.type ?? 'string',
      options: apiParam.options ?? [],
    );
  }

  /// Mock data for demo mode
  List<IntegrationTypeModel> _getMockIntegrationTypes() {
    return [
      const IntegrationTypeModel(
        type: 'jira',
        displayName: 'Jira',
        description: 'Connect to Atlassian Jira for issue tracking and project management',
        supportsMcp: true, // Enable MCP support for Jira
        configParams: [
          ConfigParamModel(
            key: 'base_url',
            displayName: 'Jira URL',
            description: 'Your Jira instance URL (e.g., https://yourcompany.atlassian.net)',
            required: true,
            sensitive: false,
            type: 'url',
            options: [],
          ),
          ConfigParamModel(
            key: 'api_token',
            displayName: 'API Token',
            description: 'Your Jira API token',
            required: true,
            sensitive: true,
            type: 'password',
            options: [],
          ),
          ConfigParamModel(
            key: 'user_email',
            displayName: 'User Email',
            description: 'Email address associated with the API token',
            required: true,
            sensitive: false,
            type: 'email',
            options: [],
          ),
        ],
      ),
      const IntegrationTypeModel(
        type: 'confluence',
        displayName: 'Confluence',
        description: 'Connect to Atlassian Confluence for documentation and knowledge management',
        supportsMcp: true, // Enable MCP support for Confluence
        configParams: [
          ConfigParamModel(
            key: 'base_url',
            displayName: 'Confluence URL',
            description: 'Your Confluence instance URL (e.g., https://yourcompany.atlassian.net/wiki)',
            required: true,
            sensitive: false,
            type: 'url',
            options: [],
          ),
          ConfigParamModel(
            key: 'api_token',
            displayName: 'API Token',
            description: 'Your Confluence API token',
            required: true,
            sensitive: true,
            type: 'password',
            options: [],
          ),
          ConfigParamModel(
            key: 'user_email',
            displayName: 'User Email',
            description: 'Email address associated with the API token',
            required: true,
            sensitive: false,
            type: 'email',
            options: [],
          ),
        ],
      ),
      const IntegrationTypeModel(
        type: 'github',
        displayName: 'GitHub',
        description: 'Connect to GitHub for source code management and collaboration',
        configParams: [
          ConfigParamModel(
            key: 'access_token',
            displayName: 'Personal Access Token',
            description: 'GitHub personal access token with appropriate permissions',
            required: true,
            sensitive: true,
            type: 'password',
            options: [],
          ),
          ConfigParamModel(
            key: 'base_url',
            displayName: 'Base URL',
            description: 'GitHub API base URL (leave empty for github.com)',
            required: false,
            sensitive: false,
            defaultValue: 'https://api.github.com',
            type: 'url',
            options: [],
          ),
        ],
      ),
    ];
  }

  List<IntegrationModel> _getMockIntegrations() {
    return [
      IntegrationModel(
        id: 'demo_jira_1',
        name: 'Company Jira',
        description: 'Main Jira instance for project management',
        type: 'jira',
        enabled: true,
        usageCount: 142,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        lastUsedAt: DateTime.now().subtract(const Duration(hours: 2)),
        createdByName: 'Demo User',
        createdByEmail: 'demo@dmtools.com',
        configParams: const [
          IntegrationConfigModel(
            id: 'base_url_config',
            paramKey: 'base_url',
            paramValue: 'https://demo.atlassian.net',
            sensitive: false,
          ),
          IntegrationConfigModel(
            id: 'api_token_config',
            paramKey: 'api_token',
            paramValue: '••••••••••••',
            sensitive: true,
          ),
          IntegrationConfigModel(
            id: 'user_email_config',
            paramKey: 'user_email',
            paramValue: 'demo@dmtools.com',
            sensitive: false,
          ),
        ],
        workspaces: const [
          WorkspaceModel(id: 'demo_workspace_1', name: 'Demo Workspace'),
        ],
        users: const [],
      ),
      IntegrationModel(
        id: 'demo_github_1',
        name: 'GitHub Integration',
        description: 'Integration with GitHub repositories',
        type: 'github',
        enabled: true,
        usageCount: 89,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        lastUsedAt: DateTime.now().subtract(const Duration(hours: 6)),
        createdByName: 'Demo User',
        createdByEmail: 'demo@dmtools.com',
        configParams: const [
          IntegrationConfigModel(
            id: 'access_token_config',
            paramKey: 'access_token',
            paramValue: '••••••••••••',
            sensitive: true,
          ),
          IntegrationConfigModel(
            id: 'base_url_config',
            paramKey: 'base_url',
            paramValue: 'https://api.github.com',
            sensitive: false,
          ),
        ],
        workspaces: const [
          WorkspaceModel(id: 'demo_workspace_1', name: 'Demo Workspace'),
        ],
        users: const [],
      ),
    ];
  }
}
