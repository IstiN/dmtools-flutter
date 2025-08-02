# AuthenticatedService - Centralized Authentication Management

## Overview

`AuthenticatedService` is a high-level abstraction that ensures user authentication before executing any network operations. This service provides a clean, reusable interface for authenticated operations across the entire application.

## Key Benefits

1. **Centralized Auth Logic**: Single place to handle authentication flow
2. **Automatic Auth Handling**: No need to manually check auth state in every component
3. **Reusability**: Use across all pages/services that need authenticated requests
4. **Consistency**: Guaranteed auth flow for all network operations
5. **Error Handling**: Built-in retry logic and timeout handling
6. **Integration Support**: Automatic integration loading when needed

## Basic Usage

### Simple Authenticated Operation

```dart
import '../core/services/authenticated_service.dart';

// In your widget or service
final authService = context.authenticatedService;

try {
  final result = await authService.execute(() async {
    // Your authenticated operation here
    return await apiService.getData();
  });
  
  print('Success: $result');
} catch (e) {
  print('Failed: $e');
}
```

### Operation Requiring Integrations

```dart
final configurations = await authService.executeWithIntegrations(() async {
  final mcpProvider = context.read<McpProvider>();
  await mcpProvider.loadConfigurations();
  return mcpProvider.configurations;
});
```

### Parallel Operations

```dart
final results = await authService.executeParallel([
  () async => await mcpService.loadConfigurations(),
  () async => await userService.loadProfile(),
  () async => await settingsService.loadPreferences(),
], requireIntegrations: true);
```

### Sequential Operations

```dart
final results = await authService.executeSequential([
  () async {
    // Step 1: Load basic data
    return await dataService.loadBasicData();
  },
  () async {
    // Step 2: Process the loaded data
    return await dataService.processData();
  },
], requireIntegrations: false);
```

## Advanced Features

### Retry Logic

```dart
final result = await authService.execute(() async {
  // Operation that might fail
  return await unreliableApiCall();
}, retries: 3); // Will retry up to 3 times
```

### Auth Status Checking

```dart
final authService = context.authenticatedService;

// Check without triggering auth flow
if (authService.isAuthenticated) {
  // User is already authenticated
}

if (authService.areIntegrationsLoaded) {
  // Integrations are ready
}

// Get detailed status
final status = authService.authStatus;
print('Auth Status: $status');
print('Ready for operations: ${status.isReady}');
print('Fully ready: ${status.isFullyReady}');
```

## Integration with LoadingStateMixin

The service works perfectly with our `LoadingStateMixin`:

```dart
class _MyPageState extends State<MyPage> with LoadingStateMixin<MyPage> {
  
  @override
  Future<void> loadData() async {
    try {
      final authService = context.authenticatedService;
      
      // No need to manually handle auth state!
      final data = await authService.executeWithIntegrations(() async {
        return await dataService.loadPageData();
      });
      
      if (data.isEmpty) {
        setEmpty();
      } else {
        setLoaded();
      }
    } catch (e) {
      setError(e.toString());
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return buildWithLoadingState(
      loadingMessage: 'Loading data...',
      child: _buildContent(),
    );
  }
}
```

## How It Works Internally

1. **Authentication Check**: Service first checks if user is authenticated
2. **Wait for Auth**: If not authenticated, waits for the automatic auth flow to complete
3. **Integration Loading**: If required, ensures integrations are loaded
4. **Operation Execution**: Executes the provided operation
5. **Error Handling**: Handles timeouts and provides retry logic

## Error Handling

The service provides specific exceptions:

- `AuthenticationTimeoutException`: Auth didn't complete within timeout
- `IntegrationLoadingTimeoutException`: Integration loading timed out
- Standard exceptions from your operations are passed through

## Configuration

Default timeouts and retry attempts:

```dart
// Authentication timeout: 15 seconds
// Integration loading timeout: 10 seconds
// Default retries: 1
// Retry delay: 500ms * attempt number
```

## Migration from Manual Auth Handling

### Before (Manual Auth Handling)

```dart
@override
Future<void> loadData() async {
  try {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    if (!authProvider.isAuthenticated) {
      // Wait for auth or show demo mode
      setLoaded(); // Demo mode
      return;
    }
    
    // Load integrations
    final integrationProvider = context.read<IntegrationProvider>();
    if (!integrationProvider.isInitialized) {
      await integrationProvider.forceReinitialize();
    }
    
    // Load actual data
    await context.read<McpProvider>().loadConfigurations();
    
    // Handle result
    final mcpProvider = context.read<McpProvider>();
    if (mcpProvider.configurations.isNotEmpty) {
      setLoaded();
    } else {
      setEmpty();
    }
  } catch (e) {
    setError(e.toString());
  }
}
```

### After (Using AuthenticatedService)

```dart
@override
Future<void> loadData() async {
  try {
    final authService = context.authenticatedService;
    
    // Handle demo mode for unauthenticated users
    if (!authService.isAuthenticated) {
      setLoaded(); // Demo mode
      return;
    }
    
    // Production mode - all auth + integration logic handled automatically
    final configurations = await authService.executeWithIntegrations(() async {
      final mcpProvider = context.read<McpProvider>();
      await mcpProvider.loadConfigurations();
      return mcpProvider.configurations;
    });
    
    if (configurations.isNotEmpty) {
      setLoaded();
    } else {
      setEmpty();
    }
  } catch (e) {
    setError(e.toString());
  }
}
```

## Best Practices

1. **Always use the service** for operations requiring authentication
2. **Check auth status first** if you need to handle demo/unauthenticated states
3. **Use `executeWithIntegrations`** for operations that need MCP-ready integrations
4. **Handle exceptions** appropriately in your UI
5. **Use parallel execution** when operations are independent
6. **Use sequential execution** when operations have dependencies
7. **Set appropriate retry counts** based on operation criticality

## Future Enhancements

- Configurable timeouts
- Custom retry strategies
- Operation prioritization
- Caching mechanisms
- Background refresh patterns