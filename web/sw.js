// Service Worker for DMTools Flutter App
// Version will be replaced during build
const CACHE_NAME = 'dmtools-v__BUILD_VERSION__';
const RUNTIME_CACHE = 'dmtools-runtime-v__BUILD_VERSION__';

// Resources to cache immediately
const CORE_RESOURCES = [
  '/',
  '/index.html',
  '/manifest.json',
  '/favicon.png',
  '/icons/Icon-192.png',
  '/icons/Icon-512.png',
  '/css/shared-theme.css',
  '/js/shared-theme.js',
  '/animation_worker.js'
];

// Install event - cache core resources
self.addEventListener('install', (event) => {
  console.log('Service Worker installing with cache:', CACHE_NAME);
  
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => {
        console.log('Caching core resources');
        return cache.addAll(CORE_RESOURCES);
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
  
  // Handle Flutter resources with network-first strategy
  if (isFlutterResource(url.pathname)) {
    event.respondWith(networkFirstStrategy(event.request));
  }
  // Handle static assets with cache-first strategy
  else if (isStaticAsset(url.pathname)) {
    event.respondWith(cacheFirstStrategy(event.request));
  }
  // Handle API calls with network-only strategy
  else if (isApiCall(url.pathname)) {
    event.respondWith(networkOnlyStrategy(event.request));
  }
  // Default to network-first for everything else
  else {
    event.respondWith(networkFirstStrategy(event.request));
  }
});

// Network-first strategy (always try network, fallback to cache)
async function networkFirstStrategy(request) {
  try {
    const networkResponse = await fetch(request);
    
    // Cache successful responses
    if (networkResponse.ok) {
      const cache = await caches.open(RUNTIME_CACHE);
      cache.put(request, networkResponse.clone());
    }
    
    return networkResponse;
  } catch (error) {
    console.log('Network failed, trying cache:', request.url);
    const cachedResponse = await caches.match(request);
    
    if (cachedResponse) {
      return cachedResponse;
    }
    
    throw error;
  }
}

// Cache-first strategy (try cache first, fallback to network)
async function cacheFirstStrategy(request) {
  const cachedResponse = await caches.match(request);
  
  if (cachedResponse) {
    return cachedResponse;
  }
  
  try {
    const networkResponse = await fetch(request);
    
    if (networkResponse.ok) {
      const cache = await caches.open(RUNTIME_CACHE);
      cache.put(request, networkResponse.clone());
    }
    
    return networkResponse;
  } catch (error) {
    console.error('Failed to fetch resource:', request.url, error);
    throw error;
  }
}

// Network-only strategy (always use network)
async function networkOnlyStrategy(request) {
  return fetch(request);
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