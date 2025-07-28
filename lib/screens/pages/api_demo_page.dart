import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';

import '../../network/services/api_service.dart';
import '../../network/generated/openapi.models.swagger.dart';
import '../../network/generated/openapi.enums.swagger.dart' as enums;
import '../../providers/auth_provider.dart';
import '../../core/models/user.dart';

class ApiDemoPage extends StatefulWidget {
  const ApiDemoPage({super.key});

  @override
  State<ApiDemoPage> createState() => _ApiDemoPageState();
}

class _ApiDemoPageState extends State<ApiDemoPage> {
  late ApiService _apiService;
  late AuthProvider _authProvider;
  List<WorkspaceDto> _workspaces = [];
  UserDto? _currentUser;
  bool _isLoading = false;
  bool _isLoadingUser = false;
  String? _error;
  String? _userError;

  @override
  void initState() {
    super.initState();
    _apiService = context.read<ApiService>();
    _authProvider = context.read<AuthProvider>();
    _loadWorkspaces();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    setState(() {
      _isLoadingUser = true;
      _userError = null;
    });

    try {
      final user = await _apiService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ User profile loaded: ${user.name ?? user.email ?? 'Unknown'}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _userError = e.toString();
        _isLoadingUser = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to load user profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _testUserProfile() async {
    await _loadCurrentUser();

    // Show detailed user info dialog
    if (_currentUser != null && mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('User Profile Test'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildUserInfoRow('ID', _currentUser!.id),
                _buildUserInfoRow('Name', _currentUser!.name),
                _buildUserInfoRow('Email', _currentUser!.email),
                _buildUserInfoRow('Picture', _currentUser!.picture),
                _buildUserInfoRow('Sub', _currentUser!.sub),
                _buildUserInfoRow('Preferred Username', _currentUser!.preferredUsername),
                _buildUserInfoRow('Given Name', _currentUser!.givenName),
                _buildUserInfoRow('Family Name', _currentUser!.familyName),
                const SizedBox(height: 16),
                const Text('Auth Provider Info:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildUserInfoRow('Auth State', _authProvider.authState.toString()),
                _buildUserInfoRow('Is Authenticated', _authProvider.isAuthenticated.toString()),
                _buildUserInfoRow('Token Type', _authProvider.currentToken?.tokenType),
                _buildUserInfoRow('Token Expires', _authProvider.currentToken?.isExpired.toString()),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _loadCurrentUser();
              },
              child: const Text('Refresh'),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildUserInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(
              value ?? 'null',
              style: TextStyle(
                color: value != null ? null : Colors.grey,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadWorkspaces() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final workspaces = await _apiService.getWorkspaces();
      setState(() {
        _workspaces = workspaces;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createWorkspace() async {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Workspace'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                final colors = context.colorsListening;
                return TextField(
                  controller: nameController,
                  style: TextStyle(color: colors.textColor),
                  decoration: InputDecoration(
                    labelText: 'Workspace Name',
                    hintText: 'Enter workspace name',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    hintStyle: TextStyle(color: colors.textMuted),
                    filled: true,
                    fillColor: colors.inputBg,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: colors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: colors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: colors.accentColor, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (context) {
                final colors = context.colorsListening;
                return TextField(
                  controller: descriptionController,
                  style: TextStyle(color: colors.textColor),
                  decoration: InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter workspace description',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    hintStyle: TextStyle(color: colors.textMuted),
                    filled: true,
                    fillColor: colors.inputBg,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: colors.borderColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: colors.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: colors.accentColor, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
                    ),
                  ),
                  maxLines: 3,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Create'),
          ),
        ],
      ),
    );

    if (result == true && nameController.text.isNotEmpty) {
      try {
        await _apiService.createWorkspace(
          name: nameController.text,
          description: descriptionController.text.isEmpty ? null : descriptionController.text,
        );
        await _loadWorkspaces();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Workspace created successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error creating workspace: $e')),
          );
        }
      }
    }
  }

  Future<void> _shareWorkspace(WorkspaceDto workspace) async {
    final emailController = TextEditingController();
    enums.ShareWorkspaceRequestRole selectedRole = enums.ShareWorkspaceRequestRole.user;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Share "${workspace.name}"'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Builder(
                builder: (context) {
                  final colors = context.colorsListening;
                  return TextField(
                    controller: emailController,
                    style: TextStyle(color: colors.textColor),
                    decoration: InputDecoration(
                      labelText: 'User Email',
                      hintText: 'Enter user email',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      hintStyle: TextStyle(color: colors.textMuted),
                      filled: true,
                      fillColor: colors.inputBg,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: colors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: colors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: colors.accentColor, width: 2),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  );
                },
              ),
              const SizedBox(height: 16),
              Builder(
                builder: (context) {
                  final colors = context.colorsListening;
                  return DropdownButtonFormField<enums.ShareWorkspaceRequestRole>(
                    value: selectedRole,
                    style: TextStyle(color: colors.textColor),
                    decoration: InputDecoration(
                      labelText: 'Role',
                      labelStyle: TextStyle(color: colors.textSecondary),
                      filled: true,
                      fillColor: colors.inputBg,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: colors.borderColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: colors.borderColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: colors.accentColor, width: 2),
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
                      ),
                    ),
                    dropdownColor: colors.inputBg,
                    items: const [
                      DropdownMenuItem(
                        value: enums.ShareWorkspaceRequestRole.user,
                        child: Text('User'),
                      ),
                      DropdownMenuItem(
                        value: enums.ShareWorkspaceRequestRole.admin,
                        child: Text('Admin'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setDialogState(() {
                          selectedRole = value;
                        });
                      }
                    },
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Share'),
            ),
          ],
        ),
      ),
    );

    if (result == true && emailController.text.isNotEmpty) {
      try {
        await _apiService.shareWorkspace(
          workspaceId: workspace.id!,
          userEmail: emailController.text,
          role: selectedRole,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Workspace shared successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error sharing workspace: $e')),
          );
        }
      }
    }
  }

  Future<void> _deleteWorkspace(WorkspaceDto workspace) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workspace'),
        content: Text('Are you sure you want to delete "${workspace.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await _apiService.deleteWorkspace(workspace.id!);
        await _loadWorkspaces();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Workspace deleted successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting workspace: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Demo'),
        actions: [
          IconButton(
            onPressed: _testUserProfile,
            icon: const Icon(Icons.person),
            tooltip: 'Test User Profile',
          ),
          IconButton(
            onPressed: _loadWorkspaces,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Workspaces',
          ),
          IconButton(
            onPressed: _createWorkspace,
            icon: const Icon(Icons.add),
            tooltip: 'Create Workspace',
          ),
        ],
      ),
      body: Column(
        children: [
          // User Profile Section
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Current User Profile',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const Spacer(),
                    if (_isLoadingUser)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        onPressed: _loadCurrentUser,
                        icon: const Icon(Icons.refresh),
                        tooltip: 'Refresh User Profile',
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_userError != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Error loading user: $_userError',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_currentUser != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundImage: _currentUser!.picture != null ? NetworkImage(_currentUser!.picture!) : null,
                          child: _currentUser!.picture == null
                              ? Text(_currentUser!.name?.substring(0, 1).toUpperCase() ?? 'U')
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _currentUser!.name ?? 'No name',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                _currentUser!.email ?? 'No email',
                                style: TextStyle(
                                  color: Theme.of(context).textTheme.bodySmall?.color,
                                ),
                              ),
                              if (_currentUser!.id != null)
                                Text(
                                  'ID: ${_currentUser!.id}',
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: _testUserProfile,
                          icon: const Icon(Icons.info, size: 16),
                          label: const Text('Details'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'No user profile loaded',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // Workspaces Section
          Expanded(
            child: _buildWorkspacesBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspacesBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error loading workspaces',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                _error!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadWorkspaces,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_workspaces.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'No workspaces found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text('Create your first workspace to get started'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _createWorkspace,
              icon: const Icon(Icons.add),
              label: const Text('Create Workspace'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _workspaces.length,
      itemBuilder: (context, index) {
        final workspace = _workspaces[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(workspace.name?.substring(0, 1).toUpperCase() ?? 'W'),
            ),
            title: Text(workspace.name ?? 'Unnamed Workspace'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (workspace.description?.isNotEmpty == true) Text(workspace.description!),
                const SizedBox(height: 4),
                Text(
                  'Owner: ${workspace.ownerName ?? workspace.ownerEmail ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (workspace.users?.isNotEmpty == true)
                  Text(
                    '${workspace.users!.length} member(s)',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
              ],
            ),
            trailing: PopupMenuButton(
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Share'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: ListTile(
                    leading: Icon(Icons.delete, color: Colors.red),
                    title: Text('Delete', style: TextStyle(color: Colors.red)),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'share':
                    _shareWorkspace(workspace);
                    break;
                  case 'delete':
                    _deleteWorkspace(workspace);
                    break;
                }
              },
            ),
          ),
        );
      },
    );
  }
}
