// Mapbox GL JS 3D Globe Web Bridge for Flutter Web

window.mapboxGlobeInstances = window.mapboxGlobeInstances || {};
window.mapboxGlobeMarkers = window.mapboxGlobeMarkers || {};

window.initMapboxGlobeWeb = function(viewId, initialLng, initialLat, initialZoom, initialStyleJson) {
  const container = document.getElementById(viewId);
  if (!container) return;

  mapboxgl.accessToken = 'sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA';

  let mapStyle = 'mapbox://styles/mapbox/satellite-streets-v12';
  if (initialStyleJson && initialStyleJson.length > 10) {
    try {
      mapStyle = JSON.parse(initialStyleJson);
    } catch(e) {
      console.warn("Could not parse style JSON, using default satellite-streets", e);
    }
  }

  const map = new mapboxgl.Map({
    container: viewId,
    style: mapStyle,
    center: [initialLng || 47.189224, initialLat || 24.694291],
    zoom: initialZoom || 4.3,
    projection: 'globe',
    attributionControl: false
  });

  map.on('style.load', () => {
    map.setFog({
      'color': 'rgb(186, 210, 235)',
      'high-color': 'rgb(36, 92, 223)',
      'horizon-blend': 0.02,
      'space-color': 'rgb(11, 11, 25)',
      'star-intensity': 0.6
    });
  });

  window.mapboxGlobeInstances[viewId] = map;
  window.mapboxGlobeMarkers[viewId] = [];

  // Spin globe slightly or handle resize
  setTimeout(() => {
    map.resize();
  }, 300);

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
      const parsed = typeof styleJsonStr === 'string' ? JSON.parse(styleJsonStr) : styleJsonStr;
      map.setStyle(parsed);
    } catch(e) {
      console.error("Error setting map style:", e);
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

  const marker = new mapboxgl.Marker(el)
    .setLngLat([lng, lat])
    .addTo(map);

  window.mapboxGlobeMarkers[viewId] = window.mapboxGlobeMarkers[viewId] || [];
  window.mapboxGlobeMarkers[viewId].push(marker);
};
