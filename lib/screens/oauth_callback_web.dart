// ignore: avoid_web_libraries_in_flutter
import 'package:web/web.dart' as web;
import 'package:flutter/foundation.dart';

/// Clean up OAuth callback URL parameters for web platform
void cleanupOAuthUrl() {
  final currentUrl = web.window.location.href;
  final pathname = web.window.location.pathname;

  // Check if we're on an OAuth callback URL with parameters
  if (pathname.contains('/auth/callback')) {
    // Extract the base origin (e.g., http://localhost:8081)
    final origin = web.window.location.origin;

    // Replace the entire URL with a clean dashboard URL
    // This removes both query parameters (?code=...&state=...) and fixes the fragment
    web.window.history.replaceState(null, '', '$origin/#/dashboard');

    // Debug logging
    if (kDebugMode) {
      debugPrint('🔧 OAuth URL cleanup:');
      debugPrint('   From: $currentUrl');
      debugPrint('   To: $origin/#/dashboard');
    }
  }
}
