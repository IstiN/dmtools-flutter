import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  void _showOAuthProviders(BuildContext context) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  contentPadding: EdgeInsets.all(AppDimensions.spacingL),
                  content: LoginProviderSelector(),
                );
              },
            );
  }

  void _showLocalAuth(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.zero,
          content: LocalLoginForm(
            onSubmit: (username, password, saveCredentials) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Demo: Login attempted with $username${saveCredentials ? ' (save credentials: yes)' : ''}',
                  ),
                ),
              );
            },
            onCancel: () => Navigator.of(context).pop(),
          ),
        );
      },
    );
  }

  void _showDynamicAuth(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(AppDimensions.spacingL),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Dynamic Authentication Demo',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacingL),
              
              // Simulate external providers mode
              const Text('External Providers Mode:'),
              const SizedBox(height: AppDimensions.spacingM),
              const LoginProviderSelector(),
              
              const SizedBox(height: AppDimensions.spacingXl),
              
              // Divider
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingM),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        color: context.colors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              
              const SizedBox(height: AppDimensions.spacingXl),
              
              // Local authentication
              const Text('Local Authentication Mode:'),
              const SizedBox(height: AppDimensions.spacingM),
              LocalLoginForm(
                onSubmit: (username, password, saveCredentials) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Demo: Login attempted with $username${saveCredentials ? ' (save credentials: yes)' : ''}',
                      ),
                    ),
                  );
                },
                onCancel: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
        backgroundColor: context.colors.cardBg,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        children: [
          const ComponentDisplay(
            title: 'Authentication Components',
            description: 'Components for user authentication including OAuth providers, local login forms, and dynamic authentication flows.',
            child: SizedBox.shrink(),
          ),
          const SizedBox(height: AppDimensions.spacingL),

          // OAuth Providers Section
          _buildSection(
            context,
            'OAuth Provider Selector',
            'OAuth provider buttons for external authentication (Google, Microsoft, GitHub)',
            PrimaryButton(
              text: 'Show OAuth Providers',
              onPressed: () => _showOAuthProviders(context),
            ),
          ),

          // Local Authentication Section
          _buildSection(
            context,
            'Local Authentication Form',
            'Username/password form with validation and credential saving option',
            PrimaryButton(
              text: 'Show Local Login',
              onPressed: () => _showLocalAuth(context),
            ),
          ),

          // Dynamic Authentication Section
          _buildSection(
            context,
            'Dynamic Authentication Demo',
            'Complete authentication flow that adapts based on configuration',
            PrimaryButton(
              text: 'Show Dynamic Auth Demo',
              onPressed: () => _showDynamicAuth(context),
            ),
          ),

          // Usage Examples Section
          _buildSection(
            context,
            'Implementation Examples',
            'Code examples showing how to integrate authentication components',
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'OAuth Provider Usage:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  decoration: BoxDecoration(
                    color: context.colors.cardBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: context.colors.borderColor),
                  ),
                  child: const Text(
                    '''LoginProviderSelector(
  title: 'Sign in to DMTools',
  subtitle: 'Choose a provider to continue',
)''',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacingL),
                
                const Text(
                  'Local Login Form Usage:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: AppDimensions.spacingS),
                Container(
                  padding: const EdgeInsets.all(AppDimensions.spacingM),
                  decoration: BoxDecoration(
                    color: context.colors.cardBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(color: context.colors.borderColor),
                  ),
                  child: const Text(
                    '''LocalLoginForm(
  showSaveCredentials: true,
  onSubmit: (username, password, save) {
    // Handle authentication
  },
  onCancel: () => Navigator.pop(context),
)''',
                    style: TextStyle(fontFamily: 'monospace'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String description, Widget demo) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingL),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: context.colors.textMuted,
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            demo,
          ],
        ),
      ),
    );
  }
} 