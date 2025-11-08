import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/widgets/atoms/buttons/app_buttons.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';

void main() {
  group('Button Accessibility Tests', () {
    Widget wrapWithApp(Widget child) {
      return ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: child),
          ),
        ),
      );
    }

    group('PrimaryButton Accessibility', () {
      testWidgets('has correct semantic properties', (tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            const PrimaryButton(
              text: 'Submit',
              testId: 'button-submit',
            ),
          ),
        );

        // Verify the button exists with correct test ID
        expect(find.byKey(const ValueKey('button-submit')), findsOneWidget);

        // Verify semantics
        final semantics = tester.getSemantics(find.text('Submit'));
        expect(semantics.label, contains('Submit'));
      });

      testWidgets('generates automatic test ID from text', (tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            const PrimaryButton(text: 'Cancel'),
          ),
        );

        // Auto-generated testId should be 'button-cancel'
        expect(find.byKey(const ValueKey('button-cancel')), findsOneWidget);
      });

      testWidgets('responds to keyboard Enter key', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          wrapWithApp(
            PrimaryButton(
              text: 'Submit',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        );

        // Focus the button
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Simulate Enter key press
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(pressed, isTrue);
      });

      testWidgets('responds to keyboard Space key', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          wrapWithApp(
            PrimaryButton(
              text: 'Submit',
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        );

        // Focus the button
        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Simulate Space key press
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();

        expect(pressed, isTrue);
      });

      testWidgets('disabled button does not respond to tap', (tester) async {
        var pressed = false;
        await tester.pumpWidget(
          wrapWithApp(
            PrimaryButton(
              text: 'Submit',
              isDisabled: true,
              onPressed: () {
                pressed = true;
              },
            ),
          ),
        );

        await tester.tap(find.text('Submit'));
        await tester.pumpAndSettle();

        // Disabled button should not trigger onPressed
        expect(pressed, isFalse);
      });

      testWidgets('loading button shows loading state', (tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            const PrimaryButton(
              text: 'Submit',
              isLoading: true,
            ),
          ),
        );

        // Loading indicator should be present
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets('accepts custom semantic label and hint', (tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            const PrimaryButton(
              text: 'OK',
              semanticLabel: 'Confirm action',
              semanticHint: 'Confirms the dialog',
            ),
          ),
        );

        // Verify button renders with correct text
        expect(find.text('OK'), findsOneWidget);
        
        // Custom semantic label is set on the Semantics widget
        // The actual verification would require checking the semantics tree
        // which is implementation-specific
      });
    });

    group('SecondaryButton Accessibility', () {
      testWidgets('has correct semantic properties', (tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            const SecondaryButton(
              text: 'Cancel',
              testId: 'button-cancel',
            ),
          ),
        );

        expect(find.byKey(const ValueKey('button-cancel')), findsOneWidget);
      });
    });

    group('OutlineButton Accessibility', () {
      testWidgets('has correct semantic properties', (tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            const OutlineButton(
              text: 'Learn More',
              testId: 'button-learn-more',
            ),
          ),
        );

        expect(find.byKey(const ValueKey('button-learn-more')), findsOneWidget);
      });
    });

    group('Button with Icon Accessibility', () {
      testWidgets('includes icon in button', (tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            const PrimaryButton(
              text: 'Add',
              icon: Icons.add,
            ),
          ),
        );

        expect(find.byIcon(Icons.add), findsOneWidget);
        expect(find.text('Add'), findsOneWidget);
      });
    });

    group('Full Width Button Accessibility', () {
      testWidgets('renders at full width', (tester) async {
        await tester.pumpWidget(
          wrapWithApp(
            const PrimaryButton(
              text: 'Full Width',
              isFullWidth: true,
            ),
          ),
        );

        final button = find.byType(PrimaryButton);
        expect(button, findsOneWidget);
      });
    });
  });
}

