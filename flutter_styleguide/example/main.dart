import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const ExampleApp(),
    ),
  );
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
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
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const ExampleHomePage(),
    );
  }
}

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({Key? key}) : super(key: key);

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
              name: 'Customer Support Agent',
              description: 'Handles customer inquiries and resolves issues',
              status: 'Active',
              tags: ['Support', 'Customer Service'],
              onTap: () {},
              onEdit: () {},
              onDelete: () {},
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
              child: ChatModule(
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
                  print('Message sent: $message');
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