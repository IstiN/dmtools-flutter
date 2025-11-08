import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';
import '../providers/enhanced_auth_provider.dart';

class LocalLoginForm extends StatefulWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onSuccess;

  const LocalLoginForm({
    this.onCancel,
    this.onSuccess,
    super.key,
  });

  @override
  State<LocalLoginForm> createState() => _LocalLoginFormState();
}

class _LocalLoginFormState extends State<LocalLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocusNode = FocusNode();
  bool _saveCredentials = true; // Default to true for better UX
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
    // Focus username field after dialog is shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _usernameFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loadSavedCredentials() async {
    final authProvider = context.read<EnhancedAuthProvider>();
    final savedCredentials = await authProvider.getSavedCredentials();

    if (savedCredentials != null && mounted) {
      setState(() {
        _usernameController.text = savedCredentials.username;
        _passwordController.text = savedCredentials.password;
        _saveCredentials = true;
      });
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<EnhancedAuthProvider>();

    final success = await authProvider.loginWithCredentials(
      _usernameController.text.trim(),
      _passwordController.text,
      saveCredentials: _saveCredentials,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        widget.onSuccess?.call();
      }
      // Error handling is done through the provider's error state
    }
  }

  String? _validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your username';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Consumer<EnhancedAuthProvider>(
      builder: (context, authProvider, child) {
        return Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: colors.borderColor),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.login,
                      color: colors.accentColor,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Local Login',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: colors.textColor,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Username field
                TextFormField(
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    prefixIcon: Icon(Icons.person_outline, color: colors.textSecondary),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colors.accentColor, width: 2),
                    ),
                  ),
                  validator: _validateUsername,
                  textInputAction: TextInputAction.next,
                  enabled: !_isLoading,
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    prefixIcon: Icon(Icons.lock_outline, color: colors.textSecondary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: colors.textSecondary,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: colors.accentColor, width: 2),
                    ),
                  ),
                  validator: _validatePassword,
                  textInputAction: TextInputAction.done,
                  obscureText: _obscurePassword,
                  enabled: !_isLoading,
                  onFieldSubmitted: (_) => _handleLogin(),
                ),
                const SizedBox(height: 16),

                // Save credentials checkbox
                CheckboxListTile(
                  value: _saveCredentials,
                  onChanged: _isLoading
                      ? null
                      : (value) {
                          setState(() {
                            _saveCredentials = value ?? false;
                          });
                        },
                  title: Text(
                    'Save login credentials',
                    style: TextStyle(color: colors.textColor),
                  ),
                  subtitle: Text(
                    'Credentials will be stored securely on this device',
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                  activeColor: colors.accentColor,
                ),

                // Error message
                if (authProvider.hasError) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authProvider.error ?? 'An error occurred',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Action buttons
                Row(
                  children: [
                    if (widget.onCancel != null) ...[
                      Expanded(
                        child: OutlineButton(
                          onPressed: _isLoading ? null : widget.onCancel,
                          text: 'Cancel',
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: PrimaryButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        text: _isLoading ? 'Signing in...' : 'Sign In',
                        isLoading: _isLoading,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
