import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

void main() {
  group('AiIntegrationSelector Widget Tests', () {
    final sampleIntegrations = [
      const AiIntegration(id: 'gemini-123', displayName: 'Gemini 2.5 Flash Lite', type: 'gemini'),
      const AiIntegration(id: 'dial-456', displayName: 'Dial Claude', type: 'dial'),
    ];

    Widget createTestWidget({
      List<AiIntegration> integrations = const [],
      AiIntegration? selectedIntegration,
      ValueChanged<AiIntegration?>? onIntegrationChanged,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AiIntegrationSelector(
            integrations: integrations,
            selectedIntegration: selectedIntegration,
            onIntegrationChanged: onIntegrationChanged,
          ),
        ),
      );
    }

    group('Basic Rendering', () {
      testWidgets('should render with minimal parameters', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(AiIntegrationSelector), findsOneWidget);
      });

      testWidgets('should show AI icon button', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(integrations: sampleIntegrations, selectedIntegration: sampleIntegrations.first),
        );

        // Assert
        expect(find.byType(AiIntegrationSelector), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('Integration Display', () {
      testWidgets('should display selected integration icon', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(integrations: sampleIntegrations, selectedIntegration: sampleIntegrations.first),
        );

        // Assert
        expect(find.byType(AiIntegrationSelector), findsOneWidget);
        expect(find.byType(IntegrationTypeIcon), findsOneWidget);
      });

      testWidgets('should handle null selected integration', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget(integrations: sampleIntegrations));

        // Assert
        expect(find.byType(AiIntegrationSelector), findsOneWidget);
        // Should show default icon when no integration selected
      });
    });

    group('Model Validation', () {
      test('should create AiIntegration correctly', () {
        // Arrange & Act
        const integration = AiIntegration(id: 'test-123', displayName: 'Test AI', type: 'gemini');

        // Assert
        expect(integration.id, equals('test-123'));
        expect(integration.displayName, equals('Test AI'));
        expect(integration.type, equals('gemini'));
        expect(integration.isActive, isTrue);
      });

      test('should handle optional parameters', () {
        // Test with minimal parameters
        const minimalIntegration = AiIntegration(id: 'minimal', displayName: 'Minimal AI', type: 'test');

        expect(minimalIntegration.isActive, isTrue); // Default value
        expect(minimalIntegration.iconUrl, isNull);

        // Test with all parameters
        const fullIntegration = AiIntegration(
          id: 'full',
          displayName: 'Full AI',
          type: 'test',
          iconUrl: 'https://example.com/icon.png',
          isActive: false,
        );

        expect(fullIntegration.isActive, isFalse);
        expect(fullIntegration.iconUrl, equals('https://example.com/icon.png'));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle empty integrations list', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget(integrations: []));

        // Assert
        expect(find.byType(AiIntegrationSelector), findsOneWidget);
        // Should render without crashing
      });

      testWidgets('should handle very long integration names', (WidgetTester tester) async {
        // Arrange
        const longNameIntegration = [
          AiIntegration(
            id: 'long-name',
            displayName: 'This is a very long AI integration name that might cause layout issues',
            type: 'test',
          ),
        ];

        // Act
        await tester.pumpWidget(
          createTestWidget(integrations: longNameIntegration, selectedIntegration: longNameIntegration.first),
        );

        // Assert
        expect(find.byType(AiIntegrationSelector), findsOneWidget);
        // Should handle long names without overflow
      });
    });
  });
}
