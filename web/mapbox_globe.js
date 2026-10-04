// 3D Globe Web Bridge for Flutter Web (MapLibre GL JS v5 — Token-Free)

window.mapboxGlobeInstances = window.mapboxGlobeInstances || {};
window.mapboxGlobeMarkers   = window.mapboxGlobeMarkers   || {};

// ---------------------------------------------------------------------------
// Satellite + Labels base style (ArcGIS / Esri — fully public, no token)
// ---------------------------------------------------------------------------
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
      attribution: '© Esri, Maxar, Earthstar Geographics'
    },
    'esri-labels': {
      type: 'raster',
      tiles: [
        'https://server.arcgisonline.com/ArcGIS/rest/services/Reference/World_Boundaries_and_Places/MapServer/tile/{z}/{y}/{x}'
      ],
      tileSize: 256
    }
  },
  layers: [
    { id: 'imagery', type: 'raster', source: 'esri-world-imagery',
      minzoom: 0, maxzoom: 19 },
    { id: 'labels',  type: 'raster', source: 'esri-labels',
      minzoom: 0, maxzoom: 19, paint: { 'raster-opacity': 0.85 } }
  ]
};

// ---------------------------------------------------------------------------
// Resolve Flutter Web asset paths  (assets/images/x  →  assets/assets/images/x)
// ---------------------------------------------------------------------------
function resolveAssetUrl(url) {
  if (!url) return '';
  if (/^(https?:|data:|blob:)/.test(url)) return url;
  const clean = url.replace(/^\.?\//, '');
  if (clean.startsWith('assets/assets/')) return clean;
  if (clean.startsWith('assets/'))        return 'assets/' + clean;
  return 'assets/assets/' + clean;
}

// ---------------------------------------------------------------------------
// Deep-DOM search (handles Flutter's Shadow-Root iframes / glass-pane)
// ---------------------------------------------------------------------------
function findElementDeep(id) {
  const direct = document.getElementById(id);
  if (direct) return direct;

  function searchRoot(root) {
    if (!root) return null;
    const hit = root.querySelector && root.querySelector('[id="' + id + '"]');
    if (hit) return hit;
    const all = root.querySelectorAll ? root.querySelectorAll('*') : [];
    for (let i = 0; i < all.length; i++) {
      if (all[i].id === id) return all[i];
      const inner = all[i].shadowRoot ? searchRoot(all[i].shadowRoot) : null;
      if (inner) return inner;
    }
    return null;
  }

  const hosts = document.querySelectorAll('flt-glass-pane,flutter-view,flt-platform-view,*');
  for (let i = 0; i < hosts.length; i++) {
    if (hosts[i].shadowRoot) {
      const found = searchRoot(hosts[i].shadowRoot);
      if (found) return found;
    }
  }
  return null;
}

// ---------------------------------------------------------------------------
// initMapboxGlobeWeb(viewId, containerEl, lng, lat, zoom, styleJson)
//   containerEl can be an HTMLElement (passed from Dart) or omitted (null/number)
// ---------------------------------------------------------------------------
window.initMapboxGlobeWeb = function(viewId, containerEl, initialLng, initialLat, initialZoom) {
  let lng = initialLng, lat = initialLat, zoom = initialZoom;
  let targetContainer = null;

  if (containerEl && (containerEl instanceof HTMLElement || containerEl.nodeType === 1)) {
    targetContainer = containerEl;
  } else if (typeof containerEl === 'number') {
    // Called with old 5-arg signature (no containerEl)
    lng = containerEl; lat = initialLng; zoom = initialLat;
  }

  let attempts = 0;
  function tryInit() {
    if (++attempts > 60) {
      console.warn('[Globe] Container not found for', viewId);
      return;
    }

    if (!targetContainer) targetContainer = findElementDeep(viewId);
    if (!targetContainer || typeof maplibregl === 'undefined') {
      return setTimeout(tryInit, 80);
    }

    // Style the container
    Object.assign(targetContainer.style, {
      width: '100%', height: '100%',
      position: 'absolute', inset: '0',
      overflow: 'hidden', backgroundColor: '#0b0b19'
    });

    // Destroy previous instance for this viewId
    if (window.mapboxGlobeInstances[viewId]) {
      try { window.mapboxGlobeInstances[viewId].remove(); } catch (_) {}
    }

    // -----------------------------------------------------------------------
    // Create MapLibre v5 Map  (no token needed)
    // -----------------------------------------------------------------------
    const map = new maplibregl.Map({
      container:          targetContainer,
      style:              ESRI_SATELLITE_GLOBE_STYLE,
      center:             [lng || 47.189224, lat || 24.694291],
      zoom:               zoom || 3.8,
      renderWorldCopies:  false,
      attributionControl: false
    });

    // -----------------------------------------------------------------------
    // Apply 3D Globe + Atmosphere after style loads  (MapLibre v5 API)
    // -----------------------------------------------------------------------
    map.on('style.load', () => {
      // Globe projection — MapLibre v5 API
      try { map.setProjection({ type: 'globe' }); } catch(e) {
        console.warn('[Globe] setProjection failed:', e);
      }

      // Atmospheric sky / fog
      try {
        map.setFog({
          'range':            [0.5, 10],
          'color':            'rgb(186,210,235)',
          'high-color':       'rgb(36,92,223)',
          'horizon-blend':    0.05,
          'space-color':      'rgb(11,11,25)',
          'star-intensity':   0.6
        });
      } catch (e) {
        console.warn('[Globe] setFog failed:', e);
      }

      map.resize();
    });

    map.on('error', e => {
      const status = e && e.error && e.error.status;
      if (status && status !== 401 && status !== 404) console.warn('[Globe] Map error:', e);
    });

    window.mapboxGlobeInstances[viewId] = map;
    window.mapboxGlobeMarkers[viewId]   = [];

    // Progressive resize bursts (Flutter canvas settles over ~2 s)
    [50, 150, 300, 600, 1200, 2000].forEach(d =>
      setTimeout(() => { try { map.resize(); } catch (_) {} }, d)
    );

    // Continuous resize via ResizeObserver
    if (typeof ResizeObserver !== 'undefined') {
      new ResizeObserver(() => { try { map.resize(); } catch (_) {} })
        .observe(targetContainer);
    }
  }

  tryInit();
};

// ---------------------------------------------------------------------------
// flyTo
// ---------------------------------------------------------------------------
window.mapboxGlobeFlyToWeb = function(viewId, lng, lat, zoom) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;
  try {
    map.flyTo({ center: [lng, lat], zoom: zoom || 6.0, essential: true, duration: 1500 });
  } catch (e) { console.warn('[Globe] flyTo error:', e); }
};

// ---------------------------------------------------------------------------
// setStyle — ignores Mapbox-proprietary styles; falls back gracefully
// ---------------------------------------------------------------------------
window.mapboxGlobeSetStyleJSONWeb = function(viewId, styleJsonStr) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;
  try {
    const parsed = JSON.parse(styleJsonStr || '');
    if (parsed && parsed.version) {
      // Strip out mapbox:// sources that won't work without a valid token
      if (parsed.sources) {
        Object.keys(parsed.sources).forEach(key => {
          const src = parsed.sources[key];
          if (src.url && src.url.startsWith('mapbox://')) delete parsed.sources[key];
          if (src.tiles) {
            src.tiles = src.tiles.filter(t => !t.startsWith('mapbox://'));
            if (!src.tiles.length) delete parsed.sources[key];
          }
        });
      }
      // Filter layers that reference removed sources
      if (parsed.layers) {
        const validSources = new Set(Object.keys(parsed.sources || {}));
        parsed.layers = parsed.layers.filter(l => !l.source || validSources.has(l.source));
      }
      // Re-inject satellite tiles if nothing is left
      if (!parsed.sources || !Object.keys(parsed.sources).length) {
        parsed.sources = ESRI_SATELLITE_GLOBE_STYLE.sources;
        parsed.layers  = ESRI_SATELLITE_GLOBE_STYLE.layers;
      }
      map.setStyle(parsed);
      // Re-apply globe after style swap
      map.once('style.load', () => {
        try { map.setProjection({ type: 'globe' }); } catch (_) {}
        try {
          map.setFog({
            'range': [0.5, 10], 'color': 'rgb(186,210,235)',
            'high-color': 'rgb(36,92,223)', 'horizon-blend': 0.05,
            'space-color': 'rgb(11,11,25)', 'star-intensity': 0.6
          });
        } catch (_) {}
      });
    }
  } catch (e) {
    console.warn('[Globe] setStyle fallback:', e);
    try { map.setStyle(ESRI_SATELLITE_GLOBE_STYLE); } catch (_) {}
  }
};

// ---------------------------------------------------------------------------
// Markers — clear
// ---------------------------------------------------------------------------
window.mapboxGlobeClearMarkersWeb = function(viewId) {
  const markers = window.mapboxGlobeMarkers[viewId];
  if (!Array.isArray(markers)) return;
  markers.forEach(m => { try { m.remove(); } catch (_) {} });
  window.mapboxGlobeMarkers[viewId] = [];
};

// ---------------------------------------------------------------------------
// Markers — add
//   The key fix for "scattering": anchor the marker element to its CENTER
//   so it sits exactly on the coordinate, not at the top-left corner.
// ---------------------------------------------------------------------------
window.mapboxGlobeAddMarkerWeb = function(viewId, lng, lat, iconUrl, markerId, callbackName) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;

  const SIZE = 36;
  const resolvedUrl = resolveAssetUrl(iconUrl);

  // Outer wrapper — MUST be 0×0 so the marker anchor = center of the icon
  const wrapper = document.createElement('div');
  wrapper.style.cssText =
    'position:relative;width:0;height:0;overflow:visible;cursor:pointer;';

  // Icon div — centred via negative margin
  const el = document.createElement('div');
  el.className = 'mapbox-custom-marker';
  el.style.cssText =
    `width:${SIZE}px;height:${SIZE}px;` +
    `position:absolute;top:-${SIZE/2}px;left:-${SIZE/2}px;` +
    'display:flex;align-items:center;justify-content:center;' +
    'filter:drop-shadow(0 3px 6px rgba(0,0,0,.55));' +
    'transition:transform .15s ease;pointer-events:auto;';

  el.onmouseenter = () => { el.style.transform = 'scale(1.3)'; };
  el.onmouseleave = () => { el.style.transform = 'scale(1.0)'; };

  const img = document.createElement('img');
  img.style.cssText = 'width:100%;height:100%;object-fit:contain;display:block;';
  img.src = resolvedUrl;

  let _retry = 0;
  const fallbackPaths = [iconUrl, 'assets/' + iconUrl, 'assets/assets/' + iconUrl];
  img.onerror = function() {
    if (_retry < fallbackPaths.length) { this.src = fallbackPaths[_retry++]; }
    else {
      // Gold dot fallback
      el.innerHTML =
        '<div style="width:20px;height:20px;background:#D4AF37;border:2px solid #fff;' +
        'border-radius:50%;box-shadow:0 0 8px rgba(212,175,55,.8);"></div>';
    }
  };

  el.appendChild(img);
  wrapper.appendChild(el);

  wrapper.addEventListener('click', e => {
    e.stopPropagation();
    if (window[callbackName]) window[callbackName](markerId);
  });

  try {
    // anchor:'center' ensures the marker point = exact [lng,lat]
    const marker = new maplibregl.Marker({ element: wrapper, anchor: 'center' })
      .setLngLat([lng, lat])
      .addTo(map);

    window.mapboxGlobeMarkers[viewId] = window.mapboxGlobeMarkers[viewId] || [];
    window.mapboxGlobeMarkers[viewId].push(marker);
  } catch (e) {
    console.warn('[Globe] addMarker error:', e);
  }
};
