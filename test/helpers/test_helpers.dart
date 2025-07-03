/// Common test utilities and helpers for the DMTools Flutter project
///
/// This file contains shared testing utilities, builders, and helpers
/// that are used across different test files to ensure consistency
/// and reduce code duplication.
library;

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test data utilities and constants
class TestDataHelpers {
  /// Common test timeouts
  static const Duration shortTimeout = Duration(seconds: 5);
  static const Duration mediumTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(seconds: 30);

  /// Common test delays
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration mediumDelay = Duration(milliseconds: 500);

  /// Wait for a specific condition with timeout
  static Future<void> waitForCondition(
    bool Function() condition, {
    Duration timeout = const Duration(seconds: 5),
    Duration checkInterval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();

    while (!condition() && stopwatch.elapsed < timeout) {
      await Future.delayed(checkInterval);
    }

    stopwatch.stop();

    if (!condition()) {
      throw TimeoutException(
        'Condition not met within ${timeout.inMilliseconds}ms',
        timeout,
      );
    }
  }
}

/// Test widget helpers for creating common test scenarios
class TestWidgetHelpers {
  /// Creates a basic Material app wrapper for testing widgets
  static Widget createTestApp({
    required Widget child,
    ThemeData? theme,
  }) {
    return MaterialApp(
      theme: theme,
      home: child,
    );
  }

  /// Pumps a widget wrapped in Material app and waits for settling
  static Future<void> pumpTestWidget(
    WidgetTester tester, {
    required Widget child,
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(createTestApp(child: child, theme: theme));
    await tester.pumpAndSettle();
  }
}

/// Common test patterns and interaction utilities
class TestPatterns {
  /// Simulates user tap and wait for settling
  static Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Simulates text input
  static Future<void> enterText(
    WidgetTester tester,
    Finder finder,
    String text,
  ) async {
    await tester.enterText(finder, text);
    await tester.pumpAndSettle();
  }

  /// Checks if text exists on screen
  static bool hasText(String text) {
    return find.text(text).evaluate().isNotEmpty;
  }

  /// Checks if widget type exists on screen
  static bool hasWidget<T extends Widget>() {
    return find.byType(T).evaluate().isNotEmpty;
  }

  /// Waits for a widget to appear
  static Future<void> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.pumpAndSettle();

    final stopwatch = Stopwatch()..start();
    while (finder.evaluate().isEmpty && stopwatch.elapsed < timeout) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    if (finder.evaluate().isEmpty) {
      throw TimeoutException(
        'Widget not found within ${timeout.inMilliseconds}ms',
        timeout,
      );
    }
  }
}

/// Debug helpers for tests
class TestDebugHelpers {
  /// Prints widget tree for debugging
  static void printWidgetTree(WidgetTester tester) {
    debugPrint('Widget Tree:');
    for (var widget in tester.allWidgets) {
      debugPrint('  ${widget.runtimeType}');
    }
  }

  /// Prints all text widgets found
  static void printAllText(WidgetTester tester) {
    debugPrint('Text Widgets:');
    final textWidgets = tester.widgetList<Text>(find.byType(Text));
    for (final text in textWidgets) {
      debugPrint('  "${text.data}"');
    }
  }

  /// Prints all buttons found
  static void printAllButtons(WidgetTester tester) {
    debugPrint('Button Widgets:');
    final elevatedButtons = tester.widgetList(find.byType(ElevatedButton));
    final textButtons = tester.widgetList(find.byType(TextButton));
    final outlinedButtons = tester.widgetList(find.byType(OutlinedButton));

    for (final button in [...elevatedButtons, ...textButtons, ...outlinedButtons]) {
      debugPrint('  ${button.runtimeType}');
    }
  }

  /// Logs test execution step
  static void logStep(String step) {
    debugPrint('🧪 Test Step: $step');
  }

  /// Logs test assertion
  static void logAssertion(String assertion, bool passed) {
    final status = passed ? '✅' : '❌';
    debugPrint('$status Assertion: $assertion');
  }
}

/// Test assertion helpers
class TestAssertions {
  /// Asserts that a widget exists and is visible
  static void assertWidgetExists<T extends Widget>(String description) {
    expect(find.byType(T), findsOneWidget, reason: description);
  }

  /// Asserts that text is present
  static void assertTextExists(String text, String description) {
    expect(find.text(text), findsOneWidget, reason: description);
  }

  /// Asserts that a widget does not exist
  static void assertWidgetDoesNotExist<T extends Widget>(String description) {
    expect(find.byType(T), findsNothing, reason: description);
  }

  /// Asserts that text is not present
  static void assertTextDoesNotExist(String text, String description) {
    expect(find.text(text), findsNothing, reason: description);
  }
}
