import '../../network/services/api_service.dart';
import '../../network/generated/api.models.swagger.dart';
import '../../network/generated/api.enums.swagger.dart' as enums;

/// Service for managing workspace users
class UsersService {
  final ApiService _apiService;
  String? _currentWorkspaceId;

  UsersService(this._apiService);

  /// Set the current workspace ID for user operations
  void setCurrentWorkspace(String workspaceId) {
    _currentWorkspaceId = workspaceId;
  }

  /// Get all users in the current workspace
  Future<List<WorkspaceUserDto>> getWorkspaceUsers() async {
    if (_currentWorkspaceId == null) {
      throw Exception('No workspace selected. Call setCurrentWorkspace() first.');
    }

    try {
      final workspace = await _apiService.getWorkspace(_currentWorkspaceId!);
      return workspace.users ?? [];
    } catch (e) {
      throw Exception('Failed to load workspace users: $e');
    }
  }

  /// Add a user to the current workspace
  Future<void> addUserToWorkspace({
    required String userEmail,
    required enums.ShareWorkspaceRequestRole role,
  }) async {
    if (_currentWorkspaceId == null) {
      throw Exception('No workspace selected. Call setCurrentWorkspace() first.');
    }

    try {
      await _apiService.shareWorkspace(
        workspaceId: _currentWorkspaceId!,
        userEmail: userEmail,
        role: role,
      );
    } catch (e) {
      throw Exception('Failed to add user to workspace: $e');
    }
  }

  /// Remove a user from the current workspace
  Future<void> removeUserFromWorkspace(String targetUserId) async {
    if (_currentWorkspaceId == null) {
      throw Exception('No workspace selected. Call setCurrentWorkspace() first.');
    }

    try {
      await _apiService.removeUserFromWorkspace(
        workspaceId: _currentWorkspaceId!,
        targetUserId: targetUserId,
      );
    } catch (e) {
      throw Exception('Failed to remove user from workspace: $e');
    }
  }

  /// Convert API role enum to display string
  static String roleToDisplayString(enums.WorkspaceUserDtoRole? role) {
    switch (role) {
      case enums.WorkspaceUserDtoRole.admin:
        return 'Admin';
      case enums.WorkspaceUserDtoRole.user:
        return 'User';
      case enums.WorkspaceUserDtoRole.swaggerGeneratedUnknown:
        return 'Unknown';
      case null:
        return 'Unknown';
    }
  }

  /// Convert display string to API role enum
  static enums.ShareWorkspaceRequestRole displayStringToShareRole(String displayString) {
    switch (displayString) {
      case 'Admin':
        return enums.ShareWorkspaceRequestRole.admin;
      case 'User':
      default:
        return enums.ShareWorkspaceRequestRole.user;
    }
  }
}