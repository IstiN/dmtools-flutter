import 'package:dmtools_styleguide/core/services/user_interaction_tracker.dart';

import '../services/analytics_service.dart';

class InteractionTrackerBinding {
  InteractionTrackerBinding._();

  static bool _configured = false;

  static void configure() {
    if (_configured) {
      return;
    }

    UserInteractionTracker.instance.configure(
      onButtonInteraction: (event) {
        final additionalParams = <String, dynamic>{
          'button_label': event.label,
          'button_size': event.size.name,
          'is_disabled': event.isDisabled,
          'is_loading': event.isLoading,
          if (event.testId != null) 'test_id': event.testId!,
          if (event.metadata != null) ...event.metadata!,
        };

        AnalyticsService.trackButtonClick(
          buttonName: event.buttonId,
          screenName: event.screenName,
          additionalParams: additionalParams,
        );
      },
    );

    _configured = true;
  }
}

