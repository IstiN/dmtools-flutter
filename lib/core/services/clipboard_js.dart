// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import 'dart:js_util' as js_util;
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// JavaScript interop clipboard service for full HTML5 Clipboard API support
class JSClipboardService {
  static bool _listenerSetup = false;
  static StreamController<ClipboardContent>? _pasteController;

  /// Check if the JavaScript clipboard API is available
  static bool get isAvailable {
    try {
      if (!js.context.hasProperty('ClipboardAPI')) {
        if (kDebugMode) {
          debugPrint('⚠️ ClipboardAPI object not found in JavaScript context');
        }
        return false;
      }

      final clipboardAPI = js.context['ClipboardAPI'];
      if (clipboardAPI == null) {
        if (kDebugMode) {
          debugPrint('⚠️ ClipboardAPI is null');
        }
        return false;
      }

      final isAvailableFunc = clipboardAPI['isAvailable'];
      if (isAvailableFunc == null) {
        if (kDebugMode) {
          debugPrint('⚠️ isAvailable function not found');
        }
        return false;
      }

      final result = isAvailableFunc.apply([]);
      return result == true;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ JavaScript ClipboardAPI not available: $e');
      }
      return false;
    }
  }

  /// Request clipboard permissions via JavaScript
  static Future<bool> requestPermissions() async {
    if (!isAvailable) return false;

    try {
      final completer = Completer<bool>();

      final clipboardAPI = js.context['ClipboardAPI'];
      final requestPermissionsFunc = clipboardAPI['requestPermissions'];

      if (requestPermissionsFunc == null) {
        if (kDebugMode) {
          debugPrint('⚠️ requestPermissions function not found');
        }
        return false;
      }

      // Call the JavaScript function and handle the promise
      final jsPromise = requestPermissionsFunc.apply([]);

      // Convert JavaScript Promise to Dart Future
      final dartPromise = js_util.promiseToFuture(jsPromise);
      dartPromise.then((result) {
        completer.complete(result == true);
      }).catchError((error) {
        if (kDebugMode) {
          debugPrint('⚠️ Permission request failed: $error');
        }
        completer.complete(false);
      });

      return await completer.future;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Permission request error: $e');
      }
      return false;
    }
  }

  /// Read clipboard content via JavaScript
  static Future<ClipboardContent?> readClipboard() async {
    if (!isAvailable) return null;

    try {
      final completer = Completer<ClipboardContent?>();

      final clipboardAPI = js.context['ClipboardAPI'];
      final readClipboardFunc = clipboardAPI['readClipboard'];

      if (readClipboardFunc == null) {
        if (kDebugMode) {
          debugPrint('⚠️ readClipboard function not found');
        }
        return null;
      }

      // Call the JavaScript function and handle the promise
      final jsPromise = readClipboardFunc.apply([]);

      // Convert JavaScript Promise to Dart Future
      final dartPromise = js_util.promiseToFuture(jsPromise);
      dartPromise.then((result) {
        if (result == null) {
          completer.complete(null);
          return;
        }

        // Convert JavaScript object to Dart Map
        final type = js_util.getProperty(result, 'type') as String;
        final content = js_util.getProperty(result, 'content');

        if (type == 'image') {
          final name = js_util.getProperty(content, 'name') as String? ?? 'clipboard_image';
          final size = js_util.getProperty(content, 'size') as int? ?? 0;
          final extension = js_util.getProperty(content, 'extension') as String? ?? 'png';
          final jsBytes = js_util.getProperty(content, 'bytes');

          // Convert JS array to Dart list
          final bytes = <int>[];
          final length = js_util.getProperty(jsBytes, 'length') as int;
          for (int i = 0; i < length; i++) {
            bytes.add(js_util.getProperty(jsBytes, i.toString()) as int);
          }

          final attachment = FileAttachment(
            name: name,
            size: size,
            type: extension,
            bytes: bytes,
            uploadedAt: DateTime.now(),
          );

          if (kDebugMode) {
            debugPrint('✅ JSClipboard: Created image attachment ${attachment.name}');
          }

          completer.complete(ClipboardContent.image(attachment));
        } else if (type == 'text') {
          final text = content as String;

          if (kDebugMode) {
            debugPrint('✅ JSClipboard: Found text content (${text.length} chars)');
          }

          completer.complete(ClipboardContent.text(text));
        } else {
          completer.complete(null);
        }
      }).catchError((error) {
        if (kDebugMode) {
          debugPrint('❌ JSClipboard read failed: $error');
        }
        completer.complete(null);
      });

      return await completer.future;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ JSClipboard error: $e');
      }
      return null;
    }
  }

  /// Set up automatic paste event handling
  static Stream<ClipboardContent> setupPasteListener() {
    if (_listenerSetup && _pasteController != null) {
      return _pasteController!.stream;
    }

    if (!isAvailable) {
      if (kDebugMode) {
        debugPrint('⚠️ Cannot setup paste listener - JavaScript ClipboardAPI not available');
      }
      return const Stream.empty();
    }

    _pasteController = StreamController<ClipboardContent>.broadcast();

    try {
      // Create a Dart callback function for JavaScript to call
      js.context['dartPasteCallback'] = js.allowInterop((jsResult) {
        try {
          if (jsResult == null) return;

          final type = js_util.getProperty(jsResult, 'type');
          final content = js_util.getProperty(jsResult, 'content');

          if (type == 'image' && content != null) {
            try {
              final name =
                  js_util.getProperty(content, 'name') ?? 'pasted_image_${DateTime.now().millisecondsSinceEpoch}';
              final size = js_util.getProperty(content, 'size') ?? 0;
              final extension = js_util.getProperty(content, 'extension') ?? 'png';
              final jsBytes = js_util.getProperty(content, 'bytes');

              if (jsBytes != null) {
                // Convert JS array to Dart list
                final bytes = <int>[];
                final length = js_util.getProperty(jsBytes, 'length') as int? ?? 0;
                for (int i = 0; i < length; i++) {
                  final byte = js_util.getProperty(jsBytes, i.toString());
                  if (byte != null) {
                    bytes.add(byte as int);
                  }
                }

                if (bytes.isNotEmpty) {
                  final attachment = FileAttachment(
                    name: name.toString(),
                    size: (size as num).toInt(),
                    type: extension.toString(),
                    bytes: bytes,
                    uploadedAt: DateTime.now(),
                  );

                  if (kDebugMode) {
                    debugPrint('🖼️ Paste event: Image ${attachment.name} (${attachment.size} bytes)');
                  }

                  _pasteController?.add(ClipboardContent.image(attachment));
                } else {
                  if (kDebugMode) {
                    debugPrint('⚠️ No bytes found in image data');
                  }
                }
              } else {
                if (kDebugMode) {
                  debugPrint('⚠️ No bytes array found in content');
                }
              }
            } catch (imageProcessingError) {
              if (kDebugMode) {
                debugPrint('❌ Image processing error: $imageProcessingError');
              }
            }
          } else if (type == 'text') {
            final text = content as String;

            if (kDebugMode) {
              debugPrint('📝 Paste event: Text (${text.length} chars)');
            }

            _pasteController?.add(ClipboardContent.text(text));
          }
        } catch (e) {
          if (kDebugMode) {
            debugPrint('❌ Paste callback error: $e');
          }
        }
      });

      // Setup the JavaScript paste listener
      final clipboardAPI = js.context['ClipboardAPI'];
      final setupPasteListenerFunc = clipboardAPI['setupPasteListener'];

      if (setupPasteListenerFunc != null) {
        setupPasteListenerFunc.apply([js.context['dartPasteCallback']]);
      } else {
        if (kDebugMode) {
          debugPrint('⚠️ setupPasteListener function not found');
        }
      }

      _listenerSetup = true;

      if (kDebugMode) {
        debugPrint('✅ JavaScript paste listener setup complete');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Failed to setup paste listener: $e');
      }
      _pasteController?.close();
      _pasteController = null;
    }

    return _pasteController?.stream ?? const Stream.empty();
  }

  /// Clean up paste listener
  static void cleanup() {
    try {
      if (js.context.hasProperty('dartPasteCallback')) {
        js.context.deleteProperty('dartPasteCallback');
      }
      _pasteController?.close();
      _pasteController = null;
      _listenerSetup = false;

      if (kDebugMode) {
        debugPrint('🧹 JavaScript clipboard cleanup complete');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Clipboard cleanup error: $e');
      }
    }
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
