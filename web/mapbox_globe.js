// 3D Globe Web Bridge for Flutter Web

window.mapboxGlobeInstances = window.mapboxGlobeInstances || {};
window.mapboxGlobeMarkers = window.mapboxGlobeMarkers || {};

// Standalone High-Resolution Satellite 3D Globe Style (ArcGIS World Imagery + Labels)
const ESRI_SATELLITE_GLOBE_STYLE = {
  version: 8,
  name: 'Satellite 3D Globe',
  sources: {
    'esri-world-imagery': {
      type: 'raster',
      tiles: [
        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
        'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
      ],
      tileSize: 256,
      attribution: 'Esri, Maxar, Earthstar Geographics'
    },
    'esri-boundaries-labels': {
      type: 'raster',
      tiles: [
        'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}'
      ],
      tileSize: 256
    }
  },
  layers: [
    {
      id: 'esri-imagery-layer',
      type: 'raster',
      source: 'esri-world-imagery',
      minzoom: 0,
      maxzoom: 19
    },
    {
      id: 'esri-labels-layer',
      type: 'raster',
      source: 'esri-boundaries-labels',
      minzoom: 0,
      maxzoom: 19,
      paint: {
        'raster-opacity': 0.85
      }
    }
  ]
};

// Helper to find DOM elements across Shadow DOM boundaries in Flutter Web (CanvasKit / HTML / multi-view)
function findElementDeep(id) {
  if (!id) return null;
  // 1. Direct getElementById
  let el = document.getElementById(id);
  if (el) return el;

  // 2. Query selector
  try {
    el = document.querySelector('#' + CSS.escape(id)) || document.querySelector('[id="' + id + '"]');
    if (el) return el;
  } catch (_) {}

  // 3. Recursive Shadow Root search
  function searchShadow(root) {
    if (!root) return null;
    const direct = root.querySelector ? root.querySelector('[id="' + id + '"]') : null;
    if (direct) return direct;

    const all = root.querySelectorAll ? root.querySelectorAll('*') : [];
    for (let i = 0; i < all.length; i++) {
      const node = all[i];
      if (node.id === id) return node;
      if (node.shadowRoot) {
        const found = searchShadow(node.shadowRoot);
        if (found) return found;
      }
    }
    return null;
  }

  const hosts = document.querySelectorAll('flt-glass-pane, flutter-view, flt-platform-view, *');
  for (let i = 0; i < hosts.length; i++) {
    if (hosts[i].shadowRoot) {
      const found = searchShadow(hosts[i].shadowRoot);
      if (found) return found;
    }
  }

  return null;
}

window.initMapboxGlobeWeb = function(viewId, containerEl, initialLng, initialLat, initialZoom, initialStyleJson) {
  // Allow signature flexibility: (viewId, initialLng, initialLat, initialZoom, initialStyleJson) OR (viewId, containerEl, initialLng, initialLat, initialZoom, initialStyleJson)
  let lng = initialLng;
  let lat = initialLat;
  let zoom = initialZoom;
  let styleJson = initialStyleJson;

  let targetContainer = null;
  if (containerEl && (containerEl instanceof HTMLElement || containerEl.nodeType === 1)) {
    targetContainer = containerEl;
  } else if (typeof containerEl === 'number') {
    // containerEl was actually initialLng
    lng = containerEl;
    lat = initialLng;
    zoom = initialLat;
    styleJson = initialZoom;
  }

  let attempts = 0;
  const maxAttempts = 40;

  function tryInit() {
    attempts++;

    if (!targetContainer) {
      targetContainer = findElementDeep(viewId);
    }

    if (!targetContainer || typeof mapboxgl === 'undefined') {
      if (attempts < maxAttempts) {
        setTimeout(tryInit, 100);
      } else {
        console.warn("Could not find container or mapboxgl for viewId:", viewId);
      }
      return;
    }

    // Ensure container has fill styles
    targetContainer.style.width = '100%';
    targetContainer.style.height = '100%';
    targetContainer.style.position = 'relative';
    targetContainer.style.overflow = 'hidden';
    targetContainer.style.backgroundColor = '#0b0b19';

    // If an instance already exists for this viewId, remove it first
    if (window.mapboxGlobeInstances[viewId]) {
      try {
        window.mapboxGlobeInstances[viewId].remove();
      } catch (_) {}
    }

    mapboxgl.accessToken = 'pk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA';
    if (mapboxgl.config) {
      mapboxgl.config.EVENTS_URL = null;
    }

    const map = new mapboxgl.Map({
      container: targetContainer,
      style: ESRI_SATELLITE_GLOBE_STYLE,
      center: [lng || 47.189224, lat || 24.694291],
      zoom: zoom || 3.8,
      projection: 'globe',
      renderWorldCopies: false,
      attributionControl: false
    });

    const applyAtmosphere = () => {
      try {
        map.setFog({
          'color': 'rgb(186, 210, 235)',
          'high-color': 'rgb(36, 92, 223)',
          'horizon-blend': 0.02,
          'space-color': 'rgb(11, 11, 25)',
          'star-intensity': 0.6
        });
      } catch (e) {
        console.warn("Could not set fog atmosphere:", e);
      }
    };

    map.on('style.load', applyAtmosphere);
    map.on('load', () => {
      applyAtmosphere();
      map.resize();
    });

    map.on('error', (e) => {
      if (e && e.error && e.error.status !== 401) {
        console.warn("Mapbox event:", e);
      }
    });

    window.mapboxGlobeInstances[viewId] = map;
    window.mapboxGlobeMarkers[viewId] = [];

    // Trigger multiple resize checks as Flutter completes layout & sizing
    [50, 150, 300, 600, 1200].forEach(delay => {
      setTimeout(() => {
        try {
          map.resize();
        } catch (_) {}
      }, delay);
    });

    // Attach ResizeObserver to continuously handle any Flutter Web container size changes
    if (typeof ResizeObserver !== 'undefined' && targetContainer) {
      const ro = new ResizeObserver(() => {
        try {
          map.resize();
        } catch (_) {}
      });
      ro.observe(targetContainer);
    }

    return map;
  }

  tryInit();
};

window.mapboxGlobeFlyToWeb = function(viewId, lng, lat, zoom) {
  const map = window.mapboxGlobeInstances[viewId];
  if (map) {
    try {
      map.flyTo({
        center: [lng, lat],
        zoom: zoom || 6.0,
        essential: true,
        duration: 1500
      });
    } catch (e) {
      console.warn("flyToWeb error:", e);
    }
  }
};

window.mapboxGlobeSetStyleJSONWeb = function(viewId, styleJsonStr) {
  const map = window.mapboxGlobeInstances[viewId];
  if (map) {
    try {
      if (typeof styleJsonStr === 'string' && styleJsonStr.trim().length > 10) {
        const parsed = JSON.parse(styleJsonStr);
        if (parsed && parsed.version) {
          // If style does not have esri-world-imagery or relies purely on broken mapbox urls,
          // ensure globe projection and imagery stay intact
          parsed.projection = parsed.projection || { name: 'globe' };
          map.setStyle(parsed);
        }
      }
    } catch (e) {
      console.warn("Error setting custom map style, falling back to base satellite:", e);
      try {
        map.setStyle(ESRI_SATELLITE_GLOBE_STYLE);
      } catch (_) {}
    }
  }
};

window.mapboxGlobeClearMarkersWeb = function(viewId) {
  const markers = window.mapboxGlobeMarkers[viewId];
  if (markers && Array.isArray(markers)) {
    markers.forEach(m => {
      try {
        m.remove();
      } catch (_) {}
    });
    window.mapboxGlobeMarkers[viewId] = [];
  }
};

window.mapboxGlobeAddMarkerWeb = function(viewId, lng, lat, iconUrl, markerId, callbackName) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;

  const el = document.createElement('div');
  el.className = 'mapbox-custom-marker';
  el.style.width = '32px';
  el.style.height = '32px';
  el.style.cursor = 'pointer';
  el.style.backgroundImage = 'url(' + iconUrl + ')';
  el.style.backgroundSize = 'contain';
  el.style.backgroundRepeat = 'no-repeat';
  el.style.backgroundPosition = 'center';

  el.addEventListener('click', (e) => {
    e.stopPropagation();
    if (window[callbackName]) {
      window[callbackName](markerId);
    }
  });

  try {
    const marker = new mapboxgl.Marker({ element: el })
      .setLngLat([lng, lat])
      .addTo(map);

    window.mapboxGlobeMarkers[viewId] = window.mapboxGlobeMarkers[viewId] || [];
    window.mapboxGlobeMarkers[viewId].push(marker);
  } catch (e) {
    console.warn("Error adding marker:", e);
  }
};
