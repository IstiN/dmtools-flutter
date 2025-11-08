// Stub implementation for non-web platforms
import 'dart:async';
import 'package:flutter/foundation.dart';

class WebPasteService {
  /// Set up paste listener (stub - returns empty stream)
  static Stream<Map<String, dynamic>> setupPasteListener() {
    if (kDebugMode) {
      debugPrint('📋 WebPasteService: Stub implementation - no paste functionality on this platform');
    }
    return const Stream.empty();
  }

  /// Clean up resources (stub - no-op)
  static void cleanup() {
    // No-op for stub
  }
}
