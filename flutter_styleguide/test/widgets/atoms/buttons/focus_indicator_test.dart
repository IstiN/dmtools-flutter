import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

void main() {
  group('Button Focus Indicator Tests', () {
    testWidgets('Button shows focus indicator when focused', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PrimaryButton(
                text: 'Test Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Find the button's Focus widget
      final focusFinder = find.byType(Focus);
      expect(focusFinder, findsWidgets);

      // Request focus on the button
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      // The button should now be focused
      final focusNode = tester.widget<Focus>(focusFinder.first).focusNode;
      expect(focusNode?.hasFocus, isTrue);
    });

    testWidgets('Button accepts keyboard navigation', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PrimaryButton(
                text: 'Test Button',
                onPressed: () => tapped = true,
              ),
            ),
          ),
        ),
      );

      // Tab to focus the button
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      // Press Enter to activate
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('Disabled button does not respond to keyboard activation', (tester) async {
      var tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PrimaryButton(
                text: 'Disabled Button',
                onPressed: () => tapped = true,
                isDisabled: true,
              ),
            ),
          ),
        ),
      );

      // Try to activate with keyboard
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      
      // Disabled button should not be activated
      expect(tapped, isFalse);
    });

    testWidgets('Focus indicator appears on all button variants', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                PrimaryButton(
                  text: 'Primary',
                  onPressed: () {},
                ),
                SecondaryButton(
                  text: 'Secondary',
                  onPressed: () {},
                ),
                OutlineButton(
                  text: 'Outline',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      // All buttons should have Focus widgets
      final focusWidgets = find.byType(Focus);
      expect(focusWidgets, findsAtLeastNWidgets(3));
    });
  });
}

