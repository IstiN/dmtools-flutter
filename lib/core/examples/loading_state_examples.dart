import 'package:flutter/material.dart';
import '../mixins/loading_state_mixin.dart' as app_loading;
import '../providers/loading_state_provider.dart';
import '../widgets/loading_state_widget.dart';
import '../utils/async_data_loader.dart';

/// Example 1: Using LoadingStateMixin for simple screens
class SimpleDataPage extends StatefulWidget {
  const SimpleDataPage({super.key});

  @override
  State<SimpleDataPage> createState() => _SimpleDataPageState();
}

class _SimpleDataPageState extends State<SimpleDataPage> with app_loading.LoadingStateMixin<SimpleDataPage> {
  List<String> _data = [];

  @override
  Future<void> loadData() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Simulate different scenarios
    final random = DateTime.now().millisecond % 3;
    if (random == 0) {
      // Error scenario
      setError('Failed to load data from server');
    } else if (random == 1) {
      // Empty scenario
      _data = [];
      setEmpty();
    } else {
      // Success scenario
      _data = ['Item 1', 'Item 2', 'Item 3'];
      setLoaded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Data Page')),
      body: buildWithLoadingState(
        loadingMessage: 'Loading data...',
        errorTitle: 'Failed to load',
        emptyTitle: 'No data available',
        emptyMessage: 'Try refreshing to load data',
        child: ListView.builder(
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return ListTile(title: Text(_data[index]));
          },
        ),
      ),
    );
  }
}

/// Example 2: Using LoadingStateProvider for complex state management
class UserDataProvider extends LoadingStateProvider {
  List<Map<String, String>> _users = [];
  Map<String, String> _settings = {};

  List<Map<String, String>> get users => _users;
  Map<String, String> get settings => _settings;

  @override
  Future<void> refresh() async {
    await executeWithLoadingState(() async {
      // Load multiple data sources in parallel
      final results = await AsyncDataLoader.loadMultiple([
        () => _loadUsers(),
        () => _loadSettings(),
      ]);

      _users = results[0] as List<Map<String, String>>;
      _settings = results[1] as Map<String, String>;

      return _users.isNotEmpty;
    });
  }

  Future<List<Map<String, String>>> _loadUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'name': 'John Doe', 'email': 'john@example.com'},
      {'name': 'Jane Smith', 'email': 'jane@example.com'},
    ];
  }

  Future<Map<String, String>> _loadSettings() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'theme': 'dark', 'language': 'en'};
  }
}

class ComplexDataPage extends StatelessWidget {
  const ComplexDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complex Data Page')),
      body: LoadingStateWidget<UserDataProvider>(
        create: (context) => UserDataProvider(),
        onLoad: (provider) => provider.refresh(),
        loadingMessage: 'Loading users and settings...',
        errorTitle: 'Failed to load data',
        emptyTitle: 'No users found',
        emptyMessage: 'Try adding some users first',
        builder: (context, provider) {
          return Column(
            children: [
              // Settings section
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      ...provider.settings.entries.map((entry) => Text('${entry.key}: ${entry.value}')),
                    ],
                  ),
                ),
              ),
              // Users list
              Expanded(
                child: ListView.builder(
                  itemCount: provider.users.length,
                  itemBuilder: (context, index) {
                    final user = provider.users[index];
                    return ListTile(
                      title: Text(user['name'] ?? ''),
                      subtitle: Text(user['email'] ?? ''),
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Example 3: Using SimpleLoadingStateWidget for quick implementations
class QuickDataPage extends StatelessWidget {
  const QuickDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Data Page')),
      body: SimpleLoadingStateWidget<List<String>>(
        onLoad: () async {
          // Simulate API call with retry
          return await AsyncDataLoader.loadWithRetry(
            () async {
              await Future.delayed(const Duration(seconds: 1));

              // Simulate random success/failure
              if (DateTime.now().millisecond % 2 == 0) {
                throw Exception('Network error');
              }

              return ['Quick Item 1', 'Quick Item 2', 'Quick Item 3'];
            },
          );
        },
        isEmptyCheck: (data) => data.isEmpty,
        loadingMessage: 'Loading quick data...',
        errorTitle: 'Network Error',
        emptyTitle: 'No items',
        emptyMessage: 'No items were found',
        builder: (context, data) {
          return ListView.builder(
            itemCount: data?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(data![index]),
                leading: const Icon(Icons.flash_on),
              );
            },
          );
        },
      ),
    );
  }
}

/// Example 4: Using AsyncDataLoader utilities
class AdvancedDataPage extends StatefulWidget {
  const AdvancedDataPage({super.key});

  @override
  State<AdvancedDataPage> createState() => _AdvancedDataPageState();
}

class _AdvancedDataPageState extends State<AdvancedDataPage> with app_loading.LoadingStateMixin<AdvancedDataPage> {
  Map<String, dynamic> _combinedData = {};

  @override
  Future<void> loadData() async {
    await executeWithLoadingState(() async {
      // Load data with caching, timeout, and progress tracking
      final results = await AsyncDataLoader.loadWithProgress(
        [
          () => AsyncDataLoader.loadWithCache(
                'api_data',
                () => _loadApiData(),
              ),
          () => AsyncDataLoader.loadWithTimeout(
                () => _loadSlowData(),
                timeout: const Duration(seconds: 10),
              ),
          () => _loadLocalData(),
        ],
        onProgress: (completed, total) {
          print('Loading progress: $completed/$total');
        },
      );

      _combinedData = {
        'api': results[0],
        'slow': results[1],
        'local': results[2],
      };

      return _combinedData.isNotEmpty;
    });
  }

  Future<Map<String, String>> _loadApiData() async {
    await Future.delayed(const Duration(seconds: 2));
    return {'source': 'api', 'status': 'loaded'};
  }

  Future<Map<String, String>> _loadSlowData() async {
    await Future.delayed(const Duration(seconds: 3));
    return {'source': 'slow', 'status': 'loaded'};
  }

  Future<Map<String, String>> _loadLocalData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {'source': 'local', 'status': 'loaded'};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Data Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              AsyncDataLoader.clearCache();
              retry();
            },
          ),
        ],
      ),
      body: buildWithLoadingState(
        loadingMessage: 'Loading from multiple sources...',
        errorTitle: 'Failed to load',
        emptyTitle: 'No data',
        emptyMessage: 'Failed to load any data sources',
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: _combinedData.entries.map((entry) {
            final data = entry.value as Map<String, String>;
            return Card(
              child: ListTile(
                title: Text('Source: ${entry.key}'),
                subtitle: Text('Status: ${data['status']}'),
                leading: Icon(_getIconForSource(entry.key)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getIconForSource(String source) {
    switch (source) {
      case 'api':
        return Icons.cloud;
      case 'slow':
        return Icons.hourglass_empty;
      case 'local':
        return Icons.storage;
      default:
        return Icons.data_usage;
    }
  }
}
