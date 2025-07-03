import 'package:dmtools/core/config/app_config.dart';
import 'package:dmtools/network/services/dm_tools_api_service.dart';
import 'package:dmtools/network/services/dm_tools_api_service_impl.dart';
import 'package:dmtools/network/services/dm_tools_api_service_mock.dart';
import 'package:dmtools/providers/auth_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/foundation.dart';

abstract final class ServiceLocator {
  static void init() {
    // Create AuthProvider first (no dependencies)
    GetIt.I.registerLazySingleton(() => AuthProvider());

    // Create API service with AuthProvider
    GetIt.I.registerLazySingleton<DmToolsApiService>(() => AppConfig.enableMockData
        ? DmToolsApiServiceMock()
        : DmToolsApiServiceImpl(
            baseUrl: AppConfig.baseUrl,
            authProvider: get<AuthProvider>(),
            enableLogging: AppConfig.enableLogging,
          ));
  }

  static T get<T extends Object>() => GetIt.I.get<T>();

  /// Initialize user info after both AuthProvider and API service are available
  /// This should be called after authentication is successful
  static Future<void> initializeUserInfo() async {
    try {
      final authProvider = get<AuthProvider>();
      final apiService = get<DmToolsApiService>();

      if (authProvider.isAuthenticated) {
        if (kDebugMode) {
          print('🔄 Loading full user profile from API...');
          print('   Current user from JWT: ${authProvider.currentUser?.name} (${authProvider.currentUser?.email})');
        }

        final user = await apiService.getCurrentUser();
        authProvider.setUserInfo(user);

        if (kDebugMode) {
          print('✅ Full user profile loaded from API: ${user.name} (${user.email})');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ User info loading failed: $e');
        print('   Falling back to JWT data');
      }
      // User info loading failed, but auth is still valid via JWT
      // This is non-critical as JWT decoding provides basic user info
    }
  }
}
