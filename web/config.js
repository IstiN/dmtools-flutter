/**
 * DMTools Flutter - Runtime Configuration
 * 
 * This file allows you to configure the application without rebuilding.
 * Simply edit the values below and refresh the application.
 */
window.dmtoolsConfig = {
  /**
   * Base URL for the API service
   * 
   * Examples:
   * - Local development: 'http://localhost:8080'
   * - Internal server: 'http://your-internal-server:8080'
   * - Production: 'https://api.yourcompany.com'
   */
  apiBaseUrl: 'http://localhost:8080',
  
  /**
   * Application environment
   * Options: 'development', 'production'
   */
  environment: 'production',
  
  /**
   * Enable debug logging
   * Set to true for troubleshooting
   */
  enableLogging: false,
  
  /**
   * Enable mock data for testing
   * Set to true to use sample data instead of real API calls
   */
  enableMockData: false,
  
  /**
   * Request timeout in seconds
   */
  timeoutDuration: 30,
  
  /**
   * Application metadata
   */
  appName: 'DMTools',
  appVersion: '1.0.0'
};

/**
 * Configuration validation and helpers
 */
window.dmtoolsConfigHelpers = {
  /**
   * Validate the configuration
   */
  validate: function() {
    const config = window.dmtoolsConfig;
    const errors = [];
    
    // Validate API base URL
    if (!config.apiBaseUrl || typeof config.apiBaseUrl !== 'string') {
      errors.push('apiBaseUrl must be a valid string');
    } else {
      try {
        new URL(config.apiBaseUrl);
      } catch (e) {
        errors.push('apiBaseUrl must be a valid URL');
      }
    }
    
    // Validate environment
    if (!['development', 'production'].includes(config.environment)) {
      errors.push('environment must be either "development" or "production"');
    }
    
    // Validate timeout
    if (typeof config.timeoutDuration !== 'number' || config.timeoutDuration <= 0) {
      errors.push('timeoutDuration must be a positive number');
    }
    
    return errors;
  },
  
  /**
   * Get the current configuration
   */
  getConfig: function() {
    return window.dmtoolsConfig;
  },
  
  /**
   * Set a configuration value
   */
  setConfig: function(key, value) {
    window.dmtoolsConfig[key] = value;
  },
  
  /**
   * Log current configuration (for debugging)
   */
  logConfig: function() {
    console.log('DMTools Configuration:', window.dmtoolsConfig);
  }
};

// Validate configuration on load
document.addEventListener('DOMContentLoaded', function() {
  const errors = window.dmtoolsConfigHelpers.validate();
  if (errors.length > 0) {
    console.error('DMTools Configuration Errors:', errors);
    console.log('Please check your config.js file and fix the following issues:');
    errors.forEach(error => console.log('- ' + error));
  } else {
    console.log('DMTools Configuration loaded successfully');
    if (window.dmtoolsConfig.enableLogging) {
      window.dmtoolsConfigHelpers.logConfig();
    }
  }
});
