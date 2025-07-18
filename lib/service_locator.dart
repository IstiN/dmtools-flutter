import 'package:dmtools/core/config/app_config.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
import 'package:dmtools/network/services/dm_tools_api_service_impl.dart';
import 'package:dmtools/network/services/dm_tools_api_service_mock.dart';
import 'package:dmtools/providers/auth_provider.dart';
import 'package:dmtools/providers/integration_provider.dart';
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
    if (AppConfig.enableMockData) {
      if (kDebugMode) {
        print('🔧 ServiceLocator: Using MOCK API service');
      }
      GetIt.I.registerLazySingleton<DmToolsApiService>(() => DmToolsApiServiceMock());
    } else {
      if (kDebugMode) {
        print('🔧 ServiceLocator: Using REAL API service');
      }
      GetIt.I.registerLazySingleton<DmToolsApiService>(
        () => DmToolsApiServiceImpl(
          baseUrl: AppConfig.baseUrl,
          authProvider: get<AuthProvider>(),
          enableLogging: AppConfig.enableLogging,
        ),
      );
    }

    // Create IntegrationProvider with dependencies
    GetIt.I.registerLazySingleton<IntegrationProvider>(
      () => IntegrationProvider(
        apiService: get<DmToolsApiService>(),
        authProvider: get<AuthProvider>(),
      ),
    );
  }

  static T get<T extends Object>() => GetIt.I.get<T>();

  /// Initialize user info after both AuthProvider and API service are available
  /// This should be called after authentication is successful
  static Future<void> initializeUserInfo() async {
    try {
      final authProvider = get<AuthProvider>();
      final apiService = get<DmToolsApiService>();

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
