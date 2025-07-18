import 'package:dmtools/core/models/user.dart';
import 'package:dmtools/network/generated/openapi.models.swagger.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
import 'package:flutter/foundation.dart';

import 'package:dmtools/network/generated/openapi.enums.swagger.dart' as enums;

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

class DmToolsApiServiceMock implements DmToolsApiService {
  DmToolsApiServiceMock();

  /// Get the current authenticated user's profile
  @override
  Future<UserDto> getCurrentUser() async {
    const user = UserDto(
      id: 'demo_user_123',
      name: 'Demo User',
      email: 'demo@dmtools.com',
    );

    if (kDebugMode) {
      print('✅ User info loaded from MOCK API (Demo Mode):');
      print('   - Name: ${user.name}');
      print('   - Email: ${user.email}');
      print('   - ID: ${user.id}');
      print('   - Picture: ${user.picture}');
    }

    return user;
  }

  @override
  Future<List<WorkspaceDto>> getWorkspaces() async {
    return _MockData.mockWorkspaces;
  }

  @override
  Future<WorkspaceDto> getWorkspace(String workspaceId) async {
    try {
      return _MockData.mockWorkspaces.firstWhere(
        (workspace) => workspace.id == workspaceId,
      );
    } catch (e) {
      throw ApiException('Demo workspace not found: $workspaceId');
    }
  }

  @override
  Future<WorkspaceDto> createWorkspace({
    required String name,
    String? description,
  }) async {
    return const WorkspaceDto();
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) => Future.value();

  @override
  Future<void> shareWorkspace({
    required String workspaceId,
    required String userEmail,
    required enums.ShareWorkspaceRequestRole role,
  }) =>
      Future.value();

  @override
  Future<void> removeUserFromWorkspace({
    required String workspaceId,
    required String targetUserId,
  }) async =>
      Future.value();

  @override
  Future<WorkspaceDto> createDefaultWorkspace() => Future.value(const WorkspaceDto());

  // Integration methods

  @override
  Future<List<IntegrationDto>> getIntegrations() async {
    return [];
  }

  @override
  Future<List<IntegrationTypeDto>> getIntegrationTypes() async {
    return [];
  }

  @override
  Future<IntegrationDto> getIntegration(String id, {bool includeSensitive = false}) async {
    return const IntegrationDto();
  }

  @override
  Future<IntegrationDto> createIntegration(CreateIntegrationRequest request) async {
    return const IntegrationDto();
  }

  @override
  Future<IntegrationDto> updateIntegration(String id, UpdateIntegrationRequest request) async {
    return const IntegrationDto();
  }

  @override
  Future<void> deleteIntegration(String id) async {
    // Mock implementation
  }

  @override
  Future<IntegrationDto> enableIntegration(String id) async {
    return const IntegrationDto();
  }

  @override
  Future<IntegrationDto> disableIntegration(String id) async {
    return const IntegrationDto();
  }

  @override
  Future<Object> testIntegration(TestIntegrationRequest request) async {
    return {};
  }

  @override
  void dispose() {}
}
