enum WorkspaceRole {
  admin('ADMIN'),
  user('USER');

  const WorkspaceRole(this.value);
  final String value;

  static WorkspaceRole fromString(String value) {
    return WorkspaceRole.values.firstWhere(
      (role) => role.value == value,
      orElse: () => WorkspaceRole.user,
    );
  }
}

class WorkspaceUser {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final String? userPictureUrl;
  final WorkspaceRole role;
  final DateTime joinedAt;
  final DateTime updatedAt;

  const WorkspaceUser({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.role,
    required this.joinedAt,
    required this.updatedAt,
    this.userPictureUrl,
  });

  factory WorkspaceUser.fromJson(Map<String, dynamic> json) {
    return WorkspaceUser(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      userEmail: json['userEmail'] as String,
      userPictureUrl: json['userPictureUrl'] as String?,
      role: WorkspaceRole.fromString(json['role'] as String),
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'userPictureUrl': userPictureUrl,
      'role': role.value,
      'joinedAt': joinedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  WorkspaceUser copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPictureUrl,
    WorkspaceRole? role,
    DateTime? joinedAt,
    DateTime? updatedAt,
  }) {
    return WorkspaceUser(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPictureUrl: userPictureUrl ?? this.userPictureUrl,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class Workspace {
  final String id;
  final String name;
  final String? description;
  final String ownerId;
  final String ownerName;
  final String ownerEmail;
  final WorkspaceRole currentUserRole;
  final int userCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<WorkspaceUser> users;

  const Workspace({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.ownerName,
    required this.ownerEmail,
    required this.currentUserRole,
    required this.userCount,
    required this.createdAt,
    required this.updatedAt,
    required this.users,
    this.description,
  });

  factory Workspace.fromJson(Map<String, dynamic> json) {
    return Workspace(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      ownerId: json['ownerId'] as String,
      ownerName: json['ownerName'] as String,
      ownerEmail: json['ownerEmail'] as String,
      currentUserRole: WorkspaceRole.fromString(json['currentUserRole'] as String),
      userCount: json['userCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      users: (json['users'] as List<dynamic>?)
              ?.map((user) => WorkspaceUser.fromJson(user as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'ownerId': ownerId,
      'ownerName': ownerName,
      'ownerEmail': ownerEmail,
      'currentUserRole': currentUserRole.value,
      'userCount': userCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'users': users.map((user) => user.toJson()).toList(),
    };
  }

  Workspace copyWith({
    String? id,
    String? name,
    String? description,
    String? ownerId,
    String? ownerName,
    String? ownerEmail,
    WorkspaceRole? currentUserRole,
    int? userCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<WorkspaceUser>? users,
  }) {
    return Workspace(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      ownerId: ownerId ?? this.ownerId,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      currentUserRole: currentUserRole ?? this.currentUserRole,
      userCount: userCount ?? this.userCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      users: users ?? this.users,
    );
  }
}

class CreateWorkspaceRequest {
  final String name;
  final String? description;

  const CreateWorkspaceRequest({
    required this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}

class ShareWorkspaceRequest {
  final String userEmail;
  final WorkspaceRole role;

  const ShareWorkspaceRequest({
    required this.userEmail,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'userEmail': userEmail,
      'role': role.value,
    };
  }
}

class UpdateWorkspaceRequest {
  final String? name;
  final String? description;

  const UpdateWorkspaceRequest({
    this.name,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (description != null) 'description': description,
    };
  }
}

class WorkspaceSummary {
  final int totalWorkspaces;
  final int ownedWorkspaces;
  final int sharedWorkspaces;
  final int totalUsers;
  final int recentActivity;

  const WorkspaceSummary({
    required this.totalWorkspaces,
    required this.ownedWorkspaces,
    required this.sharedWorkspaces,
    required this.totalUsers,
    required this.recentActivity,
  });
}
