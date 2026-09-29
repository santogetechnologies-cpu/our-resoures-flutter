// Interactive Geology Map Web App Application Logic

document.addEventListener('DOMContentLoaded', () => {
  mapboxgl.accessToken = window.MAPBOX_TOKEN;

  // Initial Camera Position (Riyadh / Saudi Arabia Center)
  const INITIAL_CENTER = [47.189224, 24.694291];
  const INITIAL_ZOOM = 5.2;

  // Initialize Mapbox Map
  const map = new mapboxgl.Map({
    container: 'map',
    style: 'mapbox://styles/mapbox/satellite-streets-v12', // Standard satellite streets or custom JSON
    center: INITIAL_CENTER,
    zoom: INITIAL_ZOOM,
    attributionControl: false
  });

  map.addControl(new mapboxgl.NavigationControl({ visualizePitch: true }), 'bottom-left');

  // DOM Elements
  const sidebar = document.getElementById('sidebar');
  const toggleSidebarBtn = document.getElementById('toggle-sidebar-btn');
  const modalOverlay = document.getElementById('modal-overlay');
  const modalTitle = document.getElementById('modal-title');
  const modalBody = document.getElementById('modal-body');
  const modalCloseBtn = document.getElementById('modal-close-btn');
  const loadingSpinner = document.getElementById('loading-spinner');
  const resetZoomBtn = document.getElementById('reset-zoom-btn');

  let currentMarkers = [];
  let currentPopup = null;

  // UI Sidebar Accordion Toggle
  document.querySelectorAll('.category-header').forEach(header => {
    header.addEventListener('click', () => {
      const category = header.parentElement;
      const isActive = category.classList.contains('active');
      document.querySelectorAll('.menu-category').forEach(c => c.classList.remove('active'));
      if (!isActive) {
        category.classList.add('active');
      }
    });
  });

  // Toggle Sidebar
  toggleSidebarBtn.addEventListener('click', () => {
    sidebar.classList.toggle('collapsed');
    toggleSidebarBtn.classList.toggle('collapsed');
    const icon = toggleSidebarBtn.querySelector('i');
    if (sidebar.classList.contains('collapsed')) {
      icon.className = 'fas fa-bars';
    } else {
      icon.className = 'fas fa-chevron-right';
    }
  });

  // Reset Camera
  resetZoomBtn.addEventListener('click', () => {
    map.flyTo({ center: INITIAL_CENTER, zoom: INITIAL_ZOOM, pitch: 0, bearing: 0 });
  });

  // Modal Dialog Handler
  function showModal(title, htmlContent) {
    modalTitle.innerHTML = title;
    modalBody.innerHTML = htmlContent;
    modalOverlay.classList.add('active');
  }

  modalCloseBtn.addEventListener('click', () => {
    modalOverlay.classList.remove('active');
  });

  modalOverlay.addEventListener('click', (e) => {
    if (e.target === modalOverlay) {
      modalOverlay.classList.remove('active');
    }
  });

  // Spinner Controls
  function showSpinner() { loadingSpinner.classList.add('active'); }
  function hideSpinner() { loadingSpinner.classList.remove('active'); }

  // Clear Map Layers and Markers
  function clearMap() {
    if (currentPopup) { currentPopup.remove(); currentPopup = null; }
    currentMarkers.forEach(m => m.remove());
    currentMarkers = [];

    // Remove custom geojson sources and layers if added
    if (map.getSource('valleys-source')) {
      if (map.getLayer('valleys-layer')) map.removeLayer('valleys-layer');
      map.removeSource('valleys-source');
    }
  }

  // Set Map Custom Style JSON from Assets
  async function loadCustomMapStyle(jsonPath) {
    showSpinner();
    try {
      const response = await fetch(jsonPath);
      const styleJson = await response.json();
      map.setStyle(styleJson);
    } catch (e) {
      console.error("Error loading map style:", e);
      map.setStyle('mapbox://styles/mapbox/satellite-streets-v12');
    } finally {
      hideSpinner();
    }
  }

  // ==========================================
  // 1. GEOLOGY CATEGORY (جيولوجية المملكة)
  // ==========================================
  document.querySelectorAll('[data-geo-layer]').forEach(btn => {
    btn.addEventListener('click', () => {
      clearMap();
      const layerType = btn.getAttribute('data-geo-layer');
      loadCustomMapStyle(`assets/maps/saudi_geo/${layerType}.json`);
    });
  });

  // ==========================================
  // 2. GEOTOURISM (السياحة والآثار)
  // ==========================================
  document.getElementById('btn-tourism').addEventListener('click', () => {
    clearMap();
    map.setStyle('mapbox://styles/mapbox/satellite-streets-v12');

    window.TOURISM_DATA.forEach(site => {
      const el = document.createElement('div');
      el.className = 'custom-marker';
      el.style.backgroundImage = 'url("assets/imgs/icon_tourism.png")';
      el.style.width = '32px';
      el.style.height = '32px';
      el.style.backgroundSize = 'contain';
      el.style.cursor = 'pointer';

      const marker = new mapboxgl.Marker(el)
        .setLngLat([site.lng, site.lat])
        .addTo(map);

      el.addEventListener('click', () => {
        const content = `
          <div style="text-align: right; font-family: Cairo, sans-serif;">
            ${site.image ? `<img src="assets/imgs/${site.image}" class="modal-img" alt="${site.title}">` : ''}
            <p style="margin-bottom: 10px; font-weight: bold; color: #d4af37;">${site.region}</p>
            <p style="line-height: 1.8; color: #e2e8f0;">${site.description}</p>
          </div>
        `;
        showModal(site.title, content);
      });

      currentMarkers.push(marker);
    });

    map.flyTo({ center: INITIAL_CENTER, zoom: INITIAL_ZOOM });
  });

  // ==========================================
  // 3. OIL & GAS (حقول البترول والغاز)
  // ==========================================
  document.getElementById('btn-oil').addEventListener('click', () => {
    clearMap();
    map.setStyle('mapbox://styles/mapbox/dark-v11');

    // Oil Markers
    window.OIL_GAS_DATA.oil.forEach(site => {
      const el = document.createElement('div');
      el.style.backgroundImage = 'url("assets/imgs/oil_marker.png")';
      el.style.width = '30px';
      el.style.height = '30px';
      el.style.backgroundSize = 'contain';
      el.style.cursor = 'pointer';

      const popupHtml = `
        <div class="popup-title"><i class="fas fa-oil-well"></i> ${site.title}</div>
        <div class="popup-desc">${site.description}</div>
      `;

      const marker = new mapboxgl.Marker(el)
        .setLngLat([site.lng, site.lat])
        .setPopup(new mapboxgl.Popup({ offset: 25 }).setHTML(popupHtml))
        .addTo(map);

      currentMarkers.push(marker);
    });

    // Gas Markers
    window.OIL_GAS_DATA.gas.forEach(site => {
      if (site.lng === 0) return; // skip unpositioned
      const el = document.createElement('div');
      el.style.backgroundImage = 'url("assets/imgs/gas_marker.png")';
      el.style.width = '30px';
      el.style.height = '30px';
      el.style.backgroundSize = 'contain';
      el.style.cursor = 'pointer';

      const popupHtml = `
        <div class="popup-title"><i class="fas fa-fire"></i> ${site.title}</div>
        <div class="popup-desc">${site.description}</div>
      `;

      const marker = new mapboxgl.Marker(el)
        .setLngLat([site.lng, site.lat])
        .setPopup(new mapboxgl.Popup({ offset: 25 }).setHTML(popupHtml))
        .addTo(map);

      currentMarkers.push(marker);
    });

    map.flyTo({ center: [48.5, 25.0], zoom: 6 });
  });

  // ==========================================
  // 4. WATER FORMATIONS & DAMS (التكاوين المائية والسدود)
  // ==========================================
  document.querySelectorAll('[data-water-layer]').forEach(btn => {
    btn.addEventListener('click', () => {
      clearMap();
      const formName = btn.getAttribute('data-water-layer');
      loadCustomMapStyle(`assets/maps/water_formation/${formName}.json`);
    });
  });

  // Dams
  document.getElementById('btn-dams').addEventListener('click', () => {
    clearMap();
    map.setStyle('mapbox://styles/mapbox/satellite-streets-v12');

    if (window.DAMS_DATA) {
      window.DAMS_DATA.forEach(dam => {
        const el = document.createElement('div');
        el.style.backgroundImage = 'url("assets/imgs/droplet.png")';
        el.style.width = '24px';
        el.style.height = '24px';
        el.style.backgroundSize = 'contain';
        el.style.cursor = 'pointer';

        const popupHtml = `
          <div class="popup-title"><i class="fas fa-water"></i> ${dam.name}</div>
          <div class="popup-desc">
            <b>الموقع:</b> ${dam.gov} - ${dam.region}<br>
            <b>نوع السد:</b> ${dam.type}<br>
            <b>سعة السد:</b> ${dam.capacity.toLocaleString()} متر مكعب<br>
            <b>ارتفاع السد:</b> ${dam.hight} متر | <b>طول السد:</b> ${dam.length} متر<br>
            <b>تاريخ الإنشاء:</b> ${dam.date}
          </div>
        `;

        const marker = new mapboxgl.Marker(el)
          .setLngLat([dam.lng, dam.lat])
          .setPopup(new mapboxgl.Popup({ offset: 25 }).setHTML(popupHtml))
          .addTo(map);

        currentMarkers.push(marker);
      });
      map.flyTo({ center: [41.4, 20.2], zoom: 6.5 });
    }
  });

  // ==========================================
  // 5. ECONOMIC MINERALS (المعادن الاقتصادية)
  // ==========================================
  const mineralSelect = document.getElementById('mineral-select');
  if (mineralSelect) {
    mineralSelect.addEventListener('change', (e) => {
      const selectedMetal = e.target.value;
      clearMap();
      if (!selectedMetal) return;

      showSpinner();
      setTimeout(() => {
        const filtered = window.MINERALS_DATA.filter(m => m.nameEn.toLowerCase() === selectedMetal.toLowerCase());

        filtered.forEach(m => {
          const el = document.createElement('div');
          el.style.backgroundImage = `url("assets/imgs/ic_${m.nameEn.toLowerCase()}.png")`;
          el.style.width = '24px';
          el.style.height = '24px';
          el.style.backgroundSize = 'contain';
          el.style.cursor = 'pointer';

          const popupHtml = `
            <div class="popup-title"><i class="fas fa-gem"></i> ${m.nameAr} (${m.nameEn})</div>
            <div class="popup-desc">
              <b>الموقع:</b> ${m.region}<br>
              <b>المنطقة الإدارية:</b> ${m.locationName}<br>
              <b>الإحداثيات:</b> ${m.lat.toFixed(4)}, ${m.lng.toFixed(4)}
            </div>
          `;

          const marker = new mapboxgl.Marker(el)
            .setLngLat([m.lng, m.lat])
            .setPopup(new mapboxgl.Popup({ offset: 20 }).setHTML(popupHtml))
            .addTo(map);

          currentMarkers.push(marker);
        });

        hideSpinner();
        map.flyTo({ center: INITIAL_CENTER, zoom: 5.5 });
      }, 50);
    });
  }

  // ==========================================
  // 6. SEISMIC DATABASE (الزلازل)
  // ==========================================
  document.querySelectorAll('[data-eq-range]').forEach(btn => {
    btn.addEventListener('click', () => {
      clearMap();
      const range = btn.getAttribute('data-eq-range');
      const eqList = window.EARTHQUAKES_DATA ? window.EARTHQUAKES_DATA[range] || [] : [];

      showSpinner();
      setTimeout(() => {
        eqList.forEach(eq => {
          const el = document.createElement('div');
          let iconName = 'small.png';
          let size = '16px';

          if (range === 'q5to6') { iconName = 'medium.png'; size = '20px'; }
          else if (range === 'q6to7') { iconName = 'larg.png'; size = '24px'; }
          else if (range === 'q7plus') { iconName = 'extra_larg.png'; size = '28px'; }
          else if (range === 'historical') { iconName = 'square.png'; size = '22px'; }

          el.style.backgroundImage = `url("assets/imgs/${iconName}")`;
          el.style.width = size;
          el.style.height = size;
          el.style.backgroundSize = 'contain';
          el.style.cursor = 'pointer';

          const popupHtml = `
            <div class="popup-title" style="color: #ef4444;"><i class="fas fa-house-crack"></i> هزة زلزالية</div>
            <div class="popup-desc">
              <b>القوة (Magnitude):</b> ${eq.mag}<br>
              <b>التاريخ والوقت:</b> ${eq.date} (GMT)<br>
              <b>الإحداثيات:</b> ${eq.lat}, ${eq.lng}
            </div>
          `;

          const marker = new mapboxgl.Marker(el)
            .setLngLat([eq.lng, eq.lat])
            .setPopup(new mapboxgl.Popup({ offset: 15 }).setHTML(popupHtml))
            .addTo(map);

          currentMarkers.push(marker);
        });

        hideSpinner();
      }, 50);
    });
  });

  // ==========================================
  // 7. BRIEF & SOURCES MODALS (حول الخريطة والمصادر)
  // ==========================================
  document.getElementById('btn-intro').addEventListener('click', () => {
    const html = `
      <div style="text-align: right; line-height: 2;">
        <p style="text-align: center; font-weight: bold; font-size: 1.1rem; color: #d4af37; margin-bottom: 15px;">بسم الله الرحمن الرحيم</p>
        <p>الحمد لله رب العالمين وبعد ...</p>
        <p>تعزيزاً وتحقيقا لرؤية المملكة 2030 في توطين واستثمار الثروات الطبيعية في المملكة وتوفير طاقة نظيفة صديقه للبيئة. قام الفريق العلمي والتقني المكون من:</p>
        <ul style="margin: 15px 30px; color: #d4af37;">
          <li>أ. د. عبد الله العمري</li>
          <li>م. مشعل ال كدم</li>
          <li>م. عبد العزيز الدحيم</li>
          <li>م. مشاري الجهني</li>
          <li>م. محمد بن عراج</li>
          <li>م. نايف العتيبي</li>
        </ul>
        <p>بتوظيف المعطيات والمعلومات الجيولوجية والجيوفيزيائية المتاحة في المملكة لتحقيق أهداف الرؤية من خلال رفع البيانات المعدنية والبترولية والمائية والزلزالية ومعالم السياحة الجيولوجية والآثار على خرائط تفاعلية عالية الدقة لخدمة الجهات ذات العلاقة والباحثين والطلاب للحصول على المعلومة الجيولوجية بكل يسر وسهولة.</p>
        <div style="text-align: center; margin-top: 20px;">
          <img src="assets/imgs/sign.png" alt="التوقيع" style="max-width: 200px; filter: invert(1);">
          <p style="font-weight: bold; color: #d4af37; margin-top: 5px;">أ. د. عبد الله بن محمد العمري<br>رئيس الجمعية السعودية لعلوم الأرض والمشرف على المشروع</p>
        </div>
      </div>
    `;
    showModal("كلمة المشرف على الخريطة التفاعلية", html);
  });

  document.getElementById('btn-sources').addEventListener('click', () => {
    const html = `
      <div style="text-align: right; line-height: 2;">
        <h3 style="color: #d4af37; margin-bottom: 15px; text-align: center;">المصادر والمراجع الرسمية</h3>
        <ol style="margin-right: 25px; color: #e2e8f0;">
          <li>أطلس المياه (1984). وزارة الزراعة والمياه - المملكة العربية السعودية - الرياض.</li>
          <li>أطلس المعادن الصناعية (2016). وكالة وزارة الطاقة والصناعة للثروة المعدنية - جدة.</li>
          <li>الثروات المعدنية في المملكة العربية السعودية (2016). وكالة وزارة الطاقة والصناعة للثروة المعدنية.</li>
          <li>قاعدة البيانات المعدنية والزلزالية (2023) - هيئة المساحة الجيولوجية - جدة.</li>
          <li>موسوعة العمري في علوم الأرض - 30 كتاب (2023). الجمعية السعودية لعلوم الأرض - الرياض.</li>
          <li>Development of Mineral Exploration in the Kingdom of Saudi Arabia (1999), Ministry of Petroleum and Minerals.</li>
          <li>The Geology of the Arabian-Nubian Shield, 2021, Springer Nature Switzerland.</li>
        </ol>
      </div>
    `;
    showModal("المصادر والمراجع", html);
  });
});
