import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';

/// Simple toggle theme switch (for backward compatibility)
class ThemeSwitch extends StatelessWidget {
  final bool isDarkMode;
  final VoidCallback onToggle;

  const ThemeSwitch({
    required this.isDarkMode,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          // Sun icon
          AnimatedOpacity(
            opacity: isDarkMode ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.light_mode,
              size: 20,
            ),
          ),
          // Moon icon
          AnimatedOpacity(
            opacity: isDarkMode ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.dark_mode,
              size: 20,
            ),
          ),
        ],
      ),
      onPressed: onToggle,
      tooltip: isDarkMode ? 'Switch to light mode' : 'Switch to dark mode',
      padding: const EdgeInsets.all(8),
    );
  }
}

/// Enhanced theme selector with system, light, and dark options
class ThemeSelector extends StatelessWidget {
  final bool showLabels;
  final bool isCompact;

  const ThemeSelector({
    this.showLabels = true,
    this.isCompact = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        if (isCompact) {
          return _buildCompactSelector(context, themeProvider);
        } else {
          return _buildFullSelector(context, themeProvider);
        }
      },
    );
  }

  Widget _buildCompactSelector(BuildContext context, ThemeProvider themeProvider) {
    return PopupMenuButton<ThemePreference>(
      icon: Icon(_getThemeIcon(themeProvider.themePreference)),
      tooltip: 'Change theme',
      onSelected: (ThemePreference preference) {
        themeProvider.setThemePreference(preference);
      },
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<ThemePreference>(
          value: ThemePreference.system,
          child: Row(
            children: [
              const Icon(Icons.settings_system_daydream, size: 18),
              const SizedBox(width: 8),
              const Text('System'),
              if (themeProvider.themePreference == ThemePreference.system)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
        PopupMenuItem<ThemePreference>(
          value: ThemePreference.light,
          child: Row(
            children: [
              const Icon(Icons.light_mode, size: 18),
              const SizedBox(width: 8),
              const Text('Light'),
              if (themeProvider.themePreference == ThemePreference.light)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
        PopupMenuItem<ThemePreference>(
          value: ThemePreference.dark,
          child: Row(
            children: [
              const Icon(Icons.dark_mode, size: 18),
              const SizedBox(width: 8),
              const Text('Dark'),
              if (themeProvider.themePreference == ThemePreference.dark)
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 16),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFullSelector(BuildContext context, ThemeProvider themeProvider) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabels)
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text('Theme:'),
          ),
        ...ThemePreference.values.map((preference) {
          final isSelected = themeProvider.themePreference == preference;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: _buildThemeButton(
              context,
              preference,
              isSelected,
              () => themeProvider.setThemePreference(preference),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildThemeButton(
    BuildContext context,
    ThemePreference preference,
    bool isSelected,
    VoidCallback onPressed,
  ) {
    final theme = Theme.of(context);
    final icon = _getThemeIcon(preference);
    final label = _getThemeLabel(preference);

    return Tooltip(
      message: 'Switch to $label theme',
      child: Material(
        color: isSelected ? theme.colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: isSelected
                  ? Border.all(color: theme.colorScheme.primary, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isSelected ? theme.colorScheme.primary : theme.iconTheme.color,
                ),
                if (showLabels) ...[
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodySmall?.color,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getThemeIcon(ThemePreference preference) {
    switch (preference) {
      case ThemePreference.system:
        return Icons.settings_system_daydream;
      case ThemePreference.light:
        return Icons.light_mode;
      case ThemePreference.dark:
        return Icons.dark_mode;
    }
  }

  String _getThemeLabel(ThemePreference preference) {
    switch (preference) {
      case ThemePreference.system:
        return 'System';
      case ThemePreference.light:
        return 'Light';
      case ThemePreference.dark:
        return 'Dark';
    }
  }
}
