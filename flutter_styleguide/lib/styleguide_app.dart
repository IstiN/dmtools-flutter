import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/theme/app_theme.dart';
import 'core/routing/styleguide_router.dart';

class StyleguideApp extends StatefulWidget {
  const StyleguideApp({super.key});

  @override
  State<StyleguideApp> createState() => _StyleguideAppState();
}

class _StyleguideAppState extends State<StyleguideApp> with WidgetsBindingObserver {
  late ThemeProvider _themeProvider;
  bool _isThemeInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeProvider = ThemeProvider();
    // Initialize theme asynchronously
    _initializeTheme();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeTheme() async {
    try {
      await _themeProvider.initializeTheme();
      if (mounted) {
        setState(() {
          _isThemeInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('StyleguideApp: Error initializing theme: $e');
      if (mounted) {
        setState(() {
          _isThemeInitialized = true;
        });
      }
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Update theme when system brightness changes
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _themeProvider.updateSystemTheme(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: 'DMTools Styleguide',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _isThemeInitialized ? themeProvider.currentThemeMode : ThemeMode.system,
            routerConfig: StyleguideRouter.router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
