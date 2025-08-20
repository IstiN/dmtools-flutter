# AI-Powered Workflows for DMTools Flutter

This directory contains AI-powered workflows that leverage the reusable agentic workflows from [`IstiN/dmtools-agentic-workflows`](https://github.com/IstiN/dmtools-agentic-workflows) for automated code discovery and implementation using Gemini AI.

## 🤖 Available Workflows

### 1. AI Code Implementation (`ai-implementation.yml`)

**Purpose**: Automated code implementation using AI models

**When to Use**:
- Implement new features based on requirements
- Add functionality to existing components
- Create new widgets, screens, or providers
- Integrate with APIs or external services

**Workflow Inputs**:
- `user_request` (required): Your implementation request with DMC ticket number
- `model`: Gemini model to use (default: gemini-2.5-flash-preview-05-20)
- `pr_base_branch`: Target branch for PR (default: main)
- `enable_debug_logging`: Enable detailed logging (default: true)
- `custom_rules_override`: Use Flutter-specific rules (default: true)

**Example Request**:
```
DMC-123: Implement user profile edit screen with form validation

Requirements:
- Create ProfileEditScreen in lib/screens/
- Use ProfileProvider for state management
- Include form fields: name, email, bio, avatar upload
- Add validation for email format and required fields
- Integrate with user API endpoint for updates
- Follow DMTools styleguide for UI components
```

**Features**:
- Automatically creates PR with implemented code
- Uses Flutter-specific prompts and rules
- Includes post-implementation Flutter validation
- Provides detailed implementation summary

### 2. AI Code Discovery (`ai-discovery.yml`)

**Purpose**: AI-powered code analysis and documentation

**When to Use**:
- Understand existing codebase architecture
- Document code patterns and structures
- Analyze specific components or modules
- Plan refactoring or improvement strategies
- Onboard new developers to the codebase

**Workflow Inputs**:
- `user_request` (required): Your discovery/analysis question
- `model`: Gemini model for analysis (default: gemini-2.5-flash-preview-05-20)
- `enable_debug_logging`: Enable detailed logging (default: true)
- `flutter_focus_area`: Specific area to analyze

**Focus Areas**:
- `full-project`: Complete project analysis
- `main-app-only`: Focus on main application
- `styleguide-only`: Focus on component library
- `state-management`: Provider patterns and data flow
- `ui-components`: Widget architecture and composition
- `networking`: API layer and data management
- `providers`: State management implementation
- `widgets`: Custom widget components

**Example Requests**:
```
How is state management implemented in this Flutter app?
What are the main architectural patterns used?
Analyze the styleguide component library structure
Document the navigation and routing implementation
Explain the provider registration and dependency injection
```

**Features**:
- Comprehensive project structure analysis
- Flutter-specific architectural insights
- Detailed documentation generation
- Focus area customization for targeted analysis

## 🔧 Setup Requirements

### Required Secrets

Set up these secrets in your repository settings:

1. **GEMINI_API_KEY** (Required for all workflows)
   - Get from [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Used for AI model interactions

2. **PAT_TOKEN** (Required for implementation workflow)
   - Create from [GitHub Settings](https://github.com/settings/tokens)
   - Needs `repo` and `pull_requests` permissions
   - Used for automated PR creation

### Setting Up Secrets

1. Go to repository **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add the required secrets with appropriate values

## 📝 Flutter-Specific Features

### Custom Prompts
Each workflow uses Flutter-specific prompts located in `.github/ai-prompts/`:
- `flutter-implementation-prompt.md`: Flutter development best practices
- `flutter-discovery-prompt.md`: Architecture analysis guidelines

### Project Context
Workflows automatically include Flutter project context:
- `@commonrules.mdc`: Flutter-specific coding rules
- `README.md`: Project overview and setup
- `pubspec.yaml`: Dependencies and configuration
- `analysis_options.yaml`: Linting and analysis rules
- `flutter_styleguide/README.md`: Component library documentation

### Post-Workflow Analysis
Implementation workflow includes Flutter-specific validation:
- `flutter analyze` execution
- `pubspec.yaml` syntax validation
- Build configuration checks
- Flutter-specific recommendations

## 🚀 Usage Examples

### Example 1: Implement New Feature
```yaml
# Workflow: AI Code Implementation
User Request: |
  DMC-456: Create settings screen with theme toggle
  
  Requirements:
  - Add SettingsScreen in lib/screens/settings_screen.dart
  - Include theme toggle (light/dark mode)
  - Add language selection dropdown
  - Use SettingsProvider for state management
  - Follow styleguide design patterns
  - Add navigation from main drawer

Model: gemini-2.5-flash-preview-05-20
Custom Rules Override: true
```

### Example 2: Analyze Architecture
```yaml
# Workflow: AI Code Discovery
User Request: |
  Analyze the state management architecture in this Flutter app.
  Focus on how providers are organized, registered, and used throughout the app.
  Document the data flow patterns and suggest any improvements.

Flutter Focus Area: state-management
Model: gemini-2.5-flash-preview-05-20
```

## 📊 Workflow Outputs

### Implementation Workflow
- **Pull Request**: Automatically created with implemented code
- **Artifacts**: Implementation logs, prompts, and analysis
- **Summary**: Detailed implementation report with next steps

### Discovery Workflow  
- **Analysis Report**: Comprehensive architectural documentation
- **Artifacts**: Discovery logs and full analysis report
- **Summary**: Key findings and recommendations

## 🔍 Best Practices

### Writing Effective Requests

1. **Be Specific**: Include clear requirements and acceptance criteria
2. **Include Context**: Reference existing files, patterns, or components
3. **Add Ticket Numbers**: Always include DMC-XXX ticket references
4. **Specify Scope**: Clearly define what should and shouldn't be included

### Request Format Examples

**Good Implementation Request**:
```
DMC-789: Add offline support for user data

Requirements:
- Implement local storage using SharedPreferences
- Add UserDataRepository with online/offline modes
- Update UserProvider to handle offline scenarios
- Add sync mechanism when connection restored
- Show offline indicator in UI when disconnected

Technical Details:
- Use provider pattern for state management
- Follow existing repository pattern in lib/repositories/
- Add proper error handling for network failures
- Include unit tests for offline scenarios
```

**Good Discovery Request**:
```
Analyze the current navigation architecture in the Flutter app.

Focus Areas:
- Route definition and organization
- Navigation patterns used throughout the app
- Deep linking implementation
- Navigation state management
- Authentication guard implementation

Please document current patterns and suggest improvements for better maintainability.
```

### Troubleshooting

**Common Issues**:

1. **"No DMC ticket number found"**
   - Include DMC-XXX format in your request
   - Example: "DMC-123: Implement feature"

2. **"Implementation failed"**
   - Check if request is too complex for single implementation
   - Break down into smaller, focused requests
   - Verify all required context is provided

3. **"Analysis incomplete"**
   - Be more specific about what you want to analyze
   - Focus on specific components or areas
   - Provide relevant file paths if known

**Getting Help**:
- Check workflow artifacts for detailed logs
- Review the generated summaries for specific guidance
- Use more focused requests for complex problems
- Refer to the [main repository documentation](https://github.com/IstiN/dmtools-agentic-workflows)

## 🔗 Related Resources

- **Main Agentic Workflows**: [IstiN/dmtools-agentic-workflows](https://github.com/IstiN/dmtools-agentic-workflows)
- **Flutter Documentation**: [flutter.dev](https://flutter.dev)
- **DMTools Flutter App**: Main application repository
- **Flutter Styleguide**: Component library in `flutter_styleguide/`

---

**Happy coding with AI assistance! 🚀**
