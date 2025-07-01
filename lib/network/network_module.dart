import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'services/api_service.dart';
import '../providers/auth_provider.dart';
import '../core/config/app_config.dart';

/// Network module for dependency injection
class NetworkModule {
  /// Configure network services
  static List<SingleChildWidget> getProviders() {
    return [
      // API Service
      ProxyProvider<AuthProvider, ApiService>(
        update: (context, authProvider, previous) {
          return ApiService(
            baseUrl: AppConfigManager.instance.baseUrl,
            authProvider: authProvider,
          );
        },
        dispose: (context, apiService) => apiService.dispose(),
      ),
    ];
  }

  /// Create a standalone API service for testing
  static ApiService createApiService({
    String? baseUrl,
    AuthProvider? authProvider,
    bool enableLogging = true,
  }) {
    return ApiService(
      baseUrl: baseUrl ?? AppConfigManager.instance.baseUrl,
      authProvider: authProvider,
      enableLogging: enableLogging,
    );
  }
}
