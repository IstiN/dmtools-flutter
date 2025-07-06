import 'package:flutter/material.dart';

// Interface for theme colors
abstract class ThemeColorSet {
  // Base Colors
  Color get bgColor;
  Color get cardBg;
  Color get textColor;
  Color get textSecondary;
  Color get textMuted;
  Color get borderColor;

  // Accent Colors
  Color get accentColor;
  Color get accentLight;
  Color get accentHover;
  Color get secondaryColor;

  // Button & Interaction Colors
  Color get buttonBg;
  Color get buttonHover;
  Color get hoverBg;
  Color get hoverBgLight;
  Color get hoverBgDark;
  Color get disabledDarkBg;
  Color get disabledDarkText;
  Color get disabledLightBg;
  Color get disabledLightText;

  // Feedback Colors
  Color get successColor;
  Color get warningColor;
  Color get dangerColor;
  Color get infoColor;

  // Input Colors
  Color get inputBg;
  Color get inputFocusBorder;

  // Banner Colors
  Color get bannerGradientStart;
  Color get bannerGradientEnd;

  // OAuth Button Colors
  Color get googleRed;
  Color get microsoftBlue;
  Color get githubBlack;
  Color get oauthButtonBgLight;
  Color get oauthButtonBgDark;
  Color get oauthButtonTextLight;
  Color get oauthButtonTextDark;
  Color get oauthBorderLight;
  Color get oauthBorderDark;

  // Additional Colors for proper theming
  Color get whiteColor;
  Color get blackColor;
  Color get primaryTextOnAccent;
  Color get codeBgColor;
  Color get codeHeaderBgColor;
  Color get dividerColor;
  Color get overlayColor;
  Color get shadowColor;
  Color get baseButtonBg;
}

class AppColors {
  // Base Colors (Light Theme Default)
  static const Color lightBgColor = Color(0xFFF8F9FA); // #f8f9fa
  static const Color lightCardBg = Color(0xFFFFFFFF); // #ffffff
  static const Color lightTextColor = Color(0xFF212529); // #212529
  static const Color lightTextSecondary = Color(0xFF495057); // #495057
  static const Color lightTextMuted = Color(0xFF6C757D); // #6c757d
  static const Color lightBorderColor = Color(0xFFEAEDF1); // #eaedf1

  // Base Colors (Dark Theme)
  static const Color darkBgColor = Color(0xFF121212); // #121212
  static const Color darkCardBg = Color(0xFF1E1E1E); // #1e1e1e
  static const Color darkTextColor = Color(0xFFE9ECEF); // #e9ecef
  static const Color darkTextSecondary = Color(0xFFCED4DA); // #ced4da
  static const Color darkTextMuted = Color(0xFFADB5BD); // #adb5bd
  static const Color darkBorderColor = Color(0xFF2A2A2A); // #2a2a2a

  // Accent Colors
  static const Color accentColor = Color(0xFF466AF1); // #466af1
  static const Color accentLight = Color(0xFF6988F5); // #6988f5
  static const Color accentHover = Color(0xFF3155DB); // #3155db
  static const Color secondaryColor = Color(0xFF6C757D); // #6c757d

  // Button & Interaction Colors
  static const Color buttonBg = Color(0xFF466AF1); // #466af1 (same as accent)
  static const Color buttonHover = Color(0xFF3155DB); // #3155db (same as accent-hover)
  static final Color hoverBg = const Color(0xFF466AF1).withValues(alpha: 0.08); // rgba(70,106,241,0.08)
  static final Color hoverBgLight = const Color(0xFF000000).withValues(alpha: 0.04);
  static final Color hoverBgDark = const Color(0xFFFFFFFF).withValues(alpha: 0.08);

  // Disabled Button Colors
  static const Color disabledDarkBg = Color(0xFF2A2A2A); // #2A2A2A
  static const Color disabledDarkText = Color(0xFF707070); // #707070
  static const Color disabledLightBg = Color(0xFFE2E2E2); // #E2E2E2
  static const Color disabledLightText = Color(0xFFAAAAAA); // #AAAAAA

  // Feedback Colors
  static const Color successColor = Color(0xFF10B981); // #10b981
  static const Color warningColor = Color(0xFFF59E0B); // #f59e0b
  static const Color dangerColor = Color(0xFFEF4444); // #ef4444
  static const Color infoColor = Color(0xFF3B82F6); // #3b82f6

  // Input Colors
  static const Color inputBg = Color(0xFFFFFFFF); // #ffffff
  static const Color darkInputBg = Color(0xFF2A2A2A); // #2A2A2A (lighter than card bg)
  static const Color inputFocusBorder = Color(0xFF466AF1); // #466af1 (same as accent)

  // Banner Colors
  static const Color bannerGradientStart = Color(0xFF2C4ED7); // Darker blue
  static const Color bannerGradientEnd = Color(0xFF3155DB); // Slightly lighter but still dark

  // OAuth Button Colors
  static const Color googleRed = Color(0xFFEA4335);
  static const Color microsoftBlue = Color(0xFF0078D4);
  static const Color githubBlack = Color(0xFF333333);
  static const Color oauthButtonBgLight = Colors.white;
  static const Color oauthButtonBgDark = Color(0xFF1E1E1E);
  static const Color oauthButtonTextLight = Color(0xFF3C4043); // Dark grey for text
  static const Color oauthButtonTextDark = Colors.white;
  static const Color oauthBorderLight = Color(0xFFDADCE0); // Light grey border
  static const Color oauthBorderDark = Color(0xFF5F6368); // Dark grey border

  // Additional Colors
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color primaryTextOnAccent = Colors.white;

  // Code snippet colors
  static const Color lightCodeBg = Color(0xFFF5F5F5);
  static const Color darkCodeBg = Color(0xFF1E1E1E);
  static const Color lightCodeHeaderBg = Color(0xFFEAEAEA);
  static const Color darkCodeHeaderBg = Color(0xFF252526);

  // Sidebar colors
  static const Color lightSidebarBg = Colors.white;
  static const Color darkSidebarBg = Color(0xFF202124);

  // Button colors
  static const Color lightBaseButtonBg = Color(0xFFF1F5F9);
  static const Color darkBaseButtonBg = Color(0xFF3A3A3A);

  // Special UI colors
  static const Color selectedBgColor = Color(0xFF6078F0);
  static final Color lightHoverBgColor = const Color(0xFF466AF1).withValues(alpha: 0.08);
  static final Color darkHoverBgColor = const Color(0xFF5B7BF0).withValues(alpha: 0.15);

  // Shadow and overlay colors
  static final Color lightShadowColor = const Color(0xFF000000).withValues(alpha: 0.05);
  static final Color darkShadowColor = const Color(0xFF000000).withValues(alpha: 0.3);
  static final Color lightOverlayColor = const Color(0xFF000000).withValues(alpha: 0.04);
  static final Color darkOverlayColor = const Color(0xFFFFFFFF).withValues(alpha: 0.08);

  // Theme objects
  static final ThemeColorSet light = _LightColors();
  static final ThemeColorSet dark = _DarkColors();
}

class _LightColors implements ThemeColorSet {
  @override
  final Color bgColor = AppColors.lightBgColor;
  @override
  final Color cardBg = AppColors.lightCardBg;
  @override
  final Color textColor = AppColors.lightTextColor;
  @override
  final Color textSecondary = AppColors.lightTextSecondary;
  @override
  final Color textMuted = AppColors.lightTextMuted;
  @override
  final Color borderColor = AppColors.lightBorderColor;
  @override
  final Color accentColor = AppColors.accentColor;
  @override
  final Color accentLight = AppColors.accentLight;
  @override
  final Color accentHover = AppColors.accentHover;
  @override
  final Color secondaryColor = AppColors.secondaryColor;
  @override
  final Color buttonBg = AppColors.buttonBg;
  @override
  final Color buttonHover = AppColors.buttonHover;
  @override
  final Color hoverBg = AppColors.hoverBg;
  @override
  final Color hoverBgLight = AppColors.hoverBgLight;
  @override
  final Color hoverBgDark = AppColors.hoverBgDark;
  @override
  final Color disabledDarkBg = AppColors.disabledDarkBg;
  @override
  final Color disabledDarkText = AppColors.disabledDarkText;
  @override
  final Color disabledLightBg = AppColors.disabledLightBg;
  @override
  final Color disabledLightText = AppColors.disabledLightText;
  @override
  final Color inputBg = AppColors.inputBg;
  @override
  final Color inputFocusBorder = AppColors.inputFocusBorder;
  @override
  final Color successColor = AppColors.successColor;
  @override
  final Color warningColor = AppColors.warningColor;
  @override
  final Color dangerColor = AppColors.dangerColor;
  @override
  final Color infoColor = AppColors.infoColor;
  @override
  final Color bannerGradientStart = AppColors.bannerGradientStart;
  @override
  final Color bannerGradientEnd = AppColors.bannerGradientEnd;

  // OAuth
  @override
  final Color googleRed = AppColors.googleRed;
  @override
  final Color microsoftBlue = AppColors.microsoftBlue;
  @override
  final Color githubBlack = AppColors.githubBlack;
  @override
  final Color oauthButtonBgLight = AppColors.oauthButtonBgLight;
  @override
  final Color oauthButtonBgDark = AppColors.oauthButtonBgDark;
  @override
  final Color oauthButtonTextLight = AppColors.oauthButtonTextLight;
  @override
  final Color oauthButtonTextDark = AppColors.oauthButtonTextDark;
  @override
  final Color oauthBorderLight = AppColors.oauthBorderLight;
  @override
  final Color oauthBorderDark = AppColors.oauthBorderDark;

  // Additional Colors
  @override
  final Color whiteColor = AppColors.whiteColor;
  @override
  final Color blackColor = AppColors.blackColor;
  @override
  final Color primaryTextOnAccent = AppColors.primaryTextOnAccent;
  @override
  final Color codeBgColor = AppColors.lightCodeBg;
  @override
  final Color codeHeaderBgColor = AppColors.lightCodeHeaderBg;
  @override
  final Color dividerColor = AppColors.lightBorderColor;
  @override
  final Color overlayColor = AppColors.lightOverlayColor;
  @override
  final Color shadowColor = AppColors.lightShadowColor;
  @override
  final Color baseButtonBg = AppColors.lightBaseButtonBg;
}

class _DarkColors implements ThemeColorSet {
  @override
  final Color bgColor = AppColors.darkBgColor;
  @override
  final Color cardBg = AppColors.darkCardBg;
  @override
  final Color textColor = AppColors.darkTextColor;
  @override
  final Color textSecondary = AppColors.darkTextSecondary;
  @override
  final Color textMuted = AppColors.darkTextMuted;
  @override
  final Color borderColor = AppColors.darkBorderColor;
  @override
  final Color accentColor = AppColors.accentColor;
  @override
  final Color accentLight = AppColors.accentLight;
  @override
  final Color accentHover = AppColors.accentHover;
  @override
  final Color secondaryColor = AppColors.secondaryColor;
  @override
  final Color buttonBg = AppColors.buttonBg;
  @override
  final Color buttonHover = AppColors.buttonHover;
  @override
  final Color hoverBg = AppColors.hoverBg;
  @override
  final Color hoverBgLight = AppColors.hoverBgLight;
  @override
  final Color hoverBgDark = AppColors.hoverBgDark;
  @override
  final Color disabledDarkBg = AppColors.disabledDarkBg;
  @override
  final Color disabledDarkText = AppColors.disabledDarkText;
  @override
  final Color disabledLightBg = AppColors.disabledLightBg;
  @override
  final Color disabledLightText = AppColors.disabledLightText;
  @override
  final Color inputBg = AppColors.darkInputBg;
  @override
  final Color inputFocusBorder = AppColors.inputFocusBorder;
  @override
  final Color successColor = AppColors.successColor;
  @override
  final Color warningColor = AppColors.warningColor;
  @override
  final Color dangerColor = AppColors.dangerColor;
  @override
  final Color infoColor = AppColors.infoColor;
  @override
  final Color bannerGradientStart = AppColors.bannerGradientStart;
  @override
  final Color bannerGradientEnd = AppColors.bannerGradientEnd;

  // OAuth
  @override
  final Color googleRed = AppColors.googleRed;
  @override
  final Color microsoftBlue = AppColors.microsoftBlue;
  @override
  final Color githubBlack = AppColors.githubBlack;
  @override
  final Color oauthButtonBgLight = AppColors.oauthButtonBgLight;
  @override
  final Color oauthButtonBgDark = AppColors.oauthButtonBgDark;
  @override
  final Color oauthButtonTextLight = AppColors.oauthButtonTextLight;
  @override
  final Color oauthButtonTextDark = AppColors.oauthButtonTextDark;
  @override
  final Color oauthBorderLight = AppColors.oauthBorderLight;
  @override
  final Color oauthBorderDark = AppColors.oauthBorderDark;

  // Additional Colors
  @override
  final Color whiteColor = AppColors.whiteColor;
  @override
  final Color blackColor = AppColors.blackColor;
  @override
  final Color primaryTextOnAccent = AppColors.primaryTextOnAccent;
  @override
  final Color codeBgColor = AppColors.darkCodeBg;
  @override
  final Color codeHeaderBgColor = AppColors.darkCodeHeaderBg;
  @override
  final Color dividerColor = AppColors.darkBorderColor;
  @override
  final Color overlayColor = AppColors.darkOverlayColor;
  @override
  final Color shadowColor = AppColors.darkShadowColor;
  @override
  final Color baseButtonBg = AppColors.darkBaseButtonBg;
}
