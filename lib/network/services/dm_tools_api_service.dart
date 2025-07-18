import 'package:dmtools/network/generated/openapi.enums.swagger.dart' as enums;
import 'package:dmtools/core/models/user.dart';
import 'package:dmtools/network/generated/openapi.models.swagger.dart';

/// Exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, [this.statusCode]);

  @override
  String toString() => 'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// High-level service for API operations using the generated client
abstract interface class DmToolsApiService {
  DmToolsApiService({
    String? baseUrl,
    bool enableLogging = true,
  });

  /// Get the current authenticated user's profile
  Future<UserDto> getCurrentUser();

  /// Get all workspaces for the current user
  Future<List<WorkspaceDto>> getWorkspaces();

  /// Get a specific workspace by ID
  Future<WorkspaceDto> getWorkspace(String workspaceId);

  /// Create a new workspace
  Future<WorkspaceDto> createWorkspace({
    required String name,
    String? description,
  });

  /// Delete a workspace
  Future<void> deleteWorkspace(String workspaceId);

  /// Share a workspace with a user
  Future<void> shareWorkspace({
    required String workspaceId,
    required String userEmail,
    required enums.ShareWorkspaceRequestRole role,
  });

  /// Remove a user from a workspace
  Future<void> removeUserFromWorkspace({
    required String workspaceId,
    required String targetUserId,
  });

  /// Create a default workspace
  Future<WorkspaceDto> createDefaultWorkspace();

  // Integration methods

  /// Get all integrations for the current user
  Future<List<IntegrationDto>> getIntegrations();

  /// Get available integration types
  Future<List<IntegrationTypeDto>> getIntegrationTypes();

  /// Get integration by ID
  Future<IntegrationDto> getIntegration(String id, {bool includeSensitive = false});

  /// Create a new integration
  Future<IntegrationDto> createIntegration(CreateIntegrationRequest request);

  /// Update an existing integration
  Future<IntegrationDto> updateIntegration(String id, UpdateIntegrationRequest request);

  /// Delete an integration
  Future<void> deleteIntegration(String id);

  /// Enable an integration
  Future<IntegrationDto> enableIntegration(String id);

  /// Disable an integration
  Future<IntegrationDto> disableIntegration(String id);

  /// Test an integration
  Future<Object> testIntegration(TestIntegrationRequest request);

  /// Dispose the service and clean up resources
  void dispose();
}
