// 3D Globe Web Bridge for Flutter Web (MapLibre v4 / Mapbox GL)

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

function resolveAssetUrl(url) {
  if (!url) return '';
  if (url.startsWith('http://') || url.startsWith('https://') || url.startsWith('data:') || url.startsWith('blob:')) {
    return url;
  }
  let clean = url.replace(/^\.?\//, '');
  if (clean.startsWith('assets/assets/')) {
    return clean;
  }
  if (clean.startsWith('assets/')) {
    return 'assets/' + clean;
  }
  return 'assets/assets/' + clean;
}

// Helper to find DOM elements across Shadow DOM boundaries in Flutter Web
function findElementDeep(id) {
  if (!id) return null;
  let el = document.getElementById(id);
  if (el) return el;

  try {
    el = document.querySelector('#' + CSS.escape(id)) || document.querySelector('[id="' + id + '"]');
    if (el) return el;
  } catch (_) {}

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
  let lng = initialLng;
  let lat = initialLat;
  let zoom = initialZoom;
  let styleJson = initialStyleJson;

  let targetContainer = null;
  if (containerEl && (containerEl instanceof HTMLElement || containerEl.nodeType === 1)) {
    targetContainer = containerEl;
  } else if (typeof containerEl === 'number') {
    lng = containerEl;
    lat = initialLng;
    zoom = initialLat;
    styleJson = initialZoom;
  }

  let attempts = 0;
  const maxAttempts = 50;

  function tryInit() {
    attempts++;

    if (!targetContainer) {
      targetContainer = findElementDeep(viewId);
    }

    const MapEngine = (typeof maplibregl !== 'undefined') ? maplibregl : (typeof mapboxgl !== 'undefined' ? mapboxgl : null);

    if (!targetContainer || !MapEngine) {
      if (attempts < maxAttempts) {
        setTimeout(tryInit, 80);
      } else {
        console.warn("Could not find container or map engine for viewId:", viewId);
      }
      return;
    }

    // Ensure container styling
    targetContainer.style.width = '100%';
    targetContainer.style.height = '100%';
    targetContainer.style.position = 'relative';
    targetContainer.style.overflow = 'hidden';
    targetContainer.style.backgroundColor = '#0b0b19';

    // Remove any previous instance on the same container
    if (window.mapboxGlobeInstances[viewId]) {
      try {
        window.mapboxGlobeInstances[viewId].remove();
      } catch (_) {}
    }

    // Configure token for Mapbox if Mapbox GL is active
    if (typeof mapboxgl !== 'undefined' && MapEngine === mapboxgl) {
      mapboxgl.accessToken = 'pk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA';
      if (mapboxgl.config) {
        mapboxgl.config.EVENTS_URL = null;
      }
    }

    const map = new MapEngine.Map({
      container: targetContainer,
      style: ESRI_SATELLITE_GLOBE_STYLE,
      center: [lng || 47.189224, lat || 24.694291],
      zoom: zoom || 3.8,
      projection: (typeof maplibregl !== 'undefined') ? { type: 'globe' } : 'globe',
      renderWorldCopies: false,
      attributionControl: false
    });

    const applyAtmosphere = () => {
      try {
        if (map.setProjection) {
          map.setProjection({ type: 'globe' });
        }
      } catch (_) {}
      try {
        if (map.setFog) {
          map.setFog({
            'color': 'rgb(186, 210, 235)',
            'high-color': 'rgb(36, 92, 223)',
            'horizon-blend': 0.02,
            'space-color': 'rgb(11, 11, 25)',
            'star-intensity': 0.6
          });
        }
      } catch (e) {
        console.warn("Fog setting:", e);
      }
    };

    map.on('style.load', applyAtmosphere);
    map.on('load', () => {
      applyAtmosphere();
      map.resize();
    });

    map.on('error', (e) => {
      if (e && e.error && e.error.status !== 401 && e.error.status !== 404) {
        console.warn("Map event:", e);
      }
    });

    window.mapboxGlobeInstances[viewId] = map;
    window.mapboxGlobeMarkers[viewId] = [];

    // Trigger progressive resize cycles as Flutter completes canvas layout
    [50, 150, 300, 600, 1200, 2000].forEach(delay => {
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
          parsed.projection = parsed.projection || { name: 'globe' };
          map.setStyle(parsed);
        }
      }
    } catch (e) {
      console.warn("Falling back to base satellite style:", e);
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

  const resolvedUrl = resolveAssetUrl(iconUrl);

  const el = document.createElement('div');
  el.className = 'mapbox-custom-marker';
  el.style.width = '36px';
  el.style.height = '36px';
  el.style.cursor = 'pointer';
  el.style.display = 'flex';
  el.style.alignItems = 'center';
  el.style.justifyContent = 'center';
  el.style.filter = 'drop-shadow(0px 3px 6px rgba(0,0,0,0.5))';
  el.style.transition = 'transform 0.15s ease';

  el.onmouseenter = () => { el.style.transform = 'scale(1.25)'; };
  el.onmouseleave = () => { el.style.transform = 'scale(1.0)'; };

  const img = document.createElement('img');
  img.src = resolvedUrl;
  img.style.width = '100%';
  img.style.height = '100%';
  img.style.objectFit = 'contain';

  // Resilient fallback if asset path differs
  img.onerror = function() {
    if (!this._retriedDirect) {
      this._retriedDirect = true;
      this.src = iconUrl;
    } else if (!this._retriedAssets) {
      this._retriedAssets = true;
      this.src = 'assets/' + iconUrl;
    } else {
      el.innerHTML = '<div style="width:22px;height:22px;background:#D4AF37;border:2px solid #ffffff;border-radius:50%;box-shadow:0 0 8px rgba(212,175,55,0.8);"></div>';
    }
  };

  el.appendChild(img);

  el.addEventListener('click', (e) => {
    e.stopPropagation();
    if (window[callbackName]) {
      window[callbackName](markerId);
    }
  });

  const MapEngine = (typeof maplibregl !== 'undefined') ? maplibregl : mapboxgl;
  try {
    const marker = new MapEngine.Marker({ element: el })
      .setLngLat([lng, lat])
      .addTo(map);

    window.mapboxGlobeMarkers[viewId] = window.mapboxGlobeMarkers[viewId] || [];
    window.mapboxGlobeMarkers[viewId].push(marker);
  } catch (e) {
    console.warn("Error adding marker:", e);
  }
};
