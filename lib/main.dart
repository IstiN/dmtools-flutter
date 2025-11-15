// PERFORMANCE TEST: Step-by-step adding changes - STEP 1: Added imports
import 'dart:io' show Platform;
import 'package:dmtools/service_locator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;
import 'package:macos_window_utils/macos_window_utils.dart';
import 'core/analytics/interaction_tracker_binding.dart';
import 'core/routing/enhanced_app_router.dart';
import 'core/services/analytics_service.dart';
import 'providers/enhanced_auth_provider.dart';
import 'providers/integration_provider.dart';
import 'providers/mcp_provider.dart';
import 'providers/chat_provider.dart';
import 'network/services/api_service.dart';
import 'screens/unauthenticated_home_screen.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  // STEP 2b: Testing ServiceLocator + AnalyticsService
  String? serverPort;
  for (var i = 0; i < args.length; i++) {
    if (args[i].startsWith('--server-port=')) {
      serverPort = args[i].substring('--server-port='.length);
      break;
    }
  }

  ServiceLocator.init(serverPort: serverPort);

  // Initialize analytics (fail gracefully if initialization fails)
  try {
    await AnalyticsService.initialize();
  } catch (e) {
    debugPrint('⚠️ Analytics initialization failed: $e');
    // Continue app startup even if analytics fails
  }

  // STEP 2c: Testing InteractionTrackerBinding - tracks user interactions including scroll!
  InteractionTrackerBinding.configure();

  // STEP 3: Adding MultiProvider with ALL providers
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

// STEP 4: Added WidgetsBindingObserver + GoRouter field
class _DMToolsAppState extends State<DMToolsApp> with WidgetsBindingObserver {
  late ThemeProvider _themeProvider;
  bool _isThemeInitialized = false;
  GoRouter? _router;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeProvider = ThemeProvider();
    // STEP 6: Renamed _initializeTheme() → _initializeApp()
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // STEP 6: Added auth initialization to _initializeApp()
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

  // STEP 5: Added didChangePlatformBrightness
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
          // STEP 7: Using EnhancedAppRouter + Provider.of<EnhancedAuthProvider>
          final enhancedAuthProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);
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
