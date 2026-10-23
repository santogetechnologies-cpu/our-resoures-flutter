// 3D Globe Web Bridge for Flutter Web (MapLibre GL JS v5 — Token-Free)

window.mapboxGlobeInstances  = window.mapboxGlobeInstances  || {};
window.mapboxGlobeMarkers    = window.mapboxGlobeMarkers    || {};
window.mapboxGlobePendingCbs = window.mapboxGlobePendingCbs || {};   // queued marker calls

// ---------------------------------------------------------------------------
// RTL Text Plugin for MapLibre GL JS (Shapes and joins Arabic/RTL text)
// ---------------------------------------------------------------------------
function ensureRTLTextPlugin() {
  if (typeof maplibregl !== 'undefined' && maplibregl.setRTLTextPlugin) {
    try {
      if (maplibregl.getRTLTextPluginStatus() === 'unavailable') {
        maplibregl.setRTLTextPlugin(
          'https://unpkg.com/@mapbox/mapbox-gl-rtl-text@0.2.3/mapbox-gl-rtl-text.min.js',
          function (err) {
            if (err) console.error('[MapLibre RTL Text Plugin Error]:', err);
          },
          true
        );
      }
    } catch (e) {
      console.warn('[MapLibre RTL Text Plugin Init]:', e);
    }
  }
}
ensureRTLTextPlugin();

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
// Mapbox Access Token & Style Transformer for Vector Overlays
// ---------------------------------------------------------------------------
const MAPBOX_TOKEN = 'sk.eyJ1IjoibXNoYXJpLWFsam9oYW5pIiwiYSI6ImNscDRodndqczB4NzEya21pdXNjNDJ6MjUifQ.cm9WGcmnAXTlF0a-BdfgTA';

function sanitizeExpr(val) {
  if (Array.isArray(val)) {
    if (val[0] === 'step' && Array.isArray(val[1]) && val[1][0] === 'pitch') return true;
    if (val[0] === 'pitch' || val[0] === 'distance-from-center' || val[0] === 'measure-light') return true;
    return val.map(sanitizeExpr);
  }
  if (typeof val === 'object' && val !== null) {
    const res = {};
    for (const k in val) {
      res[k] = sanitizeExpr(val[k]);
    }
    return res;
  }
  return val;
}

function transformMapboxStyle(styleInput) {
  let styleObj = styleInput;
  if (typeof styleObj === 'string') {
    try {
      styleObj = JSON.parse(styleObj);
    } catch (e) {
      console.warn('[Globe] Failed to parse style JSON:', e);
      return ESRI_SATELLITE_GLOBE_STYLE;
    }
  }
  if (!styleObj || !styleObj.version) {
    return ESRI_SATELLITE_GLOBE_STYLE;
  }

  let style;
  try {
    style = JSON.parse(JSON.stringify(styleObj));
  } catch (_) {
    style = styleObj;
  }

  // Transform sources so MapLibre can load Mapbox vector and raster tiles directly
  style.sources = style.sources || {};
  Object.keys(style.sources).forEach(key => {
    const src = style.sources[key];
    if (!src) return;

    if (src.type === 'raster') {
      const isMapboxSat = (src.url && src.url.includes('mapbox.satellite')) ||
                          key.includes('mapbox.satellite') ||
                          (src.tiles && src.tiles.some(t => t.includes('mapbox.satellite')));
      if (isMapboxSat) {
        delete src.url;
        src.tiles = ['https://api.mapbox.com/v4/mapbox.satellite/{z}/{x}/{y}.webp?access_token=' + MAPBOX_TOKEN];
        src.tileSize = 256;
      } else if (!src.tiles) {
        delete src.url;
        src.tiles = [
          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
          'https://services.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
        ];
        src.tileSize = 256;
      }
    } else if (src.type === 'raster-dem') {
      if (src.url && src.url.startsWith('mapbox://')) {
        const demId = src.url.replace('mapbox://', '');
        delete src.url;
        src.tiles = ['https://api.mapbox.com/v4/' + demId + '/{z}/{x}/{y}.webp?access_token=' + MAPBOX_TOKEN];
        src.encoding = 'mapbox';
      }
    } else if (src.type === 'vector') {
      if (src.url && src.url.startsWith('mapbox://')) {
        const tileset = src.url.replace('mapbox://', '');
        delete src.url;
        src.tiles = ['https://api.mapbox.com/v4/' + tileset + '/{z}/{x}/{y}.vector.pbf?access_token=' + MAPBOX_TOKEN];
      }
    }
  });

  // Clean layers and sanitize Mapbox v3 unsupported expressions (e.g. pitch culling)
  if (Array.isArray(style.layers)) {
    style.layers.forEach((layer, idx) => {
      delete layer.slot;
      if (layer.filter) {
        layer.filter = sanitizeExpr(layer.filter);
      }
      if (layer.paint) {
        layer.paint = sanitizeExpr(layer.paint);
      }
      if (layer.layout) {
        layer.layout = sanitizeExpr(layer.layout);
      }
    });
  }

  // Remove Mapbox v3 specific top-level fields not supported by MapLibre
  delete style.lights;
  delete style.projection;
  delete style.draft;
  delete style.visibility;
  delete style.protected;
  delete style.created;
  delete style.modified;
  delete style.owner;
  delete style.terrain;
  delete style.fog;

  // Transform glyphs
  if (style.glyphs && style.glyphs.startsWith('mapbox://fonts/')) {
    style.glyphs = 'https://api.mapbox.com/fonts/v1/' + style.glyphs.replace('mapbox://fonts/', '') + '?access_token=' + MAPBOX_TOKEN;
  }

  // Transform sprite
  if (style.sprite && style.sprite.startsWith('mapbox://sprites/')) {
    style.sprite = 'https://api.mapbox.com/styles/v1/' + style.sprite.replace('mapbox://sprites/', '') + '/sprite?access_token=' + MAPBOX_TOKEN;
  }

  return style;
}

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

  // MapLibre's Marker attaches translate(X, Y) to `el`. We must NEVER modify `el.style.transform`.
  const el = document.createElement('div');
  el.className = 'mapbox-custom-marker';
  el.setAttribute('data-marker-id', markerId);
  el.style.cssText = 'pointer-events:auto;cursor:pointer;user-select:none;-webkit-user-select:none;';

  // Inner container for styling, shadow, and scale animations
  const inner = document.createElement('div');
  inner.style.cssText =
    `width:${SIZE}px;height:${SIZE}px;` +
    'display:flex;align-items:center;justify-content:center;' +
    'filter:drop-shadow(0 3px 8px rgba(0,0,0,.65));' +
    'transition:transform .15s ease;pointer-events:auto;';

  inner.onmouseenter = () => { inner.style.transform = 'scale(1.25)'; };
  inner.onmouseleave = () => { inner.style.transform = 'scale(1.0)'; };

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
    inner.innerHTML =
      '<div style="width:22px;height:22px;background:#D4AF37;border:2px solid #fff;' +
      'border-radius:50%;box-shadow:0 0 10px rgba(212,175,55,.9);"></div>';
  };

  inner.appendChild(img);
  el.appendChild(inner);

  // ── Click (mouse) ──────────────────────────────────────────────────────────
  el.addEventListener('click', e => {
    e.stopPropagation();
    if (window[callbackName]) window[callbackName](markerId);
  });

  // ── Touch (mobile / tablet) ────────────────────────────────────────────────
  let touchMoved = false;
  let startX = 0, startY = 0;

  el.addEventListener('touchstart', e => {
    touchMoved = false;
    if (e.touches.length > 0) {
      startX = e.touches[0].clientX;
      startY = e.touches[0].clientY;
    }
    inner.style.transform = 'scale(1.25)';
  }, { passive: true });

  el.addEventListener('touchmove', e => {
    if (e.touches.length > 0) {
      const dx = Math.abs(e.touches[0].clientX - startX);
      const dy = Math.abs(e.touches[0].clientY - startY);
      if (dx > 8 || dy > 8) {
        touchMoved = true;
      }
    }
  }, { passive: true });

  el.addEventListener('touchend', e => {
    inner.style.transform = 'scale(1.0)';
    if (!touchMoved) {
      e.stopPropagation();
      if (window[callbackName]) window[callbackName](markerId);
    }
  });

  el.addEventListener('touchcancel', () => {
    inner.style.transform = 'scale(1.0)';
  });

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
// Disable GPU PBO readback error measurement loop on globe projection
// MapLibre's ProjectionErrorMeasurement runs a GPU readback loop every 6 frames
// which triggers ANGLE buffer fence warnings & "WebGL: too many errors" in Chromium.
// ---------------------------------------------------------------------------
function disableGlobeReadbackErrorMeasurement(map) {
  try {
    const proj = map && map.style && map.style.projection;
    const vp = proj && (proj._verticalPerspectiveProjection ||
      (proj.currentProjection && proj.currentProjection.name === 'vertical-perspective' ? proj.currentProjection : null));
    if (vp) {
      if (vp._errorMeasurement) {
        try { vp._errorMeasurement.destroy(); } catch (_) {}
        vp._errorMeasurement = null;
      }
      vp.updateGPUdependent = function() {};
      const proto = Object.getPrototypeOf(vp);
      if (proto && proto.updateGPUdependent) {
        proto.updateGPUdependent = function() {};
      }
    }
  } catch (_) {}
}

// ---------------------------------------------------------------------------
// Accessibility: prevent canvas from retaining focus inside Flutter platform views
// ---------------------------------------------------------------------------
function setupCanvasA11y(map, targetContainer) {
  const canvas = map && map.getCanvas && map.getCanvas();
  if (canvas) {
    canvas.removeAttribute('tabindex');
    try {
      Object.defineProperty(canvas, 'tabIndex', {
        get: () => -1,
        set: () => {},
        configurable: true
      });
    } catch (_) {
      canvas.tabIndex = -1;
    }
    canvas.addEventListener('focus', () => {
      try { canvas.blur(); } catch (_) {}
      if (document.activeElement === canvas && document.body) {
        document.body.focus();
      }
    }, true);
    canvas.addEventListener('pointerdown', () => {
      if (document.activeElement === canvas) {
        try { canvas.blur(); } catch (_) {}
      }
    }, true);
  }
  if (targetContainer) {
    targetContainer.removeAttribute('tabindex');
    targetContainer.tabIndex = -1;
  }
}

// ---------------------------------------------------------------------------
// Marker Icons: Provide immediate crisp fallback marker image for MapLibre
// ---------------------------------------------------------------------------
function createMarkerImageData() {
  const width = 24;
  const height = 36;
  const canvas = document.createElement('canvas');
  canvas.width = width;
  canvas.height = height;
  const ctx = canvas.getContext('2d');

  ctx.save();
  ctx.beginPath();
  ctx.arc(12, 12, 10, Math.PI, 0, false);
  ctx.bezierCurveTo(22, 18, 12, 34, 12, 34);
  ctx.bezierCurveTo(12, 34, 2, 18, 2, 12);
  ctx.closePath();
  ctx.fillStyle = '#C89D3C'; // Gold
  ctx.fill();
  ctx.lineWidth = 1.5;
  ctx.strokeStyle = '#FFFFFF';
  ctx.stroke();

  ctx.beginPath();
  ctx.arc(12, 12, 4, 0, 2 * Math.PI);
  ctx.fillStyle = '#FFFFFF';
  ctx.fill();
  ctx.restore();

  const imgData = ctx.getImageData(0, 0, width, height);
  return {
    width: width,
    height: height,
    data: imgData.data
  };
}

function registerDefaultMarkerImages(map) {
  if (!map) return;
  const defaultIds = ['marker', 'default-marker', 'pin', 'marker-15'];
  defaultIds.forEach(id => {
    try {
      if (!map.hasImage(id)) {
        map.addImage(id, createMarkerImageData(), { pixelRatio: 2 });
      }
    } catch (_) {}
  });
}

// ---------------------------------------------------------------------------
// initMapboxGlobeWeb
//   viewId       – the DOM id of the container element (domId from Dart)
//   containerEl  – the actual HTMLElement (passed from Dart via js interop)
//   lng, lat, zoom – initial camera
// ---------------------------------------------------------------------------
window.initMapboxGlobeWeb = function(viewId, containerEl, initialLng, initialLat, initialZoom, initialStyleJson) {
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

    ensureRTLTextPlugin();

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

    const activeStyle = initialStyleJson ? transformMapboxStyle(initialStyleJson) : ESRI_SATELLITE_GLOBE_STYLE;

    const map = new maplibregl.Map({
      container:          targetContainer,
      style:              activeStyle,
      center:             [lng || 47.189224, lat || 24.694291],
      zoom:               zoom || 3.8,
      renderWorldCopies:  false,
      attributionControl: false,
      doubleClickZoom:    false
    });

    try { map.doubleClickZoom.disable(); } catch (_) {}
    try { map.keyboard.disable(); } catch (_) {}

    setupCanvasA11y(map, targetContainer);
    map.on('load', () => setupCanvasA11y(map, targetContainer));
    map.on('render', () => setupCanvasA11y(map, targetContainer));

    targetContainer.addEventListener('pointerdown', () => {
      const canvas = map.getCanvas && map.getCanvas();
      if (canvas && document.activeElement === canvas) {
        try { canvas.blur(); } catch (_) {}
      }
    });

    map.on('styleimagemissing', (e) => {
      const id = e.id;
      if (map.hasImage && map.hasImage(id)) return;

      // Provide immediate fallback image synchronously so MapLibre never logs an error
      try {
        map.addImage(id, createMarkerImageData(), { pixelRatio: 2 });
      } catch (_) {}

      // Asynchronously load matching SVG asset if present
      const img = new Image();
      img.crossOrigin = 'anonymous';
      img.onload = () => {
        try {
          if (map.hasImage(id)) map.removeImage(id);
          map.addImage(id, img);
        } catch (_) {}
      };
      img.src = resolveAssetUrl(`assets/maps/saudi_geo/sprite_images/${id}.svg`);
    });

    map.on('style.load', () => {
      registerDefaultMarkerImages(map);
      setupCanvasA11y(map, targetContainer);
      // Globe projection (MapLibre v5 API)
      try {
        map.setProjection({ type: 'globe' });
        disableGlobeReadbackErrorMeasurement(map);
      } catch (e) {
        console.warn('[Globe] setProjection:', e);
      }
      disableGlobeReadbackErrorMeasurement(map);
      try { map.doubleClickZoom.disable(); } catch (_) {}
      if (map.setTerrain) {
        try { map.setTerrain(null); } catch (_) {}
      }
      map.resize();

      // ── Flush any markers that arrived before the map was ready ──
      window.mapboxGlobeInstances[viewId] = map;   // mark ready BEFORE flush
      const pending = window.mapboxGlobePendingCbs[viewId] || [];
      pending.forEach(fn => fn(map));
      delete window.mapboxGlobePendingCbs[viewId];
    });

    map.once('render', () => {
      disableGlobeReadbackErrorMeasurement(map);
    });

    map.on('error', e => {
      const s = e && e.error && e.error.status;
      if (s && s !== 401 && s !== 404) console.warn('[Globe] error:', e);
    });

    // ── Setup click listener for formation polygons & valleys on map ───────────────
    map.on('click', e => {
      if (window.flutterModalOpen) return;
      try {
        const formationLayers = [
          "Saq_Formation-657oal",
          "Tabuk_Formation-767mbq",
          "Wajid_Formation-0m41k3",
          "Minjur_Formation-cp2j29",
          "Biyadh_Formation-ciunt8",
          "Wasia_Formation-8gn6np",
          "Umm_er_radhuma_Formation-31a0hp",
          "Dammam_Formation-8o2pjs",
          "Neogene_Formation-98k03q",
          "Aruma_Formation-4kp806",
          "Jauf_Formation-3102c9"
        ];
        const activeLayers = formationLayers.filter(l => map.getLayer(l));
        if (activeLayers.length > 0) {
          const features = map.queryRenderedFeatures(e.point, { layers: activeLayers });
          if (features && features.length > 0) {
            const f = features[0];
            const layerKey = f.sourceLayer || (f.layer && f.layer.id);
            if (layerKey && typeof window.onFormationPolygonClicked === 'function') {
              window.onFormationPolygonClicked(layerKey);
              return;
            }
          }
        }
      } catch (_) {}
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

    // ── Interaction Guard: Isolate Sidebar & Modals from Globe ───────────────
    function setGlobeInteractions(enabled) {
      if (!map) return;
      if (window.flutterModalOpen) {
        enabled = false;
      }
      try {
        if (enabled) {
          if (map.scrollZoom && !map.scrollZoom.isEnabled()) map.scrollZoom.enable();
          if (map.dragPan && !map.dragPan.isEnabled()) map.dragPan.enable();
          if (map.dragRotate && !map.dragRotate.isEnabled()) map.dragRotate.enable();
          if (map.touchZoomRotate && !map.touchZoomRotate.isEnabled()) map.touchZoomRotate.enable();
        } else {
          if (map.scrollZoom && map.scrollZoom.isEnabled()) map.scrollZoom.disable();
          if (map.dragPan && map.dragPan.isEnabled()) map.dragPan.disable();
          if (map.dragRotate && map.dragRotate.isEnabled()) map.dragRotate.disable();
          if (map.touchZoomRotate && map.touchZoomRotate.isEnabled()) map.touchZoomRotate.disable();
          if (map.doubleClickZoom && map.doubleClickZoom.isEnabled()) map.doubleClickZoom.disable();
        }
      } catch (_) {}
    }

    const onPointerCheck = (e) => {
      const overSidebar = isPointerOverSidebar(e);
      setGlobeInteractions(!overSidebar);
    };

    window.addEventListener('mousemove', onPointerCheck, { passive: true });
    window.addEventListener('pointermove', onPointerCheck, { passive: true });
    window.addEventListener('wheel', onPointerCheck, { passive: true });
  }

  tryInit();
};

// ── Global Sidebar Wheel & Touch Bridge for Flutter Web ────────────────────
function _getPointerX(e) {
  if (e.clientX !== undefined) return e.clientX;
  if (e.touches && e.touches.length > 0) return e.touches[0].clientX;
  if (e.changedTouches && e.changedTouches.length > 0) return e.changedTouches[0].clientX;
  return undefined;
}

function _getPointerY(e) {
  if (e.clientY !== undefined) return e.clientY;
  if (e.touches && e.touches.length > 0) return e.touches[0].clientY;
  if (e.changedTouches && e.changedTouches.length > 0) return e.changedTouches[0].clientY;
  return undefined;
}

function isPointerOverSidebar(e) {
  const w = window.innerWidth;
  const sidebarWidth = w < 600 ? Math.max(240, Math.min(w * 0.52, 350)) : 380;
  const x = _getPointerX(e);
  return x !== undefined && x >= (w - sidebarWidth);
}

let _sidebarTouchStartY = null;

// Global wheel listener: always forward wheel scroll over the sidebar to Flutter
window.addEventListener('wheel', (e) => {
  if (isPointerOverSidebar(e)) {
    let dy = e.deltaY;
    if (e.deltaMode === 1) dy *= 32;
    else if (e.deltaMode === 2) dy *= 320;
    if (typeof window.flutterSidebarScroll === 'function') {
      window.flutterSidebarScroll(dy);
    }
  }
}, { passive: true });

// Global touch listeners: forward touch swiping over the sidebar to Flutter
window.addEventListener('touchstart', (e) => {
  if (isPointerOverSidebar(e)) {
    _sidebarTouchStartY = _getPointerY(e);
  } else {
    _sidebarTouchStartY = null;
  }
}, { passive: true });

window.addEventListener('touchmove', (e) => {
  if (_sidebarTouchStartY !== null && isPointerOverSidebar(e)) {
    const currentY = _getPointerY(e);
    if (currentY !== undefined) {
      const deltaY = _sidebarTouchStartY - currentY;
      _sidebarTouchStartY = currentY;
      if (typeof window.flutterSidebarScroll === 'function') {
        window.flutterSidebarScroll(deltaY);
      }
    }
  }
}, { passive: true });

window.addEventListener('touchend', () => {
  _sidebarTouchStartY = null;
}, { passive: true });

// ---------------------------------------------------------------------------
// Modal State Bridge: Freezes map controls while modal dialogs are open
// ---------------------------------------------------------------------------
window.flutterModalOpen = false;
window.setModalOpenWeb = function(isOpen) {
  window.flutterModalOpen = !!isOpen;
  Object.values(window.mapboxGlobeInstances || {}).forEach(map => {
    if (map) {
      try {
        if (window.flutterModalOpen) {
          if (map.scrollZoom && map.scrollZoom.isEnabled()) map.scrollZoom.disable();
          if (map.dragPan && map.dragPan.isEnabled()) map.dragPan.disable();
          if (map.dragRotate && map.dragRotate.isEnabled()) map.dragRotate.disable();
          if (map.touchZoomRotate && map.touchZoomRotate.isEnabled()) map.touchZoomRotate.disable();
          if (map.doubleClickZoom && map.doubleClickZoom.isEnabled()) map.doubleClickZoom.disable();
        } else {
          if (map.scrollZoom && !map.scrollZoom.isEnabled()) map.scrollZoom.enable();
          if (map.dragPan && !map.dragPan.isEnabled()) map.dragPan.enable();
          if (map.dragRotate && !map.dragRotate.isEnabled()) map.dragRotate.enable();
          if (map.touchZoomRotate && !map.touchZoomRotate.isEnabled()) map.touchZoomRotate.enable();
        }
      } catch (_) {}
    }
  });
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
    const transformed = transformMapboxStyle(styleJsonStr);
    map.setStyle(transformed, { diff: false });
    map.once('style.load', () => {
      registerDefaultMarkerImages(map);
      setupCanvasA11y(map);
      try {
        map.setProjection({ type: 'globe' });
        disableGlobeReadbackErrorMeasurement(map);
      } catch (_) {}
      disableGlobeReadbackErrorMeasurement(map);
      if (map.setTerrain) {
        try { map.setTerrain(null); } catch (_) {}
      }
      map.resize();
    });
  } catch (e) {
    console.warn('[Globe] setStyle error:', e);
    try { map.setStyle(ESRI_SATELLITE_GLOBE_STYLE, { diff: false }); } catch (_) {}
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

// ---------------------------------------------------------------------------
// Add GeoJSON line layer (for valley lines)
// ---------------------------------------------------------------------------
window.mapboxGlobeAddGeoJsonLineLayer = function(viewId, sourceId, layerId, geoJsonString, colorHex, lineWidth) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map) return;

  function _doAdd() {
    try {
      // Remove existing layer/source if present
      if (map.getLayer(layerId)) map.removeLayer(layerId);
      if (map.getSource(sourceId)) map.removeSource(sourceId);

      let geoJson;
      try { geoJson = JSON.parse(geoJsonString); } catch(e) { console.error('GeoJSON parse error:', e); return; }

      map.addSource(sourceId, { type: 'geojson', data: geoJson });
      map.addLayer({
        id: layerId,
        type: 'line',
        source: sourceId,
        layout: { 'line-cap': 'round', 'line-join': 'round' },
        paint: {
          'line-color': colorHex,
          'line-width': lineWidth
        }
      });

      // Valley line click & cursor interactions
      map.on('click', layerId, function(e) {
        if (window.flutterModalOpen) return;
        if (typeof window.onValleyLineClicked === 'function') {
          window.onValleyLineClicked(layerId);
        }
      });
      map.on('mouseenter', layerId, function() {
        if (!window.flutterModalOpen) map.getCanvas().style.cursor = 'pointer';
      });
      map.on('mouseleave', layerId, function() {
        map.getCanvas().style.cursor = '';
      });
    } catch(e) {
      console.error('addGeoJsonLineLayer error:', e);
    }
  }

  if (map.isStyleLoaded()) {
    _doAdd();
  } else {
    map.once('style.load', _doAdd);
  }
};

// ---------------------------------------------------------------------------
// Update Valley line colors: selected valley is RED (#FF0000), others are BLUE (#0000FF)
// ---------------------------------------------------------------------------
window.mapboxGlobeUpdateValleyColors = function(viewId, selectedValleyKey) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map || !map.isStyleLoaded()) return;

  const valleyNames = [
    "Wadi_Aba_Al_Qu", "Wadi_Aba_Ar_Ruwath", "Wadi_Al_Ahsabah", "Wadi_Al_Akhda",
    "Wadi_Al_Amq", "Wadi_Al_Batin", "Wadi_Al_Farshah", "Wadi_Al_Gharr",
    "Wadi_al_Ghinah", "Wadi_Al_Hamal", "Wadi_Al_Hamd", "Wadi_Al_Hinu",
    "Wadi_Al_Jarir", "Wadi_Al_Jizil", "Wadi_al_Judwal", "Wadi_Al_Khurmah",
    "Wadi_Al_Lith", "Wadi_Al_Makhit", "Wadi_Al_Maqran", "Wadi_Al_Mira",
    "Wadi_al_Qimra", "Wadi_Ar_Raka", "Wadi_Ar_Risha", "Wadi_Ar_Rumah",
    "Wadi_Arar", "Wadi_As_Sahba", "Wadi_As_surrah", "Wadi_Ash_Shu-bah",
    "Wadi_Baysh", "Wadi_Bishah", "Wadi_Bitat", "Wadi_Damad",
    "Wadi_Dawqah", "Wadi_Fajr", "Wadi_Hali", "Wadi_Hamir",
    "Wadi_Hanifah", "Wadi_Hirjab", "Wadi_Hubuna", "Wadi_Itwad",
    "Wadi_Najran", "Wadi_Nayyal", "Wadi_Qatan", "Wadi_Ranyah",
    "Wadi_Rash", "Wadi_Shuwayhat", "Wadi_Tabalah", "Wadi_Tarif",
    "Wadi_Tarj", "Wadi_Tathlith", "Wadi_Turubah", "Wadi_Yabah"
  ];

  valleyNames.forEach(function(vName) {
    try {
      if (map.getLayer(vName)) {
        const isSelected = (vName === selectedValleyKey);
        map.setPaintProperty(vName, 'line-color', isSelected ? '#FF0000' : '#0000FF');
        map.setPaintProperty(vName, 'line-width', isSelected ? 4.5 : 3.0);
      }
    } catch (_) {}
  });
};

// ---------------------------------------------------------------------------
// Update Dam marker icons: selected dam is RED (red_droplet), others are BLUE (droplet)
// ---------------------------------------------------------------------------
window.mapboxGlobeUpdateDamMarkers = function(viewId, selectedDamName) {
  const redIconUrl = resolveAssetUrl('assets/images/red_droplet.png');
  const blueIconUrl = resolveAssetUrl('assets/images/droplet.png');

  const markers = window.mapboxGlobeMarkers[viewId] || [];
  markers.forEach(function(m) {
    try {
      const el = m.getElement();
      if (!el) return;
      const markerId = el.getAttribute('data-marker-id');
      const img = el.querySelector('img');
      if (img && markerId) {
        if (markerId === selectedDamName) {
          img.src = redIconUrl;
          img.style.filter = 'drop-shadow(0 0 8px rgba(255,0,0,0.8))';
        } else {
          img.src = blueIconUrl;
          img.style.filter = 'none';
        }
      }
    } catch (_) {}
  });
};

// ---------------------------------------------------------------------------
// Clear GeoJSON line layers (e.g. when switching away from Valleys)
// ---------------------------------------------------------------------------
window.mapboxGlobeClearGeoJsonLineLayers = function(viewId, layerIdsStr, sourceIdsStr) {
  const map = window.mapboxGlobeInstances[viewId];
  if (!map || !map.isStyleLoaded()) return;
  const layerIds = layerIdsStr ? layerIdsStr.split(',') : [];
  const sourceIds = sourceIdsStr ? sourceIdsStr.split(',') : [];
  layerIds.forEach(id => { try { if (id && map.getLayer(id)) map.removeLayer(id); } catch(_) {} });
  sourceIds.forEach(id => { try { if (id && map.getSource(id)) map.removeSource(id); } catch(_) {} });
};
