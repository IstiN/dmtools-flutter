import 'package:flutter/material.dart';
import 'responsive_breakpoints.dart';

/// A builder that provides responsive layout capabilities
/// Uses consistent breakpoints defined in ResponsiveBreakpoints
class ResponsiveBuilder extends StatelessWidget {
  /// Builder function for mobile layout (< 768px)
  final Widget Function(BuildContext context, BoxConstraints constraints)? mobile;

  /// Builder function for tablet layout (768px - 1200px)
  final Widget Function(BuildContext context, BoxConstraints constraints)? tablet;

  /// Builder function for desktop layout (>= 1200px)
  final Widget Function(BuildContext context, BoxConstraints constraints)? desktop;

  /// Builder function for wide desktop layout (>= 1600px)
  final Widget Function(BuildContext context, BoxConstraints constraints)? wideDesktop;

  /// Default builder used when specific breakpoint builder is not provided
  final Widget Function(BuildContext context, BoxConstraints constraints)? defaultBuilder;

  const ResponsiveBuilder({
    Key? key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.wideDesktop,
    this.defaultBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final screenSize = width.screenSize;

        switch (screenSize) {
          case ScreenSize.mobile:
            final builder = mobile ?? defaultBuilder;
            return builder != null ? builder(context, constraints) : _buildFallback(context, constraints);

          case ScreenSize.tablet:
            final builder = tablet ?? mobile ?? defaultBuilder;
            return builder != null ? builder(context, constraints) : _buildFallback(context, constraints);

          case ScreenSize.desktop:
            final builder = desktop ?? tablet ?? mobile ?? defaultBuilder;
            return builder != null ? builder(context, constraints) : _buildFallback(context, constraints);

          case ScreenSize.wideDesktop:
            final builder = wideDesktop ?? desktop ?? tablet ?? mobile ?? defaultBuilder;
            return builder != null ? builder(context, constraints) : _buildFallback(context, constraints);
        }
      },
    );
  }

  Widget _buildFallback(BuildContext context, BoxConstraints constraints) {
    return Container(
      color: Colors.red,
      child: const Center(
        child: Text(
          'ResponsiveBuilder: No builder provided',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

/// A simplified responsive builder for two-layout responsive design (mobile/desktop)
class SimpleResponsiveBuilder extends StatelessWidget {
  /// Builder for mobile/tablet layout (< desktop breakpoint)
  final Widget Function(BuildContext context, BoxConstraints constraints) mobile;

  /// Builder for desktop layout (>= desktop breakpoint)
  final Widget Function(BuildContext context, BoxConstraints constraints) desktop;

  /// Custom breakpoint (defaults to ResponsiveBreakpoints.mobile)
  final double? breakpoint;

  const SimpleResponsiveBuilder({
    required this.mobile,
    required this.desktop,
    this.breakpoint,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final threshold = breakpoint ?? ResponsiveBreakpoints.mobile;

        if (constraints.maxWidth >= threshold) {
          return desktop(context, constraints);
        } else {
          return mobile(context, constraints);
        }
      },
    );
  }
}

/// A widget that conditionally shows content based on screen size
class ResponsiveWidget extends StatelessWidget {
  /// Widget to show on mobile
  final Widget? mobile;

  /// Widget to show on tablet
  final Widget? tablet;

  /// Widget to show on desktop
  final Widget? desktop;

  /// Widget to show on wide desktop
  final Widget? wideDesktop;

  /// Default widget when no specific size widget is provided
  final Widget? defaultWidget;

  const ResponsiveWidget({
    this.mobile,
    this.tablet,
    this.desktop,
    this.wideDesktop,
    this.defaultWidget,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final screenSize = width.screenSize;

        switch (screenSize) {
          case ScreenSize.mobile:
            return mobile ?? defaultWidget ?? const SizedBox.shrink();

          case ScreenSize.tablet:
            return tablet ?? mobile ?? defaultWidget ?? const SizedBox.shrink();

          case ScreenSize.desktop:
            return desktop ?? tablet ?? mobile ?? defaultWidget ?? const SizedBox.shrink();

          case ScreenSize.wideDesktop:
            return wideDesktop ?? desktop ?? tablet ?? mobile ?? defaultWidget ?? const SizedBox.shrink();
        }
      },
    );
  }
}

/// Utility functions for responsive design
class ResponsiveUtils {
  /// Get current screen size from context
  static ScreenSize getScreenSize(BuildContext context) {
    return MediaQuery.of(context).size.width.screenSize;
  }

  /// Get current device type from context
  static DeviceType getDeviceType(BuildContext context) {
    return MediaQuery.of(context).size.width.deviceType;
  }

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width.isMobile;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width.isTablet;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width.isDesktop;
  }

  /// Check if current screen is wide
  static bool isWideScreen(BuildContext context) {
    return MediaQuery.of(context).size.width.isWideScreen;
  }

  /// Get grid column count based on current screen size
  static int getGridColumnCount(BuildContext context) {
    return MediaQuery.of(context).size.width.gridColumnCount;
  }
}
