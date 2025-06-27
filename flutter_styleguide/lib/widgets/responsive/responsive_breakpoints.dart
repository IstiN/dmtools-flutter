/// Responsive breakpoints for the DMTools application
/// All screen size thresholds are defined here in one place
class ResponsiveBreakpoints {
  // Main breakpoints
  static const double mobile = 768.0;
  static const double tablet = 1024.0;
  static const double desktop = 1200.0;
  static const double wideDesktop = 1600.0;

  // Specific breakpoints used in existing code
  static const double showCircleInBanner = 600.0;
  static const double gridBreakpoint1 = 800.0;
  static const double gridBreakpoint2 = 1200.0;
  static const double wideScreenThreshold = 1200.0;

  // Chat module specific
  static const double chatMaxWidthBreakpoint = 0.7; // 70% of screen width

  // Agent card layout breakpoint
  static const double agentCardNarrowThreshold = 400.0;
}

/// Screen size categories for responsive design
enum ScreenSize {
  mobile,
  tablet,
  desktop,
  wideDesktop,
}

/// Device type for responsive design
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Grid column count based on screen size
enum GridSize {
  single, // 1 column
  double, // 2 columns
  triple, // 3 columns
  quad, // 4 columns
}

/// Extensions for responsive utilities
extension ResponsiveBreakpointsExt on double {
  /// Check if width is mobile size
  bool get isMobile => this < ResponsiveBreakpoints.mobile;

  /// Check if width is tablet size
  bool get isTablet => this >= ResponsiveBreakpoints.mobile && this < ResponsiveBreakpoints.desktop;

  /// Check if width is desktop size
  bool get isDesktop => this >= ResponsiveBreakpoints.desktop;

  /// Check if width is wide screen
  bool get isWideScreen => this >= ResponsiveBreakpoints.wideScreenThreshold;

  /// Get screen size category
  ScreenSize get screenSize {
    if (this < ResponsiveBreakpoints.mobile) return ScreenSize.mobile;
    if (this < ResponsiveBreakpoints.desktop) return ScreenSize.tablet;
    if (this < ResponsiveBreakpoints.wideDesktop) return ScreenSize.desktop;
    return ScreenSize.wideDesktop;
  }

  /// Get device type
  DeviceType get deviceType {
    if (this < ResponsiveBreakpoints.mobile) return DeviceType.mobile;
    if (this < ResponsiveBreakpoints.desktop) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Get grid column count for organisms page
  int get gridColumnCount {
    if (this > ResponsiveBreakpoints.gridBreakpoint2) return 3;
    if (this > ResponsiveBreakpoints.gridBreakpoint1) return 2;
    return 1;
  }
}
