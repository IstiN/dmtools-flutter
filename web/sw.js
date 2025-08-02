// Service Worker for DMTools Flutter App
// Version will be replaced during build
const CACHE_NAME = 'dmtools-v__BUILD_VERSION__';
const RUNTIME_CACHE = 'dmtools-runtime-v__BUILD_VERSION__';

// Minimal resources to cache immediately (for faster startup)
const CRITICAL_RESOURCES = [
  '/manifest.json',
  '/favicon.png'
];

// Install event - minimal caching for fast startup
self.addEventListener('install', (event) => {
  console.log('Service Worker installing with cache:', CACHE_NAME);
  
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        // Only cache critical resources immediately for faster startup
        console.log('Caching critical resources');
        return cache.addAll(CRITICAL_RESOURCES).catch(() => {
          // Continue even if some resources fail to cache
          console.log('Some critical resources failed to cache, continuing...');
        });
      })
      .then(() => {
        // Force activation of new service worker
        return self.skipWaiting();
      })
  );
});

// Activate event - clean old caches
self.addEventListener('activate', (event) => {
  console.log('Service Worker activating');
  
  event.waitUntil(
    Promise.all([
      // Clean old caches
      caches.keys().then((cacheNames) => {
        return Promise.all(
          cacheNames.map((cacheName) => {
            if (cacheName !== CACHE_NAME && cacheName !== RUNTIME_CACHE) {
              console.log('Deleting old cache:', cacheName);
              return caches.delete(cacheName);
            }
          })
        );
      }),
      // Take control of all clients
      self.clients.claim()
    ])
  );
});

// Fetch event - network first strategy with cache fallback
self.addEventListener('fetch', (event) => {
  const url = new URL(event.request.url);
  
  // Skip non-GET requests
  if (event.request.method !== 'GET') {
    return;
  }
  
  // Skip external requests
  if (url.origin !== location.origin) {
    return;
  }
  
  // Use lighter caching strategy for better performance
  if (isFlutterResource(url.pathname)) {
    event.respondWith(lightNetworkFirstStrategy(event.request));
  }
  // Handle static assets with cache-first strategy
  else if (isStaticAsset(url.pathname)) {
    event.respondWith(lightCacheFirstStrategy(event.request));
  }
  // Handle API calls with network-only strategy
  else if (isApiCall(url.pathname)) {
    event.respondWith(fetch(event.request));
  }
  // Default to network-first for everything else
  else {
    event.respondWith(lightNetworkFirstStrategy(event.request));
  }
});

// Lighter network-first strategy (faster, less aggressive caching)
async function lightNetworkFirstStrategy(request) {
  try {
    const networkResponse = await fetch(request);
    
    // Only cache successful responses for specific file types to reduce overhead
    if (networkResponse.ok && shouldCache(request.url)) {
      // Use non-blocking cache update
      caches.open(RUNTIME_CACHE).then(cache => {
        cache.put(request, networkResponse.clone()).catch(() => {
          // Ignore cache errors to avoid blocking
        });
      });
    }
    
    return networkResponse;
  } catch (error) {
    // Only try cache for specific resources
    if (shouldCache(request.url)) {
      const cachedResponse = await caches.match(request);
      if (cachedResponse) {
        return cachedResponse;
      }
    }
    
    throw error;
  }
}

// Lighter cache-first strategy
async function lightCacheFirstStrategy(request) {
  const cachedResponse = await caches.match(request);
  
  if (cachedResponse) {
    return cachedResponse;
  }
  
  try {
    const networkResponse = await fetch(request);
    
    // Non-blocking cache update
    if (networkResponse.ok) {
      caches.open(RUNTIME_CACHE).then(cache => {
        cache.put(request, networkResponse.clone()).catch(() => {
          // Ignore cache errors
        });
      });
    }
    
    return networkResponse;
  } catch (error) {
    throw error;
  }
}

// Helper function to determine if a resource should be cached
function shouldCache(url) {
  // Only cache specific file types to reduce overhead
  return url.includes('.css') || 
         url.includes('.js') || 
         url.includes('.png') || 
         url.includes('.svg') ||
         url.includes('manifest.json');
}

// Check if URL is a Flutter resource
function isFlutterResource(pathname) {
  return pathname.includes('flutter') || 
         pathname.endsWith('.js') || 
         pathname.endsWith('.wasm') || 
         pathname.endsWith('.html') ||
         pathname === '/';
}

// Check if URL is a static asset
function isStaticAsset(pathname) {
  return pathname.includes('/icons/') ||
         pathname.includes('/css/') ||
         pathname.endsWith('.png') ||
         pathname.endsWith('.svg') ||
         pathname.endsWith('.ico') ||
         pathname.endsWith('.css');
}

// Check if URL is an API call
function isApiCall(pathname) {
  return pathname.includes('/api/') || 
         pathname.includes('/oauth/');
}

// Handle messages from the main thread
self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
  
  if (event.data && event.data.type === 'GET_VERSION') {
    event.ports[0].postMessage({
      version: CACHE_NAME
    });
  }
});

console.log('Service Worker loaded with cache name:', CACHE_NAME);