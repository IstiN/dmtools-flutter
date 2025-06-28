import 'package:flutter/material.dart';
import '../../widgets/atoms/buttons/app_buttons.dart';
import '../../widgets/molecules/login_provider_selector.dart';
import '../../theme/app_dimensions.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: PrimaryButton(
          text: 'Sign In',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  contentPadding: EdgeInsets.all(AppDimensions.spacingL),
                  content: LoginProviderSelector(),
                );
              },
            );
          },
        ),
      ),
    );
  }
} 