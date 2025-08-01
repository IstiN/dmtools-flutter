// ignore_for_file: type=lint

import 'package:json_annotation/json_annotation.dart';
import 'package:collection/collection.dart';
import 'dart:convert';

import 'openapi.enums.swagger.dart' as enums;

part 'openapi.models.swagger.g.dart';

@JsonSerializable(explicitToJson: true)
class JsonNode {
  const JsonNode();

  factory JsonNode.fromJson(Map<String, dynamic> json) =>
      _$JsonNodeFromJson(json);

  static const toJsonFactory = _$JsonNodeToJson;
  Map<String, dynamic> toJson() => _$JsonNodeToJson(this);

  static const fromJsonFactory = _$JsonNodeFromJson;

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode => runtimeType.hashCode;
}

@JsonSerializable(explicitToJson: true)
class UpdateJobConfigurationRequest {
  const UpdateJobConfigurationRequest({
    this.name,
    this.description,
    this.jobType,
    this.jobParameters,
    this.integrationMappings,
    this.enabled,
  });

  factory UpdateJobConfigurationRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateJobConfigurationRequestFromJson(json);

  static const toJsonFactory = _$UpdateJobConfigurationRequestToJson;
  Map<String, dynamic> toJson() => _$UpdateJobConfigurationRequestToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'jobType', includeIfNull: false)
  final String? jobType;
  @JsonKey(name: 'jobParameters', includeIfNull: false)
  final JsonNode? jobParameters;
  @JsonKey(name: 'integrationMappings', includeIfNull: false)
  final JsonNode? integrationMappings;
  @JsonKey(name: 'enabled', includeIfNull: false)
  final bool? enabled;
  static const fromJsonFactory = _$UpdateJobConfigurationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateJobConfigurationRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.jobType, jobType) ||
                const DeepCollectionEquality().equals(
                  other.jobType,
                  jobType,
                )) &&
            (identical(other.jobParameters, jobParameters) ||
                const DeepCollectionEquality().equals(
                  other.jobParameters,
                  jobParameters,
                )) &&
            (identical(other.integrationMappings, integrationMappings) ||
                const DeepCollectionEquality().equals(
                  other.integrationMappings,
                  integrationMappings,
                )) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(other.enabled, enabled)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(jobType) ^
      const DeepCollectionEquality().hash(jobParameters) ^
      const DeepCollectionEquality().hash(integrationMappings) ^
      const DeepCollectionEquality().hash(enabled) ^
      runtimeType.hashCode;
}

extension $UpdateJobConfigurationRequestExtension
    on UpdateJobConfigurationRequest {
  UpdateJobConfigurationRequest copyWith({
    String? name,
    String? description,
    String? jobType,
    JsonNode? jobParameters,
    JsonNode? integrationMappings,
    bool? enabled,
  }) {
    return UpdateJobConfigurationRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      jobType: jobType ?? this.jobType,
      jobParameters: jobParameters ?? this.jobParameters,
      integrationMappings: integrationMappings ?? this.integrationMappings,
      enabled: enabled ?? this.enabled,
    );
  }

  UpdateJobConfigurationRequest copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<String?>? jobType,
    Wrapped<JsonNode?>? jobParameters,
    Wrapped<JsonNode?>? integrationMappings,
    Wrapped<bool?>? enabled,
  }) {
    return UpdateJobConfigurationRequest(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      jobType: (jobType != null ? jobType.value : this.jobType),
      jobParameters: (jobParameters != null
          ? jobParameters.value
          : this.jobParameters),
      integrationMappings: (integrationMappings != null
          ? integrationMappings.value
          : this.integrationMappings),
      enabled: (enabled != null ? enabled.value : this.enabled),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class JobConfigurationDto {
  const JobConfigurationDto({
    this.id,
    this.name,
    this.description,
    this.jobType,
    this.createdById,
    this.createdByName,
    this.createdByEmail,
    this.jobParameters,
    this.integrationMappings,
    this.enabled,
    this.executionCount,
    this.createdAt,
    this.updatedAt,
    this.lastExecutedAt,
  });

  factory JobConfigurationDto.fromJson(Map<String, dynamic> json) =>
      _$JobConfigurationDtoFromJson(json);

  static const toJsonFactory = _$JobConfigurationDtoToJson;
  Map<String, dynamic> toJson() => _$JobConfigurationDtoToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'jobType', includeIfNull: false)
  final String? jobType;
  @JsonKey(name: 'createdById', includeIfNull: false)
  final String? createdById;
  @JsonKey(name: 'createdByName', includeIfNull: false)
  final String? createdByName;
  @JsonKey(name: 'createdByEmail', includeIfNull: false)
  final String? createdByEmail;
  @JsonKey(name: 'jobParameters', includeIfNull: false)
  final JsonNode? jobParameters;
  @JsonKey(name: 'integrationMappings', includeIfNull: false)
  final JsonNode? integrationMappings;
  @JsonKey(name: 'enabled', includeIfNull: false)
  final bool? enabled;
  @JsonKey(name: 'executionCount', includeIfNull: false)
  final int? executionCount;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  @JsonKey(name: 'lastExecutedAt', includeIfNull: false)
  final DateTime? lastExecutedAt;
  static const fromJsonFactory = _$JobConfigurationDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JobConfigurationDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.jobType, jobType) ||
                const DeepCollectionEquality().equals(
                  other.jobType,
                  jobType,
                )) &&
            (identical(other.createdById, createdById) ||
                const DeepCollectionEquality().equals(
                  other.createdById,
                  createdById,
                )) &&
            (identical(other.createdByName, createdByName) ||
                const DeepCollectionEquality().equals(
                  other.createdByName,
                  createdByName,
                )) &&
            (identical(other.createdByEmail, createdByEmail) ||
                const DeepCollectionEquality().equals(
                  other.createdByEmail,
                  createdByEmail,
                )) &&
            (identical(other.jobParameters, jobParameters) ||
                const DeepCollectionEquality().equals(
                  other.jobParameters,
                  jobParameters,
                )) &&
            (identical(other.integrationMappings, integrationMappings) ||
                const DeepCollectionEquality().equals(
                  other.integrationMappings,
                  integrationMappings,
                )) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(
                  other.enabled,
                  enabled,
                )) &&
            (identical(other.executionCount, executionCount) ||
                const DeepCollectionEquality().equals(
                  other.executionCount,
                  executionCount,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )) &&
            (identical(other.lastExecutedAt, lastExecutedAt) ||
                const DeepCollectionEquality().equals(
                  other.lastExecutedAt,
                  lastExecutedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(jobType) ^
      const DeepCollectionEquality().hash(createdById) ^
      const DeepCollectionEquality().hash(createdByName) ^
      const DeepCollectionEquality().hash(createdByEmail) ^
      const DeepCollectionEquality().hash(jobParameters) ^
      const DeepCollectionEquality().hash(integrationMappings) ^
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(executionCount) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(lastExecutedAt) ^
      runtimeType.hashCode;
}

extension $JobConfigurationDtoExtension on JobConfigurationDto {
  JobConfigurationDto copyWith({
    String? id,
    String? name,
    String? description,
    String? jobType,
    String? createdById,
    String? createdByName,
    String? createdByEmail,
    JsonNode? jobParameters,
    JsonNode? integrationMappings,
    bool? enabled,
    int? executionCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastExecutedAt,
  }) {
    return JobConfigurationDto(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      jobType: jobType ?? this.jobType,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      createdByEmail: createdByEmail ?? this.createdByEmail,
      jobParameters: jobParameters ?? this.jobParameters,
      integrationMappings: integrationMappings ?? this.integrationMappings,
      enabled: enabled ?? this.enabled,
      executionCount: executionCount ?? this.executionCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastExecutedAt: lastExecutedAt ?? this.lastExecutedAt,
    );
  }

  JobConfigurationDto copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<String?>? jobType,
    Wrapped<String?>? createdById,
    Wrapped<String?>? createdByName,
    Wrapped<String?>? createdByEmail,
    Wrapped<JsonNode?>? jobParameters,
    Wrapped<JsonNode?>? integrationMappings,
    Wrapped<bool?>? enabled,
    Wrapped<int?>? executionCount,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
    Wrapped<DateTime?>? lastExecutedAt,
  }) {
    return JobConfigurationDto(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      jobType: (jobType != null ? jobType.value : this.jobType),
      createdById: (createdById != null ? createdById.value : this.createdById),
      createdByName: (createdByName != null
          ? createdByName.value
          : this.createdByName),
      createdByEmail: (createdByEmail != null
          ? createdByEmail.value
          : this.createdByEmail),
      jobParameters: (jobParameters != null
          ? jobParameters.value
          : this.jobParameters),
      integrationMappings: (integrationMappings != null
          ? integrationMappings.value
          : this.integrationMappings),
      enabled: (enabled != null ? enabled.value : this.enabled),
      executionCount: (executionCount != null
          ? executionCount.value
          : this.executionCount),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
      lastExecutedAt: (lastExecutedAt != null
          ? lastExecutedAt.value
          : this.lastExecutedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateMcpConfigurationRequest {
  const CreateMcpConfigurationRequest({
    required this.name,
    required this.integrationIds,
  });

  factory CreateMcpConfigurationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateMcpConfigurationRequestFromJson(json);

  static const toJsonFactory = _$CreateMcpConfigurationRequestToJson;
  Map<String, dynamic> toJson() => _$CreateMcpConfigurationRequestToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String name;
  @JsonKey(
    name: 'integrationIds',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String> integrationIds;
  static const fromJsonFactory = _$CreateMcpConfigurationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateMcpConfigurationRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.integrationIds, integrationIds) ||
                const DeepCollectionEquality().equals(
                  other.integrationIds,
                  integrationIds,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(integrationIds) ^
      runtimeType.hashCode;
}

extension $CreateMcpConfigurationRequestExtension
    on CreateMcpConfigurationRequest {
  CreateMcpConfigurationRequest copyWith({
    String? name,
    List<String>? integrationIds,
  }) {
    return CreateMcpConfigurationRequest(
      name: name ?? this.name,
      integrationIds: integrationIds ?? this.integrationIds,
    );
  }

  CreateMcpConfigurationRequest copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<List<String>>? integrationIds,
  }) {
    return CreateMcpConfigurationRequest(
      name: (name != null ? name.value : this.name),
      integrationIds: (integrationIds != null
          ? integrationIds.value
          : this.integrationIds),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ConfigParam {
  const ConfigParam({this.$value, this.sensitive});

  factory ConfigParam.fromJson(Map<String, dynamic> json) =>
      _$ConfigParamFromJson(json);

  static const toJsonFactory = _$ConfigParamToJson;
  Map<String, dynamic> toJson() => _$ConfigParamToJson(this);

  @JsonKey(name: 'value', includeIfNull: false)
  final String? $value;
  @JsonKey(name: 'sensitive', includeIfNull: false)
  final bool? sensitive;
  static const fromJsonFactory = _$ConfigParamFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ConfigParam &&
            (identical(other.$value, $value) ||
                const DeepCollectionEquality().equals(other.$value, $value)) &&
            (identical(other.sensitive, sensitive) ||
                const DeepCollectionEquality().equals(
                  other.sensitive,
                  sensitive,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash($value) ^
      const DeepCollectionEquality().hash(sensitive) ^
      runtimeType.hashCode;
}

extension $ConfigParamExtension on ConfigParam {
  ConfigParam copyWith({String? $value, bool? sensitive}) {
    return ConfigParam(
      $value: $value ?? this.$value,
      sensitive: sensitive ?? this.sensitive,
    );
  }

  ConfigParam copyWithWrapped({
    Wrapped<String?>? $value,
    Wrapped<bool?>? sensitive,
  }) {
    return ConfigParam(
      $value: ($value != null ? $value.value : this.$value),
      sensitive: (sensitive != null ? sensitive.value : this.sensitive),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class UpdateIntegrationRequest {
  const UpdateIntegrationRequest({
    this.name,
    this.description,
    this.enabled,
    this.configParams,
  });

  factory UpdateIntegrationRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateIntegrationRequestFromJson(json);

  static const toJsonFactory = _$UpdateIntegrationRequestToJson;
  Map<String, dynamic> toJson() => _$UpdateIntegrationRequestToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'enabled', includeIfNull: false)
  final bool? enabled;
  @JsonKey(name: 'configParams', includeIfNull: false)
  final Map<String, dynamic>? configParams;
  static const fromJsonFactory = _$UpdateIntegrationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is UpdateIntegrationRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(
                  other.enabled,
                  enabled,
                )) &&
            (identical(other.configParams, configParams) ||
                const DeepCollectionEquality().equals(
                  other.configParams,
                  configParams,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(configParams) ^
      runtimeType.hashCode;
}

extension $UpdateIntegrationRequestExtension on UpdateIntegrationRequest {
  UpdateIntegrationRequest copyWith({
    String? name,
    String? description,
    bool? enabled,
    Map<String, dynamic>? configParams,
  }) {
    return UpdateIntegrationRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      configParams: configParams ?? this.configParams,
    );
  }

  UpdateIntegrationRequest copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<bool?>? enabled,
    Wrapped<Map<String, dynamic>?>? configParams,
  }) {
    return UpdateIntegrationRequest(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      enabled: (enabled != null ? enabled.value : this.enabled),
      configParams: (configParams != null
          ? configParams.value
          : this.configParams),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class IntegrationConfigDto {
  const IntegrationConfigDto({
    this.id,
    this.paramKey,
    this.paramValue,
    this.sensitive,
  });

  factory IntegrationConfigDto.fromJson(Map<String, dynamic> json) =>
      _$IntegrationConfigDtoFromJson(json);

  static const toJsonFactory = _$IntegrationConfigDtoToJson;
  Map<String, dynamic> toJson() => _$IntegrationConfigDtoToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @JsonKey(name: 'paramKey', includeIfNull: false)
  final String? paramKey;
  @JsonKey(name: 'paramValue', includeIfNull: false)
  final String? paramValue;
  @JsonKey(name: 'sensitive', includeIfNull: false)
  final bool? sensitive;
  static const fromJsonFactory = _$IntegrationConfigDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IntegrationConfigDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.paramKey, paramKey) ||
                const DeepCollectionEquality().equals(
                  other.paramKey,
                  paramKey,
                )) &&
            (identical(other.paramValue, paramValue) ||
                const DeepCollectionEquality().equals(
                  other.paramValue,
                  paramValue,
                )) &&
            (identical(other.sensitive, sensitive) ||
                const DeepCollectionEquality().equals(
                  other.sensitive,
                  sensitive,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(paramKey) ^
      const DeepCollectionEquality().hash(paramValue) ^
      const DeepCollectionEquality().hash(sensitive) ^
      runtimeType.hashCode;
}

extension $IntegrationConfigDtoExtension on IntegrationConfigDto {
  IntegrationConfigDto copyWith({
    String? id,
    String? paramKey,
    String? paramValue,
    bool? sensitive,
  }) {
    return IntegrationConfigDto(
      id: id ?? this.id,
      paramKey: paramKey ?? this.paramKey,
      paramValue: paramValue ?? this.paramValue,
      sensitive: sensitive ?? this.sensitive,
    );
  }

  IntegrationConfigDto copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? paramKey,
    Wrapped<String?>? paramValue,
    Wrapped<bool?>? sensitive,
  }) {
    return IntegrationConfigDto(
      id: (id != null ? id.value : this.id),
      paramKey: (paramKey != null ? paramKey.value : this.paramKey),
      paramValue: (paramValue != null ? paramValue.value : this.paramValue),
      sensitive: (sensitive != null ? sensitive.value : this.sensitive),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class IntegrationDto {
  const IntegrationDto({
    this.id,
    this.name,
    this.description,
    this.type,
    this.enabled,
    this.createdById,
    this.createdByName,
    this.createdByEmail,
    this.usageCount,
    this.categories,
    this.createdAt,
    this.updatedAt,
    this.lastUsedAt,
    this.configParams,
    this.workspaces,
    this.users,
  });

  factory IntegrationDto.fromJson(Map<String, dynamic> json) =>
      _$IntegrationDtoFromJson(json);

  static const toJsonFactory = _$IntegrationDtoToJson;
  Map<String, dynamic> toJson() => _$IntegrationDtoToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'enabled', includeIfNull: false)
  final bool? enabled;
  @JsonKey(name: 'createdById', includeIfNull: false)
  final String? createdById;
  @JsonKey(name: 'createdByName', includeIfNull: false)
  final String? createdByName;
  @JsonKey(name: 'createdByEmail', includeIfNull: false)
  final String? createdByEmail;
  @JsonKey(name: 'usageCount', includeIfNull: false)
  final int? usageCount;
  @JsonKey(name: 'categories', includeIfNull: false, defaultValue: <String>[])
  final List<String>? categories;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  @JsonKey(name: 'lastUsedAt', includeIfNull: false)
  final DateTime? lastUsedAt;
  @JsonKey(
    name: 'configParams',
    includeIfNull: false,
    defaultValue: <IntegrationConfigDto>[],
  )
  final List<IntegrationConfigDto>? configParams;
  @JsonKey(
    name: 'workspaces',
    includeIfNull: false,
    defaultValue: <WorkspaceDto>[],
  )
  final List<WorkspaceDto>? workspaces;
  @JsonKey(
    name: 'users',
    includeIfNull: false,
    defaultValue: <IntegrationUserDto>[],
  )
  final List<IntegrationUserDto>? users;
  static const fromJsonFactory = _$IntegrationDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IntegrationDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(
                  other.enabled,
                  enabled,
                )) &&
            (identical(other.createdById, createdById) ||
                const DeepCollectionEquality().equals(
                  other.createdById,
                  createdById,
                )) &&
            (identical(other.createdByName, createdByName) ||
                const DeepCollectionEquality().equals(
                  other.createdByName,
                  createdByName,
                )) &&
            (identical(other.createdByEmail, createdByEmail) ||
                const DeepCollectionEquality().equals(
                  other.createdByEmail,
                  createdByEmail,
                )) &&
            (identical(other.usageCount, usageCount) ||
                const DeepCollectionEquality().equals(
                  other.usageCount,
                  usageCount,
                )) &&
            (identical(other.categories, categories) ||
                const DeepCollectionEquality().equals(
                  other.categories,
                  categories,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )) &&
            (identical(other.lastUsedAt, lastUsedAt) ||
                const DeepCollectionEquality().equals(
                  other.lastUsedAt,
                  lastUsedAt,
                )) &&
            (identical(other.configParams, configParams) ||
                const DeepCollectionEquality().equals(
                  other.configParams,
                  configParams,
                )) &&
            (identical(other.workspaces, workspaces) ||
                const DeepCollectionEquality().equals(
                  other.workspaces,
                  workspaces,
                )) &&
            (identical(other.users, users) ||
                const DeepCollectionEquality().equals(other.users, users)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(createdById) ^
      const DeepCollectionEquality().hash(createdByName) ^
      const DeepCollectionEquality().hash(createdByEmail) ^
      const DeepCollectionEquality().hash(usageCount) ^
      const DeepCollectionEquality().hash(categories) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      const DeepCollectionEquality().hash(lastUsedAt) ^
      const DeepCollectionEquality().hash(configParams) ^
      const DeepCollectionEquality().hash(workspaces) ^
      const DeepCollectionEquality().hash(users) ^
      runtimeType.hashCode;
}

extension $IntegrationDtoExtension on IntegrationDto {
  IntegrationDto copyWith({
    String? id,
    String? name,
    String? description,
    String? type,
    bool? enabled,
    String? createdById,
    String? createdByName,
    String? createdByEmail,
    int? usageCount,
    List<String>? categories,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? lastUsedAt,
    List<IntegrationConfigDto>? configParams,
    List<WorkspaceDto>? workspaces,
    List<IntegrationUserDto>? users,
  }) {
    return IntegrationDto(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      enabled: enabled ?? this.enabled,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      createdByEmail: createdByEmail ?? this.createdByEmail,
      usageCount: usageCount ?? this.usageCount,
      categories: categories ?? this.categories,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      configParams: configParams ?? this.configParams,
      workspaces: workspaces ?? this.workspaces,
      users: users ?? this.users,
    );
  }

  IntegrationDto copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<String?>? type,
    Wrapped<bool?>? enabled,
    Wrapped<String?>? createdById,
    Wrapped<String?>? createdByName,
    Wrapped<String?>? createdByEmail,
    Wrapped<int?>? usageCount,
    Wrapped<List<String>?>? categories,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
    Wrapped<DateTime?>? lastUsedAt,
    Wrapped<List<IntegrationConfigDto>?>? configParams,
    Wrapped<List<WorkspaceDto>?>? workspaces,
    Wrapped<List<IntegrationUserDto>?>? users,
  }) {
    return IntegrationDto(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      type: (type != null ? type.value : this.type),
      enabled: (enabled != null ? enabled.value : this.enabled),
      createdById: (createdById != null ? createdById.value : this.createdById),
      createdByName: (createdByName != null
          ? createdByName.value
          : this.createdByName),
      createdByEmail: (createdByEmail != null
          ? createdByEmail.value
          : this.createdByEmail),
      usageCount: (usageCount != null ? usageCount.value : this.usageCount),
      categories: (categories != null ? categories.value : this.categories),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
      lastUsedAt: (lastUsedAt != null ? lastUsedAt.value : this.lastUsedAt),
      configParams: (configParams != null
          ? configParams.value
          : this.configParams),
      workspaces: (workspaces != null ? workspaces.value : this.workspaces),
      users: (users != null ? users.value : this.users),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class IntegrationUserDto {
  const IntegrationUserDto({
    this.id,
    this.userId,
    this.userName,
    this.userEmail,
    this.userPictureUrl,
    this.permissionLevel,
    this.addedAt,
  });

  factory IntegrationUserDto.fromJson(Map<String, dynamic> json) =>
      _$IntegrationUserDtoFromJson(json);

  static const toJsonFactory = _$IntegrationUserDtoToJson;
  Map<String, dynamic> toJson() => _$IntegrationUserDtoToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @JsonKey(name: 'userId', includeIfNull: false)
  final String? userId;
  @JsonKey(name: 'userName', includeIfNull: false)
  final String? userName;
  @JsonKey(name: 'userEmail', includeIfNull: false)
  final String? userEmail;
  @JsonKey(name: 'userPictureUrl', includeIfNull: false)
  final String? userPictureUrl;
  @JsonKey(
    name: 'permissionLevel',
    includeIfNull: false,
    toJson: integrationUserDtoPermissionLevelNullableToJson,
    fromJson: integrationUserDtoPermissionLevelNullableFromJson,
  )
  final enums.IntegrationUserDtoPermissionLevel? permissionLevel;
  @JsonKey(name: 'addedAt', includeIfNull: false)
  final DateTime? addedAt;
  static const fromJsonFactory = _$IntegrationUserDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IntegrationUserDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.userName, userName) ||
                const DeepCollectionEquality().equals(
                  other.userName,
                  userName,
                )) &&
            (identical(other.userEmail, userEmail) ||
                const DeepCollectionEquality().equals(
                  other.userEmail,
                  userEmail,
                )) &&
            (identical(other.userPictureUrl, userPictureUrl) ||
                const DeepCollectionEquality().equals(
                  other.userPictureUrl,
                  userPictureUrl,
                )) &&
            (identical(other.permissionLevel, permissionLevel) ||
                const DeepCollectionEquality().equals(
                  other.permissionLevel,
                  permissionLevel,
                )) &&
            (identical(other.addedAt, addedAt) ||
                const DeepCollectionEquality().equals(other.addedAt, addedAt)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(userName) ^
      const DeepCollectionEquality().hash(userEmail) ^
      const DeepCollectionEquality().hash(userPictureUrl) ^
      const DeepCollectionEquality().hash(permissionLevel) ^
      const DeepCollectionEquality().hash(addedAt) ^
      runtimeType.hashCode;
}

extension $IntegrationUserDtoExtension on IntegrationUserDto {
  IntegrationUserDto copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userEmail,
    String? userPictureUrl,
    enums.IntegrationUserDtoPermissionLevel? permissionLevel,
    DateTime? addedAt,
  }) {
    return IntegrationUserDto(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      userPictureUrl: userPictureUrl ?? this.userPictureUrl,
      permissionLevel: permissionLevel ?? this.permissionLevel,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  IntegrationUserDto copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? userId,
    Wrapped<String?>? userName,
    Wrapped<String?>? userEmail,
    Wrapped<String?>? userPictureUrl,
    Wrapped<enums.IntegrationUserDtoPermissionLevel?>? permissionLevel,
    Wrapped<DateTime?>? addedAt,
  }) {
    return IntegrationUserDto(
      id: (id != null ? id.value : this.id),
      userId: (userId != null ? userId.value : this.userId),
      userName: (userName != null ? userName.value : this.userName),
      userEmail: (userEmail != null ? userEmail.value : this.userEmail),
      userPictureUrl: (userPictureUrl != null
          ? userPictureUrl.value
          : this.userPictureUrl),
      permissionLevel: (permissionLevel != null
          ? permissionLevel.value
          : this.permissionLevel),
      addedAt: (addedAt != null ? addedAt.value : this.addedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class WorkspaceDto {
  const WorkspaceDto({
    this.id,
    this.name,
    this.ownerId,
    this.users,
    this.description,
    this.ownerName,
    this.ownerEmail,
    this.currentUserRole,
    this.createdAt,
    this.updatedAt,
  });

  factory WorkspaceDto.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceDtoFromJson(json);

  static const toJsonFactory = _$WorkspaceDtoToJson;
  Map<String, dynamic> toJson() => _$WorkspaceDtoToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'ownerId', includeIfNull: false)
  final String? ownerId;
  @JsonKey(
    name: 'users',
    includeIfNull: false,
    defaultValue: <WorkspaceUserDto>[],
  )
  final List<WorkspaceUserDto>? users;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'ownerName', includeIfNull: false)
  final String? ownerName;
  @JsonKey(name: 'ownerEmail', includeIfNull: false)
  final String? ownerEmail;
  @JsonKey(
    name: 'currentUserRole',
    includeIfNull: false,
    toJson: workspaceDtoCurrentUserRoleNullableToJson,
    fromJson: workspaceDtoCurrentUserRoleNullableFromJson,
  )
  final enums.WorkspaceDtoCurrentUserRole? currentUserRole;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  static const fromJsonFactory = _$WorkspaceDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is WorkspaceDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.ownerId, ownerId) ||
                const DeepCollectionEquality().equals(
                  other.ownerId,
                  ownerId,
                )) &&
            (identical(other.users, users) ||
                const DeepCollectionEquality().equals(other.users, users)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.ownerName, ownerName) ||
                const DeepCollectionEquality().equals(
                  other.ownerName,
                  ownerName,
                )) &&
            (identical(other.ownerEmail, ownerEmail) ||
                const DeepCollectionEquality().equals(
                  other.ownerEmail,
                  ownerEmail,
                )) &&
            (identical(other.currentUserRole, currentUserRole) ||
                const DeepCollectionEquality().equals(
                  other.currentUserRole,
                  currentUserRole,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(ownerId) ^
      const DeepCollectionEquality().hash(users) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(ownerName) ^
      const DeepCollectionEquality().hash(ownerEmail) ^
      const DeepCollectionEquality().hash(currentUserRole) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $WorkspaceDtoExtension on WorkspaceDto {
  WorkspaceDto copyWith({
    String? id,
    String? name,
    String? ownerId,
    List<WorkspaceUserDto>? users,
    String? description,
    String? ownerName,
    String? ownerEmail,
    enums.WorkspaceDtoCurrentUserRole? currentUserRole,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WorkspaceDto(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      users: users ?? this.users,
      description: description ?? this.description,
      ownerName: ownerName ?? this.ownerName,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      currentUserRole: currentUserRole ?? this.currentUserRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  WorkspaceDto copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? ownerId,
    Wrapped<List<WorkspaceUserDto>?>? users,
    Wrapped<String?>? description,
    Wrapped<String?>? ownerName,
    Wrapped<String?>? ownerEmail,
    Wrapped<enums.WorkspaceDtoCurrentUserRole?>? currentUserRole,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
  }) {
    return WorkspaceDto(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      ownerId: (ownerId != null ? ownerId.value : this.ownerId),
      users: (users != null ? users.value : this.users),
      description: (description != null ? description.value : this.description),
      ownerName: (ownerName != null ? ownerName.value : this.ownerName),
      ownerEmail: (ownerEmail != null ? ownerEmail.value : this.ownerEmail),
      currentUserRole: (currentUserRole != null
          ? currentUserRole.value
          : this.currentUserRole),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class WorkspaceUserDto {
  const WorkspaceUserDto({this.id, this.email, this.role});

  factory WorkspaceUserDto.fromJson(Map<String, dynamic> json) =>
      _$WorkspaceUserDtoFromJson(json);

  static const toJsonFactory = _$WorkspaceUserDtoToJson;
  Map<String, dynamic> toJson() => _$WorkspaceUserDtoToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @JsonKey(name: 'email', includeIfNull: false)
  final String? email;
  @JsonKey(
    name: 'role',
    includeIfNull: false,
    toJson: workspaceUserDtoRoleNullableToJson,
    fromJson: workspaceUserDtoRoleNullableFromJson,
  )
  final enums.WorkspaceUserDtoRole? role;
  static const fromJsonFactory = _$WorkspaceUserDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is WorkspaceUserDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(role) ^
      runtimeType.hashCode;
}

extension $WorkspaceUserDtoExtension on WorkspaceUserDto {
  WorkspaceUserDto copyWith({
    String? id,
    String? email,
    enums.WorkspaceUserDtoRole? role,
  }) {
    return WorkspaceUserDto(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  WorkspaceUserDto copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? email,
    Wrapped<enums.WorkspaceUserDtoRole?>? role,
  }) {
    return WorkspaceUserDto(
      id: (id != null ? id.value : this.id),
      email: (email != null ? email.value : this.email),
      role: (role != null ? role.value : this.role),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateWorkspaceRequest {
  const CreateWorkspaceRequest({required this.name, this.description});

  factory CreateWorkspaceRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateWorkspaceRequestFromJson(json);

  static const toJsonFactory = _$CreateWorkspaceRequestToJson;
  Map<String, dynamic> toJson() => _$CreateWorkspaceRequestToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  static const fromJsonFactory = _$CreateWorkspaceRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateWorkspaceRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      runtimeType.hashCode;
}

extension $CreateWorkspaceRequestExtension on CreateWorkspaceRequest {
  CreateWorkspaceRequest copyWith({String? name, String? description}) {
    return CreateWorkspaceRequest(
      name: name ?? this.name,
      description: description ?? this.description,
    );
  }

  CreateWorkspaceRequest copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String?>? description,
  }) {
    return CreateWorkspaceRequest(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ShareWorkspaceRequest {
  const ShareWorkspaceRequest({required this.email, required this.role});

  factory ShareWorkspaceRequest.fromJson(Map<String, dynamic> json) =>
      _$ShareWorkspaceRequestFromJson(json);

  static const toJsonFactory = _$ShareWorkspaceRequestToJson;
  Map<String, dynamic> toJson() => _$ShareWorkspaceRequestToJson(this);

  @JsonKey(name: 'email', includeIfNull: false)
  final String email;
  @JsonKey(
    name: 'role',
    includeIfNull: false,
    toJson: shareWorkspaceRequestRoleToJson,
    fromJson: shareWorkspaceRequestRoleFromJson,
  )
  final enums.ShareWorkspaceRequestRole role;
  static const fromJsonFactory = _$ShareWorkspaceRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShareWorkspaceRequest &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(role) ^
      runtimeType.hashCode;
}

extension $ShareWorkspaceRequestExtension on ShareWorkspaceRequest {
  ShareWorkspaceRequest copyWith({
    String? email,
    enums.ShareWorkspaceRequestRole? role,
  }) {
    return ShareWorkspaceRequest(
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }

  ShareWorkspaceRequest copyWithWrapped({
    Wrapped<String>? email,
    Wrapped<enums.ShareWorkspaceRequestRole>? role,
  }) {
    return ShareWorkspaceRequest(
      email: (email != null ? email.value : this.email),
      role: (role != null ? role.value : this.role),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class JSONObject {
  const JSONObject({this.empty});

  factory JSONObject.fromJson(Map<String, dynamic> json) =>
      _$JSONObjectFromJson(json);

  static const toJsonFactory = _$JSONObjectToJson;
  Map<String, dynamic> toJson() => _$JSONObjectToJson(this);

  @JsonKey(name: 'empty', includeIfNull: false)
  final bool? empty;
  static const fromJsonFactory = _$JSONObjectFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JSONObject &&
            (identical(other.empty, empty) ||
                const DeepCollectionEquality().equals(other.empty, empty)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(empty) ^ runtimeType.hashCode;
}

extension $JSONObjectExtension on JSONObject {
  JSONObject copyWith({bool? empty}) {
    return JSONObject(empty: empty ?? this.empty);
  }

  JSONObject copyWithWrapped({Wrapped<bool?>? empty}) {
    return JSONObject(empty: (empty != null ? empty.value : this.empty));
  }
}

@JsonSerializable(explicitToJson: true)
class JobExecutionRequest {
  const JobExecutionRequest({
    this.jobName,
    this.params,
    this.requiredIntegrations,
  });

  factory JobExecutionRequest.fromJson(Map<String, dynamic> json) =>
      _$JobExecutionRequestFromJson(json);

  static const toJsonFactory = _$JobExecutionRequestToJson;
  Map<String, dynamic> toJson() => _$JobExecutionRequestToJson(this);

  @JsonKey(name: 'jobName', includeIfNull: false)
  final String? jobName;
  @JsonKey(name: 'params', includeIfNull: false)
  final JSONObject? params;
  @JsonKey(
    name: 'requiredIntegrations',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? requiredIntegrations;
  static const fromJsonFactory = _$JobExecutionRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JobExecutionRequest &&
            (identical(other.jobName, jobName) ||
                const DeepCollectionEquality().equals(
                  other.jobName,
                  jobName,
                )) &&
            (identical(other.params, params) ||
                const DeepCollectionEquality().equals(other.params, params)) &&
            (identical(other.requiredIntegrations, requiredIntegrations) ||
                const DeepCollectionEquality().equals(
                  other.requiredIntegrations,
                  requiredIntegrations,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(jobName) ^
      const DeepCollectionEquality().hash(params) ^
      const DeepCollectionEquality().hash(requiredIntegrations) ^
      runtimeType.hashCode;
}

extension $JobExecutionRequestExtension on JobExecutionRequest {
  JobExecutionRequest copyWith({
    String? jobName,
    JSONObject? params,
    List<String>? requiredIntegrations,
  }) {
    return JobExecutionRequest(
      jobName: jobName ?? this.jobName,
      params: params ?? this.params,
      requiredIntegrations: requiredIntegrations ?? this.requiredIntegrations,
    );
  }

  JobExecutionRequest copyWithWrapped({
    Wrapped<String?>? jobName,
    Wrapped<JSONObject?>? params,
    Wrapped<List<String>?>? requiredIntegrations,
  }) {
    return JobExecutionRequest(
      jobName: (jobName != null ? jobName.value : this.jobName),
      params: (params != null ? params.value : this.params),
      requiredIntegrations: (requiredIntegrations != null
          ? requiredIntegrations.value
          : this.requiredIntegrations),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class JobExecutionResponse {
  const JobExecutionResponse({
    this.executionId,
    this.status,
    this.jobName,
    this.jobConfigurationId,
    this.startedAt,
    this.estimatedCompletionAt,
    this.message,
  });

  factory JobExecutionResponse.fromJson(Map<String, dynamic> json) =>
      _$JobExecutionResponseFromJson(json);

  static const toJsonFactory = _$JobExecutionResponseToJson;
  Map<String, dynamic> toJson() => _$JobExecutionResponseToJson(this);

  @JsonKey(name: 'executionId', includeIfNull: false)
  final String? executionId;
  @JsonKey(
    name: 'status',
    includeIfNull: false,
    toJson: jobExecutionResponseStatusNullableToJson,
    fromJson: jobExecutionResponseStatusNullableFromJson,
  )
  final enums.JobExecutionResponseStatus? status;
  @JsonKey(name: 'jobName', includeIfNull: false)
  final String? jobName;
  @JsonKey(name: 'jobConfigurationId', includeIfNull: false)
  final String? jobConfigurationId;
  @JsonKey(name: 'startedAt', includeIfNull: false)
  final DateTime? startedAt;
  @JsonKey(name: 'estimatedCompletionAt', includeIfNull: false)
  final DateTime? estimatedCompletionAt;
  @JsonKey(name: 'message', includeIfNull: false)
  final String? message;
  static const fromJsonFactory = _$JobExecutionResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JobExecutionResponse &&
            (identical(other.executionId, executionId) ||
                const DeepCollectionEquality().equals(
                  other.executionId,
                  executionId,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.jobName, jobName) ||
                const DeepCollectionEquality().equals(
                  other.jobName,
                  jobName,
                )) &&
            (identical(other.jobConfigurationId, jobConfigurationId) ||
                const DeepCollectionEquality().equals(
                  other.jobConfigurationId,
                  jobConfigurationId,
                )) &&
            (identical(other.startedAt, startedAt) ||
                const DeepCollectionEquality().equals(
                  other.startedAt,
                  startedAt,
                )) &&
            (identical(other.estimatedCompletionAt, estimatedCompletionAt) ||
                const DeepCollectionEquality().equals(
                  other.estimatedCompletionAt,
                  estimatedCompletionAt,
                )) &&
            (identical(other.message, message) ||
                const DeepCollectionEquality().equals(other.message, message)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(executionId) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(jobName) ^
      const DeepCollectionEquality().hash(jobConfigurationId) ^
      const DeepCollectionEquality().hash(startedAt) ^
      const DeepCollectionEquality().hash(estimatedCompletionAt) ^
      const DeepCollectionEquality().hash(message) ^
      runtimeType.hashCode;
}

extension $JobExecutionResponseExtension on JobExecutionResponse {
  JobExecutionResponse copyWith({
    String? executionId,
    enums.JobExecutionResponseStatus? status,
    String? jobName,
    String? jobConfigurationId,
    DateTime? startedAt,
    DateTime? estimatedCompletionAt,
    String? message,
  }) {
    return JobExecutionResponse(
      executionId: executionId ?? this.executionId,
      status: status ?? this.status,
      jobName: jobName ?? this.jobName,
      jobConfigurationId: jobConfigurationId ?? this.jobConfigurationId,
      startedAt: startedAt ?? this.startedAt,
      estimatedCompletionAt:
          estimatedCompletionAt ?? this.estimatedCompletionAt,
      message: message ?? this.message,
    );
  }

  JobExecutionResponse copyWithWrapped({
    Wrapped<String?>? executionId,
    Wrapped<enums.JobExecutionResponseStatus?>? status,
    Wrapped<String?>? jobName,
    Wrapped<String?>? jobConfigurationId,
    Wrapped<DateTime?>? startedAt,
    Wrapped<DateTime?>? estimatedCompletionAt,
    Wrapped<String?>? message,
  }) {
    return JobExecutionResponse(
      executionId: (executionId != null ? executionId.value : this.executionId),
      status: (status != null ? status.value : this.status),
      jobName: (jobName != null ? jobName.value : this.jobName),
      jobConfigurationId: (jobConfigurationId != null
          ? jobConfigurationId.value
          : this.jobConfigurationId),
      startedAt: (startedAt != null ? startedAt.value : this.startedAt),
      estimatedCompletionAt: (estimatedCompletionAt != null
          ? estimatedCompletionAt.value
          : this.estimatedCompletionAt),
      message: (message != null ? message.value : this.message),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ExecuteJobConfigurationRequest {
  const ExecuteJobConfigurationRequest({
    this.parameterOverrides,
    this.integrationOverrides,
    this.executionMode,
  });

  factory ExecuteJobConfigurationRequest.fromJson(Map<String, dynamic> json) =>
      _$ExecuteJobConfigurationRequestFromJson(json);

  static const toJsonFactory = _$ExecuteJobConfigurationRequestToJson;
  Map<String, dynamic> toJson() => _$ExecuteJobConfigurationRequestToJson(this);

  @JsonKey(name: 'parameterOverrides', includeIfNull: false)
  final JsonNode? parameterOverrides;
  @JsonKey(name: 'integrationOverrides', includeIfNull: false)
  final JsonNode? integrationOverrides;
  @JsonKey(name: 'executionMode', includeIfNull: false)
  final String? executionMode;
  static const fromJsonFactory = _$ExecuteJobConfigurationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ExecuteJobConfigurationRequest &&
            (identical(other.parameterOverrides, parameterOverrides) ||
                const DeepCollectionEquality().equals(
                  other.parameterOverrides,
                  parameterOverrides,
                )) &&
            (identical(other.integrationOverrides, integrationOverrides) ||
                const DeepCollectionEquality().equals(
                  other.integrationOverrides,
                  integrationOverrides,
                )) &&
            (identical(other.executionMode, executionMode) ||
                const DeepCollectionEquality().equals(
                  other.executionMode,
                  executionMode,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(parameterOverrides) ^
      const DeepCollectionEquality().hash(integrationOverrides) ^
      const DeepCollectionEquality().hash(executionMode) ^
      runtimeType.hashCode;
}

extension $ExecuteJobConfigurationRequestExtension
    on ExecuteJobConfigurationRequest {
  ExecuteJobConfigurationRequest copyWith({
    JsonNode? parameterOverrides,
    JsonNode? integrationOverrides,
    String? executionMode,
  }) {
    return ExecuteJobConfigurationRequest(
      parameterOverrides: parameterOverrides ?? this.parameterOverrides,
      integrationOverrides: integrationOverrides ?? this.integrationOverrides,
      executionMode: executionMode ?? this.executionMode,
    );
  }

  ExecuteJobConfigurationRequest copyWithWrapped({
    Wrapped<JsonNode?>? parameterOverrides,
    Wrapped<JsonNode?>? integrationOverrides,
    Wrapped<String?>? executionMode,
  }) {
    return ExecuteJobConfigurationRequest(
      parameterOverrides: (parameterOverrides != null
          ? parameterOverrides.value
          : this.parameterOverrides),
      integrationOverrides: (integrationOverrides != null
          ? integrationOverrides.value
          : this.integrationOverrides),
      executionMode: (executionMode != null
          ? executionMode.value
          : this.executionMode),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateJobConfigurationRequest {
  const CreateJobConfigurationRequest({
    required this.name,
    this.description,
    required this.jobType,
    required this.jobParameters,
    required this.integrationMappings,
    this.enabled,
  });

  factory CreateJobConfigurationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateJobConfigurationRequestFromJson(json);

  static const toJsonFactory = _$CreateJobConfigurationRequestToJson;
  Map<String, dynamic> toJson() => _$CreateJobConfigurationRequestToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'jobType', includeIfNull: false)
  final String jobType;
  @JsonKey(name: 'jobParameters', includeIfNull: false)
  final JsonNode jobParameters;
  @JsonKey(name: 'integrationMappings', includeIfNull: false)
  final JsonNode integrationMappings;
  @JsonKey(name: 'enabled', includeIfNull: false)
  final bool? enabled;
  static const fromJsonFactory = _$CreateJobConfigurationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateJobConfigurationRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.jobType, jobType) ||
                const DeepCollectionEquality().equals(
                  other.jobType,
                  jobType,
                )) &&
            (identical(other.jobParameters, jobParameters) ||
                const DeepCollectionEquality().equals(
                  other.jobParameters,
                  jobParameters,
                )) &&
            (identical(other.integrationMappings, integrationMappings) ||
                const DeepCollectionEquality().equals(
                  other.integrationMappings,
                  integrationMappings,
                )) &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(other.enabled, enabled)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(jobType) ^
      const DeepCollectionEquality().hash(jobParameters) ^
      const DeepCollectionEquality().hash(integrationMappings) ^
      const DeepCollectionEquality().hash(enabled) ^
      runtimeType.hashCode;
}

extension $CreateJobConfigurationRequestExtension
    on CreateJobConfigurationRequest {
  CreateJobConfigurationRequest copyWith({
    String? name,
    String? description,
    String? jobType,
    JsonNode? jobParameters,
    JsonNode? integrationMappings,
    bool? enabled,
  }) {
    return CreateJobConfigurationRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      jobType: jobType ?? this.jobType,
      jobParameters: jobParameters ?? this.jobParameters,
      integrationMappings: integrationMappings ?? this.integrationMappings,
      enabled: enabled ?? this.enabled,
    );
  }

  CreateJobConfigurationRequest copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String?>? description,
    Wrapped<String>? jobType,
    Wrapped<JsonNode>? jobParameters,
    Wrapped<JsonNode>? integrationMappings,
    Wrapped<bool?>? enabled,
  }) {
    return CreateJobConfigurationRequest(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      jobType: (jobType != null ? jobType.value : this.jobType),
      jobParameters: (jobParameters != null
          ? jobParameters.value
          : this.jobParameters),
      integrationMappings: (integrationMappings != null
          ? integrationMappings.value
          : this.integrationMappings),
      enabled: (enabled != null ? enabled.value : this.enabled),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ExecutionParametersDto {
  const ExecutionParametersDto({
    this.jobType,
    this.jobParameters,
    this.integrationMappings,
    this.executionMode,
  });

  factory ExecutionParametersDto.fromJson(Map<String, dynamic> json) =>
      _$ExecutionParametersDtoFromJson(json);

  static const toJsonFactory = _$ExecutionParametersDtoToJson;
  Map<String, dynamic> toJson() => _$ExecutionParametersDtoToJson(this);

  @JsonKey(name: 'jobType', includeIfNull: false)
  final String? jobType;
  @JsonKey(name: 'jobParameters', includeIfNull: false)
  final JsonNode? jobParameters;
  @JsonKey(name: 'integrationMappings', includeIfNull: false)
  final JsonNode? integrationMappings;
  @JsonKey(name: 'executionMode', includeIfNull: false)
  final String? executionMode;
  static const fromJsonFactory = _$ExecutionParametersDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ExecutionParametersDto &&
            (identical(other.jobType, jobType) ||
                const DeepCollectionEquality().equals(
                  other.jobType,
                  jobType,
                )) &&
            (identical(other.jobParameters, jobParameters) ||
                const DeepCollectionEquality().equals(
                  other.jobParameters,
                  jobParameters,
                )) &&
            (identical(other.integrationMappings, integrationMappings) ||
                const DeepCollectionEquality().equals(
                  other.integrationMappings,
                  integrationMappings,
                )) &&
            (identical(other.executionMode, executionMode) ||
                const DeepCollectionEquality().equals(
                  other.executionMode,
                  executionMode,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(jobType) ^
      const DeepCollectionEquality().hash(jobParameters) ^
      const DeepCollectionEquality().hash(integrationMappings) ^
      const DeepCollectionEquality().hash(executionMode) ^
      runtimeType.hashCode;
}

extension $ExecutionParametersDtoExtension on ExecutionParametersDto {
  ExecutionParametersDto copyWith({
    String? jobType,
    JsonNode? jobParameters,
    JsonNode? integrationMappings,
    String? executionMode,
  }) {
    return ExecutionParametersDto(
      jobType: jobType ?? this.jobType,
      jobParameters: jobParameters ?? this.jobParameters,
      integrationMappings: integrationMappings ?? this.integrationMappings,
      executionMode: executionMode ?? this.executionMode,
    );
  }

  ExecutionParametersDto copyWithWrapped({
    Wrapped<String?>? jobType,
    Wrapped<JsonNode?>? jobParameters,
    Wrapped<JsonNode?>? integrationMappings,
    Wrapped<String?>? executionMode,
  }) {
    return ExecutionParametersDto(
      jobType: (jobType != null ? jobType.value : this.jobType),
      jobParameters: (jobParameters != null
          ? jobParameters.value
          : this.jobParameters),
      integrationMappings: (integrationMappings != null
          ? integrationMappings.value
          : this.integrationMappings),
      executionMode: (executionMode != null
          ? executionMode.value
          : this.executionMode),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AgentExecutionResponse {
  const AgentExecutionResponse({
    this.result,
    this.agentName,
    this.success,
    this.error,
    this.executionType,
  });

  factory AgentExecutionResponse.fromJson(Map<String, dynamic> json) =>
      _$AgentExecutionResponseFromJson(json);

  static const toJsonFactory = _$AgentExecutionResponseToJson;
  Map<String, dynamic> toJson() => _$AgentExecutionResponseToJson(this);

  @JsonKey(name: 'result', includeIfNull: false)
  final Object? result;
  @JsonKey(name: 'agentName', includeIfNull: false)
  final String? agentName;
  @JsonKey(name: 'success', includeIfNull: false)
  final bool? success;
  @JsonKey(name: 'error', includeIfNull: false)
  final String? error;
  @JsonKey(name: 'executionType', includeIfNull: false)
  final String? executionType;
  static const fromJsonFactory = _$AgentExecutionResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AgentExecutionResponse &&
            (identical(other.result, result) ||
                const DeepCollectionEquality().equals(other.result, result)) &&
            (identical(other.agentName, agentName) ||
                const DeepCollectionEquality().equals(
                  other.agentName,
                  agentName,
                )) &&
            (identical(other.success, success) ||
                const DeepCollectionEquality().equals(
                  other.success,
                  success,
                )) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)) &&
            (identical(other.executionType, executionType) ||
                const DeepCollectionEquality().equals(
                  other.executionType,
                  executionType,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(result) ^
      const DeepCollectionEquality().hash(agentName) ^
      const DeepCollectionEquality().hash(success) ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(executionType) ^
      runtimeType.hashCode;
}

extension $AgentExecutionResponseExtension on AgentExecutionResponse {
  AgentExecutionResponse copyWith({
    Object? result,
    String? agentName,
    bool? success,
    String? error,
    String? executionType,
  }) {
    return AgentExecutionResponse(
      result: result ?? this.result,
      agentName: agentName ?? this.agentName,
      success: success ?? this.success,
      error: error ?? this.error,
      executionType: executionType ?? this.executionType,
    );
  }

  AgentExecutionResponse copyWithWrapped({
    Wrapped<Object?>? result,
    Wrapped<String?>? agentName,
    Wrapped<bool?>? success,
    Wrapped<String?>? error,
    Wrapped<String?>? executionType,
  }) {
    return AgentExecutionResponse(
      result: (result != null ? result.value : this.result),
      agentName: (agentName != null ? agentName.value : this.agentName),
      success: (success != null ? success.value : this.success),
      error: (error != null ? error.value : this.error),
      executionType: (executionType != null
          ? executionType.value
          : this.executionType),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ChatResponse {
  const ChatResponse({
    this.content,
    this.model,
    this.success,
    this.error,
    this.source,
    this.agentExecutions,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) =>
      _$ChatResponseFromJson(json);

  static const toJsonFactory = _$ChatResponseToJson;
  Map<String, dynamic> toJson() => _$ChatResponseToJson(this);

  @JsonKey(name: 'content', includeIfNull: false)
  final String? content;
  @JsonKey(name: 'model', includeIfNull: false)
  final String? model;
  @JsonKey(name: 'success', includeIfNull: false)
  final bool? success;
  @JsonKey(name: 'error', includeIfNull: false)
  final String? error;
  @JsonKey(name: 'source', includeIfNull: false)
  final ResponseSource? source;
  @JsonKey(
    name: 'agentExecutions',
    includeIfNull: false,
    defaultValue: <AgentExecutionResponse>[],
  )
  final List<AgentExecutionResponse>? agentExecutions;
  static const fromJsonFactory = _$ChatResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ChatResponse &&
            (identical(other.content, content) ||
                const DeepCollectionEquality().equals(
                  other.content,
                  content,
                )) &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)) &&
            (identical(other.success, success) ||
                const DeepCollectionEquality().equals(
                  other.success,
                  success,
                )) &&
            (identical(other.error, error) ||
                const DeepCollectionEquality().equals(other.error, error)) &&
            (identical(other.source, source) ||
                const DeepCollectionEquality().equals(other.source, source)) &&
            (identical(other.agentExecutions, agentExecutions) ||
                const DeepCollectionEquality().equals(
                  other.agentExecutions,
                  agentExecutions,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(content) ^
      const DeepCollectionEquality().hash(model) ^
      const DeepCollectionEquality().hash(success) ^
      const DeepCollectionEquality().hash(error) ^
      const DeepCollectionEquality().hash(source) ^
      const DeepCollectionEquality().hash(agentExecutions) ^
      runtimeType.hashCode;
}

extension $ChatResponseExtension on ChatResponse {
  ChatResponse copyWith({
    String? content,
    String? model,
    bool? success,
    String? error,
    ResponseSource? source,
    List<AgentExecutionResponse>? agentExecutions,
  }) {
    return ChatResponse(
      content: content ?? this.content,
      model: model ?? this.model,
      success: success ?? this.success,
      error: error ?? this.error,
      source: source ?? this.source,
      agentExecutions: agentExecutions ?? this.agentExecutions,
    );
  }

  ChatResponse copyWithWrapped({
    Wrapped<String?>? content,
    Wrapped<String?>? model,
    Wrapped<bool?>? success,
    Wrapped<String?>? error,
    Wrapped<ResponseSource?>? source,
    Wrapped<List<AgentExecutionResponse>?>? agentExecutions,
  }) {
    return ChatResponse(
      content: (content != null ? content.value : this.content),
      model: (model != null ? model.value : this.model),
      success: (success != null ? success.value : this.success),
      error: (error != null ? error.value : this.error),
      source: (source != null ? source.value : this.source),
      agentExecutions: (agentExecutions != null
          ? agentExecutions.value
          : this.agentExecutions),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ResponseSource {
  const ResponseSource({this.type, this.name});

  factory ResponseSource.fromJson(Map<String, dynamic> json) =>
      _$ResponseSourceFromJson(json);

  static const toJsonFactory = _$ResponseSourceToJson;
  Map<String, dynamic> toJson() => _$ResponseSourceToJson(this);

  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  static const fromJsonFactory = _$ResponseSourceFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ResponseSource &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(name) ^
      runtimeType.hashCode;
}

extension $ResponseSourceExtension on ResponseSource {
  ResponseSource copyWith({String? type, String? name}) {
    return ResponseSource(type: type ?? this.type, name: name ?? this.name);
  }

  ResponseSource copyWithWrapped({
    Wrapped<String?>? type,
    Wrapped<String?>? name,
  }) {
    return ResponseSource(
      type: (type != null ? type.value : this.type),
      name: (name != null ? name.value : this.name),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AgentToolsConfig {
  const AgentToolsConfig({
    this.enabled,
    this.availableAgents,
    this.availableOrchestrators,
  });

  factory AgentToolsConfig.fromJson(Map<String, dynamic> json) =>
      _$AgentToolsConfigFromJson(json);

  static const toJsonFactory = _$AgentToolsConfigToJson;
  Map<String, dynamic> toJson() => _$AgentToolsConfigToJson(this);

  @JsonKey(name: 'enabled', includeIfNull: false)
  final bool? enabled;
  @JsonKey(
    name: 'availableAgents',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? availableAgents;
  @JsonKey(
    name: 'availableOrchestrators',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? availableOrchestrators;
  static const fromJsonFactory = _$AgentToolsConfigFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AgentToolsConfig &&
            (identical(other.enabled, enabled) ||
                const DeepCollectionEquality().equals(
                  other.enabled,
                  enabled,
                )) &&
            (identical(other.availableAgents, availableAgents) ||
                const DeepCollectionEquality().equals(
                  other.availableAgents,
                  availableAgents,
                )) &&
            (identical(other.availableOrchestrators, availableOrchestrators) ||
                const DeepCollectionEquality().equals(
                  other.availableOrchestrators,
                  availableOrchestrators,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(enabled) ^
      const DeepCollectionEquality().hash(availableAgents) ^
      const DeepCollectionEquality().hash(availableOrchestrators) ^
      runtimeType.hashCode;
}

extension $AgentToolsConfigExtension on AgentToolsConfig {
  AgentToolsConfig copyWith({
    bool? enabled,
    List<String>? availableAgents,
    List<String>? availableOrchestrators,
  }) {
    return AgentToolsConfig(
      enabled: enabled ?? this.enabled,
      availableAgents: availableAgents ?? this.availableAgents,
      availableOrchestrators:
          availableOrchestrators ?? this.availableOrchestrators,
    );
  }

  AgentToolsConfig copyWithWrapped({
    Wrapped<bool?>? enabled,
    Wrapped<List<String>?>? availableAgents,
    Wrapped<List<String>?>? availableOrchestrators,
  }) {
    return AgentToolsConfig(
      enabled: (enabled != null ? enabled.value : this.enabled),
      availableAgents: (availableAgents != null
          ? availableAgents.value
          : this.availableAgents),
      availableOrchestrators: (availableOrchestrators != null
          ? availableOrchestrators.value
          : this.availableOrchestrators),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ChatMessage {
  const ChatMessage({this.role, this.content, this.fileNames});

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);

  static const toJsonFactory = _$ChatMessageToJson;
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);

  @JsonKey(name: 'role', includeIfNull: false)
  final String? role;
  @JsonKey(name: 'content', includeIfNull: false)
  final String? content;
  @JsonKey(name: 'fileNames', includeIfNull: false, defaultValue: <String>[])
  final List<String>? fileNames;
  static const fromJsonFactory = _$ChatMessageFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ChatMessage &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)) &&
            (identical(other.content, content) ||
                const DeepCollectionEquality().equals(
                  other.content,
                  content,
                )) &&
            (identical(other.fileNames, fileNames) ||
                const DeepCollectionEquality().equals(
                  other.fileNames,
                  fileNames,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(role) ^
      const DeepCollectionEquality().hash(content) ^
      const DeepCollectionEquality().hash(fileNames) ^
      runtimeType.hashCode;
}

extension $ChatMessageExtension on ChatMessage {
  ChatMessage copyWith({
    String? role,
    String? content,
    List<String>? fileNames,
  }) {
    return ChatMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      fileNames: fileNames ?? this.fileNames,
    );
  }

  ChatMessage copyWithWrapped({
    Wrapped<String?>? role,
    Wrapped<String?>? content,
    Wrapped<List<String>?>? fileNames,
  }) {
    return ChatMessage(
      role: (role != null ? role.value : this.role),
      content: (content != null ? content.value : this.content),
      fileNames: (fileNames != null ? fileNames.value : this.fileNames),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ChatRequest {
  const ChatRequest({this.messages, this.model, this.agentTools});

  factory ChatRequest.fromJson(Map<String, dynamic> json) =>
      _$ChatRequestFromJson(json);

  static const toJsonFactory = _$ChatRequestToJson;
  Map<String, dynamic> toJson() => _$ChatRequestToJson(this);

  @JsonKey(
    name: 'messages',
    includeIfNull: false,
    defaultValue: <ChatMessage>[],
  )
  final List<ChatMessage>? messages;
  @JsonKey(name: 'model', includeIfNull: false)
  final String? model;
  @JsonKey(name: 'agentTools', includeIfNull: false)
  final AgentToolsConfig? agentTools;
  static const fromJsonFactory = _$ChatRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ChatRequest &&
            (identical(other.messages, messages) ||
                const DeepCollectionEquality().equals(
                  other.messages,
                  messages,
                )) &&
            (identical(other.model, model) ||
                const DeepCollectionEquality().equals(other.model, model)) &&
            (identical(other.agentTools, agentTools) ||
                const DeepCollectionEquality().equals(
                  other.agentTools,
                  agentTools,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(messages) ^
      const DeepCollectionEquality().hash(model) ^
      const DeepCollectionEquality().hash(agentTools) ^
      runtimeType.hashCode;
}

extension $ChatRequestExtension on ChatRequest {
  ChatRequest copyWith({
    List<ChatMessage>? messages,
    String? model,
    AgentToolsConfig? agentTools,
  }) {
    return ChatRequest(
      messages: messages ?? this.messages,
      model: model ?? this.model,
      agentTools: agentTools ?? this.agentTools,
    );
  }

  ChatRequest copyWithWrapped({
    Wrapped<List<ChatMessage>?>? messages,
    Wrapped<String?>? model,
    Wrapped<AgentToolsConfig?>? agentTools,
  }) {
    return ChatRequest(
      messages: (messages != null ? messages.value : this.messages),
      model: (model != null ? model.value : this.model),
      agentTools: (agentTools != null ? agentTools.value : this.agentTools),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AgentExecutionRequest {
  const AgentExecutionRequest({this.agentName, this.parameters});

  factory AgentExecutionRequest.fromJson(Map<String, dynamic> json) =>
      _$AgentExecutionRequestFromJson(json);

  static const toJsonFactory = _$AgentExecutionRequestToJson;
  Map<String, dynamic> toJson() => _$AgentExecutionRequestToJson(this);

  @JsonKey(name: 'agentName', includeIfNull: false)
  final String? agentName;
  @JsonKey(name: 'parameters', includeIfNull: false)
  final Map<String, dynamic>? parameters;
  static const fromJsonFactory = _$AgentExecutionRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AgentExecutionRequest &&
            (identical(other.agentName, agentName) ||
                const DeepCollectionEquality().equals(
                  other.agentName,
                  agentName,
                )) &&
            (identical(other.parameters, parameters) ||
                const DeepCollectionEquality().equals(
                  other.parameters,
                  parameters,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(agentName) ^
      const DeepCollectionEquality().hash(parameters) ^
      runtimeType.hashCode;
}

extension $AgentExecutionRequestExtension on AgentExecutionRequest {
  AgentExecutionRequest copyWith({
    String? agentName,
    Map<String, dynamic>? parameters,
  }) {
    return AgentExecutionRequest(
      agentName: agentName ?? this.agentName,
      parameters: parameters ?? this.parameters,
    );
  }

  AgentExecutionRequest copyWithWrapped({
    Wrapped<String?>? agentName,
    Wrapped<Map<String, dynamic>?>? parameters,
  }) {
    return AgentExecutionRequest(
      agentName: (agentName != null ? agentName.value : this.agentName),
      parameters: (parameters != null ? parameters.value : this.parameters),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ScriptGenerationRequest {
  const ScriptGenerationRequest({this.userRequest});

  factory ScriptGenerationRequest.fromJson(Map<String, dynamic> json) =>
      _$ScriptGenerationRequestFromJson(json);

  static const toJsonFactory = _$ScriptGenerationRequestToJson;
  Map<String, dynamic> toJson() => _$ScriptGenerationRequestToJson(this);

  @JsonKey(name: 'userRequest', includeIfNull: false)
  final String? userRequest;
  static const fromJsonFactory = _$ScriptGenerationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ScriptGenerationRequest &&
            (identical(other.userRequest, userRequest) ||
                const DeepCollectionEquality().equals(
                  other.userRequest,
                  userRequest,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userRequest) ^ runtimeType.hashCode;
}

extension $ScriptGenerationRequestExtension on ScriptGenerationRequest {
  ScriptGenerationRequest copyWith({String? userRequest}) {
    return ScriptGenerationRequest(
      userRequest: userRequest ?? this.userRequest,
    );
  }

  ScriptGenerationRequest copyWithWrapped({Wrapped<String?>? userRequest}) {
    return ScriptGenerationRequest(
      userRequest: (userRequest != null ? userRequest.value : this.userRequest),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class GeneratePresentationRequest {
  const GeneratePresentationRequest({this.jsScript, this.paramsForJs});

  factory GeneratePresentationRequest.fromJson(Map<String, dynamic> json) =>
      _$GeneratePresentationRequestFromJson(json);

  static const toJsonFactory = _$GeneratePresentationRequestToJson;
  Map<String, dynamic> toJson() => _$GeneratePresentationRequestToJson(this);

  @JsonKey(name: 'jsScript', includeIfNull: false)
  final String? jsScript;
  @JsonKey(name: 'paramsForJs', includeIfNull: false)
  final JsonNode? paramsForJs;
  static const fromJsonFactory = _$GeneratePresentationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is GeneratePresentationRequest &&
            (identical(other.jsScript, jsScript) ||
                const DeepCollectionEquality().equals(
                  other.jsScript,
                  jsScript,
                )) &&
            (identical(other.paramsForJs, paramsForJs) ||
                const DeepCollectionEquality().equals(
                  other.paramsForJs,
                  paramsForJs,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(jsScript) ^
      const DeepCollectionEquality().hash(paramsForJs) ^
      runtimeType.hashCode;
}

extension $GeneratePresentationRequestExtension on GeneratePresentationRequest {
  GeneratePresentationRequest copyWith({
    String? jsScript,
    JsonNode? paramsForJs,
  }) {
    return GeneratePresentationRequest(
      jsScript: jsScript ?? this.jsScript,
      paramsForJs: paramsForJs ?? this.paramsForJs,
    );
  }

  GeneratePresentationRequest copyWithWrapped({
    Wrapped<String?>? jsScript,
    Wrapped<JsonNode?>? paramsForJs,
  }) {
    return GeneratePresentationRequest(
      jsScript: (jsScript != null ? jsScript.value : this.jsScript),
      paramsForJs: (paramsForJs != null ? paramsForJs.value : this.paramsForJs),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class OAuthInitiateRequest {
  const OAuthInitiateRequest({
    this.provider,
    this.environment,
    this.clientRedirectUri,
    this.clientType,
  });

  factory OAuthInitiateRequest.fromJson(Map<String, dynamic> json) =>
      _$OAuthInitiateRequestFromJson(json);

  static const toJsonFactory = _$OAuthInitiateRequestToJson;
  Map<String, dynamic> toJson() => _$OAuthInitiateRequestToJson(this);

  @JsonKey(name: 'provider', includeIfNull: false)
  final String? provider;
  @JsonKey(name: 'environment', includeIfNull: false)
  final String? environment;
  @JsonKey(name: 'client_redirect_uri', includeIfNull: false)
  final String? clientRedirectUri;
  @JsonKey(name: 'client_type', includeIfNull: false)
  final String? clientType;
  static const fromJsonFactory = _$OAuthInitiateRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OAuthInitiateRequest &&
            (identical(other.provider, provider) ||
                const DeepCollectionEquality().equals(
                  other.provider,
                  provider,
                )) &&
            (identical(other.environment, environment) ||
                const DeepCollectionEquality().equals(
                  other.environment,
                  environment,
                )) &&
            (identical(other.clientRedirectUri, clientRedirectUri) ||
                const DeepCollectionEquality().equals(
                  other.clientRedirectUri,
                  clientRedirectUri,
                )) &&
            (identical(other.clientType, clientType) ||
                const DeepCollectionEquality().equals(
                  other.clientType,
                  clientType,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(provider) ^
      const DeepCollectionEquality().hash(environment) ^
      const DeepCollectionEquality().hash(clientRedirectUri) ^
      const DeepCollectionEquality().hash(clientType) ^
      runtimeType.hashCode;
}

extension $OAuthInitiateRequestExtension on OAuthInitiateRequest {
  OAuthInitiateRequest copyWith({
    String? provider,
    String? environment,
    String? clientRedirectUri,
    String? clientType,
  }) {
    return OAuthInitiateRequest(
      provider: provider ?? this.provider,
      environment: environment ?? this.environment,
      clientRedirectUri: clientRedirectUri ?? this.clientRedirectUri,
      clientType: clientType ?? this.clientType,
    );
  }

  OAuthInitiateRequest copyWithWrapped({
    Wrapped<String?>? provider,
    Wrapped<String?>? environment,
    Wrapped<String?>? clientRedirectUri,
    Wrapped<String?>? clientType,
  }) {
    return OAuthInitiateRequest(
      provider: (provider != null ? provider.value : this.provider),
      environment: (environment != null ? environment.value : this.environment),
      clientRedirectUri: (clientRedirectUri != null
          ? clientRedirectUri.value
          : this.clientRedirectUri),
      clientType: (clientType != null ? clientType.value : this.clientType),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class OAuthExchangeRequest {
  const OAuthExchangeRequest({this.code, this.state});

  factory OAuthExchangeRequest.fromJson(Map<String, dynamic> json) =>
      _$OAuthExchangeRequestFromJson(json);

  static const toJsonFactory = _$OAuthExchangeRequestToJson;
  Map<String, dynamic> toJson() => _$OAuthExchangeRequestToJson(this);

  @JsonKey(name: 'code', includeIfNull: false)
  final String? code;
  @JsonKey(name: 'state', includeIfNull: false)
  final String? state;
  static const fromJsonFactory = _$OAuthExchangeRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is OAuthExchangeRequest &&
            (identical(other.code, code) ||
                const DeepCollectionEquality().equals(other.code, code)) &&
            (identical(other.state, state) ||
                const DeepCollectionEquality().equals(other.state, state)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(code) ^
      const DeepCollectionEquality().hash(state) ^
      runtimeType.hashCode;
}

extension $OAuthExchangeRequestExtension on OAuthExchangeRequest {
  OAuthExchangeRequest copyWith({String? code, String? state}) {
    return OAuthExchangeRequest(
      code: code ?? this.code,
      state: state ?? this.state,
    );
  }

  OAuthExchangeRequest copyWithWrapped({
    Wrapped<String?>? code,
    Wrapped<String?>? state,
  }) {
    return OAuthExchangeRequest(
      code: (code != null ? code.value : this.code),
      state: (state != null ? state.value : this.state),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CreateIntegrationRequest {
  const CreateIntegrationRequest({
    required this.name,
    this.description,
    required this.type,
    this.configParams,
  });

  factory CreateIntegrationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateIntegrationRequestFromJson(json);

  static const toJsonFactory = _$CreateIntegrationRequestToJson;
  Map<String, dynamic> toJson() => _$CreateIntegrationRequestToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'type', includeIfNull: false)
  final String type;
  @JsonKey(name: 'configParams', includeIfNull: false)
  final Map<String, dynamic>? configParams;
  static const fromJsonFactory = _$CreateIntegrationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is CreateIntegrationRequest &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.configParams, configParams) ||
                const DeepCollectionEquality().equals(
                  other.configParams,
                  configParams,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(configParams) ^
      runtimeType.hashCode;
}

extension $CreateIntegrationRequestExtension on CreateIntegrationRequest {
  CreateIntegrationRequest copyWith({
    String? name,
    String? description,
    String? type,
    Map<String, dynamic>? configParams,
  }) {
    return CreateIntegrationRequest(
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      configParams: configParams ?? this.configParams,
    );
  }

  CreateIntegrationRequest copyWithWrapped({
    Wrapped<String>? name,
    Wrapped<String?>? description,
    Wrapped<String>? type,
    Wrapped<Map<String, dynamic>?>? configParams,
  }) {
    return CreateIntegrationRequest(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      type: (type != null ? type.value : this.type),
      configParams: (configParams != null
          ? configParams.value
          : this.configParams),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ShareIntegrationWithWorkspaceRequest {
  const ShareIntegrationWithWorkspaceRequest({required this.workspaceId});

  factory ShareIntegrationWithWorkspaceRequest.fromJson(
    Map<String, dynamic> json,
  ) => _$ShareIntegrationWithWorkspaceRequestFromJson(json);

  static const toJsonFactory = _$ShareIntegrationWithWorkspaceRequestToJson;
  Map<String, dynamic> toJson() =>
      _$ShareIntegrationWithWorkspaceRequestToJson(this);

  @JsonKey(name: 'workspaceId', includeIfNull: false)
  final String workspaceId;
  static const fromJsonFactory = _$ShareIntegrationWithWorkspaceRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShareIntegrationWithWorkspaceRequest &&
            (identical(other.workspaceId, workspaceId) ||
                const DeepCollectionEquality().equals(
                  other.workspaceId,
                  workspaceId,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(workspaceId) ^ runtimeType.hashCode;
}

extension $ShareIntegrationWithWorkspaceRequestExtension
    on ShareIntegrationWithWorkspaceRequest {
  ShareIntegrationWithWorkspaceRequest copyWith({String? workspaceId}) {
    return ShareIntegrationWithWorkspaceRequest(
      workspaceId: workspaceId ?? this.workspaceId,
    );
  }

  ShareIntegrationWithWorkspaceRequest copyWithWrapped({
    Wrapped<String>? workspaceId,
  }) {
    return ShareIntegrationWithWorkspaceRequest(
      workspaceId: (workspaceId != null ? workspaceId.value : this.workspaceId),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ShareIntegrationRequest {
  const ShareIntegrationRequest({
    required this.userEmail,
    required this.permissionLevel,
  });

  factory ShareIntegrationRequest.fromJson(Map<String, dynamic> json) =>
      _$ShareIntegrationRequestFromJson(json);

  static const toJsonFactory = _$ShareIntegrationRequestToJson;
  Map<String, dynamic> toJson() => _$ShareIntegrationRequestToJson(this);

  @JsonKey(name: 'userEmail', includeIfNull: false)
  final String userEmail;
  @JsonKey(
    name: 'permissionLevel',
    includeIfNull: false,
    toJson: shareIntegrationRequestPermissionLevelToJson,
    fromJson: shareIntegrationRequestPermissionLevelFromJson,
  )
  final enums.ShareIntegrationRequestPermissionLevel permissionLevel;
  static const fromJsonFactory = _$ShareIntegrationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ShareIntegrationRequest &&
            (identical(other.userEmail, userEmail) ||
                const DeepCollectionEquality().equals(
                  other.userEmail,
                  userEmail,
                )) &&
            (identical(other.permissionLevel, permissionLevel) ||
                const DeepCollectionEquality().equals(
                  other.permissionLevel,
                  permissionLevel,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(userEmail) ^
      const DeepCollectionEquality().hash(permissionLevel) ^
      runtimeType.hashCode;
}

extension $ShareIntegrationRequestExtension on ShareIntegrationRequest {
  ShareIntegrationRequest copyWith({
    String? userEmail,
    enums.ShareIntegrationRequestPermissionLevel? permissionLevel,
  }) {
    return ShareIntegrationRequest(
      userEmail: userEmail ?? this.userEmail,
      permissionLevel: permissionLevel ?? this.permissionLevel,
    );
  }

  ShareIntegrationRequest copyWithWrapped({
    Wrapped<String>? userEmail,
    Wrapped<enums.ShareIntegrationRequestPermissionLevel>? permissionLevel,
  }) {
    return ShareIntegrationRequest(
      userEmail: (userEmail != null ? userEmail.value : this.userEmail),
      permissionLevel: (permissionLevel != null
          ? permissionLevel.value
          : this.permissionLevel),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class TestIntegrationRequest {
  const TestIntegrationRequest({this.type, this.configParams});

  factory TestIntegrationRequest.fromJson(Map<String, dynamic> json) =>
      _$TestIntegrationRequestFromJson(json);

  static const toJsonFactory = _$TestIntegrationRequestToJson;
  Map<String, dynamic> toJson() => _$TestIntegrationRequestToJson(this);

  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'configParams', includeIfNull: false)
  final Map<String, dynamic>? configParams;
  static const fromJsonFactory = _$TestIntegrationRequestFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is TestIntegrationRequest &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.configParams, configParams) ||
                const DeepCollectionEquality().equals(
                  other.configParams,
                  configParams,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(configParams) ^
      runtimeType.hashCode;
}

extension $TestIntegrationRequestExtension on TestIntegrationRequest {
  TestIntegrationRequest copyWith({
    String? type,
    Map<String, dynamic>? configParams,
  }) {
    return TestIntegrationRequest(
      type: type ?? this.type,
      configParams: configParams ?? this.configParams,
    );
  }

  TestIntegrationRequest copyWithWrapped({
    Wrapped<String?>? type,
    Wrapped<Map<String, dynamic>?>? configParams,
  }) {
    return TestIntegrationRequest(
      type: (type != null ? type.value : this.type),
      configParams: (configParams != null
          ? configParams.value
          : this.configParams),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ConfigParamDefinition {
  const ConfigParamDefinition({
    this.key,
    this.displayName,
    this.description,
    this.instructions,
    this.required,
    this.sensitive,
    this.type,
    this.defaultValue,
    this.options,
    this.examples,
  });

  factory ConfigParamDefinition.fromJson(Map<String, dynamic> json) =>
      _$ConfigParamDefinitionFromJson(json);

  static const toJsonFactory = _$ConfigParamDefinitionToJson;
  Map<String, dynamic> toJson() => _$ConfigParamDefinitionToJson(this);

  @JsonKey(name: 'key', includeIfNull: false)
  final String? key;
  @JsonKey(name: 'displayName', includeIfNull: false)
  final String? displayName;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'instructions', includeIfNull: false)
  final String? instructions;
  @JsonKey(name: 'required', includeIfNull: false)
  final bool? required;
  @JsonKey(name: 'sensitive', includeIfNull: false)
  final bool? sensitive;
  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'defaultValue', includeIfNull: false)
  final String? defaultValue;
  @JsonKey(name: 'options', includeIfNull: false, defaultValue: <String>[])
  final List<String>? options;
  @JsonKey(name: 'examples', includeIfNull: false, defaultValue: <String>[])
  final List<String>? examples;
  static const fromJsonFactory = _$ConfigParamDefinitionFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ConfigParamDefinition &&
            (identical(other.key, key) ||
                const DeepCollectionEquality().equals(other.key, key)) &&
            (identical(other.displayName, displayName) ||
                const DeepCollectionEquality().equals(
                  other.displayName,
                  displayName,
                )) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.instructions, instructions) ||
                const DeepCollectionEquality().equals(
                  other.instructions,
                  instructions,
                )) &&
            (identical(other.required, required) ||
                const DeepCollectionEquality().equals(
                  other.required,
                  required,
                )) &&
            (identical(other.sensitive, sensitive) ||
                const DeepCollectionEquality().equals(
                  other.sensitive,
                  sensitive,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.defaultValue, defaultValue) ||
                const DeepCollectionEquality().equals(
                  other.defaultValue,
                  defaultValue,
                )) &&
            (identical(other.options, options) ||
                const DeepCollectionEquality().equals(
                  other.options,
                  options,
                )) &&
            (identical(other.examples, examples) ||
                const DeepCollectionEquality().equals(
                  other.examples,
                  examples,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(key) ^
      const DeepCollectionEquality().hash(displayName) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(instructions) ^
      const DeepCollectionEquality().hash(required) ^
      const DeepCollectionEquality().hash(sensitive) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(defaultValue) ^
      const DeepCollectionEquality().hash(options) ^
      const DeepCollectionEquality().hash(examples) ^
      runtimeType.hashCode;
}

extension $ConfigParamDefinitionExtension on ConfigParamDefinition {
  ConfigParamDefinition copyWith({
    String? key,
    String? displayName,
    String? description,
    String? instructions,
    bool? required,
    bool? sensitive,
    String? type,
    String? defaultValue,
    List<String>? options,
    List<String>? examples,
  }) {
    return ConfigParamDefinition(
      key: key ?? this.key,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      instructions: instructions ?? this.instructions,
      required: required ?? this.required,
      sensitive: sensitive ?? this.sensitive,
      type: type ?? this.type,
      defaultValue: defaultValue ?? this.defaultValue,
      options: options ?? this.options,
      examples: examples ?? this.examples,
    );
  }

  ConfigParamDefinition copyWithWrapped({
    Wrapped<String?>? key,
    Wrapped<String?>? displayName,
    Wrapped<String?>? description,
    Wrapped<String?>? instructions,
    Wrapped<bool?>? required,
    Wrapped<bool?>? sensitive,
    Wrapped<String?>? type,
    Wrapped<String?>? defaultValue,
    Wrapped<List<String>?>? options,
    Wrapped<List<String>?>? examples,
  }) {
    return ConfigParamDefinition(
      key: (key != null ? key.value : this.key),
      displayName: (displayName != null ? displayName.value : this.displayName),
      description: (description != null ? description.value : this.description),
      instructions: (instructions != null
          ? instructions.value
          : this.instructions),
      required: (required != null ? required.value : this.required),
      sensitive: (sensitive != null ? sensitive.value : this.sensitive),
      type: (type != null ? type.value : this.type),
      defaultValue: (defaultValue != null
          ? defaultValue.value
          : this.defaultValue),
      options: (options != null ? options.value : this.options),
      examples: (examples != null ? examples.value : this.examples),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class JobTypeDto {
  const JobTypeDto({
    this.type,
    this.displayName,
    this.description,
    this.iconUrl,
    this.categories,
    this.setupDocumentationUrl,
    this.executionModes,
    this.requiredIntegrations,
    this.optionalIntegrations,
    this.configParams,
  });

  factory JobTypeDto.fromJson(Map<String, dynamic> json) =>
      _$JobTypeDtoFromJson(json);

  static const toJsonFactory = _$JobTypeDtoToJson;
  Map<String, dynamic> toJson() => _$JobTypeDtoToJson(this);

  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'displayName', includeIfNull: false)
  final String? displayName;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'iconUrl', includeIfNull: false)
  final String? iconUrl;
  @JsonKey(name: 'categories', includeIfNull: false, defaultValue: <String>[])
  final List<String>? categories;
  @JsonKey(name: 'setupDocumentationUrl', includeIfNull: false)
  final String? setupDocumentationUrl;
  @JsonKey(
    name: 'executionModes',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? executionModes;
  @JsonKey(
    name: 'requiredIntegrations',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? requiredIntegrations;
  @JsonKey(
    name: 'optionalIntegrations',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? optionalIntegrations;
  @JsonKey(
    name: 'configParams',
    includeIfNull: false,
    defaultValue: <ConfigParamDefinition>[],
  )
  final List<ConfigParamDefinition>? configParams;
  static const fromJsonFactory = _$JobTypeDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JobTypeDto &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.displayName, displayName) ||
                const DeepCollectionEquality().equals(
                  other.displayName,
                  displayName,
                )) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.iconUrl, iconUrl) ||
                const DeepCollectionEquality().equals(
                  other.iconUrl,
                  iconUrl,
                )) &&
            (identical(other.categories, categories) ||
                const DeepCollectionEquality().equals(
                  other.categories,
                  categories,
                )) &&
            (identical(other.setupDocumentationUrl, setupDocumentationUrl) ||
                const DeepCollectionEquality().equals(
                  other.setupDocumentationUrl,
                  setupDocumentationUrl,
                )) &&
            (identical(other.executionModes, executionModes) ||
                const DeepCollectionEquality().equals(
                  other.executionModes,
                  executionModes,
                )) &&
            (identical(other.requiredIntegrations, requiredIntegrations) ||
                const DeepCollectionEquality().equals(
                  other.requiredIntegrations,
                  requiredIntegrations,
                )) &&
            (identical(other.optionalIntegrations, optionalIntegrations) ||
                const DeepCollectionEquality().equals(
                  other.optionalIntegrations,
                  optionalIntegrations,
                )) &&
            (identical(other.configParams, configParams) ||
                const DeepCollectionEquality().equals(
                  other.configParams,
                  configParams,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(displayName) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(iconUrl) ^
      const DeepCollectionEquality().hash(categories) ^
      const DeepCollectionEquality().hash(setupDocumentationUrl) ^
      const DeepCollectionEquality().hash(executionModes) ^
      const DeepCollectionEquality().hash(requiredIntegrations) ^
      const DeepCollectionEquality().hash(optionalIntegrations) ^
      const DeepCollectionEquality().hash(configParams) ^
      runtimeType.hashCode;
}

extension $JobTypeDtoExtension on JobTypeDto {
  JobTypeDto copyWith({
    String? type,
    String? displayName,
    String? description,
    String? iconUrl,
    List<String>? categories,
    String? setupDocumentationUrl,
    List<String>? executionModes,
    List<String>? requiredIntegrations,
    List<String>? optionalIntegrations,
    List<ConfigParamDefinition>? configParams,
  }) {
    return JobTypeDto(
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      categories: categories ?? this.categories,
      setupDocumentationUrl:
          setupDocumentationUrl ?? this.setupDocumentationUrl,
      executionModes: executionModes ?? this.executionModes,
      requiredIntegrations: requiredIntegrations ?? this.requiredIntegrations,
      optionalIntegrations: optionalIntegrations ?? this.optionalIntegrations,
      configParams: configParams ?? this.configParams,
    );
  }

  JobTypeDto copyWithWrapped({
    Wrapped<String?>? type,
    Wrapped<String?>? displayName,
    Wrapped<String?>? description,
    Wrapped<String?>? iconUrl,
    Wrapped<List<String>?>? categories,
    Wrapped<String?>? setupDocumentationUrl,
    Wrapped<List<String>?>? executionModes,
    Wrapped<List<String>?>? requiredIntegrations,
    Wrapped<List<String>?>? optionalIntegrations,
    Wrapped<List<ConfigParamDefinition>?>? configParams,
  }) {
    return JobTypeDto(
      type: (type != null ? type.value : this.type),
      displayName: (displayName != null ? displayName.value : this.displayName),
      description: (description != null ? description.value : this.description),
      iconUrl: (iconUrl != null ? iconUrl.value : this.iconUrl),
      categories: (categories != null ? categories.value : this.categories),
      setupDocumentationUrl: (setupDocumentationUrl != null
          ? setupDocumentationUrl.value
          : this.setupDocumentationUrl),
      executionModes: (executionModes != null
          ? executionModes.value
          : this.executionModes),
      requiredIntegrations: (requiredIntegrations != null
          ? requiredIntegrations.value
          : this.requiredIntegrations),
      optionalIntegrations: (optionalIntegrations != null
          ? optionalIntegrations.value
          : this.optionalIntegrations),
      configParams: (configParams != null
          ? configParams.value
          : this.configParams),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class JobExecutionStatusResponse {
  const JobExecutionStatusResponse({
    this.executionId,
    this.status,
    this.jobName,
    this.jobConfigurationId,
    this.jobConfigurationName,
    this.startedAt,
    this.completedAt,
    this.threadName,
    this.durationMillis,
    this.resultSummary,
    this.errorMessage,
    this.executionParameters,
    this.active,
    this.completed,
  });

  factory JobExecutionStatusResponse.fromJson(Map<String, dynamic> json) =>
      _$JobExecutionStatusResponseFromJson(json);

  static const toJsonFactory = _$JobExecutionStatusResponseToJson;
  Map<String, dynamic> toJson() => _$JobExecutionStatusResponseToJson(this);

  @JsonKey(name: 'executionId', includeIfNull: false)
  final String? executionId;
  @JsonKey(
    name: 'status',
    includeIfNull: false,
    toJson: jobExecutionStatusResponseStatusNullableToJson,
    fromJson: jobExecutionStatusResponseStatusNullableFromJson,
  )
  final enums.JobExecutionStatusResponseStatus? status;
  @JsonKey(name: 'jobName', includeIfNull: false)
  final String? jobName;
  @JsonKey(name: 'jobConfigurationId', includeIfNull: false)
  final String? jobConfigurationId;
  @JsonKey(name: 'jobConfigurationName', includeIfNull: false)
  final String? jobConfigurationName;
  @JsonKey(name: 'startedAt', includeIfNull: false)
  final DateTime? startedAt;
  @JsonKey(name: 'completedAt', includeIfNull: false)
  final DateTime? completedAt;
  @JsonKey(name: 'threadName', includeIfNull: false)
  final String? threadName;
  @JsonKey(name: 'durationMillis', includeIfNull: false)
  final int? durationMillis;
  @JsonKey(name: 'resultSummary', includeIfNull: false)
  final String? resultSummary;
  @JsonKey(name: 'errorMessage', includeIfNull: false)
  final String? errorMessage;
  @JsonKey(name: 'executionParameters', includeIfNull: false)
  final String? executionParameters;
  @JsonKey(name: 'active', includeIfNull: false)
  final bool? active;
  @JsonKey(name: 'completed', includeIfNull: false)
  final bool? completed;
  static const fromJsonFactory = _$JobExecutionStatusResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is JobExecutionStatusResponse &&
            (identical(other.executionId, executionId) ||
                const DeepCollectionEquality().equals(
                  other.executionId,
                  executionId,
                )) &&
            (identical(other.status, status) ||
                const DeepCollectionEquality().equals(other.status, status)) &&
            (identical(other.jobName, jobName) ||
                const DeepCollectionEquality().equals(
                  other.jobName,
                  jobName,
                )) &&
            (identical(other.jobConfigurationId, jobConfigurationId) ||
                const DeepCollectionEquality().equals(
                  other.jobConfigurationId,
                  jobConfigurationId,
                )) &&
            (identical(other.jobConfigurationName, jobConfigurationName) ||
                const DeepCollectionEquality().equals(
                  other.jobConfigurationName,
                  jobConfigurationName,
                )) &&
            (identical(other.startedAt, startedAt) ||
                const DeepCollectionEquality().equals(
                  other.startedAt,
                  startedAt,
                )) &&
            (identical(other.completedAt, completedAt) ||
                const DeepCollectionEquality().equals(
                  other.completedAt,
                  completedAt,
                )) &&
            (identical(other.threadName, threadName) ||
                const DeepCollectionEquality().equals(
                  other.threadName,
                  threadName,
                )) &&
            (identical(other.durationMillis, durationMillis) ||
                const DeepCollectionEquality().equals(
                  other.durationMillis,
                  durationMillis,
                )) &&
            (identical(other.resultSummary, resultSummary) ||
                const DeepCollectionEquality().equals(
                  other.resultSummary,
                  resultSummary,
                )) &&
            (identical(other.errorMessage, errorMessage) ||
                const DeepCollectionEquality().equals(
                  other.errorMessage,
                  errorMessage,
                )) &&
            (identical(other.executionParameters, executionParameters) ||
                const DeepCollectionEquality().equals(
                  other.executionParameters,
                  executionParameters,
                )) &&
            (identical(other.active, active) ||
                const DeepCollectionEquality().equals(other.active, active)) &&
            (identical(other.completed, completed) ||
                const DeepCollectionEquality().equals(
                  other.completed,
                  completed,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(executionId) ^
      const DeepCollectionEquality().hash(status) ^
      const DeepCollectionEquality().hash(jobName) ^
      const DeepCollectionEquality().hash(jobConfigurationId) ^
      const DeepCollectionEquality().hash(jobConfigurationName) ^
      const DeepCollectionEquality().hash(startedAt) ^
      const DeepCollectionEquality().hash(completedAt) ^
      const DeepCollectionEquality().hash(threadName) ^
      const DeepCollectionEquality().hash(durationMillis) ^
      const DeepCollectionEquality().hash(resultSummary) ^
      const DeepCollectionEquality().hash(errorMessage) ^
      const DeepCollectionEquality().hash(executionParameters) ^
      const DeepCollectionEquality().hash(active) ^
      const DeepCollectionEquality().hash(completed) ^
      runtimeType.hashCode;
}

extension $JobExecutionStatusResponseExtension on JobExecutionStatusResponse {
  JobExecutionStatusResponse copyWith({
    String? executionId,
    enums.JobExecutionStatusResponseStatus? status,
    String? jobName,
    String? jobConfigurationId,
    String? jobConfigurationName,
    DateTime? startedAt,
    DateTime? completedAt,
    String? threadName,
    int? durationMillis,
    String? resultSummary,
    String? errorMessage,
    String? executionParameters,
    bool? active,
    bool? completed,
  }) {
    return JobExecutionStatusResponse(
      executionId: executionId ?? this.executionId,
      status: status ?? this.status,
      jobName: jobName ?? this.jobName,
      jobConfigurationId: jobConfigurationId ?? this.jobConfigurationId,
      jobConfigurationName: jobConfigurationName ?? this.jobConfigurationName,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      threadName: threadName ?? this.threadName,
      durationMillis: durationMillis ?? this.durationMillis,
      resultSummary: resultSummary ?? this.resultSummary,
      errorMessage: errorMessage ?? this.errorMessage,
      executionParameters: executionParameters ?? this.executionParameters,
      active: active ?? this.active,
      completed: completed ?? this.completed,
    );
  }

  JobExecutionStatusResponse copyWithWrapped({
    Wrapped<String?>? executionId,
    Wrapped<enums.JobExecutionStatusResponseStatus?>? status,
    Wrapped<String?>? jobName,
    Wrapped<String?>? jobConfigurationId,
    Wrapped<String?>? jobConfigurationName,
    Wrapped<DateTime?>? startedAt,
    Wrapped<DateTime?>? completedAt,
    Wrapped<String?>? threadName,
    Wrapped<int?>? durationMillis,
    Wrapped<String?>? resultSummary,
    Wrapped<String?>? errorMessage,
    Wrapped<String?>? executionParameters,
    Wrapped<bool?>? active,
    Wrapped<bool?>? completed,
  }) {
    return JobExecutionStatusResponse(
      executionId: (executionId != null ? executionId.value : this.executionId),
      status: (status != null ? status.value : this.status),
      jobName: (jobName != null ? jobName.value : this.jobName),
      jobConfigurationId: (jobConfigurationId != null
          ? jobConfigurationId.value
          : this.jobConfigurationId),
      jobConfigurationName: (jobConfigurationName != null
          ? jobConfigurationName.value
          : this.jobConfigurationName),
      startedAt: (startedAt != null ? startedAt.value : this.startedAt),
      completedAt: (completedAt != null ? completedAt.value : this.completedAt),
      threadName: (threadName != null ? threadName.value : this.threadName),
      durationMillis: (durationMillis != null
          ? durationMillis.value
          : this.durationMillis),
      resultSummary: (resultSummary != null
          ? resultSummary.value
          : this.resultSummary),
      errorMessage: (errorMessage != null
          ? errorMessage.value
          : this.errorMessage),
      executionParameters: (executionParameters != null
          ? executionParameters.value
          : this.executionParameters),
      active: (active != null ? active.value : this.active),
      completed: (completed != null ? completed.value : this.completed),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AgentInfo {
  const AgentInfo({
    this.name,
    this.description,
    this.category,
    this.type,
    this.parameters,
    this.returnInfo,
  });

  factory AgentInfo.fromJson(Map<String, dynamic> json) =>
      _$AgentInfoFromJson(json);

  static const toJsonFactory = _$AgentInfoToJson;
  Map<String, dynamic> toJson() => _$AgentInfoToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'category', includeIfNull: false)
  final String? category;
  @JsonKey(
    name: 'type',
    includeIfNull: false,
    toJson: agentInfoTypeNullableToJson,
    fromJson: agentInfoTypeNullableFromJson,
  )
  final enums.AgentInfoType? type;
  @JsonKey(
    name: 'parameters',
    includeIfNull: false,
    defaultValue: <ParameterInfo>[],
  )
  final List<ParameterInfo>? parameters;
  @JsonKey(name: 'returnInfo', includeIfNull: false)
  final ReturnInfo? returnInfo;
  static const fromJsonFactory = _$AgentInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AgentInfo &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.category, category) ||
                const DeepCollectionEquality().equals(
                  other.category,
                  category,
                )) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.parameters, parameters) ||
                const DeepCollectionEquality().equals(
                  other.parameters,
                  parameters,
                )) &&
            (identical(other.returnInfo, returnInfo) ||
                const DeepCollectionEquality().equals(
                  other.returnInfo,
                  returnInfo,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(category) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(parameters) ^
      const DeepCollectionEquality().hash(returnInfo) ^
      runtimeType.hashCode;
}

extension $AgentInfoExtension on AgentInfo {
  AgentInfo copyWith({
    String? name,
    String? description,
    String? category,
    enums.AgentInfoType? type,
    List<ParameterInfo>? parameters,
    ReturnInfo? returnInfo,
  }) {
    return AgentInfo(
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      type: type ?? this.type,
      parameters: parameters ?? this.parameters,
      returnInfo: returnInfo ?? this.returnInfo,
    );
  }

  AgentInfo copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? description,
    Wrapped<String?>? category,
    Wrapped<enums.AgentInfoType?>? type,
    Wrapped<List<ParameterInfo>?>? parameters,
    Wrapped<ReturnInfo?>? returnInfo,
  }) {
    return AgentInfo(
      name: (name != null ? name.value : this.name),
      description: (description != null ? description.value : this.description),
      category: (category != null ? category.value : this.category),
      type: (type != null ? type.value : this.type),
      parameters: (parameters != null ? parameters.value : this.parameters),
      returnInfo: (returnInfo != null ? returnInfo.value : this.returnInfo),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ParameterInfo {
  const ParameterInfo({
    this.name,
    this.type,
    this.description,
    this.required,
    this.defaultValue,
    this.allowedValues,
    this.example,
  });

  factory ParameterInfo.fromJson(Map<String, dynamic> json) =>
      _$ParameterInfoFromJson(json);

  static const toJsonFactory = _$ParameterInfoToJson;
  Map<String, dynamic> toJson() => _$ParameterInfoToJson(this);

  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'required', includeIfNull: false)
  final bool? required;
  @JsonKey(name: 'defaultValue', includeIfNull: false)
  final Object? defaultValue;
  @JsonKey(
    name: 'allowedValues',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? allowedValues;
  @JsonKey(name: 'example', includeIfNull: false)
  final String? example;
  static const fromJsonFactory = _$ParameterInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ParameterInfo &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.required, required) ||
                const DeepCollectionEquality().equals(
                  other.required,
                  required,
                )) &&
            (identical(other.defaultValue, defaultValue) ||
                const DeepCollectionEquality().equals(
                  other.defaultValue,
                  defaultValue,
                )) &&
            (identical(other.allowedValues, allowedValues) ||
                const DeepCollectionEquality().equals(
                  other.allowedValues,
                  allowedValues,
                )) &&
            (identical(other.example, example) ||
                const DeepCollectionEquality().equals(other.example, example)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(required) ^
      const DeepCollectionEquality().hash(defaultValue) ^
      const DeepCollectionEquality().hash(allowedValues) ^
      const DeepCollectionEquality().hash(example) ^
      runtimeType.hashCode;
}

extension $ParameterInfoExtension on ParameterInfo {
  ParameterInfo copyWith({
    String? name,
    String? type,
    String? description,
    bool? required,
    Object? defaultValue,
    List<String>? allowedValues,
    String? example,
  }) {
    return ParameterInfo(
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      required: required ?? this.required,
      defaultValue: defaultValue ?? this.defaultValue,
      allowedValues: allowedValues ?? this.allowedValues,
      example: example ?? this.example,
    );
  }

  ParameterInfo copyWithWrapped({
    Wrapped<String?>? name,
    Wrapped<String?>? type,
    Wrapped<String?>? description,
    Wrapped<bool?>? required,
    Wrapped<Object?>? defaultValue,
    Wrapped<List<String>?>? allowedValues,
    Wrapped<String?>? example,
  }) {
    return ParameterInfo(
      name: (name != null ? name.value : this.name),
      type: (type != null ? type.value : this.type),
      description: (description != null ? description.value : this.description),
      required: (required != null ? required.value : this.required),
      defaultValue: (defaultValue != null
          ? defaultValue.value
          : this.defaultValue),
      allowedValues: (allowedValues != null
          ? allowedValues.value
          : this.allowedValues),
      example: (example != null ? example.value : this.example),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ReturnInfo {
  const ReturnInfo({this.type, this.description, this.schema, this.example});

  factory ReturnInfo.fromJson(Map<String, dynamic> json) =>
      _$ReturnInfoFromJson(json);

  static const toJsonFactory = _$ReturnInfoToJson;
  Map<String, dynamic> toJson() => _$ReturnInfoToJson(this);

  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'schema', includeIfNull: false)
  final Map<String, dynamic>? schema;
  @JsonKey(name: 'example', includeIfNull: false)
  final String? example;
  static const fromJsonFactory = _$ReturnInfoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ReturnInfo &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.schema, schema) ||
                const DeepCollectionEquality().equals(other.schema, schema)) &&
            (identical(other.example, example) ||
                const DeepCollectionEquality().equals(other.example, example)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(schema) ^
      const DeepCollectionEquality().hash(example) ^
      runtimeType.hashCode;
}

extension $ReturnInfoExtension on ReturnInfo {
  ReturnInfo copyWith({
    String? type,
    String? description,
    Map<String, dynamic>? schema,
    String? example,
  }) {
    return ReturnInfo(
      type: type ?? this.type,
      description: description ?? this.description,
      schema: schema ?? this.schema,
      example: example ?? this.example,
    );
  }

  ReturnInfo copyWithWrapped({
    Wrapped<String?>? type,
    Wrapped<String?>? description,
    Wrapped<Map<String, dynamic>?>? schema,
    Wrapped<String?>? example,
  }) {
    return ReturnInfo(
      type: (type != null ? type.value : this.type),
      description: (description != null ? description.value : this.description),
      schema: (schema != null ? schema.value : this.schema),
      example: (example != null ? example.value : this.example),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class AgentListResponse {
  const AgentListResponse({
    this.agents,
    this.orchestrators,
    this.detailedAgents,
    this.detailedOrchestrators,
    this.detailed,
  });

  factory AgentListResponse.fromJson(Map<String, dynamic> json) =>
      _$AgentListResponseFromJson(json);

  static const toJsonFactory = _$AgentListResponseToJson;
  Map<String, dynamic> toJson() => _$AgentListResponseToJson(this);

  @JsonKey(name: 'agents', includeIfNull: false, defaultValue: <String>[])
  final List<String>? agents;
  @JsonKey(
    name: 'orchestrators',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? orchestrators;
  @JsonKey(
    name: 'detailedAgents',
    includeIfNull: false,
    defaultValue: <AgentInfo>[],
  )
  final List<AgentInfo>? detailedAgents;
  @JsonKey(
    name: 'detailedOrchestrators',
    includeIfNull: false,
    defaultValue: <AgentInfo>[],
  )
  final List<AgentInfo>? detailedOrchestrators;
  @JsonKey(name: 'detailed', includeIfNull: false)
  final bool? detailed;
  static const fromJsonFactory = _$AgentListResponseFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is AgentListResponse &&
            (identical(other.agents, agents) ||
                const DeepCollectionEquality().equals(other.agents, agents)) &&
            (identical(other.orchestrators, orchestrators) ||
                const DeepCollectionEquality().equals(
                  other.orchestrators,
                  orchestrators,
                )) &&
            (identical(other.detailedAgents, detailedAgents) ||
                const DeepCollectionEquality().equals(
                  other.detailedAgents,
                  detailedAgents,
                )) &&
            (identical(other.detailedOrchestrators, detailedOrchestrators) ||
                const DeepCollectionEquality().equals(
                  other.detailedOrchestrators,
                  detailedOrchestrators,
                )) &&
            (identical(other.detailed, detailed) ||
                const DeepCollectionEquality().equals(
                  other.detailed,
                  detailed,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(agents) ^
      const DeepCollectionEquality().hash(orchestrators) ^
      const DeepCollectionEquality().hash(detailedAgents) ^
      const DeepCollectionEquality().hash(detailedOrchestrators) ^
      const DeepCollectionEquality().hash(detailed) ^
      runtimeType.hashCode;
}

extension $AgentListResponseExtension on AgentListResponse {
  AgentListResponse copyWith({
    List<String>? agents,
    List<String>? orchestrators,
    List<AgentInfo>? detailedAgents,
    List<AgentInfo>? detailedOrchestrators,
    bool? detailed,
  }) {
    return AgentListResponse(
      agents: agents ?? this.agents,
      orchestrators: orchestrators ?? this.orchestrators,
      detailedAgents: detailedAgents ?? this.detailedAgents,
      detailedOrchestrators:
          detailedOrchestrators ?? this.detailedOrchestrators,
      detailed: detailed ?? this.detailed,
    );
  }

  AgentListResponse copyWithWrapped({
    Wrapped<List<String>?>? agents,
    Wrapped<List<String>?>? orchestrators,
    Wrapped<List<AgentInfo>?>? detailedAgents,
    Wrapped<List<AgentInfo>?>? detailedOrchestrators,
    Wrapped<bool?>? detailed,
  }) {
    return AgentListResponse(
      agents: (agents != null ? agents.value : this.agents),
      orchestrators: (orchestrators != null
          ? orchestrators.value
          : this.orchestrators),
      detailedAgents: (detailedAgents != null
          ? detailedAgents.value
          : this.detailedAgents),
      detailedOrchestrators: (detailedOrchestrators != null
          ? detailedOrchestrators.value
          : this.detailedOrchestrators),
      detailed: (detailed != null ? detailed.value : this.detailed),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class McpConfigurationDto {
  const McpConfigurationDto({
    this.id,
    this.name,
    this.userId,
    this.integrationIds,
    this.createdAt,
    this.updatedAt,
  });

  factory McpConfigurationDto.fromJson(Map<String, dynamic> json) =>
      _$McpConfigurationDtoFromJson(json);

  static const toJsonFactory = _$McpConfigurationDtoToJson;
  Map<String, dynamic> toJson() => _$McpConfigurationDtoToJson(this);

  @JsonKey(name: 'id', includeIfNull: false)
  final String? id;
  @JsonKey(name: 'name', includeIfNull: false)
  final String? name;
  @JsonKey(name: 'userId', includeIfNull: false)
  final String? userId;
  @JsonKey(
    name: 'integrationIds',
    includeIfNull: false,
    defaultValue: <String>[],
  )
  final List<String>? integrationIds;
  @JsonKey(name: 'createdAt', includeIfNull: false)
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt', includeIfNull: false)
  final DateTime? updatedAt;
  static const fromJsonFactory = _$McpConfigurationDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is McpConfigurationDto &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.userId, userId) ||
                const DeepCollectionEquality().equals(other.userId, userId)) &&
            (identical(other.integrationIds, integrationIds) ||
                const DeepCollectionEquality().equals(
                  other.integrationIds,
                  integrationIds,
                )) &&
            (identical(other.createdAt, createdAt) ||
                const DeepCollectionEquality().equals(
                  other.createdAt,
                  createdAt,
                )) &&
            (identical(other.updatedAt, updatedAt) ||
                const DeepCollectionEquality().equals(
                  other.updatedAt,
                  updatedAt,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(userId) ^
      const DeepCollectionEquality().hash(integrationIds) ^
      const DeepCollectionEquality().hash(createdAt) ^
      const DeepCollectionEquality().hash(updatedAt) ^
      runtimeType.hashCode;
}

extension $McpConfigurationDtoExtension on McpConfigurationDto {
  McpConfigurationDto copyWith({
    String? id,
    String? name,
    String? userId,
    List<String>? integrationIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return McpConfigurationDto(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId,
      integrationIds: integrationIds ?? this.integrationIds,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  McpConfigurationDto copyWithWrapped({
    Wrapped<String?>? id,
    Wrapped<String?>? name,
    Wrapped<String?>? userId,
    Wrapped<List<String>?>? integrationIds,
    Wrapped<DateTime?>? createdAt,
    Wrapped<DateTime?>? updatedAt,
  }) {
    return McpConfigurationDto(
      id: (id != null ? id.value : this.id),
      name: (name != null ? name.value : this.name),
      userId: (userId != null ? userId.value : this.userId),
      integrationIds: (integrationIds != null
          ? integrationIds.value
          : this.integrationIds),
      createdAt: (createdAt != null ? createdAt.value : this.createdAt),
      updatedAt: (updatedAt != null ? updatedAt.value : this.updatedAt),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class IntegrationTypeDto {
  const IntegrationTypeDto({
    this.type,
    this.displayName,
    this.description,
    this.iconUrl,
    this.categories,
    this.setupDocumentationUrl,
    this.configParams,
    this.supportsMcp,
  });

  factory IntegrationTypeDto.fromJson(Map<String, dynamic> json) =>
      _$IntegrationTypeDtoFromJson(json);

  static const toJsonFactory = _$IntegrationTypeDtoToJson;
  Map<String, dynamic> toJson() => _$IntegrationTypeDtoToJson(this);

  @JsonKey(name: 'type', includeIfNull: false)
  final String? type;
  @JsonKey(name: 'displayName', includeIfNull: false)
  final String? displayName;
  @JsonKey(name: 'description', includeIfNull: false)
  final String? description;
  @JsonKey(name: 'iconUrl', includeIfNull: false)
  final String? iconUrl;
  @JsonKey(name: 'categories', includeIfNull: false, defaultValue: <String>[])
  final List<String>? categories;
  @JsonKey(name: 'setupDocumentationUrl', includeIfNull: false)
  final String? setupDocumentationUrl;
  @JsonKey(
    name: 'configParams',
    includeIfNull: false,
    defaultValue: <ConfigParamDefinition>[],
  )
  final List<ConfigParamDefinition>? configParams;
  @JsonKey(name: 'supportsMcp', includeIfNull: false)
  final bool? supportsMcp;
  static const fromJsonFactory = _$IntegrationTypeDtoFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is IntegrationTypeDto &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.displayName, displayName) ||
                const DeepCollectionEquality().equals(
                  other.displayName,
                  displayName,
                )) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality().equals(
                  other.description,
                  description,
                )) &&
            (identical(other.iconUrl, iconUrl) ||
                const DeepCollectionEquality().equals(
                  other.iconUrl,
                  iconUrl,
                )) &&
            (identical(other.categories, categories) ||
                const DeepCollectionEquality().equals(
                  other.categories,
                  categories,
                )) &&
            (identical(other.setupDocumentationUrl, setupDocumentationUrl) ||
                const DeepCollectionEquality().equals(
                  other.setupDocumentationUrl,
                  setupDocumentationUrl,
                )) &&
            (identical(other.configParams, configParams) ||
                const DeepCollectionEquality().equals(
                  other.configParams,
                  configParams,
                )) &&
            (identical(other.supportsMcp, supportsMcp) ||
                const DeepCollectionEquality().equals(
                  other.supportsMcp,
                  supportsMcp,
                )));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(displayName) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(iconUrl) ^
      const DeepCollectionEquality().hash(categories) ^
      const DeepCollectionEquality().hash(setupDocumentationUrl) ^
      const DeepCollectionEquality().hash(configParams) ^
      const DeepCollectionEquality().hash(supportsMcp) ^
      runtimeType.hashCode;
}

extension $IntegrationTypeDtoExtension on IntegrationTypeDto {
  IntegrationTypeDto copyWith({
    String? type,
    String? displayName,
    String? description,
    String? iconUrl,
    List<String>? categories,
    String? setupDocumentationUrl,
    List<ConfigParamDefinition>? configParams,
    bool? supportsMcp,
  }) {
    return IntegrationTypeDto(
      type: type ?? this.type,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      categories: categories ?? this.categories,
      setupDocumentationUrl:
          setupDocumentationUrl ?? this.setupDocumentationUrl,
      configParams: configParams ?? this.configParams,
      supportsMcp: supportsMcp ?? this.supportsMcp,
    );
  }

  IntegrationTypeDto copyWithWrapped({
    Wrapped<String?>? type,
    Wrapped<String?>? displayName,
    Wrapped<String?>? description,
    Wrapped<String?>? iconUrl,
    Wrapped<List<String>?>? categories,
    Wrapped<String?>? setupDocumentationUrl,
    Wrapped<List<ConfigParamDefinition>?>? configParams,
    Wrapped<bool?>? supportsMcp,
  }) {
    return IntegrationTypeDto(
      type: (type != null ? type.value : this.type),
      displayName: (displayName != null ? displayName.value : this.displayName),
      description: (description != null ? description.value : this.description),
      iconUrl: (iconUrl != null ? iconUrl.value : this.iconUrl),
      categories: (categories != null ? categories.value : this.categories),
      setupDocumentationUrl: (setupDocumentationUrl != null
          ? setupDocumentationUrl.value
          : this.setupDocumentationUrl),
      configParams: (configParams != null
          ? configParams.value
          : this.configParams),
      supportsMcp: (supportsMcp != null ? supportsMcp.value : this.supportsMcp),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiV1ChatCompletionsWithFilesPost$RequestBody {
  const ApiV1ChatCompletionsWithFilesPost$RequestBody({this.files});

  factory ApiV1ChatCompletionsWithFilesPost$RequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$ApiV1ChatCompletionsWithFilesPost$RequestBodyFromJson(json);

  static const toJsonFactory =
      _$ApiV1ChatCompletionsWithFilesPost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$ApiV1ChatCompletionsWithFilesPost$RequestBodyToJson(this);

  @JsonKey(name: 'files', includeIfNull: false, defaultValue: <String>[])
  final List<String>? files;
  static const fromJsonFactory =
      _$ApiV1ChatCompletionsWithFilesPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiV1ChatCompletionsWithFilesPost$RequestBody &&
            (identical(other.files, files) ||
                const DeepCollectionEquality().equals(other.files, files)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(files) ^ runtimeType.hashCode;
}

extension $ApiV1ChatCompletionsWithFilesPost$RequestBodyExtension
    on ApiV1ChatCompletionsWithFilesPost$RequestBody {
  ApiV1ChatCompletionsWithFilesPost$RequestBody copyWith({
    List<String>? files,
  }) {
    return ApiV1ChatCompletionsWithFilesPost$RequestBody(
      files: files ?? this.files,
    );
  }

  ApiV1ChatCompletionsWithFilesPost$RequestBody copyWithWrapped({
    Wrapped<List<String>?>? files,
  }) {
    return ApiV1ChatCompletionsWithFilesPost$RequestBody(
      files: (files != null ? files.value : this.files),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ApiPresentationScriptPost$RequestBody {
  const ApiPresentationScriptPost$RequestBody({this.files});

  factory ApiPresentationScriptPost$RequestBody.fromJson(
    Map<String, dynamic> json,
  ) => _$ApiPresentationScriptPost$RequestBodyFromJson(json);

  static const toJsonFactory = _$ApiPresentationScriptPost$RequestBodyToJson;
  Map<String, dynamic> toJson() =>
      _$ApiPresentationScriptPost$RequestBodyToJson(this);

  @JsonKey(name: 'files', includeIfNull: false, defaultValue: <String>[])
  final List<String>? files;
  static const fromJsonFactory =
      _$ApiPresentationScriptPost$RequestBodyFromJson;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is ApiPresentationScriptPost$RequestBody &&
            (identical(other.files, files) ||
                const DeepCollectionEquality().equals(other.files, files)));
  }

  @override
  String toString() => jsonEncode(this);

  @override
  int get hashCode =>
      const DeepCollectionEquality().hash(files) ^ runtimeType.hashCode;
}

extension $ApiPresentationScriptPost$RequestBodyExtension
    on ApiPresentationScriptPost$RequestBody {
  ApiPresentationScriptPost$RequestBody copyWith({List<String>? files}) {
    return ApiPresentationScriptPost$RequestBody(files: files ?? this.files);
  }

  ApiPresentationScriptPost$RequestBody copyWithWrapped({
    Wrapped<List<String>?>? files,
  }) {
    return ApiPresentationScriptPost$RequestBody(
      files: (files != null ? files.value : this.files),
    );
  }
}

String? integrationUserDtoPermissionLevelNullableToJson(
  enums.IntegrationUserDtoPermissionLevel? integrationUserDtoPermissionLevel,
) {
  return integrationUserDtoPermissionLevel?.value;
}

String? integrationUserDtoPermissionLevelToJson(
  enums.IntegrationUserDtoPermissionLevel integrationUserDtoPermissionLevel,
) {
  return integrationUserDtoPermissionLevel.value;
}

enums.IntegrationUserDtoPermissionLevel
integrationUserDtoPermissionLevelFromJson(
  Object? integrationUserDtoPermissionLevel, [
  enums.IntegrationUserDtoPermissionLevel? defaultValue,
]) {
  return enums.IntegrationUserDtoPermissionLevel.values.firstWhereOrNull(
        (e) => e.value == integrationUserDtoPermissionLevel,
      ) ??
      defaultValue ??
      enums.IntegrationUserDtoPermissionLevel.swaggerGeneratedUnknown;
}

enums.IntegrationUserDtoPermissionLevel?
integrationUserDtoPermissionLevelNullableFromJson(
  Object? integrationUserDtoPermissionLevel, [
  enums.IntegrationUserDtoPermissionLevel? defaultValue,
]) {
  if (integrationUserDtoPermissionLevel == null) {
    return null;
  }
  return enums.IntegrationUserDtoPermissionLevel.values.firstWhereOrNull(
        (e) => e.value == integrationUserDtoPermissionLevel,
      ) ??
      defaultValue;
}

String integrationUserDtoPermissionLevelExplodedListToJson(
  List<enums.IntegrationUserDtoPermissionLevel>?
  integrationUserDtoPermissionLevel,
) {
  return integrationUserDtoPermissionLevel?.map((e) => e.value!).join(',') ??
      '';
}

List<String> integrationUserDtoPermissionLevelListToJson(
  List<enums.IntegrationUserDtoPermissionLevel>?
  integrationUserDtoPermissionLevel,
) {
  if (integrationUserDtoPermissionLevel == null) {
    return [];
  }

  return integrationUserDtoPermissionLevel.map((e) => e.value!).toList();
}

List<enums.IntegrationUserDtoPermissionLevel>
integrationUserDtoPermissionLevelListFromJson(
  List? integrationUserDtoPermissionLevel, [
  List<enums.IntegrationUserDtoPermissionLevel>? defaultValue,
]) {
  if (integrationUserDtoPermissionLevel == null) {
    return defaultValue ?? [];
  }

  return integrationUserDtoPermissionLevel
      .map((e) => integrationUserDtoPermissionLevelFromJson(e.toString()))
      .toList();
}

List<enums.IntegrationUserDtoPermissionLevel>?
integrationUserDtoPermissionLevelNullableListFromJson(
  List? integrationUserDtoPermissionLevel, [
  List<enums.IntegrationUserDtoPermissionLevel>? defaultValue,
]) {
  if (integrationUserDtoPermissionLevel == null) {
    return defaultValue;
  }

  return integrationUserDtoPermissionLevel
      .map((e) => integrationUserDtoPermissionLevelFromJson(e.toString()))
      .toList();
}

String? workspaceDtoCurrentUserRoleNullableToJson(
  enums.WorkspaceDtoCurrentUserRole? workspaceDtoCurrentUserRole,
) {
  return workspaceDtoCurrentUserRole?.value;
}

String? workspaceDtoCurrentUserRoleToJson(
  enums.WorkspaceDtoCurrentUserRole workspaceDtoCurrentUserRole,
) {
  return workspaceDtoCurrentUserRole.value;
}

enums.WorkspaceDtoCurrentUserRole workspaceDtoCurrentUserRoleFromJson(
  Object? workspaceDtoCurrentUserRole, [
  enums.WorkspaceDtoCurrentUserRole? defaultValue,
]) {
  return enums.WorkspaceDtoCurrentUserRole.values.firstWhereOrNull(
        (e) => e.value == workspaceDtoCurrentUserRole,
      ) ??
      defaultValue ??
      enums.WorkspaceDtoCurrentUserRole.swaggerGeneratedUnknown;
}

enums.WorkspaceDtoCurrentUserRole? workspaceDtoCurrentUserRoleNullableFromJson(
  Object? workspaceDtoCurrentUserRole, [
  enums.WorkspaceDtoCurrentUserRole? defaultValue,
]) {
  if (workspaceDtoCurrentUserRole == null) {
    return null;
  }
  return enums.WorkspaceDtoCurrentUserRole.values.firstWhereOrNull(
        (e) => e.value == workspaceDtoCurrentUserRole,
      ) ??
      defaultValue;
}

String workspaceDtoCurrentUserRoleExplodedListToJson(
  List<enums.WorkspaceDtoCurrentUserRole>? workspaceDtoCurrentUserRole,
) {
  return workspaceDtoCurrentUserRole?.map((e) => e.value!).join(',') ?? '';
}

List<String> workspaceDtoCurrentUserRoleListToJson(
  List<enums.WorkspaceDtoCurrentUserRole>? workspaceDtoCurrentUserRole,
) {
  if (workspaceDtoCurrentUserRole == null) {
    return [];
  }

  return workspaceDtoCurrentUserRole.map((e) => e.value!).toList();
}

List<enums.WorkspaceDtoCurrentUserRole> workspaceDtoCurrentUserRoleListFromJson(
  List? workspaceDtoCurrentUserRole, [
  List<enums.WorkspaceDtoCurrentUserRole>? defaultValue,
]) {
  if (workspaceDtoCurrentUserRole == null) {
    return defaultValue ?? [];
  }

  return workspaceDtoCurrentUserRole
      .map((e) => workspaceDtoCurrentUserRoleFromJson(e.toString()))
      .toList();
}

List<enums.WorkspaceDtoCurrentUserRole>?
workspaceDtoCurrentUserRoleNullableListFromJson(
  List? workspaceDtoCurrentUserRole, [
  List<enums.WorkspaceDtoCurrentUserRole>? defaultValue,
]) {
  if (workspaceDtoCurrentUserRole == null) {
    return defaultValue;
  }

  return workspaceDtoCurrentUserRole
      .map((e) => workspaceDtoCurrentUserRoleFromJson(e.toString()))
      .toList();
}

String? workspaceUserDtoRoleNullableToJson(
  enums.WorkspaceUserDtoRole? workspaceUserDtoRole,
) {
  return workspaceUserDtoRole?.value;
}

String? workspaceUserDtoRoleToJson(
  enums.WorkspaceUserDtoRole workspaceUserDtoRole,
) {
  return workspaceUserDtoRole.value;
}

enums.WorkspaceUserDtoRole workspaceUserDtoRoleFromJson(
  Object? workspaceUserDtoRole, [
  enums.WorkspaceUserDtoRole? defaultValue,
]) {
  return enums.WorkspaceUserDtoRole.values.firstWhereOrNull(
        (e) => e.value == workspaceUserDtoRole,
      ) ??
      defaultValue ??
      enums.WorkspaceUserDtoRole.swaggerGeneratedUnknown;
}

enums.WorkspaceUserDtoRole? workspaceUserDtoRoleNullableFromJson(
  Object? workspaceUserDtoRole, [
  enums.WorkspaceUserDtoRole? defaultValue,
]) {
  if (workspaceUserDtoRole == null) {
    return null;
  }
  return enums.WorkspaceUserDtoRole.values.firstWhereOrNull(
        (e) => e.value == workspaceUserDtoRole,
      ) ??
      defaultValue;
}

String workspaceUserDtoRoleExplodedListToJson(
  List<enums.WorkspaceUserDtoRole>? workspaceUserDtoRole,
) {
  return workspaceUserDtoRole?.map((e) => e.value!).join(',') ?? '';
}

List<String> workspaceUserDtoRoleListToJson(
  List<enums.WorkspaceUserDtoRole>? workspaceUserDtoRole,
) {
  if (workspaceUserDtoRole == null) {
    return [];
  }

  return workspaceUserDtoRole.map((e) => e.value!).toList();
}

List<enums.WorkspaceUserDtoRole> workspaceUserDtoRoleListFromJson(
  List? workspaceUserDtoRole, [
  List<enums.WorkspaceUserDtoRole>? defaultValue,
]) {
  if (workspaceUserDtoRole == null) {
    return defaultValue ?? [];
  }

  return workspaceUserDtoRole
      .map((e) => workspaceUserDtoRoleFromJson(e.toString()))
      .toList();
}

List<enums.WorkspaceUserDtoRole>? workspaceUserDtoRoleNullableListFromJson(
  List? workspaceUserDtoRole, [
  List<enums.WorkspaceUserDtoRole>? defaultValue,
]) {
  if (workspaceUserDtoRole == null) {
    return defaultValue;
  }

  return workspaceUserDtoRole
      .map((e) => workspaceUserDtoRoleFromJson(e.toString()))
      .toList();
}

String? shareWorkspaceRequestRoleNullableToJson(
  enums.ShareWorkspaceRequestRole? shareWorkspaceRequestRole,
) {
  return shareWorkspaceRequestRole?.value;
}

String? shareWorkspaceRequestRoleToJson(
  enums.ShareWorkspaceRequestRole shareWorkspaceRequestRole,
) {
  return shareWorkspaceRequestRole.value;
}

enums.ShareWorkspaceRequestRole shareWorkspaceRequestRoleFromJson(
  Object? shareWorkspaceRequestRole, [
  enums.ShareWorkspaceRequestRole? defaultValue,
]) {
  return enums.ShareWorkspaceRequestRole.values.firstWhereOrNull(
        (e) => e.value == shareWorkspaceRequestRole,
      ) ??
      defaultValue ??
      enums.ShareWorkspaceRequestRole.swaggerGeneratedUnknown;
}

enums.ShareWorkspaceRequestRole? shareWorkspaceRequestRoleNullableFromJson(
  Object? shareWorkspaceRequestRole, [
  enums.ShareWorkspaceRequestRole? defaultValue,
]) {
  if (shareWorkspaceRequestRole == null) {
    return null;
  }
  return enums.ShareWorkspaceRequestRole.values.firstWhereOrNull(
        (e) => e.value == shareWorkspaceRequestRole,
      ) ??
      defaultValue;
}

String shareWorkspaceRequestRoleExplodedListToJson(
  List<enums.ShareWorkspaceRequestRole>? shareWorkspaceRequestRole,
) {
  return shareWorkspaceRequestRole?.map((e) => e.value!).join(',') ?? '';
}

List<String> shareWorkspaceRequestRoleListToJson(
  List<enums.ShareWorkspaceRequestRole>? shareWorkspaceRequestRole,
) {
  if (shareWorkspaceRequestRole == null) {
    return [];
  }

  return shareWorkspaceRequestRole.map((e) => e.value!).toList();
}

List<enums.ShareWorkspaceRequestRole> shareWorkspaceRequestRoleListFromJson(
  List? shareWorkspaceRequestRole, [
  List<enums.ShareWorkspaceRequestRole>? defaultValue,
]) {
  if (shareWorkspaceRequestRole == null) {
    return defaultValue ?? [];
  }

  return shareWorkspaceRequestRole
      .map((e) => shareWorkspaceRequestRoleFromJson(e.toString()))
      .toList();
}

List<enums.ShareWorkspaceRequestRole>?
shareWorkspaceRequestRoleNullableListFromJson(
  List? shareWorkspaceRequestRole, [
  List<enums.ShareWorkspaceRequestRole>? defaultValue,
]) {
  if (shareWorkspaceRequestRole == null) {
    return defaultValue;
  }

  return shareWorkspaceRequestRole
      .map((e) => shareWorkspaceRequestRoleFromJson(e.toString()))
      .toList();
}

String? jobExecutionResponseStatusNullableToJson(
  enums.JobExecutionResponseStatus? jobExecutionResponseStatus,
) {
  return jobExecutionResponseStatus?.value;
}

String? jobExecutionResponseStatusToJson(
  enums.JobExecutionResponseStatus jobExecutionResponseStatus,
) {
  return jobExecutionResponseStatus.value;
}

enums.JobExecutionResponseStatus jobExecutionResponseStatusFromJson(
  Object? jobExecutionResponseStatus, [
  enums.JobExecutionResponseStatus? defaultValue,
]) {
  return enums.JobExecutionResponseStatus.values.firstWhereOrNull(
        (e) => e.value == jobExecutionResponseStatus,
      ) ??
      defaultValue ??
      enums.JobExecutionResponseStatus.swaggerGeneratedUnknown;
}

enums.JobExecutionResponseStatus? jobExecutionResponseStatusNullableFromJson(
  Object? jobExecutionResponseStatus, [
  enums.JobExecutionResponseStatus? defaultValue,
]) {
  if (jobExecutionResponseStatus == null) {
    return null;
  }
  return enums.JobExecutionResponseStatus.values.firstWhereOrNull(
        (e) => e.value == jobExecutionResponseStatus,
      ) ??
      defaultValue;
}

String jobExecutionResponseStatusExplodedListToJson(
  List<enums.JobExecutionResponseStatus>? jobExecutionResponseStatus,
) {
  return jobExecutionResponseStatus?.map((e) => e.value!).join(',') ?? '';
}

List<String> jobExecutionResponseStatusListToJson(
  List<enums.JobExecutionResponseStatus>? jobExecutionResponseStatus,
) {
  if (jobExecutionResponseStatus == null) {
    return [];
  }

  return jobExecutionResponseStatus.map((e) => e.value!).toList();
}

List<enums.JobExecutionResponseStatus> jobExecutionResponseStatusListFromJson(
  List? jobExecutionResponseStatus, [
  List<enums.JobExecutionResponseStatus>? defaultValue,
]) {
  if (jobExecutionResponseStatus == null) {
    return defaultValue ?? [];
  }

  return jobExecutionResponseStatus
      .map((e) => jobExecutionResponseStatusFromJson(e.toString()))
      .toList();
}

List<enums.JobExecutionResponseStatus>?
jobExecutionResponseStatusNullableListFromJson(
  List? jobExecutionResponseStatus, [
  List<enums.JobExecutionResponseStatus>? defaultValue,
]) {
  if (jobExecutionResponseStatus == null) {
    return defaultValue;
  }

  return jobExecutionResponseStatus
      .map((e) => jobExecutionResponseStatusFromJson(e.toString()))
      .toList();
}

String? shareIntegrationRequestPermissionLevelNullableToJson(
  enums.ShareIntegrationRequestPermissionLevel?
  shareIntegrationRequestPermissionLevel,
) {
  return shareIntegrationRequestPermissionLevel?.value;
}

String? shareIntegrationRequestPermissionLevelToJson(
  enums.ShareIntegrationRequestPermissionLevel
  shareIntegrationRequestPermissionLevel,
) {
  return shareIntegrationRequestPermissionLevel.value;
}

enums.ShareIntegrationRequestPermissionLevel
shareIntegrationRequestPermissionLevelFromJson(
  Object? shareIntegrationRequestPermissionLevel, [
  enums.ShareIntegrationRequestPermissionLevel? defaultValue,
]) {
  return enums.ShareIntegrationRequestPermissionLevel.values.firstWhereOrNull(
        (e) => e.value == shareIntegrationRequestPermissionLevel,
      ) ??
      defaultValue ??
      enums.ShareIntegrationRequestPermissionLevel.swaggerGeneratedUnknown;
}

enums.ShareIntegrationRequestPermissionLevel?
shareIntegrationRequestPermissionLevelNullableFromJson(
  Object? shareIntegrationRequestPermissionLevel, [
  enums.ShareIntegrationRequestPermissionLevel? defaultValue,
]) {
  if (shareIntegrationRequestPermissionLevel == null) {
    return null;
  }
  return enums.ShareIntegrationRequestPermissionLevel.values.firstWhereOrNull(
        (e) => e.value == shareIntegrationRequestPermissionLevel,
      ) ??
      defaultValue;
}

String shareIntegrationRequestPermissionLevelExplodedListToJson(
  List<enums.ShareIntegrationRequestPermissionLevel>?
  shareIntegrationRequestPermissionLevel,
) {
  return shareIntegrationRequestPermissionLevel
          ?.map((e) => e.value!)
          .join(',') ??
      '';
}

List<String> shareIntegrationRequestPermissionLevelListToJson(
  List<enums.ShareIntegrationRequestPermissionLevel>?
  shareIntegrationRequestPermissionLevel,
) {
  if (shareIntegrationRequestPermissionLevel == null) {
    return [];
  }

  return shareIntegrationRequestPermissionLevel.map((e) => e.value!).toList();
}

List<enums.ShareIntegrationRequestPermissionLevel>
shareIntegrationRequestPermissionLevelListFromJson(
  List? shareIntegrationRequestPermissionLevel, [
  List<enums.ShareIntegrationRequestPermissionLevel>? defaultValue,
]) {
  if (shareIntegrationRequestPermissionLevel == null) {
    return defaultValue ?? [];
  }

  return shareIntegrationRequestPermissionLevel
      .map((e) => shareIntegrationRequestPermissionLevelFromJson(e.toString()))
      .toList();
}

List<enums.ShareIntegrationRequestPermissionLevel>?
shareIntegrationRequestPermissionLevelNullableListFromJson(
  List? shareIntegrationRequestPermissionLevel, [
  List<enums.ShareIntegrationRequestPermissionLevel>? defaultValue,
]) {
  if (shareIntegrationRequestPermissionLevel == null) {
    return defaultValue;
  }

  return shareIntegrationRequestPermissionLevel
      .map((e) => shareIntegrationRequestPermissionLevelFromJson(e.toString()))
      .toList();
}

String? jobExecutionStatusResponseStatusNullableToJson(
  enums.JobExecutionStatusResponseStatus? jobExecutionStatusResponseStatus,
) {
  return jobExecutionStatusResponseStatus?.value;
}

String? jobExecutionStatusResponseStatusToJson(
  enums.JobExecutionStatusResponseStatus jobExecutionStatusResponseStatus,
) {
  return jobExecutionStatusResponseStatus.value;
}

enums.JobExecutionStatusResponseStatus jobExecutionStatusResponseStatusFromJson(
  Object? jobExecutionStatusResponseStatus, [
  enums.JobExecutionStatusResponseStatus? defaultValue,
]) {
  return enums.JobExecutionStatusResponseStatus.values.firstWhereOrNull(
        (e) => e.value == jobExecutionStatusResponseStatus,
      ) ??
      defaultValue ??
      enums.JobExecutionStatusResponseStatus.swaggerGeneratedUnknown;
}

enums.JobExecutionStatusResponseStatus?
jobExecutionStatusResponseStatusNullableFromJson(
  Object? jobExecutionStatusResponseStatus, [
  enums.JobExecutionStatusResponseStatus? defaultValue,
]) {
  if (jobExecutionStatusResponseStatus == null) {
    return null;
  }
  return enums.JobExecutionStatusResponseStatus.values.firstWhereOrNull(
        (e) => e.value == jobExecutionStatusResponseStatus,
      ) ??
      defaultValue;
}

String jobExecutionStatusResponseStatusExplodedListToJson(
  List<enums.JobExecutionStatusResponseStatus>?
  jobExecutionStatusResponseStatus,
) {
  return jobExecutionStatusResponseStatus?.map((e) => e.value!).join(',') ?? '';
}

List<String> jobExecutionStatusResponseStatusListToJson(
  List<enums.JobExecutionStatusResponseStatus>?
  jobExecutionStatusResponseStatus,
) {
  if (jobExecutionStatusResponseStatus == null) {
    return [];
  }

  return jobExecutionStatusResponseStatus.map((e) => e.value!).toList();
}

List<enums.JobExecutionStatusResponseStatus>
jobExecutionStatusResponseStatusListFromJson(
  List? jobExecutionStatusResponseStatus, [
  List<enums.JobExecutionStatusResponseStatus>? defaultValue,
]) {
  if (jobExecutionStatusResponseStatus == null) {
    return defaultValue ?? [];
  }

  return jobExecutionStatusResponseStatus
      .map((e) => jobExecutionStatusResponseStatusFromJson(e.toString()))
      .toList();
}

List<enums.JobExecutionStatusResponseStatus>?
jobExecutionStatusResponseStatusNullableListFromJson(
  List? jobExecutionStatusResponseStatus, [
  List<enums.JobExecutionStatusResponseStatus>? defaultValue,
]) {
  if (jobExecutionStatusResponseStatus == null) {
    return defaultValue;
  }

  return jobExecutionStatusResponseStatus
      .map((e) => jobExecutionStatusResponseStatusFromJson(e.toString()))
      .toList();
}

String? agentInfoTypeNullableToJson(enums.AgentInfoType? agentInfoType) {
  return agentInfoType?.value;
}

String? agentInfoTypeToJson(enums.AgentInfoType agentInfoType) {
  return agentInfoType.value;
}

enums.AgentInfoType agentInfoTypeFromJson(
  Object? agentInfoType, [
  enums.AgentInfoType? defaultValue,
]) {
  return enums.AgentInfoType.values.firstWhereOrNull(
        (e) => e.value == agentInfoType,
      ) ??
      defaultValue ??
      enums.AgentInfoType.swaggerGeneratedUnknown;
}

enums.AgentInfoType? agentInfoTypeNullableFromJson(
  Object? agentInfoType, [
  enums.AgentInfoType? defaultValue,
]) {
  if (agentInfoType == null) {
    return null;
  }
  return enums.AgentInfoType.values.firstWhereOrNull(
        (e) => e.value == agentInfoType,
      ) ??
      defaultValue;
}

String agentInfoTypeExplodedListToJson(
  List<enums.AgentInfoType>? agentInfoType,
) {
  return agentInfoType?.map((e) => e.value!).join(',') ?? '';
}

List<String> agentInfoTypeListToJson(List<enums.AgentInfoType>? agentInfoType) {
  if (agentInfoType == null) {
    return [];
  }

  return agentInfoType.map((e) => e.value!).toList();
}

List<enums.AgentInfoType> agentInfoTypeListFromJson(
  List? agentInfoType, [
  List<enums.AgentInfoType>? defaultValue,
]) {
  if (agentInfoType == null) {
    return defaultValue ?? [];
  }

  return agentInfoType.map((e) => agentInfoTypeFromJson(e.toString())).toList();
}

List<enums.AgentInfoType>? agentInfoTypeNullableListFromJson(
  List? agentInfoType, [
  List<enums.AgentInfoType>? defaultValue,
]) {
  if (agentInfoType == null) {
    return defaultValue;
  }

  return agentInfoType.map((e) => agentInfoTypeFromJson(e.toString())).toList();
}

// ignore: unused_element
String? _dateToJson(DateTime? date) {
  if (date == null) {
    return null;
  }

  final year = date.year.toString();
  final month = date.month < 10 ? '0${date.month}' : date.month.toString();
  final day = date.day < 10 ? '0${date.day}' : date.day.toString();

  return '$year-$month-$day';
}

class Wrapped<T> {
  final T value;
  const Wrapped.value(this.value);
}
