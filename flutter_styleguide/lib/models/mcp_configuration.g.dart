// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mcp_configuration.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

McpConfiguration _$McpConfigurationFromJson(Map<String, dynamic> json) =>
    McpConfiguration(
      name: json['name'] as String,
      integrationIds: (json['integrationIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      id: json['id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      token: json['token'] as String?,
      endpoint: json['endpoint'] as String?,
    );

Map<String, dynamic> _$McpConfigurationToJson(McpConfiguration instance) =>
    <String, dynamic>{
      'id': ?instance.id,
      'name': instance.name,
      'integrationIds': instance.integrationIds,
      'created_at': ?instance.createdAt?.toIso8601String(),
      'updated_at': ?instance.updatedAt?.toIso8601String(),
      'token': ?instance.token,
      'endpoint': ?instance.endpoint,
    };
