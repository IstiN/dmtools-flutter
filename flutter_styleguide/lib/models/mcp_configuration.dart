import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';

part 'mcp_configuration.g.dart';

/// Available integration types for MCP
enum McpIntegrationType {
  @JsonValue('jira')
  jira,
  @JsonValue('confluence')
  confluence,
}

extension McpIntegrationTypeExtension on McpIntegrationType {
  String get displayName {
    switch (this) {
      case McpIntegrationType.jira:
        return 'Jira';
      case McpIntegrationType.confluence:
        return 'Confluence';
    }
  }

  String get description {
    switch (this) {
      case McpIntegrationType.jira:
        return 'Access Jira issues, projects, and workflows';
      case McpIntegrationType.confluence:
        return 'Access Confluence pages, spaces, and content';
    }
  }
}

@JsonSerializable(explicitToJson: true)
class McpConfiguration {
  const McpConfiguration({
    required this.name,
    required this.integrationIds,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.token,
    this.endpoint,
  });

  factory McpConfiguration.fromJson(Map<String, dynamic> json) => _$McpConfigurationFromJson(json);

  Map<String, dynamic> toJson() => _$McpConfigurationToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'integrationIds')
  final List<String> integrationIds;

  @JsonKey(name: 'created_at', includeIfNull: false)
  final DateTime? createdAt;

  @JsonKey(name: 'updated_at', includeIfNull: false)
  final DateTime? updatedAt;

  @JsonKey(name: 'token', includeIfNull: false)
  final String? token;

  @JsonKey(name: 'endpoint', includeIfNull: false)
  final String? endpoint;

  /// Generate configuration code for external tools like Cursor
  String generateConfigurationCode() {
    if (token == null || endpoint == null) {
      return 'Configuration not ready - missing token or endpoint';
    }

    final configMap = {
      name: {
        'command': 'npx',
        'args': ['-y', 'mcp-remote', '$endpoint/mcp/id/$token'],
      },
    };

    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(configMap);
  }

  McpConfiguration copyWith({
    String? id,
    String? name,
    List<String>? integrationIds,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? token,
    String? endpoint,
  }) {
    return McpConfiguration(
      id: id ?? this.id,
      name: name ?? this.name,
      integrationIds: integrationIds ?? this.integrationIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      token: token ?? this.token,
      endpoint: endpoint ?? this.endpoint,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is McpConfiguration &&
            other.id == id &&
            other.name == name &&
            const ListEquality().equals(other.integrationIds, integrationIds) &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt &&
            other.token == token &&
            other.endpoint == endpoint);
  }

  @override
  int get hashCode => Object.hash(id, name, integrationIds, createdAt, updatedAt, token, endpoint);

  @override
  String toString() =>
      'McpConfiguration('
      'id: $id, '
      'name: $name, '
      'integrationIds: $integrationIds, '
      'createdAt: $createdAt, '
      'updatedAt: $updatedAt'
      ')';
}
