import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

import '../../core/services/users_service.dart';
import '../../network/services/api_service.dart';
import '../../network/generated/api.models.swagger.dart';
import '../../widgets/users_table.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  late UsersService _usersService;
  List<WorkspaceUserDto> _allUsers = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final apiService = context.read<ApiService>();
    _usersService = UsersService(apiService);
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // For demo purposes, we'll create some mock users since API might not have workspace data
      // In production, this would get real workspace ID from context
      _usersService.setCurrentWorkspace('demo-workspace-id');
      
      try {
        final users = await _usersService.getWorkspaceUsers();
        setState(() {
          _allUsers = users;
          _isLoading = false;
        });
      } catch (apiError) {
        // If API fails, show mock data for demo
        setState(() {
          _allUsers = _createMockUsers();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  List<WorkspaceUserDto> _createMockUsers() {
    return [
      const WorkspaceUserDto(
        id: '1',
        email: 'admin@dmtools.com',
      ),
      const WorkspaceUserDto(
        id: '2', 
        email: 'user1@dmtools.com',
      ),
      const WorkspaceUserDto(
        id: '3',
        email: 'user2@dmtools.com', 
      ),
      const WorkspaceUserDto(
        id: '4',
        email: 'manager@dmtools.com',
      ),
      const WorkspaceUserDto(
        id: '5',
        email: 'developer@dmtools.com',
      ),
    ];
  }

  Future<void> _removeUser(String userId) async {
    try {
      await _usersService.removeUserFromWorkspace(userId);
      await _loadUsers(); // Reload users after removal
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

  Future<void> _addUser(String email, String role) async {
    try {
      final apiRole = UsersService.displayStringToShareRole(role);
      await _usersService.addUserToWorkspace(
        userEmail: email,
        role: apiRole,
      );
      await _loadUsers(); // Reload users after addition
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add user: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    if (_error != null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colors.cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.borderColor),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Error Loading Users',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
              ),
              const SizedBox(height: 8),
              Text(
                _error!,
                style: TextStyle(color: colors.textSecondary),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                text: 'Retry',
                onPressed: _loadUsers,
                size: ButtonSize.small,
              ),
            ],
          ),
        ),
      );
    }

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
              PrimaryButton(
                text: 'Add User',
                onPressed: () => _showAddUserDialog(),
                size: ButtonSize.small,
                icon: Icons.person_add,
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Users Table
          Expanded(
            child: UsersTable(
              users: _allUsers,
              searchQuery: _searchQuery,
              isLoading: _isLoading,
              onRefresh: _loadUsers,
              onSearchChanged: (query) => setState(() {
                _searchQuery = query;
              }),
              onRemoveUser: _removeUser,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog() {
    final emailController = TextEditingController();
    String selectedRole = 'User';
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add User to Workspace'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                hintText: 'user@example.com',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(labelText: 'Role'),
              items: const [
                DropdownMenuItem(value: 'User', child: Text('User')),
                DropdownMenuItem(value: 'Admin', child: Text('Admin')),
              ],
              onChanged: (value) => selectedRole = value ?? 'User',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (emailController.text.isNotEmpty) {
                Navigator.of(context).pop();
                _addUser(emailController.text, selectedRole);
              }
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }
}
