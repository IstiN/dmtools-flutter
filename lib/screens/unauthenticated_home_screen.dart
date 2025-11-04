import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:dmtools_styleguide/widgets/atoms/logos/dna_logo.dart';
import '../widgets/auth_login_widget.dart';
import '../providers/enhanced_auth_provider.dart';

class UnauthenticatedHomeScreen extends StatelessWidget {
  const UnauthenticatedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorsListening;

    // Calculate the total width of the three cards with spacing
    const cardWidth = 300.0;
    const cardSpacing = 24.0;
    const totalWidth = (cardWidth * 3) + (cardSpacing * 2);

    return Scaffold(
      backgroundColor: colors.bgColor,
      body: Column(
        children: [
          // macOS titlebar spacer
          if (Platform.isMacOS) const SizedBox(height: 12),
          
          // App Header from styleguide
          AppHeader(
            showTitle: false, // Hide header text
            showSearch: false, // Hide search as requested
            onThemeToggle: () async => await Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            actions: const [], // Remove actions as we'll use profileButton
            profileButton: UserProfileButton(
              loginState: LoginState.loggedOut,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const Dialog(
                      backgroundColor: Colors.transparent,
                      insetPadding: EdgeInsets.all(16),
                      elevation: 0,
                      child: AuthLoginWidget(),
                    );
                  },
                );
              },
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Welcome Banner with width matching the three cards
                    SizedBox(
                      width: totalWidth,
                      child: WelcomeBanner(
                        title: 'Welcome to DMTools',
                        subtitle: 'Your all-in-one solution for delivery management and automation',
                        onPrimaryAction: () {
                          // Show login dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const Dialog(
                                backgroundColor: Colors.transparent,
                                insetPadding: EdgeInsets.all(16),
                                elevation: 0,
                                child: AuthLoginWidget(
                                  title: 'Get Started with DMTools',
                                  subtitle: 'Sign in to access your workspace and start managing your projects',
                                ),
                              );
                            },
                          );
                        },
                        secondaryActionText: 'Demo',
                        onSecondaryAction: () async {
                          // Enable demo mode
                          final authProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);
                          await authProvider.enableDemoMode();
                        },
                        logoWidget: DnaLogo(
                          color1: Colors.white.withValues(alpha: 0.9),
                          color2: Colors.white.withValues(alpha: 0.6),
                        ),
                      ),
                    ),

                    const SizedBox(height: 64),

                    // Features Section
                    SizedBox(
                      width: totalWidth,
                      child: Text(
                        'What DMTools Can Do For You',
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Feature Cards using the styleguide component
                    const SizedBox(
                      width: totalWidth,
                      child: Wrap(
                        spacing: cardSpacing,
                        runSpacing: cardSpacing,
                        alignment: WrapAlignment.center,
                        children: [
                          FeatureCard(
                            icon: Icons.smart_toy,
                            title: 'AI-Powered Agents',
                            description:
                                'Automate repetitive tasks with intelligent agents that learn from your workflow and adapt to your needs',
                          ),
                          FeatureCard(
                            icon: Icons.workspaces,
                            title: 'Workspace Management',
                            description:
                                'Organize your projects and teams in dedicated workspaces with customizable permissions and tools',
                          ),
                          FeatureCard(
                            icon: Icons.api,
                            title: 'MCP Proxy to all your project tools',
                            description:
                                'Connect and manage all your project tools through a unified MCP interface with intelligent automation',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
