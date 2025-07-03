# Test Documentation

This directory contains comprehensive tests for the DMTools Flutter application, organized in a structured manner that mirrors the `lib/` directory and separates different types of tests for better maintainability and scalability.

## 🏗️ Test Structure

Tests are organized using Flutter best practices with clear separation of concerns:

```
test/
├── README.md                      # This documentation
├── test_structure.md              # Detailed structure planning
├── flutter_test_config.dart       # Global test configuration
│
├── unit/                          # Unit Tests (mirrors lib/ structure)
│   ├── providers/
│   │   └── auth_provider_test.dart    # Authentication provider tests
│   ├── core/                      # Core functionality tests
│   │   ├── config/                # App configuration tests
│   │   ├── models/                # Data model tests
│   │   ├── routing/               # Routing logic tests
│   │   └── services/              # Core service tests
│   ├── network/                   # Network layer tests
│   │   ├── clients/               # API client tests
│   │   ├── interceptors/          # HTTP interceptor tests
│   │   └── services/              # Network service tests
│   └── service_locator_test.dart  # Dependency injection tests
│
├── widget/                        # Widget Tests
│   ├── screens/                   # Screen widget tests
│   └── widgets/                   # Component widget tests
│
├── integration/                   # Integration Tests
│   └── auth_flow_test.dart        # End-to-end auth workflow tests
│
├── helpers/                       # Test Utilities & Helpers
│   ├── test_helpers.dart          # Common test utilities
│   └── mock_factories.dart        # Mock data factories
│
└── mocks/                         # Mock Classes
    └── mock_services.dart         # Service mocks
```

## 🧪 Test Types & Guidelines

### **Unit Tests** (`unit/`)
- **Purpose**: Test individual classes, functions, and methods in isolation
- **Structure**: Mirrors `lib/` directory structure exactly
- **Scope**: Single class or function testing
- **Location**: `test/unit/{module}/{file}_test.dart`

### **Widget Tests** (`widget/`)
- **Purpose**: Test Flutter widgets and their interactions
- **Structure**: Mirrors `lib/screens/` and `lib/widgets/`
- **Scope**: Widget rendering, user interactions, widget state
- **Location**: `test/widget/{type}/{file}_test.dart`

### **Integration Tests** (`integration/`)
- **Purpose**: Test multiple components working together
- **Structure**: Feature-based organization
- **Scope**: End-to-end workflows, API integration, complex user flows
- **Location**: `test/integration/{feature}_test.dart`

## 🔐 Current Authentication Test Coverage

### **unit/providers/auth_provider_test.dart** - Authentication Provider Tests
Comprehensive testing of the `AuthProvider` class and JWT token handling.

**Test Coverage (15 test cases):**

#### **🔧 Initialization Tests**
- Default state validation
- Proper setup verification

#### **👤 User Info Management**
- External user info setting
- Demo mode state handling
- User profile loading scenarios

#### **🎭 Demo Mode Tests**
- Enable/disable functionality
- State transitions and consistency
- Force reset when real authentication detected

#### **🔑 Authorization & Security**
- Authorization header generation
- Token-based authentication
- Scope and permission checking

#### **⏰ Token Expiration**
- Token validity detection
- Expiration buffer handling
- Edge case scenarios

#### **🔧 JWT Helper Functions**
- Valid token decoding and user extraction
- Fallback handling (preferred_username when name missing)
- Error resilience with malformed tokens
- Base64 normalization and padding

### **unit/service_locator_test.dart** - Service Locator Tests
Tests dependency injection and user info initialization logic.

**Test Coverage (5 test cases):**

#### **🔄 User Info Initialization**
- API calls for full user profiles
- Authentication state handling
- API vs JWT data prioritization

#### **⚠️ Error Handling**
- Graceful fallback when API calls fail
- Network error scenarios
- Service initialization failures

#### **🔗 Service Registration**
- Proper dependency injection setup
- Service availability verification

## 🛠️ Test Utilities & Helpers

### **helpers/test_helpers.dart** - Common Utilities
- **TestDataHelpers**: Timeouts, delays, condition waiting
- **TestWidgetHelpers**: Material app wrappers, widget pumping
- **TestPatterns**: Common interaction patterns (tap, text input)
- **TestDebugHelpers**: Debug output, widget tree inspection
- **TestAssertions**: Enhanced assertion helpers

### **helpers/mock_factories.dart** - Mock Data Generation
- **MockAuthFactory**: JWT tokens, user data, demo users
- **MockApiFactory**: API responses, error scenarios
- **MockWorkspaceFactory**: Workspace test data
- **MockAgentFactory**: Agent test data and lists

## 🚀 Running Tests

### **All Tests**
```bash
flutter test
```

### **Specific Test Types**
```bash
# Unit tests only
flutter test test/unit/

# Widget tests only  
flutter test test/widget/

# Integration tests only
flutter test test/integration/

# Authentication tests specifically
flutter test test/unit/providers/auth_provider_test.dart test/unit/service_locator_test.dart
```

### **With Coverage & Verbose Output**
```bash
flutter test --coverage --reporter=expanded
```

### **Continuous Integration**
```bash
# CI runs these commands automatically on PRs
flutter analyze --fatal-infos
flutter test --coverage --reporter=expanded
```

## 🚨 Key Issues Tested & Fixed

### **🔴 Token Loss Issue (Fixed)**
- **Problem**: `DmToolsApiServiceImpl` wasn't receiving `AuthProvider`, causing all API requests without authentication headers
- **Tests**: ServiceLocator tests verify proper auth provider injection
- **Prevention**: CI workflow catches any regression in authentication logic

### **🔴 User Profile Issue (Fixed)**
- **Problem**: User profile showed "User" instead of actual name because API calls were skipped when JWT user already existed
- **Tests**: "should load user info even when JWT user already exists" test
- **Prevention**: Ensures API calls always happen for complete user data

### **🔴 JWT Parsing Edge Cases (Covered)**
- **Problem**: JWT tokens might have different claim structures
- **Tests**: Handle missing `name` field, use `preferred_username` fallback
- **Prevention**: Comprehensive JWT helper function test coverage

## 📈 Test Architecture & Patterns

### **Mock Strategy**
- **Simple Mocks**: Avoid complex mocking framework dependencies
- **Factory Pattern**: Consistent mock data generation via factories
- **Isolated Testing**: Each test runs in isolation with fresh state

### **Error Scenario Coverage**
- **Network Failures**: API service errors handled gracefully
- **Malformed Data**: Invalid JWT tokens don't crash the app
- **State Transitions**: Authentication state changes are consistent

### **Debug & Logging**
- **Test Steps**: Clear logging of test execution steps
- **State Visibility**: Debug output shows authentication flow progress
- **Assertion Feedback**: Clear success/failure indicators

## 🔄 Maintenance & Development

### **Adding New Tests**
1. **Location**: Place in appropriate directory mirroring `lib/` structure
2. **Naming**: Use `{source_file_name}_test.dart` convention
3. **Pattern**: Follow existing group and test case patterns
4. **Coverage**: Include positive, negative, and edge cases

### **Test File Template**
```dart
/// Tests for [ClassName] 
/// 
/// Covers:
/// - Primary functionality
/// - Error scenarios  
/// - Edge cases

import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_helpers.dart';
import '../helpers/mock_factories.dart';

void main() {
  group('ClassName', () {
    late ClassName instance;
    
    setUp(() {
      instance = ClassName();
    });
    
    group('Primary Function', () {
      test('should behave correctly when condition', () {
        // Arrange
        // Act  
        // Assert
      });
    });
  });
}
```

### **Dependencies & Tools**
- **flutter_test**: Core testing framework
- **mockito**: Complex mocking (when needed)
- **integration_test**: End-to-end testing
- **Test Helpers**: Local utilities for common patterns

## 🎯 Future Enhancements

### **Planned Test Additions**
- **Widget Tests**: Authentication login widget, user profile widget
- **Integration Tests**: Complete OAuth flow, API integration scenarios
- **Performance Tests**: JWT decoding, large data handling
- **Security Tests**: Token storage, sensitive data handling

### **Test Infrastructure**
- **Golden Tests**: Visual regression testing for main app
- **Automated Mocking**: Generated mocks with build_runner
- **Test Data Management**: Centralized test data configuration
- **CI/CD Optimization**: Parallel test execution, better reporting

## 📊 Coverage Goals

- **Unit Tests**: 90%+ coverage for critical authentication logic
- **Widget Tests**: 80%+ coverage for user interface components  
- **Integration Tests**: 100% coverage for core user workflows
- **E2E Tests**: Complete authentication and primary feature flows

This structured approach ensures maintainable, scalable test coverage that grows with the application while preventing critical regressions. 