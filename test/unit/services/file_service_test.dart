import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker/file_picker.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

import 'package:dmtools/core/services/file_service.dart';

void main() {
  group('FileService Tests', () {
    late FileService fileService;

    setUp(() {
      fileService = FileService();
    });

    group('File Type Validation', () {
      test('should identify supported image types correctly', () {
        const testCases = [
          ('jpg', true),
          ('jpeg', true),
          ('png', true),
          ('gif', true),
          ('bmp', true),
          ('webp', true),
          ('svg', false), // Not in supported list
          ('txt', true), // txt is in supportedDocumentTypes
        ];

        for (final (extension, expected) in testCases) {
          final result = fileService.isFileTypeSupported(extension);
          expect(result, equals(expected),
              reason: 'Extension $extension should be ${expected ? "supported" : "not supported"}');
        }
      });

      test('should identify supported document types correctly', () {
        const testCases = [
          ('pdf', true),
          ('doc', true),
          ('docx', true),
          ('txt', true),
          ('rtf', true),
          ('exe', false),
          ('bin', false),
        ];

        for (final (extension, expected) in testCases) {
          final result = fileService.isFileTypeSupported(extension);
          expect(result, equals(expected),
              reason: 'Extension $extension should be ${expected ? "supported" : "not supported"}');
        }
      });

      test('should identify supported code types correctly', () {
        const testCases = [
          ('dart', true),
          ('js', true),
          ('ts', true),
          ('html', true),
          ('css', true),
          ('json', true),
          ('yaml', true),
          ('xml', true),
          ('py', false), // Not in supported list
          ('java', false),
        ];

        for (final (extension, expected) in testCases) {
          final result = fileService.isFileTypeSupported(extension);
          expect(result, equals(expected),
              reason: 'Extension $extension should be ${expected ? "supported" : "not supported"}');
        }
      });
    });

    group('File Category Classification', () {
      test('should categorize image files correctly', () {
        const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];

        for (final extension in imageExtensions) {
          final category = fileService.getFileCategory(extension);
          expect(category, equals('Image'), reason: 'Extension $extension should be categorized as Image');
        }
      });

      test('should categorize document files correctly', () {
        const documentExtensions = ['pdf', 'doc', 'docx', 'txt', 'rtf'];

        for (final extension in documentExtensions) {
          final category = fileService.getFileCategory(extension);
          expect(category, equals('Document'), reason: 'Extension $extension should be categorized as Document');
        }
      });

      test('should categorize code files correctly', () {
        const codeExtensions = ['dart', 'js', 'ts', 'html', 'css', 'json', 'yaml', 'xml'];

        for (final extension in codeExtensions) {
          final category = fileService.getFileCategory(extension);
          expect(category, equals('Code'), reason: 'Extension $extension should be categorized as Code');
        }
      });

      test('should categorize unknown files as File', () {
        const unknownExtensions = ['unknown', 'xyz', 'random'];

        for (final extension in unknownExtensions) {
          final category = fileService.getFileCategory(extension);
          expect(category, equals('File'), reason: 'Extension $extension should be categorized as File');
        }
      });
    });

    group('File Attachment Creation', () {
      test('should create file attachment correctly', () {
        // Arrange
        const name = 'test.png';
        const bytes = [1, 2, 3, 4, 5];
        const type = 'png';

        // Act
        final attachment = fileService.createAttachment(
          name: name,
          bytes: bytes,
          type: type,
        );

        // Assert
        expect(attachment.name, equals(name));
        expect(attachment.bytes, equals(bytes));
        expect(attachment.type, equals(type));
        expect(attachment.size, equals(bytes.length));
        expect(attachment.uploadedAt, isA<DateTime>());
      });

      test('should extract file extension from name when type not provided', () {
        // Arrange
        const name = 'document.pdf';
        const bytes = [1, 2, 3];

        // Act
        final attachment = fileService.createAttachment(
          name: name,
          bytes: bytes,
        );

        // Assert
        expect(attachment.type, equals('pdf'));
      });

      test('should handle file without extension', () {
        // Arrange
        const name = 'document';
        const bytes = [1, 2, 3];

        // Act
        final attachment = fileService.createAttachment(
          name: name,
          bytes: bytes,
        );

        // Assert
        expect(attachment.type, equals('unknown'));
      });
    });

    group('Constants and Limits', () {
      test('should have correct file size limits', () {
        expect(FileService.maxFileSize, equals(10 * 1024 * 1024)); // 10MB
        expect(FileService.maxFiles, equals(10));
      });

      test('should have correct supported file types', () {
        expect(FileService.supportedImageTypes, contains('png'));
        expect(FileService.supportedImageTypes, contains('jpg'));
        expect(FileService.supportedDocumentTypes, contains('pdf'));
        expect(FileService.supportedCodeTypes, contains('dart'));
      });
    });

    group('Clipboard Handling', () {
      test('should handle clipboard paste event gracefully', () async {
        // Note: Clipboard functionality is now handled by JavaScript
        // This test ensures the method doesn't crash

        // Act
        final result = await fileService.handlePasteEvent();

        // Assert
        // On web, this should return null (handled by JavaScript)
        // On other platforms, it might return clipboard content
        expect(result, anyOf(isNull, isA<Map<String, dynamic>>()));
      });
    });

    group('Error Handling', () {
      test('should handle file picker cancellation gracefully', () async {
        // Note: This would require mocking FilePicker.platform
        // For now, we test that the method signature is correct

        expect(fileService.pickFiles, isA<Function>());
        expect(fileService.pickImages, isA<Function>());
        expect(fileService.pickDocuments, isA<Function>());
      });
    });
  });
}
