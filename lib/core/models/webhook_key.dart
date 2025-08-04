class WebhookKey {
  final String id;
  final String name;
  final String? description;
  final String maskedValue;
  final DateTime createdAt;
  final DateTime? lastUsedAt;
  final DateTime? expiresAt;

  const WebhookKey({
    required this.id,
    required this.name,
    required this.maskedValue,
    required this.createdAt,
    this.description,
    this.lastUsedAt,
    this.expiresAt,
  });

  factory WebhookKey.fromJson(Map<String, dynamic> json) {
    return WebhookKey(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      maskedValue: json['maskedValue'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsedAt: json['lastUsedAt'] != null ? DateTime.parse(json['lastUsedAt'] as String) : null,
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'maskedValue': maskedValue,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

class WebhookKeyCreateRequest {
  final String name;
  final String? description;
  final DateTime? expiresAt;

  const WebhookKeyCreateRequest({
    required this.name,
    this.description,
    this.expiresAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }
}

class WebhookKeyResponse {
  final String id;
  final String name;
  final String? description;
  final String apiKey;
  final DateTime createdAt;
  final DateTime? expiresAt;

  const WebhookKeyResponse({
    required this.id,
    required this.name,
    required this.apiKey,
    required this.createdAt,
    this.description,
    this.expiresAt,
  });

  factory WebhookKeyResponse.fromJson(Map<String, dynamic> json) {
    return WebhookKeyResponse(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      apiKey: json['apiKey'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] != null ? DateTime.parse(json['expiresAt'] as String) : null,
    );
  }
}

enum WebhookIntegrationType {
  jiraAutomation('jira', 'Jira Automation'),
  githubActions('github', 'GitHub Actions'),
  curl('curl', 'cURL Commands'),
  postman('postman', 'Postman Collection');

  const WebhookIntegrationType(this.key, this.displayName);

  final String key;
  final String displayName;
}
