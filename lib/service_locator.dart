import './core/config/app_config.dart';
import './network/services/api_service.dart';
import './providers/auth_provider.dart';
import './providers/integration_provider.dart';
import './providers/mcp_provider.dart';
import './core/services/integration_service.dart';
import './core/services/mcp_service.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

abstract final class ServiceLocator {
  static void init() {
    // Debug AppConfig values
    if (kDebugMode) {
      print('🔧 ServiceLocator.init() - AppConfig values:');
      print('   enableMockData: ${AppConfig.enableMockData}');
      print('   baseUrl: ${AppConfig.baseUrl}');
      print('   enableLogging: ${AppConfig.enableLogging}');
    }

    // Create AuthProvider first (no dependencies)
    GetIt.I.registerLazySingleton(() => AuthProvider());

    // Create API service with AuthProvider
    GetIt.I.registerLazySingleton<ApiService>(
      () => ApiService(
        baseUrl: AppConfig.baseUrl,
        authProvider: get<AuthProvider>(),
        enableLogging: AppConfig.enableLogging,
      ),
    );

    // Create IntegrationService with dependencies
    GetIt.I.registerLazySingleton<IntegrationService>(
      () => IntegrationService(
        apiService: get<ApiService>(),
        authProvider: get<AuthProvider>(),
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
        authProvider: get<AuthProvider>(),
        enableLogging: AppConfig.enableLogging,
      ),
    );

    // Create MCP provider with dependencies
    GetIt.I.registerLazySingleton<McpProvider>(
      () => McpProvider(get<McpService>()),
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
