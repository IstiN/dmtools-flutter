import 'package:chopper/chopper.dart';
import 'package:flutter/foundation.dart';

import '../generated/openapi.swagger.dart';
import '../interceptors/auth_interceptor.dart';
import '../interceptors/logging_interceptor.dart';
import '../../providers/auth_provider.dart';
import '../../core/config/app_config.dart';

/// Configuration for API client
class ApiClientConfig {
  /// Create a configured Chopper client
  static ChopperClient createClient({
    String? baseUrl,
    AuthProvider? authProvider,
    bool enableLogging = true,
  }) {
    final List<Interceptor> interceptors = [];

    // Add authentication interceptor if auth provider is provided
    if (authProvider != null) {
      interceptors.add(AuthInterceptor(authProvider));
    }

    // Add logging interceptor in debug mode
    if (enableLogging && kDebugMode) {
      interceptors.add(const LoggingInterceptor());
    }

    return ChopperClient(
      baseUrl: Uri.parse(baseUrl ?? AppConfig.baseUrl),
      services: [
        Openapi.create(),
      ],
      converter: $JsonSerializableConverter(),
      interceptors: interceptors,
    );
  }
}

/// Extension to get typed services from ChopperClient
extension ChopperClientExtensions on ChopperClient {
  /// Get the OpenAPI service
  T getService<T extends ChopperService>() {
    return getService<T>();
  }
}
