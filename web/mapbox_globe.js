// 3D Globe Web Bridge for Flutter Web (MapLibre / Mapbox GL)

window.mapboxGlobeInstances = window.mapboxGlobeInstances || {};
window.mapboxGlobeMarkers = window.mapboxGlobeMarkers || {};

// Standalone High-Resolution Satellite 3D Globe Style
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

window.initMapboxGlobeWeb = function(viewId, initialLng, initialLat, initialZoom, initialStyleJson) {
  const container = document.getElementById(viewId);
  if (!container) return;

  const MapLibrary = window.maplibregl || window.mapboxgl;
  if (!MapLibrary) {
    console.error("Map library not found.");
    return;
  }

  const map = new MapLibrary.Map({
    container: viewId,
    style: ESRI_SATELLITE_GLOBE_STYLE,
    center: [initialLng || 47.189224, initialLat || 24.694291],
    zoom: initialZoom || 4.3,
    attributionControl: false
  });

  // Enable 3D Globe Projection
  const enableGlobe = () => {
    try {
      if (typeof map.setProjection === 'function') {
        map.setProjection({ type: 'globe' });
      }
    } catch(e) {
      console.warn("Could not set globe projection:", e);
    }

    try {
      if (typeof map.setFog === 'function') {
        map.setFog({
          'color': 'rgb(186, 210, 235)',
          'high-color': 'rgb(36, 92, 223)',
          'horizon-blend': 0.02,
          'space-color': 'rgb(11, 11, 25)',
          'star-intensity': 0.6
        });
      }
    } catch(e) {}
  };

  map.on('load', enableGlobe);
  map.on('style.load', enableGlobe);

  map.on('error', (e) => {
    // Ignore minor tile load warnings
    if (e && e.error && e.error.status !== 401) {
      console.warn("Map event:", e);
    }
  });

  window.mapboxGlobeInstances[viewId] = map;
  window.mapboxGlobeMarkers[viewId] = [];

  setTimeout(() => {
    map.resize();
  }, 200);

  return map;
};

window.mapboxGlobeFlyToWeb = function(viewId, lng, lat, zoom) {
  const map = window.mapboxGlobeInstances[viewId];
  if (map) {
    map.flyTo({
      center: [lng, lat],
      zoom: zoom || 6.0,
      essential: true,
      duration: 1500
    });
  }
};

window.mapboxGlobeSetStyleJSONWeb = function(viewId, styleJsonStr) {
  const map = window.mapboxGlobeInstances[viewId];
  if (map) {
    try {
      if (typeof styleJsonStr === 'string' && styleJsonStr.trim().length > 10) {
        const parsed = JSON.parse(styleJsonStr);
        if (parsed && parsed.version) {
          map.setStyle(parsed);
        }
      }
    } catch(e) {
      console.warn("Error setting custom map style:", e);
    }
  }
};

window.mapboxGlobeClearMarkersWeb = function(viewId) {
  const markers = window.mapboxGlobeMarkers[viewId];
  if (markers) {
    markers.forEach(m => m.remove());
    window.mapboxGlobeMarkers[viewId] = [];
  }
};

window.mapboxGlobeAddMarkerWeb = function(viewId, lng, lat, iconUrl, markerId, callbackName) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;

  const MapLibrary = window.maplibregl || window.mapboxgl;
  if (!MapLibrary) return;

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

  const marker = new MapLibrary.Marker({ element: el })
    .setLngLat([lng, lat])
    .addTo(map);

  window.mapboxGlobeMarkers[viewId] = window.mapboxGlobeMarkers[viewId] || [];
  window.mapboxGlobeMarkers[viewId].push(marker);
};
