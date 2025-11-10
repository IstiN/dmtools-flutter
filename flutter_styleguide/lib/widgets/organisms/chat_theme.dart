import 'package:flutter/material.dart';

/// Chat theme configuration for customizing chat message appearance
class ChatTheme {
  final Color userMessageColor;
  final Color aiMessageColor;
  final Color userMessageTextColor;
  final Color aiMessageTextColor;
  final Color? userMessageTextColorLight;
  final Color? userMessageTextColorDark;
  final Color? aiMessageTextColorLight;
  final Color? aiMessageTextColorDark;
  final bool showShadows;
  final bool bubbleMode;
  final double textSize;
  final Color nameColor;
  final Color? backgroundColorLight;
  final Color? backgroundColorDark;
  final Color dateTextColor;
  final bool showAgentName;
  final String? fontFamily;
  final String agentName;

  const ChatTheme({
    required this.userMessageColor,
    required this.aiMessageColor,
    required this.userMessageTextColor,
    required this.aiMessageTextColor,
    required this.nameColor,
    required this.dateTextColor,
    this.userMessageTextColorLight,
    this.userMessageTextColorDark,
    this.aiMessageTextColorLight,
    this.aiMessageTextColorDark,
    this.backgroundColorLight,
    this.backgroundColorDark,
    this.showShadows = false,
    this.bubbleMode = true,
    this.textSize = 1.0,
    this.showAgentName = true,
    this.fontFamily,
    this.agentName = 'DM.ai',
  });

  /// Day Classic theme - Green background theme
  factory ChatTheme.dayClassic() {
    return const ChatTheme(
      userMessageColor: Color(0xFF25D366), // WhatsApp green
      aiMessageColor: Color(0xFFE5E5E5), // Light gray
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF212529),
      nameColor: Color(0xFF25D366),
      backgroundColorLight: Color(0xFFECE5DD), // Light beige/green tint
      backgroundColorDark: Color(0xFF1E1E1E), // Dark gray for dark mode
      dateTextColor: Color(0xFF6C757D), // Gray for dates
    );
  }

  /// Day theme - White background with blue bubbles (default)
  factory ChatTheme.day() {
    return const ChatTheme(
      userMessageColor: Color(0xFF4285F4), // Google blue
      aiMessageColor: Color(0xFFF1F3F4), // Light gray
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF212529),
      nameColor: Color(0xFF4285F4),
      backgroundColorLight: Colors.white,
      backgroundColorDark: Color(0xFF1E1E1E), // Dark gray for dark mode
      dateTextColor: Color(0xFF6C757D), // Gray for dates
    );
  }

  /// Night Accent theme - Dark gray with dark blue bubbles
  factory ChatTheme.nightAccent() {
    return const ChatTheme(
      userMessageColor: Color(0xFF1E3A8A), // Dark blue
      aiMessageColor: Color(0xFF2D2D2D), // Dark gray
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFFE9ECEF),
      nameColor: Color(0xFF60A5FA), // Light blue accent
      backgroundColorLight: Color(0xFF1E1E1E), // Very dark gray
      backgroundColorDark: Color(0xFF1E1E1E), // Very dark gray
      dateTextColor: Color(0xFFADB5BD), // Light gray for dates
    );
  }

  /// Default theme - Based on DM.ai icon colors (dark slate gradient, transparent AI, adaptive text)
  /// Uses transparent background to match app theme
  factory ChatTheme.defaultTheme() {
    return const ChatTheme(
      userMessageColor: Color(0xFF1E293B), // Dark slate from icon background (start of gradient)
      aiMessageColor: Colors.transparent, // Transparent for AI messages
      userMessageTextColor: Colors.white, // Default for user messages
      aiMessageTextColor: Colors.white, // Default for AI messages
      userMessageTextColorLight: Colors.white, // White text on dark slate in light theme
      userMessageTextColorDark: Colors.white, // White text on dark slate in dark theme
      aiMessageTextColorLight: Color(0xFF1E293B), // Dark text for transparent AI messages in light theme
      aiMessageTextColorDark: Colors.white, // White text for transparent AI messages in dark theme
      nameColor: Color(0xFF06B6D4), // Cyan matching "ai" badge
      dateTextColor: Color(0xFF94A3B8), // Light gray for dates
      // backgroundColorLight and backgroundColorDark default to null for transparent background
    );
  }

  /// System theme - Uses app theme background (transparent/null)
  factory ChatTheme.system() {
    return const ChatTheme(
      userMessageColor: Color(0xFF0D7377), // Teal/cyan
      aiMessageColor: Color(0xFF2A2A2A), // Dark gray
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFFE9ECEF),
      nameColor: Color(0xFF14FFEC), // Cyan accent
      dateTextColor: Color(0xFFADB5BD), // Light gray for dates
      // backgroundColorLight and backgroundColorDark default to null for system theme
    );
  }

  /// Modern Minimal - Clean, minimalist design with subtle colors
  factory ChatTheme.modernMinimal() {
    return const ChatTheme(
      userMessageColor: Color(0xFF6366F1), // Indigo
      aiMessageColor: Color(0xFFF3F4F6), // Very light gray
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF111827),
      nameColor: Color(0xFF6366F1),
      backgroundColorLight: Color(0xFFFAFAFA), // Off-white
      backgroundColorDark: Color(0xFF18181B), // Dark gray
      dateTextColor: Color(0xFF6B7280),
      fontFamily: 'Inter',
    );
  }

  /// Vibrant Sunset - Warm, energetic colors inspired by sunset
  factory ChatTheme.vibrantSunset() {
    return const ChatTheme(
      userMessageColor: Color(0xFFFF6B6B), // Coral red
      aiMessageColor: Color(0xFFFFF4E6), // Warm cream
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF2D3436),
      nameColor: Color(0xFFFF6B6B),
      backgroundColorLight: Color(0xFFFFF8F0), // Warm white
      backgroundColorDark: Color(0xFF1A1A1A), // Deep black
      dateTextColor: Color(0xFF74B9FF),
      fontFamily: 'Poppins',
    );
  }

  /// Ocean Breeze - Cool, calming blue tones
  factory ChatTheme.oceanBreeze() {
    return const ChatTheme(
      userMessageColor: Color(0xFF00B4D8), // Sky blue
      aiMessageColor: Color(0xFFE0F7FA), // Light cyan
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF003D5B),
      nameColor: Color(0xFF0077B6),
      backgroundColorLight: Color(0xFFF0F9FF), // Ice blue
      backgroundColorDark: Color(0xFF0A1929), // Deep navy
      dateTextColor: Color(0xFF48CAE4),
      fontFamily: 'Open Sans',
    );
  }

  /// Forest Green - Natural, earthy green palette
  factory ChatTheme.forestGreen() {
    return const ChatTheme(
      userMessageColor: Color(0xFF2D5016), // Forest green
      aiMessageColor: Color(0xFFE8F5E9), // Light green
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF1B5E20),
      nameColor: Color(0xFF4CAF50),
      backgroundColorLight: Color(0xFFF1F8E9), // Mint cream
      backgroundColorDark: Color(0xFF1B3A1B), // Dark forest
      dateTextColor: Color(0xFF66BB6A),
      fontFamily: 'Lato',
    );
  }

  /// Purple Dream - Rich purple and lavender tones
  factory ChatTheme.purpleDream() {
    return const ChatTheme(
      userMessageColor: Color(0xFF7B2CBF), // Deep purple
      aiMessageColor: Color(0xFFF3E5F5), // Light lavender
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF4A148C),
      nameColor: Color(0xFF9D4EDD),
      backgroundColorLight: Color(0xFFFAF5FF), // Lavender white
      backgroundColorDark: Color(0xFF1A0B2E), // Deep purple black
      dateTextColor: Color(0xFFC77DFF),
      fontFamily: 'Montserrat',
    );
  }

  /// Warm Coffee - Cozy, warm brown tones
  factory ChatTheme.warmCoffee() {
    return const ChatTheme(
      userMessageColor: Color(0xFF6F4E37), // Coffee brown
      aiMessageColor: Color(0xFFFFF8E1), // Warm beige
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF3E2723),
      nameColor: Color(0xFF8D6E63),
      backgroundColorLight: Color(0xFFFFFBF0), // Cream
      backgroundColorDark: Color(0xFF2C1810), // Dark coffee
      dateTextColor: Color(0xFFA1887F),
      fontFamily: 'Merriweather',
    );
  }

  /// Cool Tech - Modern tech-inspired blue-gray palette
  factory ChatTheme.coolTech() {
    return const ChatTheme(
      userMessageColor: Color(0xFF0EA5E9), // Bright cyan
      aiMessageColor: Color(0xFFE0E7FF), // Light indigo
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF1E293B),
      nameColor: Color(0xFF3B82F6),
      backgroundColorLight: Color(0xFFF8FAFC), // Cool gray
      backgroundColorDark: Color(0xFF0F172A), // Slate dark
      dateTextColor: Color(0xFF64748B),
      fontFamily: 'Roboto',
    );
  }

  /// Pastel Soft - Gentle, soft pastel colors
  factory ChatTheme.pastelSoft() {
    return const ChatTheme(
      userMessageColor: Color(0xFFFFB3BA), // Soft pink
      aiMessageColor: Color(0xFFFFF0F5), // Lavender blush
      userMessageTextColor: Color(0xFF8B4A6B),
      aiMessageTextColor: Color(0xFF6B4C7A),
      nameColor: Color(0xFFFFB3BA),
      backgroundColorLight: Color(0xFFFFFEFE), // Almost white
      backgroundColorDark: Color(0xFF2D1B2E), // Soft dark purple
      dateTextColor: Color(0xFFB19CD9),
      fontFamily: 'Nunito',
    );
  }

  /// High Contrast - Maximum readability with strong contrast
  factory ChatTheme.highContrast() {
    return const ChatTheme(
      userMessageColor: Color(0xFF000000), // Pure black
      aiMessageColor: Color(0xFFFFFFFF), // Pure white
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Colors.black,
      nameColor: Color(0xFF000000),
      backgroundColorLight: Color(0xFFFFFFFF), // Pure white
      backgroundColorDark: Color(0xFF000000), // Pure black
      dateTextColor: Color(0xFF666666),
      fontFamily: 'Roboto Condensed',
    );
  }

  /// Midnight Blue - Deep, sophisticated blue-black theme
  factory ChatTheme.midnightBlue() {
    return const ChatTheme(
      userMessageColor: Color(0xFF1E40AF), // Royal blue
      aiMessageColor: Color(0xFF1E293B), // Slate gray
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFFE2E8F0),
      nameColor: Color(0xFF60A5FA),
      backgroundColorLight: Color(0xFFF1F5F9), // Light slate
      backgroundColorDark: Color(0xFF0F172A), // Midnight blue
      dateTextColor: Color(0xFF94A3B8),
      fontFamily: 'Source Sans 3',
    );
  }

  /// Golden Hour - Warm, golden sunset-inspired theme
  factory ChatTheme.goldenHour() {
    return const ChatTheme(
      userMessageColor: Color(0xFFF59E0B), // Amber
      aiMessageColor: Color(0xFFFFF7ED), // Warm orange tint
      userMessageTextColor: Colors.white,
      aiMessageTextColor: Color(0xFF78350F),
      nameColor: Color(0xFFF97316),
      backgroundColorLight: Color(0xFFFFFBF5), // Warm white
      backgroundColorDark: Color(0xFF1C1917), // Warm dark
      dateTextColor: Color(0xFFFB923C),
      fontFamily: 'Raleway',
    );
  }

  /// Create a copy with modified properties
  ChatTheme copyWith({
    Color? userMessageColor,
    Color? aiMessageColor,
    Color? userMessageTextColor,
    Color? aiMessageTextColor,
    Color? userMessageTextColorLight,
    Color? userMessageTextColorDark,
    Color? aiMessageTextColorLight,
    Color? aiMessageTextColorDark,
    bool? showShadows,
    bool? bubbleMode,
    double? textSize,
    Color? nameColor,
    Color? backgroundColorLight,
    Color? backgroundColorDark,
    bool? clearBackgroundColor,
    Color? dateTextColor,
    bool? showAgentName,
    String? fontFamily,
    String? agentName,
  }) {
    return ChatTheme(
      userMessageColor: userMessageColor ?? this.userMessageColor,
      aiMessageColor: aiMessageColor ?? this.aiMessageColor,
      userMessageTextColor: userMessageTextColor ?? this.userMessageTextColor,
      aiMessageTextColor: aiMessageTextColor ?? this.aiMessageTextColor,
      userMessageTextColorLight: userMessageTextColorLight ?? this.userMessageTextColorLight,
      userMessageTextColorDark: userMessageTextColorDark ?? this.userMessageTextColorDark,
      aiMessageTextColorLight: aiMessageTextColorLight ?? this.aiMessageTextColorLight,
      aiMessageTextColorDark: aiMessageTextColorDark ?? this.aiMessageTextColorDark,
      showShadows: showShadows ?? this.showShadows,
      bubbleMode: bubbleMode ?? this.bubbleMode,
      textSize: textSize ?? this.textSize,
      nameColor: nameColor ?? this.nameColor,
      backgroundColorLight: clearBackgroundColor == true ? null : (backgroundColorLight ?? this.backgroundColorLight),
      backgroundColorDark: clearBackgroundColor == true ? null : (backgroundColorDark ?? this.backgroundColorDark),
      dateTextColor: dateTextColor ?? this.dateTextColor,
      showAgentName: showAgentName ?? this.showAgentName,
      fontFamily: fontFamily ?? this.fontFamily,
      agentName: agentName ?? this.agentName,
    );
  }

  /// Get background color based on current theme mode
  Color? getBackgroundColor(bool isDarkMode) {
    return isDarkMode ? backgroundColorDark : backgroundColorLight;
  }

  /// Get user message text color based on current theme mode
  Color getUserMessageTextColor(bool isDarkMode) {
    if (isDarkMode && userMessageTextColorDark != null) {
      return userMessageTextColorDark!;
    }
    if (!isDarkMode && userMessageTextColorLight != null) {
      return userMessageTextColorLight!;
    }
    return userMessageTextColor; // Fallback to default
  }

  /// Get AI message text color based on current theme mode
  Color getAiMessageTextColor(bool isDarkMode) {
    if (isDarkMode && aiMessageTextColorDark != null) {
      return aiMessageTextColorDark!;
    }
    if (!isDarkMode && aiMessageTextColorLight != null) {
      return aiMessageTextColorLight!;
    }
    return aiMessageTextColor; // Fallback to default
  }
}

/// Predefined accent colors for chat themes
class ChatAccentColors {
  static const List<Color> accentColors = [
    Color(0xFF4285F4), // Blue (default)
    Color(0xFFEA4335), // Red
    Color(0xFFFBBC05), // Orange/Yellow
    Color(0xFF34A853), // Green
    Color(0xFF1A73E8), // Light Blue
    Color(0xFF9333EA), // Purple
    Color(0xFFE91E63), // Pink
    // Popular modern colors
    Color(0xFF06B6D4), // Cyan
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Fuchsia
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Emerald
    Color(0xFF3B82F6), // Sky Blue
    Color(0xFF6366F1), // Indigo
    Color(0xFFEF4444), // Rose
    Color(0xFF14B8A6), // Teal
    Color(0xFFA855F7), // Purple-500
    Color(0xFFF97316), // Orange
    Color(0xFF22C55E), // Green-500
  ];

  /// Multi-color gradient representation
  static Widget getMultiColorSwatch() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFFEA4335), Color(0xFFFBBC05), Color(0xFF34A853)],
          stops: [0.0, 0.33, 0.66, 1.0],
        ),
      ),
    );
  }
}

/// Chat theme type enum
enum ChatThemeType {
  defaultTheme,
  dayClassic,
  day,
  nightAccent,
  system,
  modernMinimal,
  vibrantSunset,
  oceanBreeze,
  forestGreen,
  purpleDream,
  warmCoffee,
  coolTech,
  pastelSoft,
  highContrast,
  midnightBlue,
  goldenHour,
}

extension ChatThemeTypeExtension on ChatThemeType {
  ChatTheme toTheme() {
    switch (this) {
      case ChatThemeType.defaultTheme:
        return ChatTheme.defaultTheme();
      case ChatThemeType.dayClassic:
        return ChatTheme.dayClassic();
      case ChatThemeType.day:
        return ChatTheme.day();
      case ChatThemeType.nightAccent:
        return ChatTheme.nightAccent();
      case ChatThemeType.system:
        return ChatTheme.system();
      case ChatThemeType.modernMinimal:
        return ChatTheme.modernMinimal();
      case ChatThemeType.vibrantSunset:
        return ChatTheme.vibrantSunset();
      case ChatThemeType.oceanBreeze:
        return ChatTheme.oceanBreeze();
      case ChatThemeType.forestGreen:
        return ChatTheme.forestGreen();
      case ChatThemeType.purpleDream:
        return ChatTheme.purpleDream();
      case ChatThemeType.warmCoffee:
        return ChatTheme.warmCoffee();
      case ChatThemeType.coolTech:
        return ChatTheme.coolTech();
      case ChatThemeType.pastelSoft:
        return ChatTheme.pastelSoft();
      case ChatThemeType.highContrast:
        return ChatTheme.highContrast();
      case ChatThemeType.midnightBlue:
        return ChatTheme.midnightBlue();
      case ChatThemeType.goldenHour:
        return ChatTheme.goldenHour();
    }
  }

  String get displayName {
    switch (this) {
      case ChatThemeType.defaultTheme:
        return 'Default';
      case ChatThemeType.dayClassic:
        return 'Day Classic';
      case ChatThemeType.day:
        return 'Day';
      case ChatThemeType.nightAccent:
        return 'Night Accent';
      case ChatThemeType.system:
        return 'System';
      case ChatThemeType.modernMinimal:
        return 'Modern Minimal';
      case ChatThemeType.vibrantSunset:
        return 'Vibrant Sunset';
      case ChatThemeType.oceanBreeze:
        return 'Ocean Breeze';
      case ChatThemeType.forestGreen:
        return 'Forest Green';
      case ChatThemeType.purpleDream:
        return 'Purple Dream';
      case ChatThemeType.warmCoffee:
        return 'Warm Coffee';
      case ChatThemeType.coolTech:
        return 'Cool Tech';
      case ChatThemeType.pastelSoft:
        return 'Pastel Soft';
      case ChatThemeType.highContrast:
        return 'High Contrast';
      case ChatThemeType.midnightBlue:
        return 'Midnight Blue';
      case ChatThemeType.goldenHour:
        return 'Golden Hour';
    }
  }
}
