import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

import '../../core/pages/authenticated_page.dart';
import '../../core/services/users_service.dart';
import '../../core/services/workspace_service.dart';
import '../../core/models/workspace.dart';
import '../../network/services/api_service.dart';
import '../../network/generated/api.models.swagger.dart';
import '../../network/generated/api.enums.swagger.dart' as enums;
import '../../widgets/users_table.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends AuthenticatedPage<UsersPage> {
  late UsersService _usersService;
  late WorkspaceService _workspaceService;
  List<WorkspaceUserDto> _allUsers = [];
  String? _currentWorkspaceId;
  enums.WorkspaceDtoCurrentUserRole? _currentUserRole;
  String _searchQuery = '';

  @override
  String get loadingMessage => 'Loading user management...';

  @override
  String get errorTitle => 'Access Denied';

  @override
  String get emptyTitle => 'No Users Found';

  @override
  String get emptyMessage => 'This workspace has no users yet.';

  @override
  IconData get emptyIcon => Icons.people_outline;

  @override
  Future<void> loadAuthenticatedData() async {
    // print('🔐 UsersPage: Loading authenticated data...');

    try {
      // Initialize services
      final apiService = context.read<ApiService>();
      _usersService = UsersService(apiService);
      _workspaceService = WorkspaceService(apiService: apiService);

      // Load workspaces and check admin access
      final workspaces = await authService.execute(() async {
        await _workspaceService.loadWorkspaces();
        return _workspaceService.workspaces;
      });

      if (workspaces.isEmpty) {
        setError('No workspace found. Please create a workspace first.');
        return;
      }

      // Use the first workspace (in real app this would be selected workspace)
      final currentWorkspace = workspaces.first;
      _currentWorkspaceId = currentWorkspace.id;
      _currentUserRole = _convertLocalRoleToApi(currentWorkspace.currentUserRole);

      // Check if user has admin role
      if (_currentUserRole != enums.WorkspaceDtoCurrentUserRole.admin) {
        setError('Admin access required. You do not have permission to manage users.');
        return;
      }

      // Load workspace users
      final users = await authService.execute(() async {
        _usersService.setCurrentWorkspace(_currentWorkspaceId!);
        return await _usersService.getWorkspaceUsers();
      });

      setState(() {
        _allUsers = users;
      });

      if (users.isEmpty) {
        setEmpty();
      } else {
        setLoaded();
      }

      // print('🔐 UsersPage: Loaded ${users.length} users for workspace $_currentWorkspaceId');
    } catch (e) {
      // print('🔐 UsersPage: Error loading data: $e');
      setError('Failed to load users: $e');
    }
  }

  /// Convert local WorkspaceRole to API enum
  enums.WorkspaceDtoCurrentUserRole _convertLocalRoleToApi(WorkspaceRole localRole) {
    return switch (localRole) {
      WorkspaceRole.admin => enums.WorkspaceDtoCurrentUserRole.admin,
      WorkspaceRole.user => enums.WorkspaceDtoCurrentUserRole.user,
    };
  }

  Future<void> _changeUserRole(String userId, enums.WorkspaceUserDtoRole newRole) async {
    try {
      // Find the user in our list
      final userIndex = _allUsers.indexWhere((user) => user.id == userId);
      if (userIndex == -1) {
        throw Exception('User not found');
      }

      final oldUser = _allUsers[userIndex];

      // Update the user role locally for immediate UI feedback
      setState(() {
        _allUsers[userIndex] = WorkspaceUserDto(
          id: oldUser.id,
          email: oldUser.email,
          role: newRole,
        );
      });

      // Make API call to update role
      await authService.execute(() async {
        // For role change, we need to remove and re-add the user with new role
        // This is based on the current API structure
        final shareRole = newRole == enums.WorkspaceUserDtoRole.admin
            ? enums.ShareWorkspaceRequestRole.admin
            : enums.ShareWorkspaceRequestRole.user;

        await _usersService.addUserToWorkspace(
          userEmail: oldUser.email!,
          role: shareRole,
        );
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User role changed to ${UsersService.roleToDisplayString(newRole)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Revert the UI change on error
      await _reloadUsers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to change user role: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _removeUser(String userId) async {
    try {
      await authService.execute(() async {
        await _usersService.removeUserFromWorkspace(userId);
      });

      // Reload users after removal
      await _reloadUsers();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User removed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to remove user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reloadUsers() async {
    try {
      final users = await authService.execute(() async {
        return await _usersService.getWorkspaceUsers();
      });

      setState(() {
        _allUsers = users;
      });
    } catch (e) {
      // print('Error reloading users: $e');
    }
  }

  @override
  Widget buildAuthenticatedContent(BuildContext context) {
    final colors = context.colorsListening;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.people_outlined, size: 32, color: colors.textColor),
              const SizedBox(width: 12),
              Text(
                'Users Management',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
              ),
              const Spacer(),
              Text(
                '${_allUsers.length} users',
                style: TextStyle(fontSize: 16, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Users Table with Role Management
          Expanded(
            child: UsersTable(
              users: _allUsers,
              searchQuery: _searchQuery,
              onRefresh: _reloadUsers,
              onSearchChanged: (query) => setState(() {
                _searchQuery = query;
              }),
              onRemoveUser: _removeUser,
              onRoleChanged: _changeUserRole,
            ),
          ),
        ],
      ),
    );
  }
}
