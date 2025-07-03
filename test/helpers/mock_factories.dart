/// Mock factories for creating test data objects
///
/// This file contains factory methods for creating mock objects
/// used in tests across the project.
library;

import 'dart:convert';

/// Factory for creating mock authentication and user-related test data
class MockAuthFactory {
  /// Creates a mock JWT token for testing
  static String createJwtToken({
    String? userId,
    String? name,
    String? email,
    bool expired = false,
  }) {
    final header = {'alg': 'HS256', 'typ': 'JWT'};
    final headerEncoded = base64Url.encode(utf8.encode(json.encode(header)));

    final now = DateTime.now();
    final payload = {
      'sub': userId ?? 'test-user-123',
      'name': name ?? 'Test User',
      'email': email ?? 'test@example.com',
      'iat': now.millisecondsSinceEpoch ~/ 1000,
      'exp': expired
          ? now.subtract(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000
          : now.add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
    };

    final payloadEncoded = base64Url.encode(utf8.encode(json.encode(payload)));
    const signature = 'mock-signature';

    return '$headerEncoded.$payloadEncoded.$signature';
  }

  /// Creates mock user data map
  static Map<String, dynamic> createUserData({
    String? id,
    String? name,
    String? email,
    String? profilePictureUrl,
  }) {
    return {
      'id': id ?? 'test-user-123',
      'name': name ?? 'Test User',
      'email': email ?? 'test@example.com',
      'profilePictureUrl': profilePictureUrl,
    };
  }

  /// Creates a demo user data
  static Map<String, dynamic> createDemoUserData() {
    return createUserData(
      id: 'demo-user',
      name: 'Demo User',
      email: 'demo@dmtools.com',
    );
  }
}

/// Factory for creating mock API responses
class MockApiFactory {
  /// Creates a successful API response structure
  static Map<String, dynamic> createSuccessResponse({
    dynamic data,
    String? message,
  }) {
    return {
      'success': true,
      'data': data,
      'message': message ?? 'Success',
    };
  }

  /// Creates an error API response structure
  static Map<String, dynamic> createErrorResponse({
    String? message,
    int? statusCode,
  }) {
    return {
      'success': false,
      'error': message ?? 'Test error',
      'statusCode': statusCode ?? 400,
    };
  }
}

/// Factory for creating test workspace data
class MockWorkspaceFactory {
  /// Creates mock workspace data
  static Map<String, dynamic> createWorkspaceData({
    String? id,
    String? name,
    String? description,
  }) {
    return {
      'id': id ?? 'test-workspace-123',
      'name': name ?? 'Test Workspace',
      'description': description ?? 'A test workspace for testing purposes',
    };
  }
}

/// Factory for creating test agent data
class MockAgentFactory {
  /// Creates mock agent data
  static Map<String, dynamic> createAgentData({
    String? id,
    String? name,
    String? description,
    String? type,
  }) {
    return {
      'id': id ?? 'test-agent-123',
      'name': name ?? 'Test Agent',
      'description': description ?? 'A test agent for testing purposes',
      'type': type ?? 'ai-assistant',
    };
  }

  /// Creates a list of mock agents
  static List<Map<String, dynamic>> createAgentList([int count = 3]) {
    return List.generate(
      count,
      (index) => createAgentData(
        id: 'test-agent-${index + 1}',
        name: 'Test Agent ${index + 1}',
        description: 'Test agent number ${index + 1}',
      ),
    );
  }
}
