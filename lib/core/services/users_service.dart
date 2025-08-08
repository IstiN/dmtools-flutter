import '../../network/services/api_service.dart';
import '../../network/generated/api.models.swagger.dart';
import '../../network/generated/api.enums.swagger.dart' as enums;

/// Admin users response with pagination
class AdminUsersResponse {
  final List<AdminUserDto> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool first;
  final bool last;

  AdminUsersResponse({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.first,
    required this.last,
  });

  factory AdminUsersResponse.fromJson(Map<String, dynamic> json) {
    // Handle both structures: Spring Boot style and actual API style
    if (json.containsKey('users') && json.containsKey('pagination')) {
      // Actual API structure: {users: [...], pagination: {...}}
      final users =
          (json['users'] as List? ?? []).map((user) => AdminUserDto.fromJson(user as Map<String, dynamic>)).toList();

      final pagination = json['pagination'] as Map<String, dynamic>? ?? {};

      return AdminUsersResponse(
        content: users,
        page: pagination['currentPage'] ?? 0,
        size: pagination['size'] ?? 50,
        totalElements: pagination['totalElements'] ?? 0,
        totalPages: pagination['totalPages'] ?? 1,
        first: !(pagination['hasPrevious'] ?? false),
        last: !(pagination['hasNext'] ?? false),
      );
    } else {
      // Spring Boot style: {content: [...], page: 0, ...}
      return AdminUsersResponse(
        content: (json['content'] as List? ?? [])
            .map((user) => AdminUserDto.fromJson(user as Map<String, dynamic>))
            .toList(),
        page: json['page'] ?? 0,
        size: json['size'] ?? 50,
        totalElements: json['totalElements'] ?? 0,
        totalPages: json['totalPages'] ?? 0,
        first: json['first'] ?? true,
        last: json['last'] ?? true,
      );
    }
  }
}

/// Admin user DTO
class AdminUserDto {
  final String id;
  final String email;
  final String? name;
  final String? role;
  final String? createdAt;
  final String? lastLoginAt;

  AdminUserDto({
    required this.id,
    required this.email,
    this.name,
    this.role,
    this.createdAt,
    this.lastLoginAt,
  });

  factory AdminUserDto.fromJson(Map<String, dynamic> json) {
    return AdminUserDto(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'],
      role: json['role'],
      createdAt: json['joinedAt'], // API uses 'joinedAt' instead of 'createdAt'
      lastLoginAt: json['lastLogin'], // API uses 'lastLogin' instead of 'lastLoginAt'
    );
  }

  /// Convert to WorkspaceUserDto for compatibility
  WorkspaceUserDto toWorkspaceUserDto() {
    return WorkspaceUserDto(
      id: id,
      email: email,
      role: _parseRole(role),
    );
  }

  /// Parse role string to enum
  enums.WorkspaceUserDtoRole? _parseRole(String? roleString) {
    switch (roleString?.toUpperCase()) {
      case 'ADMIN':
        return enums.WorkspaceUserDtoRole.admin;
      case 'USER':
      case 'REGULAR_USER': // API uses REGULAR_USER instead of USER
        return enums.WorkspaceUserDtoRole.user;
      default:
        return enums.WorkspaceUserDtoRole.user;
    }
  }
}

/// Service for managing workspace users
class UsersService {
  final ApiService _apiService;

  UsersService(this._apiService);

  /// Get paginated list of all users (Admin only)
  Future<AdminUsersResponse> getAdminUsers({
    int page = 0,
    int size = 50,
    String? search,
  }) async {
    try {
      print('🔧 UsersService: Calling API with page=$page, size=$size, search=$search');
      final response = await _apiService.getAdminUsers(
        page: page,
        size: size,
        search: search,
      );
      print('🔧 UsersService: Raw API response type: ${response.runtimeType}');
      print('🔧 UsersService: Raw API response keys: ${response.keys}');

      final adminResponse = AdminUsersResponse.fromJson(response);
      print('🔧 UsersService: Parsed response - content count: ${adminResponse.content.length}');
      print('🔧 UsersService: Parsed response - totalElements: ${adminResponse.totalElements}');

      return adminResponse;
    } catch (e) {
      print('🔧 UsersService: Error loading admin users: $e');
      throw Exception('Failed to load admin users: $e');
    }
  }

  /// Update user role (Admin only)
  Future<void> updateUserRole({
    required String userId,
    required enums.WorkspaceUserDtoRole role,
  }) async {
    try {
      final roleString = _roleToApiString(role);
      await _apiService.updateUserRole(
        userId: userId,
        role: roleString,
      );
    } catch (e) {
      throw Exception('Failed to update user role: $e');
    }
  }

  /// Convert WorkspaceUserDtoRole to API string
  String _roleToApiString(enums.WorkspaceUserDtoRole role) {
    switch (role) {
      case enums.WorkspaceUserDtoRole.admin:
        return 'ADMIN';
      case enums.WorkspaceUserDtoRole.user:
        return 'REGULAR_USER'; // API expects REGULAR_USER instead of USER
      case enums.WorkspaceUserDtoRole.swaggerGeneratedUnknown:
        return 'REGULAR_USER';
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
