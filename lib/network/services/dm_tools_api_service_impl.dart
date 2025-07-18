import 'package:chopper/chopper.dart';
import 'package:dmtools/network/clients/api_client.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
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
