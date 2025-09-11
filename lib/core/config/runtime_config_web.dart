// Web implementation for JavaScript configuration access
// This file is used only on web platforms where dart:js is available

// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;

/// Get JavaScript configuration from window.dmtoolsConfig
/// Returns the configuration object if available, null otherwise
dynamic getJsConfig() {
  try {
    return js.context['dmtoolsConfig'];
  } catch (e) {
    // Return null if there's any error accessing JS context
    return null;
  }
}
