// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter

import 'package:flutter/foundation.dart';
import 'dart:html' as html;

/// Detects if the current platform is Safari when running on the web.
bool get isSafariOnWeb {
  if (!kIsWeb) {
    return false;
  }
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('safari') && !userAgent.contains('chrome');
}
