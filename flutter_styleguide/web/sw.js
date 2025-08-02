// Service Worker for DMTools Styleguide
// Version will be replaced during build
const CACHE_NAME = 'dmtools-styleguide-v__BUILD_VERSION__';
const RUNTIME_CACHE = 'dmtools-styleguide-runtime-v__BUILD_VERSION__';

// Minimal resources for faster startup
const CRITICAL_RESOURCES = [
  '/manifest.json',
  '/favicon.png'
];

// Install event - minimal caching for fast startup
self.addEventListener('install', (event) => {
  console.log('Styleguide Service Worker installing with cache:', CACHE_NAME);
  
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('Caching critical resources');
        return cache.addAll(CRITICAL_RESOURCES).catch(() => {
          console.log('Some critical resources failed to cache, continuing...');
        });
      })
      .then(() => {
        return self.skipWaiting();
      })
  );
});

// Activate event - clean old caches
self.addEventListener('activate', (event) => {
  console.log('Styleguide Service Worker activating');
  
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

// Fetch event - network first strategy for development
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
  
  // For styleguide development, use lighter network-first strategy
  event.respondWith(lightNetworkFirstStrategy(event.request));
});

// Lighter network-first strategy for styleguide
async function lightNetworkFirstStrategy(request) {
  try {
    const networkResponse = await fetch(request);
    
    // Only cache specific resources in styleguide for faster development
    if (networkResponse.ok && shouldCache(request.url)) {
      caches.open(RUNTIME_CACHE).then(cache => {
        cache.put(request, networkResponse.clone()).catch(() => {
          // Ignore cache errors
        });
      });
    }
    
    return networkResponse;
  } catch (error) {
    if (shouldCache(request.url)) {
      const cachedResponse = await caches.match(request);
      if (cachedResponse) {
        return cachedResponse;
      }
    }
    
    throw error;
  }
}

// Helper function for styleguide caching
function shouldCache(url) {
  return url.includes('.css') || 
         url.includes('.js') || 
         url.includes('.png') || 
         url.includes('.svg') ||
         url.includes('manifest.json');
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

console.log('Styleguide Service Worker loaded with cache name:', CACHE_NAME);