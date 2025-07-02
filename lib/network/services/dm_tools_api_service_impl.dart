import 'package:chopper/chopper.dart';
import 'package:dmtools/network/clients/api_client.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
import '../generated/openapi.swagger.dart';
import 'dart:convert';

import '../generated/openapi.enums.swagger.dart' as enums;
import 'package:dmtools/core/models/user.dart';

class DmToolsApiServiceImpl implements DmToolsApiService {
  final ChopperClient _client;
  late final Openapi _api;

  DmToolsApiServiceImpl({
    String? baseUrl,
    bool enableLogging = true,
  }) : _client = ApiClientConfig.createClient(
          baseUrl: baseUrl,
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
