import 'dart:math';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../models/workspace.dart';
import '../../network/generated/openapi.models.swagger.dart' as api;
import '../../network/generated/openapi.enums.swagger.dart' as enums;
import '../../network/services/dm_tools_api_service.dart';
import '../../providers/auth_provider.dart';

class WorkspaceService with ChangeNotifier {
  static const String _currentUserId = 'user-123';
  static const String _currentUserName = 'John Doe';
  static const String _currentUserEmail = 'john.doe@example.com';

  bool _isLoading = false;
  String? _error;
  List<Workspace> _workspaces = [];
  final DmToolsApiService? _apiService;
  final AuthProvider? _authProvider;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Workspace> get workspaces => List.unmodifiable(_workspaces);

  WorkspaceService({DmToolsApiService? apiService, AuthProvider? authProvider})
      : _apiService = apiService,
        _authProvider = authProvider {
    _initializeMockData();
  }

  // Check if we should use mock data based on demo mode
  bool get _shouldUseMockData {
    final shouldUseMock = _authProvider?.shouldUseMockData ?? true;
    if (kDebugMode) {
      debugPrint('🔍 WorkspaceService _shouldUseMockData: $shouldUseMock');
      debugPrint('   - AuthProvider exists: ${_authProvider != null}');
      debugPrint('   - ApiService exists: ${_apiService != null}');
      debugPrint('   - Demo mode: ${_authProvider?.isDemoMode ?? 'null'}');
    }
    return shouldUseMock;
  }

  void _initializeMockData() {
    final now = DateTime.now();
    _workspaces = [
      Workspace(
        id: 'ws-1',
        name: 'Marketing Team',
        description: 'Workspace for marketing team projects and campaigns',
        ownerId: _currentUserId,
        ownerName: _currentUserName,
        ownerEmail: _currentUserEmail,
        currentUserRole: WorkspaceRole.admin,
        userCount: 8,
        createdAt: now.subtract(const Duration(days: 30)),
        updatedAt: now.subtract(const Duration(hours: 2)),
        users: [
          WorkspaceUser(
            id: 'wu-1',
            userId: _currentUserId,
            userName: _currentUserName,
            userEmail: _currentUserEmail,
            role: WorkspaceRole.admin,
            joinedAt: now.subtract(const Duration(days: 30)),
            updatedAt: now.subtract(const Duration(days: 30)),
          ),
          WorkspaceUser(
            id: 'wu-2',
            userId: 'user-456',
            userName: 'Alice Smith',
            userEmail: 'alice.smith@example.com',
            role: WorkspaceRole.user,
            joinedAt: now.subtract(const Duration(days: 20)),
            updatedAt: now.subtract(const Duration(days: 20)),
          ),
          WorkspaceUser(
            id: 'wu-3',
            userId: 'user-789',
            userName: 'Bob Johnson',
            userEmail: 'bob.johnson@example.com',
            role: WorkspaceRole.user,
            joinedAt: now.subtract(const Duration(days: 15)),
            updatedAt: now.subtract(const Duration(days: 15)),
          ),
        ],
      ),
      Workspace(
        id: 'ws-2',
        name: 'Development Team',
        description: 'Software development and engineering workspace',
        ownerId: 'user-456',
        ownerName: 'Alice Smith',
        ownerEmail: 'alice.smith@example.com',
        currentUserRole: WorkspaceRole.user,
        userCount: 12,
        createdAt: now.subtract(const Duration(days: 45)),
        updatedAt: now.subtract(const Duration(minutes: 30)),
        users: [
          WorkspaceUser(
            id: 'wu-4',
            userId: 'user-456',
            userName: 'Alice Smith',
            userEmail: 'alice.smith@example.com',
            role: WorkspaceRole.admin,
            joinedAt: now.subtract(const Duration(days: 45)),
            updatedAt: now.subtract(const Duration(days: 45)),
          ),
          WorkspaceUser(
            id: 'wu-5',
            userId: _currentUserId,
            userName: _currentUserName,
            userEmail: _currentUserEmail,
            role: WorkspaceRole.user,
            joinedAt: now.subtract(const Duration(days: 25)),
            updatedAt: now.subtract(const Duration(days: 25)),
          ),
        ],
      ),
      Workspace(
        id: 'ws-3',
        name: 'Customer Support',
        description: 'Customer service and support workspace',
        ownerId: _currentUserId,
        ownerName: _currentUserName,
        ownerEmail: _currentUserEmail,
        currentUserRole: WorkspaceRole.admin,
        userCount: 5,
        createdAt: now.subtract(const Duration(days: 10)),
        updatedAt: now.subtract(const Duration(days: 1)),
        users: [
          WorkspaceUser(
            id: 'wu-6',
            userId: _currentUserId,
            userName: _currentUserName,
            userEmail: _currentUserEmail,
            role: WorkspaceRole.admin,
            joinedAt: now.subtract(const Duration(days: 10)),
            updatedAt: now.subtract(const Duration(days: 10)),
          ),
        ],
      ),
    ];
  }

  /// Get all workspaces for current user
  Future<void> loadWorkspaces() async {
    _setLoading(true);
    _clearError();

    try {
      // Log configuration information
      if (kDebugMode) {
        print('🔄 Loading workspaces...');
        print('📍 Base URL: ${AppConfig.baseUrl}');
        print('🔧 Environment: ${AppConfig.environment.name}');
        print('📊 Using mock data: $_shouldUseMockData');
      }

      if (_shouldUseMockData) {
        // Simulate network delay for mock data
        await Future.delayed(const Duration(milliseconds: 800));
        // Mock data is already initialized
        if (kDebugMode) {
          print('✅ Using mock workspaces (${_workspaces.length})');
        }
      } else {
        // Use real API service
        if (_apiService != null) {
          if (kDebugMode) {
            print('🌐 Making real API call to get workspaces');
          }
          final apiWorkspaces = await _apiService!.getWorkspaces();
          _workspaces = apiWorkspaces.map(_convertApiWorkspaceToLocal).toList();
          if (kDebugMode) {
            print('✅ Loaded ${_workspaces.length} workspaces from API');
          }
        } else {
          throw Exception('ApiService not available for real data');
        }
      }

      _setLoading(false);
    } catch (e) {
      _setError('Failed to load workspaces: ${e.toString()}');
      _setLoading(false);
    }
  }

  /// Convert API workspace to local workspace model
  Workspace _convertApiWorkspaceToLocal(api.WorkspaceDto apiWorkspace) {
    return Workspace(
      id: apiWorkspace.id ?? 'unknown',
      name: apiWorkspace.name ?? 'Unnamed Workspace',
      description: apiWorkspace.description,
      ownerId: apiWorkspace.ownerId ?? 'unknown',
      ownerName: apiWorkspace.ownerName ?? 'Unknown Owner',
      ownerEmail: apiWorkspace.ownerEmail ?? 'unknown@example.com',
      currentUserRole: _convertApiWorkspaceRoleToLocal(apiWorkspace.currentUserRole),
      userCount: apiWorkspace.users?.length ?? 0,
      createdAt: apiWorkspace.createdAt ?? DateTime.now(),
      updatedAt: apiWorkspace.updatedAt ?? DateTime.now(),
      users: apiWorkspace.users?.map(_convertApiUserToLocal).toList() ?? [],
    );
  }

  /// Convert API workspace user to local user model
  WorkspaceUser _convertApiUserToLocal(api.WorkspaceUserDto apiUser) {
    return WorkspaceUser(
      id: apiUser.id ?? 'unknown',
      userId: apiUser.id ?? 'unknown',
      userName: apiUser.email?.split('@').first ?? 'Unknown User', // Extract name from email
      userEmail: apiUser.email ?? '',
      role: _convertApiUserRoleToLocal(apiUser.role),
      joinedAt: DateTime.now(), // API doesn't provide this
      updatedAt: DateTime.now(),
    );
  }

  /// Convert API workspace role to local role
  WorkspaceRole _convertApiWorkspaceRoleToLocal(enums.WorkspaceDtoCurrentUserRole? apiRole) {
    switch (apiRole) {
      case enums.WorkspaceDtoCurrentUserRole.admin:
        return WorkspaceRole.admin;
      case enums.WorkspaceDtoCurrentUserRole.user:
        return WorkspaceRole.user;
      default:
        return WorkspaceRole.user;
    }
  }

  /// Convert API user role to local role
  WorkspaceRole _convertApiUserRoleToLocal(enums.WorkspaceUserDtoRole? apiRole) {
    switch (apiRole) {
      case enums.WorkspaceUserDtoRole.admin:
        return WorkspaceRole.admin;
      case enums.WorkspaceUserDtoRole.user:
        return WorkspaceRole.user;
      default:
        return WorkspaceRole.user;
    }
  }

  /// Get workspace by ID
  Future<Workspace?> getWorkspace(String workspaceId) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final workspace = _workspaces.firstWhere(
        (ws) => ws.id == workspaceId,
        orElse: () => throw Exception('Workspace not found'),
      );

      _setLoading(false);
      return workspace;
    } catch (e) {
      _setError('Failed to get workspace: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }

  /// Create a new workspace
  Future<Workspace?> createWorkspace(CreateWorkspaceRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1000));

      final now = DateTime.now();
      final workspaceId = 'ws-${Random().nextInt(10000)}';

      final newWorkspace = Workspace(
        id: workspaceId,
        name: request.name,
        description: request.description,
        ownerId: _currentUserId,
        ownerName: _currentUserName,
        ownerEmail: _currentUserEmail,
        currentUserRole: WorkspaceRole.admin,
        userCount: 1,
        createdAt: now,
        updatedAt: now,
        users: [
          WorkspaceUser(
            id: 'wu-${Random().nextInt(10000)}',
            userId: _currentUserId,
            userName: _currentUserName,
            userEmail: _currentUserEmail,
            role: WorkspaceRole.admin,
            joinedAt: now,
            updatedAt: now,
          ),
        ],
      );

      _workspaces.add(newWorkspace);
      notifyListeners();
      _setLoading(false);
      return newWorkspace;
    } catch (e) {
      _setError('Failed to create workspace: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }

  /// Update workspace
  Future<Workspace?> updateWorkspace(String workspaceId, UpdateWorkspaceRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));

      final index = _workspaces.indexWhere((ws) => ws.id == workspaceId);
      if (index == -1) {
        throw Exception('Workspace not found');
      }

      final existingWorkspace = _workspaces[index];
      final updatedWorkspace = existingWorkspace.copyWith(
        name: request.name ?? existingWorkspace.name,
        description: request.description ?? existingWorkspace.description,
        updatedAt: DateTime.now(),
      );

      _workspaces[index] = updatedWorkspace;
      notifyListeners();
      _setLoading(false);
      return updatedWorkspace;
    } catch (e) {
      _setError('Failed to update workspace: ${e.toString()}');
      _setLoading(false);
      return null;
    }
  }

  /// Delete workspace
  Future<bool> deleteWorkspace(String workspaceId) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));

      final index = _workspaces.indexWhere((ws) => ws.id == workspaceId);
      if (index == -1) {
        throw Exception('Workspace not found');
      }

      _workspaces.removeAt(index);
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to delete workspace: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Share workspace with user
  Future<bool> shareWorkspace(String workspaceId, api.ShareWorkspaceRequest request) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1000));

      final index = _workspaces.indexWhere((ws) => ws.id == workspaceId);
      if (index == -1) {
        throw Exception('Workspace not found');
      }

      final workspace = _workspaces[index];
      final now = DateTime.now();

      // Check if user is already in workspace
      final existingUserIndex = workspace.users.indexWhere((user) => user.userEmail == request.email);

      if (existingUserIndex != -1) {
        // Update existing user role
        final existingUser = workspace.users[existingUserIndex];
        final updatedUser = existingUser.copyWith(
          role: _convertApiRoleToLocal(request.role),
          updatedAt: now,
        );
        workspace.users[existingUserIndex] = updatedUser;
      } else {
        // Add new user
        final newUser = WorkspaceUser(
          id: 'wu-${Random().nextInt(10000)}',
          userId: 'user-${Random().nextInt(10000)}',
          userName: request.email.split('@')[0], // Use email prefix as name
          userEmail: request.email,
          role: _convertApiRoleToLocal(request.role),
          joinedAt: now,
          updatedAt: now,
        );
        workspace.users.add(newUser);
      }

      // Update workspace user count
      final updatedWorkspace = workspace.copyWith(
        userCount: workspace.users.length,
        updatedAt: now,
      );

      _workspaces[index] = updatedWorkspace;
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to share workspace: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Remove user from workspace
  Future<bool> removeUserFromWorkspace(String workspaceId, String userId) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));

      final index = _workspaces.indexWhere((ws) => ws.id == workspaceId);
      if (index == -1) {
        throw Exception('Workspace not found');
      }

      final workspace = _workspaces[index];
      workspace.users.removeWhere((user) => user.userId == userId);

      // Update workspace user count
      final updatedWorkspace = workspace.copyWith(
        userCount: workspace.users.length,
        updatedAt: DateTime.now(),
      );

      _workspaces[index] = updatedWorkspace;
      notifyListeners();
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('Failed to remove user from workspace: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  /// Get workspace summary statistics
  WorkspaceSummary getWorkspaceSummary() {
    final totalWorkspaces = _workspaces.length;
    final ownedWorkspaces = _workspaces.where((ws) => ws.ownerId == _currentUserId).length;
    final sharedWorkspaces = totalWorkspaces - ownedWorkspaces;
    final totalUsers = _workspaces.fold<int>(0, (sum, ws) => sum + ws.userCount);

    return WorkspaceSummary(
      totalWorkspaces: totalWorkspaces,
      ownedWorkspaces: ownedWorkspaces,
      sharedWorkspaces: sharedWorkspaces,
      totalUsers: totalUsers,
      recentActivity:
          _workspaces.where((ws) => ws.updatedAt.isAfter(DateTime.now().subtract(const Duration(days: 7)))).length,
    );
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    _isLoading = false;
    if (kDebugMode) {
      print('❌ WorkspaceService Error: $error');
    }
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
  }

  // Helper function to convert API role to local role
  WorkspaceRole _convertApiRoleToLocal(enums.ShareWorkspaceRequestRole apiRole) {
    switch (apiRole) {
      case enums.ShareWorkspaceRequestRole.admin:
        return WorkspaceRole.admin;
      case enums.ShareWorkspaceRequestRole.user:
        return WorkspaceRole.user;
      default:
        return WorkspaceRole.user;
    }
  }
}
