import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../../core/services/workspace_service.dart';
import '../../core/models/workspace.dart';
import '../../network/generated/openapi.models.swagger.dart' as api;
import '../../network/generated/openapi.enums.swagger.dart' as enums;
import '../../providers/auth_provider.dart' as app_auth;
import '../../network/services/dm_tools_api_service.dart';
import 'package:flutter/foundation.dart';

class WorkspacesPage extends StatefulWidget {
  const WorkspacesPage({super.key});

  @override
  State<WorkspacesPage> createState() => _WorkspacesPageState();
}

class _WorkspacesPageState extends State<WorkspacesPage> {
  late WorkspaceService _workspaceService;
  bool _showCreateForm = false;
  bool _showEditForm = false;
  bool _showShareForm = false;
  Workspace? _selectedWorkspace;
  bool _hasLoadedWorkspaces = false;

  final _createNameController = TextEditingController();
  final _createDescriptionController = TextEditingController();
  final _editNameController = TextEditingController();
  final _editDescriptionController = TextEditingController();
  final _shareEmailController = TextEditingController();
  WorkspaceRole _shareRole = WorkspaceRole.user;

  @override
  void initState() {
    super.initState();
    // Initialize WorkspaceService with dependencies for real data access
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
    final apiService = Provider.of<DmToolsApiService>(context, listen: false);
    _workspaceService = WorkspaceService(
      apiService: apiService,
      authProvider: authProvider,
    );

    // Load workspaces only if already authenticated, otherwise wait for auth
    if (authProvider.isAuthenticated) {
      _loadWorkspaces();
      _hasLoadedWorkspaces = true;
    }
  }

  @override
  void dispose() {
    _createNameController.dispose();
    _createDescriptionController.dispose();
    _editNameController.dispose();
    _editDescriptionController.dispose();
    _shareEmailController.dispose();
    super.dispose();
  }

  Future<void> _loadWorkspaces() async {
    await _workspaceService.loadWorkspaces();
  }

  // Helper function to convert local role to API role
  enums.ShareWorkspaceRequestRole _convertLocalRoleToApi(WorkspaceRole localRole) {
    switch (localRole) {
      case WorkspaceRole.admin:
        return enums.ShareWorkspaceRequestRole.admin;
      case WorkspaceRole.user:
        return enums.ShareWorkspaceRequestRole.user;
    }
  }

  Future<void> _createWorkspace() async {
    if (_createNameController.text.trim().isEmpty) return;

    final request = CreateWorkspaceRequest(
      name: _createNameController.text.trim(),
      description: _createDescriptionController.text.trim().isEmpty ? null : _createDescriptionController.text.trim(),
    );

    final result = await _workspaceService.createWorkspace(request);
    if (!mounted) return;

    if (result != null) {
      _createNameController.clear();
      _createDescriptionController.clear();
      setState(() {
        _showCreateForm = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workspace created successfully!')),
      );
    }
  }

  Future<void> _updateWorkspace() async {
    if (_selectedWorkspace == null || _editNameController.text.trim().isEmpty) return;

    final request = UpdateWorkspaceRequest(
      name: _editNameController.text.trim(),
      description: _editDescriptionController.text.trim().isEmpty ? null : _editDescriptionController.text.trim(),
    );

    final result = await _workspaceService.updateWorkspace(_selectedWorkspace!.id, request);
    if (!mounted) return;

    if (result != null) {
      setState(() {
        _showEditForm = false;
        _selectedWorkspace = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workspace updated successfully!')),
      );
    }
  }

  Future<void> _deleteWorkspace(Workspace workspace) async {
    final result = await _workspaceService.deleteWorkspace(workspace.id);
    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Workspace deleted successfully!')),
      );
    }
  }

  Future<void> _shareWorkspace() async {
    if (_selectedWorkspace == null || _shareEmailController.text.trim().isEmpty) return;

    final request = api.ShareWorkspaceRequest(
      email: _shareEmailController.text.trim(),
      role: _convertLocalRoleToApi(_shareRole),
    );

    await _workspaceService.shareWorkspace(_selectedWorkspace!.id, request);
    if (!mounted) return;

    _shareEmailController.clear();
    setState(() {
      _showShareForm = false;
      _selectedWorkspace = null;
      _shareRole = WorkspaceRole.user;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Workspace shared successfully!')),
    );
  }

  Future<void> _removeUser(Workspace workspace, WorkspaceUser user) async {
    final result = await _workspaceService.removeUserFromWorkspace(workspace.id, user.userId);
    if (!mounted) return;

    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${user.userName} removed from workspace')),
      );
    }
  }

  List<Widget> _getHeaderActions() {
    final actions = <Widget>[];

    // Debug button (only in debug mode)
    if (kDebugMode) {
      actions.add(
        Consumer<app_auth.AuthProvider>(
          builder: (context, authProvider, child) {
            return SecondaryButton(
              text: 'Debug Auth',
              icon: Icons.bug_report,
              size: ButtonSize.small,
              onPressed: () {
                _showAuthDebugDialog(authProvider);
              },
            );
          },
        ),
      );
    }

    // Create Workspace button
    actions.add(
      PrimaryButton(
        text: 'Create Workspace',
        icon: Icons.add,
        size: ButtonSize.small,
        onPressed: _showCreateForm
            ? null
            : () {
                setState(() {
                  _showCreateForm = true;
                  _showEditForm = false;
                  _showShareForm = false;
                  _createNameController.clear();
                  _createDescriptionController.clear();
                });
              },
      ),
    );

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    // Check if we need to load workspaces after authentication
    final authProvider = Provider.of<app_auth.AuthProvider>(context);
    if (authProvider.isAuthenticated && !_hasLoadedWorkspaces && !_workspaceService.isLoading) {
      // Use post-frame callback to avoid calling setState during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadWorkspaces();
        _hasLoadedWorkspaces = true;
      });
    }

    return ChangeNotifierProvider.value(
      value: _workspaceService,
      child: Consumer<WorkspaceService>(
        builder: (context, service, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with PageActionBar
              PageActionBar(
                title: 'Workspace Management',
                actions: _getHeaderActions(),
              ),
              const SizedBox(height: 24),

              // Scrollable content area
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Error display
                      if (service.error != null) ...[
                        _buildErrorMessage(colors, service.error!),
                        const SizedBox(height: 16),
                      ],

                      // Create form
                      if (_showCreateForm) ...[
                        _buildCreateForm(colors),
                        const SizedBox(height: 24),
                      ],

                      // Edit form
                      if (_showEditForm && _selectedWorkspace != null) ...[
                        _buildEditForm(colors),
                        const SizedBox(height: 24),
                      ],

                      // Share form
                      if (_showShareForm && _selectedWorkspace != null) ...[
                        _buildShareForm(colors),
                        const SizedBox(height: 24),
                      ],

                      // Loading indicator
                      if (service.isLoading) ...[
                        _buildLoadingIndicator(colors),
                        const SizedBox(height: 24),
                      ],

                      // Workspaces list
                      _buildWorkspacesList(colors, service.workspaces),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAuthDebugDialog(app_auth.AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Authentication Debug Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Is Demo Mode: ${authProvider.isDemoMode}'),
            Text('Should Use Mock Data: ${authProvider.shouldUseMockData}'),
            Text('Is Authenticated: ${authProvider.isAuthenticated}'),
            Text('Auth State: ${authProvider.authState}'),
            Text('Current User: ${authProvider.currentUser?.name}'),
            Text('User Email: ${authProvider.currentUser?.email}'),
            const SizedBox(height: 16),
            const Text('Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              authProvider.forceResetDemoMode();
              Navigator.of(context).pop();
              _loadWorkspaces(); // Reload to see changes
            },
            child: const Text('Force Reset Demo Mode'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage(ThemeColorSet colors, String error) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.dangerColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.dangerColor),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.dangerColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: colors.dangerColor),
            ),
          ),
          IconButton(
            onPressed: () => _workspaceService.clearError(),
            icon: Icon(Icons.close, color: colors.dangerColor),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateForm(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Create Workspace',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showCreateForm = false;
                  });
                },
                icon: Icon(Icons.close, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _createNameController,
            label: 'Workspace Name *',
            hint: 'Enter workspace name',
            colors: colors,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _createDescriptionController,
            label: 'Description',
            hint: 'Enter workspace description (optional)',
            colors: colors,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                text: 'Cancel',
                onPressed: () {
                  setState(() {
                    _showCreateForm = false;
                  });
                },
              ),
              const SizedBox(width: 12),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _createNameController,
                builder: (context, value, child) {
                  return PrimaryButton(
                    text: 'Create',
                    onPressed: value.text.trim().isEmpty ? null : _createWorkspace,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Edit Workspace',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showEditForm = false;
                    _selectedWorkspace = null;
                  });
                },
                icon: Icon(Icons.close, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _editNameController,
            label: 'Workspace Name *',
            hint: 'Enter workspace name',
            colors: colors,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _editDescriptionController,
            label: 'Description',
            hint: 'Enter workspace description (optional)',
            colors: colors,
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                text: 'Cancel',
                onPressed: () {
                  setState(() {
                    _showEditForm = false;
                    _selectedWorkspace = null;
                  });
                },
              ),
              const SizedBox(width: 12),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _editNameController,
                builder: (context, value, child) {
                  return PrimaryButton(
                    text: 'Update',
                    onPressed: value.text.trim().isEmpty ? null : _updateWorkspace,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShareForm(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Share Workspace',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colors.textColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showShareForm = false;
                    _selectedWorkspace = null;
                  });
                },
                icon: Icon(Icons.close, color: colors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _shareEmailController,
            label: 'User Email *',
            hint: 'Enter user email address',
            colors: colors,
          ),
          const SizedBox(height: 16),
          Text(
            'Role',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Theme(
            data: Theme.of(context).copyWith(
              radioTheme: RadioThemeData(
                fillColor: WidgetStateProperty.all(colors.accentColor),
              ),
            ),
            child: Column(
              children: [
                RadioListTile<WorkspaceRole>(
                  title: Text('User', style: TextStyle(color: colors.textColor)),
                  subtitle: Text('Can view and use workspace', style: TextStyle(color: colors.textSecondary)),
                  value: WorkspaceRole.user,
                  groupValue: _shareRole,
                  onChanged: (value) {
                    setState(() {
                      _shareRole = value!;
                    });
                  },
                ),
                RadioListTile<WorkspaceRole>(
                  title: Text('Admin', style: TextStyle(color: colors.textColor)),
                  subtitle: Text('Can manage workspace and users', style: TextStyle(color: colors.textSecondary)),
                  value: WorkspaceRole.admin,
                  groupValue: _shareRole,
                  onChanged: (value) {
                    setState(() {
                      _shareRole = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                text: 'Cancel',
                onPressed: () {
                  setState(() {
                    _showShareForm = false;
                    _selectedWorkspace = null;
                  });
                },
              ),
              const SizedBox(width: 12),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _shareEmailController,
                builder: (context, value, child) {
                  return PrimaryButton(
                    text: 'Share',
                    onPressed: value.text.trim().isEmpty ? null : _shareWorkspace,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required ThemeColorSet colors,
    int maxLines = 1,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: colors.textColor,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          maxLines: maxLines,
          onChanged: onChanged,
          style: TextStyle(color: colors.textColor),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colors.textMuted),
            filled: true,
            fillColor: colors.inputBg,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.inputFocusBorder, width: 2),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor.withValues(alpha: 0.5)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Processing...',
            style: TextStyle(color: colors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspacesList(ThemeColorSet colors, List<Workspace> workspaces) {
    if (workspaces.isEmpty) {
      return _buildEmptyState(colors);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...workspaces.map((workspace) => _buildWorkspaceCard(workspace, colors)),
      ],
    );
  }

  Widget _buildEmptyState(ThemeColorSet colors) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.group_work,
            size: 48,
            color: colors.accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            'No Workspaces Yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colors.textColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first workspace to start collaborating with your team.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkspaceCard(Workspace workspace, ThemeColorSet colors) {
    final isAdmin = workspace.currentUserRole == WorkspaceRole.admin;
    final lastActive = _formatLastActive(workspace.updatedAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CircleAvatar(
                backgroundColor: colors.accentColor,
                child: Text(
                  workspace.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            workspace.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor,
                            ),
                          ),
                        ),
                        if (isAdmin)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: colors.accentColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ADMIN',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: colors.accentColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (workspace.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        workspace.description!,
                        style: TextStyle(
                          color: colors.textSecondary,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Stats
          Row(
            children: [
              Icon(Icons.people, size: 16, color: colors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${workspace.userCount} members',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 16),
              Icon(Icons.access_time, size: 16, color: colors.textSecondary),
              const SizedBox(width: 4),
              Text(
                'Last active: $lastActive',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // User list
          if (workspace.users.isNotEmpty) ...[
            Text(
              'Members:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: colors.textColor,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            ...workspace.users.take(3).map((user) => _buildUserItem(workspace, user, colors)),
            if (workspace.users.length > 3)
              Text(
                '+ ${workspace.users.length - 3} more members',
                style: TextStyle(
                  color: colors.textSecondary,
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 16),
          ],

          // Actions
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SecondaryButton(
                text: 'Open',
                onPressed: () {
                  // Open workspace details
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Opening ${workspace.name}')),
                  );
                },
              ),
              if (isAdmin) ...[
                const SizedBox(width: 8),
                SecondaryButton(
                  text: 'Share',
                  icon: Icons.person_add,
                  onPressed: () {
                    setState(() {
                      _selectedWorkspace = workspace;
                      _showShareForm = true;
                      _showCreateForm = false;
                      _showEditForm = false;
                      _shareEmailController.clear();
                      _shareRole = WorkspaceRole.user;
                    });
                  },
                ),
                const SizedBox(width: 8),
                SecondaryButton(
                  text: 'Edit',
                  icon: Icons.edit,
                  onPressed: () {
                    setState(() {
                      _selectedWorkspace = workspace;
                      _showEditForm = true;
                      _showCreateForm = false;
                      _showShareForm = false;
                      _editNameController.text = workspace.name;
                      _editDescriptionController.text = workspace.description ?? '';
                    });
                  },
                ),
                const SizedBox(width: 8),
                SecondaryButton(
                  text: 'Delete',
                  icon: Icons.delete,
                  onPressed: () => _showDeleteConfirmation(workspace),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserItem(Workspace workspace, WorkspaceUser user, ThemeColorSet colors) {
    final isCurrentUserAdmin = workspace.currentUserRole == WorkspaceRole.admin;
    final isOwner = user.userId == workspace.ownerId;

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: colors.textSecondary.withValues(alpha: 0.2),
            child: Text(
              user.userName.substring(0, 1).toUpperCase(),
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: colors.textSecondary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${user.userName} (${user.userEmail})',
              style: TextStyle(
                fontSize: 12,
                color: colors.textColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: user.role == WorkspaceRole.admin
                  ? colors.accentColor.withValues(alpha: 0.1)
                  : colors.textSecondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isOwner ? 'OWNER' : user.role.value,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: user.role == WorkspaceRole.admin ? colors.accentColor : colors.textSecondary,
              ),
            ),
          ),
          if (isCurrentUserAdmin && !isOwner) ...[
            const SizedBox(width: 8),
            IconButton(
              onPressed: () => _removeUser(workspace, user),
              icon: const Icon(Icons.remove_circle, size: 16),
              color: colors.dangerColor,
              tooltip: 'Remove user',
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteConfirmation(Workspace workspace) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Workspace'),
        content: Text('Are you sure you want to delete "${workspace.name}"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _deleteWorkspace(workspace);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  String _formatLastActive(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 30).floor()}mo ago';
    }
  }
}
