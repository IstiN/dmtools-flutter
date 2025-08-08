import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

import '../../core/pages/authenticated_page.dart';
import '../../core/services/users_service.dart';
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
  List<WorkspaceUserDto> _allUsers = [];
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

      // Check current user role from auth provider to ensure admin access
      // In a real app, this would come from the current user context
      // For now, we'll try to call the admin API and handle 403 errors

      // Load admin users directly from new API
      print('🔐 UsersPage: Calling getAdminUsers API...');
      final adminUsersResponse = await authService.execute(() async {
        return await _usersService.getAdminUsers(
          size: 100, // Load more users for now
          search: _searchQuery.isNotEmpty ? _searchQuery : null,
        );
      });

      print('🔐 UsersPage: API Response - content length: ${adminUsersResponse.content.length}');
      print('🔐 UsersPage: API Response - totalElements: ${adminUsersResponse.totalElements}');

      // Convert AdminUserDto to WorkspaceUserDto for compatibility
      final users = adminUsersResponse.content.map((adminUser) => adminUser.toWorkspaceUserDto()).toList();

      print('🔐 UsersPage: Converted users count: ${users.length}');
      if (users.isNotEmpty) {
        print('🔐 UsersPage: First user: ${users.first.email} (${users.first.role})');
      }

      setState(() {
        _allUsers = users;
      });

      if (users.isEmpty) {
        print('🔐 UsersPage: Setting EMPTY state - no users found');
        setEmpty();
      } else {
        print('🔐 UsersPage: Setting LOADED state - ${users.length} users found');
        setLoaded();
      }

      // print('🔐 UsersPage: Loaded ${users.length} admin users');
    } catch (e) {
      // print('🔐 UsersPage: Error loading data: $e');
      if (e.toString().contains('403') || e.toString().contains('Forbidden')) {
        setError('Admin access required. You do not have permission to manage users.');
      } else {
        setError('Failed to load users: $e');
      }
    }
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

      // Make API call to update role using new admin endpoint
      await authService.execute(() async {
        await _usersService.updateUserRole(
          userId: userId,
          role: newRole,
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
    // Admin user removal is not implemented in the new API
    // This would require a different endpoint
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('User removal is not available for admin users'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  Future<void> _reloadUsers() async {
    try {
      final adminUsersResponse = await authService.execute(() async {
        return await _usersService.getAdminUsers(
          size: 100,
          search: _searchQuery.isNotEmpty ? _searchQuery : null,
        );
      });

      final users = adminUsersResponse.content.map((adminUser) => adminUser.toWorkspaceUserDto()).toList();

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
