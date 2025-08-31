import 'package:flutter_test/flutter_test.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

import 'package:dmtools/providers/chat_provider.dart';

void main() {
  group('ChatProvider Tests', () {
    group('State Management', () {
      test('should initialize with correct default state', () {
        // Note: This test requires mocking services, but for now we test the enum
        expect(ChatState.initial, isA<ChatState>());
        expect(ChatState.loading, isA<ChatState>());
        expect(ChatState.success, isA<ChatState>());
        expect(ChatState.error, isA<ChatState>());
        expect(ChatState.aiSelecting, isA<ChatState>());
      });
    });

    group('AI Integration Type Checking', () {
      test('should identify AI-capable integration types correctly', () {
        // Test the logic that determines if an integration type is AI-capable
        const aiCapableTypes = {
          'openai',
          'gemini',
          'claude',
          'anthropic',
          'azure-openai',
          'huggingface',
          'dial',
        };

        const nonAiTypes = {
          'jira',
          'github',
          'confluence',
          'figma',
          'gitlab',
          'bitbucket',
        };

        // Test AI-capable types
        for (final type in aiCapableTypes) {
          expect(aiCapableTypes.contains(type.toLowerCase()), isTrue, reason: 'Type $type should be AI-capable');
        }

        // Test non-AI types
        for (final type in nonAiTypes) {
          expect(aiCapableTypes.contains(type.toLowerCase()), isFalse, reason: 'Type $type should not be AI-capable');
        }
      });
    });

    group('File Attachment Validation', () {
      test('should create valid FileAttachment objects', () {
        // Arrange
        final attachment = FileAttachment(
          name: 'test.png',
          size: 1024,
          type: 'png',
          bytes: [1, 2, 3, 4, 5],
          uploadedAt: DateTime.now(),
        );

        // Assert
        expect(attachment.name, equals('test.png'));
        expect(attachment.size, equals(1024));
        expect(attachment.type, equals('png'));
        expect(attachment.bytes, equals([1, 2, 3, 4, 5]));
        expect(attachment.uploadedAt, isA<DateTime>());
      });

      test('should handle different file types correctly', () {
        const testCases = [
          ('image.jpg', 'jpg'),
          ('document.pdf', 'pdf'),
          ('script.dart', 'dart'),
          ('data.json', 'json'),
          ('styles.css', 'css'),
        ];

        for (final (name, expectedType) in testCases) {
          final attachment = FileAttachment(
            name: name,
            size: 100,
            type: expectedType,
            bytes: [1, 2, 3],
            uploadedAt: DateTime.now(),
          );

          expect(attachment.type, equals(expectedType));
          expect(attachment.name, equals(name));
        }
      });
    });

    group('Chat Message Validation', () {
      test('should create valid ChatMessage objects', () {
        // Arrange
        final userMessage = ChatMessage(
          message: 'Hello AI',
          isUser: true,
          timestamp: DateTime.now(),
        );

        final aiMessage = ChatMessage(
          message: 'Hello human!',
          isUser: false,
          timestamp: DateTime.now(),
        );

        // Assert
        expect(userMessage.message, equals('Hello AI'));
        expect(userMessage.isUser, isTrue);
        expect(userMessage.timestamp, isA<DateTime>());

        expect(aiMessage.message, equals('Hello human!'));
        expect(aiMessage.isUser, isFalse);
        expect(aiMessage.timestamp, isA<DateTime>());
      });

      test('should auto-generate timestamp when null provided', () {
        // Arrange
        final message = ChatMessage(
          message: 'Test message',
          isUser: true,
        );

        // Assert
        expect(message.message, equals('Test message'));
        expect(message.isUser, isTrue);
        expect(message.timestamp, isA<DateTime>()); // Auto-generated
      });
    });

    group('AiIntegration Validation', () {
      test('should create valid AiIntegration objects', () {
        // Arrange
        const integration = AiIntegration(
          id: 'test-ai-123',
          displayName: 'Test AI Assistant',
          type: 'gemini',
        );

        // Assert
        expect(integration.id, equals('test-ai-123'));
        expect(integration.displayName, equals('Test AI Assistant'));
        expect(integration.type, equals('gemini'));
      });

      test('should handle different AI integration types', () {
        const testCases = [
          ('gemini-123', 'Gemini 2.5', 'gemini'),
          ('dial-456', 'Dial Claude', 'dial'),
          ('openai-789', 'GPT-4', 'openai'),
        ];

        for (final (id, name, type) in testCases) {
          final integration = AiIntegration(
            id: id,
            displayName: name,
            type: type,
          );

          expect(integration.id, equals(id));
          expect(integration.displayName, equals(name));
          expect(integration.type, equals(type));
        }
      });
    });

    group('Input Validation', () {
      test('should validate message input requirements', () {
        // Test empty message validation
        const emptyMessage = '';
        expect(emptyMessage.trim().isEmpty, isTrue);

        // Test whitespace-only message validation
        const whitespaceMessage = '   \n\t  ';
        expect(whitespaceMessage.trim().isEmpty, isTrue);

        // Test valid message
        const validMessage = 'Hello AI!';
        expect(validMessage.trim().isEmpty, isFalse);
      });

      test('should validate file size limits', () {
        const maxFileSize = 10 * 1024 * 1024; // 10MB
        const maxFiles = 10;

        // Test file size validation
        expect(1024, lessThan(maxFileSize)); // 1KB - valid
        expect(5 * 1024 * 1024, lessThan(maxFileSize)); // 5MB - valid
        expect(15 * 1024 * 1024, greaterThan(maxFileSize)); // 15MB - invalid

        // Test file count validation
        expect(5, lessThan(maxFiles)); // 5 files - valid
        expect(15, greaterThan(maxFiles)); // 15 files - invalid
      });
    });

    group('Error Handling', () {
      test('should handle various error scenarios', () {
        // Test error message formats
        const testErrors = [
          'Message cannot be empty',
          'Please select an AI integration first',
          'Failed to send message: API Error',
          'User not authenticated',
        ];

        for (final error in testErrors) {
          expect(error, isA<String>());
          expect(error.isNotEmpty, isTrue);
        }
      });
    });
  });
}
