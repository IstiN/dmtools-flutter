import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/enhanced_auth_provider.dart';
import '../service_locator.dart';

// Conditional imports for web-specific functionality
import 'oauth_callback_web.dart' if (dart.library.io) 'oauth_callback_stub.dart';

class OAuthCallbackScreen extends StatefulWidget {
  // Global flag to prevent duplicate processing of the same callback
  static String? _processedCallbackCode;
  final Uri callbackUri;

  const OAuthCallbackScreen({
    required this.callbackUri,
    super.key,
  });

  @override
  State<OAuthCallbackScreen> createState() => _OAuthCallbackScreenState();
}

class _OAuthCallbackScreenState extends State<OAuthCallbackScreen> {
  bool _isProcessing = true;
  String? _error;
  String _currentStep = 'Initializing authentication...';

  @override
  void initState() {
    super.initState();
    // Delay callback handling until after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleCallback();
    });
  }

  void _updateStep(String step) {
    if (mounted) {
      setState(() {
        _currentStep = step;
      });
    }
  }

  Future<void> _handleCallback() async {
    final authProvider = Provider.of<EnhancedAuthProvider>(context, listen: false);
    final router = GoRouter.of(context);
    final tempCode = widget.callbackUri.queryParameters['code'];

    if (kDebugMode) {
      print('🔄 OAuth Callback Screen handling URI: ${widget.callbackUri}');
      print('📋 Query parameters: ${widget.callbackUri.queryParameters}');
    }

    _updateStep('Checking authentication status...');

    // Don't process callback if already authenticated
    if (authProvider.isAuthenticated) {
      if (kDebugMode) {
        print('✅ Already authenticated, navigating to dashboard');
      }
      if (mounted) {
        // Clear OAuth parameters from window (web only)
        if (kIsWeb) {
          clearOAuthParamsFromWindow();
          cleanupOAuthUrl();
        }
        router.go('/dashboard');
      }
      return;
    }

    // Don't process the same callback code twice
    if (tempCode != null && OAuthCallbackScreen._processedCallbackCode == tempCode) {
      if (kDebugMode) {
        print('⚠️ Callback code already processed, skipping');
      }
      if (mounted) {
        // Clean up OAuth callback URL parameters (web only)
        if (kIsWeb) {
          cleanupOAuthUrl();
        }

        // Redirect based on current auth state
        if (authProvider.isAuthenticated) {
          router.go('/dashboard');
        } else {
          router.go('/unauthenticated');
        }
      }
      return;
    }

    // Mark this callback code as being processed
    if (tempCode != null) {
      OAuthCallbackScreen._processedCallbackCode = tempCode;
    }

    try {
      _updateStep('Processing OAuth callback...');

      final success = await authProvider.handleOAuthCallback(widget.callbackUri).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          if (kDebugMode) {
            print('⏰ OAuth callback timed out after 30 seconds');
          }
          return false;
        },
      );

      if (mounted) {
        if (success) {
          _updateStep('Authentication successful! Redirecting...');

          if (kDebugMode) {
            print('✅ OAuth callback successful, navigating to dashboard');
          }
          // Clear the processed callback code on success
          OAuthCallbackScreen._processedCallbackCode = null;

          if (kDebugMode) {
            print('🎉 OAuth authentication successful, cleaning up URL and redirecting');
          }

          // Clean up OAuth callback URL parameters first (web only)
          if (kIsWeb) {
            cleanupOAuthUrl();
            // Small delay to ensure URL cleanup is processed
            await Future.delayed(const Duration(milliseconds: 100));
          }

          // Check if widget is still mounted before using context
          if (mounted) {
            // Clear OAuth parameters from window (web only)
            if (kIsWeb) {
              clearOAuthParamsFromWindow();
            }

            _updateStep('Loading user information...');

            // Load user info from API
            await ServiceLocator.initializeUserInfo();

            // Navigate to AI Jobs on successful authentication
            router.go('/ai-jobs');
          }
        } else {
          if (kDebugMode) {
            print('❌ OAuth callback failed: ${authProvider.error}');
          }
          // Clear the processed callback code on failure so user can retry
          OAuthCallbackScreen._processedCallbackCode = null;

          // Clear OAuth parameters from window (web only)
          if (kIsWeb) {
            clearOAuthParamsFromWindow();
          }

          setState(() {
            _error = authProvider.error ?? 'Authentication failed or timed out';
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ OAuth callback exception: $e');
      }
      if (mounted) {
        // Clear the processed callback code on exception so user can retry
        OAuthCallbackScreen._processedCallbackCode = null;

        // Clear OAuth parameters from window (web only)
        if (kIsWeb) {
          clearOAuthParamsFromWindow();
        }

        setState(() {
          _error = 'Authentication failed: $e';
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            width: 480,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isProcessing) ...[
                  // Loading animation
                  SizedBox(
                    width: 64,
                    height: 64,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Title
                  Text(
                    'Completing Authentication',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Step description
                  Text(
                    _currentStep,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyMedium?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Progress steps
                  _buildProgressSteps(),
                ] else if (_error != null) ...[
                  // Error state
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 64,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Authentication Failed',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).go('/unauthenticated');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Try Again'),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSteps() {
    final theme = Theme.of(context);
    final steps = [
      'Validating OAuth code',
      'Exchanging for access token',
      'Fetching user information',
      'Validating authentication',
      'Completing sign-in',
    ];

    return Column(
      children: steps.map((step) {
        final isActive = _currentStep.toLowerCase().contains(step.toLowerCase().split(' ')[0]);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: isActive ? theme.primaryColor : theme.dividerColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  step,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isActive ? theme.primaryColor : theme.textTheme.bodyMedium?.color,
                    fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
