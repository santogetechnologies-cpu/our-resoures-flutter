import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';
import 'map_scale_bar.dart';

class AppPointAnnotationClickListener extends OnPointAnnotationClickListener {
  final void Function(PointAnnotation annotation) onClick;
  AppPointAnnotationClickListener(this.onClick);

  @override
  void onPointAnnotationClick(PointAnnotation annotation) {
    onClick(annotation);
  }
}

class MapShellController {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;

  Future<void> setStyleFromAsset(String assetPath) async {
    if (mapboxMap == null) return;
    try {
      final styleJson = await rootBundle.loadString(assetPath);
      await mapboxMap!.style.setStyleJSON(styleJson);
      try {
        await mapboxMap!.style.setProjection(StyleProjection(name: StyleProjectionName.globe));
      } catch (_) {}
    } catch (e) {
      debugPrint('Error loading style asset $assetPath: $e');
    }
  }

  Future<void> flyTo({
    required double latitude,
    required double longitude,
    double? zoom,
    double? pitch,
    double? bearing,
  }) async {
    if (mapboxMap == null) return;
    await mapboxMap!.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(longitude, latitude)),
        zoom: zoom,
        pitch: pitch,
        bearing: bearing,
      ),
      MapAnimationOptions(duration: 1000),
    );
  }
}

class MapShell extends StatefulWidget {
  final String title;
  final VoidCallback? onBriefPressed;
  final String briefButtonText;
  final Widget sidebarContent;
  final String? initialStyleAsset;
  final bool isLoading;
  final void Function(MapShellController controller)? onMapCreated;
  final double initialLatitude;
  final double initialLongitude;
  final double initialZoom;
  final double sidebarWidth;

  const MapShell({
    super.key,
    required this.title,
    this.onBriefPressed,
    this.briefButtonText = 'مقدمة',
    required this.sidebarContent,
    this.initialStyleAsset,
    this.isLoading = false,
    this.onMapCreated,
    this.initialLatitude = 24.694291,
    this.initialLongitude = 47.189224,
    this.initialZoom = 4.3,
    this.sidebarWidth = 350,
  });

  @override
  State<MapShell> createState() => _MapShellState();
}

class _MapShellState extends State<MapShell> {
  final MapShellController _shellController = MapShellController();
  double _currentZoom = 4.3;
  double _currentLat = 24.694291;

  @override
  void initState() {
    super.initState();
    _currentZoom = widget.initialZoom;
    _currentLat = widget.initialLatitude;
  }

  void _onMapCreated(MapboxMap mapboxMap) async {
    _shellController.mapboxMap = mapboxMap;

    // Load initial custom style from assets if provided, or default satellite-streets
    if (widget.initialStyleAsset != null && widget.initialStyleAsset!.isNotEmpty) {
      await _shellController.setStyleFromAsset(widget.initialStyleAsset!);
    } else {
      try {
        await mapboxMap.style.setStyleURI(MapboxStyles.SATELLITE_STREETS);
      } catch (_) {}
    }

    // Set globe projection explicitly to ensure 3D spherical globe is rendered
    try {
      await mapboxMap.style.setProjection(StyleProjection(name: StyleProjectionName.globe));
    } catch (_) {}

    // Initialize point annotation manager for high-performance markers
    try {
      _shellController.pointAnnotationManager =
          await mapboxMap.annotations.createPointAnnotationManager();
    } catch (e) {
      debugPrint('Error creating PointAnnotationManager: $e');
    }

    if (widget.onMapCreated != null) {
      widget.onMapCreated!(_shellController);
    }
  }

  void _resetZoom() {
    _shellController.flyTo(
      latitude: widget.initialLatitude,
      longitude: widget.initialLongitude,
      zoom: widget.initialZoom,
      pitch: 0.0,
      bearing: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            final effectiveSidebarWidth = constraints.maxWidth < 600
                ? (constraints.maxWidth * 0.52).clamp(240.0, widget.sidebarWidth)
                : widget.sidebarWidth;

            return Stack(
              children: [
                // 3D Globe Mapbox Widget
                MapWidget(
                  key: const ValueKey('mapbox_globe_widget'),
                  styleUri: MapboxStyles.SATELLITE_STREETS,
                  cameraOptions: CameraOptions(
                    center: Point(
                      coordinates: Position(widget.initialLongitude, widget.initialLatitude),
                    ),
                    zoom: widget.initialZoom,
                    pitch: 0.0,
                    bearing: 0.0,
                  ),
                  onMapCreated: _onMapCreated,
                  onCameraChangeListener: (cameraChangedEventData) {
                    if (_shellController.mapboxMap != null) {
                      _shellController.mapboxMap!.getCameraState().then((cameraState) {
                        if (mounted) {
                          setState(() {
                            _currentZoom = cameraState.zoom;
                            _currentLat = cameraState.center.coordinates.lat.toDouble();
                          });
                        }
                      });
                    }
                  },
                ),

                // Map Scale Bar
                MapScaleBar(
                  zoom: _currentZoom,
                  latitude: _currentLat,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16, top: 16),
                ),

                // Floating Action Buttons (Home + Reset Zoom)
                Positioned(
                  right: effectiveSidebarWidth + 8,
                  top: 16,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'fab_home_${widget.title}',
                        onPressed: () => Navigator.of(context).pop(),
                        backgroundColor: AppColors.primaryBrown,
                        elevation: 6,
                        child: Image.asset(
                          AppAssets.home,
                          width: 28,
                          height: 28,
                          color: Colors.white,
                          errorBuilder: (c, e, s) => const Icon(Icons.home, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FloatingActionButton(
                        heroTag: 'fab_zoom_${widget.title}',
                        onPressed: _resetZoom,
                        backgroundColor: AppColors.primaryBrown,
                        elevation: 6,
                        child: Image.asset(
                          AppAssets.zoom,
                          width: 26,
                          height: 26,
                          color: Colors.white,
                          errorBuilder: (c, e, s) => const Icon(Icons.zoom_out_map, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                // Right-side Sidebar matching Android activity_*.xml
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: effectiveSidebarWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage(AppAssets.wallpaper),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 16,
                          offset: const Offset(-4, 0),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                widget.title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontFamily: 'NotoKufi',
                                  fontSize: 30,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBlack,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Optional Intro/Brief Button matching Android main_menu_btn
                          if (widget.onBriefPressed != null) ...[
                            Container(
                              width: double.infinity,
                              height: 70,
                              margin: const EdgeInsets.only(left: 21, right: 21, bottom: 16),
                              decoration: BoxDecoration(
                                color: AppColors.mainMenuBtnBg,
                                borderRadius: BorderRadius.circular(AppColors.borderRadius),
                                border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.12),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                                  onTap: widget.onBriefPressed,
                                  child: Center(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        widget.briefButtonText,
                                        style: const TextStyle(
                                          fontFamily: 'NotoKufi',
                                          fontSize: 25,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textBlack,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],

                          // Sidebar scrollable content
                          Expanded(
                            child: widget.sidebarContent,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Loading overlay
                if (widget.isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.25),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryBrown,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
