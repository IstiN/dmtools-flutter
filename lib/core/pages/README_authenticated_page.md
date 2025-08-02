# AuthenticatedPage - Abstract Base for Authenticated Pages

## Overview

`AuthenticatedPage` is an abstract base class that provides a standardized approach to handling authentication in Flutter pages. It eliminates the need to manually manage auth states, loading states, and auth transitions in every page.

## Key Benefits

1. **Centralized Auth Management**: All auth logic is handled in the base class
2. **Consistent UX**: Standardized loading, error, and empty states across all pages
3. **Simplified Development**: Pages only need to implement business logic
4. **Automatic State Transitions**: Base class handles unauthenticated → authenticated transitions
5. **Error Handling**: Built-in error handling for auth and data operations
6. **Integration Support**: Automatic integration loading when required

## How It Works

### Authentication Flow
1. **Initial State**: Page shows loading indicator while checking auth status
2. **Unauthenticated**: Shows "Authenticating..." message until user logs in
3. **Auth Change Detection**: Automatically detects when user becomes authenticated
4. **Data Loading**: Calls `loadAuthenticatedData()` once auth is confirmed
5. **Content Display**: Shows `buildAuthenticatedContent()` when data is loaded

### State Management
The base class uses the `LoadingStateMixin` to manage these states:
- `loading`: During authentication and data loading
- `loaded`: When data is successfully loaded
- `empty`: When no data is available
- `error`: When loading fails

## Usage

### Basic Implementation

```dart
class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends AuthenticatedPage<MyPage> {
  
  @override
  String get loadingMessage => 'Loading my data...';
  
  @override
  bool get requiresIntegrations => true; // If you need integrations
  
  @override
  Future<void> loadAuthenticatedData() async {
    // Load your page-specific data here
    final data = await authService.executeWithIntegrations(() async {
      // Your data loading logic
      return await someDataService.loadData();
    });
    
    if (data.isEmpty) {
      setEmpty();
    } else {
      setLoaded();
    }
  }
  
  @override
  Widget buildAuthenticatedContent(BuildContext context) {
    // Build your UI here - user is guaranteed to be authenticated
    return Scaffold(
      appBar: AppBar(title: const Text('My Page')),
      body: YourContent(),
    );
  }
}
```

### Customization Options

Override these getters to customize the UI:

```dart
@override
String get loadingMessage => 'Custom loading message...';

@override
String get errorTitle => 'Custom error title';

@override
String get emptyTitle => 'No data found';

@override
String get emptyMessage => 'Try creating some data';

@override
IconData get emptyIcon => Icons.inbox_outlined;

@override
bool get requiresIntegrations => true; // Set to false if no integrations needed
```

### Accessing AuthenticatedService

The base class provides access to `AuthenticatedService`:

```dart
@override
Future<void> loadAuthenticatedData() async {
  // Simple authenticated operation
  final result = await authService.execute(() async {
    return await apiService.getData();
  });
  
  // Operation with integrations
  final result2 = await authService.executeWithIntegrations(() async {
    return await mcpService.loadConfigurations();
  });
  
  // Parallel operations
  final results = await authService.executeParallel([
    () => service1.loadData(),
    () => service2.loadData(),
  ], requireIntegrations: true);
}
```

## Migration from Existing Pages

### Before (Manual Auth Handling)
```dart
class OldPageState extends State<OldPage> with LoadingStateMixin<OldPage> {
  bool _lastAuthState = false;
  
  @override
  void initState() {
    super.initState();
    loadData();
    // Manual auth listener setup...
  }
  
  @override
  void dispose() {
    // Manual auth listener cleanup...
    super.dispose();
  }
  
  void _onAuthStateChanged() {
    // Manual auth state change handling...
  }
  
  @override
  Future<void> loadData() async {
    try {
      if (!authProvider.isAuthenticated) {
        // Demo mode logic...
        return;
      }
      
      // Production mode logic...
      // Integration loading...
      // MCP loading...
      // State management...
    } catch (e) {
      // Error handling...
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Manual auth state checking...
        return buildWithLoadingState(
          // Manual configuration...
          child: _buildContent(),
        );
      },
    );
  }
}
```

### After (Using AuthenticatedPage)
```dart
class NewPageState extends AuthenticatedPage<NewPage> {
  
  @override
  bool get requiresIntegrations => true;
  
  @override
  Future<void> loadAuthenticatedData() async {
    final configurations = await authService.executeWithIntegrations(() async {
      return await mcpProvider.loadConfigurations();
    });
    
    if (configurations.isEmpty) {
      setEmpty();
    } else {
      setLoaded();
    }
  }
  
  @override
  Widget buildAuthenticatedContent(BuildContext context) {
    return YourContent();
  }
}
```

## Advanced Patterns

### Complex Data Loading
```dart
@override
Future<void> loadAuthenticatedData() async {
  try {
    // Load multiple data sources in parallel
    final results = await authService.executeParallel([
      () => userService.loadProfile(),
      () => notificationService.loadNotifications(),
      () => settingsService.loadSettings(),
    ], requireIntegrations: false);
    
    final profile = results[0];
    final notifications = results[1]; 
    final settings = results[2];
    
    // Update local state
    setState(() {
      _profile = profile;
      _notifications = notifications;
      _settings = settings;
    });
    
    if (profile == null) {
      setError('Failed to load user profile');
    } else {
      setLoaded();
    }
  } catch (e) {
    setError('Failed to load data: ${e.toString()}');
  }
}
```

### Conditional Integration Requirements
```dart
@override
bool get requiresIntegrations {
  // Dynamically determine if integrations are needed
  final userSettings = context.read<UserSettings>();
  return userSettings.enableIntegrations;
}
```

## Best Practices

1. **Keep loadAuthenticatedData() Simple**: Focus only on data loading logic
2. **Use AuthenticatedService**: Always use the provided `authService` for operations
3. **Handle Empty States**: Always call `setEmpty()` when appropriate
4. **Error Handling**: Wrap operations in try-catch and call `setError()`
5. **State Updates**: Use `setLoaded()`, `setEmpty()`, `setError()` appropriately
6. **Context Safety**: Always check `if (!mounted) return;` in async operations

## Error Handling Patterns

```dart
@override
Future<void> loadAuthenticatedData() async {
  try {
    final data = await authService.executeWithIntegrations(() async {
      // Operation that might fail
      return await riskyOperation();
    });
    
    if (data == null) {
      setError('No data received from server');
      return;
    }
    
    if (data.isEmpty) {
      setEmpty();
      return;
    }
    
    setLoaded();
  } catch (e) {
    if (e.toString().contains('network')) {
      setError('Network error. Please check your connection.');
    } else if (e.toString().contains('unauthorized')) {
      setError('Authentication expired. Please sign in again.');
    } else {
      setError('Failed to load data: ${e.toString()}');
    }
  }
}
```

## Testing

The `AuthenticatedPage` can be tested by:

1. **Mocking AuthenticatedService**: Test different auth states
2. **Testing loadAuthenticatedData()**: Verify data loading logic
3. **Testing buildAuthenticatedContent()**: Test UI rendering
4. **Testing Error Scenarios**: Verify error handling

```dart
// Example test
testWidgets('should show loading then content', (tester) async {
  // Setup mocks...
  
  await tester.pumpWidget(MyAuthenticatedPage());
  
  // Should show loading initially
  expect(find.text('Loading...'), findsOneWidget);
  
  // Complete auth and data loading
  await tester.pumpAndSettle();
  
  // Should show content
  expect(find.byType(MyContent), findsOneWidget);
});
```

## Migration Checklist

When migrating existing pages to use `AuthenticatedPage`:

- [ ] Replace `StatefulWidget` state class with `AuthenticatedPage<T>`
- [ ] Remove manual auth state management code
- [ ] Move data loading logic to `loadAuthenticatedData()`
- [ ] Move UI building logic to `buildAuthenticatedContent()`
- [ ] Remove manual `Consumer<AuthProvider>` from build method
- [ ] Configure customization options (messages, icons, etc.)
- [ ] Update imports to include `AuthenticatedPage`
- [ ] Test auth transitions and error scenarios
- [ ] Remove unused imports and dead code