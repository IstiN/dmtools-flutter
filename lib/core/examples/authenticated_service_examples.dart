import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/authenticated_service.dart';
import '../../providers/mcp_provider.dart';

/// Examples showing how to use AuthenticatedService for various scenarios
class AuthenticatedServiceExamples {
  /// Example 1: Simple authenticated operation (MCP configurations)
  static Future<void> loadMcpConfigurations(BuildContext context) async {
    final authService = context.authenticatedService;

    try {
      // This will automatically handle auth + integrations + MCP loading
      final configurations = await authService.executeWithIntegrations(() async {
        final mcpProvider = context.read<McpProvider>();
        await mcpProvider.loadConfigurations();
        return mcpProvider.configurations;
      });

      print('✅ Loaded ${configurations.length} MCP configurations');
    } catch (e) {
      print('❌ Failed to load MCP configurations: $e');
    }
  }

  /// Example 2: Multiple parallel authenticated operations
  static Future<void> loadAllData(BuildContext context) async {
    final authService = context.authenticatedService;

    try {
      final results = await authService.executeParallel([
        () async {
          final mcpProvider = context.read<McpProvider>();
          await mcpProvider.loadConfigurations();
          return mcpProvider.configurations.length;
        },
        () async {
          // Another service call (example)
          await Future.delayed(const Duration(milliseconds: 500));
          return 'Some other data';
        },
      ], requireIntegrations: true);

      print('✅ Loaded data in parallel: ${results[0]} configs, ${results[1]}');
    } catch (e) {
      print('❌ Failed to load data in parallel: $e');
    }
  }

  /// Example 3: Sequential operations that depend on each other
  static Future<void> loadDataSequentially(BuildContext context) async {
    final authService = context.authenticatedService;

    try {
      final results = await authService.executeSequential([
        () async {
          print('📊 Step 1: Loading configurations...');
          final mcpProvider = context.read<McpProvider>();
          await mcpProvider.loadConfigurations();
          return mcpProvider.configurations;
        },
        () async {
          print('📊 Step 2: Processing configurations...');
          // Process the loaded configurations
          await Future.delayed(const Duration(milliseconds: 300));
          return 'Processed data';
        },
      ], requireIntegrations: true);

      print('✅ Sequential loading completed: ${results.length} steps');
    } catch (e) {
      print('❌ Sequential loading failed: $e');
    }
  }

  /// Example 4: Simple operation without integrations
  static Future<void> simpleAuthenticatedOperation(BuildContext context) async {
    final authService = context.authenticatedService;

    try {
      final result = await authService.execute(() async {
        // Some operation that only needs authentication, not integrations
        return 'User-specific data';
      });

      print('✅ Simple operation result: $result');
    } catch (e) {
      print('❌ Simple operation failed: $e');
    }
  }

  /// Example 5: Operation with retry logic
  static Future<void> operationWithRetries(BuildContext context) async {
    final authService = context.authenticatedService;

    try {
      final result = await authService.execute(() async {
        // Simulate an operation that might fail
        if (DateTime.now().millisecond % 3 == 0) {
          throw Exception('Random failure for demo');
        }
        return 'Success after potential retries';
      }, retries: 3);

      print('✅ Operation with retries result: $result');
    } catch (e) {
      print('❌ Operation failed after retries: $e');
    }
  }

  /// Example 6: Checking auth status without triggering operations
  static void checkAuthStatus(BuildContext context) {
    final authService = context.authenticatedService;
    final status = authService.authStatus;

    print('📊 Auth Status: $status');
    print('   - Ready for operations: ${status.isReady}');
    print('   - Fully ready (with integrations): ${status.isFullyReady}');
    print('   - User: ${status.user?.email ?? 'Not available'}');
  }
}

/// Example widget showing integration with LoadingStateMixin
class ExamplePageWithAuthenticatedService extends StatefulWidget {
  const ExamplePageWithAuthenticatedService({super.key});

  @override
  State<ExamplePageWithAuthenticatedService> createState() => _ExamplePageWithAuthenticatedServiceState();
}

class _ExamplePageWithAuthenticatedServiceState extends State<ExamplePageWithAuthenticatedService> {
  List<dynamic> _configurations = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _error = null;
      });

      // Use authenticated service - no need to manually handle auth flow!
      final authService = context.authenticatedService;

      final configurations = await authService.executeWithIntegrations(() async {
        final mcpProvider = context.read<McpProvider>();
        await mcpProvider.loadConfigurations();
        return mcpProvider.configurations;
      });

      setState(() {
        _configurations = configurations;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _configurations.length,
      itemBuilder: (context, index) {
        final config = _configurations[index];
        return ListTile(
          title: Text(config.name ?? 'Unnamed Configuration'),
          subtitle: Text('ID: ${config.id}'),
        );
      },
    );
  }
}
