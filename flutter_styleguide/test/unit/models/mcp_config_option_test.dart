import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/models/mcp_config_option.dart';

void main() {
  group('McpConfigOption', () {
    group('Constructor', () {
      test('should create a standard McpConfigOption', () {
        const option = McpConfigOption(id: 'test-id', name: 'Test Configuration');

        expect(option.id, equals('test-id'));
        expect(option.name, equals('Test Configuration'));
        expect(option.isNone, isFalse);
      });

      test('should create McpConfigOption with minimal parameters', () {
        const option = McpConfigOption(name: 'Minimal Config');

        expect(option.id, isNull);
        expect(option.name, equals('Minimal Config'));
        expect(option.isNone, isFalse); // isNone defaults to false
      });
    });

    group('Factory constructors', () {
      test('should create a "None" option', () {
        const noneOption = McpConfigOption.none();

        expect(noneOption.id, isNull);
        expect(noneOption.name, equals('None'));
        expect(noneOption.isNone, isTrue);
      });

      test('should create from config with required parameters', () {
        const configOption = McpConfigOption.fromConfig(id: 'config-id', name: 'Config Name');

        expect(configOption.id, equals('config-id'));
        expect(configOption.name, equals('Config Name'));
        expect(configOption.isNone, isFalse);
      });
    });

    group('isNone property', () {
      test('should return false by default', () {
        const option = McpConfigOption(name: 'Test');
        expect(option.isNone, isFalse);
      });

      test('should return false when explicitly set', () {
        const option = McpConfigOption(id: 'test-id', name: 'Test');
        expect(option.isNone, isFalse);
      });

      test('should return true for none() factory', () {
        const noneOption = McpConfigOption.none();
        expect(noneOption.isNone, isTrue);
      });

      test('should return false for fromConfig() factory', () {
        const configOption = McpConfigOption.fromConfig(id: 'test', name: 'Test');
        expect(configOption.isNone, isFalse);
      });
    });

    group('Equality', () {
      test('should be equal when id and name are the same', () {
        const option1 = McpConfigOption(id: 'same-id', name: 'Same Name');
        const option2 = McpConfigOption(id: 'same-id', name: 'Same Name');

        expect(option1, equals(option2));
        expect(option1.hashCode, equals(option2.hashCode));
      });

      test('should not be equal when id differs', () {
        const option1 = McpConfigOption(id: 'id-1', name: 'Same Name');
        const option2 = McpConfigOption(id: 'id-2', name: 'Same Name');

        expect(option1, isNot(equals(option2)));
      });

      test('should not be equal when name differs', () {
        const option1 = McpConfigOption(id: 'same-id', name: 'Name 1');
        const option2 = McpConfigOption(id: 'same-id', name: 'Name 2');

        expect(option1, isNot(equals(option2)));
      });

      test('should be equal for none options', () {
        const none1 = McpConfigOption.none();
        const none2 = McpConfigOption.none();

        expect(none1, equals(none2));
        expect(none1.hashCode, equals(none2.hashCode));
      });

      test('should handle identical instances', () {
        const option = McpConfigOption(id: 'test', name: 'Test');

        expect(option, equals(option));
      });
    });

    group('Edge cases', () {
      test('should handle empty string id', () {
        const option = McpConfigOption(id: '', name: 'Test');
        expect(option.isNone, isFalse); // empty string is not null
      });

      test('should handle empty string name', () {
        const option = McpConfigOption(id: 'test', name: '');
        expect(option.name, equals(''));
        expect(option.isNone, isFalse);
      });

      test('should handle null id gracefully', () {
        const option = McpConfigOption(name: 'Test');
        expect(option.id, isNull);
      });

      test('should handle isNone flag correctly', () {
        const option = McpConfigOption(id: 'test', name: 'Test', isNone: true);
        expect(option.isNone, isTrue);
      });
    });
  });
}
