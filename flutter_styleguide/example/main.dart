import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ExampleApp());
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> with WidgetsBindingObserver {
  late ThemeProvider _themeProvider;
  bool _isThemeInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _themeProvider = ThemeProvider();
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
      debugPrint('ExampleApp: Error initializing theme: $e');
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
    final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    _themeProvider.updateSystemTheme(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _themeProvider,
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          if (!_isThemeInitialized) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading theme preferences...'),
                    ],
                  ),
                ),
              ),
            );
          }

          return MaterialApp(
            title: 'DMTools Styleguide Example',
            theme: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.light.accentColor,
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: AppColors.dark.accentColor,
              ),
            ),
            themeMode: themeProvider.currentThemeMode,
            home: const ExampleHomePage(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DMTools Styleguide Example'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Banner
            WelcomeBanner(
              title: 'Welcome to DMTools',
              subtitle: 'Build, deploy, and manage AI agents with our powerful platform.',
              onPrimaryAction: () {},
              onSecondaryAction: () {},
              logoAssetPath: 'assets/img/dmtools-logo-combined.svg',
            ),

            const SizedBox(height: 32),

            // Button Examples
            Text(
              'Buttons',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                PrimaryButton(
                  text: 'Primary Button',
                  onPressed: () {},
                ),
                SecondaryButton(
                  text: 'Secondary Button',
                  onPressed: () {},
                ),
                OutlineButton(
                  text: 'Outline Button',
                  onPressed: () {},
                ),
                WhiteOutlineButton(
                  text: 'White Outline Button',
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Agent Card Example
            Text(
              'Agent Card',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            AgentCard(
              title: 'Customer Support Agent',
              description: 'Handles customer inquiries and resolves issues',
              status: StatusType.online,
              statusLabel: 'Active',
              tags: const ['Support', 'Customer Service'],
              runCount: 42,
              lastRunTime: '2 hours ago',
              onRun: () {},
            ),

            const SizedBox(height: 32),

            // Chat Module Example
            Text(
              'Chat Module',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: ChatInterface(
                messages: [
                  ChatMessage(
                    message: 'Hello! How can I help you today?',
                    isUser: false,
                  ),
                  ChatMessage(
                    message: 'I need help setting up my workspace.',
                    isUser: true,
                  ),
                  ChatMessage(
                    message: 'Sure, I can help with that. First, go to the Workspaces tab.',
                    isUser: false,
                  ),
                ],
                onSendMessage: (message) {
                  // In production, this would be handled by a proper messaging system
                  // print('Message sent: $message');
                },
                title: 'Support Chat',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
