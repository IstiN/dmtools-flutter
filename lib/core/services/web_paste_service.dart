// Web-specific paste service
// This file is only imported on web platform to avoid CI/CD issues

import 'dart:async';
import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'clipboard_js.dart';

class WebPasteService {
  static Timer? _pasteCheckTimer;
  static StreamController<Map<String, dynamic>>? _controller;

  /// Set up paste listener with JavaScript integration
  static Stream<Map<String, dynamic>> setupPasteListener() {
    _controller = StreamController<Map<String, dynamic>>.broadcast();
    
    try {
      // Set up JavaScript paste listener first
      js.context.callMethod('eval', [
        '''
        if (window.ClipboardAPI && !window.pasteListenerSetup) {
          window.ClipboardAPI.setupPasteListener((data) => {
            console.log('📋 JS Callback received:', data.type);
            window.lastPastedContent = data;
            window.lastPastedTimestamp = Date.now();
          });
          window.pasteListenerSetup = true;
          console.log('✅ JavaScript paste listener initialized');
        }
        '''
      ]);

      // Poll for pasted content
      _pasteCheckTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        try {
          final lastContent = js.context['lastPastedContent'];
          final lastTimestamp = js.context['lastPastedTimestamp'];

          if (lastContent != null && lastTimestamp != null) {
            final timestamp = lastTimestamp as num;
            final now = DateTime.now().millisecondsSinceEpoch;

            // Only process if it's recent (within last 2 seconds)
            if (now - timestamp < 2000) {
              final data = _extractPasteData(lastContent);
              if (data != null) {
                _controller!.add(data);
              }

              // Clear the content to avoid reprocessing
              js.context['lastPastedContent'] = null;
              js.context['lastPastedTimestamp'] = null;
            }
          }
        } catch (e) {
          // Ignore polling errors
        }
      });

      if (kDebugMode) {
        print('✅ JavaScript paste polling setup complete');
      }
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ Failed to setup JavaScript paste listener: $e');
      }
    }

    return _controller!.stream;
  }

  /// Extract paste data from JavaScript object
  static Map<String, dynamic>? _extractPasteData(dynamic jsContent) {
    try {
      final type = js.context['lastPastedContent']?['type'];

      if (type == 'image') {
        final content = js.context['lastPastedContent']?['content'];
        final name = content?['name'] ?? 'pasted_image_${DateTime.now().millisecondsSinceEpoch}.png';
        final size = content?['size'] ?? 0;
        final extension = content?['extension'] ?? 'png';
        final jsBytes = content?['bytes'];

        if (jsBytes != null) {
          // Convert JS array to Dart list
          final bytes = <int>[];
          final length = jsBytes['length'] ?? 0;

          for (int i = 0; i < (length as num).toInt(); i++) {
            final byte = jsBytes[i];
            if (byte != null) {
              bytes.add((byte as num).toInt());
            }
          }

          return {
            'type': 'image',
            'content': {
              'name': name.toString(),
              'mimeType': 'image/$extension',
              'size': (size as num).toInt(),
              'bytes': bytes,
            }
          };
        }
      } else if (type == 'text') {
        final text = js.context['lastPastedContent']?['content'];
        if (text != null && text.toString().trim().isNotEmpty) {
          return {
            'type': 'text',
            'content': text.toString(),
          };
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error extracting paste data: $e');
      }
    }

    return null;
  }

  /// Clean up resources
  static void cleanup() {
    _pasteCheckTimer?.cancel();
    _controller?.close();
    JSClipboardService.cleanup();
    _pasteCheckTimer = null;
    _controller = null;
  }
}
