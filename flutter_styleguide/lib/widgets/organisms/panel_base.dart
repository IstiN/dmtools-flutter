import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

enum PanelHeaderStyle {
  primary,
  secondary,
  neutral
}

class PanelBase extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;
  final PanelHeaderStyle headerStyle;
  final bool isCollapsible;
  final bool initiallyCollapsed;
  final bool? isTestMode;
  final bool? testDarkMode;

  const PanelBase({
    Key? key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.headerStyle = PanelHeaderStyle.primary,
    this.isCollapsible = false,
    this.initiallyCollapsed = false,
    this.isTestMode = false,
    this.testDarkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode;
    dynamic colors;
    
    if (isTestMode == true) {
      isDarkMode = testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      try {
        final themeProvider = Provider.of<ThemeProvider>(context);
        isDarkMode = themeProvider.isDarkMode;
        colors = isDarkMode ? AppColors.dark : AppColors.light;
      } catch (e) {
        // Fallback for tests
        isDarkMode = false;
        colors = AppColors.light;
      }
    }

    Color headerBgColor;
    Color headerTextColor;
    
    switch (headerStyle) {
      case PanelHeaderStyle.primary:
        headerBgColor = colors.accentColor;
        headerTextColor = Colors.white;
        break;
      case PanelHeaderStyle.secondary:
        headerBgColor = colors.secondaryColor;
        headerTextColor = Colors.white;
        break;
      case PanelHeaderStyle.neutral:
        headerBgColor = isDarkMode ? colors.cardBg : colors.bgColor;
        headerTextColor = colors.textColor;
        break;
    }

    return StatefulBuilder(
      builder: (context, setState) {
        bool isCollapsed = initiallyCollapsed;
        
        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Panel Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: headerBgColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppDimensions.radiusM),
                    topRight: Radius.circular(AppDimensions.radiusM),
                    bottomLeft: isCollapsed ? Radius.circular(AppDimensions.radiusM) : Radius.zero,
                    bottomRight: isCollapsed ? Radius.circular(AppDimensions.radiusM) : Radius.zero,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: headerTextColor,
                        ),
                      ),
                    ),
                    ...actions,
                    if (isCollapsible)
                      IconButton(
                        icon: Icon(
                          isCollapsed ? Icons.expand_more : Icons.expand_less,
                          color: headerTextColor,
                        ),
                        onPressed: () {
                          setState(() {
                            isCollapsed = !isCollapsed;
                          });
                        },
                      ),
                  ],
                ),
              ),
              
              // Panel Content
              if (!isCollapsed)
                Container(
                  padding: const EdgeInsets.all(16),
                  child: content,
                ),
            ],
          ),
        );
      },
    );
  }
} 