import 'package:flutter/material.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/styleguide/component_display.dart';
import '../../widgets/styleguide/component_item.dart';
import '../../widgets/atoms/buttons/app_buttons.dart';
import '../../widgets/atoms/form_elements.dart';
import '../../widgets/atoms/status_dot.dart';
import '../../widgets/atoms/tag_chip.dart';
import '../../widgets/atoms/texts/app_text.dart';
import '../../widgets/atoms/integration_type_icon.dart';
import '../../widgets/atoms/sensitive_field_input.dart';
import '../../widgets/atoms/integration_status_badge.dart';

class AtomsPage extends StatefulWidget {
  const AtomsPage({super.key});

  @override
  AtomsPageState createState() => AtomsPageState();
}

class AtomsPageState extends State<AtomsPage> {
  String _dropdownValue = 'Option 1';
  bool _checkbox1Value = false;
  bool _checkbox2Value = true;
  String _radioValue = 'B';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppDimensions.spacingM),
      children: [
        ComponentDisplay(
          title: 'Buttons',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PrimaryButton(text: 'Primary'),
              const SizedBox(height: AppDimensions.spacingXs),
              const SecondaryButton(text: 'Secondary'),
              const SizedBox(height: AppDimensions.spacingXs),
              const OutlineButton(text: 'Outline'),
              const SizedBox(height: AppDimensions.spacingXs),
              const AppTextButton(text: 'Text'),
              const SizedBox(height: AppDimensions.spacingM),
              const BaseStyleButton(text: 'Base Button'),
              const SizedBox(height: AppDimensions.spacingXs),
              const RunButton(
                text: 'Run',
                icon: Icons.play_arrow,
              ),
              const SizedBox(height: AppDimensions.spacingM),
              Wrap(
                spacing: AppDimensions.spacingM,
                runSpacing: AppDimensions.spacingM,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const AppIconButton(
                    text: 'Settings',
                    icon: Icons.settings,
                  ),
                  const MediumBodyText('Dark Theme:'),
                  Theme(
                    data: ThemeData.dark(),
                    child: const AppIconButton(
                      text: 'Settings',
                      icon: Icons.settings,
                    ),
                  ),
                  const PrimaryButton(
                    text: 'Loading',
                    isLoading: true,
                  ),
                  const PrimaryButton(
                    text: 'Disabled',
                    isDisabled: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Form Inputs',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                width: AppDimensions.dialogWidth * 0.625, // 300px equivalent
                child: FormGroup(
                  label: 'Text Label',
                  child: TextInput(
                    placeholder: 'Enter text...',
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              const SizedBox(
                width: AppDimensions.dialogWidth * 0.625, // 300px equivalent
                child: FormGroup(
                  label: 'Password Label',
                  child: PasswordInput(
                    placeholder: 'Enter password...',
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              SizedBox(
                width: AppDimensions.dialogWidth * 0.625, // 300px equivalent
                child: FormGroup(
                  label: 'Select Label',
                  child: SelectDropdown(
                    value: _dropdownValue,
                    items: ['Option 1', 'Option 2', 'Option 3']
                        .map((String value) => DropdownMenuItem<String>(
                              value: value,
                              child: MediumBodyText(value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _dropdownValue = value ?? 'Option 1';
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Checkbox',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CheckboxInput(
                      label: 'Option 1 (Unchecked)',
                      value: _checkbox1Value,
                      onChanged: (value) {
                        setState(() {
                          _checkbox1Value = value ?? false;
                        });
                      },
                    ),
                    CheckboxInput(
                      label: 'Option 2 (Checked)',
                      value: _checkbox2Value,
                      onChanged: (value) {
                        setState(() {
                          _checkbox2Value = value ?? true;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Radio Buttons',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadioInput(
                      label: 'Option A',
                      value: 'A',
                      groupValue: _radioValue,
                      onChanged: (value) {
                        setState(() {
                          _radioValue = value ?? 'A';
                        });
                      },
                    ),
                    RadioInput(
                      label: 'Option B',
                      value: 'B',
                      groupValue: _radioValue,
                      onChanged: (value) {
                        setState(() {
                          _radioValue = value ?? 'B';
                        });
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Tags & Status',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ComponentItem(
                title: 'Status Dots',
                child: Wrap(
                  spacing: AppDimensions.spacingL,
                  runSpacing: AppDimensions.spacingM,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    StatusDot(status: StatusType.online, showLabel: true),
                    StatusDot(status: StatusType.offline, showLabel: true),
                    StatusDot(status: StatusType.warning, showLabel: true),
                    StatusDot(status: StatusType.error, showLabel: true),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spacingL),
              ComponentItem(
                title: 'Tags',
                child: Wrap(
                  spacing: AppDimensions.spacingXs,
                  runSpacing: AppDimensions.spacingXs,
                  children: [
                    TagChip(label: 'Default'),
                    TagChip(label: 'Primary'),
                    TagChip(label: 'Success', variant: TagChipVariant.success),
                    TagChip(label: 'Warning', variant: TagChipVariant.warning),
                    TagChip(label: 'Danger', variant: TagChipVariant.danger),
                    TagChip(
                      label: 'Removable',
                      // onDeleted: () {}, // Temporarily removed
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Links',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ComponentItem(
                title: 'View All Link',
                child: ViewAllLink(
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'OAuth Provider Buttons',
          child: SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OAuthProviderButton(
                  provider: OAuthProvider.google,
                  text: 'Continue with Google',
                ),
                SizedBox(height: AppDimensions.spacingM),
                OAuthProviderButton(
                  provider: OAuthProvider.microsoft,
                  text: 'Continue with Microsoft',
                ),
                SizedBox(height: AppDimensions.spacingM),
                OAuthProviderButton(
                  provider: OAuthProvider.github,
                  text: 'Continue with Github',
                ),
                SizedBox(height: AppDimensions.spacingM),
                OAuthProviderButton(
                  provider: OAuthProvider.google,
                  text: 'Loading...',
                  isLoading: true,
                ),
                SizedBox(height: AppDimensions.spacingM),
                OAuthProviderButton(
                  provider: OAuthProvider.google,
                  text: 'Disabled',
                  isDisabled: true,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Integration Type Icons',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Icons for different integration types with fallback support.'),
              SizedBox(height: AppDimensions.spacingM),
              Wrap(
                spacing: AppDimensions.spacingL,
                runSpacing: AppDimensions.spacingM,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IntegrationTypeIcon(integrationType: 'github'),
                  IntegrationTypeIcon(integrationType: 'slack'),
                  IntegrationTypeIcon(integrationType: 'google'),
                  IntegrationTypeIcon(integrationType: 'microsoft'),
                  IntegrationTypeIcon(integrationType: 'jira'),
                  IntegrationTypeIcon(integrationType: 'unknown'),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        const ComponentDisplay(
          title: 'Integration Status Badges',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Status indicators for integrations with appropriate colors.'),
              SizedBox(height: AppDimensions.spacingM),
              Wrap(
                spacing: AppDimensions.spacingL,
                runSpacing: AppDimensions.spacingM,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  IntegrationStatusBadge(status: IntegrationStatus.enabled),
                  IntegrationStatusBadge(status: IntegrationStatus.disabled),
                  IntegrationStatusBadge(status: IntegrationStatus.error),
                  IntegrationStatusBadge(status: IntegrationStatus.testing),
                  IntegrationStatusBadge(status: IntegrationStatus.connected),
                  IntegrationStatusBadge(status: IntegrationStatus.disconnected),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDimensions.spacingXl),
        ComponentDisplay(
          title: 'Sensitive Field Input',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Secure input fields for API keys and sensitive data with toggle visibility.'),
              const SizedBox(height: AppDimensions.spacingM),
              SizedBox(
                width: 400,
                child: SensitiveFieldInput(
                  placeholder: 'Enter your API key...',
                  controller: TextEditingController(text: 'sk-1234567890abcdef'),
                ),
              ),
              const SizedBox(height: AppDimensions.spacingM),
              const SizedBox(
                width: 400,
                child: SensitiveFieldInput(
                  placeholder: 'Enter your access token...',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
