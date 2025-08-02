import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';
import '../../providers/auth_provider.dart' as app_auth;
import '../../providers/integration_provider.dart';

/// High-level service that ensures authentication before executing any operations.
/// This abstraction handles the auth flow automatically and provides a clean
/// interface for authenticated operations.
class AuthenticatedService {
  final BuildContext context;

  AuthenticatedService(this.context);

  /// Executes an authenticated operation. If user is not authenticated,
  /// this will handle the auth flow automatically.
  ///
  /// [operation] - The operation to execute after ensuring authentication
  /// [requireIntegrations] - Whether to ensure integrations are also loaded
  /// [retries] - Number of retries if auth fails (default: 1)
  Future<T> execute<T>(
    Future<T> Function() operation, {
    bool requireIntegrations = false,
    int retries = 1,
  }) async {
    for (int attempt = 0; attempt <= retries; attempt++) {
      try {
        // Ensure user is authenticated
        await _ensureAuthenticated();

        // Ensure integrations are loaded if required
        if (requireIntegrations) {
          await _ensureIntegrationsLoaded();
        }

        // Execute the operation
        return await operation();
      } catch (e) {
        if (attempt == retries) {
          rethrow; // Last attempt failed, rethrow the error
        }

        // Wait before retry
        await Future.delayed(Duration(milliseconds: 500 * (attempt + 1)));
      }
    }

    throw Exception('Operation failed after $retries retries');
  }

  /// Executes multiple authenticated operations in parallel.
  /// All operations will be executed only after authentication is ensured.
  Future<List<T>> executeParallel<T>(
    List<Future<T> Function()> operations, {
    bool requireIntegrations = false,
  }) async {
    // Ensure auth first
    await _ensureAuthenticated();

    if (requireIntegrations) {
      await _ensureIntegrationsLoaded();
    }

    // Execute all operations in parallel
    return await Future.wait(
      operations.map((operation) => operation()).toList(),
    );
  }

  /// Executes authenticated operations in sequence.
  /// Useful when operations depend on each other.
  Future<List<T>> executeSequential<T>(
    List<Future<T> Function()> operations, {
    bool requireIntegrations = false,
  }) async {
    // Ensure auth first
    await _ensureAuthenticated();

    if (requireIntegrations) {
      await _ensureIntegrationsLoaded();
    }

    // Execute operations sequentially
    final results = <T>[];
    for (final operation in operations) {
      results.add(await operation());
    }

    return results;
  }

  /// Convenience method for operations that need both auth and integrations
  Future<T> executeWithIntegrations<T>(
    Future<T> Function() operation, {
    int retries = 1,
  }) async {
    return execute(
      operation,
      requireIntegrations: true,
      retries: retries,
    );
  }

  /// Checks if user is currently authenticated without triggering auth flow
  bool get isAuthenticated {
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
    return authProvider.isAuthenticated;
  }

  /// Checks if integrations are loaded without triggering loading
  bool get areIntegrationsLoaded {
    final integrationProvider = Provider.of<IntegrationProvider>(context, listen: false);
    return integrationProvider.isInitialized && !integrationProvider.isLoading;
  }

  /// Gets current auth status information
  AuthStatus get authStatus {
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);
    final integrationProvider = Provider.of<IntegrationProvider>(context, listen: false);

    return AuthStatus(
      isAuthenticated: authProvider.isAuthenticated,
      isLoading: authProvider.isLoading,
      areIntegrationsLoaded: integrationProvider.isInitialized && !integrationProvider.isLoading,
      areIntegrationsLoading: integrationProvider.isLoading,
      user: authProvider.currentUser,
    );
  }

  // Private methods

  Future<void> _ensureAuthenticated() async {
    final authProvider = Provider.of<app_auth.AuthProvider>(context, listen: false);

    if (authProvider.isAuthenticated) {
      print('🔐 AuthenticatedService: User already authenticated');
      return;
    }

    print('🔐 AuthenticatedService: User not authenticated, waiting for auth...');

    // Wait for auth to complete (this handles the automatic auth flow)
    int attempts = 0;
    const maxAttempts = 30; // 15 seconds max wait

    while (!authProvider.isAuthenticated && attempts < maxAttempts) {
      await Future.delayed(const Duration(milliseconds: 500));
      attempts++;

      if (attempts % 4 == 0) {
        // Log every 2 seconds
        print('🔐 AuthenticatedService: Still waiting for authentication... (${attempts * 0.5}s)');
      }
    }

    if (!authProvider.isAuthenticated) {
      throw AuthenticationTimeoutException('Authentication timeout after ${maxAttempts * 0.5} seconds');
    }

    print('🔐 AuthenticatedService: Authentication completed successfully');
  }

  Future<void> _ensureIntegrationsLoaded() async {
    final integrationProvider = Provider.of<IntegrationProvider>(context, listen: false);

    if (integrationProvider.isInitialized && !integrationProvider.isLoading) {
      print('🔧 AuthenticatedService: Integrations already loaded');
      return;
    }

    print('🔧 AuthenticatedService: Loading integrations...');

    if (!integrationProvider.isInitialized) {
      await integrationProvider.forceReinitialize();
    }

    // Always wait for loading to complete, even after forceReinitialize
    if (integrationProvider.isLoading) {
      print('🔧 AuthenticatedService: Waiting for integration loading to complete...');
      int attempts = 0;
      const maxAttempts = 20; // 10 seconds max wait

      while (integrationProvider.isLoading && attempts < maxAttempts) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
        print('🔧 AuthenticatedService: Still waiting... ($attempts/20)');
      }

      if (integrationProvider.isLoading) {
        throw IntegrationLoadingTimeoutException('Integration loading timeout after ${maxAttempts * 0.5} seconds');
      }
    }

    print('🔧 AuthenticatedService: Integrations loaded successfully');
  }
}

/// Extension to easily access AuthenticatedService from BuildContext
extension AuthenticatedServiceExtension on BuildContext {
  AuthenticatedService get authenticatedService => AuthenticatedService(this);
}

/// Data class containing current authentication status
class AuthStatus {
  final bool isAuthenticated;
  final bool isLoading;
  final bool areIntegrationsLoaded;
  final bool areIntegrationsLoading;
  final dynamic user;

  const AuthStatus({
    required this.isAuthenticated,
    required this.isLoading,
    required this.areIntegrationsLoaded,
    required this.areIntegrationsLoading,
    this.user,
  });

  bool get isReady => isAuthenticated && !isLoading;
  bool get isFullyReady => isReady && areIntegrationsLoaded && !areIntegrationsLoading;

  @override
  String toString() {
    return 'AuthStatus(authenticated: $isAuthenticated, loading: $isLoading, '
        'integrationsLoaded: $areIntegrationsLoaded, integrationsLoading: $areIntegrationsLoading)';
  }
}

/// Custom exceptions for authentication service
class AuthenticationTimeoutException implements Exception {
  final String message;
  AuthenticationTimeoutException(this.message);

  @override
  String toString() => 'AuthenticationTimeoutException: $message';
}

class IntegrationLoadingTimeoutException implements Exception {
  final String message;
  IntegrationLoadingTimeoutException(this.message);

  @override
  String toString() => 'IntegrationLoadingTimeoutException: $message';
}
