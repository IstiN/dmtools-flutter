import 'package:flutter/foundation.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

/// Checks if the current platform is Safari on the web.
bool get isSafariOnWeb {
  if (!kIsWeb) {
    return false;
  }
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('safari') && !userAgent.contains('chrome');
}
