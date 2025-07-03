# Test Structure Organization

This document outlines the test organization strategy for the DMTools Flutter project.

## 🏗️ Recommended Test Structure

```
test/
├── README.md                           # Test documentation (main)
├── test_structure.md                   # This file
├── flutter_test_config.dart            # Global test configuration
│
├── unit/                               # Unit Tests
│   ├── core/
│   │   ├── config/
│   │   │   └── app_config_test.dart
│   │   ├── models/
│   │   │   ├── user_test.dart
│   │   │   └── workspace_test.dart
│   │   ├── routing/
│   │   │   └── app_router_test.dart
│   │   └── services/
│   │       ├── oauth_service_test.dart
│   │       └── workspace_service_test.dart
│   ├── network/
│   │   ├── clients/
│   │   │   └── api_client_test.dart
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor_test.dart
│   │   │   └── logging_interceptor_test.dart
│   │   └── services/
│   │       ├── api_service_test.dart
│   │       ├── dm_tools_api_service_impl_test.dart
│   │       └── dm_tools_api_service_mock_test.dart
│   ├── providers/
│   │   ├── auth_provider_test.dart     # ✅ Existing - will move here
│   │   └── demo_mode_provider_test.dart
│   └── service_locator_test.dart       # ✅ Existing - will move here
│
├── widget/                             # Widget Tests
│   ├── screens/
│   │   ├── home_screen_test.dart
│   │   ├── oauth_callback_screen_test.dart
│   │   └── pages/
│   │       ├── agents_page_test.dart
│   │       ├── api_demo_page_test.dart
│   │       └── applications_page_test.dart
│   └── widgets/
│       ├── auth_login_widget_test.dart
│       ├── recent_agents_test.dart
│       └── workspace_summary_test.dart
│
├── integration/                        # Integration Tests
│   ├── auth_flow_test.dart
│   ├── api_integration_test.dart
│   └── end_to_end_test.dart
│
├── golden/                             # Golden Tests (if needed for main app)
│   ├── goldens/
│   └── golden_test_helper.dart
│
├── helpers/                            # Test Helpers & Utilities
│   ├── test_helpers.dart               # Common test utilities
│   ├── mock_factories.dart             # Mock object factories
│   ├── test_data.dart                  # Test data constants
│   └── matchers/                       # Custom matchers
│       └── custom_matchers.dart
│
└── mocks/                              # Mock Classes
    ├── mock_api_service.dart
    ├── mock_auth_provider.dart
    ├── mock_oauth_service.dart
    └── generated_mocks.dart            # Auto-generated mocks
```

## 📁 Directory Purposes

### **`unit/`** - Unit Tests
- **Purpose**: Test individual classes, functions, and methods in isolation
- **Structure**: Mirrors `lib/` directory structure exactly
- **Scope**: Single class or function testing
- **Example**: Testing AuthProvider methods, API service calls, model validation

### **`widget/`** - Widget Tests  
- **Purpose**: Test Flutter widgets and their interactions
- **Structure**: Mirrors `lib/screens/` and `lib/widgets/`
- **Scope**: Widget rendering, user interactions, widget state
- **Example**: Testing if login widget shows/hides password, button interactions

### **`integration/`** - Integration Tests
- **Purpose**: Test multiple components working together
- **Structure**: Feature-based organization
- **Scope**: End-to-end workflows, API integration, complex user flows
- **Example**: Complete authentication flow, API + UI integration

### **`golden/`** - Golden Tests (Main App)
- **Purpose**: Visual regression testing for main app (styleguide has its own)
- **Structure**: Feature-based with golden files
- **Scope**: Screenshot comparison testing
- **Example**: Login screen appearance, theme consistency

### **`helpers/`** - Test Utilities
- **Purpose**: Reusable test utilities, builders, and helpers
- **Files**:
  - `test_helpers.dart` - Common testing utilities
  - `mock_factories.dart` - Factory methods for test objects
  - `test_data.dart` - Shared test data and constants
  - `matchers/` - Custom test matchers

### **`mocks/`** - Mock Classes
- **Purpose**: Mock implementations for testing
- **Files**:
  - Manual mocks for complex objects
  - Generated mocks from mockito
  - Shared mock implementations

## 🎯 Test Type Guidelines

### **Unit Tests** (`unit/`)
```dart
// Example: test/unit/providers/auth_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_flutter/providers/auth_provider.dart';

void main() {
  group('AuthProvider', () {
    late AuthProvider authProvider;
    
    setUp(() {
      authProvider = AuthProvider();
    });
    
    test('should initialize with correct default state', () {
      expect(authProvider.isAuthenticated, false);
      expect(authProvider.currentUser, null);
    });
  });
}
```

### **Widget Tests** (`widget/`)
```dart
// Example: test/widget/widgets/auth_login_widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_flutter/widgets/auth_login_widget.dart';

void main() {
  group('AuthLoginWidget', () {
    testWidgets('should show login button when not authenticated', (tester) async {
      await tester.pumpWidget(
        MaterialApp(home: AuthLoginWidget()),
      );
      
      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Logout'), findsNothing);
    });
  });
}
```

### **Integration Tests** (`integration/`)
```dart
// Example: test/integration/auth_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:dmtools_flutter/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  group('Authentication Flow', () {
    testWidgets('complete login flow works correctly', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Test complete authentication workflow
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();
      
      // Assert authentication success
      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
```

## 🚀 Benefits of This Structure

### **🔍 Easy Navigation**
- Mirror structure of `lib/` directory
- Quickly find test for any source file
- Clear separation of test types

### **📦 Scalability**  
- Each module has its own test directory
- New features get their own test folders
- No more flat file chaos

### **🎯 Test Type Clarity**
- Unit tests for business logic
- Widget tests for UI components  
- Integration tests for workflows
- Clear separation of concerns

### **🛠️ Maintainability**
- Shared helpers reduce duplication
- Mock factories ensure consistency
- Test data centralized and reusable

### **⚡ CI/CD Optimization**
- Can run different test types in parallel
- Faster feedback with targeted testing
- Better test reporting and coverage

## 🔧 Test Naming Conventions

### **File Naming**
- `{source_file_name}_test.dart`
- Example: `auth_provider.dart` → `auth_provider_test.dart`

### **Test Group Naming**
- Use the class/component name as main group
- Example: `group('AuthProvider', () { ... })`

### **Test Case Naming**
- Descriptive, behavior-focused names
- Pattern: "should {expected behavior} when {condition}"
- Example: `'should return false when token is expired'`

## 📝 Test Documentation Standards

### **File Headers**
```dart
/// Tests for [AuthProvider] class
/// 
/// Covers:
/// - User authentication state management
/// - Token handling and validation
/// - Demo mode functionality
/// - JWT parsing edge cases
```

### **Group Documentation**
```dart
group('Token Validation', () {
  // Tests token expiration, format validation, and edge cases
});
```

## 🔄 Migration Strategy

1. **Phase 1**: Create new directory structure
2. **Phase 2**: Move existing tests to appropriate locations
3. **Phase 3**: Create shared helpers and mocks
4. **Phase 4**: Update CI/CD to use new structure
5. **Phase 5**: Create test templates for new features

This structure will scale with the application and maintain clean organization as the codebase grows. 