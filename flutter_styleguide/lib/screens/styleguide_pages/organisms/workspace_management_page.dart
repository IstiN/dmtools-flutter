import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import '../../../widgets/organisms/workspace_management.dart';
import '../../../widgets/organisms/panel_base.dart';
import '../../../widgets/atoms/buttons/app_buttons.dart';
import '../../../widgets/styleguide/component_display.dart';

class WorkspaceManagementPage extends StatefulWidget {
  const WorkspaceManagementPage({super.key});

  @override
  State<WorkspaceManagementPage> createState() => _WorkspaceManagementPageState();
}

class _WorkspaceManagementPageState extends State<WorkspaceManagementPage> {
  bool _showAddWorkspace = false;
  bool _showEditWorkspace = false;
  WorkspaceCard? _selectedWorkspace;
  
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final colors = isDarkMode ? AppColors.dark : AppColors.light;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Workspace Management'),
        backgroundColor: colors.accentColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Workspace Management',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Complete workspace management system with cards, forms, and user management.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 32),
            
            ComponentDisplay(
              title: 'Workspace List',
              description: 'Display of workspaces with interactive cards.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.spacingM),
                  WorkspaceManagement(
                    workspaces: [
                      WorkspaceCard(
                        name: 'Marketing Team',
                        description: 'Workspace for marketing team projects and campaigns',
                        memberCount: 8,
                        agentCount: 3,
                        lastActive: DateTime.now().subtract(const Duration(hours: 2)),
                      ),
                      WorkspaceCard(
                        name: 'Development',
                        description: 'Product development and engineering workspace',
                        memberCount: 12,
                        agentCount: 7,
                        lastActive: DateTime.now().subtract(const Duration(days: 1)),
                      ),
                    ],
                    onWorkspaceSelected: (workspace) {
                      setState(() {
                        _selectedWorkspace = workspace;
                        _showEditWorkspace = true;
                        _showAddWorkspace = false;
                        _nameController.text = workspace.name;
                        _descriptionController.text = workspace.description;
                      });
                    },
                    onCreateWorkspace: () {
                      setState(() {
                        _showAddWorkspace = true;
                        _showEditWorkspace = false;
                        _nameController.clear();
                        _descriptionController.clear();
                      });
                    },
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            
            if (_showAddWorkspace)
              _buildAddWorkspaceForm(colors, isDarkMode),
              
            if (_showEditWorkspace && _selectedWorkspace != null)
              _buildEditWorkspaceForm(colors, isDarkMode),
            
            const SizedBox(height: 48),
            
            ComponentDisplay(
              title: 'Empty State',
              description: 'Display when no workspaces are available.',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppDimensions.spacingM),
                  WorkspaceManagement(
                    workspaces: const [],
                    onCreateWorkspace: () {},
                    isTestMode: true,
                    testDarkMode: isDarkMode,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: colors.borderColor,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'DART',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SelectableText(
                      '''
WorkspaceManagement(
  workspaces: [
    WorkspaceCard(
      name: 'Marketing Team',
      description: 'Workspace for marketing team projects and campaigns',
      memberCount: 8,
      agentCount: 3,
      lastActive: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    WorkspaceCard(
      name: 'Development',
      description: 'Product development and engineering workspace',
      memberCount: 12,
      agentCount: 7,
      lastActive: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ],
  onWorkspaceSelected: (workspace) {
    // Handle workspace selection
  },
  onCreateWorkspace: () {
    // Show create workspace form
  },
),''',
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                        height: 1.5,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAddWorkspaceForm(dynamic colors, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: PanelBase(
        title: 'Create Workspace',
        isTestMode: true,
        testDarkMode: isDarkMode,
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Workspace Name',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.borderColor),
                    ),
                  ),
                  style: TextStyle(color: colors.textColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a workspace name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.borderColor),
                    ),
                  ),
                  style: TextStyle(color: colors.textColor),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlineButton(
                      text: 'Cancel',
                      onPressed: () {
                        setState(() {
                          _showAddWorkspace = false;
                        });
                      },
                      isTestMode: true,
                      testDarkMode: isDarkMode,
                    ),
                    const SizedBox(width: 16),
                    PrimaryButton(
                      text: 'Create Workspace',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Create workspace logic would go here
                          setState(() {
                            _showAddWorkspace = false;
                          });
                        }
                      },
                      isTestMode: true,
                      testDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildEditWorkspaceForm(dynamic colors, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: PanelBase(
        title: 'Edit Workspace',
        isTestMode: true,
        testDarkMode: isDarkMode,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.white),
            onPressed: () {
              // Delete workspace logic would go here
              setState(() {
                _showEditWorkspace = false;
              });
            },
          ),
        ],
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Workspace Name',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.borderColor),
                    ),
                  ),
                  style: TextStyle(color: colors.textColor),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a workspace name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.borderColor),
                    ),
                  ),
                  style: TextStyle(color: colors.textColor),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlineButton(
                      text: 'Cancel',
                      onPressed: () {
                        setState(() {
                          _showEditWorkspace = false;
                        });
                      },
                      isTestMode: true,
                      testDarkMode: isDarkMode,
                    ),
                    const SizedBox(width: 16),
                    PrimaryButton(
                      text: 'Save Changes',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save workspace changes logic would go here
                          setState(() {
                            _showEditWorkspace = false;
                          });
                        }
                      },
                      isTestMode: true,
                      testDarkMode: isDarkMode,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 