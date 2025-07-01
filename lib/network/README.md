# Networking Module

This module provides a complete networking solution for the DMTools Flutter application using auto-generated API clients from OpenAPI specifications.

## Overview

The networking module consists of:

- **Generated API Client**: Auto-generated from OpenAPI 3.0.3 specification using `swagger_dart_code_generator`
- **Service Layer**: High-level service classes that wrap the generated client
- **Interceptors**: Authentication and logging interceptors
- **Configuration**: Centralized API client configuration

## Structure

```
lib/network/
├── clients/
│   └── api_client.dart          # Base API client configuration
├── generated/                   # Auto-generated code (do not edit)
│   ├── workspace_api.swagger.dart
│   ├── workspace_api.models.swagger.dart
│   ├── workspace_api.enums.swagger.dart
│   └── ...
├── interceptors/
│   ├── auth_interceptor.dart    # Authentication interceptor
│   └── logging_interceptor.dart # Request/response logging
├── services/
│   └── workspace_api_service.dart # High-level workspace service
├── network_module.dart          # Main module exports
└── README.md                    # This file
```

## Usage

### Basic Usage

```dart
import 'package:dmtools/network/network_module.dart';

// Create service instance
final workspaceService = WorkspaceApiService(
  baseUrl: 'https://api.dmtools.app/api',
  authToken: 'your-auth-token',
  enableLogging: true,
);

// Use the service
try {
  final workspaces = await workspaceService.getWorkspaces();
  print('Found ${workspaces.length} workspaces');
} catch (e) {
  print('Error: $e');
}

// Don't forget to dispose
workspaceService.dispose();
```

### Available Operations

The `WorkspaceApiService` provides the following operations:

#### Workspace Management
- `getWorkspaces()` - Get all workspaces for current user
- `getWorkspace(String id)` - Get specific workspace by ID
- `createWorkspace({required String name, String? description})` - Create new workspace
- `updateWorkspace({required String id, required String name, String? description})` - Update workspace
- `deleteWorkspace(String id)` - Delete workspace
- `createDefaultWorkspace()` - Create default workspace

#### User Management
- `shareWorkspace({required String workspaceId, required String userEmail, required WorkspaceRole role})` - Share workspace with user
- `removeUserFromWorkspace({required String workspaceId, required String targetUserId})` - Remove user from workspace

### Configuration

#### Environment Configuration

```dart
// Development
final devService = WorkspaceApiService(
  baseUrl: 'http://localhost:8080/api',
  enableLogging: true,
);

// Production
final prodService = WorkspaceApiService(
  baseUrl: 'https://dmtools-431977789017.us-central1.run.app/api',
  authToken: userToken,
  enableLogging: false,
);
```

#### Custom HTTP Client

```dart
final customClient = http.Client();
final client = ApiClientConfig.createClient(
  httpClient: customClient,
  authToken: token,
);
```

### Error Handling

The service throws `ApiException` for API-related errors:

```dart
try {
  final workspace = await service.getWorkspace('invalid-id');
} catch (e) {
  if (e is ApiException) {
    print('API Error: ${e.message}');
    if (e.statusCode != null) {
      print('Status Code: ${e.statusCode}');
    }
  } else {
    print('Unexpected error: $e');
  }
}
```

### Data Models

The generated models include:

- `WorkspaceDto` - Complete workspace information
- `WorkspaceUserDto` - User information within workspace context
- `CreateWorkspaceRequest` - Request model for creating workspaces
- `ShareWorkspaceRequest` - Request model for sharing workspaces
- `WorkspaceRole` - Enum for user roles (ADMIN, USER)
- `ErrorResponse` - Standard error response model

## Code Generation

### Regenerating API Client

When the API specification changes, regenerate the client:

1. Update the OpenAPI specification in `swagger/workspace-api.swagger`
2. Run code generation:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

### Configuration

The code generation is configured in `build.yaml`:

```yaml
targets:
  $default:
    builders:
      swagger_dart_code_generator:
        options:
          input_folder: 'swagger'
          output_folder: 'lib/network/generated'
          with_base_url: true
          with_converter: true
          separate_models: true
```

## Demo

See `/api-demo` route in the app for a complete working example that demonstrates:

- Service initialization
- CRUD operations
- Error handling
- Mock data fallback when API is unavailable

## Dependencies

The networking module uses:

- `chopper` ^8.0.0 - HTTP client generator
- `json_annotation` ^4.8.0 - JSON serialization
- `http` ^1.0.0 - HTTP client
- `collection` ^1.17.0 - Collection utilities

## Architecture Notes

- Generated code is kept separate and should not be manually edited
- Service layer provides a clean interface and handles error transformation
- Interceptors handle cross-cutting concerns like authentication and logging
- Configuration is centralized for easy environment switching
- Models include copyWith methods and proper equality implementations 