import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import 'package:dmtools_styleguide/widgets/molecules/user_profile_button.dart';

class UnauthenticatedHomeScreen extends StatelessWidget {
  const UnauthenticatedHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    // Calculate the total width of the three cards with spacing
    const cardWidth = 300.0;
    const cardSpacing = 24.0;
    const totalWidth = (cardWidth * 3) + (cardSpacing * 2);

    return Scaffold(
      backgroundColor: colors.bgColor,
      body: Column(
        children: [
          // App Header from styleguide
          AppHeader(
            showTitle: false, // Hide header text
            showSearch: false, // Hide search as requested
            onThemeToggle: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
            actions: const [], // Remove actions as we'll use profileButton
            profileButton: UserProfileButton(
              loginState: LoginState.loggedOut,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const AlertDialog(
                      contentPadding: AppDimensions.dialogPadding,
                      content: LoginProviderSelector(),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),

                    // Welcome Banner with width matching the three cards
                    SizedBox(
                      width: totalWidth,
                      child: WelcomeBanner(
                        title: 'Welcome to DMTools',
                        subtitle: 'Your all-in-one solution for delivery management and automation',
                        onPrimaryAction: () {},
                        onSecondaryAction: () {},
                        primaryActionText: 'Get Started',
                        secondaryActionText: 'Get Help',
                        logoAssetPath: 'assets/img/dmtools-icon.svg',
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
                            icon: Icons.apps,
                            title: 'Integrated Applications',
                            description:
                                'Access a suite of tools designed for delivery managers to streamline your workflow and boost productivity',
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
