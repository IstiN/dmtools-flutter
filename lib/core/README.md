# Loading State Management Abstractions

This directory contains reusable abstractions for handling loading states across the application. These components automatically manage the common pattern of loading → loaded/empty/error states.

## Overview

All screens in the app typically follow this pattern:
1. **Start loading** - Show loading indicator
2. **Make API requests** - Execute one or more async operations  
3. **Handle results** - Show content, empty state, or error based on results

Instead of writing this logic repeatedly, use these abstractions:

## 🔧 **Available Abstractions**

### 1. `LoadingStateMixin` - For Simple Screens

**Use when**: You have a StatefulWidget that needs loading state management.

```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> with LoadingStateMixin<MyPage> {
  List<MyData> _data = [];

  @override
  Future<void> loadData() async {
    // Your loading logic here
    final result = await apiService.getData();
    
    if (result.isEmpty) {
      setEmpty();
    } else {
      _data = result;
      setLoaded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildWithLoadingState(
      loadingMessage: 'Loading data...',
      emptyTitle: 'No data found',
      emptyMessage: 'Try refreshing the page',
      errorTitle: 'Failed to load data',
      child: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) => ListTile(title: Text(_data[index].name)),
      ),
    );
  }
}
```

**Benefits**:
- ✅ Automatic retry functionality
- ✅ Proper state management
- ✅ Consistent loading UI
- ✅ Error handling built-in

### 2. `LoadingStateProvider` - For Complex State Management

**Use when**: You need Provider-based state management with loading states.

```dart
class UserDataProvider extends LoadingStateProvider {
  List<User> _users = [];
  List<User> get users => _users;

  @override
  Future<void> refresh() async {
    await executeWithLoadingState(() async {
      _users = await apiService.getUsers();
      return _users.isNotEmpty;
    });
  }

  // Additional methods for CRUD operations...
}

// Usage in widget:
LoadingStateWidget<UserDataProvider>(
  create: (context) => UserDataProvider(),
  onLoad: (provider) => provider.refresh(),
  loadingMessage: 'Loading users...',
  emptyTitle: 'No users found',
  builder: (context, provider) {
    return ListView.builder(
      itemCount: provider.users.length,
      itemBuilder: (context, index) => UserCard(user: provider.users[index]),
    );
  },
)
```

**Benefits**:
- ✅ Provider integration
- ✅ Reactive UI updates
- ✅ Shared state across widgets
- ✅ Built-in error handling

### 3. `SimpleLoadingStateWidget` - For Quick Implementations

**Use when**: You need a quick loading wrapper without complex state management.

```dart
SimpleLoadingStateWidget<List<String>>(
  onLoad: () async {
    return await apiService.getItems();
  },
  isEmptyCheck: (data) => data.isEmpty,
  loadingMessage: 'Loading items...',
  errorTitle: 'Network Error',
  emptyTitle: 'No items',
  builder: (context, data) {
    return ListView.builder(
      itemCount: data?.length ?? 0,
      itemBuilder: (context, index) => ListTile(title: Text(data![index])),
    );
  },
)
```

**Benefits**:
- ✅ Minimal boilerplate
- ✅ Perfect for simple cases
- ✅ Type-safe data handling
- ✅ Automatic retry

### 4. `AsyncDataLoader` - For Advanced Operations

**Use when**: You need sophisticated async operation handling.

```dart
// Parallel loading
final results = await AsyncDataLoader.loadMultiple([
  () => apiService.getUsers(),
  () => apiService.getSettings(),
  () => apiService.getNotifications(),
]);

// Sequential loading
final results = await AsyncDataLoader.loadSequential([
  () => authService.login(),
  () => userService.getProfile(),
  () => dataService.getUserData(),
]);

// With retry and timeout
final data = await AsyncDataLoader.loadWithRetryAndTimeout(
  () => apiService.getData(),
  maxRetries: 3,
  retryDelay: Duration(seconds: 2),
  timeout: Duration(seconds: 30),
);

// With caching
final data = await AsyncDataLoader.loadWithCache(
  key: 'user_data',
  operation: () => apiService.getUserData(),
  cacheDuration: Duration(minutes: 5),
);

// With progress tracking
final data = await AsyncDataLoader.loadWithProgress(
  operations: [
    () => loadStep1(),
    () => loadStep2(),
    () => loadStep3(),
  ],
  onProgress: (completed, total) {
    print('Progress: $completed/$total');
  },
);
```

**Benefits**:
- ✅ Retry logic
- ✅ Timeout handling
- ✅ Caching support
- ✅ Progress tracking
- ✅ Parallel/sequential execution

## 📋 **Usage Guidelines**

### Choose the Right Abstraction

| Use Case | Recommended Abstraction |
|----------|------------------------|
| Simple page with basic loading | `LoadingStateMixin` |
| Complex state with Provider | `LoadingStateProvider` + `LoadingStateWidget` |
| Quick implementation | `SimpleLoadingStateWidget` |
| Advanced async operations | `AsyncDataLoader` utilities |
| Multiple parallel API calls | `AsyncDataLoader.loadMultiple()` |
| Sequential operations | `AsyncDataLoader.loadSequential()` |
| Need retry logic | `AsyncDataLoader.loadWithRetry()` |
| Need caching | `AsyncDataLoader.loadWithCache()` |

### Best Practices

1. **Always handle empty states**: Don't forget to call `setEmpty()` when appropriate
2. **Provide meaningful messages**: Use descriptive loading and error messages
3. **Handle errors gracefully**: Always wrap async operations in try-catch
4. **Use caching wisely**: Cache expensive operations that don't change frequently
5. **Test all states**: Ensure loading, loaded, empty, and error states work correctly

### Common Patterns

#### Loading Multiple Data Sources
```dart
@override
Future<void> loadData() async {
  await executeWithLoadingState(() async {
    final results = await AsyncDataLoader.loadMultiple([
      () => apiService.getUsers(),
      () => apiService.getSettings(),
    ]);
    
    users = results[0];
    settings = results[1];
    
    return users.isNotEmpty;
  });
}
```

#### Dependent API Calls
```dart
@override
Future<void> loadData() async {
  await executeWithLoadingState(() async {
    // Load user first, then their data
    final results = await AsyncDataLoader.loadSequential([
      () => authService.getCurrentUser(),
      () => dataService.getUserData(userId),
    ]);
    
    user = results[0];
    userData = results[1];
    
    return userData != null;
  });
}
```

#### With Error Recovery
```dart
@override
Future<void> loadData() async {
  try {
    final data = await AsyncDataLoader.loadWithRetryAndTimeout(
      () => apiService.getCriticalData(),
      maxRetries: 3,
      retryDelay: Duration(seconds: 2),
      timeout: Duration(seconds: 30),
    );
    
    if (data.isEmpty) {
      setEmpty();
    } else {
      setLoaded();
    }
  } catch (e) {
    setError('Failed to load data: ${e.toString()}');
  }
}
```

#### Handling Authentication State Changes
```dart
class _MyPageState extends State<MyPage> with LoadingStateMixin<MyPage> {
  bool _lastAuthState = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Reload data when auth state changes
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final currentAuthState = authProvider.isAuthenticated;
    
    if (currentAuthState != _lastAuthState) {
      _lastAuthState = currentAuthState;
      
      if (currentAuthState) {
        // User just authenticated, reload with real data
        WidgetsBinding.instance.addPostFrameCallback((_) {
          retry(); // Forces fresh loadData() call
        });
      }
    }
  }

  @override
  Future<void> loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (authProvider.isAuthenticated) {
      // Load real data
      final data = await apiService.getRealData();
      data.isEmpty ? setEmpty() : setLoaded();
    } else {
      // Load demo/mock data
      final demoData = getDemoData();
      setLoaded(); // Demo always shows loaded state
    }
  }
}
```

## 🔄 **Migration from Manual Loading States**

### Before (Manual Implementation)
```dart
class OldPage extends StatefulWidget {
  @override
  State<OldPage> createState() => _OldPageState();
}

class _OldPageState extends State<OldPage> {
  bool _isLoading = false;
  String? _error;
  List<Data> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await apiService.getData();
      setState(() {
        _data = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    
    if (_error != null) {
      return Center(child: Text('Error: $_error'));
    }
    
    if (_data.isEmpty) {
      return Center(child: Text('No data'));
    }

    return ListView.builder(
      itemCount: _data.length,
      itemBuilder: (context, index) => ListTile(title: Text(_data[index].name)),
    );
  }
}
```

### After (Using LoadingStateMixin)
```dart
class NewPage extends StatefulWidget {
  @override
  State<NewPage> createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> with LoadingStateMixin<NewPage> {
  List<Data> _data = [];

  @override
  Future<void> loadData() async {
    final result = await apiService.getData();
    
    if (result.isEmpty) {
      setEmpty();
    } else {
      _data = result;
      setLoaded();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildWithLoadingState(
      loadingMessage: 'Loading data...',
      emptyTitle: 'No data available',
      errorTitle: 'Failed to load',
      child: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) => ListTile(title: Text(_data[index].name)),
      ),
    );
  }
}
```

**Reduction**: ~40 lines → ~20 lines (-50% code)

## 🎯 **Benefits Summary**

✅ **Consistent UX**: All loading states look and behave the same  
✅ **Less Boilerplate**: 50-70% less code for loading state management  
✅ **Error Handling**: Built-in retry and error display  
✅ **Type Safety**: Generic type support for data handling  
✅ **Flexibility**: Multiple abstraction levels for different needs  
✅ **Maintainability**: Centralized loading state logic  
✅ **Testing**: Easier to test loading states  
✅ **Performance**: Built-in caching and optimization  

## 📁 **File Structure**

```
lib/core/
├── mixins/
│   └── loading_state_mixin.dart      # Mixin for StatefulWidgets
├── providers/
│   └── loading_state_provider.dart   # Base provider class
├── widgets/
│   └── loading_state_widget.dart     # Widget wrappers
├── utils/
│   └── async_data_loader.dart        # Utility functions
├── examples/
│   └── loading_state_examples.dart   # Usage examples
└── README.md                         # This documentation
```

Start with the examples in `loading_state_examples.dart` to see all abstractions in action!