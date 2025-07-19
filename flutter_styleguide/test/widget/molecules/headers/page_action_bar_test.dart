import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

void main() {
  group('PageActionBar', () {
    const testTitle = 'Test Page Title';

    testWidgets('renders with title only', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              isTestMode: true,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.byType(PageActionBar), findsOneWidget);
    });

    testWidgets('renders with custom height of 56px', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: 'Test Page',
              isTestMode: true,
            ),
          ),
        ),
      );

      // Find the ConstrainedBox within the PageActionBar component
      final constrainedBox = tester.widget<ConstrainedBox>(
        find
            .descendant(
              of: find.byType(PageActionBar),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );

      expect(constrainedBox.constraints.minHeight, equals(56.0));
      expect(constrainedBox.constraints.maxHeight, equals(56.0));
    });

    testWidgets('renders with actions', (WidgetTester tester) async {
      final testActions = [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 1'),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.add),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              actions: testActions,
              isTestMode: true,
            ),
          ),
        ),
      );

      expect(find.text('Action 1'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('shows loading indicator when isLoading is true', (WidgetTester tester) async {
      final testActions = [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 1'),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              actions: testActions,
              isLoading: true,
              isTestMode: true,
            ),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Action 1'), findsNothing); // Actions should be hidden when loading
    });

    testWidgets('applies custom padding when provided', (WidgetTester tester) async {
      const customPadding = EdgeInsets.all(20.0);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              padding: customPadding,
              isTestMode: true,
            ),
          ),
        ),
      );

      final padding = tester.widget<Padding>(
        find
            .descendant(
              of: find.byType(PageActionBar),
              matching: find.byType(Padding),
            )
            .first,
      );

      expect(padding.padding, equals(customPadding));
    });

    testWidgets('shows border when showBorder is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              showBorder: true,
              isTestMode: true,
            ),
          ),
        ),
      );

      final decoratedBox = tester.widget<DecoratedBox>(
        find
            .descendant(
              of: find.byType(PageActionBar),
              matching: find.byType(DecoratedBox),
            )
            .first,
      );

      final decoration = decoratedBox.decoration as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('applies correct text styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              isTestMode: true,
            ),
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text(testTitle));
      expect(titleText.style?.fontSize, equals(18.0));
      expect(titleText.style?.fontWeight, equals(FontWeight.bold));
    });

    testWidgets('handles mobile layout with few actions', (WidgetTester tester) async {
      final testActions = [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 1'),
        ),
      ];

      // Set a narrow width to trigger mobile layout
      await tester.binding.setSurfaceSize(const Size(400, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              actions: testActions,
              isTestMode: true,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.text('Action 1'), findsOneWidget);
    });

    testWidgets('handles mobile layout with many actions', (WidgetTester tester) async {
      final testActions = [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 1'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 2'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 3'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 4'),
        ),
      ];

      // Set a narrow width to trigger mobile layout
      await tester.binding.setSurfaceSize(const Size(400, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              actions: testActions,
              isTestMode: true,
            ),
          ),
        ),
      );

      // Should show overflow menu when there are more actions than maxMobileActions
      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      // Check that the component uses dynamic height
      final constrainedBox = tester.widget<ConstrainedBox>(
        find
            .descendant(
              of: find.byType(PageActionBar),
              matching: find.byType(ConstrainedBox),
            )
            .first,
      );
      expect(constrainedBox.constraints.maxHeight, equals(double.infinity));
    });

    testWidgets('handles desktop layout', (WidgetTester tester) async {
      final testActions = [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 1'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 2'),
        ),
      ];

      // Set a wide width to trigger desktop layout
      await tester.binding.setSurfaceSize(const Size(1200, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              actions: testActions,
              isTestMode: true,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.text('Action 1'), findsOneWidget);
      expect(find.text('Action 2'), findsOneWidget);
    });

    testWidgets('has proper semantic labels for accessibility', (WidgetTester tester) async {
      final testActions = [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 1'),
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              actions: testActions,
              isTestMode: true,
            ),
          ),
        ),
      );

      // Check for header semantics
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.header == true,
        ),
        findsOneWidget,
      );

      // Check for page actions semantics
      expect(
        find.byWidgetPredicate(
          (widget) => widget is Semantics && widget.properties.label == 'Page actions',
        ),
        findsOneWidget,
      );
    });

    testWidgets('handles dark mode correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              isTestMode: true,
              testDarkMode: true,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      // Verify the component renders without errors in dark mode
      expect(find.byType(PageActionBar), findsOneWidget);
    });

    testWidgets('handles empty actions list', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              actions: [],
              isTestMode: true,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.byType(SizedBox), findsWidgets); // Should render SizedBox.shrink for empty actions
    });

    testWidgets('overflow menu works correctly', (WidgetTester tester) async {
      final testActions = [
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 1'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 2'),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Action 3'),
        ),
      ];

      // Set narrow width and limit mobile actions
      await tester.binding.setSurfaceSize(const Size(400, 800));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PageActionBar(
                title: testTitle,
                actions: testActions,
                maxMobileActions: 1,
                isTestMode: true,
              ),
            ),
          ),
        ),
      );

      // Should show overflow menu
      expect(find.byIcon(Icons.more_vert), findsOneWidget);

      // Ensure widget is fully rendered before tap
      await tester.pumpAndSettle();

      // Verify overflow menu is tappable
      expect(find.byType(PopupMenuButton<int>), findsOneWidget);
    });

    // Test edge cases
    testWidgets('handles null actions gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: testTitle,
              isTestMode: true,
            ),
          ),
        ),
      );

      expect(find.text(testTitle), findsOneWidget);
      expect(find.byType(PageActionBar), findsOneWidget);
    });

    testWidgets('title text truncates with ellipsis for long titles', (WidgetTester tester) async {
      const longTitle = 'This is a very long title that should truncate with ellipsis when the screen is narrow';

      await tester.binding.setSurfaceSize(const Size(300, 800));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PageActionBar(
              title: longTitle,
              isTestMode: true,
            ),
          ),
        ),
      );

      final titleText = tester.widget<Text>(find.text(longTitle));
      expect(titleText.overflow, equals(TextOverflow.ellipsis));
      expect(titleText.maxLines, equals(1));
    });
  });
}
