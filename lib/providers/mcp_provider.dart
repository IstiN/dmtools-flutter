import 'package:flutter/foundation.dart';
import '../core/models/mcp_configuration.dart';
import '../core/services/mcp_service.dart';

/// Provider for managing MCP (Model Context Protocol) configurations state
class McpProvider extends ChangeNotifier {
  final McpService _mcpService;

  McpProvider(this._mcpService);

  // State
  List<McpConfiguration> _configurations = [];
  bool _isLoading = false;
  String? _error;
  McpConfiguration? _selectedConfiguration;

  // Getters
  List<McpConfiguration> get configurations => _configurations;
  bool get isLoading => _isLoading;
  String? get error => _error;
  McpConfiguration? get selectedConfiguration => _selectedConfiguration;

  bool get hasConfigurations => _configurations.isNotEmpty;
  bool get hasError => _error != null;

  /// Load all MCP configurations
  Future<void> loadConfigurations() async {
    debugPrint('🔧 McpProvider: Loading configurations...');
    _setLoading(true);
    _clearError();

    try {
      _configurations = await _mcpService.getMcpConfigurations();
      debugPrint('🔧 McpProvider: Loaded ${_configurations.length} configurations');
      notifyListeners();
    } catch (e) {
      debugPrint('🔧 McpProvider: Error loading configurations: $e');
      _setError('Failed to load MCP configurations: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Load a specific MCP configuration
  Future<void> loadConfiguration(String id) async {
    _setLoading(true);
    _clearError();

    try {
      _selectedConfiguration = await _mcpService.getMcpConfiguration(id);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load MCP configuration: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  /// Create a new MCP configuration
  Future<bool> createConfiguration({
    required String name,
    required List<String> integrationIds,
    String? description,
  }) async {
    debugPrint('🔧 McpProvider: Creating configuration with name: $name, integrationIds: $integrationIds');
    debugPrint('🔧 McpProvider: _mcpService type: ${_mcpService.runtimeType}');

    _setLoading(true);
    _clearError();

    try {
      debugPrint('🔧 McpProvider: Calling API with integrationIds: $integrationIds');
      debugPrint('🔧 McpProvider: Before API call');

      final newConfig = await _mcpService.createMcpConfiguration(
        name: name,
        description: description,
        integrationIds: integrationIds,
      );

      debugPrint('🔧 McpProvider: After API call');
      debugPrint('🔧 McpProvider: Configuration created successfully: ${newConfig.id}');
      _configurations.add(newConfig);
      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      debugPrint('🔧 McpProvider: Error creating configuration: $e');
      debugPrint('🔧 McpProvider: Stack trace: $stackTrace');
      _setError('Failed to create MCP configuration: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update an existing MCP configuration
  Future<bool> updateConfiguration({
    required String id,
    required String name,
    required List<String> integrationIds,
    String? description,
  }) async {
    debugPrint('🔧 McpProvider: Updating configuration $id with name: $name, integrationIds: $integrationIds');

    _setLoading(true);
    _clearError();

    try {
      debugPrint('🔧 McpProvider: Calling update API with integrationIds: $integrationIds');
      debugPrint('🔧 McpProvider: Before update API call');

      final updatedConfig = await _mcpService.updateMcpConfiguration(
        id: id,
        name: name,
        description: description,
        integrationIds: integrationIds,
      );

      debugPrint('🔧 McpProvider: After update API call');
      debugPrint('🔧 McpProvider: Configuration updated successfully: ${updatedConfig.id}');

      // Update the configuration in the list
      final index = _configurations.indexWhere((config) => config.id == id);
      if (index != -1) {
        _configurations[index] = updatedConfig;
      } else {
        // If not found in list, add it
        _configurations.add(updatedConfig);
      }

      // Update selected configuration if it's the one being updated
      if (_selectedConfiguration?.id == id) {
        _selectedConfiguration = updatedConfig;
      }

      notifyListeners();
      return true;
    } catch (e, stackTrace) {
      debugPrint('🔧 McpProvider: Error updating configuration: $e');
      debugPrint('🔧 McpProvider: Stack trace: $stackTrace');
      _setError('Failed to update MCP configuration: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Delete an MCP configuration
  Future<bool> deleteConfiguration(String id) async {
    _setLoading(true);
    _clearError();

    try {
      await _mcpService.deleteMcpConfiguration(id);
      _configurations.removeWhere((config) => config.id == id);

      // Clear selected config if it was deleted
      if (_selectedConfiguration?.id == id) {
        _selectedConfiguration = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to delete MCP configuration: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Generate configuration code
  Future<String> generateConfigurationCode(String configId, {String format = 'json'}) async {
    try {
      return await _mcpService.generateMcpConfigurationCode(configId, format: format);
    } catch (e) {
      debugPrint('🔧 McpProvider: Error generating configuration code: $e');
      return 'Error: Failed to generate configuration code.';
    }
  }

  /// Select a configuration for viewing details
  void selectConfiguration(McpConfiguration? configuration) {
    _selectedConfiguration = configuration;
    notifyListeners();
  }

  /// Clear selected configuration
  void clearSelection() {
    _selectedConfiguration = null;
    notifyListeners();
  }

  /// Refresh configurations
  Future<void> refresh() async {
    await loadConfigurations();
  }

  /// Clear error state
  void clearError() {
    _clearError();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    if (_error != null) {
      _error = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _mcpService.dispose();
    super.dispose();
  }
}
