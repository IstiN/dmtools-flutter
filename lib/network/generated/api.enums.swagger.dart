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

enum JobExecutionResponseStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('PENDING')
  pending('PENDING'),
  @JsonValue('RUNNING')
  running('RUNNING'),
  @JsonValue('COMPLETED')
  completed('COMPLETED'),
  @JsonValue('FAILED')
  failed('FAILED'),
  @JsonValue('CANCELLED')
  cancelled('CANCELLED');

  final String? value;

  const JobExecutionResponseStatus(this.value);
}

enum ChatMessageRole {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('user')
  user('user'),
  @JsonValue('assistant')
  assistant('assistant'),
  @JsonValue('system')
  system('system'),
  @JsonValue('model')
  model('model');

  final String? value;

  const ChatMessageRole(this.value);
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

enum JobExecutionStatusResponseStatus {
  @JsonValue(null)
  swaggerGeneratedUnknown(null),

  @JsonValue('PENDING')
  pending('PENDING'),
  @JsonValue('RUNNING')
  running('RUNNING'),
  @JsonValue('COMPLETED')
  completed('COMPLETED'),
  @JsonValue('FAILED')
  failed('FAILED'),
  @JsonValue('CANCELLED')
  cancelled('CANCELLED');

  final String? value;

  const JobExecutionStatusResponseStatus(this.value);
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
