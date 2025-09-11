/**
 * DMTools Flutter - Runtime Configuration Template
 * 
 * IMPORTANT: Copy this file to 'config.js' in both the root directory and 
 * styleguide directory, then modify the values below.
 * 
 * For easy deployment:
 * 1. cp config.template.js config.js
 * 2. cp config.template.js styleguide/config.js
 * 3. Edit both config.js files to match your environment
 * 4. Deploy to your web server
 */
window.dmtoolsConfig = {
  /**
   * ⚙️  API Base URL Configuration
   * 
   * This is the most important setting - it tells the app where to find your API server.
   * 
   * Examples:
   * - Development: 'http://localhost:8080'
   * - Internal server: 'http://your-server.company.com:8080'
   * - Production: 'https://api.yourcompany.com'
   * - Docker: 'http://dmtools-api:8080'
   */
  apiBaseUrl: 'http://localhost:8080',
  
  /**
   * 🌍 Environment Setting
   * 
   * Options: 'development' or 'production'
   * - development: Shows debug information, more verbose logging
   * - production: Optimized for performance, minimal logging
   */
  environment: 'production',
  
  /**
   * 📝 Debug Logging
   * 
   * Set to true to see detailed logs in browser console
   * Useful for troubleshooting connection issues
   */
  enableLogging: false,
  
  /**
   * 🧪 Mock Data Mode
   * 
   * Set to true to use sample data instead of real API calls
   * Useful for testing the interface without a backend server
   */
  enableMockData: false,
  
  /**
   * ⏱️  Request Timeout
   * 
   * How long to wait for API responses (in seconds)
   * Increase if your server is slow or on a slow network
   */
  timeoutDuration: 30,
  
  /**
   * 📱 Application Metadata
   * 
   * These settings control the app title and version display
   */
  appName: 'DMTools',
  appVersion: '1.0.0'
};

/**
 * 🔧 Configuration Helpers
 * 
 * These functions help validate and manage your configuration.
 * You don't need to modify anything below this line.
 */
window.dmtoolsConfigHelpers = {
  validate: function() {
    const config = window.dmtoolsConfig;
    const errors = [];
    
    if (!config.apiBaseUrl || typeof config.apiBaseUrl !== 'string') {
      errors.push('❌ apiBaseUrl must be a valid string');
    } else {
      try {
        new URL(config.apiBaseUrl);
      } catch (e) {
        errors.push('❌ apiBaseUrl must be a valid URL (e.g., http://localhost:8080)');
      }
    }
    
    if (!['development', 'production'].includes(config.environment)) {
      errors.push('❌ environment must be either "development" or "production"');
    }
    
    if (typeof config.timeoutDuration !== 'number' || config.timeoutDuration <= 0) {
      errors.push('❌ timeoutDuration must be a positive number');
    }
    
    return errors;
  },
  
  getConfig: function() {
    return window.dmtoolsConfig;
  },
  
  setConfig: function(key, value) {
    window.dmtoolsConfig[key] = value;
  },
  
  logConfig: function() {
    console.log('🔧 DMTools Configuration:', window.dmtoolsConfig);
  },
  
  testConnection: function() {
    const config = window.dmtoolsConfig;
    console.log('🌐 Testing connection to:', config.apiBaseUrl);
    
    fetch(config.apiBaseUrl + '/health')
      .then(response => {
        if (response.ok) {
          console.log('✅ Connection successful!');
        } else {
          console.log('⚠️  Server responded with status:', response.status);
        }
      })
      .catch(error => {
        console.log('❌ Connection failed:', error.message);
        console.log('💡 Tips:');
        console.log('   - Check if your API server is running');
        console.log('   - Verify the apiBaseUrl in config.js');
        console.log('   - Check network connectivity');
      });
  }
};

// Auto-validate configuration when page loads
document.addEventListener('DOMContentLoaded', function() {
  const errors = window.dmtoolsConfigHelpers.validate();
  if (errors.length > 0) {
    console.error('🚨 DMTools Configuration Errors:');
    errors.forEach(error => console.error('  ' + error));
    console.log('💡 Please check your config.js file and fix the issues above.');
  } else {
    console.log('✅ DMTools Configuration loaded successfully');
    console.log('🔗 API Base URL:', window.dmtoolsConfig.apiBaseUrl);
    
    if (window.dmtoolsConfig.enableLogging) {
      window.dmtoolsConfigHelpers.logConfig();
    }
    
    // Test connection if in development mode
    if (window.dmtoolsConfig.environment === 'development') {
      setTimeout(() => window.dmtoolsConfigHelpers.testConnection(), 1000);
    }
  }
});

/**
 * 📖 Quick Configuration Guide
 * 
 * 1. BASIC SETUP:
 *    - Copy this file to config.js in both root and styleguide directories
 *    - Change apiBaseUrl to your server URL
 *    - Set environment to 'production' for live deployment
 * 
 * 2. TESTING:
 *    - Open browser console and run: window.dmtoolsConfigHelpers.testConnection()
 *    - Enable logging temporarily: window.dmtoolsConfig.enableLogging = true
 * 
 * 3. TROUBLESHOOTING:
 *    - Check browser console for error messages
 *    - Verify your API server is accessible at the configured URL
 *    - Try enableMockData: true to test without a backend
 * 
 * 4. COMMON URLS:
 *    - Local development: http://localhost:8080
 *    - Docker Compose: http://dmtools-api:8080 (from container) or http://localhost:8080 (from host)
 *    - Internal server: http://your-server-ip:8080
 *    - Load balancer: https://api.yourcompany.com
 */
