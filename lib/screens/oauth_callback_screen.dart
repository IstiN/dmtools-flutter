import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

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

  @override
  void initState() {
    super.initState();
    // Delay callback handling until after build is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleCallback();
    });
  }

  Future<void> _handleCallback() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final tempCode = widget.callbackUri.queryParameters['code'];

    if (kDebugMode) {
      print('🔄 OAuth Callback Screen handling URI: ${widget.callbackUri}');
      print('📋 Query parameters: ${widget.callbackUri.queryParameters}');
    }

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
        context.go('/dashboard');
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
          context.go('/dashboard');
        } else {
          context.go('/unauthenticated');
        }
      }
      return;
    }

    // Mark this callback code as being processed
    if (tempCode != null) {
      OAuthCallbackScreen._processedCallbackCode = tempCode;
    }

    try {
      final success = await authProvider.handleCallback(widget.callbackUri).timeout(
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

            // Navigate to dashboard on successful authentication
            context.go('/dashboard');
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
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isProcessing) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                const Text(
                  'Completing authentication...',
                  style: TextStyle(fontSize: 16),
                ),
              ] else if (_error != null) ...[
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 64,
                ),
                const SizedBox(height: 24),
                Text(
                  'Authentication Failed',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context.go('/unauthenticated');
                  },
                  child: const Text('Try Again'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
