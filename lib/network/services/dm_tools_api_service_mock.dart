import 'package:dmtools/core/models/user.dart';
import 'package:dmtools/network/generated/openapi.models.swagger.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
import 'package:flutter/foundation.dart';

import 'package:dmtools/network/generated/openapi.enums.swagger.dart' as enums;

/// Mock data for demo mode
class _MockData {
  static List<WorkspaceDto> get mockWorkspaces => [
        WorkspaceDto(
          id: 'demo_workspace_1',
          name: 'Demo Workspace',
          description: 'This is a demo workspace with sample data',
          ownerId: 'demo_user_123',
          ownerName: 'Demo User',
          ownerEmail: 'demo@dmtools.com',
          currentUserRole: enums.WorkspaceDtoCurrentUserRole.admin,
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          users: [
            const WorkspaceUserDto(
              id: 'demo_user_123',
              email: 'demo@dmtools.com',
              role: enums.WorkspaceUserDtoRole.admin,
            ),
            const WorkspaceUserDto(
              id: 'demo_user_456',
              email: 'colleague@dmtools.com',
              role: enums.WorkspaceUserDtoRole.user,
            ),
          ],
        ),
        WorkspaceDto(
          id: 'demo_workspace_2',
          name: 'Sample Project',
          description: 'Another demo workspace for testing',
          ownerId: 'demo_user_123',
          ownerName: 'Demo User',
          ownerEmail: 'demo@dmtools.com',
          currentUserRole: enums.WorkspaceDtoCurrentUserRole.admin,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
          users: [
            const WorkspaceUserDto(
              id: 'demo_user_123',
              email: 'demo@dmtools.com',
              role: enums.WorkspaceUserDtoRole.admin,
            ),
          ],
        ),
      ];

  static List<JobConfigurationDto> get mockJobConfigurations => [
        JobConfigurationDto(
          id: 'demo_job_1',
          name: 'Expert Analysis',
          description: 'AI-powered expert analysis and recommendations for project issues and requirements',
          jobType: 'expert_analysis',
          createdById: 'demo_user_123',
          createdByName: 'Demo User',
          createdByEmail: 'demo@dmtools.com',
          enabled: true,
          executionCount: 42,
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          lastExecutedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        JobConfigurationDto(
          id: 'demo_job_2',
          name: 'Code Review Assistant',
          description: 'Automated code review and quality analysis for pull requests',
          jobType: 'code_review',
          createdById: 'demo_user_123',
          createdByName: 'Demo User',
          createdByEmail: 'demo@dmtools.com',
          enabled: true,
          executionCount: 28,
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
          updatedAt: DateTime.now().subtract(const Duration(days: 2)),
          lastExecutedAt: DateTime.now().subtract(const Duration(hours: 6)),
        ),
        JobConfigurationDto(
          id: 'demo_job_3',
          name: 'Issue Summarizer',
          description: 'Automatically summarize and categorize project issues',
          jobType: 'issue_summary',
          createdById: 'demo_user_123',
          createdByName: 'Demo User',
          createdByEmail: 'demo@dmtools.com',
          enabled: false,
          executionCount: 12,
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          lastExecutedAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
      ];
}

class DmToolsApiServiceMock implements DmToolsApiService {
  DmToolsApiServiceMock();

  /// Get the current authenticated user's profile
  @override
  Future<UserDto> getCurrentUser() async {
    const user = UserDto(
      id: 'demo_user_123',
      name: 'Demo User',
      email: 'demo@dmtools.com',
    );

    if (kDebugMode) {
      print('✅ User info loaded from MOCK API (Demo Mode):');
      print('   - Name: ${user.name}');
      print('   - Email: ${user.email}');
      print('   - ID: ${user.id}');
      print('   - Picture: ${user.picture}');
    }

    return user;
  }

  @override
  Future<List<WorkspaceDto>> getWorkspaces() async {
    return _MockData.mockWorkspaces;
  }

  @override
  Future<WorkspaceDto> getWorkspace(String workspaceId) async {
    try {
      return _MockData.mockWorkspaces.firstWhere(
        (workspace) => workspace.id == workspaceId,
      );
    } catch (e) {
      throw ApiException('Demo workspace not found: $workspaceId');
    }
  }

  @override
  Future<WorkspaceDto> createWorkspace({
    required String name,
    String? description,
  }) async {
    return const WorkspaceDto();
  }

  @override
  Future<void> deleteWorkspace(String workspaceId) => Future.value();

  @override
  Future<void> shareWorkspace({
    required String workspaceId,
    required String userEmail,
    required enums.ShareWorkspaceRequestRole role,
  }) =>
      Future.value();

  @override
  Future<void> removeUserFromWorkspace({
    required String workspaceId,
    required String targetUserId,
  }) async =>
      Future.value();

  @override
  Future<WorkspaceDto> createDefaultWorkspace() => Future.value(const WorkspaceDto());

  // Integration methods

  @override
  Future<List<IntegrationDto>> getIntegrations() async {
    return [];
  }

  @override
  Future<List<IntegrationTypeDto>> getIntegrationTypes() async {
    return [];
  }

  @override
  Future<IntegrationDto> getIntegration(String id, {bool includeSensitive = false}) async {
    return const IntegrationDto();
  }

  @override
  Future<IntegrationDto> createIntegration(CreateIntegrationRequest request) async {
    return const IntegrationDto();
  }

  @override
  Future<IntegrationDto> updateIntegration(String id, UpdateIntegrationRequest request) async {
    return const IntegrationDto();
  }

  @override
  Future<void> deleteIntegration(String id) async {
    // Mock implementation
  }

  @override
  Future<IntegrationDto> enableIntegration(String id) async {
    return const IntegrationDto();
  }

  @override
  Future<IntegrationDto> disableIntegration(String id) async {
    return const IntegrationDto();
  }

  @override
  Future<Object> testIntegration(TestIntegrationRequest request) async {
    return {};
  }

  // Job Configuration methods implementation
  @override
  Future<List<JobConfigurationDto>> getJobConfigurations({bool? enabled}) async {
    final mockConfigs = _MockData.mockJobConfigurations;
    if (enabled == null) return mockConfigs;
    return mockConfigs.where((config) => config.enabled == enabled).toList();
  }

  @override
  Future<JobConfigurationDto> getJobConfiguration(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _MockData.mockJobConfigurations.firstWhere(
      (config) => config.id == id,
      orElse: () => throw ApiException('Job configuration not found', 404),
    );
  }

  @override
  Future<Map<String, dynamic>> getJobConfigurationRaw(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final config = _MockData.mockJobConfigurations.firstWhere(
      (config) => config.id == id,
      orElse: () => throw ApiException('Job configuration not found', 404),
    );

    // Return raw JSON with proper jobParameters and integrationMappings
    return {
      'id': config.id,
      'name': config.name,
      'description': config.description,
      'jobType': config.jobType,
      'createdById': config.createdById,
      'createdByName': config.createdByName,
      'createdByEmail': config.createdByEmail,
      'enabled': config.enabled,
      'executionCount': config.executionCount,
      'createdAt': config.createdAt?.toIso8601String(),
      'updatedAt': config.updatedAt?.toIso8601String(),
      'lastExecutedAt': config.lastExecutedAt?.toIso8601String(),
      'jobParameters': {
        'systemRequest': 'https://dmtools.atlassian.net/wiki/spaces/AINA/pages/6750209/Acceptance+Criteria',
        'systemRequestCommentAlias': 'BA Acceptance Criteria',
        'requestDecompositionChunkProcessing': false,
        'projectContext':
            'We\'re developing Flutter App, Server and Core module to use AI and connectivity to different SDLC tools',
      },
      'integrationMappings': {
        'AI': '570130c7-5ef7-494a-97ef-434fa7811fe2',
        'Documentation': '8f68bd6a-19ab-4de7-a5e8-ef474e805ebe',
        'TrackerClient': '9decb6c0-1212-4a38-bde6-21b2eabb40a8',
      },
    };
  }

  @override
  Future<JobConfigurationDto> createJobConfiguration(CreateJobConfigurationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newConfig = JobConfigurationDto(
      id: newId,
      name: request.name,
      description: request.description,
      jobType: request.jobType,
      createdById: '1',
      createdByName: 'Mock User',
      createdByEmail: 'mock@example.com',
      enabled: request.enabled ?? true,
      executionCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _MockData.mockJobConfigurations.add(newConfig);
    return newConfig;
  }

  @override
  Future<JobConfigurationDto> createJobConfigurationRaw(
      String name, String jobType, Map<String, dynamic> jobParameters, Map<String, dynamic> integrationMappings,
      {String? description, bool? enabled}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    print('🔄 Mock createJobConfigurationRaw called with:');
    print('  name: $name');
    print('  jobType: $jobType');
    print('  jobParameters: $jobParameters');
    print('  integrationMappings: $integrationMappings');

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newConfig = JobConfigurationDto(
      id: newId,
      name: name,
      description: description,
      jobType: jobType,
      createdById: '1',
      createdByName: 'Mock User',
      createdByEmail: 'mock@example.com',
      enabled: enabled ?? true,
      executionCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _MockData.mockJobConfigurations.add(newConfig);
    print('✅ Mock creation successful for: $name');
    return newConfig;
  }

  @override
  Future<JobConfigurationDto> updateJobConfiguration(String id, UpdateJobConfigurationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _MockData.mockJobConfigurations.indexWhere((config) => config.id == id);
    if (index >= 0) {
      final updatedConfig = _MockData.mockJobConfigurations[index].copyWith(
        name: request.name ?? _MockData.mockJobConfigurations[index].name,
        description: request.description ?? _MockData.mockJobConfigurations[index].description,
        enabled: request.enabled ?? _MockData.mockJobConfigurations[index].enabled,
        updatedAt: DateTime.now(),
      );
      _MockData.mockJobConfigurations[index] = updatedConfig;
      return updatedConfig;
    } else {
      throw ApiException('Job configuration not found', 404);
    }
  }

  @override
  Future<JobConfigurationDto> updateJobConfigurationRaw(
      String id, String name, Map<String, dynamic> jobParameters, Map<String, dynamic> integrationMappings,
      {String? description, bool? enabled}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    print('🔄 Mock updateJobConfigurationRaw called with:');
    print('  id: $id');
    print('  name: $name');
    print('  jobParameters: $jobParameters');
    print('  integrationMappings: $integrationMappings');

    final index = _MockData.mockJobConfigurations.indexWhere((config) => config.id == id);
    if (index >= 0) {
      final updatedConfig = _MockData.mockJobConfigurations[index].copyWith(
        name: name,
        description: description ?? _MockData.mockJobConfigurations[index].description,
        enabled: enabled ?? _MockData.mockJobConfigurations[index].enabled,
        updatedAt: DateTime.now(),
      );
      _MockData.mockJobConfigurations[index] = updatedConfig;

      // In mock, we simulate successful parameter storage
      print('✅ Mock update successful for: $name');
      return updatedConfig;
    } else {
      throw ApiException('Job configuration not found', 404);
    }
  }

  @override
  Future<void> deleteJobConfiguration(String id) async {
    // Mock implementation - no actual deletion
    if (kDebugMode) {
      print('Mock: Deleting job configuration $id');
    }
  }

  @override
  Future<Object> executeJobConfiguration(String id, ExecuteJobConfigurationRequest request) async {
    await Future.delayed(const Duration(milliseconds: 1000)); // Simulate execution time

    if (kDebugMode) {
      print('🚀 Mock: Executing job configuration $id');
      print('🚀 Mock: Request details: ${request.toJson()}');
    }

    // Simulate successful job execution
    final result = {
      'status': 'success',
      'message': 'Job configuration executed successfully',
      'executionId': 'exec_${DateTime.now().millisecondsSinceEpoch}',
      'configurationId': id,
      'startedAt': DateTime.now().toIso8601String(),
      'parameters': request.parameterOverrides?.toString() ?? 'default',
      'integrations': request.integrationOverrides?.toString() ?? 'default',
    };

    if (kDebugMode) {
      print('✅ Mock: Job execution completed successfully');
      print('✅ Mock: Result: $result');
    }

    return result;
  }

  @override
  Future<JobTypeDto> getJobType(String jobName) async {
    await Future.delayed(const Duration(milliseconds: 300));

    switch (jobName.toLowerCase()) {
      case 'expert_analysis':
        return const JobTypeDto(
          type: 'expert_analysis',
          displayName: 'Expert Analysis',
          description: 'AI-powered expert analysis and recommendations for project issues and requirements',
          requiredIntegrations: ['jira', 'github'],
          configParams: [
            ConfigParamDefinition(
              key: 'expertise_domain',
              displayName: 'Expertise Domain',
              description: 'The domain of expertise for the AI assistant',
              required: true,
              type: 'select',
              options: ['backend', 'frontend', 'devops', 'testing', 'security'],
              defaultValue: 'backend',
            ),
            ConfigParamDefinition(
              key: 'analysis_depth',
              displayName: 'Analysis Depth',
              description: 'How detailed should the analysis be',
              required: true,
              type: 'select',
              options: ['shallow', 'medium', 'deep'],
              defaultValue: 'medium',
            ),
            ConfigParamDefinition(
              key: 'context_instructions',
              displayName: 'Context Instructions',
              description: 'Additional context or specific instructions for the analysis',
              required: false,
              type: 'textarea',
            ),
          ],
        );
      case 'code_review':
        return const JobTypeDto(
          type: 'code_review',
          displayName: 'Code Review Assistant',
          description: 'Automated code review and quality analysis for pull requests',
          requiredIntegrations: ['github'],
          configParams: [
            ConfigParamDefinition(
              key: 'review_scope',
              displayName: 'Review Scope',
              description: 'What aspects of the code to review',
              required: true,
              type: 'select',
              options: ['syntax', 'style', 'performance', 'security', 'all'],
              defaultValue: 'all',
            ),
            ConfigParamDefinition(
              key: 'include_suggestions',
              displayName: 'Include Suggestions',
              description: 'Provide code improvement suggestions',
              required: false,
              type: 'boolean',
              defaultValue: 'true',
            ),
            ConfigParamDefinition(
              key: 'severity_level',
              displayName: 'Minimum Severity Level',
              description: 'Minimum severity level for issues to report',
              required: true,
              type: 'select',
              options: ['info', 'warning', 'error', 'critical'],
              defaultValue: 'warning',
            ),
          ],
        );
      case 'issue_summary':
        return const JobTypeDto(
          type: 'issue_summary',
          displayName: 'Issue Summarizer',
          description: 'Automatically summarize and categorize project issues',
          requiredIntegrations: ['jira'],
          configParams: [
            ConfigParamDefinition(
              key: 'summary_length',
              displayName: 'Summary Length',
              description: 'How detailed should the summary be',
              required: true,
              type: 'select',
              options: ['brief', 'detailed', 'comprehensive'],
              defaultValue: 'detailed',
            ),
            ConfigParamDefinition(
              key: 'include_priority',
              displayName: 'Include Priority Analysis',
              description: 'Analyze and suggest issue priorities',
              required: false,
              type: 'boolean',
              defaultValue: 'true',
            ),
            ConfigParamDefinition(
              key: 'categorization',
              displayName: 'Auto-categorization',
              description: 'Automatically categorize issues by type',
              required: true,
              type: 'boolean',
              defaultValue: 'true',
            ),
          ],
        );
      default:
        throw ApiException('Job type not found: $jobName', 404);
    }
  }

  @override
  Future<List<JobTypeDto>> getAvailableJobTypes() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      await getJobType('expert_analysis'),
      await getJobType('code_review'),
      await getJobType('issue_summary'),
    ];
  }

  @override
  void dispose() {}
}
