// PERFORMANCE TEST: Testing ThemeProvider impact - added ThemeProvider + GoRouter
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'screens/unauthenticated_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DMToolsApp());
}

class DMToolsApp extends StatefulWidget {
  const DMToolsApp({super.key});

  @override
  State<DMToolsApp> createState() => _DMToolsAppState();
}

class _DMToolsAppState extends State<DMToolsApp> {
  late ThemeProvider _themeProvider;
  bool _isThemeInitialized = false;

  @override
  void initState() {
    super.initState();
    _themeProvider = ThemeProvider();
    _initializeTheme();
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
      debugPrint('Error initializing theme: $e');
      if (mounted) {
        setState(() {
          _isThemeInitialized = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Simple router without authentication
          final router = GoRouter(
            initialLocation: '/',
            routes: [GoRoute(path: '/', builder: (context, state) => const UnauthenticatedHomeScreen())],
          );

          return MaterialApp.router(
            title: 'DMTools',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: _isThemeInitialized ? themeProvider.currentThemeMode : ThemeMode.system,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
