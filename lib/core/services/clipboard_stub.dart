import 'package:flutter/foundation.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Stub implementation for non-web platforms
class WebClipboard {
  static bool get isAvailable => false;

  static Future<bool> requestPermissions() async {
    if (kDebugMode) {
      debugPrint('🔧 WebClipboard: Not available on this platform');
    }
    return false;
  }

  static Future<ClipboardContent?> readClipboard() async {
    if (kDebugMode) {
      debugPrint('🔧 WebClipboard: Not available on this platform');
    }
    return null;
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
