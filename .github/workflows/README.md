# GitHub Workflows

This directory contains GitHub Actions workflows for Continuous Integration and Deployment.

## 🔄 Workflows Overview

### 1. **Continuous Integration** (`ci.yml`)
**Triggers**: Pull Requests and pushes to `main`/`develop` branches

**Purpose**: Ensures code quality and functionality before merging changes.

#### **Jobs:**

**📋 Test Job**
- **Duration**: ~5-10 minutes
- **Actions**:
  - Code analysis (`flutter analyze`)
  - Unit tests for main app (including authentication tests)
  - Unit tests for styleguide
  - Coverage report generation
- **Caching**: Flutter dependencies and pub cache for faster runs

**🔐 Authentication Tests Job**
- **Duration**: ~3-5 minutes  
- **Actions**:
  - Focused authentication provider tests
  - Service locator dependency injection tests
  - JWT token parsing and validation tests
- **Critical for**: Preventing authentication regressions

**🏗️ Build Verification Job**
- **Duration**: ~5-8 minutes
- **Actions**:
  - Verify main app builds for production
  - Verify styleguide builds for production
  - Ensures deployment readiness
- **Dependencies**: Runs only after tests pass

### 2. **Deploy to GitHub Pages** (`deploy-pages.yml`)
**Triggers**: Pushes to `main` branch, PRs (for testing), manual dispatch

**Purpose**: Builds and deploys both the main app and styleguide to GitHub Pages.

#### **Jobs:**

**🏗️ Build Job**
- Runs tests (same as CI)
- Builds optimized production bundles
- Creates deployment structure with navigation
- Uploads artifacts for deployment

**🚀 Deploy Job**  
- Deploys to GitHub Pages (main branch only)
- Sets up custom domain and routing

## 🛡️ Quality Gates

### **Required Checks for PR Merge:**
1. ✅ All unit tests pass
2. ✅ Code analysis passes (no warnings/errors)
3. ✅ Authentication tests pass (critical)
4. ✅ Build verification succeeds
5. ✅ No regressions in authentication token logic

### **Authentication Test Coverage:**
- **AuthProvider**: Token handling, user management, demo mode
- **JWT Parsing**: Token validation, claim extraction, error handling  
- **Service Locator**: Dependency injection, user info loading
- **API Integration**: Token inclusion in requests, user profile loading

## 🚀 Optimization Features

### **Performance:**
- **Parallel Jobs**: Tests and builds run in parallel when possible
- **Dependency Caching**: Flutter dependencies cached between runs
- **Concurrency Control**: Cancels old runs when new commits are pushed
- **Timeouts**: Prevents stuck workflows (15min max per job)

### **Smart Failure Handling:**
- **Golden Tests**: Styleguide golden tests allowed to fail in CI (environment differences)
- **Coverage Reports**: Generated even if some non-critical tests fail
- **Clear Error Messages**: Detailed summaries in GitHub UI

## 📊 Workflow Outputs

### **GitHub PR Interface:**
- ✅ **Status Checks**: Clear pass/fail indicators
- 📋 **Detailed Summaries**: What was tested and verified
- ⚠️ **Failure Explanations**: Specific guidance on fixing issues
- 📈 **Coverage Reports**: Test coverage artifacts

### **Summary Examples:**

**✅ Success:**
```
🔒 Authentication logic is secure and working correctly!

✅ Verified Components:
- AuthProvider token handling
- JWT token parsing and validation  
- User info management and API integration
- Demo mode functionality
```

**❌ Failure:**
```
⚠️ CRITICAL: Authentication token logic has issues that could affect user login and API access.

Please review the authentication test failures and fix them before merging to prevent:
- Users being unable to log in
- API requests failing due to missing tokens  
- User profile data not loading correctly
```

## 🔧 Configuration

### **Flutter Version:** 3.32.x (stable channel)
### **Environment Variables:**
- `FLUTTER_ENV=production`
- `baseUrl=https://dmtools-431977789017.us-central1.run.app`

### **Caching Strategy:**
```yaml
path: |
  ~/.pub-cache
  .dart_tool
  flutter_styleguide/.dart_tool
key: flutter-${{ runner.os }}-${{ hashFiles('**/pubspec.lock') }}
```

## 🎯 Usage Guidelines

### **For Developers:**

1. **Creating PRs**: All checks must pass before merge
2. **Test Failures**: Fix issues rather than bypassing checks
3. **Authentication Changes**: Pay special attention to auth test results
4. **Build Errors**: Ensure production builds work before merging

### **For Reviewers:**

1. **Check Status**: Ensure all CI checks are green
2. **Review Summaries**: Look at detailed test summaries
3. **Authentication**: Extra scrutiny for auth-related changes
4. **Coverage**: Review coverage reports for new code

## 🔄 Maintenance

### **Adding New Tests:**
1. Add test files to appropriate directories
2. Tests are automatically discovered and run
3. Critical tests can be added to dedicated jobs

### **Updating Dependencies:**
1. Update Flutter version in both workflows
2. Clear cache if major dependency changes
3. Test workflow changes in feature branches

### **Monitoring:**
- Workflow run times should stay under 15 minutes total
- Authentication tests should complete in under 5 minutes
- Build verification should complete in under 10 minutes

## 🚨 Troubleshooting

### **Common Issues:**

**🔍 "flutter analyze" failures:**
- Fix linting errors and warnings
- Update analysis_options.yaml if needed

**🧪 Test failures:**
- Check test output for specific failures
- Authentication test failures are critical and must be fixed

**🏗️ Build failures:**
- Check dart-define values match production config
- Ensure all dependencies are properly installed

**📦 Cache issues:**
- Clear cache by updating workflow file
- Check if dependencies changed significantly

### **Emergency Procedures:**

**🚨 Bypass checks (last resort):**
- Only for hotfixes in critical situations
- Requires admin approval
- Must create follow-up PR to fix issues

**🔧 Workflow debugging:**
- Add debug steps with `flutter doctor -v`
- Check specific test output with `--verbose`
- Review workflow logs in GitHub Actions tab 