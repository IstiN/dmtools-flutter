import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/mixins/accessibility_mixin.dart';

// Test widget that uses the AccessibilityMixin
class TestWidgetWithMixin extends StatelessWidget with AccessibilityMixin {
  const TestWidgetWithMixin({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

void main() {
  group('AccessibilityMixin', () {
    late TestWidgetWithMixin testWidget;

    setUp(() {
      testWidget = const TestWidgetWithMixin();
    });

    group('buildButtonSemantics', () {
      testWidgets('wraps child with Semantics widget', (tester) async {
        final widget = testWidget.buildButtonSemantics(
          child: const Text('Submit'),
          label: 'Submit button',
          hint: 'Submit the form',
          enabled: true,
          onTap: () {},
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.text('Submit'), findsOneWidget);
      });

      testWidgets('creates disabled button semantics without onTap', (tester) async {
        final widget = testWidget.buildButtonSemantics(
          child: const Text('Submit'),
          label: 'Submit button',
          enabled: false,
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
      });
    });

    group('buildTextFieldSemantics', () {
      testWidgets('wraps TextField with Semantics', (tester) async {
        final widget = testWidget.buildTextFieldSemantics(
          child: const TextField(),
          label: 'Email address',
          hint: 'Enter your email',
          value: 'test@example.com',
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets('handles obscured text fields', (tester) async {
        final widget = testWidget.buildTextFieldSemantics(
          child: const TextField(obscureText: true),
          label: 'Password',
          obscureText: true,
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
      });
    });

    group('buildCheckboxSemantics', () {
      testWidgets('wraps Checkbox with Semantics', (tester) async {
        final widget = testWidget.buildCheckboxSemantics(
          child: Checkbox(value: true, onChanged: (_) {}),
          label: 'Remember me',
          checked: true,
          onTap: () {},
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.byType(Checkbox), findsOneWidget);
      });

      testWidgets('handles unchecked state', (tester) async {
        final widget = testWidget.buildCheckboxSemantics(
          child: Checkbox(value: false, onChanged: (_) {}),
          label: 'Remember me',
          checked: false,
          onTap: () {},
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
      });
    });

    group('buildRadioSemantics', () {
      testWidgets('wraps Radio with Semantics', (tester) async {
        final widget = testWidget.buildRadioSemantics(
          child: Radio<int>(value: 1, groupValue: 1, onChanged: (_) {}),
          label: 'Option A',
          selected: true,
          onTap: () {},
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.byType(Radio<int>), findsOneWidget);
      });
    });

    group('buildContainerSemantics', () {
      testWidgets('wraps content with Semantics', (tester) async {
        final widget = testWidget.buildContainerSemantics(
          child: const Text('Content'),
          label: 'Card container',
          hint: 'Click to expand',
          focusable: true,
          onTap: () {},
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('buildImageSemantics', () {
      testWidgets('wraps image with Semantics', (tester) async {
        final widget = testWidget.buildImageSemantics(
          child: const Icon(Icons.home),
          label: 'Home icon',
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });
    });

    group('buildHeaderSemantics', () {
      testWidgets('wraps header with Semantics', (tester) async {
        final widget = testWidget.buildHeaderSemantics(
          child: const Text('Page Title'),
          label: 'Page Title',
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.text('Page Title'), findsOneWidget);
      });
    });

    group('buildLinkSemantics', () {
      testWidgets('wraps link with Semantics', (tester) async {
        final widget = testWidget.buildLinkSemantics(
          child: const Text('Click here'),
          label: 'Privacy policy link',
          hint: 'Opens privacy policy',
          onTap: () {},
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.text('Click here'), findsOneWidget);
      });
    });

    group('buildLiveRegionSemantics', () {
      testWidgets('wraps live region with Semantics', (tester) async {
        final widget = testWidget.buildLiveRegionSemantics(
          child: const Text('New message received'),
          label: 'New message received',
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Semantics), findsOneWidget);
        expect(find.text('New message received'), findsOneWidget);
      });
    });

    group('buildFocusableWidget', () {
      testWidgets('wraps widget with Focus', (tester) async {
        final widget = testWidget.buildFocusableWidget(
          child: const Text('Focusable'),
        );

        await tester.pumpWidget(MaterialApp(home: Scaffold(body: widget)));

        expect(find.byType(Focus), findsOneWidget);
        expect(find.text('Focusable'), findsOneWidget);
      });
    });

    group('createTestKey', () {
      test('creates ValueKey from test ID', () {
        final key = testWidget.createTestKey('button-submit');
        expect(key, isA<ValueKey<String>>());
        expect((key as ValueKey<String>).value, equals('button-submit'));
      });
    });

    group('safeGenerateTestId', () {
      test('generates test ID safely', () {
        final testId = testWidget.safeGenerateTestId('button', {'action': 'submit'});
        expect(testId, equals('button-submit'));
      });
    });

    group('safeGenerateSemanticLabel', () {
      test('generates semantic label safely', () {
        final label = testWidget.safeGenerateSemanticLabel('button', 'Submit form');
        expect(label, equals('Submit form button'));
      });
    });
  });

  group('AccessibilityContext extension', () {
    testWidgets('isAccessibilityEnabled returns correct value', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(context.isAccessibilityEnabled, isA<bool>());
              return const SizedBox();
            },
          ),
        ),
      );
    });

    testWidgets('accessibilityTextScale returns text scale factor', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              expect(context.accessibilityTextScale, isA<double>());
              expect(context.accessibilityTextScale, greaterThan(0));
              return const SizedBox();
            },
          ),
        ),
      );
    });
  });
}
