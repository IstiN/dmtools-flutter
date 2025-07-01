import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:js' as js;

/// Get OAuth parameters from JavaScript window.oauthParams
Map<String, String>? getOAuthParamsFromWindow() {
  try {
    // Check if OAuth params are ready
    final oauthReady = js.context['oauthParamsReady'];
    final jsParams = js.context['oauthParams'];

    if (kDebugMode) {
      print('🔍 OAuth ready flag: $oauthReady');
      print('🔍 OAuth params object: ${jsParams != null ? 'present' : 'null'}');
    }

    if (jsParams == null) return null;

    final params = <String, String>{};

    // Convert JS object to Dart map
    if (jsParams['code'] != null) {
      params['code'] = jsParams['code'].toString();
    }

    if (jsParams['state'] != null) {
      params['state'] = jsParams['state'].toString();
    }

    if (jsParams['error'] != null) {
      params['error'] = jsParams['error'].toString();
    }

    if (kDebugMode) {
      print('🔍 OAuth params from window: $params');
    }

    return params.isNotEmpty ? params : null;
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error reading OAuth params from window: $e');
    }
    return null;
  }
}

/// Clear OAuth parameters from window
void clearOAuthParamsFromWindow() {
  try {
    js.context.deleteProperty('oauthParams');
    if (kDebugMode) {
      print('🧹 Cleared OAuth params from window');
    }
  } catch (e) {
    if (kDebugMode) {
      print('❌ Error clearing OAuth params: $e');
    }
  }
}

/// Clean up OAuth callback URL parameters for web platform
void cleanupOAuthUrl() {
  // Since we're now using index.html for OAuth callbacks,
  // we don't need to clean up specific callback URLs
  // The JavaScript in index.html already handles URL cleanup

  if (kDebugMode) {
    print('🔧 OAuth URL cleanup completed by JavaScript in index.html');
  }
}
