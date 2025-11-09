import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
  late final GoRouter router;
  bool _isThemeInitialized = false;

  @override
  void initState() {
    super.initState();
    debugPrint('📱 StyleguideApp: initState called');
    // Create router IMMEDIATELY before anything else
    router = StyleguideRouter.createRouter();
    debugPrint('📱 StyleguideApp: Router created in initState');
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
    debugPrint('📱 StyleguideApp: Starting theme initialization...');
    try {
      await _themeProvider.initializeTheme();
      debugPrint('📱 StyleguideApp: Theme initialized successfully');
      if (mounted) {
        setState(() {
          debugPrint('📱 StyleguideApp: Calling setState to show router');
          _isThemeInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('📱 StyleguideApp: Error initializing theme: $e');
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
          // Show loading screen until theme is initialized
          if (!_isThemeInitialized) {
            return MaterialApp(
              title: 'DMTools Styleguide',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              debugShowCheckedModeBanner: false,
              home: const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          }

          debugPrint('📱 StyleguideApp: Building MaterialApp.router with theme initialized');
          return MaterialApp.router(
            title: 'DMTools Styleguide',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.currentThemeMode,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
