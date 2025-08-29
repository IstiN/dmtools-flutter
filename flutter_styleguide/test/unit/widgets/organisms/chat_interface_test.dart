import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

void main() {
  group('ChatInterface Widget Tests', () {
    final sampleMessages = [
      ChatMessage(message: 'Hello, how are you?', isUser: true, timestamp: DateTime.now()),
      ChatMessage(
        message: 'I am doing well, thank you! How can I help you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ),
    ];

    final sampleAiIntegrations = [
      const AiIntegration(id: 'gemini-123', displayName: 'Gemini 2.5 Flash Lite', type: 'gemini'),
      const AiIntegration(id: 'dial-456', displayName: 'Dial Claude', type: 'dial'),
    ];

    Widget createTestWidget({
      List<ChatMessage> messages = const [],
      List<AiIntegration> aiIntegrations = const [],
      AiIntegration? selectedAiIntegration,
      List<FileAttachment> attachments = const [],
      bool isLoading = false,
      String title = 'Test Chat',
      Function(String)? onSendMessage,
      VoidCallback? onAttachmentPressed,
      Function(AiIntegration?)? onAiIntegrationChanged,
      Function(List<FileAttachment>)? onAttachmentsChanged,
      Function(String)? onTextInsert,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: ChatInterface(
            title: title,
            messages: messages,
            onSendMessage: onSendMessage ?? (message) {},
            onAttachmentPressed: onAttachmentPressed,
            aiIntegrations: aiIntegrations,
            selectedAiIntegration: selectedAiIntegration,
            onAiIntegrationChanged: onAiIntegrationChanged,
            attachments: attachments,
            onAttachmentsChanged: onAttachmentsChanged,
            isLoading: isLoading,
            onTextInsert: onTextInsert,
          ),
        ),
      );
    }

    group('Basic Rendering', () {
      testWidgets('should render with minimal required parameters', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        expect(find.text('Test Chat'), findsOneWidget);
      });

      testWidgets('should display title correctly', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget(title: 'AI Assistant'));

        // Assert
        expect(find.text('AI Assistant'), findsOneWidget);
      });
    });

    group('Message Display', () {
      testWidgets('should display messages when provided', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget(messages: sampleMessages));

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Note: Individual message display testing depends on internal message widgets
      });

      testWidgets('should handle empty message list', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(createTestWidget(messages: []));

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Should not crash with empty messages
      });
    });

    group('Model Validation', () {
      test('should create ChatMessage correctly', () {
        // Arrange & Act
        final message = ChatMessage(message: 'Test message', isUser: true, timestamp: DateTime(2024));

        // Assert
        expect(message.message, equals('Test message'));
        expect(message.isUser, isTrue);
        expect(message.timestamp, equals(DateTime(2024)));
        expect(message.enableMarkdown, isTrue); // Default value
      });

      test('should handle optional timestamp', () {
        // Arrange & Act
        final message = ChatMessage(message: 'Test without timestamp', isUser: false);

        // Assert
        expect(message.message, equals('Test without timestamp'));
        expect(message.isUser, isFalse);
        expect(message.timestamp, isA<DateTime>()); // Should be set to now
        expect(message.enableMarkdown, isTrue);
      });

      test('should handle markdown settings', () {
        // Arrange & Act
        final messageWithMarkdown = ChatMessage(message: '**Bold** text', isUser: false);

        final messageWithoutMarkdown = ChatMessage(message: '**Bold** text', isUser: false, enableMarkdown: false);

        // Assert
        expect(messageWithMarkdown.enableMarkdown, isTrue);
        expect(messageWithoutMarkdown.enableMarkdown, isFalse);
      });
    });

    group('AI Integration Support', () {
      testWidgets('should display AI integration selector when integrations available', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(aiIntegrations: sampleAiIntegrations, selectedAiIntegration: sampleAiIntegrations.first),
        );

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        expect(find.byType(AiIntegrationSelector), findsOneWidget);
      });
    });

    group('File Attachments', () {
      testWidgets('should display file attachment picker when attachments exist', (WidgetTester tester) async {
        // Arrange
        final mockAttachments = [
          FileAttachment(name: 'test.png', size: 1024, type: 'png', bytes: [1, 2, 3], uploadedAt: DateTime.now()),
        ];

        // Act
        await tester.pumpWidget(createTestWidget(attachments: mockAttachments));

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        expect(find.byType(FileAttachmentPicker), findsOneWidget);
      });
    });

    group('Loading States', () {
      testWidgets('should handle loading state', (WidgetTester tester) async {
        // Act
        await tester.pumpWidget(
          createTestWidget(
            aiIntegrations: sampleAiIntegrations,
            selectedAiIntegration: sampleAiIntegrations.first,
            isLoading: true,
          ),
        );

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Note: Loading state display is handled within ChatInterface
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very long message lists', (WidgetTester tester) async {
        // Arrange
        final longMessageList = List.generate(
          50,
          (index) => ChatMessage(message: 'Message $index', isUser: index % 2 == 0, timestamp: DateTime.now()),
        );

        // Act
        await tester.pumpWidget(
          createTestWidget(
            aiIntegrations: sampleAiIntegrations,
            selectedAiIntegration: sampleAiIntegrations.first,
            messages: longMessageList,
          ),
        );

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Should handle large message lists without performance issues
      });
    });
  });
}
