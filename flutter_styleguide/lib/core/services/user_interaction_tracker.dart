import 'package:flutter/widgets.dart';

import 'package:dmtools_styleguide/theme/app_dimensions.dart';

typedef ButtonInteractionCallback = void Function(ButtonInteractionEvent event);
typedef ScreenNameResolver = String? Function(BuildContext context);

/// Immutable data that describes a button interaction.
class ButtonInteractionEvent {
  const ButtonInteractionEvent({
    required this.buttonId,
    required this.label,
    required this.size,
    required this.timestamp,
    this.screenName,
    this.isDisabled = false,
    this.isLoading = false,
    this.testId,
    this.metadata,
  });

  final String buttonId;
  final String label;
  final ButtonSize size;
  final DateTime timestamp;
  final String? screenName;
  final bool isDisabled;
  final bool isLoading;
  final String? testId;
  final Map<String, dynamic>? metadata;
}

/// Centralized tracker that propagates user interaction events
/// from styleguide widgets to the host application.
class UserInteractionTracker {
  UserInteractionTracker._();

  static final UserInteractionTracker instance = UserInteractionTracker._();

  ButtonInteractionCallback? _buttonCallback;
  ScreenNameResolver? _screenResolver;
  String? _currentScreenName;

  String? get currentScreenName => _currentScreenName;

  /// Configure callbacks or screen name resolvers.
  void configure({ButtonInteractionCallback? onButtonInteraction, ScreenNameResolver? screenNameResolver}) {
    if (onButtonInteraction != null) {
      _buttonCallback = onButtonInteraction;
    }
    if (screenNameResolver != null) {
      _screenResolver = screenNameResolver;
    }
  }

  /// Update the name of the current screen (typically from route observers).
  void setCurrentScreen(String? screenName) {
    _currentScreenName = screenName;
  }

  /// Track a button interaction and notify any configured listeners.
  void trackButtonInteraction({
    required BuildContext context,
    required String label,
    required ButtonSize size,
    String? analyticsId,
    String? screenNameOverride,
    Map<String, dynamic>? metadata,
    String? testId,
    bool isDisabled = false,
    bool isLoading = false,
  }) {
    if (_buttonCallback == null) {
      return;
    }

    final resolvedScreen = screenNameOverride ?? _currentScreenName ?? _screenResolver?.call(context);
    final buttonId = _resolveButtonId(analyticsId, label);
    final event = ButtonInteractionEvent(
      buttonId: buttonId,
      label: label,
      size: size,
      screenName: resolvedScreen,
      isDisabled: isDisabled,
      isLoading: isLoading,
      testId: testId,
      metadata: metadata == null ? null : Map<String, dynamic>.unmodifiable(metadata),
      timestamp: DateTime.now(),
    );
    _buttonCallback?.call(event);
  }

  String _resolveButtonId(String? analyticsId, String label) {
    final source = (analyticsId != null && analyticsId.trim().isNotEmpty) ? analyticsId : label;
    final normalized = source
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp('_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
    return normalized.isEmpty ? 'button' : normalized;
  }
}
