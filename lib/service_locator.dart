import './core/config/app_config.dart';
import './network/services/api_service.dart';
import './network/services/auth_api_service.dart';
import './providers/auth_provider.dart';
import './providers/enhanced_auth_provider.dart';
import './providers/integration_provider.dart';
import './providers/mcp_provider.dart';
import './providers/chat_provider.dart';
import './core/services/integration_service.dart';
import './core/services/mcp_service.dart';
import './core/services/chat_service.dart';
import './core/services/file_service.dart';
import './core/services/auth_config_service.dart';
import './core/services/local_auth_service.dart';
import './core/services/credentials_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

abstract final class ServiceLocator {
  static void init({String? serverPort}) {
    // Construct baseUrl from server port if provided
    final baseUrl = serverPort != null ? 'http://localhost:$serverPort' : AppConfig.baseUrl;
    
    // Debug AppConfig values
    print('[SERVICE_LOCATOR] Initializing with:');
    print('   serverPort: $serverPort');
    print('   baseUrl: $baseUrl');
    print('   enableMockData: ${AppConfig.enableMockData}');
    print('   enableLogging: ${AppConfig.enableLogging}');

    // Create AuthProvider first (no dependencies)
    GetIt.I.registerLazySingleton(() => AuthProvider());

    // Create enhanced auth services with custom baseUrl
    GetIt.I.registerLazySingleton<AuthConfigService>(() => AuthConfigService(baseUrl: baseUrl));
    GetIt.I.registerLazySingleton<LocalAuthService>(() => LocalAuthService(baseUrl: baseUrl));
    GetIt.I.registerLazySingleton<CredentialsService>(() => CredentialsService());
    GetIt.I.registerLazySingleton<AuthApiService>(() => AuthApiService(baseUrl: baseUrl));

    // Create EnhancedAuthProvider with dependencies
    GetIt.I.registerLazySingleton<EnhancedAuthProvider>(
      () => EnhancedAuthProvider(
        authConfigService: get<AuthConfigService>(),
        localAuthService: get<LocalAuthService>(),
        credentialsService: get<CredentialsService>(),
        authApiService: get<AuthApiService>(),
      ),
    );

    // Create API service with EnhancedAuthProvider
    GetIt.I.registerLazySingleton<ApiService>(
      () {
        final authProvider = get<EnhancedAuthProvider>();
        return ApiService(
          baseUrl: AppConfig.baseUrl,
          authProvider: authProvider,
          onAuthenticationFailed: authProvider.handleAuthenticationFailure,
          enableLogging: AppConfig.enableLogging,
        );
      },
    );

    // Create IntegrationService with dependencies
    GetIt.I.registerLazySingleton<IntegrationService>(
      () => IntegrationService(
        apiService: get<ApiService>(),
        authProvider: get<EnhancedAuthProvider>(),
      ),
    );

    // Create IntegrationProvider with dependencies
    GetIt.I.registerLazySingleton<IntegrationProvider>(
      () => IntegrationProvider(get<IntegrationService>()),
    );

    // Create MCP service with dependencies
    GetIt.I.registerLazySingleton<McpService>(
      () => McpService(
        baseUrl: AppConfig.baseUrl,
        authProvider: get<EnhancedAuthProvider>(),
        enableLogging: AppConfig.enableLogging,
      ),
    );

    // Create MCP provider with dependencies
    GetIt.I.registerLazySingleton<McpProvider>(
      () => McpProvider(get<McpService>()),
    );

    // Create ChatService with dependencies
    GetIt.I.registerLazySingleton<ChatService>(
      () => ChatService(
        apiService: get<ApiService>(),
        authProvider: get<EnhancedAuthProvider>(),
      ),
    );

    // Create FileService (no dependencies)
    GetIt.I.registerLazySingleton<FileService>(
      () => FileService(),
    );

    // Create ChatProvider with dependencies
    GetIt.I.registerLazySingleton<ChatProvider>(
      () => ChatProvider(
        get<ChatService>(),
        get<IntegrationService>(),
        get<McpProvider>(),
      ),
    );
  }

  static T get<T extends Object>() => GetIt.I.get<T>();

  /// Initialize user info after both AuthProvider and API service are available
  /// This should be called after authentication is successful
  static Future<void> initializeUserInfo() async {
    try {
      final authProvider = get<AuthProvider>();
      final apiService = get<ApiService>();

      if (authProvider.isAuthenticated) {
        final currentUser = authProvider.currentUser;
        if (kDebugMode) {
          print('🔄 Loading full user profile from API...');
          print('   Current user: ${currentUser?.name} (${currentUser?.email})');
        }

        // Try to get full user profile from API
        final user = await apiService.getCurrentUser();
        authProvider.setUserInfo(user);

        if (kDebugMode) {
          print('✅ Full user profile loaded from API: ${user.name} (${user.email})');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ User not authenticated, skipping user info initialization');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ User info loading failed: $e');
        print('   Continuing with existing user data');
      }
      // User info loading failed, but auth is still valid
      // This is non-critical - we can continue with limited user info
    }
  }
}
