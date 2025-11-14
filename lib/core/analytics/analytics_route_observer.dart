import 'package:dmtools_styleguide/core/services/user_interaction_tracker.dart';
import 'package:flutter/material.dart';

import '../services/analytics_service.dart';

class AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _trackRoute(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _trackRoute(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _trackRoute(newRoute);
  }

  void _trackRoute(Route<dynamic>? route) {
    final screenName = _extractScreenName(route);
    if (screenName == null || screenName.isEmpty) {
      return;
    }

    AnalyticsService.trackScreenView(screenName: screenName);
    UserInteractionTracker.instance.setCurrentScreen(screenName);
  }

  String? _extractScreenName(Route<dynamic>? route) {
    final settings = route?.settings;
    if (settings == null) {
      return null;
    }

    final explicitName = settings.name;
    if (explicitName != null && explicitName.isNotEmpty) {
      return explicitName;
    }

    final arguments = settings.arguments;
    if (arguments is Map && arguments['screenName'] is String) {
      return arguments['screenName'] as String;
    }

    if (arguments is Uri) {
      return arguments.path.isEmpty ? null : arguments.path;
    }

    return null;
  }
}

