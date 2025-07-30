import 'package:chopper/chopper.dart';
import '../generated/openapi.swagger.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import '../clients/api_client.dart';
import '../../providers/auth_provider.dart';
import '../generated/openapi.enums.swagger.dart' as enums;
import '../../core/models/user.dart'; // Import our custom UserDto

/// Exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Mock data for demo mode
class _MockData {
  static List<WorkspaceDto> get mockWorkspaces => [
        WorkspaceDto(
          id: 'demo_workspace_1',
          name: 'Demo Workspace',
          description: 'This is a demo workspace with sample data',
          ownerId: 'demo_user_123',
          ownerName: 'Demo User',
          ownerEmail: 'demo@dmtools.com',
          currentUserRole: enums.WorkspaceDtoCurrentUserRole.admin,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          users: [
            const WorkspaceUserDto(
              id: 'demo_user_123',
              email: 'demo@dmtools.com',
              role: enums.WorkspaceUserDtoRole.admin,
            ),
            const WorkspaceUserDto(
              id: 'demo_user_456',
              email: 'colleague@dmtools.com',
              role: enums.WorkspaceUserDtoRole.user,
            ),
          ],
        ),
        WorkspaceDto(
          id: 'demo_workspace_2',
          name: 'Sample Project',
          description: 'Another demo workspace for testing',
          ownerId: 'demo_user_123',
          ownerName: 'Demo User',
          ownerEmail: 'demo@dmtools.com',
          currentUserRole: enums.WorkspaceDtoCurrentUserRole.admin,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          users: [
            const WorkspaceUserDto(
              id: 'demo_user_123',
              email: 'demo@dmtools.com',
              role: enums.WorkspaceUserDtoRole.admin,
            ),
          ],
        ),
      ];
}

/// High-level service for API operations using the generated client
class ApiService {
  final ChopperClient _client;
  late final Openapi _api;
  final AuthProvider? _authProvider;

  ApiService({
    String? baseUrl,
    AuthProvider? authProvider,
    bool enableLogging = true,
  })  : _authProvider = authProvider,
        _client = ApiClientConfig.createClient(
          baseUrl: baseUrl,
          authProvider: authProvider,
          enableLogging: enableLogging,
        ) {
    _api = _client.getService<Openapi>();
  }

  /// Check if the service should use mock data
  bool get _shouldUseMockData {
    final authProvider = _authProvider;
    final useMock = authProvider?.shouldUseMockData ?? false;
    final isDemoMode = authProvider?.isDemoMode ?? false;
    final isAuthenticated = authProvider?.isAuthenticated ?? false;
    final currentUser = authProvider?.currentUser;

    if (kDebugMode) {
      debugPrint('🔍 API Service Mock Data Check:');
      debugPrint('   - AuthProvider exists: ${authProvider != null}');
      debugPrint('   - isDemoMode: $isDemoMode');
      debugPrint('   - shouldUseMockData: $useMock');
      debugPrint('   - isAuthenticated: $isAuthenticated');
      debugPrint('   - currentUser: ${currentUser?.name} (${currentUser?.email})');
      debugPrint('   - Will use mock data: $useMock');
    }

    return useMock;
  }

  /// Get the current authenticated user's profile
  Future<UserDto> getCurrentUser() async {
    // Return mock data if in demo mode
    if (_shouldUseMockData) {
      return const UserDto(
        id: 'demo_user_123',
        name: 'Demo User',
        email: 'demo@dmtools.com',
      );
    }

    try {
      final response = await _api.apiAuthUserGet();
      if (response.isSuccessful && response.body != null) {
        // The API returns Object, so we need to parse it manually
        final responseBody = response.body!;

        if (responseBody is Map<String, dynamic>) {
          return UserDto.fromJson(responseBody);
        } else if (responseBody is String) {
          // If it's returned as JSON string, parse it first
          final jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
          return UserDto.fromJson(jsonData);
        } else {
          throw ApiException('Unexpected response format from /api/auth/user: ${responseBody.runtimeType}');
        }
      } else {
        throw ApiException('Failed to get current user', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get all workspaces for the current user
  Future<List<WorkspaceDto>> getWorkspaces() async {
    // Return mock data if in demo mode
    if (_shouldUseMockData) {
      return _MockData.mockWorkspaces;
    }

    try {
      final response = await _api.apiWorkspacesGet();
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to get workspaces', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Get a specific workspace by ID
  Future<WorkspaceDto> getWorkspace(String workspaceId) async {
    // Return mock data if in demo mode
    if (_shouldUseMockData) {
      try {
        return _MockData.mockWorkspaces.firstWhere(
          (workspace) => workspace.id == workspaceId,
        );
      } catch (e) {
        throw ApiException('Demo workspace not found: $workspaceId');
      }
    }

    try {
      final response = await _api.apiWorkspacesWorkspaceIdGet(workspaceId: workspaceId);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to get workspace', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a new workspace
  Future<WorkspaceDto> createWorkspace({
    required String name,
    String? description,
  }) async {
    try {
      final request = CreateWorkspaceRequest(
        name: name,
        description: description,
      );
      final response = await _api.apiWorkspacesPost(body: request);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to create workspace', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Delete a workspace
  Future<void> deleteWorkspace(String workspaceId) async {
    try {
      final response = await _api.apiWorkspacesWorkspaceIdDelete(workspaceId: workspaceId);
      if (!response.isSuccessful) {
        throw ApiException('Failed to delete workspace', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Share a workspace with a user
  Future<void> shareWorkspace({
    required String workspaceId,
    required String userEmail,
    required enums.ShareWorkspaceRequestRole role,
  }) async {
    try {
      final request = ShareWorkspaceRequest(
        email: userEmail,
        role: role,
      );
      final response = await _api.apiWorkspacesWorkspaceIdSharePost(
        workspaceId: workspaceId,
        body: request,
      );
      if (!response.isSuccessful) {
        throw ApiException('Failed to share workspace', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Remove a user from a workspace
  Future<void> removeUserFromWorkspace({
    required String workspaceId,
    required String targetUserId,
  }) async {
    try {
      final response = await _api.apiWorkspacesWorkspaceIdUsersTargetUserIdDelete(
        workspaceId: workspaceId,
        targetUserId: targetUserId,
      );
      if (!response.isSuccessful) {
        throw ApiException('Failed to remove user from workspace', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  /// Create a default workspace
  Future<WorkspaceDto> createDefaultWorkspace() async {
    try {
      final response = await _api.apiWorkspacesDefaultPost();
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to create default workspace', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- Integration Methods ---

  Future<List<IntegrationDto>> getIntegrations() async {
    try {
      final response = await _api.apiIntegrationsGet();
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to get integrations', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<IntegrationDto> createIntegration(
    CreateIntegrationRequest request,
  ) async {
    try {
      final response = await _api.apiIntegrationsPost(body: request);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to create integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<IntegrationDto> getIntegration(
    String integrationId, {
    bool includeSensitive = false,
  }) async {
    try {
      final response = await _api.apiIntegrationsIdGet(
        id: integrationId,
        includeSensitive: includeSensitive,
      );
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to get integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteIntegration(String integrationId) async {
    try {
      final response = await _api.apiIntegrationsIdDelete(
        id: integrationId,
      );
      if (!response.isSuccessful) {
        throw ApiException('Failed to delete integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<IntegrationDto> updateIntegration(
    String integrationId,
    UpdateIntegrationRequest request,
  ) async {
    try {
      final response = await _api.apiIntegrationsIdPut(
        id: integrationId,
        body: request,
      );
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to update integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> enableIntegration(String integrationId) async {
    try {
      final response = await _api.apiIntegrationsIdEnablePut(
        id: integrationId,
      );
      if (!response.isSuccessful) {
        throw ApiException('Failed to enable integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> disableIntegration(String integrationId) async {
    try {
      final response = await _api.apiIntegrationsIdDisablePut(
        id: integrationId,
      );
      if (!response.isSuccessful) {
        throw ApiException('Failed to disable integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<IntegrationTypeDto>> getIntegrationTypes() async {
    try {
      final response = await _api.apiIntegrationsTypesGet();
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to get integration types', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Object> testIntegration(TestIntegrationRequest request) async {
    try {
      final response = await _api.apiIntegrationsTestPost(body: request);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to test integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  // --- Job Methods ---

  /// Get all job configurations for the authenticated user
  /// Note: There is no endpoint that returns a list of job configurations in the actual API
  /// This method should be removed or the backend should implement this endpoint
  Future<List<JobConfigurationDto>> getJobConfigurations() async {
    throw UnimplementedError('GET /api/v1/job-configurations endpoint does not exist in the actual API');
  }

  /// Create a new job configuration
  Future<JobConfigurationDto> createJobConfigurationRaw({
    required String name,
    required String jobType,
    required Map<String, dynamic> config,
    required Map<String, dynamic> integrationMappings,
    String? description,
    bool? enabled,
  }) async {
    try {
      final request = CreateJobConfigurationRequest(
        name: name,
        description: description,
        jobType: jobType,
        jobParameters: const JsonNode(), // API expects JsonNode, not Map<String, dynamic>
        integrationMappings: const JsonNode(), // API expects JsonNode, not Map<String, dynamic>
        enabled: enabled,
      );
      final response = await _api.apiV1JobConfigurationsPost(body: request);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to create job configuration', response.statusCode);
      }
    } catch (e) {
      throw ApiException('Error creating job configuration: $e');
    }
  }

  /// Update an existing job configuration
  Future<JobConfigurationDto> updateJobConfigurationRaw({
    required String id,
    String? name,
    String? description,
    String? jobType,
    Map<String, dynamic>? config,
    Map<String, dynamic>? integrationMappings,
    bool? enabled,
  }) async {
    try {
      final request = UpdateJobConfigurationRequest(
        name: name,
        description: description,
        jobType: jobType,
        jobParameters: config != null ? const JsonNode() : null, // API expects JsonNode, not Map<String, dynamic>
        integrationMappings:
            integrationMappings != null ? const JsonNode() : null, // API expects JsonNode, not Map<String, dynamic>
        enabled: enabled,
      );
      final response = await _api.apiV1JobConfigurationsIdPut(id: id, body: request);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to update job configuration', response.statusCode);
      }
    } catch (e) {
      throw ApiException('Error updating job configuration: $e');
    }
  }

  /// Delete a job configuration
  Future<void> deleteJobConfiguration(String id) async {
    try {
      final response = await _api.apiV1JobConfigurationsIdDelete(id: id);
      if (!response.isSuccessful) {
        throw ApiException('Failed to delete job configuration', response.statusCode);
      }
    } catch (e) {
      throw ApiException('Error deleting job configuration: $e');
    }
  }

  /// Execute a job configuration
  Future<void> executeJobConfiguration(String id, ExecuteJobConfigurationRequest request) async {
    try {
      final response = await _api.apiV1JobsConfigurationsConfigIdExecutePost(
        configId: id, // API uses configId parameter name
        body: request,
      );
      if (!response.isSuccessful) {
        throw ApiException('Failed to execute job configuration', response.statusCode);
      }
    } catch (e) {
      throw ApiException('Error executing job configuration: $e');
    }
  }

  /// Get raw job configuration data
  Future<Map<String, dynamic>> getJobConfigurationRaw(String id) async {
    try {
      final response = await _api.apiV1JobConfigurationsIdGet(id: id);
      if (response.isSuccessful && response.body != null) {
        return response.body! as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to get job configuration', response.statusCode);
      }
    } catch (e) {
      throw ApiException('Error getting job configuration: $e');
    }
  }

  /// Get available job types
  Future<List<JobTypeDto>> getAvailableJobTypes() async {
    try {
      debugPrint('🔍 ApiService: Making API call to /api/v1/jobs/types');
      final response = await _api.apiV1JobsTypesGet();
      debugPrint(
          '🔍 ApiService: Response received - success: ${response.isSuccessful}, statusCode: ${response.statusCode}');
      debugPrint('🔍 ApiService: Response body is null: ${response.body == null}');
      debugPrint('🔍 ApiService: Response body type: ${response.body.runtimeType}');

      if (response.isSuccessful && response.body != null) {
        debugPrint('🔍 ApiService: About to deserialize response body...');

        // Handle the response body which comes as List<dynamic> containing Map objects
        final rawList = response.body! as List<dynamic>;
        debugPrint('🔍 ApiService: Raw list length: ${rawList.length}');

        final jobTypes = <JobTypeDto>[];
        for (int i = 0; i < rawList.length; i++) {
          try {
            final rawMap = rawList[i] as Map<String, dynamic>;
            debugPrint('🔍 ApiService: [$i] Deserializing JobTypeDto from map keys: ${rawMap.keys.toList()}');

            final jobType = JobTypeDto.fromJson(rawMap);
            jobTypes.add(jobType);
            debugPrint(
                '🔍 ApiService: [$i] Successfully deserialized JobTypeDto - type: "${jobType.type}", displayName: "${jobType.displayName}"');
          } catch (e, stackTrace) {
            debugPrint('❌ ApiService: Failed to deserialize JobTypeDto [$i]: $e');
            debugPrint('❌ ApiService: Raw item [$i]: ${rawList[i]}');
            debugPrint('❌ ApiService: Stack trace: $stackTrace');
          }
        }

        debugPrint(
            '🔍 ApiService: Successfully deserialized ${jobTypes.length} JobTypeDto objects from ${rawList.length} raw items');
        return jobTypes;
      } else {
        debugPrint('❌ ApiService: API call failed - statusCode: ${response.statusCode}');
        throw ApiException('Failed to get job types', response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint('❌ ApiService: Exception in getAvailableJobTypes: $e');
      debugPrint('❌ ApiService: Stack trace: $stackTrace');
      throw ApiException('Error getting job types: $e');
    }
  }

  /// Handle and transform errors to more specific types
  Exception _handleError(dynamic error) {
    if (error is ApiException) {
      return error;
    }

    if (error is Response) {
      return ApiException(
        'API request failed: ${error.statusCode}',
        error.statusCode,
      );
    }

    if (error is Exception) {
      return error;
    }

    return ApiException('Unknown error: $error');
  }

  /// Dispose the service and clean up resources
  void dispose() {
    _client.dispose();
  }
}
