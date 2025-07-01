import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;
import 'core/config/app_config.dart';
import 'core/routing/app_router.dart';
import 'providers/auth_provider.dart';
import 'network/services/api_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize app configuration
  await AppConfigManager.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ProxyProvider<AuthProvider, ApiService>(
          update: (_, authProvider, __) => ApiService(
            baseUrl: AppConfigManager.instance.baseUrl,
            authProvider: authProvider,
          ),
        ),
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

class _DMToolsAppState extends State<DMToolsApp> {
  @override
  void initState() {
    super.initState();
    // Initialize authentication state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return MaterialApp.router(
      title: 'DMTools',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: AppRouter.createRouter(authProvider),
    );
  }
}
