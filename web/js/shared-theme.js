/**
 * DMTools Shared Theme Management
 * Used by both main app and styleguide to ensure consistent theme behavior
 */

class ThemeManager {
    constructor() {
        this.STORAGE_KEY = 'flutter.theme_preference';
        this.THEME_DARK_CLASS = 'theme-dark';
        this.THEME_LIGHT_CLASS = 'theme-light';
        this.debugMode = true;
    }

    /**
     * Initialize theme detection and set appropriate HTML classes
     */
    initializeTheme() {
        try {
            const savedTheme = localStorage.getItem(this.STORAGE_KEY);
            const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
            
            if (this.debugMode) {
                console.log('Theme detection:', { savedTheme, prefersDark });
            }

            // Determine if should use dark theme
            const shouldUseDark = savedTheme === '"ThemePreference.dark"' || 
                                 (savedTheme !== '"ThemePreference.light"' && prefersDark);

            this.applyTheme(shouldUseDark);
            
            if (this.debugMode) {
                console.log('Applied theme:', shouldUseDark ? 'dark' : 'light');
            }
        } catch (e) {
            // Fallback to dark theme on error
            if (this.debugMode) {
                console.log('Theme detection error:', e);
            }
            this.applyTheme(true);
        }
    }

    /**
     * Apply theme to HTML document
     * @param {boolean} isDark - Whether to apply dark theme
     */
    applyTheme(isDark) {
        document.documentElement.className = isDark ? this.THEME_DARK_CLASS : this.THEME_LIGHT_CLASS;
    }

    /**
     * Check if current theme is dark
     * @returns {boolean} True if dark theme is active
     */
    isDarkTheme() {
        return document.documentElement.classList.contains(this.THEME_DARK_CLASS);
    }

    /**
     * Listen for Flutter theme changes via postMessage
     */
    setupFlutterThemeListener() {
        window.addEventListener('message', (event) => {
            if (event.data && event.data.type === 'flutter-theme-change') {
                if (this.debugMode) {
                    console.log('🎨 Flutter theme change detected:', event.data.theme);
                }
                const isDark = event.data.theme === 'dark';
                this.applyTheme(isDark);
                this.updateCanvasBackground(isDark);
                
                if (this.debugMode) {
                    console.log('🎨 Applied aggressive theme sync:', isDark ? 'dark' : 'light');
                }
            }
        });
    }

    /**
     * Listen for storage changes (theme preference updates)
     */
    setupStorageListener() {
        window.addEventListener('storage', (event) => {
            if (event.key === this.STORAGE_KEY) {
                if (this.debugMode) {
                    console.log('🎨 Theme preference changed in storage:', event.newValue);
                }
                const isDark = event.newValue === '"ThemePreference.dark"';
                this.applyTheme(isDark);
            }
        });
    }

    /**
     * Update canvas backgrounds for theme changes
     * @param {boolean} isDark - Whether dark theme is active
     */
    updateCanvasBackground(isDark) {
        const canvases = document.querySelectorAll('canvas');
        const backgroundColor = isDark ? '#121212' : '#F8F9FA';
        
        canvases.forEach(canvas => {
            if (canvas.style) {
                canvas.style.backgroundColor = backgroundColor;
            }
        });

        // Update Flutter glass pane if available
        const glassPanes = document.querySelectorAll('flt-glass-pane');
        glassPanes.forEach(pane => {
            if (pane.style) {
                pane.style.backgroundColor = backgroundColor;
            }
        });

        if (this.debugMode && canvases.length > 0) {
            console.log('🎨 Updated canvas background for theme change');
        }
    }

    /**
     * Debug theme information
     */
    debugTheme() {
        console.log('=== FLUTTER THEME DEBUG ===');
        console.log('Document classes:', document.documentElement.className);
        console.log('Is dark theme:', this.isDarkTheme());
        console.log('Storage preference:', localStorage.getItem(this.STORAGE_KEY));
        console.log('System prefers dark:', window.matchMedia('(prefers-color-scheme: dark)').matches);
        
        // Check canvas elements
        const canvases = document.querySelectorAll('canvas');
        console.log('Canvas elements found:', canvases.length);
        canvases.forEach((canvas, index) => {
            console.log(`Canvas ${index}:`, {
                backgroundColor: canvas.style.backgroundColor,
                width: canvas.width,
                height: canvas.height
            });
        });
        
        // Check Flutter elements
        const flutterViews = document.querySelectorAll('flutter-view');
        const glassPanes = document.querySelectorAll('flt-glass-pane');
        console.log('Flutter views:', flutterViews.length);
        console.log('Glass panes:', glassPanes.length);
        console.log('================================');
    }
}

// Global theme manager instance
window.themeManager = new ThemeManager();

// Initialize theme immediately
window.themeManager.initializeTheme();

// Set up listeners when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        window.themeManager.setupFlutterThemeListener();
        window.themeManager.setupStorageListener();
    });
} else {
    window.themeManager.setupFlutterThemeListener();
    window.themeManager.setupStorageListener();
}

// Export for module usage if needed
if (typeof module !== 'undefined' && module.exports) {
    module.exports = ThemeManager;
} 