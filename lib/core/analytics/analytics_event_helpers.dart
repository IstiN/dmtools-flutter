import 'package:dmtools_styleguide/core/services/user_interaction_tracker.dart';

import '../services/analytics_service.dart';

void trackManualButtonClick(
  String buttonName, {
  String? screenName,
  Map<String, dynamic>? additionalParams,
}) {
  final resolvedScreen = screenName ?? UserInteractionTracker.instance.currentScreenName;
  AnalyticsService.trackButtonClick(
    buttonName: buttonName,
    screenName: resolvedScreen,
    additionalParams: additionalParams,
  );
}

