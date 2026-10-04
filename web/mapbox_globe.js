// 3D Globe Web Bridge for Flutter Web (MapLibre GL JS v5 — Token-Free)

window.mapboxGlobeInstances  = window.mapboxGlobeInstances  || {};
window.mapboxGlobeMarkers    = window.mapboxGlobeMarkers    || {};
window.mapboxGlobePendingCbs = window.mapboxGlobePendingCbs || {};   // queued marker calls

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
    { id: 'imagery', type: 'raster', source: 'esri-world-imagery', minzoom: 0, maxzoom: 19 },
    { id: 'labels',  type: 'raster', source: 'esri-labels',
      minzoom: 0, maxzoom: 19, paint: { 'raster-opacity': 0.85 } }
  ]
};

// ---------------------------------------------------------------------------
// Resolve Flutter Web asset path  (Flutter dev server doubles the "assets/" prefix)
// Input:  "assets/assets/images/x.png"  → "assets/assets/images/x.png"
// Input:  "assets/images/x.png"         → "assets/assets/images/x.png"
// Input:  "images/x.png"                → "assets/assets/images/x.png"
// ---------------------------------------------------------------------------
function resolveAssetUrl(url) {
  if (!url) return '';
  if (/^(https?:|data:|blob:)/.test(url)) return url;
  let clean = url.replace(/^\.?\//, '');
  if (clean.startsWith('assets/assets/')) return clean;
  if (clean.startsWith('assets/'))        return 'assets/' + clean;
  return 'assets/assets/' + clean;
}

// ---------------------------------------------------------------------------
// Internal: actually add a single marker to a ready map
// ---------------------------------------------------------------------------
function _doAddMarker(map, viewId, lng, lat, iconUrl, markerId, callbackName) {
  const SIZE = 38;
  const resolvedUrl = resolveAssetUrl(iconUrl);

  const el = document.createElement('div');
  el.style.cssText =
    `width:${SIZE}px;height:${SIZE}px;` +
    'display:flex;align-items:center;justify-content:center;' +
    'filter:drop-shadow(0 3px 8px rgba(0,0,0,.65));' +
    'transition:transform .15s ease;pointer-events:auto;cursor:pointer;' +
    'touch-action:none;'; // prevent browser scroll/pan gesture on the marker

  el.onmouseenter = () => { el.style.transform = 'scale(1.3)'; };
  el.onmouseleave = () => { el.style.transform = 'scale(1.0)'; };

  const img = document.createElement('img');
  img.style.cssText = 'width:100%;height:100%;object-fit:contain;display:block;pointer-events:none;';
  img.src = resolvedUrl;

  // Resilient fallback chain: resolved → raw → assets/raw → dot
  const fallbacks = [iconUrl, 'assets/' + iconUrl, 'assets/assets/' + iconUrl];
  let fbIdx = 0;
  img.onerror = function() {
    if (fbIdx < fallbacks.length) {
      const next = fallbacks[fbIdx++];
      if (next !== this.src) { this.src = next; return; }
      fbIdx++;
      if (fbIdx <= fallbacks.length) { this.src = fallbacks[fbIdx-1]; return; }
    }
    // Gold dot fallback
    el.innerHTML =
      '<div style="width:22px;height:22px;background:#D4AF37;border:2px solid #fff;' +
      'border-radius:50%;box-shadow:0 0 10px rgba(212,175,55,.9);"></div>';
  };

  el.appendChild(img);

  // ── Click (mouse) ──────────────────────────────────────────────────────────
  el.addEventListener('click', e => {
    e.stopPropagation();
    e.preventDefault();
    if (window[callbackName]) window[callbackName](markerId);
  });

  // ── Touch (mobile / tablet) ────────────────────────────────────────────────
  // Track touch start position so we can distinguish a tap from a drag.
  let _touchStartX = 0;
  let _touchStartY = 0;

  el.addEventListener('touchstart', e => {
    // Block the map from receiving this touch and starting a pan/drag.
    e.stopPropagation();
    e.preventDefault();
    if (e.touches.length > 0) {
      _touchStartX = e.touches[0].clientX;
      _touchStartY = e.touches[0].clientY;
    }
    el.style.transform = 'scale(1.3)';
  }, { passive: false });

  el.addEventListener('touchend', e => {
    e.stopPropagation();
    e.preventDefault();
    el.style.transform = 'scale(1.0)';
    // Only fire callback if the finger didn't move much (tap, not drag).
    const dx = e.changedTouches.length > 0 ? Math.abs(e.changedTouches[0].clientX - _touchStartX) : 0;
    const dy = e.changedTouches.length > 0 ? Math.abs(e.changedTouches[0].clientY - _touchStartY) : 0;
    if (dx < 10 && dy < 10) {
      if (window[callbackName]) window[callbackName](markerId);
    }
  }, { passive: false });

  el.addEventListener('touchcancel', e => {
    e.stopPropagation();
    el.style.transform = 'scale(1.0)';
  }, { passive: false });

  try {
    // anchor:'center' = the element's center sits exactly on [lng,lat]
    const marker = new maplibregl.Marker({ element: el, anchor: 'center' })
      .setLngLat([lng, lat])
      .addTo(map);

    window.mapboxGlobeMarkers[viewId] = window.mapboxGlobeMarkers[viewId] || [];
    window.mapboxGlobeMarkers[viewId].push(marker);
  } catch (e) {
    console.warn('[Globe] addMarker error:', e);
  }
}

// ---------------------------------------------------------------------------
// initMapboxGlobeWeb
//   viewId       – the DOM id of the container element (domId from Dart)
//   containerEl  – the actual HTMLElement (passed from Dart via js interop)
//   lng, lat, zoom – initial camera
// ---------------------------------------------------------------------------
window.initMapboxGlobeWeb = function(viewId, containerEl, initialLng, initialLat, initialZoom) {
  let lng = initialLng, lat = initialLat, zoom = initialZoom;
  let targetContainer = null;

  if (containerEl && (typeof HTMLElement !== 'undefined') &&
      (containerEl instanceof HTMLElement || containerEl.nodeType === 1)) {
    targetContainer = containerEl;
  } else if (typeof containerEl === 'number') {
    // Old 5-arg call (no containerEl)
    lng = containerEl; lat = initialLng; zoom = initialLat;
  }

  // Also accept the div by ID immediately (sometimes JS receives it before Dart interop resolves)
  if (!targetContainer) {
    targetContainer = document.getElementById(viewId);
  }

  let attempts = 0;
  function tryInit() {
    if (++attempts > 80) {
      console.warn('[Globe] Giving up on container', viewId);
      return;
    }
    if (!targetContainer) {
      targetContainer = document.getElementById(viewId);
    }
    // Deep shadow-DOM search as last resort
    if (!targetContainer) {
      const all = document.querySelectorAll('*');
      for (let i = 0; i < all.length; i++) {
        if (all[i].id === viewId) { targetContainer = all[i]; break; }
        if (all[i].shadowRoot) {
          const hit = all[i].shadowRoot.querySelector('[id="' + viewId + '"]');
          if (hit) { targetContainer = hit; break; }
        }
      }
    }

    if (!targetContainer || typeof maplibregl === 'undefined') {
      return setTimeout(tryInit, 80);
    }

    // Style container to fill its slot
    Object.assign(targetContainer.style, {
      width: '100%', height: '100%',
      position: 'absolute', top: '0', left: '0', right: '0', bottom: '0',
      overflow: 'hidden', backgroundColor: '#0b0b19'
    });

    // Destroy existing instance
    if (window.mapboxGlobeInstances[viewId]) {
      try { window.mapboxGlobeInstances[viewId].remove(); } catch (_) {}
      delete window.mapboxGlobeInstances[viewId];
    }

    const map = new maplibregl.Map({
      container:          targetContainer,
      style:              ESRI_SATELLITE_GLOBE_STYLE,
      center:             [lng || 47.189224, lat || 24.694291],
      zoom:               zoom || 3.8,
      renderWorldCopies:  false,
      attributionControl: false
    });

    map.on('style.load', () => {
      // Globe projection (MapLibre v5 API)
      try { map.setProjection({ type: 'globe' }); } catch (e) {
        console.warn('[Globe] setProjection:', e);
      }
      // Atmosphere
      try {
        map.setFog({
          'range':          [0.5, 10],
          'color':          'rgb(186,210,235)',
          'high-color':     'rgb(36,92,223)',
          'horizon-blend':  0.05,
          'space-color':    'rgb(11,11,25)',
          'star-intensity': 0.6
        });
      } catch (_) {}
      map.resize();

      // ── Flush any markers that arrived before the map was ready ──
      window.mapboxGlobeInstances[viewId] = map;   // mark ready BEFORE flush
      const pending = window.mapboxGlobePendingCbs[viewId] || [];
      pending.forEach(fn => fn(map));
      delete window.mapboxGlobePendingCbs[viewId];
    });

    map.on('error', e => {
      const s = e && e.error && e.error.status;
      if (s && s !== 401 && s !== 404) console.warn('[Globe] error:', e);
    });

    window.mapboxGlobeInstances[viewId] = map;   // also set immediately for resize calls
    window.mapboxGlobeMarkers[viewId]   = [];

    // Progressive resize
    [50, 150, 300, 600, 1200, 2000].forEach(d =>
      setTimeout(() => { try { map.resize(); } catch (_) {} }, d)
    );
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
  } catch (e) { console.warn('[Globe] flyTo:', e); }
};

// ---------------------------------------------------------------------------
// setStyle — strips mapbox:// sources that need a token
// ---------------------------------------------------------------------------
window.mapboxGlobeSetStyleJSONWeb = function(viewId, styleJsonStr) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;
  try {
    const parsed = JSON.parse(styleJsonStr || '');
    if (parsed && parsed.version) {
      // Remove mapbox:// sources
      Object.keys(parsed.sources || {}).forEach(k => {
        const s = parsed.sources[k];
        const hasMapboxUrl   = s.url   && s.url.startsWith('mapbox://');
        const hasMapboxTiles = s.tiles && s.tiles.some(t => t.startsWith('mapbox://'));
        if (hasMapboxUrl || hasMapboxTiles) delete parsed.sources[k];
      });
      // Remove layers referencing deleted sources
      if (parsed.layers) {
        const ok = new Set(Object.keys(parsed.sources || {}));
        parsed.layers = parsed.layers.filter(l => !l.source || ok.has(l.source));
      }
      // If nothing is left after stripping, use base satellite
      if (!parsed.sources || !Object.keys(parsed.sources).length) {
        parsed.sources = ESRI_SATELLITE_GLOBE_STYLE.sources;
        parsed.layers  = ESRI_SATELLITE_GLOBE_STYLE.layers;
      }
      map.setStyle(parsed);
      map.once('style.load', () => {
        try { map.setProjection({ type: 'globe' }); } catch (_) {}
        try {
          map.setFog({
            'range': [0.5,10], 'color': 'rgb(186,210,235)',
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
// Clear markers
// ---------------------------------------------------------------------------
window.mapboxGlobeClearMarkersWeb = function(viewId) {
  (window.mapboxGlobeMarkers[viewId] || []).forEach(m => { try { m.remove(); } catch (_) {} });
  window.mapboxGlobeMarkers[viewId] = [];
  // Also clear any pending queue
  delete window.mapboxGlobePendingCbs[viewId];
};

// ---------------------------------------------------------------------------
// Add marker — queues call if the map isn't ready yet
// ---------------------------------------------------------------------------
window.mapboxGlobeAddMarkerWeb = function(viewId, lng, lat, iconUrl, markerId, callbackName) {
  const map = window.mapboxGlobeInstances[viewId];

  // Map is ready → add immediately
  if (map && map.loaded && map.loaded()) {
    _doAddMarker(map, viewId, lng, lat, iconUrl, markerId, callbackName);
    return;
  }

  // Map exists but style not loaded yet → wait for style.load event
  if (map) {
    map.once('style.load', () => _doAddMarker(map, viewId, lng, lat, iconUrl, markerId, callbackName));
    return;
  }

  // Map not initialised yet → queue and execute when initMapboxGlobeWeb fires
  if (!window.mapboxGlobePendingCbs[viewId]) {
    window.mapboxGlobePendingCbs[viewId] = [];
  }
  window.mapboxGlobePendingCbs[viewId].push(
    readyMap => _doAddMarker(readyMap, viewId, lng, lat, iconUrl, markerId, callbackName)
  );
};
