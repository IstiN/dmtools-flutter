// Agent status enum for better type safety
enum AgentStatus {
  active,
  inactive,
  pending,
  error,
  warning,
}

// Extension to convert from string to enum
extension AgentStatusExtension on AgentStatus {
  static AgentStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'online':
        return AgentStatus.active;
      case 'inactive':
      case 'offline':
        return AgentStatus.inactive;
      case 'pending':
      case 'warning':
        return AgentStatus.pending;
      case 'error':
      case 'failed':
        return AgentStatus.error;
      default:
        return AgentStatus.inactive;
    }
  }

  String get displayName {
    switch (this) {
      case AgentStatus.active:
        return 'Active';
      case AgentStatus.inactive:
        return 'Inactive';
      case AgentStatus.pending:
        return 'Pending';
      case AgentStatus.error:
        return 'Error';
      case AgentStatus.warning:
        return 'Warning';
    }
  }
}

class Agent {
  final String id;
  final String name;
  final String description;
  final AgentStatus status;
  final List<String> tags;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime? lastActive;

  const Agent({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.tags,
    required this.createdAt,
    this.avatarUrl,
    this.lastActive,
  });

  // Factory method to create an Agent from JSON
  factory Agent.fromJson(Map<String, dynamic> json) {
    return Agent(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      status: AgentStatusExtension.fromString(json['status'] as String),
      tags: List<String>.from(json['tags']),
      avatarUrl: json['avatarUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastActive: json['lastActive'] != null ? DateTime.parse(json['lastActive'] as String) : null,
    );
  }

  // Convert Agent to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'status': status.name,
      'tags': tags,
      'avatarUrl': avatarUrl,
      'createdAt': createdAt.toIso8601String(),
      'lastActive': lastActive?.toIso8601String(),
    };
  }
}
