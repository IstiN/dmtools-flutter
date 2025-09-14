import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../mixins/loading_state_mixin.dart' as app_loading;
import '../services/authenticated_service.dart';
import '../../providers/enhanced_auth_provider.dart';

/// Abstract base class for pages that require authentication.
/// Handles auth state management, loading states, and provides a clean
/// interface for authenticated operations.
///
/// Pages extending this class only need to implement:
/// - loadAuthenticatedData(): Load page-specific data after auth is confirmed
/// - buildAuthenticatedContent(): Build the UI for authenticated users
///
/// The base class automatically handles:
/// - Authentication checking and waiting
/// - Auth state transitions (unauthenticated -> authenticated)
/// - Loading states during auth and data loading
/// - Error handling for auth and data operations
/// - Consistent UI patterns across all authenticated pages
abstract class AuthenticatedPage<T extends StatefulWidget> extends State<T> with app_loading.LoadingStateMixin<T> {
  bool _lastAuthState = false;
  AuthenticatedService? _authService;

  /// Override this to load page-specific data after authentication is confirmed.
  /// This method is called automatically when the user becomes authenticated.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// Future<void> loadAuthenticatedData() async {
  ///   final configurations = await _authService!.executeWithIntegrations(() async {
  ///     return await context.read<McpProvider>().loadConfigurations();
  ///   });
  ///
  ///   if (configurations.isEmpty) {
  ///     setEmpty();
  ///   } else {
  ///     setLoaded();
  ///   }
  /// }
  /// ```
  Future<void> loadAuthenticatedData();

  /// Override this to build the UI content for authenticated users.
  /// This is called when the page is in the loaded state.
  ///
  /// The context will have access to all authenticated providers and services.
  Widget buildAuthenticatedContent(BuildContext context);

  /// Optional: Override to customize loading message
  String get loadingMessage => 'Loading...';

  /// Optional: Override to customize error title
  String get errorTitle => 'Error loading data';

  /// Optional: Override to customize empty state title
  String get emptyTitle => 'No data available';

  /// Optional: Override to customize empty state message
  String get emptyMessage => 'No data found for your account';

  /// Optional: Override to customize empty state icon
  IconData get emptyIcon => Icons.inbox_outlined;

  /// Optional: Override to require integrations for this page
  bool get requiresIntegrations => false;

  /// Access to the authenticated service for manual operations
  AuthenticatedService get authService => _authService!;

  @override
  void initState() {
    super.initState();

    // Initialize auth service immediately (not in post frame callback)
    _authService = AuthenticatedService(context);
    final authProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);
    _lastAuthState = authProvider.isAuthenticated;

    // Listen for auth state changes
    authProvider.addListener(_onAuthStateChanged);

    // Let the LoadingStateMixin handle the initial loadData() call
    // We don't need to call it ourselves
  }

  @override
  void dispose() {
    // Clean up auth listener
    try {
      final authProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);
      authProvider.removeListener(_onAuthStateChanged);
    } catch (_) {
      // Provider might not be available during disposal
    }
    super.dispose();
  }

  void _onAuthStateChanged() {
    if (!mounted) return;

    final authProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);
    final currentAuthState = authProvider.isAuthenticated;

    if (currentAuthState != _lastAuthState) {
      print('🔐 AuthenticatedPage: Auth state changed from $_lastAuthState to $currentAuthState');
      _lastAuthState = currentAuthState;

      if (currentAuthState) {
        print('🔐 AuthenticatedPage: User became authenticated, reloading data...');
        retry(); // Reload data with new auth state
      }
    }
  }

  @override
  Future<void> loadData() async {
    print('🔐 AuthenticatedPage: Starting authenticated data load...');

    try {
      final authProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);

      if (!authProvider.isAuthenticated) {
        print('🔐 AuthenticatedPage: User not authenticated, waiting for auth...');
        // For unauthenticated users, show loading state until auth completes
        // The auth listener will trigger reload when authentication happens
        return;
      }

      print('🔐 AuthenticatedPage: User authenticated, loading page data...');

      // Ensure auth service is initialized
      if (_authService == null) {
        print('🔐 AuthenticatedPage: Auth service not ready, delaying...');
        await Future.delayed(const Duration(milliseconds: 100));
        if (!mounted) return;

        if (_authService == null) {
          setError('Authentication service not available');
          return;
        }
      }

      // User is authenticated, load page-specific data
      await loadAuthenticatedData();
    } catch (e) {
      print('🔐 AuthenticatedPage: Error loading authenticated data: $e');
      setError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EnhancedAuthProvider>(
      builder: (context, authProvider, child) {
        print('🔐 AuthenticatedPage: Building with auth: ${authProvider.isAuthenticated}, state: $loadingState');

        // Handle unauthenticated state
        if (!authProvider.isAuthenticated) {
          return _buildUnauthenticatedState();
        }

        // Handle authenticated states using loading state wrapper
        return buildWithLoadingState(
          loadingMessage: loadingMessage,
          errorTitle: errorTitle,
          emptyTitle: emptyTitle,
          emptyMessage: emptyMessage,
          emptyIcon: emptyIcon,
          child: buildAuthenticatedContent(context),
        );
      },
    );
  }

  Widget _buildUnauthenticatedState() {
    return const LoadingStateWrapper(
      state: PageLoadingState.loading,
      loadingMessage: 'Authenticating...',
      child: SizedBox.shrink(),
    );
  }
}

/// Extension to provide quick access to AuthenticatedService from any page
extension AuthenticatedPageExtension on BuildContext {
  AuthenticatedService get authService => AuthenticatedService(this);
}
