# Our Resources (ثرواتنا من أرضنا)

An interactive, high-performance **3D Digital Geospatial Atlas and Geological Information System** of the Kingdom of Saudi Arabia, engineered with **Flutter**, **Dart**, and **Mapbox 3D Globe Engine**.

---

## 🌍 Overview

**Our Resources** is an educational and scientific exploration application showcasing the natural wealth, geological formations, mineral reserves, hydrology, energy infrastructures, seismic history, and geo-tourism heritage of Saudi Arabia. 

Originally created as an interactive GIS kiosk application for the Saudi Society of Geosciences and King Saud University, this repository represents a modern, cross-platform codebase supporting **Web**, **Android**, **iOS**, and **Desktop** environments.

---

## ✨ Core Features & Modules

### 1. 🌐 Interactive 3D Globe & GIS Viewport
* **Spherical 3D Globe Projection**: Renders the Earth as a realistic 3D globe with atmospheric glow, star field background, and spherical navigation.
* **Vector & Satellite Imagery**: High-resolution satellite base layers layered with custom geological shapefiles and vector features.
* **Smart Camera Control**: Dynamic fly-to transitions with automated pitch, bearing, and zoom level adjustments.
* **Authentic GIS Scale Bar**: Live distance ruler calculating real-time ground resolution per pixel based on camera altitude and latitude.

---

### 2. ⛰️ General Geology of the Kingdom (`GeologyScreen`)
Explore the primary geological provinces shaping the Arabian Plate:
* **The Arabian Shield (*الدرع العربي*)**: Pre-Cambrian crystalline igneous and metamorphic basement rocks rich in precious and base metals.
* **The Arabian Platform (*الرصيف القاري العربي*)**: Extensive sedimentary cover occupying over two-thirds of Saudi Arabia, hosting global hydrocarbon reserves and major deep aquifers.
* **Volcanic Harrat (*الحرات البركانية*)**: Cenozoic basaltic lava fields and volcanic cones, including Harrat Rahat, Khaybar, Kishb, Lunayyir, and volcanic calderas (e.g., Al-Wahbah Crater).
* **Coastal Plains (*السهول الساحلية*)**: Red Sea Tihama plains and Arabian Gulf coastal flats with evaporite sequences and marine deposits.

---

### 3. 💎 Economic Rocks & Minerals (`MaterialsScreen`)
* **Comprehensive Mineral Registry**: Interactive explorer covering over 40 industrial minerals and metallic ores (Gold, Silver, Copper, Iron, Phosphate, Bauxite, Zinc, Lithium, Silica Sand, Granite, Marble, Kaolin, Gypsum, Uranium, etc.).
* **Geospatial Extraction Sites**: Coordinates and mining sites across the Kingdom with specialized category icons.
* **Specimen Inspection & Data**: High-resolution specimen imagery, geological characteristics, industrial applications, and Vision 2030 mining sector targets.

---

### 4. 💧 Water Formations & Hydrology (`WaterFormationsScreen`)
* **Major Aquifers**: Deep groundwater formations including Saq, Wajid, Tabuk, Minjur, Biyadh, and Wasia sandstone reservoirs.
* **Secondary Aquifers**: Regional formations including Umm Er Radhuma, Dammam, Neogene, Al-Jouf, Khuff, and Jilh.
* **Wadi River Networks**: Vector routing and path visualization for 53 primary wadi basins across Saudi Arabia (Wadi Al-Rummah, Wadi Hanifah, Wadi Bishah, Wadi Al-Batin, etc.) rendered with customized color schemes and length metrics.
* **Drinking & Agricultural Dams**: Geographic database of major dams across all provinces with structural metrics (height, length, reservoir capacity, and construction year).

---

### 5. ⚡ Energy, Petroleum & Renewables (`OilGasScreen`)
* **Renewable Energy Megaprojects**: Clean energy initiatives under Vision 2030 and the Saudi Green Initiative:
  * Sakaka Solar Power Plant (300 MW)
  * Dumat Al-Jandal Wind Farm (400 MW)
  * Sudair Solar PV Project (1,500 MW)
  * NEOM Green Hydrogen Facility
  * Shuaibah Solar PV Complex
  * Geothermal exploration across volcanic Harrat fields.
* **Oil Fields**: Ghawar, Khurais, Safaniya, Shaybah, Manifa, Abqaiq, Berri, and more.
* **Natural Gas Fields**: Midyan, Jafurah unconventional basin, Mazalij, Karan, and Arabiyah.

---

### 6. 🏛️ Geo-Tourism & Cultural Heritage (`TourismScreen`)
* **Provincial Landmark Explorer**: Curated regional categories covering Riyadh, Madinah, Makkah, Asir, Tabuk, Al-Jawf, Najran, Hail, and the Eastern Province.
* **Natural Wonders & UNESCO Sites**: Detailed photographic cards and geospatial pins for Elephant Rock (Jabal Al-Fil), Madain Saleh (Hegra), Al-Gharameel, Edge of the World, Al-Ukhdood, Hema Rock Inscriptions, Farasan Islands, and Habala.

---

### 7. 🌋 Seismic Database & Tectonics (`EarthquakeScreen`)
* **Seismic History Catalog**: Complete historical and instrumental earthquake records from 112 AD to present from the King Saud University Seismic Studies Center.
* **Magnitude Classification**: Real-time filtering by Richter scale thresholds:
  * Historical Seismicity (112 AD – 1899 AD)
  * Minor Seismicity ($M < 3.0$)
  * Moderate Seismicity ($3.0 \le M < 5.0$)
  * Significant Seismicity ($M \ge 5.0$)
* **Detailed Epicenter Popups**: Magnitude, focal depth, GMT timestamp, and tectonic boundary associations.

---

## 🏗️ Architecture & Technology Stack

```
our-resources-flutter/
├── lib/
│   ├── main.dart                          # Application entry point & configuration
│   ├── core/
│   │   ├── constants/app_assets.dart      # Centralized asset paths & data registry
│   │   ├── dialogs/                       # Infographic & popup modal system
│   │   ├── theme/app_theme.dart           # Color palette, parchment styling & typography
│   │   └── widgets/
│   │       ├── custom_button.dart         # Styled parchment navigation buttons
│   │       ├── map_scale_bar.dart         # Live GIS distance ruler
│   │       ├── map_shell.dart             # Cross-platform map layout & controller
│   │       ├── map_view_platform.dart     # Platform-agnostic map interface
│   │       ├── map_view_platform_web.dart # Mapbox GL JS 3D Globe Web engine
│   │       └── map_view_platform_stub.dart# Mapbox Mobile native engine
│   └── features/
│       ├── start/start_screen.dart        # Immersive splash screen
│       ├── menu/fullscreen_menu_screen.dart # 6-module grid navigation
│       ├── geology/                       # General geology module
│       ├── materials/                     # Economic minerals module
│       ├── water/                         # Hydrology & dams module
│       ├── oil_gas/                       # Energy & petroleum module
│       ├── tourism/                       # Geo-tourism module
│       └── earthquake/                    # Seismic database module
├── web/
│   ├── index.html                         # Web entry point with Mapbox GL JS v3
│   └── mapbox_globe.js                    # WebGL 3D Globe bridge script
└── assets/
    ├── data/                              # Datasets (materials, dams, tourism)
    ├── earthquake/                        # Earthquake catalogs (JSON/XLSX)
    ├── images/                            # Textures, specimens, banners & icons
    └── maps/                              # Mapbox Style JSONs & GeoJSON vectors
```

### Key Technical Choices
* **Flutter & Dart**: Single cross-platform codebase maintaining native performance on mobile and canvas/HTML rendering on web.
* **Mapbox 3D Globe Hybrid Engine**:
  * **Web**: WebGL-accelerated **Mapbox GL JS v3** with native `globe` projection, atmospheric fog, and hardware-rendered satellite layers embedded via `HtmlElementView`.
  * **Android / iOS**: **Mapbox Maps Flutter SDK** (`mapbox_maps_flutter`) backed by native Android/iOS vector tiles.
* **Full RTL & Typography**: Custom Arabic typography (`Noto Kufi` & `Reem Kufi`) paired with Right-to-Left directional layouts.
* **Decoupled Controller Architecture**: Uniform `MapShellController` interface ensuring identical behavior across web and mobile platforms.

---

## 🚀 Getting Started

### Prerequisites
* [Flutter SDK](https://docs.flutter.dev/get-started/install) (version `3.10.0` or higher).
* Google Chrome (for web development) or Android Studio / Xcode (for mobile deployment).

### 1. Clone the Repository
```bash
git clone https://github.com/santogetechnologies-cpu/our-resoures-flutter.git
cd our-resoures-flutter
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Validate Codebase
```bash
flutter analyze
```

### 4. Run Locally
* **Run in Web Browser**:
  ```bash
  flutter run -d chrome
  ```
* **Run on Android Device / Emulator**:
  ```bash
  flutter run -d android
  ```

---

## 🌐 Deployment (Vercel)

The web version is configured for automated CI/CD deployment on [Vercel](https://vercel.com):
* **Build Script**: `vercel-build.sh` automatically fetches the stable Flutter SDK, installs dependencies, and compiles the web bundle (`flutter build web --release --base-href "/"`).
* **Output Directory**: Configured in `vercel.json` pointing to `build/web`.

---

## 📜 Scientific Supervision & Credits

* **Project Supervisor**: Prof. Dr. Abdullah bin Mohammed Al-Amri (*أ. د. عبد الله بن محمد العمري*)
* **Scientific Organizations**:
  * Saudi Society of Geosciences (*الجمعية السعودية لعلوم الأرض*)
  * King Saud University (*جامعة الملك سعود*)
  * Center for Seismic Studies (*مركز الدراسات الزلزالية*)
* **Design & Digital Development**: Santoge Technologies

---

## 📄 License

This software and its associated educational datasets are published for scientific, academic, and exploration purposes.
