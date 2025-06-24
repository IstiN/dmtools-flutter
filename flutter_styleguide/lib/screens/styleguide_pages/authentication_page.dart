import 'package:dmtools_styleguide/widgets/atoms/buttons/app_button.dart';
import 'package:dmtools_styleguide/widgets/molecules/login_provider_selector.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_dimensions.dart';

class AuthenticationPage extends StatelessWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authentication'),
      ),
      body: Center(
        child: AppButton.primary(
          label: 'Sign In',
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return const AlertDialog(
                  contentPadding: EdgeInsets.all(AppDimensions.paddingLarge),
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