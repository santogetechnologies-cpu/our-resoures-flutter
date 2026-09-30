import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';
import 'map_scale_bar.dart';

class MapShell extends StatefulWidget {
  final String title;
  final VoidCallback? onBriefPressed;
  final String briefButtonText;
  final Widget sidebarContent;
  final List<Marker> markers;
  final List<Polyline> polylines;
  final List<Polygon> polygons;
  final bool isLoading;
  final void Function(MapController)? onMapReady;
  final LatLng initialCenter;
  final double initialZoom;
  final double sidebarWidth;

  const MapShell({
    super.key,
    required this.title,
    this.onBriefPressed,
    this.briefButtonText = 'مقدمة',
    required this.sidebarContent,
    this.markers = const [],
    this.polylines = const [],
    this.polygons = const [],
    this.isLoading = false,
    this.onMapReady,
    this.initialCenter = const LatLng(24.694291, 47.189224),
    this.initialZoom = 5.0,
    this.sidebarWidth = 350,
  });

  @override
  State<MapShell> createState() => _MapShellState();
}

class _MapShellState extends State<MapShell> {
  late final MapController _mapController;
  late double _currentZoom;
  late double _currentLat;

  @override
  void initState() {
    super.initState();
    _currentZoom = widget.initialZoom;
    _currentLat = widget.initialCenter.latitude;
    _mapController = MapController();
    if (widget.onMapReady != null) {
      widget.onMapReady!(_mapController);
    }
  }

  void _resetZoom() {
    _mapController.move(widget.initialCenter, widget.initialZoom);
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
                // Map
                FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: widget.initialCenter,
                    initialZoom: widget.initialZoom,
                    minZoom: 3.5,
                    maxZoom: 18.0,
                    onPositionChanged: (position, hasGesture) {
                      if (position.zoom != null && position.center != null) {
                        setState(() {
                          _currentZoom = position.zoom!;
                          _currentLat = position.center!.latitude;
                        });
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                      userAgentPackageName: 'com.example.flutter_app',
                      maxZoom: 19,
                    ),
                    if (widget.polygons.isNotEmpty)
                      PolygonLayer(polygons: widget.polygons),
                    if (widget.polylines.isNotEmpty)
                      PolylineLayer(polylines: widget.polylines),
                    if (widget.markers.isNotEmpty)
                      MarkerLayer(markers: widget.markers),
                  ],
                ),

                // Map Scale Bar (0 | 500 km | 1000 km dynamic scale bar matching Mapbox native Android SDK)
                MapScaleBar(
                  zoom: _currentZoom,
                  latitude: _currentLat,
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.only(left: 16, top: 16),
                ),

                // Floating Action Buttons (Home + Reset Zoom) positioned immediately adjacent to the 350dp sidebar
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
