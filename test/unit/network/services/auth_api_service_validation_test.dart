import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools/core/models/user.dart';

void main() {
  group('AuthApiService Authentication Validation', () {
    group('UserDto authenticated field validation', () {
      test('should accept user with authenticated: true', () {
        // Arrange
        const user = UserDto(
          id: 'user123',
          name: 'Test User',
          email: 'test@example.com',
          authenticated: true,
        );

        // Act & Assert
        expect(user.authenticated, true);
        expect(user.id, 'user123');
        expect(user.name, 'Test User');
      });

      test('should detect user with authenticated: false', () {
        // Arrange
        const user = UserDto(
          id: 'user123',
          name: 'Test User',
          email: 'test@example.com',
          authenticated: false,
        );

        // Act & Assert
        expect(user.authenticated, false);
      });

      test('should detect user with authenticated: null', () {
        // Arrange
        const user = UserDto(
          id: 'user123',
          name: 'Test User',
          email: 'test@example.com',
        );

        // Act & Assert
        expect(user.authenticated, null);
        expect(user.authenticated != true, true);
      });

      test('should parse authenticated field from JSON correctly', () {
        // Arrange
        final jsonWithTrue = {
          'id': 'user123',
          'name': 'Test User',
          'email': 'test@example.com',
          'authenticated': true,
        };

        final jsonWithFalse = {
          'id': 'user123',
          'name': 'Test User',
          'email': 'test@example.com',
          'authenticated': false,
        };

        final jsonWithoutAuth = {
          'id': 'user123',
          'name': 'Test User',
          'email': 'test@example.com',
        };

        // Act
        final userTrue = UserDto.fromJson(jsonWithTrue);
        final userFalse = UserDto.fromJson(jsonWithFalse);
        final userNull = UserDto.fromJson(jsonWithoutAuth);

        // Assert
        expect(userTrue.authenticated, true);
        expect(userFalse.authenticated, false);
        expect(userNull.authenticated, null);
      });
    });

    group('Authentication validation logic', () {
      test('validation should fail for authenticated: false', () {
        // Arrange
        const user = UserDto(
          id: 'user123',
          name: 'Test User',
          email: 'test@example.com',
          authenticated: false,
        );

        // Act
        final isValid = user.authenticated == true;

        // Assert
        expect(isValid, false);
      });

      test('validation should fail for authenticated: null', () {
        // Arrange
        const user = UserDto(
          id: 'user123',
          name: 'Test User',
          email: 'test@example.com',
        );

        // Act
        final isValid = user.authenticated == true;

        // Assert
        expect(isValid, false);
      });

      test('validation should pass for authenticated: true', () {
        // Arrange
        const user = UserDto(
          id: 'user123',
          name: 'Test User',
          email: 'test@example.com',
          authenticated: true,
        );

        // Act
        final isValid = user.authenticated == true;

        // Assert
        expect(isValid, true);
      });

      test('should use strict equality check (== true) not truthy check', () {
        // This test ensures we're using == true, not just checking truthiness
        
        // Arrange - various "falsy" values
        const userFalse = UserDto(authenticated: false);
        const userNull = UserDto();
        
        // Act & Assert - all should fail strict equality check
        expect(userFalse.authenticated == true, false);
        expect(userNull.authenticated == true, false);
        
        // Only true should pass
        const userTrue = UserDto(authenticated: true);
        expect(userTrue.authenticated == true, true);
      });
    });

    group('Error handling scenarios', () {
      test('should treat missing authenticated field as invalid', () {
        // Arrange
        final json = {
          'id': 'user123',
          'name': 'Test User',
          'email': 'test@example.com',
          // No authenticated field
        };

        // Act
        final user = UserDto.fromJson(json);
        final isValid = user.authenticated == true;

        // Assert
        expect(isValid, false);
        expect(user.authenticated, null);
      });

      test('should handle API response with authenticated: false gracefully', () {
        // Arrange - Simulating actual API response
        final apiResponse = {
          'authenticated': false,
          'id': null,
          'email': null,
          'name': null,
          'givenName': null,
          'familyName': null,
          'pictureUrl': null,
          'provider': null,
          'role': null,
        };

        // Act
        final user = UserDto.fromJson(apiResponse);

        // Assert
        expect(user.authenticated, false);
        expect(user.id, null);
        expect(user.email, null);
        expect(user.name, null);
      });
    });
  });
}


