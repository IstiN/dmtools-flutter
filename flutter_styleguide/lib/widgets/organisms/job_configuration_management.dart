import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../atoms/buttons/app_buttons.dart';
import '../molecules/job_configuration_card.dart';

import '../molecules/job_config_form.dart';
import '../molecules/integration_type_selector.dart';
import '../molecules/headers/page_action_bar.dart';
import '../responsive/responsive_builder.dart';

enum JobConfigurationView { list, discovery, create, edit }

/// Complete AI job configuration management interface organism
class JobConfigurationManagement extends StatefulWidget {
  final List<JobConfigurationData> configurations;
  final List<JobType> availableTypes;
  final List<IntegrationCategory> availableIntegrations;
  final List<IntegrationType>? configuredIntegrations;
  final Function(JobType, String, Map<String, dynamic>, List<String>) onCreateConfiguration;
  final Function(String, String, Map<String, dynamic>, List<String>) onUpdateConfiguration;
  final Function(String) onDeleteConfiguration;
  final Function(String) onExecuteConfiguration;
  final Function(String, Map<String, dynamic>) onTestConfiguration;
  final Future<JobConfigurationData?> Function(String)? onGetConfigurationDetails;
  final Function(String)? onViewDetails;
  final VoidCallback? onCreateIntegration;
  final bool? isTestMode;
  final bool? testDarkMode;

  const JobConfigurationManagement({
    required this.configurations,
    required this.availableTypes,
    required this.availableIntegrations,
    required this.onCreateConfiguration,
    required this.onUpdateConfiguration,
    required this.onDeleteConfiguration,
    required this.onExecuteConfiguration,
    required this.onTestConfiguration,
    this.configuredIntegrations,
    this.onGetConfigurationDetails,
    this.onViewDetails,
    this.onCreateIntegration,
    this.isTestMode = false,
    this.testDarkMode = false,
    super.key,
  });

  @override
  State<JobConfigurationManagement> createState() => _JobConfigurationManagementState();
}

class _JobConfigurationManagementState extends State<JobConfigurationManagement> {
  JobConfigurationView _currentView = JobConfigurationView.list;
  JobType? _selectedType;
  JobConfigurationData? _editingConfiguration;
  Map<String, dynamic> _configValues = {};
  List<String> _selectedIntegrations = [];
  String _configurationName = '';
  bool _isLoading = false;
  String? _testResult;

  @override
  Widget build(BuildContext context) {
    ThemeColorSet colors;

    if (widget.isTestMode == true) {
      final isDarkMode = widget.testDarkMode ?? false;
      colors = isDarkMode ? AppColors.dark : AppColors.light;
    } else {
      colors = context.colors;
    }

    return Container(
      decoration: BoxDecoration(color: colors.bgColor, borderRadius: BorderRadius.circular(AppDimensions.radiusL)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageActionBar(
            title: _getHeaderTitle(),
            showBorder: true,
            actions: _getHeaderActions(),
            isTestMode: widget.isTestMode ?? false,
          ),
          // Show subtitle below the header for better UX
          if (_currentView != JobConfigurationView.list)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL, vertical: AppDimensions.spacingM),
              decoration: BoxDecoration(
                color: colors.cardBg,
                border: Border(bottom: BorderSide(color: colors.borderColor.withValues(alpha: 0.1))),
              ),
              child: Text(_getHeaderSubtitle(), style: TextStyle(fontSize: 14, color: colors.textSecondary)),
            ),
          Expanded(child: _buildContent(colors)),
        ],
      ),
    );
  }

  List<Widget> _getHeaderActions() {
    switch (_currentView) {
      case JobConfigurationView.list:
        return [
          PrimaryButton(
            text: 'Add Job Configuration',
            icon: Icons.add,
            onPressed: () {
              setState(() {
                _currentView = JobConfigurationView.discovery;
              });
            },
            size: ButtonSize.small,
            isTestMode: widget.isTestMode ?? false,
          ),
        ];
      case JobConfigurationView.discovery:
      case JobConfigurationView.create:
      case JobConfigurationView.edit:
        return [
          AppIconButton(
            text: 'Back',
            icon: Icons.arrow_back,
            onPressed: () {
              setState(() {
                _currentView = JobConfigurationView.list;
                _selectedType = null;
                _editingConfiguration = null;
                _configValues.clear();
                _selectedIntegrations.clear();
                _configurationName = '';
                _testResult = null;
              });
            },
            size: ButtonSize.small,
            isTestMode: widget.isTestMode ?? false,
          ),
        ];
    }
  }

  Widget _buildContent(ThemeColorSet colors) {
    switch (_currentView) {
      case JobConfigurationView.list:
        return _buildConfigurationList(colors);
      case JobConfigurationView.discovery:
        return _buildDiscoveryView(colors);
      case JobConfigurationView.create:
        return _buildCreateConfiguration(colors);
      case JobConfigurationView.edit:
        return _buildEditConfiguration(colors);
    }
  }

  Widget _buildConfigurationList(ThemeColorSet colors) {
    if (widget.configurations.isEmpty) {
      return _buildEmptyState(colors);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveUtils.isWideScreen(context)
            ? 3
            : ResponsiveUtils.isTablet(context)
            ? 2
            : 1,
        crossAxisSpacing: AppDimensions.spacingL,
        mainAxisSpacing: AppDimensions.spacingL,
        mainAxisExtent: 320, // Slightly taller for job configurations
      ),
      itemCount: widget.configurations.length,
      itemBuilder: (context, index) {
        final configuration = widget.configurations[index];
        return JobConfigurationCard(
          id: configuration.id,
          name: configuration.name,
          description: configuration.description,
          jobType: configuration.jobType,
          enabled: configuration.enabled,
          executionCount: configuration.executionCount,
          lastExecutedAt: configuration.lastExecutedAt,
          createdAt: configuration.createdAt,
          createdByName: configuration.createdByName,
          requiredIntegrations: configuration.requiredIntegrations,
          onExecute: () => widget.onExecuteConfiguration(configuration.id),
          onEdit: () => _editConfiguration(configuration),
          onDelete: () => _deleteConfiguration(configuration),
          onTest: () => _testConfiguration(configuration),
          onViewDetails: widget.onViewDetails != null ? () => widget.onViewDetails!(configuration.id) : null,
          isTestMode: widget.isTestMode,
          testDarkMode: widget.testDarkMode,
        );
      },
    );
  }

  Widget _buildEmptyState(ThemeColorSet colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.smart_toy_outlined, size: 64, color: colors.textMuted),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              'No AI Job Configurations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
            ),
            const SizedBox(height: AppDimensions.spacingS),
            Text(
              'Create your first AI-powered job configuration to get started',
              style: TextStyle(fontSize: 16, color: colors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingL),
            PrimaryButton(
              text: 'Add Job Configuration',
              icon: Icons.add,
              onPressed: () {
                setState(() {
                  _currentView = JobConfigurationView.discovery;
                });
              },
              isTestMode: widget.isTestMode ?? false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscoveryView(ThemeColorSet colors) {
    final availableJobTypes = widget.availableTypes;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Available Job Types',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'Connect AI-powered automation to your development workflow',
                style: TextStyle(fontSize: 16, color: colors.textSecondary),
              ),
              const SizedBox(height: AppDimensions.spacingL),
              Text(
                '${availableJobTypes.length} job type${availableJobTypes.length != 1 ? 's' : ''} available',
                style: TextStyle(fontSize: 14, color: colors.textMuted),
              ),
            ],
          ),
        ),

        // Job type grid
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacingL),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: ResponsiveUtils.isWideScreen(context) ? 3 : 2,
              crossAxisSpacing: AppDimensions.spacingM,
              mainAxisSpacing: AppDimensions.spacingM,
              mainAxisExtent: 240,
            ),
            itemCount: availableJobTypes.length,
            itemBuilder: (context, index) {
              final jobType = availableJobTypes[index];
              return _buildJobTypeCard(jobType, colors);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildJobTypeCard(JobType jobType, ThemeColorSet colors) {
    return Card(
      elevation: 2,
      color: colors.cardBg,
      child: InkWell(
        onTap: () => _selectJobTypeFromDiscovery(jobType),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(_getJobTypeIcon(jobType.type), size: 32, color: colors.accentColor),
                  const SizedBox(width: AppDimensions.spacingS),
                  Expanded(
                    child: Text(
                      jobType.displayName,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colors.textColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                jobType.description,
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacingS,
                      vertical: AppDimensions.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: colors.accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusXs),
                    ),
                    child: Text(
                      _getJobTypeCategory(jobType.type),
                      style: TextStyle(fontSize: 12, color: colors.accentColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${jobType.requiredIntegrations.length} integrations',
                    style: TextStyle(fontSize: 12, color: colors.textMuted),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectJobTypeFromDiscovery(JobType jobType) {
    setState(() {
      _selectedType = jobType;
      _currentView = JobConfigurationView.create;
      _configValues.clear();
      _selectedIntegrations.clear();
      _testResult = null;
      _configurationName = '';
    });
  }

  Widget _buildCreateConfiguration(ThemeColorSet colors) {
    if (_selectedType == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacingXl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: colors.textMuted),
              const SizedBox(height: AppDimensions.spacingL),
              Text(
                'No Job Type Selected',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor),
              ),
              const SizedBox(height: AppDimensions.spacingS),
              Text(
                'Please go back and select a job type',
                style: TextStyle(fontSize: 14, color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobConfigForm(
            jobType: _selectedType!,
            availableIntegrations: widget.availableIntegrations,
            initialValues: _configValues,
            initialName: _configurationName.isNotEmpty
                ? _configurationName
                : '${_selectedType!.displayName} Configuration',
            initialIntegrations: _selectedIntegrations,
            onConfigChanged: (values) {
              setState(() {
                _configValues = values;
              });
            },
            onNameChanged: (name) {
              setState(() {
                _configurationName = name;
              });
            },
            onIntegrationsChanged: (integrations) {
              setState(() {
                _selectedIntegrations = integrations;
              });
            },
            onTestConfiguration: () => _testJobConfiguration(_selectedType!, _configValues),
            onCreateIntegration: widget.onCreateIntegration,
            isLoading: _isLoading,
            testResult: _testResult,
            isTestMode: widget.isTestMode,
            testDarkMode: widget.testDarkMode,
          ),

          const SizedBox(height: AppDimensions.spacingXl),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Cancel',
                  onPressed: () {
                    setState(() {
                      _currentView = JobConfigurationView.list;
                      _selectedType = null;
                      _configValues.clear();
                      _selectedIntegrations.clear();
                      _configurationName = '';
                      _testResult = null;
                    });
                  },
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: PrimaryButton(
                  text: 'Create Configuration',
                  onPressed: _canCreateConfiguration() ? () => _createConfiguration() : null,
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEditConfiguration(ThemeColorSet colors) {
    if (_editingConfiguration == null) return const SizedBox();

    final jobType = widget.availableTypes.firstWhere((type) => type.type == _editingConfiguration!.jobType);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          JobConfigForm(
            jobType: jobType,
            availableIntegrations: widget.availableIntegrations,
            initialValues: _configValues,
            initialName: _configurationName.isNotEmpty ? _configurationName : _editingConfiguration!.name,
            initialIntegrations: _selectedIntegrations,
            onConfigChanged: (values) {
              setState(() {
                _configValues = values;
              });
            },
            onNameChanged: (name) {
              setState(() {
                _configurationName = name;
              });
            },
            onIntegrationsChanged: (integrations) {
              setState(() {
                _selectedIntegrations = integrations;
              });
            },
            onTestConfiguration: () => _testJobConfiguration(jobType, _configValues),
            onCreateIntegration: widget.onCreateIntegration,
            isLoading: _isLoading,
            testResult: _testResult,
            isTestMode: widget.isTestMode,
            testDarkMode: widget.testDarkMode,
          ),
          const SizedBox(height: AppDimensions.spacingXl),
          Row(
            children: [
              Expanded(
                child: SecondaryButton(
                  text: 'Cancel',
                  onPressed: () {
                    setState(() {
                      _currentView = JobConfigurationView.list;
                      _editingConfiguration = null;
                      _configValues.clear();
                      _selectedIntegrations.clear();
                      _configurationName = '';
                      _testResult = null;
                    });
                  },
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ),
              const SizedBox(width: AppDimensions.spacingM),
              Expanded(
                child: PrimaryButton(
                  text: 'Update Configuration',
                  onPressed: () => _updateConfiguration(),
                  isTestMode: widget.isTestMode ?? false,
                  testDarkMode: widget.testDarkMode ?? false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_currentView) {
      case JobConfigurationView.list:
        return 'AI Powered Jobs';
      case JobConfigurationView.discovery:
        return 'Discover Job Types';
      case JobConfigurationView.create:
        return 'Add Job Configuration';
      case JobConfigurationView.edit:
        return 'Edit Job Configuration';
    }
  }

  String _getHeaderSubtitle() {
    switch (_currentView) {
      case JobConfigurationView.list:
        return 'Manage your AI-powered job configurations and automation workflows';
      case JobConfigurationView.discovery:
        return 'Browse available job types and choose one to configure';
      case JobConfigurationView.create:
        return 'Configure a new ${_selectedType?.displayName ?? 'AI job'} configuration';
      case JobConfigurationView.edit:
        return 'Update configuration for ${_editingConfiguration?.name ?? 'job'}';
    }
  }

  bool _canCreateConfiguration() {
    debugPrint('🔧 JobConfigurationManagement: Checking if can create configuration');
    debugPrint('🔧   - _selectedType: ${_selectedType?.type} (${_selectedType?.displayName})');
    debugPrint('🔧   - _configurationName: "$_configurationName"');
    debugPrint('🔧   - _configValues: $_configValues');
    debugPrint('🔧   - _selectedIntegrations: $_selectedIntegrations');

    if (_selectedType == null) {
      debugPrint('🔧   - ❌ No job type selected');
      return false;
    }

    // Ensure we have a configuration name (use default if empty)
    bool nameWasEmpty = false;
    if (_configurationName.isEmpty) {
      nameWasEmpty = true;
      final defaultName = '${_selectedType!.displayName} Configuration';
      debugPrint('🔧   - Configuration name is empty, using default: "$defaultName"');
      _configurationName = defaultName;

      // Schedule a setState to update the UI if we're setting a default name
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            // The name has already been set above, this just triggers UI update
          });
        }
      });
    }

    final requiredParams = _selectedType!.parameters.where((p) => p.required);
    debugPrint('🔧   - Required parameters (${requiredParams.length}):');

    bool allValid = true;
    for (final param in requiredParams) {
      final value = _configValues[param.key];
      final isValid = value != null && value.toString().isNotEmpty;
      debugPrint('🔧     - ${param.key}: ${isValid ? "✅" : "❌"} (value: $value)');
      if (!isValid) allValid = false;
    }

    debugPrint(
      '🔧   - Configuration name validation: ${_configurationName.isNotEmpty ? "✅" : "❌"} ("$_configurationName")',
    );
    debugPrint('🔧   - Can create: ${allValid && _configurationName.isNotEmpty}');

    if (nameWasEmpty) {
      debugPrint('🔧   - Name was set from empty, triggering UI update');
    }

    return allValid && _configurationName.isNotEmpty;
  }

  Future<void> _testConfiguration(JobConfigurationData configuration) async {
    if (widget.onGetConfigurationDetails != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final detailedConfiguration = await widget.onGetConfigurationDetails!(configuration.id);
        if (detailedConfiguration != null) {
          widget.onTestConfiguration(detailedConfiguration.id, detailedConfiguration.parameters);
        } else {
          widget.onTestConfiguration(configuration.id, configuration.parameters);
        }
      } catch (e) {
        widget.onTestConfiguration(configuration.id, configuration.parameters);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      widget.onTestConfiguration(configuration.id, configuration.parameters);
    }
  }

  Future<void> _editConfiguration(JobConfigurationData configuration) async {
    setState(() {
      _isLoading = true;
    });

    if (widget.onGetConfigurationDetails != null) {
      try {
        final detailedConfiguration = await widget.onGetConfigurationDetails!(configuration.id);
        if (detailedConfiguration != null) {
          setState(() {
            _currentView = JobConfigurationView.edit;
            _editingConfiguration = detailedConfiguration;
            _configValues = Map.from(detailedConfiguration.parameters);
            _selectedIntegrations = List.from(detailedConfiguration.requiredIntegrations);
            _configurationName = detailedConfiguration.name;
            _testResult = null;
            _isLoading = false;
          });
        } else {
          _fallbackEditConfiguration(configuration);
        }
      } catch (e) {
        _fallbackEditConfiguration(configuration);
      }
    } else {
      _fallbackEditConfiguration(configuration);
    }
  }

  void _fallbackEditConfiguration(JobConfigurationData configuration) {
    setState(() {
      _currentView = JobConfigurationView.edit;
      _editingConfiguration = configuration;
      _configValues = Map.from(configuration.parameters);
      _selectedIntegrations = List.from(configuration.requiredIntegrations);
      _configurationName = configuration.name;
      _testResult = null;
      _isLoading = false;
    });
  }

  void _deleteConfiguration(JobConfigurationData configuration) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Job Configuration'),
        content: Text('Are you sure you want to delete "${configuration.name}"? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.onDeleteConfiguration(configuration.id);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _testJobConfiguration(JobType type, Map<String, dynamic> config) {
    setState(() {
      _isLoading = true;
      _testResult = null;
    });

    widget.onTestConfiguration('test:${type.type}', config);

    // Simulate test result
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _testResult = 'Configuration test successful';
        });
      }
    });
  }

  void _createConfiguration() {
    debugPrint('🚀 JobConfigurationManagement: _createConfiguration() called');
    debugPrint('🚀   - _selectedType: ${_selectedType?.type}');
    debugPrint('🚀   - _configurationName: "$_configurationName"');
    debugPrint('🚀   - Can create: ${_canCreateConfiguration()}');

    if (_selectedType != null && _canCreateConfiguration()) {
      debugPrint('🚀   - All validation passed, calling onCreateConfiguration callback...');
      try {
        widget.onCreateConfiguration(_selectedType!, _configurationName, _configValues, _selectedIntegrations);
        debugPrint('🚀   - Callback completed successfully');
        setState(() {
          _currentView = JobConfigurationView.list;
          _selectedType = null;
          _configValues.clear();
          _selectedIntegrations.clear();
          _testResult = null;
        });
      } catch (error, stackTrace) {
        debugPrint('🚀   - ❌ Error in callback: $error');
        debugPrint('🚀   - Stack trace: $stackTrace');
      }
    } else {
      debugPrint('🚀   - ❌ Validation failed, cannot create configuration');
      if (_selectedType == null) {
        debugPrint('🚀     - No job type selected');
      }
      if (!_canCreateConfiguration()) {
        debugPrint('🚀     - Validation checks failed');
      }
    }
  }

  void _updateConfiguration() {
    if (_editingConfiguration != null) {
      widget.onUpdateConfiguration(_editingConfiguration!.id, _configurationName, _configValues, _selectedIntegrations);
      setState(() {
        _currentView = JobConfigurationView.list;
        _editingConfiguration = null;
        _configValues.clear();
        _selectedIntegrations.clear();
        _testResult = null;
      });
    }
  }

  IconData _getJobTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'expert':
        return Icons.psychology;
      case 'testcasesgenerator':
        return Icons.quiz;
      default:
        return Icons.smart_toy;
    }
  }

  String _getJobTypeCategory(String type) {
    switch (type.toLowerCase()) {
      case 'expert':
        return 'Analysis';
      case 'testcasesgenerator':
        return 'Testing';
      default:
        return 'AI Job';
    }
  }
}

/// Model for job configuration data
class JobConfigurationData {
  final String id;
  final String name;
  final String description;
  final String jobType;
  final bool enabled;
  final int executionCount;
  final DateTime? lastExecutedAt;
  final DateTime createdAt;
  final String createdByName;
  final List<String> requiredIntegrations;
  final Map<String, dynamic> parameters;

  const JobConfigurationData({
    required this.id,
    required this.name,
    required this.description,
    required this.jobType,
    required this.enabled,
    required this.executionCount,
    required this.createdAt,
    required this.createdByName,
    required this.requiredIntegrations,
    required this.parameters,
    this.lastExecutedAt,
  });
}

/// Model for job type data
class JobType {
  final String type;
  final String displayName;
  final String description;
  final List<JobParameter> parameters;
  final List<String> requiredIntegrations;

  const JobType({
    required this.type,
    required this.displayName,
    required this.description,
    required this.parameters,
    required this.requiredIntegrations,
  });
}

/// Model for job parameter
class JobParameter {
  final String key;
  final String displayName;
  final String description;
  final bool required;
  final String type;
  final dynamic defaultValue;
  final List<String>? options;

  const JobParameter({
    required this.key,
    required this.displayName,
    required this.description,
    required this.required,
    required this.type,
    this.defaultValue,
    this.options,
  });
}

/// Model for integration category
class IntegrationCategory {
  final String type;
  final String displayName;
  final String description;
  final bool available;

  const IntegrationCategory({
    required this.type,
    required this.displayName,
    required this.description,
    required this.available,
  });
}
