// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Api extends Api {
  _$Api([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Api;

  @override
  Future<Response<JobConfigurationDto>> _apiV1JobConfigurationsIdGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/v1/job-configurations/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<JobConfigurationDto, JobConfigurationDto>($request);
  }

  @override
  Future<Response<JobConfigurationDto>> _apiV1JobConfigurationsIdPut({
    required String? id,
    required UpdateJobConfigurationRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/job-configurations/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<JobConfigurationDto, JobConfigurationDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1JobConfigurationsIdDelete(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/v1/job-configurations/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Object>> _apiSettingsUserUserIdKeyGet({
    required String? userId,
    required String? key,
    String? defaultValue,
  }) {
    final Uri $url = Uri.parse('/api/settings/user/${userId}/${key}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'defaultValue': defaultValue
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiSettingsUserUserIdKeyPut({
    required String? userId,
    required String? key,
    required Object? body,
  }) {
    final Uri $url = Uri.parse('/api/settings/user/${userId}/${key}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiMcpConfigurationsConfigIdGet(
      {required String? configId}) {
    final Uri $url = Uri.parse('/api/mcp/configurations/${configId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiMcpConfigurationsConfigIdPut({
    required String? configId,
    required CreateMcpConfigurationRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/mcp/configurations/${configId}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiMcpConfigurationsConfigIdDelete(
      {required String? configId}) {
    final Uri $url = Uri.parse('/api/mcp/configurations/${configId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<IntegrationDto>> _apiIntegrationsIdGet({
    required String? id,
    bool? includeSensitive,
  }) {
    final Uri $url = Uri.parse('/api/integrations/${id}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'includeSensitive': includeSensitive
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<IntegrationDto, IntegrationDto>($request);
  }

  @override
  Future<Response<IntegrationDto>> _apiIntegrationsIdPut({
    required String? id,
    required UpdateIntegrationRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/integrations/${id}');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<IntegrationDto, IntegrationDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiIntegrationsIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/api/integrations/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<IntegrationDto>> _apiIntegrationsIdEnablePut(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/integrations/${id}/enable');
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
    );
    return client.send<IntegrationDto, IntegrationDto>($request);
  }

  @override
  Future<Response<IntegrationDto>> _apiIntegrationsIdDisablePut(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/integrations/${id}/disable');
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
    );
    return client.send<IntegrationDto, IntegrationDto>($request);
  }

  @override
  Future<Response<Object>> _apiAdminUsersUserIdRolePut({
    required String? userId,
    required String? body,
  }) {
    final Uri $url = Uri.parse('/api/admin/users/${userId}/role');
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _shutdownPost() {
    final Uri $url = Uri.parse('/shutdown');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<SseEmitter>> _mcpStreamConfigIdGet(
      {required String? configId}) {
    final Uri $url = Uri.parse('/mcp/stream/${configId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<SseEmitter, SseEmitter>($request);
  }

  @override
  Future<Response<SseEmitter>> _mcpStreamConfigIdPost({
    required String? configId,
    required String? body,
  }) {
    final Uri $url = Uri.parse('/mcp/stream/${configId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<SseEmitter, SseEmitter>($request);
  }

  @override
  Future<Response<List<WorkspaceDto>>> _apiWorkspacesGet() {
    final Uri $url = Uri.parse('/api/workspaces');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<WorkspaceDto>, WorkspaceDto>($request);
  }

  @override
  Future<Response<WorkspaceDto>> _apiWorkspacesPost(
      {required CreateWorkspaceRequest? body}) {
    final Uri $url = Uri.parse('/api/workspaces');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<WorkspaceDto, WorkspaceDto>($request);
  }

  @override
  Future<Response<Object>> _apiWorkspacesWorkspaceIdSharePost({
    required String? workspaceId,
    required ShareWorkspaceRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/workspaces/${workspaceId}/share');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<WorkspaceDto>> _apiWorkspacesDefaultPost() {
    final Uri $url = Uri.parse('/api/workspaces/default');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<WorkspaceDto, WorkspaceDto>($request);
  }

  @override
  Future<Response<JobExecutionResponse>> _apiV1JobsExecutePost(
      {required JobExecutionRequest? body}) {
    final Uri $url = Uri.parse('/api/v1/jobs/execute');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<JobExecutionResponse, JobExecutionResponse>($request);
  }

  @override
  Future<Response<JobExecutionResponse>>
      _apiV1JobsConfigurationsConfigIdExecutePost({
    required String? configId,
    required ExecuteJobConfigurationRequest? body,
  }) {
    final Uri $url =
        Uri.parse('/api/v1/jobs/configurations/${configId}/execute');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<JobExecutionResponse, JobExecutionResponse>($request);
  }

  @override
  Future<Response<List<JobConfigurationDto>>> _apiV1JobConfigurationsGet(
      {bool? enabled}) {
    final Uri $url = Uri.parse('/api/v1/job-configurations');
    final Map<String, dynamic> $params = <String, dynamic>{'enabled': enabled};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<List<JobConfigurationDto>, JobConfigurationDto>($request);
  }

  @override
  Future<Response<JobConfigurationDto>> _apiV1JobConfigurationsPost(
      {required CreateJobConfigurationRequest? body}) {
    final Uri $url = Uri.parse('/api/v1/job-configurations');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<JobConfigurationDto, JobConfigurationDto>($request);
  }

  @override
  Future<Response<WebhookExecutionResponse>>
      _apiV1JobConfigurationsIdWebhookPost({
    required String? id,
    String? xAPIKey,
    required WebhookExecuteRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/job-configurations/${id}/webhook');
    final Map<String, String> $headers = {
      if (xAPIKey != null) 'X-API-Key': xAPIKey,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
    );
    return client
        .send<WebhookExecutionResponse, WebhookExecutionResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1JobConfigurationsIdWebhookKeysGet(
      {required String? id}) {
    final Uri $url = Uri.parse('/api/v1/job-configurations/${id}/webhook-keys');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<CreateWebhookKeyResponse>>
      _apiV1JobConfigurationsIdWebhookKeysPost({
    required String? id,
    required CreateWebhookKeyRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/job-configurations/${id}/webhook-keys');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<CreateWebhookKeyResponse, CreateWebhookKeyResponse>($request);
  }

  @override
  Future<Response<ExecutionParametersDto>>
      _apiV1JobConfigurationsIdExecutePost({
    required String? id,
    required ExecuteJobConfigurationRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/job-configurations/${id}/execute');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<ExecutionParametersDto, ExecutionParametersDto>($request);
  }

  @override
  Future<Response<ChatResponse>> _apiV1ChatSimplePost({
    required String? message,
    String? model,
    String? ai,
  }) {
    final Uri $url = Uri.parse('/api/v1/chat/simple');
    final Map<String, dynamic> $params = <String, dynamic>{
      'message': message,
      'model': model,
      'ai': ai,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ChatResponse, ChatResponse>($request);
  }

  @override
  Future<Response<ChatResponse>> _apiV1ChatCompletionsPost(
      {required ChatRequest? body}) {
    final Uri $url = Uri.parse('/api/v1/chat/completions');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<ChatResponse, ChatResponse>($request);
  }

  @override
  Future<Response<ChatResponse>> _apiV1ChatCompletionsWithFilesPost({
    required String? chatRequest,
    required List<List<int>> files,
  }) {
    final Uri $url = Uri.parse('/api/v1/chat/completions-with-files');
    final Map<String, dynamic> $params = <String, dynamic>{
      'chatRequest': chatRequest
    };
    final List<PartValue> $parts = <PartValue>[
      PartValueFile<List<List<int>>>(
        'files',
        files,
      )
    ];
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parts: $parts,
      multipart: true,
      parameters: $params,
    );
    return client.send<ChatResponse, ChatResponse>($request);
  }

  @override
  Future<Response<AgentExecutionResponse>> _apiV1AgentsOrchestratorsExecutePost(
      {required AgentExecutionRequest? body}) {
    final Uri $url = Uri.parse('/api/v1/agents/orchestrators/execute');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<AgentExecutionResponse, AgentExecutionResponse>($request);
  }

  @override
  Future<Response<AgentExecutionResponse>>
      _apiV1AgentsOrchestratorsExecuteOrchestratorNamePost({
    required String? orchestratorName,
    required Object? body,
  }) {
    final Uri $url =
        Uri.parse('/api/v1/agents/orchestrators/execute/${orchestratorName}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<AgentExecutionResponse, AgentExecutionResponse>($request);
  }

  @override
  Future<Response<AgentExecutionResponse>> _apiV1AgentsExecutePost(
      {required AgentExecutionRequest? body}) {
    final Uri $url = Uri.parse('/api/v1/agents/execute');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<AgentExecutionResponse, AgentExecutionResponse>($request);
  }

  @override
  Future<Response<AgentExecutionResponse>> _apiV1AgentsExecuteAgentNamePost({
    required String? agentName,
    required Object? body,
  }) {
    final Uri $url = Uri.parse('/api/v1/agents/execute/${agentName}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client
        .send<AgentExecutionResponse, AgentExecutionResponse>($request);
  }

  @override
  Future<Response<Object>> _apiSettingsUserUserIdGet(
      {required String? userId}) {
    final Uri $url = Uri.parse('/api/settings/user/${userId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiSettingsUserUserIdPost({
    required String? userId,
    required Object? body,
  }) {
    final Uri $url = Uri.parse('/api/settings/user/${userId}');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _apiPresentationScriptPost({
    required String? userRequest,
    required ApiPresentationScriptPost$RequestBody? body,
  }) {
    final Uri $url = Uri.parse('/api/presentation/script');
    final Map<String, dynamic> $params = <String, dynamic>{
      'userRequest': userRequest
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _apiPresentationGeneratePost(
      {required GeneratePresentationRequest? body}) {
    final Uri $url = Uri.parse('/api/presentation/generate');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Object>> _apiOauthProxyInitiatePost(
      {required OAuthInitiateRequest? body}) {
    final Uri $url = Uri.parse('/api/oauth-proxy/initiate');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiOauthProxyExchangePost(
      {required OAuthExchangeRequest? body}) {
    final Uri $url = Uri.parse('/api/oauth-proxy/exchange');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<List<McpConfigurationDto>>> _apiMcpConfigurationsGet() {
    final Uri $url = Uri.parse('/api/mcp/configurations');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<List<McpConfigurationDto>, McpConfigurationDto>($request);
  }

  @override
  Future<Response<Object>> _apiMcpConfigurationsPost(
      {required CreateMcpConfigurationRequest? body}) {
    final Uri $url = Uri.parse('/api/mcp/configurations');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<List<IntegrationDto>>> _apiIntegrationsGet() {
    final Uri $url = Uri.parse('/api/integrations');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<IntegrationDto>, IntegrationDto>($request);
  }

  @override
  Future<Response<IntegrationDto>> _apiIntegrationsPost(
      {required CreateIntegrationRequest? body}) {
    final Uri $url = Uri.parse('/api/integrations');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<IntegrationDto, IntegrationDto>($request);
  }

  @override
  Future<Response<WorkspaceDto>> _apiIntegrationsIdWorkspacesPost({
    required String? id,
    required ShareIntegrationWithWorkspaceRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/integrations/${id}/workspaces');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<WorkspaceDto, WorkspaceDto>($request);
  }

  @override
  Future<Response<IntegrationUserDto>> _apiIntegrationsIdUsersPost({
    required String? id,
    required ShareIntegrationRequest? body,
  }) {
    final Uri $url = Uri.parse('/api/integrations/${id}/users');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<IntegrationUserDto, IntegrationUserDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiIntegrationsIdUsagePost({required String? id}) {
    final Uri $url = Uri.parse('/api/integrations/${id}/usage');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Object>> _apiIntegrationsTestPost(
      {required TestIntegrationRequest? body}) {
    final Uri $url = Uri.parse('/api/integrations/test');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _apiExecuteJobPost({required String? body}) {
    final Uri $url = Uri.parse('/api/executeJob');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Object>> _apiAuthLogoutPost() {
    final Uri $url = Uri.parse('/api/auth/logout');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAuthLocalLoginPost({required Object? body}) {
    final Uri $url = Uri.parse('/api/auth/local-login');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAdminUsersRolesReevaluatePost() {
    final Uri $url = Uri.parse('/api/admin/users/roles/reevaluate');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAdminCacheClearPost() {
    final Uri $url = Uri.parse('/api/admin/cache/clear');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<bool>> _isLocalGet() {
    final Uri $url = Uri.parse('/is-local');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<bool, bool>($request);
  }

  @override
  Future<Response<WorkspaceDto>> _apiWorkspacesWorkspaceIdGet(
      {required String? workspaceId}) {
    final Uri $url = Uri.parse('/api/workspaces/${workspaceId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<WorkspaceDto, WorkspaceDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiWorkspacesWorkspaceIdDelete(
      {required String? workspaceId}) {
    final Uri $url = Uri.parse('/api/workspaces/${workspaceId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1JobsJobNameIntegrationsGet(
      {required String? jobName}) {
    final Uri $url = Uri.parse('/api/v1/jobs/${jobName}/integrations');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1JobsTypesGet() {
    final Uri $url = Uri.parse('/api/v1/jobs/types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<JobTypeDto>> _apiV1JobsTypesJobNameGet(
      {required String? jobName}) {
    final Uri $url = Uri.parse('/api/v1/jobs/types/${jobName}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<JobTypeDto, JobTypeDto>($request);
  }

  @override
  Future<Response<JobExecutionStatusResponse>>
      _apiV1JobsExecutionsExecutionIdStatusGet({required String? executionId}) {
    final Uri $url = Uri.parse('/api/v1/jobs/executions/${executionId}/status');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client
        .send<JobExecutionStatusResponse, JobExecutionStatusResponse>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1JobsAvailableGet() {
    final Uri $url = Uri.parse('/api/v1/jobs/available');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<WebhookExamplesDto>>
      _apiV1JobConfigurationsIdWebhookExamplesGet({required String? id}) {
    final Uri $url =
        Uri.parse('/api/v1/job-configurations/${id}/webhook-examples');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<WebhookExamplesDto, WebhookExamplesDto>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1ChatHealthGet() {
    final Uri $url = Uri.parse('/api/v1/chat/health');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Object>> _apiV1AgentsOrchestratorsGet({bool? detailed}) {
    final Uri $url = Uri.parse('/api/v1/agents/orchestrators');
    final Map<String, dynamic> $params = <String, dynamic>{
      'detailed': detailed
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<AgentInfo>> _apiV1AgentsOrchestratorsOrchestratorNameInfoGet(
      {required String? orchestratorName}) {
    final Uri $url =
        Uri.parse('/api/v1/agents/orchestrators/${orchestratorName}/info');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<AgentInfo, AgentInfo>($request);
  }

  @override
  Future<Response<String>> _apiV1AgentsHealthGet() {
    final Uri $url = Uri.parse('/api/v1/agents/health');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<AgentListResponse>> _apiV1AgentsAvailableGet(
      {bool? detailed}) {
    final Uri $url = Uri.parse('/api/v1/agents/available');
    final Map<String, dynamic> $params = <String, dynamic>{
      'detailed': detailed
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<AgentListResponse, AgentListResponse>($request);
  }

  @override
  Future<Response<Object>> _apiV1AgentsAgentsGet({bool? detailed}) {
    final Uri $url = Uri.parse('/api/v1/agents/agents');
    final Map<String, dynamic> $params = <String, dynamic>{
      'detailed': detailed
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<AgentInfo>> _apiV1AgentsAgentsAgentNameInfoGet(
      {required String? agentName}) {
    final Uri $url = Uri.parse('/api/v1/agents/agents/${agentName}/info');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<AgentInfo, AgentInfo>($request);
  }

  @override
  Future<Response<String>> _apiPresentationHealthGet() {
    final Uri $url = Uri.parse('/api/presentation/health');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Object>> _apiOauthProxyProvidersGet() {
    final Uri $url = Uri.parse('/api/oauth-proxy/providers');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiMcpConfigurationsConfigIdAccessCodeGet({
    required String? configId,
    String? format,
  }) {
    final Uri $url =
        Uri.parse('/api/mcp/configurations/${configId}/access-code');
    final Map<String, dynamic> $params = <String, dynamic>{'format': format};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<List<IntegrationDto>>>
      _apiIntegrationsWorkspaceWorkspaceIdGet({required String? workspaceId}) {
    final Uri $url = Uri.parse('/api/integrations/workspace/${workspaceId}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<IntegrationDto>, IntegrationDto>($request);
  }

  @override
  Future<Response<List<IntegrationTypeDto>>> _apiIntegrationsTypesGet() {
    final Uri $url = Uri.parse('/api/integrations/types');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<List<IntegrationTypeDto>, IntegrationTypeDto>($request);
  }

  @override
  Future<Response<IntegrationTypeDto>> _apiIntegrationsTypesTypeSchemaGet(
      {required String? type}) {
    final Uri $url = Uri.parse('/api/integrations/types/${type}/schema');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<IntegrationTypeDto, IntegrationTypeDto>($request);
  }

  @override
  Future<Response<String>> _apiIntegrationsTypesTypeDocumentationGet({
    required String? type,
    String? locale,
  }) {
    final Uri $url = Uri.parse('/api/integrations/types/${type}/documentation');
    final Map<String, dynamic> $params = <String, dynamic>{'locale': locale};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Object>> _apiHealthGet() {
    final Uri $url = Uri.parse('/api/health');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _apiHealthSimpleGet() {
    final Uri $url = Uri.parse('/api/health/simple');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _apiHealthHealthGet() {
    final Uri $url = Uri.parse('/api/health/health');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Object>> _apiHealthEnvironmentGet() {
    final Uri $url = Uri.parse('/api/health/environment');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiHealthDatabaseGet() {
    final Uri $url = Uri.parse('/api/health/database');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiHealthCloudsqlGet() {
    final Uri $url = Uri.parse('/api/health/cloudsql');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _apiHealthAhHealthGet() {
    final Uri $url = Uri.parse('/api/health/_ah/health');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _apiFilesDownloadTokenGet({required String? token}) {
    final Uri $url = Uri.parse('/api/files/download/${token}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Object>> _apiConfigGet() {
    final Uri $url = Uri.parse('/api/config');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAuthUserGet() {
    final Uri $url = Uri.parse('/api/auth/user');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAuthTestJwtGet() {
    final Uri $url = Uri.parse('/api/auth/test-jwt');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _apiAuthSimpleTestGet() {
    final Uri $url = Uri.parse('/api/auth/simple-test');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Object>> _apiAuthPublicTestGet() {
    final Uri $url = Uri.parse('/api/auth/public-test');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAuthLoginProviderGet(
      {required String? provider}) {
    final Uri $url = Uri.parse('/api/auth/login/${provider}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAuthIsLocalGet() {
    final Uri $url = Uri.parse('/api/auth/is-local');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAuthCallbackProviderGet({
    required String? provider,
    required String? code,
  }) {
    final Uri $url = Uri.parse('/api/auth/callback/${provider}');
    final Map<String, dynamic> $params = <String, dynamic>{'code': code};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<String>> _apiAuthBasicTestGet() {
    final Uri $url = Uri.parse('/api/auth/basic-test');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<Object>> _apiAdminUsersGet({
    int? page,
    int? size,
    String? search,
  }) {
    final Uri $url = Uri.parse('/api/admin/users');
    final Map<String, dynamic> $params = <String, dynamic>{
      'page': page,
      'size': size,
      'search': search,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiAdminCacheStatsGet() {
    final Uri $url = Uri.parse('/api/admin/cache/stats');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<Object>> _apiWorkspacesWorkspaceIdUsersTargetUserIdDelete({
    required String? workspaceId,
    required String? targetUserId,
  }) {
    final Uri $url =
        Uri.parse('/api/workspaces/${workspaceId}/users/${targetUserId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<Object, Object>($request);
  }

  @override
  Future<Response<dynamic>> _apiV1JobConfigurationsIdWebhookKeysKeyIdDelete({
    required String? id,
    required String? keyId,
  }) {
    final Uri $url =
        Uri.parse('/api/v1/job-configurations/${id}/webhook-keys/${keyId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiIntegrationsIdWorkspacesWorkspaceIdDelete({
    required String? id,
    required String? workspaceId,
  }) {
    final Uri $url =
        Uri.parse('/api/integrations/${id}/workspaces/${workspaceId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _apiIntegrationsIdUsersUserIdDelete({
    required String? id,
    required String? userId,
  }) {
    final Uri $url = Uri.parse('/api/integrations/${id}/users/${userId}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
