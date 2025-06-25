import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../core/services/auth_service.dart';
import '../../widgets/molecules/login_provider_selector.dart';
import '../../widgets/atoms/buttons/app_buttons.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String? _loggedInUser;

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(16),
          elevation: 0,
          child: LoginProviderSelector(
          ),
        );
      },
    );
  }

  void _handleLogout() {
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.logout();
    setState(() {
      _loggedInUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication Components'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login Provider Selector',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                'A component that allows users to choose from multiple authentication providers.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              
              // Demo section with interactive login
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF2A2A2A) : const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Interactive Demo',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    
                    if (_loggedInUser != null) ...[
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 64,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Successfully logged in as $_loggedInUser!',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'Log Out',
                        onPressed: _handleLogout,
                      ),
                    ] else ...[
                      Text(
                        'Click the button below to show the login dialog.',
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        text: 'Show Login Dialog',
                        onPressed: _showLoginDialog,
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 48),
              const Divider(),
              const SizedBox(height: 48),
              
              // Static examples
              Text(
                'Login Provider Selector - Static Examples',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 32),
              const Center(
                child: LoginProviderSelector(
                  title: 'Sign In',
                  subtitle: 'Select your authentication method',
                ),
              ),
              const SizedBox(height: 48),
              const Center(
                child: LoginProviderSelector(
                  title: 'Create Account',
                  subtitle: 'Choose how you want to register',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 