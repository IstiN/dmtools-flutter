import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dmtools_styleguide/dmtools_styleguide.dart' hide AuthProvider;
import '../../service_locator.dart';
import '../../network/services/dm_tools_api_service.dart';
import '../../network/services/dm_tools_api_service_mock.dart';
import '../../network/generated/openapi.models.swagger.dart';
import '../../providers/auth_provider.dart';
import '../loading_screen.dart'; // Fixed import path for LoadingScreen

class AiJobsPage extends StatefulWidget {
  const AiJobsPage({super.key});

  @override
  State<AiJobsPage> createState() => _AiJobsPageState();
}

class _AiJobsPageState extends State<AiJobsPage> {
  // State variables
  bool _isLoading = false;
  bool _dataLoaded = false;
  String? _errorMessage;
  List<JobConfigurationDto> _jobConfigurations = [];
  List<JobType> _availableJobTypes = [];
  List<AvailableIntegration> _availableIntegrations = [];

  // Track specific integration selections per job configuration
  // Maps job config ID to map of category type to selected integration ID
  final Map<String, Map<String, String>> _jobIntegrationSelections = {};

  int _buildCounter = 0; // Track how many times build is called

  /// Helper method to safely convert API boolean values that might come as strings
  bool _safeBool(dynamic value, {bool defaultValue = false}) {
    debugPrint('🔄 _safeBool called with: $value (type: ${value.runtimeType})');
    if (value == null) {
      debugPrint('✅ _safeBool: null -> $defaultValue');
      return defaultValue;
    }
    if (value is bool) {
      debugPrint('✅ _safeBool: bool $value -> $value');
      return value;
    }
    if (value is String) {
      final result = value.toLowerCase() == 'true';
      debugPrint('✅ _safeBool: string "$value" -> $result');
      return result;
    }
    debugPrint('⚠️ _safeBool: unknown type ${value.runtimeType} -> $defaultValue');
    return defaultValue;
  }

  /// Helper method to safely convert API integer values that might come as strings
  int _safeInt(dynamic value, {int defaultValue = 0}) {
    debugPrint('🔄 _safeInt called with: $value (type: ${value.runtimeType})');
    if (value == null) {
      debugPrint('✅ _safeInt: null -> $defaultValue');
      return defaultValue;
    }
    if (value is int) {
      debugPrint('✅ _safeInt: int $value -> $value');
      return value;
    }
    if (value is String) {
      final result = int.tryParse(value) ?? defaultValue;
      debugPrint('✅ _safeInt: string "$value" -> $result');
      return result;
    }
    debugPrint('⚠️ _safeInt: unknown type ${value.runtimeType} -> $defaultValue');
    return defaultValue;
  }

  // Use demo-aware API service
  DmToolsApiService get _apiService {
    final authProvider = ServiceLocator.get<AuthProvider>();
    if (authProvider.isDemoMode) {
      return DmToolsApiServiceMock();
    }
    return ServiceLocator.get<DmToolsApiService>();
  }

  @override
  void initState() {
    super.initState();
    debugPrint('🔧 AI Jobs Page - initState() called');
  }

  Future<void> _loadData() async {
    debugPrint('🚀 _loadData() called - Starting data loading process');
    debugPrint('📊 Initial state: _isLoading=$_isLoading, _dataLoaded=$_dataLoaded');

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    debugPrint('✅ Set _isLoading=true, starting API calls');

    try {
      debugPrint('🔄 About to start Future.wait() with API calls');
      // Load critical data in parallel - integrations are now stable
      await Future.wait([
        _loadJobConfigurations().then((value) {
          debugPrint('✅ _loadJobConfigurations completed successfully');
          return value;
        }).catchError((e) {
          debugPrint('❌ _loadJobConfigurations failed: $e');
          throw e;
        }),
        _loadJobTypes().then((value) {
          debugPrint('✅ _loadJobTypes completed successfully');
          return value;
        }).catchError((e) {
          debugPrint('❌ _loadJobTypes failed: $e');
          throw e;
        }),
        _loadIntegrations().then((value) {
          debugPrint('✅ _loadIntegrations completed successfully');
          return value;
        }).catchError((e) {
          debugPrint('❌ Integration loading failed independently: $e');
          // Don't block the UI - integrations are optional
          return null;
        }),
      ]);

      debugPrint('🎉 All API calls completed successfully');
      setState(() {
        _isLoading = false;
        _dataLoaded = true;
      });
      debugPrint('✅ Set _isLoading=false, _dataLoaded=true');
    } catch (e) {
      debugPrint('💥 Exception in _loadData: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load data: $e';
      });
      debugPrint('❌ Set _isLoading=false, _errorMessage=$_errorMessage');
    }

    debugPrint(
        '🏁 _loadData() completed - Final state: _isLoading=$_isLoading, _dataLoaded=$_dataLoaded, _errorMessage=$_errorMessage');
  }

  Future<void> _loadJobConfigurations() async {
    debugPrint('📋 _loadJobConfigurations() called - Starting job configurations loading');

    try {
      debugPrint('📞 About to call _apiService.getJobConfigurations()');

      try {
        final configurations = await _apiService.getJobConfigurations();
        debugPrint('✅ API call successful - Loaded ${configurations.length} job configurations');
        setState(() {
          _jobConfigurations = configurations;
        });
        debugPrint('✅ Updated _jobConfigurations state with ${configurations.length} items');
      } catch (e) {
        debugPrint('❌ Job configuration API call failed due to type conversion: $e');
        // If there's a type conversion error, use empty list and let UI show no configurations
        setState(() {
          _jobConfigurations = [];
        });
        debugPrint('⚠️ Fallback: Set _jobConfigurations to empty list');
      }
    } catch (e) {
      debugPrint('💥 Critical error in _loadJobConfigurations: $e');
      setState(() {
        _jobConfigurations = [];
      });
      debugPrint('❌ Error recovery: Set _jobConfigurations to empty list');
    }

    debugPrint('🏁 _loadJobConfigurations() completed - Final count: ${_jobConfigurations.length}');
  }

  Future<void> _loadJobTypes() async {
    try {
      debugPrint('🔄 Loading job types from API...');
      debugPrint('🔍 API Call: GET /api/v1/jobs/types');

      try {
        final jobTypeDtos = await _apiService.getAvailableJobTypes();
        debugPrint('✅ Successfully loaded job types from API');
        debugPrint('📋 Available job types: ${jobTypeDtos.map((dto) => dto.displayName).toList()}');

        final convertedTypes = <JobType>[];
        for (final jobTypeDto in jobTypeDtos) {
          debugPrint('✅ Converting job type: ${jobTypeDto.displayName}');
          debugPrint('📋 Config params count: ${jobTypeDto.configParams?.length ?? 0}');

          final convertedJobType = _convertJobTypeFromApi(jobTypeDto);
          convertedTypes.add(convertedJobType);

          debugPrint(
              '✅ Converted job type ${jobTypeDto.displayName} with ${convertedJobType.parameters.length} parameters');
        }

        debugPrint('✅ Loaded ${convertedTypes.length} job types from API');
        setState(() {
          _availableJobTypes = convertedTypes;
        });
      } catch (e) {
        debugPrint('❌ Job types API call failed due to type conversion: $e');
        // If there's a type conversion error, use empty list
        setState(() {
          _availableJobTypes = [];
        });
      }
    } catch (e) {
      debugPrint('❌ Failed to load job types: $e');
      setState(() {
        _availableJobTypes = [];
      });
    }
  }

  JobType _convertJobTypeFromApi(JobTypeDto dto) {
    debugPrint('🔄 Converting JobTypeDto: ${dto.type}');
    debugPrint('📋 Input configParams: ${dto.configParams?.length ?? 0} parameters');

    final parameters = _convertConfigParams(dto.configParams ?? []);
    final requiredIntegrations = dto.requiredIntegrations ?? [];

    debugPrint('📋 Converted parameters: ${parameters.length}');
    debugPrint('📋 Required integrations: $requiredIntegrations');

    return JobType(
      type: dto.type ?? 'unknown',
      displayName: dto.displayName ?? dto.type ?? 'Unknown',
      description: dto.description ?? 'AI job configuration',
      parameters: parameters, // Use the converted parameters
      requiredIntegrations: requiredIntegrations, // Keep generic category names
    );
  }

  Future<void> _loadIntegrations() async {
    debugPrint('🔄 _loadIntegrations() called - Starting integration loading');

    try {
      debugPrint('📞 About to call _apiService.getIntegrations() and getIntegrationTypes()');

      // Load integrations and integration types in parallel
      final results = await Future.wait([
        _apiService.getIntegrations().then((integrations) {
          debugPrint('✅ Loaded ${integrations.length} integrations from API');
          return integrations;
        }).catchError((e) {
          debugPrint('❌ Failed to load integrations: $e');
          return <IntegrationDto>[];
        }),
        _apiService.getIntegrationTypes().then((types) {
          debugPrint('✅ Loaded ${types.length} integration types from API');
          return types;
        }).catchError((e) {
          debugPrint('❌ Failed to load integration types: $e');
          return <IntegrationTypeDto>[];
        }),
      ]);

      final integrations = results[0] as List<IntegrationDto>;
      final integrationTypes = results[1] as List<IntegrationTypeDto>;

      debugPrint('📋 Processing ${integrations.length} integrations and ${integrationTypes.length} types');

      // Create a map of integration type to categories
      final Map<String, List<String>> typeCategoriesMap = {};
      for (final type in integrationTypes) {
        if (type.categories != null && type.categories!.isNotEmpty) {
          typeCategoriesMap[type.type ?? ''] = type.categories!;
          debugPrint('📋 Type ${type.type} has categories: ${type.categories}');
        }
      }

      // Convert individual integrations to AvailableIntegration objects
      List<AvailableIntegration> availableIntegrations = [];

      for (final integration in integrations) {
        if (integration.enabled == true) {
          final integrationTypeName = integration.type;
          final categories = typeCategoriesMap[integrationTypeName] ?? ['Other'];

          // For each category this integration belongs to, create an AvailableIntegration object
          for (final category in categories) {
            final availableIntegration = AvailableIntegration(
              id: integration.id ?? '',
              name: integration.name ?? 'Unknown Integration',
              type: category, // Use the category as the type for grouping
              displayName: integration.name ?? 'Unknown Integration',
              enabled: integration.enabled ?? false,
              description:
                  '$integrationTypeName:${integration.description ?? ''}', // Store original type name in description
            );

            availableIntegrations.add(availableIntegration);
            debugPrint(
                '✅ Added integration ${integration.name} to category $category (original type: $integrationTypeName)');
          }
        }
      }

      // If no integrations loaded, create fallback integrations to ensure form works
      if (availableIntegrations.isEmpty) {
        debugPrint('⚠️ No integrations found, creating fallback integrations for form functionality');
        availableIntegrations = [
          const AvailableIntegration(
            id: 'fallback-tracker-1',
            name: 'Sample Jira Integration',
            type: 'TrackerClient',
            displayName: 'Sample Jira Integration',
            enabled: true,
            description: 'jira:Sample Jira integration for testing',
          ),
          const AvailableIntegration(
            id: 'fallback-ai-1',
            name: 'Sample AI Integration',
            type: 'AI',
            displayName: 'Sample AI Integration',
            enabled: true,
            description: 'openai:Sample AI integration for testing',
          ),
          const AvailableIntegration(
            id: 'fallback-doc-1',
            name: 'Sample Documentation Integration',
            type: 'Documentation',
            displayName: 'Sample Documentation Integration',
            enabled: true,
            description: 'confluence:Sample documentation integration for testing',
          ),
        ];
        debugPrint('✅ Created ${availableIntegrations.length} fallback integrations');
      } else {
        debugPrint('✅ Created ${availableIntegrations.length} integrations from API data');
      }

      for (final integration in availableIntegrations) {
        debugPrint('📋 Integration ${integration.name} (${integration.type}): ${integration.description}');
      }

      setState(() {
        _availableIntegrations = availableIntegrations;
      });

      debugPrint('✅ Updated _availableIntegrations state with ${availableIntegrations.length} integrations');
    } catch (e) {
      debugPrint('💥 Critical error in _loadIntegrations: $e');

      // Create fallback integrations even on error to ensure form functionality
      final fallbackIntegrations = [
        const AvailableIntegration(
          id: 'fallback-tracker-1',
          name: 'Sample Jira Integration',
          type: 'TrackerClient',
          displayName: 'Sample Jira Integration',
          enabled: true,
          description: 'jira:Sample Jira integration for testing',
        ),
        const AvailableIntegration(
          id: 'fallback-ai-1',
          name: 'Sample AI Integration',
          type: 'AI',
          displayName: 'Sample AI Integration',
          enabled: true,
          description: 'openai:Sample AI integration for testing',
        ),
      ];

      setState(() {
        _availableIntegrations = fallbackIntegrations;
      });
      debugPrint('✅ Error recovery: Set fallback integrations for form functionality');
    }

    debugPrint('🏁 _loadIntegrations() completed - Final count: ${_availableIntegrations.length}');
  }

  List<JobParameter> _convertConfigParams(List<ConfigParamDefinition> apiParams) {
    debugPrint('🔄 Converting ${apiParams.length} config parameters');

    final convertedParams = apiParams.map((param) {
      debugPrint('📋 Converting param: ${param.key} (${param.type})');

      return JobParameter(
        key: param.key ?? '',
        displayName: param.displayName ?? param.key ?? '',
        description: param.description ?? '',
        required: param.required ?? false,
        type: param.type ?? 'string',
        defaultValue: param.defaultValue,
        options: param.options,
      );
    }).toList();

    debugPrint('✅ Converted ${convertedParams.length} parameters');
    return convertedParams;
  }

  Future<void> _createJobConfiguration(
    JobType jobType,
    String name,
    Map<String, dynamic> config,
    List<String> integrationIds,
  ) async {
    try {
      debugPrint('🔄 Creating job configuration with raw data:');
      debugPrint('  📋 Job type: ${jobType.type}');
      debugPrint('  📋 Config data: $config');
      debugPrint('  📋 Integration IDs: $integrationIds');

      // Prepare integration mappings in the correct format: {"TrackerClient": "uuid", "AI": "uuid"}
      final integrationMappings = <String, dynamic>{};

      for (final integrationId in integrationIds) {
        // Find the integration by ID to get its category type
        final integration = _availableIntegrations.firstWhere(
          (integration) => integration.id == integrationId,
          orElse: () => AvailableIntegration(
            id: integrationId,
            name: integrationId,
            type: integrationId,
            displayName: integrationId,
            enabled: true,
          ),
        );

        // Map category type to the selected integration UUID
        integrationMappings[integration.type] = integrationId;
        debugPrint('🔍 Mapping category "${integration.type}" -> integration ID "$integrationId"');
      }

      debugPrint('🔍 Final integration mappings for backend: $integrationMappings');

      debugPrint('🔄 Sending raw job config creation...');

      // Call the API service with the correct signature
      final newConfig = await _apiService.createJobConfigurationRaw(
        name,
        jobType.type,
        config,
        integrationMappings,
        enabled: true,
      );

      debugPrint('✅ Job configuration created successfully: ${newConfig.name}');

      // Reload configurations to update the list
      await _loadJobConfigurations();
    } catch (e) {
      debugPrint('❌ Error creating job configuration: $e');
      rethrow;
    }
  }

  Future<void> _updateJobConfiguration(
    String id,
    String name,
    Map<String, dynamic> config,
    List<String> integrationIds,
  ) async {
    try {
      debugPrint('🔄 Updating job configuration with raw data:');
      debugPrint('  📋 Config data: $config');
      debugPrint('  📋 Integration IDs: $integrationIds');

      // Prepare integration mappings in the correct format: {"TrackerClient": "uuid", "AI": "uuid"}
      final integrationMappings = <String, dynamic>{};

      for (final integrationId in integrationIds) {
        // Find the integration by ID to get its category type
        final integration = _availableIntegrations.firstWhere(
          (integration) => integration.id == integrationId,
          orElse: () => AvailableIntegration(
            id: integrationId,
            name: integrationId,
            type: integrationId, // Fallback: assume it's a category type
            displayName: integrationId,
            enabled: true,
            description: '$integrationId:', // Fallback format
          ),
        );

        // Map category type to the actual selected integration ID
        final categoryType = integration.type;
        integrationMappings[categoryType] = integrationId; // Use the actual integration ID

        debugPrint('🔍 Mapping category "$categoryType" -> integration ID "$integrationId"');
      }

      debugPrint('🔍 Final integration mappings for backend: $integrationMappings');

      debugPrint('🔄 Sending raw job config update...');

      // Call the API service with the correct signature
      final updatedConfig = await _apiService.updateJobConfigurationRaw(
        id,
        name,
        config,
        integrationMappings,
        enabled: true,
      );

      debugPrint('✅ Job configuration updated successfully: ${updatedConfig.name}');

      // Reload configurations to update the list
      await _loadJobConfigurations();
    } catch (e) {
      debugPrint('❌ Failed to update job configuration: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update job configuration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _deleteJobConfiguration(String id) async {
    try {
      await _apiService.deleteJobConfiguration(id);

      setState(() {
        _jobConfigurations.removeWhere((config) => config.id == id);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job configuration deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete job configuration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _executeJobConfiguration(String id) async {
    try {
      const request = ExecuteJobConfigurationRequest();

      await _apiService.executeJobConfiguration(id, request);

      // Update execution count locally
      final index = _jobConfigurations.indexWhere((config) => config.id == id);
      if (index >= 0) {
        final config = _jobConfigurations[index];
        final updatedConfig = JobConfigurationDto(
          id: config.id,
          name: config.name,
          description: config.description,
          jobType: config.jobType,
          createdById: config.createdById,
          createdByName: config.createdByName,
          createdByEmail: config.createdByEmail,
          jobParameters: config.jobParameters,
          integrationMappings: config.integrationMappings,
          enabled: _safeBool(config.enabled),
          executionCount: _safeInt(config.executionCount) + 1,
          createdAt: config.createdAt,
          updatedAt: config.updatedAt,
          lastExecutedAt: DateTime.now(),
        );

        setState(() {
          _jobConfigurations[index] = updatedConfig;
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Job configuration executed successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to execute job configuration: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<JobConfigurationData?> _getJobConfigurationDetails(String id) async {
    try {
      debugPrint('🔄 _getJobConfigurationDetails called for ID: $id');

      // Get raw JSON data to bypass JsonNode parsing issues
      final rawConfigData = await _apiService.getJobConfigurationRaw(id);
      debugPrint('🔍 Raw config data received: $rawConfigData');

      // Extract jobParameters safely
      Map<String, dynamic> parameters = {};
      if (rawConfigData['jobParameters'] != null) {
        if (rawConfigData['jobParameters'] is Map<String, dynamic>) {
          parameters = Map<String, dynamic>.from(rawConfigData['jobParameters']);
          debugPrint('✅ Extracted jobParameters from raw data: $parameters');
        } else {
          debugPrint('⚠️ jobParameters is not a Map: ${rawConfigData['jobParameters'].runtimeType}');
        }
      } else {
        debugPrint('📋 No jobParameters found in raw data');
      }

      // Extract integrationMappings safely
      List<String> requiredIntegrations = [];
      if (rawConfigData['integrationMappings'] != null) {
        if (rawConfigData['integrationMappings'] is Map<String, dynamic>) {
          final mappings = Map<String, dynamic>.from(rawConfigData['integrationMappings']);
          requiredIntegrations = mappings.values.cast<String>().toList();
          debugPrint('✅ Extracted integration IDs from raw data: $requiredIntegrations');
          debugPrint('📋 Integration mappings: $mappings');
        } else {
          debugPrint('⚠️ integrationMappings is not a Map: ${rawConfigData['integrationMappings'].runtimeType}');
        }
      } else {
        debugPrint('📋 No integrationMappings found in raw data');
      }

      // Convert raw data to styleguide model with safe type conversion
      debugPrint('🔄 About to create JobConfigurationData for details...');
      debugPrint('📋 Final parameters: $parameters');
      debugPrint('📋 Final requiredIntegrations: $requiredIntegrations');

      final result = JobConfigurationData(
        id: rawConfigData['id']?.toString() ?? '',
        name: rawConfigData['name']?.toString() ?? '',
        description: rawConfigData['description']?.toString() ?? '',
        jobType: rawConfigData['jobType']?.toString() ?? '',
        enabled: _safeBool(rawConfigData['enabled']),
        executionCount: _safeInt(rawConfigData['executionCount']),
        createdAt: rawConfigData['createdAt'] != null
            ? DateTime.tryParse(rawConfigData['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
        lastExecutedAt: rawConfigData['lastExecutedAt'] != null
            ? DateTime.tryParse(rawConfigData['lastExecutedAt'].toString())
            : null,
        createdByName: rawConfigData['createdByName']?.toString() ?? '',
        requiredIntegrations: requiredIntegrations,
        parameters: parameters,
      );
      debugPrint('✅ Successfully created JobConfigurationData for details: ${result.id}');
      return result;
    } catch (e) {
      debugPrint('❌ Failed to get job configuration details: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildCounter++;
    debugPrint('🔧 AI Jobs Page - build() called #$_buildCounter - rebuilding widget');

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        debugPrint(
            '🔐 AI Jobs Page - Auth State (build #$_buildCounter): ${authProvider.authState}, isAuthenticated: ${authProvider.isAuthenticated}, isLoading: ${authProvider.isLoading}');

        // Show loading screen while authentication is in progress
        if (authProvider.isLoading) {
          debugPrint('🔄 AI Jobs Page - Showing loading screen for authentication (build #$_buildCounter)');
          return const LoadingScreen();
        }

        // Check if user is authenticated
        if (!authProvider.isAuthenticated) {
          debugPrint(
              '❌ AI Jobs Page - User not authenticated, this should not happen on protected route (build #$_buildCounter)');
          return const Center(
            child: Text('Authentication required'),
          );
        }

        debugPrint('🔄 User authenticated, checking if data needs to be loaded... (build #$_buildCounter)');
        debugPrint(
            '📊 Current state (build #$_buildCounter): _isLoading=$_isLoading, _dataLoaded=$_dataLoaded, _errorMessage=$_errorMessage');

        // Load data only once when authenticated
        if (!_dataLoaded && !_isLoading && _errorMessage == null) {
          debugPrint('🚀 Triggering data load... (build #$_buildCounter)');
          debugPrint('📊 Detailed check (build #$_buildCounter):');
          debugPrint('   - !_dataLoaded: ${!_dataLoaded}');
          debugPrint('   - !_isLoading: ${!_isLoading}');
          debugPrint('   - _errorMessage == null: ${_errorMessage == null}');

          // Use Future.microtask to avoid calling setState during build
          Future.microtask(() {
            debugPrint('🔄 Inside Future.microtask (build #$_buildCounter) - About to call _loadData()');
            debugPrint(
                '📊 State check before _loadData (build #$_buildCounter): _isLoading=$_isLoading, _dataLoaded=$_dataLoaded');
            _loadData();
          });
        } else {
          debugPrint('📋 Data loading skipped (build #$_buildCounter):');
          debugPrint('   - _dataLoaded: $_dataLoaded');
          debugPrint('   - _isLoading: $_isLoading');
          debugPrint('   - _errorMessage: $_errorMessage');
        }

        // Show main content
        return _buildMainContent();
      },
    );
  }

  Widget _buildMainContent() {
    debugPrint('🔧 _buildMainContent called - _isLoading=$_isLoading, _errorMessage=$_errorMessage');

    // Show loading while data is being fetched
    if (_isLoading) {
      debugPrint('🔄 Showing loading screen for data loading');
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading AI Jobs...'),
          ],
        ),
      );
    }

    // Show error state
    if (_errorMessage != null) {
      debugPrint('❌ Showing error screen: $_errorMessage');
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading AI Jobs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                debugPrint('🔄 Retry button pressed, resetting state and reloading data');
                setState(() {
                  _dataLoaded = false;
                  _errorMessage = null;
                });
                _loadData();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show the main job management content
    debugPrint('✅ Showing main job management content');
    final jobConfigurationWidget = JobConfigurationManagement(
      configurations: _jobConfigurations.map((config) {
        debugPrint('🔄 Converting config: ${config.id} - ${config.name}');

        // Extract jobParameters safely from JsonNode
        Map<String, dynamic> extractedJobParameters = {};
        if (config.jobParameters != null) {
          if (config.jobParameters is Map<String, dynamic>) {
            extractedJobParameters = config.jobParameters as Map<String, dynamic>;
          } else {
            // Handle JsonNode - extract what we can or use empty map
            extractedJobParameters = {};
          }
        }

        // Extract requiredIntegrations safely from integrationMappings
        List<String> requiredIntegrations = [];
        if (config.integrationMappings != null) {
          if (config.integrationMappings is Map<String, dynamic>) {
            final mappings = config.integrationMappings as Map<String, dynamic>;
            requiredIntegrations = mappings.values.cast<String>().toList();
          } else {
            // Handle JsonNode - can't extract, use empty list
            requiredIntegrations = [];
          }
        }

        return JobConfigurationData(
          id: config.id ?? '',
          name: config.name ?? 'Unnamed Configuration',
          description: config.description ?? '',
          jobType: config.jobType ?? 'unknown',
          enabled: _safeBool(config.enabled),
          executionCount: _safeInt(config.executionCount),
          parameters: extractedJobParameters,
          requiredIntegrations: requiredIntegrations,
          createdAt: config.createdAt ?? DateTime.now(),
          createdByName: config.createdByName ?? 'Unknown User',
        );
      }).toList(),
      availableTypes: _availableJobTypes,
      availableIntegrations: _createIntegrationCategoriesFromData(),
      onCreateConfiguration: _onCreateConfiguration,
      onUpdateConfiguration: _onUpdateConfiguration,
      onDeleteConfiguration: _onDeleteConfiguration,
      onExecuteConfiguration: _onExecuteConfiguration,
      onTestConfiguration: _onTestConfiguration,
      onGetConfigurationDetails: _onGetConfigurationDetails,
      onCreateIntegration: _onCreateIntegration,
    );

    debugPrint('🔍 FINAL DATA PASSED TO JobConfigurationManagement:');
    debugPrint('  - configurations count: ${_jobConfigurations.length}');
    debugPrint('  - availableTypes count: ${_availableJobTypes.length}');
    debugPrint('  - availableIntegrations count: ${_createIntegrationCategoriesFromData().length}');
    debugPrint('  - onCreateIntegration callback: PROVIDED');

    final integrationCategories = _createIntegrationCategoriesFromData();
    debugPrint('🔍 Integration categories being passed:');
    for (int i = 0; i < integrationCategories.length; i++) {
      final cat = integrationCategories[i];
      debugPrint('  [$i] "${cat.displayName}" (type: "${cat.type}", available: ${cat.available})');
    }

    debugPrint('🔍 Job types being passed:');
    for (int i = 0; i < _availableJobTypes.length; i++) {
      final jobType = _availableJobTypes[i];
      debugPrint('  [$i] "${jobType.displayName}" (type: "${jobType.type}")');
      debugPrint('    - required integrations: ${jobType.requiredIntegrations.join(", ")}');
    }

    return jobConfigurationWidget;
  }

  // Callback methods for JobConfigurationManagement widget
  Future<void> _onCreateConfiguration(
      JobType jobType, String name, Map<String, dynamic> config, List<String> integrationIds) async {
    debugPrint('🚀 ==========================================================');
    debugPrint('🚀 onCreateConfiguration called with:');
    debugPrint('🚀   - jobType: ${jobType.type} (${jobType.displayName})');
    debugPrint('🚀   - name: $name');
    debugPrint('🚀   - config: $config');
    debugPrint('🚀   - integrationIds: $integrationIds');
    debugPrint('🚀 ==========================================================');

    try {
      debugPrint('🔍 Integration IDs received: ${integrationIds.join(", ")}');

      // Track the specific integration selections for this configuration
      final integrationSelectionMap = <String, String>{};
      for (final integrationId in integrationIds) {
        // Find the integration by ID to get its category type
        final integration = _availableIntegrations.firstWhere(
          (integration) => integration.id == integrationId,
          orElse: () => AvailableIntegration(
            id: integrationId,
            name: integrationId,
            type: integrationId,
            displayName: integrationId,
            enabled: true,
          ),
        );
        integrationSelectionMap[integration.type] = integrationId;
        debugPrint('🔍 Mapped category "${integration.type}" -> integration ID "$integrationId"');
      }

      // Store selection temporarily with config name + type as key since we don't have job ID yet
      final tempKey = '${jobType.type}:$name';
      _jobIntegrationSelections[tempKey] = integrationSelectionMap;
      debugPrint('🔍 Stored integration selections temporarily: $integrationSelectionMap');

      debugPrint('🚀 About to call _createJobConfiguration...');
      await _createJobConfiguration(jobType, name, config, integrationIds);
      debugPrint('🚀 _createJobConfiguration completed successfully!');
    } catch (e) {
      debugPrint('❌ Error in _onCreateConfiguration: $e');
      rethrow;
    }
  }

  Future<void> _onUpdateConfiguration(
      String id, String name, Map<String, dynamic> config, List<String> integrationIds) async {
    debugPrint('🚀 ==========================================================');
    debugPrint('🚀 onUpdateConfiguration called with:');
    debugPrint('🚀   - id: $id');
    debugPrint('🚀   - name: $name');
    debugPrint('🚀   - config: $config');
    debugPrint('🚀   - integrationIds: $integrationIds');
    debugPrint('🚀 ==========================================================');

    try {
      debugPrint('🔍 Integration IDs received: ${integrationIds.join(", ")}');

      // Track the specific integration selections for this configuration
      final integrationSelectionMap = <String, String>{};
      for (final integrationId in integrationIds) {
        // Find the integration by ID to get its category type
        final integration = _availableIntegrations.firstWhere(
          (integration) => integration.id == integrationId,
          orElse: () => AvailableIntegration(
            id: integrationId,
            name: integrationId,
            type: integrationId,
            displayName: integrationId,
            enabled: true,
          ),
        );
        integrationSelectionMap[integration.type] = integrationId;
        debugPrint('🔍 Mapped category "${integration.type}" -> integration ID "$integrationId"');
      }

      // Store the integration selections for this job ID
      _jobIntegrationSelections[id] = integrationSelectionMap;
      debugPrint('🔍 Stored integration selections for job $id: $integrationSelectionMap');

      debugPrint('🚀 About to call _updateJobConfiguration...');
      await _updateJobConfiguration(id, name, config, integrationIds);
      debugPrint('🚀 _updateJobConfiguration completed successfully!');
    } catch (e) {
      debugPrint('❌ Error in _onUpdateConfiguration: $e');
      rethrow;
    }
  }

  Future<void> _onDeleteConfiguration(String id) async {
    debugPrint('🔄 onDeleteConfiguration called with: $id');
    await _deleteJobConfiguration(id);
  }

  Future<void> _onExecuteConfiguration(String id) async {
    debugPrint('🔄 onExecuteConfiguration called with: $id');
    await _executeJobConfiguration(id);
  }

  Future<void> _onTestConfiguration(String id, Map<String, dynamic> testParameters) async {
    debugPrint('🔄 onTestConfiguration called with: $id, parameters: $testParameters');
    // TODO: Implement test configuration functionality when backend supports it
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Test configuration functionality coming soon'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  Future<JobConfigurationData> _onGetConfigurationDetails(String id) async {
    debugPrint('🔄 onGetConfigurationDetails called with: $id');
    final details = await _getJobConfigurationDetails(id);
    if (details != null) {
      debugPrint('✅ Successfully retrieved configuration details for: $id');
      debugPrint('🔍 Configuration details:');
      debugPrint('  - name: ${details.name}');
      debugPrint('  - jobType: ${details.jobType}');
      debugPrint('  - enabled: ${details.enabled}');
      debugPrint('  - requiredIntegrations: ${details.requiredIntegrations.join(", ")}');
      debugPrint('  - parameters count: ${details.parameters.length}');

      // Map category types to integration IDs for UI, preserving user selections
      final List<String> integrationIds = [];
      debugPrint('🔍 Mapping category types to integration IDs for UI:');

      // Check if we have stored selections for this job
      final storedSelections = _jobIntegrationSelections[id];
      debugPrint('🔍 Stored selections for job $id: $storedSelections');

      for (final categoryType in details.requiredIntegrations) {
        final matchingIntegrations = _availableIntegrations
            .where((integration) => integration.type == categoryType && integration.enabled)
            .toList();

        if (matchingIntegrations.isNotEmpty) {
          String selectedIntegrationId;
          AvailableIntegration selectedIntegration;

          // Try to use stored selection first
          if (storedSelections != null && storedSelections.containsKey(categoryType)) {
            final storedSelectionId = storedSelections[categoryType]!;
            final storedIntegration = matchingIntegrations.firstWhere(
              (integration) => integration.id == storedSelectionId,
              orElse: () => matchingIntegrations.first,
            );
            selectedIntegration = storedIntegration;
            selectedIntegrationId = storedIntegration.id;
            debugPrint(
                '  ✅ Category "$categoryType" -> Using stored selection "${selectedIntegration.name}" (ID: $selectedIntegrationId)');
          } else {
            // Fall back to first available integration
            selectedIntegration = matchingIntegrations.first;
            selectedIntegrationId = selectedIntegration.id;
            debugPrint(
                '  ✅ Category "$categoryType" -> Using default selection "${selectedIntegration.name}" (ID: $selectedIntegrationId)');
          }

          integrationIds.add(selectedIntegrationId);
        } else {
          debugPrint('  ❌ Category "$categoryType" has no available integrations');
          // Keep the category type as fallback for empty categories
          integrationIds.add(categoryType);
        }
      }

      // Update the details with integration IDs for UI
      final updatedDetails = JobConfigurationData(
        id: details.id,
        name: details.name,
        description: details.description,
        jobType: details.jobType,
        enabled: details.enabled,
        executionCount: details.executionCount,
        parameters: details.parameters,
        requiredIntegrations: integrationIds, // Use integration IDs for UI
        createdAt: details.createdAt,
        createdByName: details.createdByName,
      );

      debugPrint('🔍 Updated configuration with integration IDs: ${integrationIds.join(", ")}');

      return updatedDetails;
    } else {
      debugPrint('❌ Failed to retrieve configuration details for: $id');
      throw Exception('Failed to load configuration details');
    }
  }

  Future<void> _onCreateIntegration() async {
    debugPrint('🔄 onCreateIntegration called - redirecting to integrations page');
    // TODO: Navigate to integrations page or show integration creation dialog
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Redirecting to Integrations page to add new integration...'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  List<IntegrationCategory> _createIntegrationCategoriesFromData() {
    debugPrint('🔄 _createIntegrationCategoriesFromData called');
    final List<IntegrationCategory> categories = [];

    // Create individual IntegrationCategory entries for each integration
    // Use integration ID as type for uniqueness, provide category info in description
    for (final integration in _availableIntegrations) {
      categories.add(IntegrationCategory(
        type: integration.id, // Use unique integration ID as type for selection
        displayName: integration.name,
        description: '${integration.type} integration: ${integration.name}', // Provide category type for extraction
        available: integration.enabled,
      ));
    }

    debugPrint('✅ Created ${categories.length} integration categories from individual integrations');
    for (final cat in categories) {
      debugPrint('📋 Integration ${cat.type}: ${cat.displayName} (available: ${cat.available})');
    }

    // Log what data we're passing to JobConfigurationManagement
    debugPrint('🔍 IntegrationCategory data being passed to JobConfigurationManagement:');
    for (int i = 0; i < categories.length; i++) {
      final cat = categories[i];
      debugPrint(
          '  [$i] type: "${cat.type}", displayName: "${cat.displayName}", description: "${cat.description}", available: ${cat.available}');
    }

    return categories;
  }
}
