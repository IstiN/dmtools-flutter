import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../utils/accessibility_utils.dart';

/// Mixin providing common accessibility functionality for widgets.
///
/// This mixin provides helper methods for:
/// - Building Semantics wrappers with consistent configuration
/// - Generating test identifiers and semantic labels
/// - Managing keyboard interactions
/// - Creating accessible widget variants
mixin AccessibilityMixin {
  /// Creates a Semantics widget for a button component.
  Widget buildButtonSemantics({
    required Widget child,
    required String label,
    required bool enabled,
    String? hint,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: true,
      enabled: enabled,
      focusable: true,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }

  /// Creates a Semantics widget for a text input component.
  Widget buildTextFieldSemantics({
    required Widget child,
    required String label,
    String? hint,
    String? value,
    bool obscureText = false,
    bool enabled = true,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      textField: true,
      obscured: obscureText,
      enabled: enabled,
      focusable: true,
      child: child,
    );
  }

  /// Creates a Semantics widget for a checkbox component.
  Widget buildCheckboxSemantics({
    required Widget child,
    required String label,
    required bool checked,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      checked: checked,
      enabled: enabled,
      focusable: true,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }

  /// Creates a Semantics widget for a radio button component.
  Widget buildRadioSemantics({
    required Widget child,
    required String label,
    required bool selected,
    bool enabled = true,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      enabled: enabled,
      focusable: true,
      onTap: enabled ? onTap : null,
      child: child,
    );
  }

  /// Creates a Semantics widget for a container/card component.
  Widget buildContainerSemantics({
    required Widget child,
    required String label,
    String? hint,
    bool focusable = false,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      container: true,
      focusable: focusable,
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a Semantics widget for an image component.
  Widget buildImageSemantics({
    required Widget child,
    required String label,
  }) {
    return Semantics(
      label: label,
      image: true,
      child: child,
    );
  }

  /// Creates a Semantics widget for a header component.
  Widget buildHeaderSemantics({
    required Widget child,
    required String label,
    bool header = true,
  }) {
    return Semantics(
      label: label,
      header: header,
      child: child,
    );
  }

  /// Creates a Semantics widget for a link component.
  Widget buildLinkSemantics({
    required Widget child,
    required String label,
    String? hint,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      link: true,
      focusable: true,
      onTap: onTap,
      child: child,
    );
  }

  /// Creates a Semantics widget for dynamic content (live region).
  Widget buildLiveRegionSemantics({
    required Widget child,
    required String label,
    bool liveRegion = true,
  }) {
    return Semantics(
      label: label,
      liveRegion: liveRegion,
      child: child,
    );
  }

  /// Wraps a widget with focus handling for keyboard navigation.
  Widget buildFocusableWidget({
    required Widget child,
    FocusNode? focusNode,
    bool autofocus = false,
    VoidCallback? onFocusChange,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: (hasFocus) {
        if (onFocusChange != null) {
          onFocusChange();
        }
      },
      child: child,
    );
  }

  /// Creates a ValueKey from a test identifier.
  Key createTestKey(String testId) {
    return ValueKey(testId);
  }

  /// Generates a test ID with automatic sanitization.
  String safeGenerateTestId(String componentType, [Map<String, dynamic>? params]) {
    return generateTestId(componentType, params);
  }

  /// Generates a semantic label with automatic formatting.
  String safeGenerateSemanticLabel(String componentType, String context) {
    return generateSemanticLabel(componentType, context);
  }
}

/// Extension on BuildContext for easy access to accessibility features.
extension AccessibilityContext on BuildContext {
  /// Announces a message to screen readers.
  Future<void> announceToScreenReader(String message) async {
    await SemanticsService.announce(message, TextDirection.ltr);
  }

  /// Checks if accessibility features are enabled.
  bool get isAccessibilityEnabled {
    return MediaQuery.of(this).accessibleNavigation;
  }

  /// Gets the current text scale factor for accessibility.
  double get accessibilityTextScale {
    return MediaQuery.of(this).textScaler.scale(1.0);
  }
}

