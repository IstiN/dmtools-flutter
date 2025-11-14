import 'package:flutter/foundation.dart';
import '../core/services/integration_service.dart';
import '../core/interfaces/auth_token_provider.dart';

/// Provider for managing integration state across the application
class IntegrationProvider extends ChangeNotifier {
  final IntegrationService _integrationService;
  final AuthTokenProvider? _authProvider;
  bool _isInitialized = false;
  bool _isLoading = false;
  String? _error;

  IntegrationProvider(this._integrationService) : _authProvider = _integrationService.authProvider {
    // Listen to the integration service for changes
    _integrationService.addListener(_onIntegrationServiceChanged);

    // Initialize if auth provider is already authenticated
    if (_authProvider != null && _authProvider.isAuthenticated) {
      _initialize();
    }

    // Listen to auth changes to initialize when user becomes authenticated
    _authProvider?.addListener(_onAuthChanged);
  }

  /// Getters
  bool get isInitialized => _isInitialized;
  bool get isLoading {
    final providerLoading = _isLoading;
    final serviceLoading = _integrationService.isLoading;
    final result = providerLoading || serviceLoading;

    if (kDebugMode && result) {
      debugPrint(
        '🔍 IntegrationProvider.isLoading: provider=$providerLoading, service=$serviceLoading, result=$result',
      );
    }

    return result;
  }

  String? get error => _error ?? _integrationService.error;
  List<IntegrationModel> get integrations => _integrationService.integrations;
  List<IntegrationTypeModel> get availableTypes => _integrationService.availableTypes;
  IntegrationService get service => _integrationService;

  /// Initialize the integration provider - load types and integrations
  Future<void> _initialize() async {
    if (_isInitialized || _isLoading) return;

    _setLoading(true);
    _clearError();

    try {
      if (kDebugMode) {
        debugPrint('🔄 IntegrationProvider: Initializing...');
      }

      // Load integration types and integrations in parallel
      await Future.wait([_integrationService.loadIntegrationTypes(), _integrationService.loadIntegrations()]);

      _isInitialized = true;

      if (kDebugMode) {
        debugPrint('✅ IntegrationProvider: Initialized successfully');
        debugPrint('   - Available types: ${availableTypes.length}');
        debugPrint('   - Current integrations: ${integrations.length}');
        debugPrint('   - MCP-ready integrations: ${service.mcpReadyIntegrations.length}');
      }
    } catch (e) {
      _setError('Failed to initialize integrations: ${e.toString()}');
      if (kDebugMode) {
        debugPrint('❌ IntegrationProvider: Initialization failed - $e');
      }
      // Reset initialization flag on error so we can retry
      _isInitialized = false;
    } finally {
      _setLoading(false);
    }
  }

  /// Refresh all integration data
  Future<void> refresh() async {
    if (kDebugMode) {
      debugPrint('🔄 IntegrationProvider: Refresh called - initialized: $_isInitialized, loading: $_isLoading');
    }

    if (!_isInitialized) {
      if (kDebugMode) {
        debugPrint('🔄 IntegrationProvider: Not initialized, calling _initialize()');
      }
      await _initialize();
      return;
    }

    if (kDebugMode) {
      debugPrint('🔄 IntegrationProvider: Already initialized, refreshing data...');
    }

    _setLoading(true);
    _clearError();

    try {
      await Future.wait([_integrationService.loadIntegrationTypes(), _integrationService.loadIntegrations()]);

      if (kDebugMode) {
        debugPrint('✅ IntegrationProvider: Refreshed successfully');
        debugPrint('   - Available types: ${availableTypes.length}');
        debugPrint('   - Current integrations: ${integrations.length}');
        debugPrint('   - MCP-ready integrations: ${service.mcpReadyIntegrations.length}');
      }
    } catch (e) {
      _setError('Failed to refresh integrations: ${e.toString()}');
      if (kDebugMode) {
        debugPrint('❌ IntegrationProvider: Refresh failed - $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new integration
  Future<IntegrationModel?> createIntegration({
    required String name,
    required String description,
    required String type,
    required Map<String, dynamic> configParams,
  }) async {
    if (kDebugMode) {
      // Creating integration
    }

    final request = CreateIntegrationRequest(
      name: name,
      description: description,
      type: type,
      configParams: configParams,
    );

    final result = await _integrationService.createIntegration(request);

    if (result != null && kDebugMode) {
      // Integration created successfully
    }

    return result;
  }

  /// Update an existing integration
  Future<bool> updateIntegration({
    required String integrationId,
    required String name,
    required String description,
    required Map<String, dynamic> configParams,
    bool? enabled,
  }) async {
    if (kDebugMode) {
      debugPrint('🔄 IntegrationProvider: Updating integration - $integrationId');
    }

    final request = UpdateIntegrationRequest(
      name: name,
      description: description,
      configParams: configParams,
      enabled: enabled,
    );

    final result = await _integrationService.updateIntegration(integrationId, request);

    if (result && kDebugMode) {
      // Integration updated successfully
    }

    return result;
  }

  /// Delete an integration
  Future<bool> deleteIntegration(String integrationId) async {
    if (kDebugMode) {
      debugPrint('🗑️ IntegrationProvider: Deleting integration - $integrationId');
    }

    final result = await _integrationService.deleteIntegration(integrationId);

    if (result && kDebugMode) {
      // Integration deleted successfully
    }

    return result;
  }

  /// Enable an integration
  Future<bool> enableIntegration(String integrationId) async {
    if (kDebugMode) {
      debugPrint('✅ IntegrationProvider: Enabling integration - $integrationId');
    }

    final result = await _integrationService.enableIntegration(integrationId);

    if (result && kDebugMode) {
      // Integration enabled successfully
    }

    return result;
  }

  /// Disable an integration
  Future<bool> disableIntegration(String integrationId) async {
    if (kDebugMode) {
      debugPrint('❌ IntegrationProvider: Disabling integration - $integrationId');
    }

    final result = await _integrationService.disableIntegration(integrationId);

    if (result && kDebugMode) {
      debugPrint('✅ IntegrationProvider: Integration disabled successfully');
    }

    return result;
  }

  /// Test an integration connection
  Future<Map<String, dynamic>?> testIntegration({
    required String type,
    required Map<String, dynamic> configParams,
  }) async {
    if (kDebugMode) {
      debugPrint('🔧 IntegrationProvider: Testing integration - $type');
    }

    final request = TestIntegrationRequest(type: type, configParams: configParams);

    final result = await _integrationService.testIntegration(request);

    if (result != null && kDebugMode) {
      final success = result['success'] ?? false;
      debugPrint('${success ? '✅' : '❌'} IntegrationProvider: Integration test ${success ? 'passed' : 'failed'}');
    }

    return result;
  }

  /// Get integration by ID from local cache
  IntegrationModel? getIntegration(String integrationId) {
    return _integrationService.getIntegration(integrationId);
  }

  /// Get integration details by ID with full config parameters from API
  Future<IntegrationModel?> getIntegrationById(String integrationId, {bool includeSensitive = true}) async {
    if (kDebugMode) {
      debugPrint('🔄 IntegrationProvider: Fetching integration details - $integrationId');
    }

    final result = await _integrationService.getIntegrationById(integrationId, includeSensitive: includeSensitive);

    if (result != null && kDebugMode) {
      debugPrint('✅ IntegrationProvider: Integration details fetched successfully');
    }

    return result;
  }

  /// Get integration type by type string
  IntegrationTypeModel? getIntegrationType(String type) {
    return _integrationService.getIntegrationType(type);
  }

  /// Get integrations by type
  List<IntegrationModel> getIntegrationsByType(String type) {
    return integrations.where((integration) => integration.type == type).toList();
  }

  /// Get enabled integrations
  List<IntegrationModel> get enabledIntegrations {
    return integrations.where((integration) => integration.enabled).toList();
  }

  /// Get disabled integrations
  List<IntegrationModel> get disabledIntegrations {
    return integrations.where((integration) => !integration.enabled).toList();
  }

  /// Get integration types by category
  List<IntegrationTypeModel> getIntegrationTypesByCategory(String category) {
    // Note: This would need to be implemented in the IntegrationTypeModel
    // For now, just return all types
    return availableTypes;
  }

  /// Get popular integration types
  List<IntegrationTypeModel> get popularIntegrationTypes {
    // For now, return priority types: Jira, Confluence, GitHub
    final priorityTypes = ['jira', 'confluence', 'github'];
    return availableTypes.where((type) => priorityTypes.contains(type.type)).toList();
  }

  /// Check if an integration type is supported
  bool isIntegrationTypeSupported(String type) {
    return availableTypes.any((integrationType) => integrationType.type == type);
  }

  /// Get integration usage statistics
  Map<String, int> get integrationUsageStats {
    final stats = <String, int>{};
    for (final integration in integrations) {
      stats[integration.type] = (stats[integration.type] ?? 0) + integration.usageCount;
    }
    return stats;
  }

  /// Get total integration count
  int get totalIntegrationCount => integrations.length;

  /// Get enabled integration count
  int get enabledIntegrationCount => enabledIntegrations.length;

  /// Get disabled integration count
  int get disabledIntegrationCount => disabledIntegrations.length;

  /// Private methods
  void _onIntegrationServiceChanged() {
    notifyListeners();
  }

  void _onAuthChanged() {
    // Check if user just became authenticated
    if (!_isInitialized) {
      _initialize();
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  /// Force reinitialize (useful for testing or after auth changes)
  Future<void> forceReinitialize() async {
    if (kDebugMode) {
      debugPrint(
        '🔄 IntegrationProvider: Force reinitialize called - current state: initialized: $_isInitialized, loading: $_isLoading',
      );
    }
    _isInitialized = false;
    await _initialize();
    if (kDebugMode) {
      debugPrint(
        '🔄 IntegrationProvider: Force reinitialize completed - new state: initialized: $_isInitialized, loading: $_isLoading',
      );
    }
  }

  @override
  void dispose() {
    // Remove auth provider listener first
    _authProvider?.removeListener(_onAuthChanged);
    // Remove integration service listener
    _integrationService.removeListener(_onIntegrationServiceChanged);
    super.dispose();
  }
}
