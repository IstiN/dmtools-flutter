/// MCP Code Format enum
enum McpCodeFormat {
  cursor('Cursor', 'For Cursor IDE integration'),
  json('JSON', 'Standard JSON configuration'),
  shell('Shell', 'Command line usage');

  const McpCodeFormat(this.displayName, this.description);
  final String displayName;
  final String description;
}

/// MCP Configuration model for main app
class McpConfiguration {
  final String? id;
  final String name;
  final List<String> integrationIds; // Integration IDs from API
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const McpConfiguration({
    required this.name,
    required this.integrationIds,
    this.id,
    this.createdAt,
    this.updatedAt,
  });

  /// Create a copy with updated fields
  McpConfiguration copyWith({
    String? id,
    String? name,
    List<String>? integrationIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return McpConfiguration(
      id: id ?? this.id,
      name: name ?? this.name,
      integrationIds: integrationIds ?? this.integrationIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is McpConfiguration &&
        other.id == id &&
        other.name == name &&
        other.integrationIds.length == integrationIds.length;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      integrationIds,
    );
  }

  @override
  String toString() {
    return 'McpConfiguration(id: $id, name: $name, integrationIds: ${integrationIds.length})';
  }
}
