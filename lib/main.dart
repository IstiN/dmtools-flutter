import 'package:dmtools/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;
import 'core/routing/app_router.dart';
import 'providers/auth_provider.dart';
import 'providers/integration_provider.dart';
import 'providers/mcp_provider.dart';
import 'network/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ServiceLocator.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceLocator.get<AuthProvider>()),
        Provider<ApiService>(create: (_) => ServiceLocator.get()),
        ChangeNotifierProvider(create: (_) => ServiceLocator.get<IntegrationProvider>()),
        ChangeNotifierProvider(create: (_) => ServiceLocator.get<McpProvider>()),
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
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.initialize();

      // Load user info from API if authenticated
      if (authProvider.isAuthenticated) {
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
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          final authProvider = Provider.of<AuthProvider>(context);

          // Create router only once
          _router ??= AppRouter.createRouter(authProvider);

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
