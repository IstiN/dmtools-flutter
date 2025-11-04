import 'dart:io' show Platform;
import 'package:dmtools/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;
import 'package:macos_window_utils/macos_window_utils.dart';
import 'core/routing/enhanced_app_router.dart';
import 'providers/enhanced_auth_provider.dart';
import 'providers/integration_provider.dart';
import 'providers/mcp_provider.dart';
import 'providers/chat_provider.dart';
import 'network/services/api_service.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Parse command line arguments
  String? serverPort;
  for (var i = 0; i < args.length; i++) {
    if (args[i].startsWith('--server-port=')) {
      serverPort = args[i].substring('--server-port='.length);
      print('[MAIN] Server port from args: $serverPort');
      break;
    }
  }

  // Configure macOS window appearance
  if (Platform.isMacOS) {
    await WindowManipulator.initialize(enableWindowDelegate: true);
    WindowManipulator.makeTitlebarTransparent();
    WindowManipulator.enableFullSizeContentView();
    WindowManipulator.hideTitle();
  }

  ServiceLocator.init(serverPort: serverPort);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceLocator.get<EnhancedAuthProvider>()),
        Provider<ApiService>(create: (_) => ServiceLocator.get()),
        ChangeNotifierProvider(create: (_) => ServiceLocator.get<IntegrationProvider>()),
        ChangeNotifierProvider(create: (_) => ServiceLocator.get<McpProvider>()),
        ChangeNotifierProvider(create: (_) => ServiceLocator.get<ChatProvider>()),
      ],
      child: const DMToolsApp(),
    ),
  );
}

class DMToolsApp extends StatefulWidget {
  const DMToolsApp({super.key});

  @override
  State<DMToolsApp> createState() => _DMToolsAppState();
}

class _DMToolsAppState extends State<DMToolsApp> with WidgetsBindingObserver {
  late ThemeProvider _themeProvider;
  bool _isThemeInitialized = false;
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeProvider = ThemeProvider();

    // Initialize theme and authentication
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _initializeApp() async {
    // Initialize theme first
    try {
      await _themeProvider.initializeTheme();
      if (mounted) {
        setState(() {
          _isThemeInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('DMToolsApp: Error initializing theme: $e');
      if (mounted) {
        setState(() {
          _isThemeInitialized = true;
        });
      }
    }

    // Initialize authentication state
    if (mounted) {
      final enhancedAuthProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);
      await enhancedAuthProvider.initializeAuth();

      // Load user info from API if authenticated
      if (enhancedAuthProvider.isAuthenticated) {
        await ServiceLocator.initializeUserInfo();
      }
    }
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Update theme when system brightness changes
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _themeProvider.updateSystemTheme(brightness);
    _updateMacOSWindowAppearance(brightness == Brightness.dark);
  }

  void _updateMacOSWindowAppearance(bool isDark) {
    if (Platform.isMacOS) {
      // The title bar will automatically adapt to the Material theme
      // No additional configuration needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final enhancedAuthProvider = Provider.of<EnhancedAuthProvider>(context);

          // Create router only once
          _router ??= EnhancedAppRouter.createRouter(enhancedAuthProvider);

          return MaterialApp.router(
            title: 'DMTools',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _isThemeInitialized ? themeProvider.currentThemeMode : ThemeMode.system,
            routerConfig: _router!,
          );
        },
      ),
    );
  }
}
