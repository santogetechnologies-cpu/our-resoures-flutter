class AppAssets {
  static const String basePath = 'assets/images';

  // Wallpapers
  static const String wallpaper2 = '$basePath/wallpaper2.jpg';
  static const String wallpaper5 = '$basePath/wallpaper5.jpg';
  static const String wallpaper = '$basePath/wallpaper.png';
  static const String infoback = '$basePath/infoback.png';

  // Logos
  static const String saudiVision = '$basePath/saudi_vision.png';
  static const String dLogo = '$basePath/d_logo.png';
  static const String click = '$basePath/click.png';
  static const String sign = '$basePath/sign.png';

  // Action icons
  static const String home = '$basePath/home.png';
  static const String zoom = '$basePath/zoom.png';

  // Map Markers
  static const String markerIcon = '$basePath/marker_icon.png';
  static const String oilMarker = '$basePath/oil_marker.png';
  static const String gasMarker = '$basePath/gas_marker.png';
  static const String droplet = '$basePath/droplet.png';
  static const String redDroplet = '$basePath/red_droplet.png';

  // Earthquake markers
  static const String smallEarth = '$basePath/small.png';
  static const String mediumEarth = '$basePath/medium.png';
  static const String largEarth = '$basePath/larg.png';
  static const String extraLargEarth = '$basePath/extra_larg.png';
  static const String squareEarth = '$basePath/square.png';

  // Briefs & Layer Banners
  static const String oilBrief = '$basePath/oil_brief.png';
  static const String arabianShield = '$basePath/arabian_shield.png';
  static const String arabianPlatform = '$basePath/arabian_platform.png';
  static const String harat = '$basePath/harat.jpg';
  static const String swahel = '$basePath/swahel.png';
  static const String earth = '$basePath/earth.jpg';
  static const String geologicMapArabianPeninsula = '$basePath/geologic_map_arabian_peninsula.jpg';

  // Datasets
  static const String materialsXlsx = 'assets/data/materials.xlsx';
  static const String materialsJson = 'assets/data/materials.json';
  static const String damsXlsx = 'assets/data/dams.xlsx';
  static const String damsJson = 'assets/data/dams.json';
  static const String tourismDataJson = 'assets/data/tourism_data.json';

  // Earthquake data (using fast JSON)
  static const String earthquakeHistorical = 'assets/earthquake/Histroical.json';
  static const String earthquake4to5 = 'assets/earthquake/4 to 5.json';
  static const String earthquake5to6 = 'assets/earthquake/5 to 6.json';
  static const String earthquake6to7 = 'assets/earthquake/6 to 7.json';
  static const String earthquake7andAbove = 'assets/earthquake/7 and above.json';

  // GeoJSON / Maps
  static const String valleysDir = 'assets/maps/valleys';
  static const String waterFormationDir = 'assets/maps/water_formation';
  static const String saudiGeoDir = 'assets/maps/saudi_geo';

  // Helper for mineral icon
  static String mineralIcon(String metalEn) {
    return '$basePath/ic_${metalEn.toLowerCase()}.png';
  }

  // Helper for mineral photo
  static String mineralPhoto(String metalEn) {
    return '$basePath/${metalEn.toLowerCase()}.jpg';
  }

  // Helper for water problems
  static String waterProblem(int index) {
    return '$basePath/waterproblems$index.png';
  }
}
