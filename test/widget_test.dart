import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

import 'package:dmtools/main.dart';

void main() {
  testWidgets('DMTools app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => ThemeProvider(),
        child: const DMToolsApp(),
      ),
    );

    // Verify that the app loads without crashing
    expect(find.byType(MaterialApp), findsOneWidget);

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // The test passes if no exception is thrown
  });
}
