// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Web-specific clipboard implementation using HTML5 Clipboard API
class WebClipboard {
  /// Check if the Clipboard API is available
  static bool get isAvailable {
    return html.window.navigator.clipboard != null;
  }

  /// Request clipboard permissions
  static Future<bool> requestPermissions() async {
    if (!isAvailable) return false;

    try {
      // Request clipboard-read permission if available
      final permissions = html.window.navigator.permissions;
      if (permissions != null) {
        final permission = await permissions.query({'name': 'clipboard-read'});

        if (kDebugMode) {
          debugPrint('🔐 Clipboard permission state: ${permission.state}');
        }
        return permission.state == 'granted' || permission.state == 'prompt';
      }

      return true; // If permissions API not available, assume it's OK
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Clipboard permission check failed: $e');
      }
      return true; // Fallback to trying anyway
    }
  }

  /// Read clipboard content - simplified to focus on text only
  /// Image clipboard support is handled by JavaScript interop in clipboard_js.dart
  static Future<ClipboardContent?> readClipboard() async {
    if (!isAvailable) {
      if (kDebugMode) {
        debugPrint('❌ Clipboard API not available');
      }
      return null;
    }

    try {
      if (kDebugMode) {
        debugPrint('🔧 Reading clipboard content...');
      }

      // Try to read text first (most reliable)
      try {
        final text = await html.window.navigator.clipboard!.readText();
        if (text.isNotEmpty) {
          if (kDebugMode) {
            debugPrint('📝 Found text content: ${text.length} chars');
          }
          return ClipboardContent.text(text);
        }
      } catch (textError) {
        if (kDebugMode) {
          debugPrint('⚠️ Text clipboard read failed: $textError');
        }
      }

      // Note: Advanced clipboard API for images is not well supported in Dart
      // The dart:html API doesn't fully expose the modern Clipboard API
      // For now, we'll focus on text-only clipboard support
      if (kDebugMode) {
        debugPrint('💡 Image clipboard reading not supported in current Dart web implementation');
        debugPrint('💡 Consider using file picker for image uploads');
      }

      if (kDebugMode) {
        debugPrint('🔍 No valid content found in clipboard');
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to read clipboard: $e');
        debugPrint('💡 User may need to grant clipboard permissions or use Ctrl+V during focus');
      }
      return null;
    }
  }

  /// Create a fake image attachment for testing purposes
  /// This simulates what would happen when image clipboard is supported
  static ClipboardContent createTestImageAttachment() {
    final now = DateTime.now();
    final filename = 'test_image_${now.millisecondsSinceEpoch}.png';

    // Create a simple 1x1 pixel PNG as test data
    final testBytes = [
      137, 80, 78, 71, 13, 10, 26, 10, // PNG signature
      0, 0, 0, 13, 73, 72, 68, 82, // IHDR chunk
      0, 0, 0, 1, 0, 0, 0, 1, 8, 2, 0, 0, 0, // 1x1 image, RGB
      144, 119, 83, 222, // CRC
      0, 0, 0, 12, 73, 68, 65, 84, // IDAT chunk
      8, 215, 99, 248, 15, 0, 0, 1, 0, 1, // minimal image data
      93, 18, 230, 60, // CRC
      0, 0, 0, 0, 73, 69, 78, 68, 174, 66, 96, 130 // IEND chunk
    ];

    final attachment = FileAttachment(
      name: filename,
      size: testBytes.length,
      type: 'png',
      bytes: testBytes,
      uploadedAt: now,
    );

    return ClipboardContent.image(attachment);
  }
}

/// Represents clipboard content with its type
class ClipboardContent {
  final ClipboardContentType type;
  final dynamic content;

  const ClipboardContent._(this.type, this.content);

  factory ClipboardContent.image(FileAttachment attachment) {
    return ClipboardContent._(ClipboardContentType.image, attachment);
  }

  factory ClipboardContent.text(String text) {
    return ClipboardContent._(ClipboardContentType.text, text);
  }

  bool get isImage => type == ClipboardContentType.image;
  bool get isText => type == ClipboardContentType.text;

  FileAttachment? get asImage => isImage ? content as FileAttachment : null;
  String? get asText => isText ? content as String : null;
}

enum ClipboardContentType {
  image,
  text,
}
