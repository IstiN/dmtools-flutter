import 'package:flutter/material.dart';

/// App-wide dimensions and spacing constants
/// Use these constants instead of hardcoding values throughout the app
class AppDimensions {
  // Spacing
  static const double spacingXxs = 4.0;
  static const double spacingXs = 8.0;
  static const double spacingS = 12.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // Border radius
  static const double radiusXs = 4.0;
  static const double radiusS = 6.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXl = 16.0;
  static const double radiusCircular = 100.0;

  // Border width
  static const double borderWidthThin = 1.0;
  static const double borderWidthRegular = 1.5;
  static const double borderWidthThick = 2.0;

  // Icon sizes
  static const double iconSizeXs = 14.0;
  static const double iconSizeS = 16.0;
  static const double iconSizeM = 20.0;
  static const double iconSizeL = 24.0;
  static const double iconSizeXl = 32.0;

  // Button sizes
  static const Map<ButtonSize, EdgeInsets> buttonPadding = {
    ButtonSize.small: EdgeInsets.symmetric(horizontal: 12.8, vertical: 6.4),
    ButtonSize.medium: EdgeInsets.symmetric(horizontal: 20.0, vertical: 9.6),
    ButtonSize.large: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  };

  static const Map<ButtonSize, double> buttonFontSize = {
    ButtonSize.small: 13.6,
    ButtonSize.medium: 15.2,
    ButtonSize.large: 16.0,
  };

  static const Map<ButtonSize, double> buttonIconSize = {
    ButtonSize.small: 14.0,
    ButtonSize.medium: 16.0,
    ButtonSize.large: 18.0,
  };

  // Card and container padding
  static const EdgeInsets cardPaddingS = EdgeInsets.all(spacingS);
  static const EdgeInsets cardPaddingM = EdgeInsets.all(spacingM);
  static const EdgeInsets cardPaddingL = EdgeInsets.all(spacingL);

  // Form element dimensions
  static const double inputHeight = 40.0;
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(horizontal: spacingM, vertical: spacingS);

  // Animation durations
  static const Duration animationDurationFast = Duration(milliseconds: 150);
  static const Duration animationDurationMedium = Duration(milliseconds: 250);
  static const Duration animationDurationSlow = Duration(milliseconds: 350);

  // OAuth Button dimensions
  static const double oauthButtonHeight = 56.0;
  static const EdgeInsets oauthButtonPadding = EdgeInsets.symmetric(horizontal: spacingL, vertical: spacingM);
  static const double oauthIconSize = 22.0;
  static const double oauthButtonFontSize = 16.0;

  // Dialog dimensions
  static const double dialogWidth = 480.0;
  static const EdgeInsets dialogPadding = EdgeInsets.all(spacingXl);

  // Header dimensions
  static const double headerMinHeight = 56.0;
  static const double headerBorderOpacity = 0.3;
  static const double loadingIndicatorSize = 20.0;
  static const double loadingIndicatorStrokeWidth = 2.0;
  static const double overflowMenuIconSize = 20.0;
}

/// Button size enum for use with AppDimensions
enum ButtonSize {
  small,
  medium,
  large,
}
