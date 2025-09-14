import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../theme/app_theme.dart';
import '../atoms/form_elements.dart';
import '../atoms/buttons/app_buttons.dart';

/// Local login form with validation and save credentials option for styleguide
class LocalLoginForm extends StatefulWidget {
  final String? initialUsername;
  final bool showSaveCredentials;
  final VoidCallback? onCancel;
  final void Function(String username, String password, bool saveCredentials)? onSubmit;
  final bool isLoading;
  final String? errorMessage;

  const LocalLoginForm({
    this.initialUsername,
    this.showSaveCredentials = true,
    this.onCancel,
    this.onSubmit,
    this.isLoading = false,
    this.errorMessage,
    super.key,
  });

  @override
  State<LocalLoginForm> createState() => _LocalLoginFormState();
}

class _LocalLoginFormState extends State<LocalLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _saveCredentials = false;
  bool _obscurePassword = true;
  Map<String, String> _fieldErrors = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialUsername != null) {
      _usernameController.text = widget.initialUsername!;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      _fieldErrors = {};
    });

    // Clear previous form validation
    _formKey.currentState?.validate();

    // Validate credentials
    final errors = <String, String>{};
    
    if (_usernameController.text.trim().isEmpty) {
      errors['username'] = 'Username is required';
    }
    
    if (_passwordController.text.trim().isEmpty) {
      errors['password'] = 'Password is required';
    }

    if (errors.isNotEmpty) {
      setState(() {
        _fieldErrors = errors;
      });
      return;
    }

    // Submit the form
    widget.onSubmit?.call(
      _usernameController.text.trim(),
      _passwordController.text,
      _saveCredentials,
    );
  }

  String? _validateUsername(String? value) {
    final error = _fieldErrors['username'];
    if (error != null) {
      return error;
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final error = _fieldErrors['password'];
    if (error != null) {
      return error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: AppDimensions.dialogWidth,
      padding: AppDimensions.dialogPadding,
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title
            Text(
              'Local Authentication',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingS),

            // Subtitle
            Text(
              'Enter your local admin credentials',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: colors.textMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXl),

            // Error message
            if (widget.errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(AppDimensions.spacingM),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: AppDimensions.iconSizeM,
                    ),
                    const SizedBox(width: AppDimensions.spacingS),
                    Expanded(
                      child: Text(
                        widget.errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
            ],

            // Username field
            FormGroup(
              label: 'Username',
              child: TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  prefixIcon: const Icon(Icons.person_outline),
                  errorText: _validateUsername(_usernameController.text),
                ),
                validator: _validateUsername,
                textInputAction: TextInputAction.next,
                enabled: !widget.isLoading,
                onChanged: (value) {
                  if (_fieldErrors.containsKey('username')) {
                    setState(() {
                      _fieldErrors.remove('username');
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: AppDimensions.spacingL),

            // Password field
            FormGroup(
              label: 'Password',
              child: TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Enter password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  ),
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  errorText: _validatePassword(_passwordController.text),
                ),
                validator: _validatePassword,
                textInputAction: TextInputAction.done,
                enabled: !widget.isLoading,
                onFieldSubmitted: (_) => _validateAndSubmit(),
                onChanged: (value) {
                  if (_fieldErrors.containsKey('password')) {
                    setState(() {
                      _fieldErrors.remove('password');
                    });
                  }
                },
              ),
            ),

            // Save credentials checkbox
            if (widget.showSaveCredentials) ...[
              const SizedBox(height: AppDimensions.spacingL),
              Row(
                children: [
                  Checkbox(
                    value: _saveCredentials,
                    onChanged: widget.isLoading
                        ? null
                        : (value) {
                            setState(() {
                              _saveCredentials = value ?? false;
                            });
                          },
                  ),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(
                    child: GestureDetector(
                      onTap: widget.isLoading
                          ? null
                          : () {
                              setState(() {
                                _saveCredentials = !_saveCredentials;
                              });
                            },
                      child: Text(
                        'Save credentials for future logins',
                        style: TextStyle(
                          color: colors.textColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: AppDimensions.spacingXl),

            // Action buttons
            Row(
              children: [
                if (widget.onCancel != null) ...[
                  Expanded(
                    child: OutlineButton(
                      text: 'Cancel',
                      onPressed: widget.isLoading ? null : widget.onCancel!,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                ],
                Expanded(
                  child: PrimaryButton(
                    text: 'Sign In',
                    onPressed: widget.isLoading ? null : _validateAndSubmit,
                    isLoading: widget.isLoading,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
