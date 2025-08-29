import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

// Conditional imports for clipboard handling
import 'clipboard_web.dart' if (dart.library.io) 'clipboard_stub.dart';
import 'clipboard_js.dart' if (dart.library.io) 'clipboard_stub.dart';

/// Service for handling file operations including file picking and clipboard
class FileService {
  static const List<String> supportedImageTypes = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
  static const List<String> supportedDocumentTypes = ['pdf', 'doc', 'docx', 'txt', 'rtf'];
  static const List<String> supportedCodeTypes = ['dart', 'js', 'ts', 'html', 'css', 'json', 'yaml', 'xml'];

  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const int maxFiles = 10;

  /// Pick files from the device
  Future<List<FileAttachment>?> pickFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    bool allowMultiple = true,
  }) async {
    try {
      if (kDebugMode) {
        print('🔧 FileService: Starting file picker...');
      }

      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
        allowMultiple: allowMultiple,
        withData: true, // We need the file bytes
      );

      if (result == null || result.files.isEmpty) {
        if (kDebugMode) {
          print('🔧 FileService: No files selected');
        }
        return null;
      }

      final attachments = <FileAttachment>[];

      for (final file in result.files) {
        if (file.bytes == null) {
          if (kDebugMode) {
            print('⚠️ FileService: File ${file.name} has no bytes, skipping');
          }
          continue;
        }

        // Validate file size
        if (file.size > maxFileSize) {
          if (kDebugMode) {
            print('⚠️ FileService: File ${file.name} exceeds max size (${file.size} > $maxFileSize)');
          }
          throw Exception('File ${file.name} is too large. Maximum size is ${_formatFileSize(maxFileSize)}');
        }

        // Get file extension
        final extension = file.extension ?? _getExtensionFromName(file.name);

        final attachment = FileAttachment(
          name: file.name,
          size: file.size,
          type: extension,
          bytes: file.bytes!,
          uploadedAt: DateTime.now(),
        );

        attachments.add(attachment);

        if (kDebugMode) {
          print('✅ FileService: Added file ${file.name} (${_formatFileSize(file.size)})');
        }
      }

      if (attachments.length > maxFiles) {
        throw Exception('Too many files selected. Maximum is $maxFiles files');
      }

      if (kDebugMode) {
        print('✅ FileService: Successfully picked ${attachments.length} files');
      }

      return attachments;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FileService: Error picking files: $e');
      }
      rethrow;
    }
  }

  /// Pick only image files
  Future<List<FileAttachment>?> pickImages({bool allowMultiple = true}) async {
    return pickFiles(
      type: FileType.image,
      allowMultiple: allowMultiple,
    );
  }

  /// Pick only document files
  Future<List<FileAttachment>?> pickDocuments({bool allowMultiple = true}) async {
    return pickFiles(
      allowedExtensions: [...supportedDocumentTypes, ...supportedCodeTypes],
      allowMultiple: allowMultiple,
    );
  }

  /// Check clipboard for image content and convert to FileAttachment
  Future<FileAttachment?> getClipboardImage() async {
    try {
      if (kDebugMode) {
        print('🔧 FileService: Checking clipboard for images...');
      }

      // Try to get image from clipboard using pasteboard
      if (kIsWeb) {
        // For web, we'll use a different approach
        return await _getClipboardImageWeb();
      } else {
        // For desktop/mobile platforms
        return await _getClipboardImageNative();
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ FileService: Error getting clipboard image: $e');
      }
      return null;
    }
  }

  /// Handle paste event (keyboard shortcut Ctrl+V / Cmd+V)
  /// Returns a Map with 'type' ('file' or 'text') and 'content' keys
  Future<Map<String, dynamic>?> handlePasteEvent() async {
    try {
      if (kDebugMode) {
        print('🔧 FileService: Handling paste event...');
      }

      // For web, we DON'T manually read clipboard - we rely on paste events only!
      // The JavaScript paste listener handles everything automatically
      if (kIsWeb) {
        if (kDebugMode) {
          print('🔧 FileService: Web platform detected - paste events handled by JavaScript listener');
          print('💡 FileService: No manual clipboard reading needed - paste events work automatically');
        }
        // Return null here - paste events are handled by the automatic listener
        return null;
      }

      // For non-web platforms, use native clipboard
      try {
        final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
        if (clipboardData?.text?.isNotEmpty == true) {
          final text = clipboardData!.text!;

          if (kDebugMode) {
            print('✅ FileService: Found text in native clipboard (${text.length} chars)');
          }

          return {
            'type': 'text',
            'content': text,
          };
        }
      } catch (nativeError) {
        if (kDebugMode) {
          print('⚠️ FileService: Native clipboard failed: $nativeError');
        }
      }

      // For non-web platforms, try to get image
      if (!kIsWeb) {
        try {
          final clipboardImage = await getClipboardImage();
          if (clipboardImage != null) {
            if (kDebugMode) {
              print('✅ FileService: Successfully pasted image from clipboard');
            }
            return {
              'type': 'file',
              'content': clipboardImage,
            };
          }
        } catch (imageError) {
          if (kDebugMode) {
            print('⚠️ FileService: Image clipboard failed: $imageError');
          }
        }
      }

      if (kDebugMode) {
        print('🔧 FileService: No valid content found in clipboard');
        if (kIsWeb) {
          print('💡 FileService: Web clipboard access is limited by browser security');
          print('💡 FileService: Try copying content and immediately pressing Ctrl+V');
          print('💡 FileService: For images, use the file picker button instead');
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FileService: Error handling paste event: $e');
      }
      return null;
    }
  }

  /// Get clipboard image for native platforms (desktop/mobile)
  Future<FileAttachment?> _getClipboardImageNative() async {
    final imageBytes = await Pasteboard.image;

    if (imageBytes != null && imageBytes.isNotEmpty) {
      final now = DateTime.now();
      final filename = 'clipboard_image_${now.millisecondsSinceEpoch}.png';

      final attachment = FileAttachment(
        name: filename,
        size: imageBytes.length,
        type: 'png',
        bytes: imageBytes,
        uploadedAt: now,
      );

      if (kDebugMode) {
        print('✅ FileService: Found clipboard image (${_formatFileSize(imageBytes.length)})');
      }

      return attachment;
    }

    return null;
  }

  /// Get clipboard image for web platform
  /// Note: Web browsers have limited clipboard API access for images
  /// This is a simplified implementation that falls back to text
  Future<FileAttachment?> _getClipboardImageWeb() async {
    try {
      if (kDebugMode) {
        print('🔧 FileService: Attempting to read clipboard on web...');
        print('⚠️ FileService: Web clipboard image access is limited by browser security');
        print('💡 FileService: Consider using file picker instead for images');
      }

      // For web, the Clipboard API for images requires user permission and
      // is not reliably supported across all browsers
      // Fall back to text content for now

      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

      if (clipboardData?.text?.isNotEmpty == true) {
        final text = clipboardData!.text!;

        if (kDebugMode) {
          print('🔧 FileService: Found text in clipboard (${text.length} chars)');
          print('📝 FileService: Creating text file (image clipboard not available on web)');
        }

        // Create a text file from clipboard content
        final textBytes = text.codeUnits;

        final attachment = FileAttachment(
          name: 'clipboard_text.txt',
          size: textBytes.length,
          type: 'txt',
          bytes: textBytes,
          uploadedAt: DateTime.now(),
        );

        if (kDebugMode) {
          print('✅ FileService: Created text attachment from clipboard');
        }

        return attachment;
      }

      if (kDebugMode) {
        print('🔧 FileService: No content found in clipboard');
      }

      return null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ FileService: Error reading web clipboard: $e');
      }
      return null;
    }
  }

  /// Get file extension from filename
  String _getExtensionFromName(String filename) {
    final lastDot = filename.lastIndexOf('.');
    if (lastDot != -1 && lastDot < filename.length - 1) {
      return filename.substring(lastDot + 1).toLowerCase();
    }
    return 'unknown';
  }

  /// Format file size in human readable format
  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// Validate if file type is supported
  bool isFileTypeSupported(String extension) {
    final ext = extension.toLowerCase();
    return supportedImageTypes.contains(ext) ||
        supportedDocumentTypes.contains(ext) ||
        supportedCodeTypes.contains(ext);
  }

  /// Get file category for display purposes
  String getFileCategory(String extension) {
    final ext = extension.toLowerCase();
    if (supportedImageTypes.contains(ext)) return 'Image';
    if (supportedDocumentTypes.contains(ext)) return 'Document';
    if (supportedCodeTypes.contains(ext)) return 'Code';
    return 'File';
  }

  /// Create a FileAttachment from raw data (useful for testing)
  FileAttachment createAttachment({
    required String name,
    required List<int> bytes,
    String? type,
  }) {
    final extension = type ?? _getExtensionFromName(name);

    return FileAttachment(
      name: name,
      size: bytes.length,
      type: extension,
      bytes: bytes,
      uploadedAt: DateTime.now(),
    );
  }
}
