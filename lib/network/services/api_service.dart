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
