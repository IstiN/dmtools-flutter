import 'package:dmtools_styleguide/core/services/user_interaction_tracker.dart';
import 'package:dmtools_styleguide/theme/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserInteractionTracker', () {
    tearDown(() {
      UserInteractionTracker.instance.setCurrentScreen(null);
    });

    testWidgets('notifies listeners with sanitized button id', (tester) async {
      ButtonInteractionEvent? capturedEvent;
      UserInteractionTracker.instance.configure(
        onButtonInteraction: (event) {
          capturedEvent = event;
        },
      );

      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      UserInteractionTracker.instance.trackButtonInteraction(
        context: context,
        label: 'Submit Form!',
        size: ButtonSize.medium,
      );

      expect(capturedEvent, isNotNull);
      expect(capturedEvent!.buttonId, 'submit_form');
      expect(capturedEvent!.label, 'Submit Form!');
    });

    testWidgets('uses current screen name when available', (tester) async {
      ButtonInteractionEvent? capturedEvent;
      UserInteractionTracker.instance
        ..configure(
          onButtonInteraction: (event) {
            capturedEvent = event;
          },
        )
        ..setCurrentScreen('auth_page');

      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      UserInteractionTracker.instance.trackButtonInteraction(
        context: context,
        label: 'Login',
        size: ButtonSize.medium,
      );

      expect(capturedEvent?.screenName, 'auth_page');
    });
  });
}

