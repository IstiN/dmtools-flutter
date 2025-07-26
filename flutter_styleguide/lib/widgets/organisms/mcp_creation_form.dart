import 'package:flutter/material.dart';
import 'package:dmtools_styleguide/dmtools_styleguide.dart';

/// Form validation states
enum McpFormValidationState { valid, invalid, pending }

/// Progress states for form submission
enum McpFormSubmissionState { idle, submitting, success, error }

/// Complete creation form for MCP configurations
///
/// This organism provides name input, integration selection with validation,
/// and form submission handling. Includes responsive layout and error handling.
class McpCreationForm extends StatefulWidget {
  const McpCreationForm({
    required this.availableIntegrations,
    this.initialName = '',
    this.initialSelectedIntegrations = const [],
    this.onSubmit,
    this.onCancel,
    this.submissionState = McpFormSubmissionState.idle,
    this.errorMessage,
    this.nameValidator,
    this.integrationValidator,
    this.showCancelButton = true,
    this.submitButtonText = 'Create MCP Configuration',
    this.cancelButtonText = 'Cancel',
    super.key,
  });

  final List<IntegrationOption> availableIntegrations;
  final String initialName;
  final List<String> initialSelectedIntegrations;
  final Function(String name, List<String> integrations)? onSubmit;
  final VoidCallback? onCancel;
  final McpFormSubmissionState submissionState;
  final String? errorMessage;
  final String? Function(String)? nameValidator;
  final String? Function(List<String>)? integrationValidator;
  final bool showCancelButton;
  final String submitButtonText;
  final String cancelButtonText;

  @override
  State<McpCreationForm> createState() => _McpCreationFormState();
}

class _McpCreationFormState extends State<McpCreationForm> {
  late TextEditingController _nameController;
  late List<String> _selectedIntegrations;
  final _formKey = GlobalKey<FormState>();

  String? _nameError;
  String? _integrationError;
  bool _hasValidated = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _selectedIntegrations = List.from(widget.initialSelectedIntegrations);
    _nameController.addListener(_onNameChanged);
  }

  @override
  void didUpdateWidget(McpCreationForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialName != widget.initialName) {
      _nameController.text = widget.initialName;
    }
    if (oldWidget.initialSelectedIntegrations != widget.initialSelectedIntegrations) {
      _selectedIntegrations = List.from(widget.initialSelectedIntegrations);
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_onNameChanged);
    _nameController.dispose();
    super.dispose();
  }

  void _onNameChanged() {
    if (_hasValidated) {
      _validateForm();
    }
  }

  void _onIntegrationChanged(String integration, bool selected) {
    setState(() {
      if (selected) {
        _selectedIntegrations.add(integration);
      } else {
        _selectedIntegrations.remove(integration);
      }
    });

    if (_hasValidated) {
      _validateForm();
    }
  }

  bool _validateForm() {
    setState(() {
      _hasValidated = true;

      // Validate name
      final name = _nameController.text.trim();
      if (widget.nameValidator != null) {
        _nameError = widget.nameValidator!(name);
      } else {
        _nameError = _defaultNameValidator(name);
      }

      // Validate integrations
      if (widget.integrationValidator != null) {
        _integrationError = widget.integrationValidator!(_selectedIntegrations);
      } else {
        _integrationError = _defaultIntegrationValidator(_selectedIntegrations);
      }
    });

    return _nameError == null && _integrationError == null;
  }

  String? _defaultNameValidator(String name) {
    if (name.isEmpty) {
      return 'Configuration name is required';
    }
    if (name.length < 3) {
      return 'Name must be at least 3 characters long';
    }
    if (name.length > 50) {
      return 'Name must be 50 characters or less';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s\-_]+$').hasMatch(name)) {
      return 'Name can only contain letters, numbers, spaces, hyphens, and underscores';
    }
    return null;
  }

  String? _defaultIntegrationValidator(List<String> integrations) {
    if (integrations.isEmpty) {
      return 'Please select at least one integration';
    }
    return null;
  }

  void _handleSubmit() {
    if (_validateForm() && widget.onSubmit != null) {
      widget.onSubmit!(_nameController.text.trim(), _selectedIntegrations);
    }
  }

  McpFormValidationState get _validationState {
    if (!_hasValidated) return McpFormValidationState.pending;
    return (_nameError == null && _integrationError == null)
        ? McpFormValidationState.valid
        : McpFormValidationState.invalid;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isSubmitting = widget.submissionState == McpFormSubmissionState.submitting;
    final canSubmit = _validationState == McpFormValidationState.valid && !isSubmitting;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _FormHeader(
            title: 'Create MCP Configuration',
            subtitle: 'Configure integrations for your Model Context Protocol setup',
            colors: colors,
          ),
          const SizedBox(height: 24),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _NameSection(controller: _nameController, error: _nameError, enabled: !isSubmitting, colors: colors),
                  const SizedBox(height: 24),

                  _IntegrationSection(
                    availableIntegrations: widget.availableIntegrations,
                    selectedIntegrations: _selectedIntegrations,
                    onIntegrationChanged: _onIntegrationChanged,
                    error: _integrationError,
                    enabled: !isSubmitting,
                    colors: colors,
                  ),

                  if (widget.errorMessage != null) ...[
                    const SizedBox(height: 24),
                    _ErrorMessage(message: widget.errorMessage!, colors: colors),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          _ActionSection(
            onSubmit: canSubmit ? _handleSubmit : null,
            onCancel: widget.onCancel,
            submissionState: widget.submissionState,
            showCancelButton: widget.showCancelButton,
            submitButtonText: widget.submitButtonText,
            cancelButtonText: widget.cancelButtonText,
            colors: colors,
          ),
        ],
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader({required this.title, required this.subtitle, required this.colors});

  final String title;
  final String subtitle;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border(bottom: BorderSide(color: colors.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
          ),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 16, color: colors.textColor.withOpacity(0.7))),
        ],
      ),
    );
  }
}

class _NameSection extends StatelessWidget {
  const _NameSection({required this.controller, required this.error, required this.enabled, required this.colors});

  final TextEditingController controller;
  final String? error;
  final bool enabled;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Configuration Name',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose a descriptive name for your MCP configuration',
          style: TextStyle(fontSize: 14, color: colors.textColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: InputDecoration(
            hintText: 'e.g., Development Environment',
            errorText: error,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.accentColor, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colors.dangerColor, width: 2),
            ),
            filled: true,
            fillColor: enabled ? colors.bgColor : colors.bgColor.withOpacity(0.5),
            prefixIcon: Icon(
              Icons.label_outline,
              color: enabled ? colors.textColor.withOpacity(0.6) : colors.textColor.withOpacity(0.3),
            ),
          ),
          style: TextStyle(color: enabled ? colors.textColor : colors.textColor.withOpacity(0.5)),
        ),
      ],
    );
  }
}

class _IntegrationSection extends StatelessWidget {
  const _IntegrationSection({
    required this.availableIntegrations,
    required this.selectedIntegrations,
    required this.onIntegrationChanged,
    required this.error,
    required this.enabled,
    required this.colors,
  });

  final List<IntegrationOption> availableIntegrations;
  final List<String> selectedIntegrations;
  final Function(String, bool) onIntegrationChanged;
  final String? error;
  final bool enabled;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Integrations',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: colors.textColor),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose which integrations to include in your MCP configuration',
          style: TextStyle(fontSize: 14, color: colors.textColor.withOpacity(0.7)),
        ),
        const SizedBox(height: 16),

        RequiredIntegrationSelection(
          title: 'Required Integrations',
          subtitle: 'Choose which integrations to include in your MCP configuration',
          integrations: availableIntegrations,
          selectedIntegrations: selectedIntegrations.toSet(),
          onIntegrationChanged: (integration) {
            onIntegrationChanged(integration, !selectedIntegrations.contains(integration));
          },
        ),

        if (error != null) ...[
          const SizedBox(height: 8),
          Text(error!, style: TextStyle(fontSize: 12, color: colors.dangerColor)),
        ],
      ],
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message, required this.colors});

  final String message;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.dangerColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.dangerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colors.dangerColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(message, style: TextStyle(color: colors.dangerColor, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    required this.onSubmit,
    required this.onCancel,
    required this.submissionState,
    required this.showCancelButton,
    required this.submitButtonText,
    required this.cancelButtonText,
    required this.colors,
  });

  final VoidCallback? onSubmit;
  final VoidCallback? onCancel;
  final McpFormSubmissionState submissionState;
  final bool showCancelButton;
  final String submitButtonText;
  final String cancelButtonText;
  final ThemeColorSet colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colors.cardBg,
        border: Border(top: BorderSide(color: colors.borderColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (submissionState == McpFormSubmissionState.submitting) ...[
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: colors.accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(colors.accentColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Creating configuration...',
                    style: TextStyle(color: colors.accentColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              children: [
                if (showCancelButton) ...[
                  Expanded(
                    child: SecondaryButton(
                      text: cancelButtonText,
                      onPressed: submissionState == McpFormSubmissionState.submitting ? null : onCancel,
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spacingM),
                ],
                Expanded(
                  child: PrimaryButton(
                    text: submitButtonText,
                    onPressed: submissionState == McpFormSubmissionState.submitting ? null : (onSubmit ?? () {}),
                  ),
                ),
              ],
            ),
          ],

          if (submissionState == McpFormSubmissionState.success) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colors.successColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: colors.successColor.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: colors.successColor, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Configuration created successfully!',
                    style: TextStyle(color: colors.successColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
