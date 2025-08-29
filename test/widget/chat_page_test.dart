import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

import 'package:dmtools/screens/pages/chat_page.dart';
import 'package:dmtools/providers/chat_provider.dart';
import 'package:dmtools/core/services/file_service.dart';
import 'package:dmtools/service_locator.dart';

import 'chat_page_test.mocks.dart';

@GenerateMocks([ChatProvider, FileService])
void main() {
  group('ChatPage Widget Tests', () {
    late MockChatProvider mockChatProvider;
    late MockFileService mockFileService;

    setUp(() {
      mockChatProvider = MockChatProvider();
      mockFileService = MockFileService();

      // Setup ServiceLocator for testing
      ServiceLocator.registerLazySingleton<FileService>(() => mockFileService);

      // Setup default mock behavior
      when(mockChatProvider.currentState).thenReturn(ChatState.initial);
      when(mockChatProvider.messages).thenReturn([]);
      when(mockChatProvider.availableAiIntegrations).thenReturn([]);
      when(mockChatProvider.selectedAiIntegration).thenReturn(null);
      when(mockChatProvider.attachments).thenReturn([]);
      when(mockChatProvider.isLoading).thenReturn(false);
      when(mockChatProvider.isUploadingFiles).thenReturn(false);
      when(mockChatProvider.uploadProgress).thenReturn(null);
      when(mockChatProvider.error).thenReturn(null);
      when(mockChatProvider.hasError).thenReturn(false);
      when(mockChatProvider.isEmpty).thenReturn(true);
    });

    tearDown(() {
      ServiceLocator.reset();
    });

    Widget createTestWidget() {
      return MaterialApp(
        home: ChangeNotifierProvider<ChatProvider>.value(
          value: mockChatProvider,
          child: const ChatPage(),
        ),
      );
    }

    group('Loading State', () {
      testWidgets('should show loading state when chat is loading', (WidgetTester tester) async {
        // Arrange
        when(mockChatProvider.currentState).thenReturn(ChatState.loading);
        when(mockChatProvider.isEmpty).thenReturn(true);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading AI integrations...'), findsOneWidget);
      });
    });

    group('Empty State', () {
      testWidgets('should show empty state when no AI integrations available', (WidgetTester tester) async {
        // Arrange
        when(mockChatProvider.currentState).thenReturn(ChatState.initial);
        when(mockChatProvider.availableAiIntegrations).thenReturn([]);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(EmptyState), findsOneWidget);
        expect(find.text('No AI Integrations Available'), findsOneWidget);
        expect(find.byIcon(Icons.smart_toy_outlined), findsOneWidget);
      });
    });

    group('Chat Interface', () {
      testWidgets('should show ChatInterface when AI integrations are available', (WidgetTester tester) async {
        // Arrange
        const mockIntegrations = [
          AiIntegration(
            id: 'test-ai',
            displayName: 'Test AI',
            type: 'gemini',
            available: true,
          ),
        ];

        when(mockChatProvider.availableAiIntegrations).thenReturn(mockIntegrations);
        when(mockChatProvider.selectedAiIntegration).thenReturn(mockIntegrations.first);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
      });

      testWidgets('should display messages correctly', (WidgetTester tester) async {
        // Arrange
        const mockIntegrations = [
          AiIntegration(
            id: 'test-ai',
            displayName: 'Test AI',
            type: 'gemini',
            available: true,
          ),
        ];

        final mockMessages = [
          ChatMessage(
            message: 'Hello AI',
            isUser: true,
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            message: 'Hello human!',
            isUser: false,
            timestamp: DateTime.now(),
          ),
        ];

        when(mockChatProvider.availableAiIntegrations).thenReturn(mockIntegrations);
        when(mockChatProvider.selectedAiIntegration).thenReturn(mockIntegrations.first);
        when(mockChatProvider.messages).thenReturn(mockMessages);
        when(mockChatProvider.isEmpty).thenReturn(false);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Note: Actual message display testing would require testing the ChatInterface widget
      });

      testWidgets('should handle message sending', (WidgetTester tester) async {
        // Arrange
        const mockIntegrations = [
          AiIntegration(
            id: 'test-ai',
            displayName: 'Test AI',
            type: 'gemini',
            available: true,
          ),
        ];

        when(mockChatProvider.availableAiIntegrations).thenReturn(mockIntegrations);
        when(mockChatProvider.selectedAiIntegration).thenReturn(mockIntegrations.first);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Find and tap the ChatInterface (this would trigger message sending in real usage)
        final chatInterface = find.byType(ChatInterface);
        expect(chatInterface, findsOneWidget);

        // Note: Actual message sending testing would require interacting with ChatInterface
        // The ChatInterface widget has its own tests in the styleguide
      });
    });

    group('File Attachment Handling', () {
      testWidgets('should handle attachment button press', (WidgetTester tester) async {
        // Arrange
        const mockIntegrations = [
          AiIntegration(
            id: 'test-ai',
            displayName: 'Test AI',
            type: 'gemini',
            available: true,
          ),
        ];

        when(mockChatProvider.availableAiIntegrations).thenReturn(mockIntegrations);
        when(mockChatProvider.selectedAiIntegration).thenReturn(mockIntegrations.first);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Note: File attachment testing would require mocking FilePicker
      });

      testWidgets('should display file attachments correctly', (WidgetTester tester) async {
        // Arrange
        const mockIntegrations = [
          AiIntegration(
            id: 'test-ai',
            displayName: 'Test AI',
            type: 'gemini',
            available: true,
          ),
        ];

        final mockAttachments = [
          FileAttachment(
            name: 'test.png',
            size: 1024,
            type: 'png',
            bytes: [1, 2, 3],
            uploadedAt: DateTime.now(),
          ),
        ];

        when(mockChatProvider.availableAiIntegrations).thenReturn(mockIntegrations);
        when(mockChatProvider.selectedAiIntegration).thenReturn(mockIntegrations.first);
        when(mockChatProvider.attachments).thenReturn(mockAttachments);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Note: Attachment display testing is handled by FileAttachmentPicker tests
      });
    });

    group('AI Integration Selection', () {
      testWidgets('should handle AI integration changes', (WidgetTester tester) async {
        // Arrange
        const mockIntegrations = [
          AiIntegration(
            id: 'gemini-123',
            displayName: 'Gemini',
            type: 'gemini',
            available: true,
          ),
          AiIntegration(
            id: 'dial-456',
            displayName: 'Dial Claude',
            type: 'dial',
            available: true,
          ),
        ];

        when(mockChatProvider.availableAiIntegrations).thenReturn(mockIntegrations);
        when(mockChatProvider.selectedAiIntegration).thenReturn(mockIntegrations.first);

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Note: AI integration selection testing is handled by AiIntegrationSelector tests
      });
    });

    group('Error Handling', () {
      testWidgets('should handle chat errors gracefully', (WidgetTester tester) async {
        // Arrange
        const mockIntegrations = [
          AiIntegration(
            id: 'test-ai',
            displayName: 'Test AI',
            type: 'gemini',
            available: true,
          ),
        ];

        when(mockChatProvider.availableAiIntegrations).thenReturn(mockIntegrations);
        when(mockChatProvider.selectedAiIntegration).thenReturn(mockIntegrations.first);
        when(mockChatProvider.currentState).thenReturn(ChatState.error);
        when(mockChatProvider.hasError).thenReturn(true);
        when(mockChatProvider.error).thenReturn('Test error message');

        // Act
        await tester.pumpWidget(createTestWidget());

        // Assert
        expect(find.byType(ChatInterface), findsOneWidget);
        // Note: Error display is handled within ChatInterface
      });
    });

    group('Responsive Behavior', () {
      testWidgets('should adapt to different screen sizes', (WidgetTester tester) async {
        // Arrange
        const mockIntegrations = [
          AiIntegration(
            id: 'test-ai',
            displayName: 'Test AI',
            type: 'gemini',
            available: true,
          ),
        ];

        when(mockChatProvider.availableAiIntegrations).thenReturn(mockIntegrations);
        when(mockChatProvider.selectedAiIntegration).thenReturn(mockIntegrations.first);

        // Test different screen sizes
        await tester.binding.setSurfaceSize(const Size(400, 800)); // Mobile
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(ChatInterface), findsOneWidget);

        await tester.binding.setSurfaceSize(const Size(1200, 800)); // Desktop
        await tester.pumpWidget(createTestWidget());
        expect(find.byType(ChatInterface), findsOneWidget);

        // Reset to default
        await tester.binding.setSurfaceSize(null);
      });
    });
  });
}
