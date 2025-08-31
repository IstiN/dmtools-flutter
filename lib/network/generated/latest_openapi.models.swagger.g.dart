// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_openapi.models.swagger.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonNode _$JsonNodeFromJson(Map<String, dynamic> json) => JsonNode();

Map<String, dynamic> _$JsonNodeToJson(JsonNode instance) => <String, dynamic>{};

UpdateJobConfigurationRequest _$UpdateJobConfigurationRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateJobConfigurationRequest(
      name: json['name'] as String?,
      description: json['description'] as String?,
      jobType: json['jobType'] as String?,
      jobParameters: json['jobParameters'] == null
          ? null
          : JsonNode.fromJson(json['jobParameters'] as Map<String, dynamic>),
      integrationMappings: json['integrationMappings'] == null
          ? null
          : JsonNode.fromJson(
              json['integrationMappings'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$UpdateJobConfigurationRequestToJson(
        UpdateJobConfigurationRequest instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.jobType case final value?) 'jobType': value,
      if (instance.jobParameters?.toJson() case final value?)
        'jobParameters': value,
      if (instance.integrationMappings?.toJson() case final value?)
        'integrationMappings': value,
      if (instance.enabled case final value?) 'enabled': value,
    };

JobConfigurationDto _$JobConfigurationDtoFromJson(Map<String, dynamic> json) =>
    JobConfigurationDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      jobType: json['jobType'] as String?,
      createdById: json['createdById'] as String?,
      createdByName: json['createdByName'] as String?,
      createdByEmail: json['createdByEmail'] as String?,
      jobParameters: json['jobParameters'] == null
          ? null
          : JsonNode.fromJson(json['jobParameters'] as Map<String, dynamic>),
      integrationMappings: json['integrationMappings'] == null
          ? null
          : JsonNode.fromJson(
              json['integrationMappings'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool?,
      executionCount: (json['executionCount'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastExecutedAt: json['lastExecutedAt'] == null
          ? null
          : DateTime.parse(json['lastExecutedAt'] as String),
    );

Map<String, dynamic> _$JobConfigurationDtoToJson(
        JobConfigurationDto instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.jobType case final value?) 'jobType': value,
      if (instance.createdById case final value?) 'createdById': value,
      if (instance.createdByName case final value?) 'createdByName': value,
      if (instance.createdByEmail case final value?) 'createdByEmail': value,
      if (instance.jobParameters?.toJson() case final value?)
        'jobParameters': value,
      if (instance.integrationMappings?.toJson() case final value?)
        'integrationMappings': value,
      if (instance.enabled case final value?) 'enabled': value,
      if (instance.executionCount case final value?) 'executionCount': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
      if (instance.lastExecutedAt?.toIso8601String() case final value?)
        'lastExecutedAt': value,
    };

CreateMcpConfigurationRequest _$CreateMcpConfigurationRequestFromJson(
        Map<String, dynamic> json) =>
    CreateMcpConfigurationRequest(
      name: json['name'] as String,
      integrationIds: (json['integrationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$CreateMcpConfigurationRequestToJson(
        CreateMcpConfigurationRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'integrationIds': instance.integrationIds,
    };

ConfigParam _$ConfigParamFromJson(Map<String, dynamic> json) => ConfigParam(
      $value: json['value'] as String?,
      sensitive: json['sensitive'] as bool?,
    );

Map<String, dynamic> _$ConfigParamToJson(ConfigParam instance) =>
    <String, dynamic>{
      if (instance.$value case final value?) 'value': value,
      if (instance.sensitive case final value?) 'sensitive': value,
    };

UpdateIntegrationRequest _$UpdateIntegrationRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateIntegrationRequest(
      name: json['name'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool?,
      configParams: json['configParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UpdateIntegrationRequestToJson(
        UpdateIntegrationRequest instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.enabled case final value?) 'enabled': value,
      if (instance.configParams case final value?) 'configParams': value,
    };

IntegrationConfigDto _$IntegrationConfigDtoFromJson(
        Map<String, dynamic> json) =>
    IntegrationConfigDto(
      id: json['id'] as String?,
      paramKey: json['paramKey'] as String?,
      paramValue: json['paramValue'] as String?,
      sensitive: json['sensitive'] as bool?,
    );

Map<String, dynamic> _$IntegrationConfigDtoToJson(
        IntegrationConfigDto instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.paramKey case final value?) 'paramKey': value,
      if (instance.paramValue case final value?) 'paramValue': value,
      if (instance.sensitive case final value?) 'sensitive': value,
    };

IntegrationDto _$IntegrationDtoFromJson(Map<String, dynamic> json) =>
    IntegrationDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      enabled: json['enabled'] as bool?,
      createdById: json['createdById'] as String?,
      createdByName: json['createdByName'] as String?,
      createdByEmail: json['createdByEmail'] as String?,
      usageCount: (json['usageCount'] as num?)?.toInt(),
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      lastUsedAt: json['lastUsedAt'] == null
          ? null
          : DateTime.parse(json['lastUsedAt'] as String),
      configParams: (json['configParams'] as List<dynamic>?)
              ?.map((e) =>
                  IntegrationConfigDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      workspaces: (json['workspaces'] as List<dynamic>?)
              ?.map((e) => WorkspaceDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      users: (json['users'] as List<dynamic>?)
              ?.map(
                  (e) => IntegrationUserDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$IntegrationDtoToJson(IntegrationDto instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.type case final value?) 'type': value,
      if (instance.enabled case final value?) 'enabled': value,
      if (instance.createdById case final value?) 'createdById': value,
      if (instance.createdByName case final value?) 'createdByName': value,
      if (instance.createdByEmail case final value?) 'createdByEmail': value,
      if (instance.usageCount case final value?) 'usageCount': value,
      if (instance.categories case final value?) 'categories': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
      if (instance.lastUsedAt?.toIso8601String() case final value?)
        'lastUsedAt': value,
      if (instance.configParams?.map((e) => e.toJson()).toList()
          case final value?)
        'configParams': value,
      if (instance.workspaces?.map((e) => e.toJson()).toList()
          case final value?)
        'workspaces': value,
      if (instance.users?.map((e) => e.toJson()).toList() case final value?)
        'users': value,
    };

IntegrationUserDto _$IntegrationUserDtoFromJson(Map<String, dynamic> json) =>
    IntegrationUserDto(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      userName: json['userName'] as String?,
      userEmail: json['userEmail'] as String?,
      userPictureUrl: json['userPictureUrl'] as String?,
      permissionLevel: integrationUserDtoPermissionLevelNullableFromJson(
          json['permissionLevel']),
      addedAt: json['addedAt'] == null
          ? null
          : DateTime.parse(json['addedAt'] as String),
    );

Map<String, dynamic> _$IntegrationUserDtoToJson(IntegrationUserDto instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.userName case final value?) 'userName': value,
      if (instance.userEmail case final value?) 'userEmail': value,
      if (instance.userPictureUrl case final value?) 'userPictureUrl': value,
      if (integrationUserDtoPermissionLevelNullableToJson(
              instance.permissionLevel)
          case final value?)
        'permissionLevel': value,
      if (instance.addedAt?.toIso8601String() case final value?)
        'addedAt': value,
    };

WorkspaceDto _$WorkspaceDtoFromJson(Map<String, dynamic> json) => WorkspaceDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      ownerId: json['ownerId'] as String?,
      users: (json['users'] as List<dynamic>?)
              ?.map((e) => WorkspaceUserDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      description: json['description'] as String?,
      ownerName: json['ownerName'] as String?,
      ownerEmail: json['ownerEmail'] as String?,
      currentUserRole:
          workspaceDtoCurrentUserRoleNullableFromJson(json['currentUserRole']),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$WorkspaceDtoToJson(WorkspaceDto instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.ownerId case final value?) 'ownerId': value,
      if (instance.users?.map((e) => e.toJson()).toList() case final value?)
        'users': value,
      if (instance.description case final value?) 'description': value,
      if (instance.ownerName case final value?) 'ownerName': value,
      if (instance.ownerEmail case final value?) 'ownerEmail': value,
      if (workspaceDtoCurrentUserRoleNullableToJson(instance.currentUserRole)
          case final value?)
        'currentUserRole': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };

WorkspaceUserDto _$WorkspaceUserDtoFromJson(Map<String, dynamic> json) =>
    WorkspaceUserDto(
      id: json['id'] as String?,
      email: json['email'] as String?,
      role: workspaceUserDtoRoleNullableFromJson(json['role']),
    );

Map<String, dynamic> _$WorkspaceUserDtoToJson(WorkspaceUserDto instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.email case final value?) 'email': value,
      if (workspaceUserDtoRoleNullableToJson(instance.role) case final value?)
        'role': value,
    };

SseEmitter _$SseEmitterFromJson(Map<String, dynamic> json) => SseEmitter(
      timeout: (json['timeout'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SseEmitterToJson(SseEmitter instance) =>
    <String, dynamic>{
      if (instance.timeout case final value?) 'timeout': value,
    };

CreateWorkspaceRequest _$CreateWorkspaceRequestFromJson(
        Map<String, dynamic> json) =>
    CreateWorkspaceRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateWorkspaceRequestToJson(
        CreateWorkspaceRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
    };

ShareWorkspaceRequest _$ShareWorkspaceRequestFromJson(
        Map<String, dynamic> json) =>
    ShareWorkspaceRequest(
      email: json['email'] as String,
      role: shareWorkspaceRequestRoleFromJson(json['role']),
    );

Map<String, dynamic> _$ShareWorkspaceRequestToJson(
        ShareWorkspaceRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      if (shareWorkspaceRequestRoleToJson(instance.role) case final value?)
        'role': value,
    };

JSONObject _$JSONObjectFromJson(Map<String, dynamic> json) => JSONObject(
      empty: json['empty'] as bool?,
    );

Map<String, dynamic> _$JSONObjectToJson(JSONObject instance) =>
    <String, dynamic>{
      if (instance.empty case final value?) 'empty': value,
    };

JobExecutionRequest _$JobExecutionRequestFromJson(Map<String, dynamic> json) =>
    JobExecutionRequest(
      jobName: json['jobName'] as String?,
      params: json['params'] == null
          ? null
          : JSONObject.fromJson(json['params'] as Map<String, dynamic>),
      requiredIntegrations: (json['requiredIntegrations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$JobExecutionRequestToJson(
        JobExecutionRequest instance) =>
    <String, dynamic>{
      if (instance.jobName case final value?) 'jobName': value,
      if (instance.params?.toJson() case final value?) 'params': value,
      if (instance.requiredIntegrations case final value?)
        'requiredIntegrations': value,
    };

JobExecutionResponse _$JobExecutionResponseFromJson(
        Map<String, dynamic> json) =>
    JobExecutionResponse(
      executionId: json['executionId'] as String?,
      status: jobExecutionResponseStatusNullableFromJson(json['status']),
      jobName: json['jobName'] as String?,
      jobConfigurationId: json['jobConfigurationId'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      estimatedCompletionAt: json['estimatedCompletionAt'] == null
          ? null
          : DateTime.parse(json['estimatedCompletionAt'] as String),
      message: json['message'] as String?,
    );

Map<String, dynamic> _$JobExecutionResponseToJson(
        JobExecutionResponse instance) =>
    <String, dynamic>{
      if (instance.executionId case final value?) 'executionId': value,
      if (jobExecutionResponseStatusNullableToJson(instance.status)
          case final value?)
        'status': value,
      if (instance.jobName case final value?) 'jobName': value,
      if (instance.jobConfigurationId case final value?)
        'jobConfigurationId': value,
      if (instance.startedAt?.toIso8601String() case final value?)
        'startedAt': value,
      if (instance.estimatedCompletionAt?.toIso8601String() case final value?)
        'estimatedCompletionAt': value,
      if (instance.message case final value?) 'message': value,
    };

ExecuteJobConfigurationRequest _$ExecuteJobConfigurationRequestFromJson(
        Map<String, dynamic> json) =>
    ExecuteJobConfigurationRequest(
      parameterOverrides: json['parameterOverrides'] == null
          ? null
          : JsonNode.fromJson(
              json['parameterOverrides'] as Map<String, dynamic>),
      integrationOverrides: json['integrationOverrides'] == null
          ? null
          : JsonNode.fromJson(
              json['integrationOverrides'] as Map<String, dynamic>),
      executionMode: json['executionMode'] as String?,
    );

Map<String, dynamic> _$ExecuteJobConfigurationRequestToJson(
        ExecuteJobConfigurationRequest instance) =>
    <String, dynamic>{
      if (instance.parameterOverrides?.toJson() case final value?)
        'parameterOverrides': value,
      if (instance.integrationOverrides?.toJson() case final value?)
        'integrationOverrides': value,
      if (instance.executionMode case final value?) 'executionMode': value,
    };

CreateJobConfigurationRequest _$CreateJobConfigurationRequestFromJson(
        Map<String, dynamic> json) =>
    CreateJobConfigurationRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      jobType: json['jobType'] as String,
      jobParameters:
          JsonNode.fromJson(json['jobParameters'] as Map<String, dynamic>),
      integrationMappings: JsonNode.fromJson(
          json['integrationMappings'] as Map<String, dynamic>),
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$CreateJobConfigurationRequestToJson(
        CreateJobConfigurationRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
      'jobType': instance.jobType,
      'jobParameters': instance.jobParameters.toJson(),
      'integrationMappings': instance.integrationMappings.toJson(),
      if (instance.enabled case final value?) 'enabled': value,
    };

WebhookExecuteRequest _$WebhookExecuteRequestFromJson(
        Map<String, dynamic> json) =>
    WebhookExecuteRequest(
      jobParameters: json['jobParameters'] == null
          ? null
          : JsonNode.fromJson(json['jobParameters'] as Map<String, dynamic>),
      integrationMappings: json['integrationMappings'] == null
          ? null
          : JsonNode.fromJson(
              json['integrationMappings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WebhookExecuteRequestToJson(
        WebhookExecuteRequest instance) =>
    <String, dynamic>{
      if (instance.jobParameters?.toJson() case final value?)
        'jobParameters': value,
      if (instance.integrationMappings?.toJson() case final value?)
        'integrationMappings': value,
    };

WebhookExecutionResponse _$WebhookExecutionResponseFromJson(
        Map<String, dynamic> json) =>
    WebhookExecutionResponse(
      executionId: json['executionId'] as String?,
      status: json['status'] as String?,
      message: json['message'] as String?,
      jobConfigurationId: json['jobConfigurationId'] as String?,
    );

Map<String, dynamic> _$WebhookExecutionResponseToJson(
        WebhookExecutionResponse instance) =>
    <String, dynamic>{
      if (instance.executionId case final value?) 'executionId': value,
      if (instance.status case final value?) 'status': value,
      if (instance.message case final value?) 'message': value,
      if (instance.jobConfigurationId case final value?)
        'jobConfigurationId': value,
    };

CreateWebhookKeyRequest _$CreateWebhookKeyRequestFromJson(
        Map<String, dynamic> json) =>
    CreateWebhookKeyRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateWebhookKeyRequestToJson(
        CreateWebhookKeyRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
    };

CreateWebhookKeyResponse _$CreateWebhookKeyResponseFromJson(
        Map<String, dynamic> json) =>
    CreateWebhookKeyResponse(
      keyId: json['keyId'] as String?,
      apiKey: json['apiKey'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      jobConfigurationId: json['jobConfigurationId'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CreateWebhookKeyResponseToJson(
        CreateWebhookKeyResponse instance) =>
    <String, dynamic>{
      if (instance.keyId case final value?) 'keyId': value,
      if (instance.apiKey case final value?) 'apiKey': value,
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.jobConfigurationId case final value?)
        'jobConfigurationId': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
    };

ExecutionParametersDto _$ExecutionParametersDtoFromJson(
        Map<String, dynamic> json) =>
    ExecutionParametersDto(
      jobType: json['jobType'] as String?,
      jobParameters: json['jobParameters'] == null
          ? null
          : JsonNode.fromJson(json['jobParameters'] as Map<String, dynamic>),
      integrationMappings: json['integrationMappings'] == null
          ? null
          : JsonNode.fromJson(
              json['integrationMappings'] as Map<String, dynamic>),
      executionMode: json['executionMode'] as String?,
    );

Map<String, dynamic> _$ExecutionParametersDtoToJson(
        ExecutionParametersDto instance) =>
    <String, dynamic>{
      if (instance.jobType case final value?) 'jobType': value,
      if (instance.jobParameters?.toJson() case final value?)
        'jobParameters': value,
      if (instance.integrationMappings?.toJson() case final value?)
        'integrationMappings': value,
      if (instance.executionMode case final value?) 'executionMode': value,
    };

ChatResponse _$ChatResponseFromJson(Map<String, dynamic> json) => ChatResponse(
      content: json['content'] as String?,
      success: json['success'] as bool,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ChatResponseToJson(ChatResponse instance) =>
    <String, dynamic>{
      if (instance.content case final value?) 'content': value,
      'success': instance.success,
      if (instance.error case final value?) 'error': value,
    };

ChatMessage _$ChatMessageFromJson(Map<String, dynamic> json) => ChatMessage(
      role: chatMessageRoleFromJson(json['role']),
      content: json['content'] as String,
      fileNames: (json['fileNames'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ChatMessageToJson(ChatMessage instance) =>
    <String, dynamic>{
      if (chatMessageRoleToJson(instance.role) case final value?) 'role': value,
      'content': instance.content,
      if (instance.fileNames case final value?) 'fileNames': value,
    };

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
      messages: (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      model: json['model'] as String?,
      ai: json['ai'] as String?,
      mcpConfigId: json['mcpConfigId'] as String?,
    );

Map<String, dynamic> _$ChatRequestToJson(ChatRequest instance) =>
    <String, dynamic>{
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      if (instance.model case final value?) 'model': value,
      if (instance.ai case final value?) 'ai': value,
      if (instance.mcpConfigId case final value?) 'mcpConfigId': value,
    };

AgentExecutionRequest _$AgentExecutionRequestFromJson(
        Map<String, dynamic> json) =>
    AgentExecutionRequest(
      agentName: json['agentName'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AgentExecutionRequestToJson(
        AgentExecutionRequest instance) =>
    <String, dynamic>{
      if (instance.agentName case final value?) 'agentName': value,
      if (instance.parameters case final value?) 'parameters': value,
    };

AgentExecutionResponse _$AgentExecutionResponseFromJson(
        Map<String, dynamic> json) =>
    AgentExecutionResponse(
      result: json['result'],
      agentName: json['agentName'] as String?,
      success: json['success'] as bool?,
      error: json['error'] as String?,
      executionType: json['executionType'] as String?,
    );

Map<String, dynamic> _$AgentExecutionResponseToJson(
        AgentExecutionResponse instance) =>
    <String, dynamic>{
      if (instance.result case final value?) 'result': value,
      if (instance.agentName case final value?) 'agentName': value,
      if (instance.success case final value?) 'success': value,
      if (instance.error case final value?) 'error': value,
      if (instance.executionType case final value?) 'executionType': value,
    };

ScriptGenerationRequest _$ScriptGenerationRequestFromJson(
        Map<String, dynamic> json) =>
    ScriptGenerationRequest(
      userRequest: json['userRequest'] as String?,
    );

Map<String, dynamic> _$ScriptGenerationRequestToJson(
        ScriptGenerationRequest instance) =>
    <String, dynamic>{
      if (instance.userRequest case final value?) 'userRequest': value,
    };

GeneratePresentationRequest _$GeneratePresentationRequestFromJson(
        Map<String, dynamic> json) =>
    GeneratePresentationRequest(
      jsScript: json['jsScript'] as String?,
      paramsForJs: json['paramsForJs'] == null
          ? null
          : JsonNode.fromJson(json['paramsForJs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GeneratePresentationRequestToJson(
        GeneratePresentationRequest instance) =>
    <String, dynamic>{
      if (instance.jsScript case final value?) 'jsScript': value,
      if (instance.paramsForJs?.toJson() case final value?)
        'paramsForJs': value,
    };

OAuthInitiateRequest _$OAuthInitiateRequestFromJson(
        Map<String, dynamic> json) =>
    OAuthInitiateRequest(
      provider: json['provider'] as String?,
      environment: json['environment'] as String?,
      clientRedirectUri: json['client_redirect_uri'] as String?,
      clientType: json['client_type'] as String?,
    );

Map<String, dynamic> _$OAuthInitiateRequestToJson(
        OAuthInitiateRequest instance) =>
    <String, dynamic>{
      if (instance.provider case final value?) 'provider': value,
      if (instance.environment case final value?) 'environment': value,
      if (instance.clientRedirectUri case final value?)
        'client_redirect_uri': value,
      if (instance.clientType case final value?) 'client_type': value,
    };

OAuthExchangeRequest _$OAuthExchangeRequestFromJson(
        Map<String, dynamic> json) =>
    OAuthExchangeRequest(
      code: json['code'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$OAuthExchangeRequestToJson(
        OAuthExchangeRequest instance) =>
    <String, dynamic>{
      if (instance.code case final value?) 'code': value,
      if (instance.state case final value?) 'state': value,
    };

CreateIntegrationRequest _$CreateIntegrationRequestFromJson(
        Map<String, dynamic> json) =>
    CreateIntegrationRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      configParams: json['configParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$CreateIntegrationRequestToJson(
        CreateIntegrationRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (instance.description case final value?) 'description': value,
      'type': instance.type,
      if (instance.configParams case final value?) 'configParams': value,
    };

ShareIntegrationWithWorkspaceRequest
    _$ShareIntegrationWithWorkspaceRequestFromJson(Map<String, dynamic> json) =>
        ShareIntegrationWithWorkspaceRequest(
          workspaceId: json['workspaceId'] as String,
        );

Map<String, dynamic> _$ShareIntegrationWithWorkspaceRequestToJson(
        ShareIntegrationWithWorkspaceRequest instance) =>
    <String, dynamic>{
      'workspaceId': instance.workspaceId,
    };

ShareIntegrationRequest _$ShareIntegrationRequestFromJson(
        Map<String, dynamic> json) =>
    ShareIntegrationRequest(
      userEmail: json['userEmail'] as String,
      permissionLevel: shareIntegrationRequestPermissionLevelFromJson(
          json['permissionLevel']),
    );

Map<String, dynamic> _$ShareIntegrationRequestToJson(
        ShareIntegrationRequest instance) =>
    <String, dynamic>{
      'userEmail': instance.userEmail,
      if (shareIntegrationRequestPermissionLevelToJson(instance.permissionLevel)
          case final value?)
        'permissionLevel': value,
    };

TestIntegrationRequest _$TestIntegrationRequestFromJson(
        Map<String, dynamic> json) =>
    TestIntegrationRequest(
      type: json['type'] as String?,
      configParams: json['configParams'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TestIntegrationRequestToJson(
        TestIntegrationRequest instance) =>
    <String, dynamic>{
      if (instance.type case final value?) 'type': value,
      if (instance.configParams case final value?) 'configParams': value,
    };

ConfigParamDefinition _$ConfigParamDefinitionFromJson(
        Map<String, dynamic> json) =>
    ConfigParamDefinition(
      key: json['key'] as String?,
      displayName: json['displayName'] as String?,
      description: json['description'] as String?,
      instructions: json['instructions'] as String?,
      required: json['required'] as bool?,
      sensitive: json['sensitive'] as bool?,
      type: json['type'] as String?,
      defaultValue: json['defaultValue'] as String?,
      options: (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$ConfigParamDefinitionToJson(
        ConfigParamDefinition instance) =>
    <String, dynamic>{
      if (instance.key case final value?) 'key': value,
      if (instance.displayName case final value?) 'displayName': value,
      if (instance.description case final value?) 'description': value,
      if (instance.instructions case final value?) 'instructions': value,
      if (instance.required case final value?) 'required': value,
      if (instance.sensitive case final value?) 'sensitive': value,
      if (instance.type case final value?) 'type': value,
      if (instance.defaultValue case final value?) 'defaultValue': value,
      if (instance.options case final value?) 'options': value,
      if (instance.examples case final value?) 'examples': value,
    };

JobTypeDto _$JobTypeDtoFromJson(Map<String, dynamic> json) => JobTypeDto(
      type: json['type'] as String?,
      displayName: json['displayName'] as String?,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      setupDocumentationUrl: json['setupDocumentationUrl'] as String?,
      executionModes: (json['executionModes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      requiredIntegrations: (json['requiredIntegrations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      optionalIntegrations: (json['optionalIntegrations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      configParams: (json['configParams'] as List<dynamic>?)
              ?.map((e) =>
                  ConfigParamDefinition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$JobTypeDtoToJson(JobTypeDto instance) =>
    <String, dynamic>{
      if (instance.type case final value?) 'type': value,
      if (instance.displayName case final value?) 'displayName': value,
      if (instance.description case final value?) 'description': value,
      if (instance.iconUrl case final value?) 'iconUrl': value,
      if (instance.categories case final value?) 'categories': value,
      if (instance.setupDocumentationUrl case final value?)
        'setupDocumentationUrl': value,
      if (instance.executionModes case final value?) 'executionModes': value,
      if (instance.requiredIntegrations case final value?)
        'requiredIntegrations': value,
      if (instance.optionalIntegrations case final value?)
        'optionalIntegrations': value,
      if (instance.configParams?.map((e) => e.toJson()).toList()
          case final value?)
        'configParams': value,
    };

JobExecutionStatusResponse _$JobExecutionStatusResponseFromJson(
        Map<String, dynamic> json) =>
    JobExecutionStatusResponse(
      executionId: json['executionId'] as String?,
      status: jobExecutionStatusResponseStatusNullableFromJson(json['status']),
      jobName: json['jobName'] as String?,
      jobConfigurationId: json['jobConfigurationId'] as String?,
      jobConfigurationName: json['jobConfigurationName'] as String?,
      startedAt: json['startedAt'] == null
          ? null
          : DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      threadName: json['threadName'] as String?,
      durationMillis: (json['durationMillis'] as num?)?.toInt(),
      resultSummary: json['resultSummary'] as String?,
      errorMessage: json['errorMessage'] as String?,
      executionParameters: json['executionParameters'] as String?,
      active: json['active'] as bool?,
      completed: json['completed'] as bool?,
    );

Map<String, dynamic> _$JobExecutionStatusResponseToJson(
        JobExecutionStatusResponse instance) =>
    <String, dynamic>{
      if (instance.executionId case final value?) 'executionId': value,
      if (jobExecutionStatusResponseStatusNullableToJson(instance.status)
          case final value?)
        'status': value,
      if (instance.jobName case final value?) 'jobName': value,
      if (instance.jobConfigurationId case final value?)
        'jobConfigurationId': value,
      if (instance.jobConfigurationName case final value?)
        'jobConfigurationName': value,
      if (instance.startedAt?.toIso8601String() case final value?)
        'startedAt': value,
      if (instance.completedAt?.toIso8601String() case final value?)
        'completedAt': value,
      if (instance.threadName case final value?) 'threadName': value,
      if (instance.durationMillis case final value?) 'durationMillis': value,
      if (instance.resultSummary case final value?) 'resultSummary': value,
      if (instance.errorMessage case final value?) 'errorMessage': value,
      if (instance.executionParameters case final value?)
        'executionParameters': value,
      if (instance.active case final value?) 'active': value,
      if (instance.completed case final value?) 'completed': value,
    };

WebhookExampleTemplate _$WebhookExampleTemplateFromJson(
        Map<String, dynamic> json) =>
    WebhookExampleTemplate(
      name: json['name'] as String?,
      renderedTemplate: json['renderedTemplate'] as String?,
    );

Map<String, dynamic> _$WebhookExampleTemplateToJson(
        WebhookExampleTemplate instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.renderedTemplate case final value?)
        'renderedTemplate': value,
    };

WebhookExamplesDto _$WebhookExamplesDtoFromJson(Map<String, dynamic> json) =>
    WebhookExamplesDto(
      jobConfigurationId: json['jobConfigurationId'] as String?,
      jobType: json['jobType'] as String?,
      webhookUrl: json['webhookUrl'] as String?,
      examples: (json['examples'] as List<dynamic>?)
              ?.map((e) =>
                  WebhookExampleTemplate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      availableVariables: (json['availableVariables'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );

Map<String, dynamic> _$WebhookExamplesDtoToJson(WebhookExamplesDto instance) =>
    <String, dynamic>{
      if (instance.jobConfigurationId case final value?)
        'jobConfigurationId': value,
      if (instance.jobType case final value?) 'jobType': value,
      if (instance.webhookUrl case final value?) 'webhookUrl': value,
      if (instance.examples?.map((e) => e.toJson()).toList() case final value?)
        'examples': value,
      if (instance.availableVariables case final value?)
        'availableVariables': value,
    };

AgentInfo _$AgentInfoFromJson(Map<String, dynamic> json) => AgentInfo(
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      type: agentInfoTypeNullableFromJson(json['type']),
      parameters: (json['parameters'] as List<dynamic>?)
              ?.map((e) => ParameterInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      returnInfo: json['returnInfo'] == null
          ? null
          : ReturnInfo.fromJson(json['returnInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgentInfoToJson(AgentInfo instance) => <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.description case final value?) 'description': value,
      if (instance.category case final value?) 'category': value,
      if (agentInfoTypeNullableToJson(instance.type) case final value?)
        'type': value,
      if (instance.parameters?.map((e) => e.toJson()).toList()
          case final value?)
        'parameters': value,
      if (instance.returnInfo?.toJson() case final value?) 'returnInfo': value,
    };

ParameterInfo _$ParameterInfoFromJson(Map<String, dynamic> json) =>
    ParameterInfo(
      name: json['name'] as String?,
      type: json['type'] as String?,
      description: json['description'] as String?,
      required: json['required'] as bool?,
      defaultValue: json['defaultValue'],
      allowedValues: (json['allowedValues'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      example: json['example'] as String?,
    );

Map<String, dynamic> _$ParameterInfoToJson(ParameterInfo instance) =>
    <String, dynamic>{
      if (instance.name case final value?) 'name': value,
      if (instance.type case final value?) 'type': value,
      if (instance.description case final value?) 'description': value,
      if (instance.required case final value?) 'required': value,
      if (instance.defaultValue case final value?) 'defaultValue': value,
      if (instance.allowedValues case final value?) 'allowedValues': value,
      if (instance.example case final value?) 'example': value,
    };

ReturnInfo _$ReturnInfoFromJson(Map<String, dynamic> json) => ReturnInfo(
      type: json['type'] as String?,
      description: json['description'] as String?,
      schema: json['schema'] as Map<String, dynamic>?,
      example: json['example'] as String?,
    );

Map<String, dynamic> _$ReturnInfoToJson(ReturnInfo instance) =>
    <String, dynamic>{
      if (instance.type case final value?) 'type': value,
      if (instance.description case final value?) 'description': value,
      if (instance.schema case final value?) 'schema': value,
      if (instance.example case final value?) 'example': value,
    };

AgentListResponse _$AgentListResponseFromJson(Map<String, dynamic> json) =>
    AgentListResponse(
      agents: (json['agents'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      orchestrators: (json['orchestrators'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      detailedAgents: (json['detailedAgents'] as List<dynamic>?)
              ?.map((e) => AgentInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      detailedOrchestrators: (json['detailedOrchestrators'] as List<dynamic>?)
              ?.map((e) => AgentInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      detailed: json['detailed'] as bool?,
    );

Map<String, dynamic> _$AgentListResponseToJson(AgentListResponse instance) =>
    <String, dynamic>{
      if (instance.agents case final value?) 'agents': value,
      if (instance.orchestrators case final value?) 'orchestrators': value,
      if (instance.detailedAgents?.map((e) => e.toJson()).toList()
          case final value?)
        'detailedAgents': value,
      if (instance.detailedOrchestrators?.map((e) => e.toJson()).toList()
          case final value?)
        'detailedOrchestrators': value,
      if (instance.detailed case final value?) 'detailed': value,
    };

McpConfigurationDto _$McpConfigurationDtoFromJson(Map<String, dynamic> json) =>
    McpConfigurationDto(
      id: json['id'] as String?,
      name: json['name'] as String?,
      userId: json['userId'] as String?,
      integrationIds: (json['integrationIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$McpConfigurationDtoToJson(
        McpConfigurationDto instance) =>
    <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.name case final value?) 'name': value,
      if (instance.userId case final value?) 'userId': value,
      if (instance.integrationIds case final value?) 'integrationIds': value,
      if (instance.createdAt?.toIso8601String() case final value?)
        'createdAt': value,
      if (instance.updatedAt?.toIso8601String() case final value?)
        'updatedAt': value,
    };

IntegrationTypeDto _$IntegrationTypeDtoFromJson(Map<String, dynamic> json) =>
    IntegrationTypeDto(
      type: json['type'] as String?,
      displayName: json['displayName'] as String?,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      setupDocumentationUrl: json['setupDocumentationUrl'] as String?,
      configParams: (json['configParams'] as List<dynamic>?)
              ?.map((e) =>
                  ConfigParamDefinition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      supportsMcp: json['supportsMcp'] as bool?,
    );

Map<String, dynamic> _$IntegrationTypeDtoToJson(IntegrationTypeDto instance) =>
    <String, dynamic>{
      if (instance.type case final value?) 'type': value,
      if (instance.displayName case final value?) 'displayName': value,
      if (instance.description case final value?) 'description': value,
      if (instance.iconUrl case final value?) 'iconUrl': value,
      if (instance.categories case final value?) 'categories': value,
      if (instance.setupDocumentationUrl case final value?)
        'setupDocumentationUrl': value,
      if (instance.configParams?.map((e) => e.toJson()).toList()
          case final value?)
        'configParams': value,
      if (instance.supportsMcp case final value?) 'supportsMcp': value,
    };

ApiV1ChatCompletionsWithFilesPost$RequestBody
    _$ApiV1ChatCompletionsWithFilesPost$RequestBodyFromJson(
            Map<String, dynamic> json) =>
        ApiV1ChatCompletionsWithFilesPost$RequestBody(
          files: (json['files'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              [],
        );

Map<String, dynamic> _$ApiV1ChatCompletionsWithFilesPost$RequestBodyToJson(
        ApiV1ChatCompletionsWithFilesPost$RequestBody instance) =>
    <String, dynamic>{
      if (instance.files case final value?) 'files': value,
    };

ApiPresentationScriptPost$RequestBody
    _$ApiPresentationScriptPost$RequestBodyFromJson(
            Map<String, dynamic> json) =>
        ApiPresentationScriptPost$RequestBody(
          files: (json['files'] as List<dynamic>?)
                  ?.map((e) => e as String)
                  .toList() ??
              [],
        );

Map<String, dynamic> _$ApiPresentationScriptPost$RequestBodyToJson(
        ApiPresentationScriptPost$RequestBody instance) =>
    <String, dynamic>{
      if (instance.files case final value?) 'files': value,
    };
