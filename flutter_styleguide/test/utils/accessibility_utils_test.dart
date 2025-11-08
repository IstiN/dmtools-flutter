import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/utils/accessibility_utils.dart';

void main() {
  group('generateTestId', () {
    test('generates simple test ID without parameters', () {
      expect(generateTestId('button'), equals('button'));
      expect(generateTestId('input'), equals('input'));
      expect(generateTestId('card'), equals('card'));
    });

    test('generates test ID with single parameter', () {
      expect(
        generateTestId('button', {'action': 'submit'}),
        equals('button-submit'),
      );
      expect(
        generateTestId('input', {'field': 'email'}),
        equals('input-email'),
      );
    });

    test('generates test ID with multiple parameters in alphabetical order', () {
      expect(
        generateTestId('card', {'type': 'agent', 'name': 'GPT-4'}),
        equals('card-gpt-4-agent'),
      );
      expect(
        generateTestId('button', {'context': 'form', 'action': 'submit'}),
        equals('button-submit-form'),
      );
    });

    test('sanitizes test ID values to lowercase', () {
      expect(
        generateTestId('button', {'action': 'Submit'}),
        equals('button-submit'),
      );
      expect(
        generateTestId('Card', {'Type': 'Agent'}),
        equals('card-agent'),
      );
    });

    test('replaces special characters with hyphens', () {
      expect(
        generateTestId('button', {'action': 'submit form'}),
        equals('button-submit-form'),
      );
      expect(
        generateTestId('card', {'name': 'GPT-4.0'}),
        equals('card-gpt-4-0'),
      );
      expect(
        generateTestId('input', {'field': 'user@email'}),
        equals('input-user-email'),
      );
    });

    test('handles empty parameters', () {
      expect(generateTestId('button', {}), equals('button'));
      expect(generateTestId('button'), equals('button'));
    });

    test('filters out null parameter values', () {
      expect(
        generateTestId('button', {'action': 'submit', 'context': null}),
        equals('button-submit'),
      );
    });

    test('removes consecutive hyphens', () {
      expect(
        generateTestId('button', {'action': 'submit  form'}),
        equals('button-submit-form'),
      );
    });

    test('removes leading and trailing hyphens', () {
      expect(
        generateTestId('button', {'action': '-submit-'}),
        equals('button-submit'),
      );
    });
  });

  group('generateSemanticLabel', () {
    test('generates label for button', () {
      expect(
        generateSemanticLabel('button', 'Submit form'),
        equals('Submit form button'),
      );
    });

    test('generates label for input field', () {
      expect(
        generateSemanticLabel('input', 'Email address'),
        equals('Email address input field'),
      );
      expect(
        generateSemanticLabel('textfield', 'Password'),
        equals('Password input field'),
      );
    });

    test('generates label for checkbox', () {
      expect(
        generateSemanticLabel('checkbox', 'Remember me'),
        equals('Remember me checkbox'),
      );
    });

    test('generates label for radio button', () {
      expect(
        generateSemanticLabel('radio', 'Option A'),
        equals('Option A radio button'),
      );
    });

    test('generates label for card', () {
      expect(
        generateSemanticLabel('card', 'Agent GPT-4'),
        equals('Agent GPT-4 card'),
      );
    });

    test('handles case-insensitive component types', () {
      expect(
        generateSemanticLabel('BUTTON', 'Click me'),
        equals('Click me button'),
      );
      expect(
        generateSemanticLabel('Button', 'Submit'),
        equals('Submit button'),
      );
    });

    test('returns context only for unknown component types', () {
      expect(
        generateSemanticLabel('unknown', 'Some content'),
        equals('Some content'),
      );
    });
  });

  group('isValidTestId', () {
    test('validates correct test IDs', () {
      expect(isValidTestId('button'), isTrue);
      expect(isValidTestId('button-submit'), isTrue);
      expect(isValidTestId('card-agent-gpt4'), isTrue);
      expect(isValidTestId('input-email-address'), isTrue);
    });

    test('rejects empty test IDs', () {
      expect(isValidTestId(''), isFalse);
    });

    test('rejects test IDs with uppercase letters', () {
      expect(isValidTestId('Button'), isFalse);
      expect(isValidTestId('button-Submit'), isFalse);
    });

    test('rejects test IDs with special characters', () {
      expect(isValidTestId('button_submit'), isFalse);
      expect(isValidTestId('button.submit'), isFalse);
      expect(isValidTestId('button@submit'), isFalse);
      expect(isValidTestId('button submit'), isFalse);
    });

    test('rejects test IDs starting or ending with hyphen', () {
      expect(isValidTestId('-button'), isFalse);
      expect(isValidTestId('button-'), isFalse);
      expect(isValidTestId('-button-submit-'), isFalse);
    });

    test('rejects test IDs with consecutive hyphens', () {
      expect(isValidTestId('button--submit'), isFalse);
    });
  });

  group('combineTestIdParts', () {
    test('combines multiple parts', () {
      expect(
        combineTestIdParts(['form', 'login', 'submit']),
        equals('form-login-submit'),
      );
      expect(
        combineTestIdParts(['card', 'agent', 'gpt4']),
        equals('card-agent-gpt4'),
      );
    });

    test('sanitizes parts before combining', () {
      expect(
        combineTestIdParts(['Form', 'Login', 'Submit']),
        equals('form-login-submit'),
      );
      expect(
        combineTestIdParts(['button', 'submit form', 'action']),
        equals('button-submit-form-action'),
      );
    });

    test('filters out empty parts', () {
      expect(
        combineTestIdParts(['button', '', 'submit']),
        equals('button-submit'),
      );
      expect(
        combineTestIdParts(['', 'button', 'submit', '']),
        equals('button-submit'),
      );
    });

    test('handles empty list', () {
      expect(combineTestIdParts([]), equals(''));
    });

    test('handles list with only empty strings', () {
      expect(combineTestIdParts(['', '', '']), equals(''));
    });
  });

  group('extractComponentType', () {
    test('extracts component type from test ID', () {
      expect(extractComponentType('button-submit'), equals('button'));
      expect(extractComponentType('card-agent-gpt4'), equals('card'));
      expect(extractComponentType('input-email'), equals('input'));
    });

    test('returns entire string for single-part test ID', () {
      expect(extractComponentType('button'), equals('button'));
      expect(extractComponentType('card'), equals('card'));
    });

    test('returns empty string for empty test ID', () {
      expect(extractComponentType(''), equals(''));
    });
  });
}

