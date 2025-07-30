// ignore_for_file: type=lint


import 'openapi.models.swagger.dart';
import 'package:chopper/chopper.dart';

import 'client_mapping.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:chopper/chopper.dart' as chopper;
export 'openapi.enums.swagger.dart';
export 'openapi.models.swagger.dart';

part 'openapi.swagger.chopper.dart';

// **************************************************************************
// SwaggerChopperGenerator
// **************************************************************************

@ChopperApi()
abstract class Openapi extends ChopperService {
  static Openapi create({
    ChopperClient? client,
    http.Client? httpClient,
    Authenticator? authenticator,
    ErrorConverter? errorConverter,
    Converter? converter,
    Uri? baseUrl,
    List<Interceptor>? interceptors,
  }) {
    if (client != null) {
      return _$Openapi(client);
    }

    final newClient = ChopperClient(
      services: [_$Openapi()],
      converter: converter ?? $JsonSerializableConverter(),
      interceptors: interceptors ?? [],
      client: httpClient,
      authenticator: authenticator,
      errorConverter: errorConverter,
      baseUrl: baseUrl ?? Uri.parse('http://'),
    );
    return _$Openapi(newClient);
  }

  ///Get job configuration by ID
  ///@param id Job configuration ID
  Future<chopper.Response<JobConfigurationDto>> apiV1JobConfigurationsIdGet({
    required String? id,
  }) {
    generatedMapping.putIfAbsent(
      JobConfigurationDto,
      () => JobConfigurationDto.fromJsonFactory,
    );

    return _apiV1JobConfigurationsIdGet(id: id);
  }

  ///Get job configuration by ID
  ///@param id Job configuration ID
  @GET(path: '/api/v1/job-configurations/{id}')
  Future<chopper.Response<JobConfigurationDto>> _apiV1JobConfigurationsIdGet({
    @Path('id') required String? id,
  });

  ///Update job configuration
  ///@param id Job configuration ID
  Future<chopper.Response<JobConfigurationDto>> apiV1JobConfigurationsIdPut({
    required String? id,
    required UpdateJobConfigurationRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      JobConfigurationDto,
      () => JobConfigurationDto.fromJsonFactory,
    );

    return _apiV1JobConfigurationsIdPut(id: id, body: body);
  }

  ///Update job configuration
  ///@param id Job configuration ID
  @PUT(path: '/api/v1/job-configurations/{id}', optionalBody: true)
  Future<chopper.Response<JobConfigurationDto>> _apiV1JobConfigurationsIdPut({
    @Path('id') required String? id,
    @Body() required UpdateJobConfigurationRequest? body,
  });

  ///Delete job configuration
  ///@param id Job configuration ID
  Future<chopper.Response> apiV1JobConfigurationsIdDelete({
    required String? id,
  }) {
    return _apiV1JobConfigurationsIdDelete(id: id);
  }

  ///Delete job configuration
  ///@param id Job configuration ID
  @DELETE(path: '/api/v1/job-configurations/{id}')
  Future<chopper.Response> _apiV1JobConfigurationsIdDelete({
    @Path('id') required String? id,
  });

  ///
  ///@param userId
  ///@param key
  ///@param defaultValue
  Future<chopper.Response<Object>> apiSettingsUserUserIdKeyGet({
    required String? userId,
    required String? key,
    String? defaultValue,
  }) {
    return _apiSettingsUserUserIdKeyGet(
      userId: userId,
      key: key,
      defaultValue: defaultValue,
    );
  }

  ///
  ///@param userId
  ///@param key
  ///@param defaultValue
  @GET(path: '/api/settings/user/{userId}/{key}')
  Future<chopper.Response<Object>> _apiSettingsUserUserIdKeyGet({
    @Path('userId') required String? userId,
    @Path('key') required String? key,
    @Query('defaultValue') String? defaultValue,
  });

  ///
  ///@param userId
  ///@param key
  Future<chopper.Response<Object>> apiSettingsUserUserIdKeyPut({
    required String? userId,
    required String? key,
    required Object? body,
  }) {
    return _apiSettingsUserUserIdKeyPut(userId: userId, key: key, body: body);
  }

  ///
  ///@param userId
  ///@param key
  @PUT(path: '/api/settings/user/{userId}/{key}', optionalBody: true)
  Future<chopper.Response<Object>> _apiSettingsUserUserIdKeyPut({
    @Path('userId') required String? userId,
    @Path('key') required String? key,
    @Body() required Object? body,
  });

  ///Get MCP configuration
  ///@param configId Configuration ID
  Future<chopper.Response<Object>> apiMcpConfigurationsConfigIdGet({
    required String? configId,
  }) {
    return _apiMcpConfigurationsConfigIdGet(configId: configId);
  }

  ///Get MCP configuration
  ///@param configId Configuration ID
  @GET(path: '/api/mcp/configurations/{configId}')
  Future<chopper.Response<Object>> _apiMcpConfigurationsConfigIdGet({
    @Path('configId') required String? configId,
  });

  ///Update MCP configuration
  ///@param configId Configuration ID
  Future<chopper.Response<Object>> apiMcpConfigurationsConfigIdPut({
    required String? configId,
    required CreateMcpConfigurationRequest? body,
  }) {
    return _apiMcpConfigurationsConfigIdPut(configId: configId, body: body);
  }

  ///Update MCP configuration
  ///@param configId Configuration ID
  @PUT(path: '/api/mcp/configurations/{configId}', optionalBody: true)
  Future<chopper.Response<Object>> _apiMcpConfigurationsConfigIdPut({
    @Path('configId') required String? configId,
    @Body() required CreateMcpConfigurationRequest? body,
  });

  ///Delete MCP configuration
  ///@param configId Configuration ID
  Future<chopper.Response<Object>> apiMcpConfigurationsConfigIdDelete({
    required String? configId,
  }) {
    return _apiMcpConfigurationsConfigIdDelete(configId: configId);
  }

  ///Delete MCP configuration
  ///@param configId Configuration ID
  @DELETE(path: '/api/mcp/configurations/{configId}')
  Future<chopper.Response<Object>> _apiMcpConfigurationsConfigIdDelete({
    @Path('configId') required String? configId,
  });

  ///Get integration by ID
  ///@param id
  ///@param includeSensitive
  Future<chopper.Response<IntegrationDto>> apiIntegrationsIdGet({
    required String? id,
    bool? includeSensitive,
  }) {
    generatedMapping.putIfAbsent(
      IntegrationDto,
      () => IntegrationDto.fromJsonFactory,
    );

    return _apiIntegrationsIdGet(id: id, includeSensitive: includeSensitive);
  }

  ///Get integration by ID
  ///@param id
  ///@param includeSensitive
  @GET(path: '/api/integrations/{id}')
  Future<chopper.Response<IntegrationDto>> _apiIntegrationsIdGet({
    @Path('id') required String? id,
    @Query('includeSensitive') bool? includeSensitive,
  });

  ///Update integration
  ///@param id
  Future<chopper.Response<IntegrationDto>> apiIntegrationsIdPut({
    required String? id,
    required UpdateIntegrationRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      IntegrationDto,
      () => IntegrationDto.fromJsonFactory,
    );

    return _apiIntegrationsIdPut(id: id, body: body);
  }

  ///Update integration
  ///@param id
  @PUT(path: '/api/integrations/{id}', optionalBody: true)
  Future<chopper.Response<IntegrationDto>> _apiIntegrationsIdPut({
    @Path('id') required String? id,
    @Body() required UpdateIntegrationRequest? body,
  });

  ///Delete integration
  ///@param id
  Future<chopper.Response> apiIntegrationsIdDelete({required String? id}) {
    return _apiIntegrationsIdDelete(id: id);
  }

  ///Delete integration
  ///@param id
  @DELETE(path: '/api/integrations/{id}')
  Future<chopper.Response> _apiIntegrationsIdDelete({
    @Path('id') required String? id,
  });

  ///Enable integration
  ///@param id
  Future<chopper.Response<IntegrationDto>> apiIntegrationsIdEnablePut({
    required String? id,
  }) {
    generatedMapping.putIfAbsent(
      IntegrationDto,
      () => IntegrationDto.fromJsonFactory,
    );

    return _apiIntegrationsIdEnablePut(id: id);
  }

  ///Enable integration
  ///@param id
  @PUT(path: '/api/integrations/{id}/enable', optionalBody: true)
  Future<chopper.Response<IntegrationDto>> _apiIntegrationsIdEnablePut({
    @Path('id') required String? id,
  });

  ///Disable integration
  ///@param id
  Future<chopper.Response<IntegrationDto>> apiIntegrationsIdDisablePut({
    required String? id,
  }) {
    generatedMapping.putIfAbsent(
      IntegrationDto,
      () => IntegrationDto.fromJsonFactory,
    );

    return _apiIntegrationsIdDisablePut(id: id);
  }

  ///Disable integration
  ///@param id
  @PUT(path: '/api/integrations/{id}/disable', optionalBody: true)
  Future<chopper.Response<IntegrationDto>> _apiIntegrationsIdDisablePut({
    @Path('id') required String? id,
  });

  ///
  Future<chopper.Response<String>> shutdownPost() {
    return _shutdownPost();
  }

  ///
  @POST(path: '/shutdown', optionalBody: true)
  Future<chopper.Response<String>> _shutdownPost();

  ///
  ///@param userId
  Future<chopper.Response<Object>> mcpPost({
    String? userId,
    required Object? body,
  }) {
    return _mcpPost(userId: userId, body: body);
  }

  ///
  ///@param userId
  @POST(path: '/mcp', optionalBody: true)
  Future<chopper.Response<Object>> _mcpPost({
    @Query('userId') String? userId,
    @Body() required Object? body,
  });

  ///
  Future<chopper.Response<List<WorkspaceDto>>> apiWorkspacesGet() {
    generatedMapping.putIfAbsent(
      WorkspaceDto,
      () => WorkspaceDto.fromJsonFactory,
    );

    return _apiWorkspacesGet();
  }

  ///
  @GET(path: '/api/workspaces')
  Future<chopper.Response<List<WorkspaceDto>>> _apiWorkspacesGet();

  ///
  Future<chopper.Response<WorkspaceDto>> apiWorkspacesPost({
    required CreateWorkspaceRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      WorkspaceDto,
      () => WorkspaceDto.fromJsonFactory,
    );

    return _apiWorkspacesPost(body: body);
  }

  ///
  @POST(path: '/api/workspaces', optionalBody: true)
  Future<chopper.Response<WorkspaceDto>> _apiWorkspacesPost({
    @Body() required CreateWorkspaceRequest? body,
  });

  ///
  ///@param workspaceId
  Future<chopper.Response<Object>> apiWorkspacesWorkspaceIdSharePost({
    required String? workspaceId,
    required ShareWorkspaceRequest? body,
  }) {
    return _apiWorkspacesWorkspaceIdSharePost(
      workspaceId: workspaceId,
      body: body,
    );
  }

  ///
  ///@param workspaceId
  @POST(path: '/api/workspaces/{workspaceId}/share', optionalBody: true)
  Future<chopper.Response<Object>> _apiWorkspacesWorkspaceIdSharePost({
    @Path('workspaceId') required String? workspaceId,
    @Body() required ShareWorkspaceRequest? body,
  });

  ///
  Future<chopper.Response<WorkspaceDto>> apiWorkspacesDefaultPost() {
    generatedMapping.putIfAbsent(
      WorkspaceDto,
      () => WorkspaceDto.fromJsonFactory,
    );

    return _apiWorkspacesDefaultPost();
  }

  ///
  @POST(path: '/api/workspaces/default', optionalBody: true)
  Future<chopper.Response<WorkspaceDto>> _apiWorkspacesDefaultPost();

  ///Execute a job in server-managed mode (async)
  Future<chopper.Response<JobExecutionResponse>> apiV1JobsExecutePost({
    required JobExecutionRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      JobExecutionResponse,
      () => JobExecutionResponse.fromJsonFactory,
    );

    return _apiV1JobsExecutePost(body: body);
  }

  ///Execute a job in server-managed mode (async)
  @POST(path: '/api/v1/jobs/execute', optionalBody: true)
  Future<chopper.Response<JobExecutionResponse>> _apiV1JobsExecutePost({
    @Body() required JobExecutionRequest? body,
  });

  ///Execute a saved job configuration (async)
  ///@param configId Job configuration ID
  Future<chopper.Response<JobExecutionResponse>>
  apiV1JobsConfigurationsConfigIdExecutePost({
    required String? configId,
    required ExecuteJobConfigurationRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      JobExecutionResponse,
      () => JobExecutionResponse.fromJsonFactory,
    );

    return _apiV1JobsConfigurationsConfigIdExecutePost(
      configId: configId,
      body: body,
    );
  }

  ///Execute a saved job configuration (async)
  ///@param configId Job configuration ID
  @POST(
    path: '/api/v1/jobs/configurations/{configId}/execute',
    optionalBody: true,
  )
  Future<chopper.Response<JobExecutionResponse>>
  _apiV1JobsConfigurationsConfigIdExecutePost({
    @Path('configId') required String? configId,
    @Body() required ExecuteJobConfigurationRequest? body,
  });

  ///Get all job configurations
  ///@param enabled Only return enabled configurations
  Future<chopper.Response<List<JobConfigurationDto>>>
  apiV1JobConfigurationsGet({bool? enabled}) {
    generatedMapping.putIfAbsent(
      JobConfigurationDto,
      () => JobConfigurationDto.fromJsonFactory,
    );

    return _apiV1JobConfigurationsGet(enabled: enabled);
  }

  ///Get all job configurations
  ///@param enabled Only return enabled configurations
  @GET(path: '/api/v1/job-configurations')
  Future<chopper.Response<List<JobConfigurationDto>>>
  _apiV1JobConfigurationsGet({@Query('enabled') bool? enabled});

  ///Create a new job configuration
  Future<chopper.Response<JobConfigurationDto>> apiV1JobConfigurationsPost({
    required CreateJobConfigurationRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      JobConfigurationDto,
      () => JobConfigurationDto.fromJsonFactory,
    );

    return _apiV1JobConfigurationsPost(body: body);
  }

  ///Create a new job configuration
  @POST(path: '/api/v1/job-configurations', optionalBody: true)
  Future<chopper.Response<JobConfigurationDto>> _apiV1JobConfigurationsPost({
    @Body() required CreateJobConfigurationRequest? body,
  });

  ///Webhook endpoint for job execution
  ///@param id Job configuration ID
  ///@param X-API-Key API key for authentication (future enhancement)
  Future<chopper.Response<Object>> apiV1JobConfigurationsIdWebhookPost({
    required String? id,
    String? xAPIKey,
    required ExecuteJobConfigurationRequest? body,
  }) {
    return _apiV1JobConfigurationsIdWebhookPost(
      id: id,
      xAPIKey: xAPIKey?.toString(),
      body: body,
    );
  }

  ///Webhook endpoint for job execution
  ///@param id Job configuration ID
  ///@param X-API-Key API key for authentication (future enhancement)
  @POST(path: '/api/v1/job-configurations/{id}/webhook', optionalBody: true)
  Future<chopper.Response<Object>> _apiV1JobConfigurationsIdWebhookPost({
    @Path('id') required String? id,
    @Header('X-API-Key') String? xAPIKey,
    @Body() required ExecuteJobConfigurationRequest? body,
  });

  ///Execute a saved job configuration
  ///@param id Job configuration ID
  Future<chopper.Response<ExecutionParametersDto>>
  apiV1JobConfigurationsIdExecutePost({
    required String? id,
    required ExecuteJobConfigurationRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      ExecutionParametersDto,
      () => ExecutionParametersDto.fromJsonFactory,
    );

    return _apiV1JobConfigurationsIdExecutePost(id: id, body: body);
  }

  ///Execute a saved job configuration
  ///@param id Job configuration ID
  @POST(path: '/api/v1/job-configurations/{id}/execute', optionalBody: true)
  Future<chopper.Response<ExecutionParametersDto>>
  _apiV1JobConfigurationsIdExecutePost({
    @Path('id') required String? id,
    @Body() required ExecuteJobConfigurationRequest? body,
  });

  ///
  ///@param message
  ///@param model
  Future<chopper.Response<ChatResponse>> apiV1ChatSimplePost({
    required String? message,
    String? model,
  }) {
    generatedMapping.putIfAbsent(
      ChatResponse,
      () => ChatResponse.fromJsonFactory,
    );

    return _apiV1ChatSimplePost(message: message, model: model);
  }

  ///
  ///@param message
  ///@param model
  @POST(path: '/api/v1/chat/simple', optionalBody: true)
  Future<chopper.Response<ChatResponse>> _apiV1ChatSimplePost({
    @Query('message') required String? message,
    @Query('model') String? model,
  });

  ///
  Future<chopper.Response<ChatResponse>> apiV1ChatCompletionsPost({
    required ChatRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      ChatResponse,
      () => ChatResponse.fromJsonFactory,
    );

    return _apiV1ChatCompletionsPost(body: body);
  }

  ///
  @POST(path: '/api/v1/chat/completions', optionalBody: true)
  Future<chopper.Response<ChatResponse>> _apiV1ChatCompletionsPost({
    @Body() required ChatRequest? body,
  });

  ///
  ///@param chatRequest
  Future<chopper.Response<ChatResponse>> apiV1ChatCompletionsWithFilesPost({
    required String? chatRequest,
    required List<List<int>> files,
  }) {
    generatedMapping.putIfAbsent(
      ChatResponse,
      () => ChatResponse.fromJsonFactory,
    );

    return _apiV1ChatCompletionsWithFilesPost(
      chatRequest: chatRequest,
      files: files,
    );
  }

  ///
  ///@param chatRequest
  @POST(path: '/api/v1/chat/completions-with-files', optionalBody: true)
  @Multipart()
  Future<chopper.Response<ChatResponse>> _apiV1ChatCompletionsWithFilesPost({
    @Query('chatRequest') required String? chatRequest,
    @PartFile() required List<List<int>> files,
  });

  ///
  Future<chopper.Response<AgentExecutionResponse>>
  apiV1AgentsOrchestratorsExecutePost({required AgentExecutionRequest? body}) {
    generatedMapping.putIfAbsent(
      AgentExecutionResponse,
      () => AgentExecutionResponse.fromJsonFactory,
    );

    return _apiV1AgentsOrchestratorsExecutePost(body: body);
  }

  ///
  @POST(path: '/api/v1/agents/orchestrators/execute', optionalBody: true)
  Future<chopper.Response<AgentExecutionResponse>>
  _apiV1AgentsOrchestratorsExecutePost({
    @Body() required AgentExecutionRequest? body,
  });

  ///
  ///@param orchestratorName
  Future<chopper.Response<AgentExecutionResponse>>
  apiV1AgentsOrchestratorsExecuteOrchestratorNamePost({
    required String? orchestratorName,
    required Object? body,
  }) {
    generatedMapping.putIfAbsent(
      AgentExecutionResponse,
      () => AgentExecutionResponse.fromJsonFactory,
    );

    return _apiV1AgentsOrchestratorsExecuteOrchestratorNamePost(
      orchestratorName: orchestratorName,
      body: body,
    );
  }

  ///
  ///@param orchestratorName
  @POST(
    path: '/api/v1/agents/orchestrators/execute/{orchestratorName}',
    optionalBody: true,
  )
  Future<chopper.Response<AgentExecutionResponse>>
  _apiV1AgentsOrchestratorsExecuteOrchestratorNamePost({
    @Path('orchestratorName') required String? orchestratorName,
    @Body() required Object? body,
  });

  ///
  Future<chopper.Response<AgentExecutionResponse>> apiV1AgentsExecutePost({
    required AgentExecutionRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      AgentExecutionResponse,
      () => AgentExecutionResponse.fromJsonFactory,
    );

    return _apiV1AgentsExecutePost(body: body);
  }

  ///
  @POST(path: '/api/v1/agents/execute', optionalBody: true)
  Future<chopper.Response<AgentExecutionResponse>> _apiV1AgentsExecutePost({
    @Body() required AgentExecutionRequest? body,
  });

  ///
  ///@param agentName
  Future<chopper.Response<AgentExecutionResponse>>
  apiV1AgentsExecuteAgentNamePost({
    required String? agentName,
    required Object? body,
  }) {
    generatedMapping.putIfAbsent(
      AgentExecutionResponse,
      () => AgentExecutionResponse.fromJsonFactory,
    );

    return _apiV1AgentsExecuteAgentNamePost(agentName: agentName, body: body);
  }

  ///
  ///@param agentName
  @POST(path: '/api/v1/agents/execute/{agentName}', optionalBody: true)
  Future<chopper.Response<AgentExecutionResponse>>
  _apiV1AgentsExecuteAgentNamePost({
    @Path('agentName') required String? agentName,
    @Body() required Object? body,
  });

  ///
  ///@param userId
  Future<chopper.Response<Object>> apiSettingsUserUserIdGet({
    required String? userId,
  }) {
    return _apiSettingsUserUserIdGet(userId: userId);
  }

  ///
  ///@param userId
  @GET(path: '/api/settings/user/{userId}')
  Future<chopper.Response<Object>> _apiSettingsUserUserIdGet({
    @Path('userId') required String? userId,
  });

  ///
  ///@param userId
  Future<chopper.Response<Object>> apiSettingsUserUserIdPost({
    required String? userId,
    required Object? body,
  }) {
    return _apiSettingsUserUserIdPost(userId: userId, body: body);
  }

  ///
  ///@param userId
  @POST(path: '/api/settings/user/{userId}', optionalBody: true)
  Future<chopper.Response<Object>> _apiSettingsUserUserIdPost({
    @Path('userId') required String? userId,
    @Body() required Object? body,
  });

  ///
  ///@param userRequest
  Future<chopper.Response<String>> apiPresentationScriptPost({
    required String? userRequest,
    required ApiPresentationScriptPost$RequestBody? body,
  }) {
    return _apiPresentationScriptPost(userRequest: userRequest, body: body);
  }

  ///
  ///@param userRequest
  @POST(path: '/api/presentation/script', optionalBody: true)
  Future<chopper.Response<String>> _apiPresentationScriptPost({
    @Query('userRequest') required String? userRequest,
    @Body() required ApiPresentationScriptPost$RequestBody? body,
  });

  ///
  Future<chopper.Response<String>> apiPresentationGeneratePost({
    required GeneratePresentationRequest? body,
  }) {
    return _apiPresentationGeneratePost(body: body);
  }

  ///
  @POST(path: '/api/presentation/generate', optionalBody: true)
  Future<chopper.Response<String>> _apiPresentationGeneratePost({
    @Body() required GeneratePresentationRequest? body,
  });

  ///
  Future<chopper.Response<Object>> apiOauthProxyInitiatePost({
    required OAuthInitiateRequest? body,
  }) {
    return _apiOauthProxyInitiatePost(body: body);
  }

  ///
  @POST(path: '/api/oauth-proxy/initiate', optionalBody: true)
  Future<chopper.Response<Object>> _apiOauthProxyInitiatePost({
    @Body() required OAuthInitiateRequest? body,
  });

  ///
  Future<chopper.Response<Object>> apiOauthProxyExchangePost({
    required OAuthExchangeRequest? body,
  }) {
    return _apiOauthProxyExchangePost(body: body);
  }

  ///
  @POST(path: '/api/oauth-proxy/exchange', optionalBody: true)
  Future<chopper.Response<Object>> _apiOauthProxyExchangePost({
    @Body() required OAuthExchangeRequest? body,
  });

  ///Get MCP configurations
  Future<chopper.Response<List<McpConfigurationDto>>>
  apiMcpConfigurationsGet() {
    generatedMapping.putIfAbsent(
      McpConfigurationDto,
      () => McpConfigurationDto.fromJsonFactory,
    );

    return _apiMcpConfigurationsGet();
  }

  ///Get MCP configurations
  @GET(path: '/api/mcp/configurations')
  Future<chopper.Response<List<McpConfigurationDto>>>
  _apiMcpConfigurationsGet();

  ///Create MCP configuration
  Future<chopper.Response<Object>> apiMcpConfigurationsPost({
    required CreateMcpConfigurationRequest? body,
  }) {
    return _apiMcpConfigurationsPost(body: body);
  }

  ///Create MCP configuration
  @POST(path: '/api/mcp/configurations', optionalBody: true)
  Future<chopper.Response<Object>> _apiMcpConfigurationsPost({
    @Body() required CreateMcpConfigurationRequest? body,
  });

  ///Get all integrations
  Future<chopper.Response<List<IntegrationDto>>> apiIntegrationsGet() {
    generatedMapping.putIfAbsent(
      IntegrationDto,
      () => IntegrationDto.fromJsonFactory,
    );

    return _apiIntegrationsGet();
  }

  ///Get all integrations
  @GET(path: '/api/integrations')
  Future<chopper.Response<List<IntegrationDto>>> _apiIntegrationsGet();

  ///Create integration
  Future<chopper.Response<IntegrationDto>> apiIntegrationsPost({
    required CreateIntegrationRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      IntegrationDto,
      () => IntegrationDto.fromJsonFactory,
    );

    return _apiIntegrationsPost(body: body);
  }

  ///Create integration
  @POST(path: '/api/integrations', optionalBody: true)
  Future<chopper.Response<IntegrationDto>> _apiIntegrationsPost({
    @Body() required CreateIntegrationRequest? body,
  });

  ///Share integration with workspace
  ///@param id
  Future<chopper.Response<WorkspaceDto>> apiIntegrationsIdWorkspacesPost({
    required String? id,
    required ShareIntegrationWithWorkspaceRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      WorkspaceDto,
      () => WorkspaceDto.fromJsonFactory,
    );

    return _apiIntegrationsIdWorkspacesPost(id: id, body: body);
  }

  ///Share integration with workspace
  ///@param id
  @POST(path: '/api/integrations/{id}/workspaces', optionalBody: true)
  Future<chopper.Response<WorkspaceDto>> _apiIntegrationsIdWorkspacesPost({
    @Path('id') required String? id,
    @Body() required ShareIntegrationWithWorkspaceRequest? body,
  });

  ///Share integration with user
  ///@param id
  Future<chopper.Response<IntegrationUserDto>> apiIntegrationsIdUsersPost({
    required String? id,
    required ShareIntegrationRequest? body,
  }) {
    generatedMapping.putIfAbsent(
      IntegrationUserDto,
      () => IntegrationUserDto.fromJsonFactory,
    );

    return _apiIntegrationsIdUsersPost(id: id, body: body);
  }

  ///Share integration with user
  ///@param id
  @POST(path: '/api/integrations/{id}/users', optionalBody: true)
  Future<chopper.Response<IntegrationUserDto>> _apiIntegrationsIdUsersPost({
    @Path('id') required String? id,
    @Body() required ShareIntegrationRequest? body,
  });

  ///Record integration usage
  ///@param id
  Future<chopper.Response> apiIntegrationsIdUsagePost({required String? id}) {
    return _apiIntegrationsIdUsagePost(id: id);
  }

  ///Record integration usage
  ///@param id
  @POST(path: '/api/integrations/{id}/usage', optionalBody: true)
  Future<chopper.Response> _apiIntegrationsIdUsagePost({
    @Path('id') required String? id,
  });

  ///Test integration
  Future<chopper.Response<Object>> apiIntegrationsTestPost({
    required TestIntegrationRequest? body,
  }) {
    return _apiIntegrationsTestPost(body: body);
  }

  ///Test integration
  @POST(path: '/api/integrations/test', optionalBody: true)
  Future<chopper.Response<Object>> _apiIntegrationsTestPost({
    @Body() required TestIntegrationRequest? body,
  });

  ///Execute a job
  Future<chopper.Response<String>> apiExecuteJobPost({required String? body}) {
    return _apiExecuteJobPost(body: body);
  }

  ///Execute a job
  @POST(path: '/api/executeJob', optionalBody: true)
  Future<chopper.Response<String>> _apiExecuteJobPost({
    @Body() required String? body,
  });

  ///
  Future<chopper.Response<Object>> apiAuthLogoutPost() {
    return _apiAuthLogoutPost();
  }

  ///
  @POST(path: '/api/auth/logout', optionalBody: true)
  Future<chopper.Response<Object>> _apiAuthLogoutPost();

  ///
  Future<chopper.Response<Object>> apiAuthLocalLoginPost({
    required Object? body,
  }) {
    return _apiAuthLocalLoginPost(body: body);
  }

  ///
  @POST(path: '/api/auth/local-login', optionalBody: true)
  Future<chopper.Response<Object>> _apiAuthLocalLoginPost({
    @Body() required Object? body,
  });

  ///
  ///@param userId
  Future<chopper.Response<Object>> mcpToolsUserIdGet({
    required String? userId,
  }) {
    return _mcpToolsUserIdGet(userId: userId);
  }

  ///
  ///@param userId
  @GET(path: '/mcp/tools/{userId}')
  Future<chopper.Response<Object>> _mcpToolsUserIdGet({
    @Path('userId') required String? userId,
  });

  ///
  Future<chopper.Response<Object>> mcpHealthGet() {
    return _mcpHealthGet();
  }

  ///
  @GET(path: '/mcp/health')
  Future<chopper.Response<Object>> _mcpHealthGet();

  ///
  Future<chopper.Response<bool>> isLocalGet() {
    return _isLocalGet();
  }

  ///
  @GET(path: '/is-local')
  Future<chopper.Response<bool>> _isLocalGet();

  ///
  ///@param workspaceId
  Future<chopper.Response<WorkspaceDto>> apiWorkspacesWorkspaceIdGet({
    required String? workspaceId,
  }) {
    generatedMapping.putIfAbsent(
      WorkspaceDto,
      () => WorkspaceDto.fromJsonFactory,
    );

    return _apiWorkspacesWorkspaceIdGet(workspaceId: workspaceId);
  }

  ///
  ///@param workspaceId
  @GET(path: '/api/workspaces/{workspaceId}')
  Future<chopper.Response<WorkspaceDto>> _apiWorkspacesWorkspaceIdGet({
    @Path('workspaceId') required String? workspaceId,
  });

  ///
  ///@param workspaceId
  Future<chopper.Response> apiWorkspacesWorkspaceIdDelete({
    required String? workspaceId,
  }) {
    return _apiWorkspacesWorkspaceIdDelete(workspaceId: workspaceId);
  }

  ///
  ///@param workspaceId
  @DELETE(path: '/api/workspaces/{workspaceId}')
  Future<chopper.Response> _apiWorkspacesWorkspaceIdDelete({
    @Path('workspaceId') required String? workspaceId,
  });

  ///Get required integrations for a job
  ///@param jobName Name of the job
  Future<chopper.Response> apiV1JobsJobNameIntegrationsGet({
    required String? jobName,
  }) {
    return _apiV1JobsJobNameIntegrationsGet(jobName: jobName);
  }

  ///Get required integrations for a job
  ///@param jobName Name of the job
  @GET(path: '/api/v1/jobs/{jobName}/integrations')
  Future<chopper.Response> _apiV1JobsJobNameIntegrationsGet({
    @Path('jobName') required String? jobName,
  });

  ///Get job types
  Future<chopper.Response> apiV1JobsTypesGet() {
    return _apiV1JobsTypesGet();
  }

  ///Get job types
  @GET(path: '/api/v1/jobs/types')
  Future<chopper.Response> _apiV1JobsTypesGet();

  ///Get job type details
  ///@param jobName Name of the job type
  Future<chopper.Response<JobTypeDto>> apiV1JobsTypesJobNameGet({
    required String? jobName,
  }) {
    generatedMapping.putIfAbsent(JobTypeDto, () => JobTypeDto.fromJsonFactory);

    return _apiV1JobsTypesJobNameGet(jobName: jobName);
  }

  ///Get job type details
  ///@param jobName Name of the job type
  @GET(path: '/api/v1/jobs/types/{jobName}')
  Future<chopper.Response<JobTypeDto>> _apiV1JobsTypesJobNameGet({
    @Path('jobName') required String? jobName,
  });

  ///Get job execution status
  ///@param executionId Job execution ID
  Future<chopper.Response<JobExecutionStatusResponse>>
  apiV1JobsExecutionsExecutionIdStatusGet({required String? executionId}) {
    generatedMapping.putIfAbsent(
      JobExecutionStatusResponse,
      () => JobExecutionStatusResponse.fromJsonFactory,
    );

    return _apiV1JobsExecutionsExecutionIdStatusGet(executionId: executionId);
  }

  ///Get job execution status
  ///@param executionId Job execution ID
  @GET(path: '/api/v1/jobs/executions/{executionId}/status')
  Future<chopper.Response<JobExecutionStatusResponse>>
  _apiV1JobsExecutionsExecutionIdStatusGet({
    @Path('executionId') required String? executionId,
  });

  ///Get available jobs
  Future<chopper.Response> apiV1JobsAvailableGet() {
    return _apiV1JobsAvailableGet();
  }

  ///Get available jobs
  @GET(path: '/api/v1/jobs/available')
  Future<chopper.Response> _apiV1JobsAvailableGet();

  ///
  Future<chopper.Response<String>> apiV1ChatHealthGet() {
    return _apiV1ChatHealthGet();
  }

  ///
  @GET(path: '/api/v1/chat/health')
  Future<chopper.Response<String>> _apiV1ChatHealthGet();

  ///
  ///@param detailed
  Future<chopper.Response<Object>> apiV1AgentsOrchestratorsGet({
    bool? detailed,
  }) {
    return _apiV1AgentsOrchestratorsGet(detailed: detailed);
  }

  ///
  ///@param detailed
  @GET(path: '/api/v1/agents/orchestrators')
  Future<chopper.Response<Object>> _apiV1AgentsOrchestratorsGet({
    @Query('detailed') bool? detailed,
  });

  ///
  ///@param orchestratorName
  Future<chopper.Response<AgentInfo>>
  apiV1AgentsOrchestratorsOrchestratorNameInfoGet({
    required String? orchestratorName,
  }) {
    generatedMapping.putIfAbsent(AgentInfo, () => AgentInfo.fromJsonFactory);

    return _apiV1AgentsOrchestratorsOrchestratorNameInfoGet(
      orchestratorName: orchestratorName,
    );
  }

  ///
  ///@param orchestratorName
  @GET(path: '/api/v1/agents/orchestrators/{orchestratorName}/info')
  Future<chopper.Response<AgentInfo>>
  _apiV1AgentsOrchestratorsOrchestratorNameInfoGet({
    @Path('orchestratorName') required String? orchestratorName,
  });

  ///
  Future<chopper.Response<String>> apiV1AgentsHealthGet() {
    return _apiV1AgentsHealthGet();
  }

  ///
  @GET(path: '/api/v1/agents/health')
  Future<chopper.Response<String>> _apiV1AgentsHealthGet();

  ///
  ///@param detailed
  Future<chopper.Response<AgentListResponse>> apiV1AgentsAvailableGet({
    bool? detailed,
  }) {
    generatedMapping.putIfAbsent(
      AgentListResponse,
      () => AgentListResponse.fromJsonFactory,
    );

    return _apiV1AgentsAvailableGet(detailed: detailed);
  }

  ///
  ///@param detailed
  @GET(path: '/api/v1/agents/available')
  Future<chopper.Response<AgentListResponse>> _apiV1AgentsAvailableGet({
    @Query('detailed') bool? detailed,
  });

  ///
  ///@param detailed
  Future<chopper.Response<Object>> apiV1AgentsAgentsGet({bool? detailed}) {
    return _apiV1AgentsAgentsGet(detailed: detailed);
  }

  ///
  ///@param detailed
  @GET(path: '/api/v1/agents/agents')
  Future<chopper.Response<Object>> _apiV1AgentsAgentsGet({
    @Query('detailed') bool? detailed,
  });

  ///
  ///@param agentName
  Future<chopper.Response<AgentInfo>> apiV1AgentsAgentsAgentNameInfoGet({
    required String? agentName,
  }) {
    generatedMapping.putIfAbsent(AgentInfo, () => AgentInfo.fromJsonFactory);

    return _apiV1AgentsAgentsAgentNameInfoGet(agentName: agentName);
  }

  ///
  ///@param agentName
  @GET(path: '/api/v1/agents/agents/{agentName}/info')
  Future<chopper.Response<AgentInfo>> _apiV1AgentsAgentsAgentNameInfoGet({
    @Path('agentName') required String? agentName,
  });

  ///
  Future<chopper.Response<String>> apiPresentationHealthGet() {
    return _apiPresentationHealthGet();
  }

  ///
  @GET(path: '/api/presentation/health')
  Future<chopper.Response<String>> _apiPresentationHealthGet();

  ///
  Future<chopper.Response<Object>> apiOauthProxyProvidersGet() {
    return _apiOauthProxyProvidersGet();
  }

  ///
  @GET(path: '/api/oauth-proxy/providers')
  Future<chopper.Response<Object>> _apiOauthProxyProvidersGet();

  ///Generate access code
  ///@param configId Configuration ID
  ///@param format Output format for the configuration code
  Future<chopper.Response<Object>> apiMcpConfigurationsConfigIdAccessCodeGet({
    required String? configId,
    String? format,
  }) {
    return _apiMcpConfigurationsConfigIdAccessCodeGet(
      configId: configId,
      format: format,
    );
  }

  ///Generate access code
  ///@param configId Configuration ID
  ///@param format Output format for the configuration code
  @GET(path: '/api/mcp/configurations/{configId}/access-code')
  Future<chopper.Response<Object>> _apiMcpConfigurationsConfigIdAccessCodeGet({
    @Path('configId') required String? configId,
    @Query('format') String? format,
  });

  ///Get workspace integrations
  ///@param workspaceId
  Future<chopper.Response<List<IntegrationDto>>>
  apiIntegrationsWorkspaceWorkspaceIdGet({required String? workspaceId}) {
    generatedMapping.putIfAbsent(
      IntegrationDto,
      () => IntegrationDto.fromJsonFactory,
    );

    return _apiIntegrationsWorkspaceWorkspaceIdGet(workspaceId: workspaceId);
  }

  ///Get workspace integrations
  ///@param workspaceId
  @GET(path: '/api/integrations/workspace/{workspaceId}')
  Future<chopper.Response<List<IntegrationDto>>>
  _apiIntegrationsWorkspaceWorkspaceIdGet({
    @Path('workspaceId') required String? workspaceId,
  });

  ///Get integration types
  Future<chopper.Response<List<IntegrationTypeDto>>> apiIntegrationsTypesGet() {
    generatedMapping.putIfAbsent(
      IntegrationTypeDto,
      () => IntegrationTypeDto.fromJsonFactory,
    );

    return _apiIntegrationsTypesGet();
  }

  ///Get integration types
  @GET(path: '/api/integrations/types')
  Future<chopper.Response<List<IntegrationTypeDto>>> _apiIntegrationsTypesGet();

  ///Get integration type schema
  ///@param type
  Future<chopper.Response<IntegrationTypeDto>>
  apiIntegrationsTypesTypeSchemaGet({required String? type}) {
    generatedMapping.putIfAbsent(
      IntegrationTypeDto,
      () => IntegrationTypeDto.fromJsonFactory,
    );

    return _apiIntegrationsTypesTypeSchemaGet(type: type);
  }

  ///Get integration type schema
  ///@param type
  @GET(path: '/api/integrations/types/{type}/schema')
  Future<chopper.Response<IntegrationTypeDto>>
  _apiIntegrationsTypesTypeSchemaGet({@Path('type') required String? type});

  ///Get integration setup documentation
  ///@param type
  ///@param locale
  Future<chopper.Response<String>> apiIntegrationsTypesTypeDocumentationGet({
    required String? type,
    String? locale,
  }) {
    return _apiIntegrationsTypesTypeDocumentationGet(
      type: type,
      locale: locale,
    );
  }

  ///Get integration setup documentation
  ///@param type
  ///@param locale
  @GET(path: '/api/integrations/types/{type}/documentation')
  Future<chopper.Response<String>> _apiIntegrationsTypesTypeDocumentationGet({
    @Path('type') required String? type,
    @Query('locale') String? locale,
  });

  ///
  Future<chopper.Response<Object>> apiHealthGet() {
    return _apiHealthGet();
  }

  ///
  @GET(path: '/api/health')
  Future<chopper.Response<Object>> _apiHealthGet();

  ///
  Future<chopper.Response<String>> apiHealthSimpleGet() {
    return _apiHealthSimpleGet();
  }

  ///
  @GET(path: '/api/health/simple')
  Future<chopper.Response<String>> _apiHealthSimpleGet();

  ///
  Future<chopper.Response<String>> apiHealthHealthGet() {
    return _apiHealthHealthGet();
  }

  ///
  @GET(path: '/api/health/health')
  Future<chopper.Response<String>> _apiHealthHealthGet();

  ///
  Future<chopper.Response<Object>> apiHealthEnvironmentGet() {
    return _apiHealthEnvironmentGet();
  }

  ///
  @GET(path: '/api/health/environment')
  Future<chopper.Response<Object>> _apiHealthEnvironmentGet();

  ///
  Future<chopper.Response<Object>> apiHealthDatabaseGet() {
    return _apiHealthDatabaseGet();
  }

  ///
  @GET(path: '/api/health/database')
  Future<chopper.Response<Object>> _apiHealthDatabaseGet();

  ///
  Future<chopper.Response<Object>> apiHealthCloudsqlGet() {
    return _apiHealthCloudsqlGet();
  }

  ///
  @GET(path: '/api/health/cloudsql')
  Future<chopper.Response<Object>> _apiHealthCloudsqlGet();

  ///
  Future<chopper.Response<String>> apiHealthAhHealthGet() {
    return _apiHealthAhHealthGet();
  }

  ///
  @GET(path: '/api/health/_ah/health')
  Future<chopper.Response<String>> _apiHealthAhHealthGet();

  ///Get configuration
  Future<chopper.Response<Object>> apiConfigGet() {
    return _apiConfigGet();
  }

  ///Get configuration
  @GET(path: '/api/config')
  Future<chopper.Response<Object>> _apiConfigGet();

  ///
  Future<chopper.Response<Object>> apiAuthUserGet() {
    return _apiAuthUserGet();
  }

  ///
  @GET(path: '/api/auth/user')
  Future<chopper.Response<Object>> _apiAuthUserGet();

  ///
  Future<chopper.Response<Object>> apiAuthTestJwtGet() {
    return _apiAuthTestJwtGet();
  }

  ///
  @GET(path: '/api/auth/test-jwt')
  Future<chopper.Response<Object>> _apiAuthTestJwtGet();

  ///
  Future<chopper.Response<String>> apiAuthSimpleTestGet() {
    return _apiAuthSimpleTestGet();
  }

  ///
  @GET(path: '/api/auth/simple-test')
  Future<chopper.Response<String>> _apiAuthSimpleTestGet();

  ///
  Future<chopper.Response<Object>> apiAuthPublicTestGet() {
    return _apiAuthPublicTestGet();
  }

  ///
  @GET(path: '/api/auth/public-test')
  Future<chopper.Response<Object>> _apiAuthPublicTestGet();

  ///
  ///@param provider
  Future<chopper.Response<Object>> apiAuthLoginProviderGet({
    required String? provider,
  }) {
    return _apiAuthLoginProviderGet(provider: provider);
  }

  ///
  ///@param provider
  @GET(path: '/api/auth/login/{provider}')
  Future<chopper.Response<Object>> _apiAuthLoginProviderGet({
    @Path('provider') required String? provider,
  });

  ///
  Future<chopper.Response<Object>> apiAuthIsLocalGet() {
    return _apiAuthIsLocalGet();
  }

  ///
  @GET(path: '/api/auth/is-local')
  Future<chopper.Response<Object>> _apiAuthIsLocalGet();

  ///
  ///@param provider
  ///@param code
  Future<chopper.Response<Object>> apiAuthCallbackProviderGet({
    required String? provider,
    required String? code,
  }) {
    return _apiAuthCallbackProviderGet(provider: provider, code: code);
  }

  ///
  ///@param provider
  ///@param code
  @GET(path: '/api/auth/callback/{provider}')
  Future<chopper.Response<Object>> _apiAuthCallbackProviderGet({
    @Path('provider') required String? provider,
    @Query('code') required String? code,
  });

  ///
  Future<chopper.Response<String>> apiAuthBasicTestGet() {
    return _apiAuthBasicTestGet();
  }

  ///
  @GET(path: '/api/auth/basic-test')
  Future<chopper.Response<String>> _apiAuthBasicTestGet();

  ///
  ///@param workspaceId
  ///@param targetUserId
  Future<chopper.Response<Object>>
  apiWorkspacesWorkspaceIdUsersTargetUserIdDelete({
    required String? workspaceId,
    required String? targetUserId,
  }) {
    return _apiWorkspacesWorkspaceIdUsersTargetUserIdDelete(
      workspaceId: workspaceId,
      targetUserId: targetUserId,
    );
  }

  ///
  ///@param workspaceId
  ///@param targetUserId
  @DELETE(path: '/api/workspaces/{workspaceId}/users/{targetUserId}')
  Future<chopper.Response<Object>>
  _apiWorkspacesWorkspaceIdUsersTargetUserIdDelete({
    @Path('workspaceId') required String? workspaceId,
    @Path('targetUserId') required String? targetUserId,
  });

  ///Remove from workspace
  ///@param id
  ///@param workspaceId
  Future<chopper.Response> apiIntegrationsIdWorkspacesWorkspaceIdDelete({
    required String? id,
    required String? workspaceId,
  }) {
    return _apiIntegrationsIdWorkspacesWorkspaceIdDelete(
      id: id,
      workspaceId: workspaceId,
    );
  }

  ///Remove from workspace
  ///@param id
  ///@param workspaceId
  @DELETE(path: '/api/integrations/{id}/workspaces/{workspaceId}')
  Future<chopper.Response> _apiIntegrationsIdWorkspacesWorkspaceIdDelete({
    @Path('id') required String? id,
    @Path('workspaceId') required String? workspaceId,
  });

  ///Remove user access
  ///@param id
  ///@param userId
  Future<chopper.Response> apiIntegrationsIdUsersUserIdDelete({
    required String? id,
    required String? userId,
  }) {
    return _apiIntegrationsIdUsersUserIdDelete(id: id, userId: userId);
  }

  ///Remove user access
  ///@param id
  ///@param userId
  @DELETE(path: '/api/integrations/{id}/users/{userId}')
  Future<chopper.Response> _apiIntegrationsIdUsersUserIdDelete({
    @Path('id') required String? id,
    @Path('userId') required String? userId,
  });
}

typedef $JsonFactory<T> = T Function(Map<String, dynamic> json);

class $CustomJsonDecoder {
  $CustomJsonDecoder(this.factories);

  final Map<Type, $JsonFactory> factories;

  dynamic decode<T>(dynamic entity) {
    if (entity is Iterable) {
      return _decodeList<T>(entity);
    }

    if (entity is T) {
      return entity;
    }

    if (isTypeOf<T, Map>()) {
      return entity;
    }

    if (isTypeOf<T, Iterable>()) {
      return entity;
    }

    if (entity is Map<String, dynamic>) {
      return _decodeMap<T>(entity);
    }

    return entity;
  }

  T _decodeMap<T>(Map<String, dynamic> values) {
    final jsonFactory = factories[T];
    if (jsonFactory == null || jsonFactory is! $JsonFactory<T>) {
      return throw "Could not find factory for type $T. Is '$T: $T.fromJsonFactory' included in the CustomJsonDecoder instance creation in bootstrapper.dart?";
    }

    return jsonFactory(values);
  }

  List<T> _decodeList<T>(Iterable values) =>
      values.where((v) => v != null).map<T>((v) => decode<T>(v) as T).toList();
}

class $JsonSerializableConverter extends chopper.JsonConverter {
  @override
  FutureOr<chopper.Response<ResultType>> convertResponse<ResultType, Item>(
    chopper.Response response,
  ) async {
    if (response.bodyString.isEmpty) {
      // In rare cases, when let's say 204 (no content) is returned -
      // we cannot decode the missing json with the result type specified
      return chopper.Response(response.base, null, error: response.error);
    }

    if (ResultType == String) {
      return response.copyWith();
    }

    if (ResultType == DateTime) {
      return response.copyWith(
        body:
            DateTime.parse((response.body as String).replaceAll('"', ''))
                as ResultType,
      );
    }

    final jsonRes = await super.convertResponse(response);
    return jsonRes.copyWith<ResultType>(
      body: $jsonDecoder.decode<Item>(jsonRes.body) as ResultType,
    );
  }
}

final $jsonDecoder = $CustomJsonDecoder(generatedMapping);
