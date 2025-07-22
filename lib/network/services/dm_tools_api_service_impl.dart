import 'package:chopper/chopper.dart';
import 'package:dmtools/network/clients/api_client.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
import 'package:dmtools/network/services/dm_tools_api_service_mock.dart';
import '../generated/openapi.swagger.dart';
import 'dart:convert';

import '../generated/openapi.enums.swagger.dart' as enums;
import 'package:dmtools/core/models/user.dart';
import '../../providers/auth_provider.dart';
import 'package:flutter/foundation.dart';

class DmToolsApiServiceImpl implements DmToolsApiService {
  final ChopperClient _client;
  late final Openapi _api;

  DmToolsApiServiceImpl({
    String? baseUrl,
    AuthProvider? authProvider,
    bool enableLogging = true,
  }) : _client = ApiClientConfig.createClient(
          baseUrl: baseUrl,
          authProvider: authProvider,
          enableLogging: enableLogging,
        ) {
    _api = _client.getService<Openapi>();
  }

  @override
  Future<UserDto> getCurrentUser() async {
    try {
      final response = await _api.apiAuthUserGet();
      if (response.isSuccessful && response.body != null) {
        // The API returns Object, so we need to parse it manually
        final responseBody = response.body!;

        UserDto user;
        if (responseBody is Map<String, dynamic>) {
          user = UserDto.fromJson(responseBody);
        } else if (responseBody is String) {
          // If it's returned as JSON string, parse it first
          final jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
          user = UserDto.fromJson(jsonData);
        } else {
          throw ApiException('Unexpected response format from /api/auth/user: ${responseBody.runtimeType}');
        }

        if (kDebugMode) {
          print('✅ User info loaded from API:');
          print('   - Name: ${user.name}');
          print('   - Email: ${user.email}');
          print('   - ID: ${user.id}');
          print('   - Picture: ${user.picture}');
        }

        return user;
      } else {
        throw ApiException('Failed to get current user', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<List<WorkspaceDto>> getWorkspaces() async {
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

  @override
  Future<WorkspaceDto> getWorkspace(String workspaceId) async {
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

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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

  // Integration methods

  @override
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

  @override
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

  @override
  Future<IntegrationDto> getIntegration(String id, {bool includeSensitive = false}) async {
    try {
      final response = await _api.apiIntegrationsIdGet(id: id, includeSensitive: includeSensitive);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to get integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<IntegrationDto> createIntegration(CreateIntegrationRequest request) async {
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

  @override
  Future<IntegrationDto> updateIntegration(String id, UpdateIntegrationRequest request) async {
    try {
      final response = await _api.apiIntegrationsIdPut(id: id, body: request);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to update integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteIntegration(String id) async {
    try {
      final response = await _api.apiIntegrationsIdDelete(id: id);
      if (!response.isSuccessful) {
        throw ApiException('Failed to delete integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<IntegrationDto> enableIntegration(String id) async {
    try {
      final response = await _api.apiIntegrationsIdEnablePut(id: id);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to enable integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<IntegrationDto> disableIntegration(String id) async {
    try {
      final response = await _api.apiIntegrationsIdDisablePut(id: id);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException('Failed to disable integration', response.statusCode);
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
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

  // Job Configuration methods implementation

  @override
  Future<List<JobConfigurationDto>> getJobConfigurations({bool? enabled}) async {
    try {
      final response = await _api.apiV1JobConfigurationsGet(enabled: enabled);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException(
          'Failed to fetch job configurations: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<JobConfigurationDto> getJobConfiguration(String id) async {
    try {
      final response = await _api.apiV1JobConfigurationsIdGet(id: id);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException(
          'Failed to fetch job configuration: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> getJobConfigurationRaw(String id) async {
    try {
      // Make the raw HTTP call to get the JSON response
      final request = Request('GET', Uri.parse('${_client.baseUrl}/api/v1/job-configurations/$id'), _client.baseUrl);
      final response = await _client.send(request);

      if (response.isSuccessful && response.body != null) {
        // Parse the raw JSON response
        final dynamic responseBody = response.body;
        Map<String, dynamic> jsonData;

        if (responseBody is String) {
          jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
        } else if (responseBody is Map<String, dynamic>) {
          jsonData = responseBody;
        } else {
          throw ApiException('Unexpected response format: ${responseBody.runtimeType}');
        }

        debugPrint('🔍 Raw job configuration JSON: $jsonData');
        return jsonData;
      } else {
        throw ApiException(
          'Failed to fetch raw job configuration: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('❌ Error fetching raw job configuration: $e');
      throw _handleError(e);
    }
  }

  @override
  Future<JobConfigurationDto> createJobConfiguration(CreateJobConfigurationRequest request) async {
    try {
      final response = await _api.apiV1JobConfigurationsPost(body: request);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException(
          'Failed to create job configuration: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<JobConfigurationDto> createJobConfigurationRaw(
      String name, String jobType, Map<String, dynamic> jobParameters, Map<String, dynamic> integrationMappings,
      {String? description, bool? enabled}) async {
    try {
      // Build raw JSON request body
      final requestBody = {
        'name': name,
        'jobType': jobType,
        if (description != null) 'description': description,
        'jobParameters': jobParameters,
        'integrationMappings': integrationMappings,
        'enabled': enabled ?? true,
      };

      debugPrint('🔄 Sending raw job config creation: $requestBody');

      // Make raw HTTP POST request
      final request = Request('POST', Uri.parse('${_client.baseUrl}/api/v1/job-configurations'), _client.baseUrl,
          body: jsonEncode(requestBody));
      request.headers['Content-Type'] = 'application/json';

      final response = await _client.send(request);

      if (response.isSuccessful && response.body != null) {
        // Parse the raw JSON response
        final dynamic responseBody = response.body;
        Map<String, dynamic> jsonData;

        if (responseBody is String) {
          jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
        } else if (responseBody is Map<String, dynamic>) {
          jsonData = responseBody;
        } else {
          throw ApiException('Unexpected response format: ${responseBody.runtimeType}');
        }

        // Convert to DTO manually to ensure proper data handling
        return JobConfigurationDto.fromJson(jsonData);
      } else {
        throw ApiException(
          'Failed to create job configuration: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('❌ Error creating job configuration: $e');
      throw _handleError(e);
    }
  }

  @override
  Future<JobConfigurationDto> updateJobConfiguration(String id, UpdateJobConfigurationRequest request) async {
    try {
      final response = await _api.apiV1JobConfigurationsIdPut(id: id, body: request);
      if (response.isSuccessful && response.body != null) {
        return response.body!;
      } else {
        throw ApiException(
          'Failed to update job configuration: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<JobConfigurationDto> updateJobConfigurationRaw(
      String id, String name, Map<String, dynamic> jobParameters, Map<String, dynamic> integrationMappings,
      {String? description, bool? enabled}) async {
    try {
      // Build raw JSON request body
      final requestBody = {
        'name': name,
        if (description != null) 'description': description,
        'jobParameters': jobParameters,
        'integrationMappings': integrationMappings,
        if (enabled != null) 'enabled': enabled,
      };

      debugPrint('🔄 Sending raw job config update: $requestBody');

      // Make raw HTTP PUT request
      final request = Request('PUT', Uri.parse('${_client.baseUrl}/api/v1/job-configurations/$id'), _client.baseUrl,
          body: jsonEncode(requestBody));
      request.headers['Content-Type'] = 'application/json';

      final response = await _client.send(request);

      if (response.isSuccessful && response.body != null) {
        // Parse the raw JSON response
        final dynamic responseBody = response.body;
        Map<String, dynamic> jsonData;

        if (responseBody is String) {
          jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
        } else if (responseBody is Map<String, dynamic>) {
          jsonData = responseBody;
        } else {
          throw ApiException('Unexpected response format: ${responseBody.runtimeType}');
        }

        // Convert to DTO manually to ensure proper data handling
        return JobConfigurationDto.fromJson(jsonData);
      } else {
        throw ApiException(
          'Failed to update job configuration: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      debugPrint('❌ Error updating job configuration: $e');
      throw _handleError(e);
    }
  }

  @override
  Future<void> deleteJobConfiguration(String id) async {
    try {
      final response = await _api.apiV1JobConfigurationsIdDelete(id: id);
      if (!response.isSuccessful) {
        throw ApiException(
          'Failed to delete job configuration: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Object> executeJobConfiguration(String id, ExecuteJobConfigurationRequest request) async {
    try {
      // Use the correct endpoint that actually executes the job: /api/v1/jobs/configurations/{configId}/execute
      // instead of /api/v1/job-configurations/{id}/execute (which only gets execution parameters)
      final response = await _api.apiV1JobsConfigurationsConfigIdExecutePost(configId: id, body: request);
      if (response.isSuccessful) {
        return response.body ?? {};
      } else {
        throw ApiException(
          'Failed to execute job configuration: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<JobTypeDto> getJobType(String jobName) async {
    try {
      if (kDebugMode) {
        print('🔍 API Call: GET /api/v1/jobs/types/$jobName');
      }

      final response = await _api.apiV1JobsTypesJobNameGet(jobName: jobName);

      if (response.isSuccessful && response.body != null) {
        if (kDebugMode) {
          print('✅ Successfully loaded job type: $jobName');
        }
        return response.body!;
      } else {
        if (kDebugMode) {
          print('❌ API call failed with status: ${response.statusCode}');
        }
        throw ApiException(
          'Failed to get job type: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('💥 API call error, falling back to mock data: $e');
      }
      // If endpoint doesn't exist or fails, fallback to mock data
      return DmToolsApiServiceMock().getJobType(jobName);
    }
  }

  @override
  Future<List<JobTypeDto>> getAvailableJobTypes() async {
    try {
      if (kDebugMode) {
        print('🔍 API Call: GET /api/v1/jobs/types');
      }

      final response = await _api.apiV1JobsTypesGet();

      if (response.isSuccessful && response.body != null) {
        if (kDebugMode) {
          print('✅ Successfully loaded job types from API');
        }

        // The API returns a list of job type objects
        final jobTypesJson = response.body as List<dynamic>;
        final jobTypes = jobTypesJson.map((json) => JobTypeDto.fromJson(json as Map<String, dynamic>)).toList();

        if (kDebugMode) {
          print('📋 Available job types: ${jobTypes.map((jt) => jt.type).toList()}');
        }

        return jobTypes;
      } else {
        if (kDebugMode) {
          print('❌ API call failed with status: ${response.statusCode}');
        }
        throw ApiException(
          'Failed to get available job types: ${response.statusCode}',
          response.statusCode,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('💥 API call error, falling back to mock data: $e');
      }
      // If endpoint doesn't exist or fails, fallback to mock data
      return DmToolsApiServiceMock().getAvailableJobTypes();
    }
  }

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

  @override
  void dispose() {
    _client.dispose();
  }
}
