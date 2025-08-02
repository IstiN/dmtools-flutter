import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/authenticated_page.dart';
import '../../providers/mcp_provider.dart';
import '../../providers/integration_provider.dart';

/// Example 1: Simple MCP page using AuthenticatedPage
class SimpleMcpPage extends StatefulWidget {
  const SimpleMcpPage({super.key});

  @override
  State<SimpleMcpPage> createState() => _SimpleMcpPageState();
}

class _SimpleMcpPageState extends AuthenticatedPage<SimpleMcpPage> {
  @override
  String get loadingMessage => 'Loading MCP configurations...';

  @override
  String get errorTitle => 'Error loading MCP configurations';

  @override
  String get emptyTitle => 'No MCP configurations found';

  @override
  String get emptyMessage => 'Create your first MCP configuration to get started';

  @override
  bool get requiresIntegrations => true;

  @override
  Future<void> loadAuthenticatedData() async {
    print('📊 SimpleMcpPage: Loading MCP configurations...');

    // Use the authenticated service to load data with automatic integration handling
    final configurations = await authService.executeWithIntegrations(() async {
      final mcpProvider = context.read<McpProvider>();
      await mcpProvider.loadConfigurations();
      return mcpProvider.configurations;
    });

    print('📊 SimpleMcpPage: Loaded ${configurations.length} configurations');

    if (configurations.isEmpty) {
      setEmpty();
    } else {
      setLoaded();
    }
  }

  @override
  Widget buildAuthenticatedContent(BuildContext context) {
    return Consumer<McpProvider>(
      builder: (context, mcpProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('MCP Configurations'),
          ),
          body: Column(
            children: [
              if (mcpProvider.configurations.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: mcpProvider.configurations.length,
                    itemBuilder: (context, index) {
                      final config = mcpProvider.configurations[index];
                      return ListTile(
                        title: Text(config.name),
                        subtitle: Text('${config.integrationIds.length} integrations'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      );
                    },
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Handle create new configuration
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

/// Example 2: Complex page with multiple data sources
class ComplexDataPage extends StatefulWidget {
  const ComplexDataPage({super.key});

  @override
  State<ComplexDataPage> createState() => _ComplexDataPageState();
}

class _ComplexDataPageState extends AuthenticatedPage<ComplexDataPage> {
  List<String> _userData = [];
  List<String> _integrationData = [];

  @override
  String get loadingMessage => 'Loading dashboard data...';

  @override
  bool get requiresIntegrations => true;

  @override
  Future<void> loadAuthenticatedData() async {
    print('📊 ComplexDataPage: Loading multiple data sources...');

    try {
      // Load multiple data sources in parallel using authenticated service
      final results = await authService.executeParallel([
        () async {
          // Load user-specific data
          await Future.delayed(const Duration(milliseconds: 500));
          return ['User data 1', 'User data 2', 'User data 3'];
        },
        () async {
          // Load integration data
          final integrationProvider = context.read<IntegrationProvider>();
          await integrationProvider.refresh();
          return integrationProvider.integrations.map((i) => i.name).toList();
        },
      ], requireIntegrations: true);

      _userData = results[0];
      _integrationData = results[1];

      print('📊 ComplexDataPage: Loaded ${_userData.length} user items, ${_integrationData.length} integrations');

      if (_userData.isEmpty && _integrationData.isEmpty) {
        setEmpty();
      } else {
        setLoaded();
      }
    } catch (e) {
      print('📊 ComplexDataPage: Error loading data: $e');
      setError('Failed to load dashboard data: ${e.toString()}');
    }
  }

  @override
  Widget buildAuthenticatedContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Data Section
            Text(
              'User Data',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _userData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(_userData[index]),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Integration Data Section
            Text(
              'Integrations',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _integrationData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.integration_instructions),
                      title: Text(_integrationData[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Example 3: Simple page that doesn't require integrations
class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends AuthenticatedPage<UserProfilePage> {
  Map<String, dynamic>? _userProfile;

  @override
  String get loadingMessage => 'Loading user profile...';

  @override
  String get emptyMessage => 'No profile data available';

  @override
  bool get requiresIntegrations => false; // This page doesn't need integrations

  @override
  Future<void> loadAuthenticatedData() async {
    print('📊 UserProfilePage: Loading user profile...');

    // Simple authenticated operation without integrations
    final profile = await authService.execute(() async {
      // Simulate API call to get user profile
      await Future.delayed(const Duration(milliseconds: 800));
      return {
        'name': 'John Doe',
        'email': 'john@example.com',
        'role': 'Admin',
        'lastLogin': '2024-01-15',
      };
    });

    _userProfile = profile;

    if (_userProfile == null || _userProfile!.isEmpty) {
      setEmpty();
    } else {
      setLoaded();
    }
  }

  @override
  Widget buildAuthenticatedContent(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile Information',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _buildProfileRow('Name', _userProfile!['name']),
                    _buildProfileRow('Email', _userProfile!['email']),
                    _buildProfileRow('Role', _userProfile!['role']),
                    _buildProfileRow('Last Login', _userProfile!['lastLogin']),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
