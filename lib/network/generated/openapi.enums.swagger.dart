import 'package:json_annotation/json_annotation.dart';

enum IntegrationUserDtoPermissionLevel {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('READ')
  read('READ'),
  @JsonValue('WRITE')
  write('WRITE'),
  @JsonValue('ADMIN')
  admin('ADMIN');

  final String? value;

  const IntegrationUserDtoPermissionLevel(this.value);
}

enum WorkspaceDtoCurrentUserRole {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ADMIN')
  admin('ADMIN'),
  @JsonValue('USER')
  user('USER');

  final String? value;

  const WorkspaceDtoCurrentUserRole(this.value);
}

enum WorkspaceUserDtoRole {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ADMIN')
  admin('ADMIN'),
  @JsonValue('USER')
  user('USER');

  final String? value;

  const WorkspaceUserDtoRole(this.value);
}

enum ShareWorkspaceRequestRole {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('ADMIN')
  admin('ADMIN'),
  @JsonValue('USER')
  user('USER');

  final String? value;

  const ShareWorkspaceRequestRole(this.value);
}

enum ShareIntegrationRequestPermissionLevel {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('READ')
  read('READ'),
  @JsonValue('WRITE')
  write('WRITE'),
  @JsonValue('ADMIN')
  admin('ADMIN');

  final String? value;

  const ShareIntegrationRequestPermissionLevel(this.value);
}

enum AgentInfoType {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('AGENT')
  agent('AGENT'),
  @JsonValue('ORCHESTRATOR')
  orchestrator('ORCHESTRATOR');

  final String? value;

  const AgentInfoType(this.value);
}
