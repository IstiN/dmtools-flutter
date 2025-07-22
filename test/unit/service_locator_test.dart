import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools/service_locator.dart';
import 'package:dmtools/providers/auth_provider.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
import 'package:dmtools/core/models/user.dart';
import 'package:dmtools/core/services/oauth_service.dart';
import 'package:dmtools/network/generated/openapi.models.swagger.dart';
import 'package:dmtools/network/generated/openapi.enums.swagger.dart' as enums;
import 'package:get_it/get_it.dart';

void main() {
  group('ServiceLocator', () {
    late MockAuthProvider mockAuthProvider;
    late MockApiService mockApiService;

    setUp(() {
      // Clear any existing registrations
      GetIt.I.reset();

      mockAuthProvider = MockAuthProvider();
      mockApiService = MockApiService();

      // Register test services
      GetIt.I.registerSingleton<AuthProvider>(mockAuthProvider);
      GetIt.I.registerSingleton<DmToolsApiService>(mockApiService);
    });

    tearDown(() {
      GetIt.I.reset();
    });

    group('User Info Initialization', () {
      test('should load user info from API when authenticated', () async {
        // Arrange
        const jwtUser = UserDto(
          id: 'user123',
          name: 'JWT User', // Limited info from JWT
          email: 'jwt@example.com',
        );

        const apiUser = UserDto(
          id: 'user123',
          name: 'Full API User', // Complete info from API
          email: 'api@example.com',
          picture: 'https://avatar.com/user.jpg',
          givenName: 'Full',
          familyName: 'User',
        );

        mockAuthProvider.mockIsAuthenticated = true;
        mockAuthProvider.mockCurrentUser = jwtUser; // Simulate JWT user data
        mockApiService.userToReturn = apiUser;

        // Act
        await ServiceLocator.initializeUserInfo();

        // Assert
        expect(mockApiService.getCurrentUserCalled, true);
        expect(mockAuthProvider.setUserInfoCalled, true);
        expect(mockAuthProvider.lastSetUser, apiUser);
      });

      test('should not load user info when not authenticated', () async {
        // Arrange
        mockAuthProvider.mockIsAuthenticated = false;

        // Act
        await ServiceLocator.initializeUserInfo();

        // Assert
        expect(mockApiService.getCurrentUserCalled, false);
        expect(mockAuthProvider.setUserInfoCalled, false);
      });

      test('should handle API service failure gracefully', () async {
        // Arrange
        mockAuthProvider.mockIsAuthenticated = true;
        mockApiService.shouldThrowError = true;

        // Act & Assert - Should not throw
        await ServiceLocator.initializeUserInfo();

        // Should attempt API call but gracefully handle failure
        expect(mockApiService.getCurrentUserCalled, true);
        expect(mockAuthProvider.setUserInfoCalled, false);
      });

      test('should load user info even when JWT user already exists', () async {
        // Arrange - This tests the fix we made earlier
        const existingJwtUser = UserDto(
          id: 'user123',
          name: 'Existing JWT User',
          email: 'jwt@example.com',
        );

        const fullApiUser = UserDto(
          id: 'user123',
          name: 'Complete API User',
          email: 'full@example.com',
          picture: 'https://avatar.com/user.jpg',
          preferredUsername: 'fulluser',
        );

        mockAuthProvider.mockIsAuthenticated = true;
        mockAuthProvider.mockCurrentUser = existingJwtUser; // User already exists from JWT
        mockApiService.userToReturn = fullApiUser;

        // Act
        await ServiceLocator.initializeUserInfo();

        // Assert - Should still call API and update user info
        expect(mockApiService.getCurrentUserCalled, true);
        expect(mockAuthProvider.setUserInfoCalled, true);
        expect(mockAuthProvider.lastSetUser, fullApiUser);
      });
    });

    group('Service Registration', () {
      test('should be able to get registered services', () {
        // Services are already registered in setUp() above
        // Act
        final authProvider = ServiceLocator.get<AuthProvider>();
        final apiService = ServiceLocator.get<DmToolsApiService>();

        // Assert
        expect(authProvider, isNotNull);
        expect(apiService, isNotNull);
        expect(authProvider, isA<MockAuthProvider>());
        expect(apiService, isA<MockApiService>());
      });
    });
  });
}

// Mock classes for testing

class MockAuthProvider extends AuthProvider {
  bool mockIsAuthenticated = false;
  UserDto? mockCurrentUser;
  bool setUserInfoCalled = false;
  UserDto? lastSetUser;

  MockAuthProvider() : super(oauthService: MockOAuthService());

  @override
  bool get isAuthenticated => mockIsAuthenticated;

  @override
  UserDto? get currentUser => mockCurrentUser;

  @override
  void setUserInfo(UserDto user) {
    setUserInfoCalled = true;
    lastSetUser = user;
    mockCurrentUser = user;
  }
}

class MockApiService implements DmToolsApiService {
  bool getCurrentUserCalled = false;
  bool shouldThrowError = false;
  UserDto? userToReturn;

  @override
  Future<UserDto> getCurrentUser() async {
    getCurrentUserCalled = true;

    if (shouldThrowError) {
      throw Exception('API Error');
    }

    return userToReturn ??
        const UserDto(
          id: 'default_user',
          name: 'Default User',
          email: 'default@example.com',
        );
  }

  @override
  Future<List<WorkspaceDto>> getWorkspaces() async => [];

  @override
  Future<WorkspaceDto> getWorkspace(String workspaceId) async => const WorkspaceDto();

  @override
  Future<WorkspaceDto> createWorkspace({required String name, String? description}) async => const WorkspaceDto();

  @override
  Future<void> deleteWorkspace(String workspaceId) async {}

  @override
  Future<void> shareWorkspace(
      {required String workspaceId, required String userEmail, required enums.ShareWorkspaceRequestRole role}) async {}

  @override
  Future<void> removeUserFromWorkspace({required String workspaceId, required String targetUserId}) async {}

  @override
  Future<WorkspaceDto> createDefaultWorkspace() async => const WorkspaceDto();

  // Integration methods

  @override
  Future<List<IntegrationDto>> getIntegrations() async => [];

  @override
  Future<List<IntegrationTypeDto>> getIntegrationTypes() async => [];

  @override
  Future<IntegrationDto> getIntegration(String id, {bool includeSensitive = false}) async => const IntegrationDto();

  @override
  Future<IntegrationDto> createIntegration(CreateIntegrationRequest request) async => const IntegrationDto();

  @override
  Future<IntegrationDto> updateIntegration(String id, UpdateIntegrationRequest request) async => const IntegrationDto();

  @override
  Future<void> deleteIntegration(String id) async {}

  @override
  Future<IntegrationDto> enableIntegration(String id) async => const IntegrationDto();

  @override
  Future<IntegrationDto> disableIntegration(String id) async => const IntegrationDto();

  @override
  Future<Object> testIntegration(TestIntegrationRequest request) async => {'success': true, 'message': 'Test passed'};

  // Job Configuration methods implementation
  @override
  Future<List<JobConfigurationDto>> getJobConfigurations({bool? enabled}) async {
    return [];
  }

  @override
  Future<JobConfigurationDto> getJobConfiguration(String id) async {
    return JobConfigurationDto(
      id: id,
      name: 'Test Configuration',
      description: 'Test Description',
      jobType: 'expert_analysis',
      enabled: true,
      executionCount: 0,
      createdAt: DateTime.now(),
      createdByName: 'Test User',
    );
  }

  @override
  Future<Map<String, dynamic>> getJobConfigurationRaw(String id) async {
    return {
      'id': id,
      'name': 'Test Configuration',
      'description': 'Test Description',
      'jobType': 'expert_analysis',
      'enabled': true,
      'executionCount': 0,
      'createdAt': DateTime.now().toIso8601String(),
      'createdByName': 'Test User',
      'jobParameters': {
        'testParam': 'testValue',
      },
      'integrationMappings': {
        'testIntegration': 'test-id-123',
      },
    };
  }

  @override
  Future<JobConfigurationDto> createJobConfiguration(CreateJobConfigurationRequest request) async {
    return JobConfigurationDto(
      id: 'test_config_${DateTime.now().millisecondsSinceEpoch}',
      name: request.name,
      description: request.description,
      jobType: request.jobType,
      enabled: request.enabled ?? true,
      executionCount: 0,
      createdAt: DateTime.now(),
      createdByName: 'Test User',
    );
  }

  @override
  Future<JobConfigurationDto> createJobConfigurationRaw(
      String name, String jobType, Map<String, dynamic> jobParameters, Map<String, dynamic> integrationMappings,
      {String? description, bool? enabled}) async {
    return JobConfigurationDto(
      id: 'test_config_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description ?? 'Test Description',
      jobType: jobType,
      enabled: enabled ?? true,
      executionCount: 0,
      createdAt: DateTime.now(),
      createdByName: 'Test User',
    );
  }

  @override
  Future<JobConfigurationDto> updateJobConfiguration(String id, UpdateJobConfigurationRequest request) async {
    return JobConfigurationDto(
      id: id,
      name: request.name ?? 'Updated Configuration',
      description: request.description ?? 'Updated Description',
      jobType: 'expert_analysis',
      enabled: request.enabled ?? true,
      executionCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdByName: 'Test User',
    );
  }

  @override
  Future<JobConfigurationDto> updateJobConfigurationRaw(
      String id, String name, Map<String, dynamic> jobParameters, Map<String, dynamic> integrationMappings,
      {String? description, bool? enabled}) async {
    return JobConfigurationDto(
      id: id,
      name: name,
      description: description ?? 'Test Description',
      jobType: 'expert_analysis',
      enabled: enabled ?? true,
      executionCount: 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      createdByName: 'Test User',
    );
  }

  @override
  Future<void> deleteJobConfiguration(String id) async {
    // Mock implementation
  }

  @override
  Future<Object> executeJobConfiguration(String id, ExecuteJobConfigurationRequest request) async {
    return {};
  }

  @override
  Future<JobTypeDto> getJobType(String jobName) async {
    return const JobTypeDto();
  }

  @override
  Future<List<JobTypeDto>> getAvailableJobTypes() async {
    return [
      const JobTypeDto(type: 'expert_analysis'),
      const JobTypeDto(type: 'code_review'),
      const JobTypeDto(type: 'issue_summary'),
    ];
  }

  @override
  void dispose() {}
}

class MockOAuthService extends OAuthService {
  @override
  Future<OAuthToken?> getCurrentToken() async => null;

  @override
  Future<Map<String, dynamic>?> initiateLogin(OAuthProvider provider) async {
    return {
      'auth_url': 'https://example.com/oauth',
      'state': 'test_state',
      'expires_in': 900,
    };
  }

  @override
  Future<bool> launchOAuthUrl(String authUrl) async => true;

  @override
  Future<bool> handleCallback(Uri callbackUri) async => true;

  @override
  Future<void> logout() async {}

  @override
  Future<UserDto?> getUserData() async => const UserDto(
        id: 'test_user',
        name: 'Test User',
        email: 'test@example.com',
        authenticated: true,
      );
}
