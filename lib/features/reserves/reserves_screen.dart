import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/map_view_platform.dart';
import '../../core/dialogs/pdf_viewer_dialog.dart';

class ReserveItem {
  final int index;
  final int num;
  final String id;
  final String nameAr;
  final String nameEn;
  final String category; // 'terrestrial' or 'marine'
  final String pdfAsset;
  final double minLng;
  final double minLat;
  final double maxLng;
  final double maxLat;
  final double centerLng;
  final double centerLat;

  const ReserveItem({
    required this.index,
    required this.num,
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.category,
    required this.pdfAsset,
    required this.minLng,
    required this.minLat,
    required this.maxLng,
    required this.maxLat,
    required this.centerLng,
    required this.centerLat,
  });
}

class ReservesScreen extends StatefulWidget {
  const ReservesScreen({super.key});

  @override
  State<ReservesScreen> createState() => _ReservesScreenState();
}

class _ReservesScreenState extends State<ReservesScreen> {
  MapShellController? _mapController;
  bool _isLoading = false;
  String? _rawGeoJsonString;
  String? _expandedCategory = 'terrestrial';
  String? _selectedReserveId;
  final List<ReserveItem> _allReserves = [];

  @override
  void initState() {
    super.initState();
    _loadGeoJsonData();
    registerReservePolygonCallback((reserveId) {
      if (mounted) {
        _onPolygonTapped(reserveId);
      }
    });
  }

  @override
  void dispose() {
    registerReservePolygonCallback(null);
    super.dispose();
  }

  Future<void> _loadGeoJsonData() async {
    setState(() => _isLoading = true);
    try {
      String jsonStr;
      try {
        jsonStr =
            await rootBundle.loadString('assets/maps/reserves/SGS.geojson');
      } catch (_) {
        jsonStr = await rootBundle.loadString('SGS/SGS.geojson');
      }

      _rawGeoJsonString = jsonStr;
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      final features = data['features'] as List<dynamic>? ?? [];

      _allReserves.clear();
      for (int i = 0; i < features.length; i++) {
        final f = features[i] as Map<String, dynamic>;
        final props = f['properties'] as Map<String, dynamic>? ?? {};
        final geom = f['geometry'] as Map<String, dynamic>? ?? {};
        final coords = geom['coordinates'] as List<dynamic>? ?? [];

        // Extract boundary limits
        final pts = <List<double>>[];
        void extract(dynamic c) {
          if (c is List && c.isNotEmpty) {
            if (c[0] is num) {
              pts.add([(c[0] as num).toDouble(), (c[1] as num).toDouble()]);
            } else {
              for (final sub in c) {
                extract(sub);
              }
            }
          }
        }

        extract(coords);

        double minLng = 0, maxLng = 0, minLat = 0, maxLat = 0;
        if (pts.isNotEmpty) {
          final lons = pts.map((p) => p[0]).toList();
          final lats = pts.map((p) => p[1]).toList();
          minLng = lons.reduce((a, b) => a < b ? a : b);
          maxLng = lons.reduce((a, b) => a > b ? a : b);
          minLat = lats.reduce((a, b) => a < b ? a : b);
          maxLat = lats.reduce((a, b) => a > b ? a : b);
        }
        final centerLng = (minLng + maxLng) / 2;
        final centerLat = (minLat + maxLat) / 2;

        final numVal = (props['num'] is int)
            ? (props['num'] as int)
            : int.tryParse(props['num']?.toString() ?? '') ?? (i + 1);

        final nameAr = (props['Name'] ?? props['arabic_nam'] ?? 'محمية $numVal')
            .toString()
            .trim();
        final nameEn = props['english_na']?.toString() ?? '';
        final category = props['category']?.toString() ??
            ((numVal <= 21) ? 'terrestrial' : 'marine');
        final id = props['id']?.toString() ?? 'reserve_$numVal';
        final pdfAsset = props['pdfAsset']?.toString() ??
            'assets/books/reserves/reserve_${numVal.toString().padLeft(2, '0')}.pdf';

        _allReserves.add(ReserveItem(
          index: i,
          num: numVal,
          id: id,
          nameAr: nameAr,
          nameEn: nameEn,
          category: category,
          pdfAsset: pdfAsset,
          minLng: minLng,
          minLat: minLat,
          maxLng: maxLng,
          maxLat: maxLat,
          centerLng: centerLng,
          centerLat: centerLat,
        ));
      }

      if (_mapController != null && _rawGeoJsonString != null) {
        _mapController!.loadReserves(
          geoJsonString: _rawGeoJsonString!,
          selectedReserveId: _selectedReserveId,
        );
      }
    } catch (e) {
      debugPrint('[ReservesScreen] Error loading GeoJSON: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _isPopupOpen = false;
  DateTime _lastPopupDismissed = DateTime.fromMillisecondsSinceEpoch(0);

  void _onPolygonTapped(String reserveId) {
    if (_isPopupOpen) return;
    if (DateTime.now().difference(_lastPopupDismissed).inMilliseconds < 450) {
      return;
    }
    final matched = _allReserves.firstWhere(
      (r) =>
          r.id == reserveId ||
          'reserve_${r.num}' == reserveId ||
          'reserve_${r.index}' == reserveId ||
          r.nameAr == reserveId,
      orElse: () => _allReserves.first,
    );
    _selectAndShowReserve(matched);
  }

  Future<void> _selectAndShowReserve(ReserveItem reserve) async {
    if (_isPopupOpen) return;
    _isPopupOpen = true;

    setState(() {
      _selectedReserveId = reserve.id;
      _expandedCategory = reserve.category;
    });

    if (_mapController != null) {
      _mapController!.selectReserve(reserve.id);
      _mapController!.fitBounds(
        minLng: reserve.minLng,
        minLat: reserve.minLat,
        maxLng: reserve.maxLng,
        maxLat: reserve.maxLat,
        padding: 95.0,
      );
    }

    try {
      await PdfViewerDialog.show(
        context,
        title: reserve.nameAr,
        assetPath: reserve.pdfAsset,
      );
    } finally {
      _lastPopupDismissed = DateTime.now();
      _isPopupOpen = false;
    }
  }

  Future<void> _showIntroBrief() async {
    if (_isPopupOpen) return;
    _isPopupOpen = true;

    try {
      await PdfViewerDialog.show(
        context,
        title: 'المحميات في سطور',
        assetPath: 'assets/books/reserves/reserves_intro.pdf',
      );
    } finally {
      _lastPopupDismissed = DateTime.now();
      _isPopupOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final terrestrialReserves =
        _allReserves.where((r) => r.category == 'terrestrial').toList();
    final marineReserves =
        _allReserves.where((r) => r.category == 'marine').toList();

    return MapShell(
      title: 'المحميات، حكاية الأرض ومخاطر الطبيعة',
      onBriefPressed: _showIntroBrief,
      briefButtonText: 'المحميات في سطور',
      initialStyleAsset: 'assets/maps/saudi_geo/sahel.json',
      initialLatitude: 24.5,
      initialLongitude: 44.5,
      initialZoom: 5.2,
      isLoading: _isLoading,
      onMapCreated: (controller) {
        _mapController = controller;
        if (_rawGeoJsonString != null) {
          controller.loadReserves(
            geoJsonString: _rawGeoJsonString!,
            selectedReserveId: _selectedReserveId,
          );
        }
      },
      sidebarContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category 1: From 1 to 21 المحميات البرية
          CustomButton(
            text: 'المحميات البرية',
            height: 76,
            fontSize: 22,
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                if (_expandedCategory == 'terrestrial') {
                  _expandedCategory = null;
                } else {
                  _expandedCategory = 'terrestrial';
                }
              });
            },
          ),
          if (_expandedCategory == 'terrestrial') ...[
            const SizedBox(height: 6),
            ...terrestrialReserves.map((reserve) {
              final isSelected = reserve.id == _selectedReserveId;
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 3.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFFE65100).withValues(alpha: 0.45),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: CustomButton(
                  text: reserve.nameAr,
                  styleType: ButtonStyleType.subMenu,
                  margin: EdgeInsets.zero,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  onPressed: () => _selectAndShowReserve(reserve),
                ),
              );
            }),
          ],

          const SizedBox(height: 14),

          // Category 2: From 22 to 26 المحميات البحرية
          CustomButton(
            text: 'المحميات البحرية',
            height: 76,
            fontSize: 22,
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                if (_expandedCategory == 'marine') {
                  _expandedCategory = null;
                } else {
                  _expandedCategory = 'marine';
                }
              });
            },
          ),
          if (_expandedCategory == 'marine') ...[
            const SizedBox(height: 6),
            ...marineReserves.map((reserve) {
              final isSelected = reserve.id == _selectedReserveId;
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 21, vertical: 3.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color:
                                const Color(0xFFE65100).withValues(alpha: 0.45),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : null,
                ),
                child: CustomButton(
                  text: reserve.nameAr,
                  styleType: ButtonStyleType.subMenu,
                  margin: EdgeInsets.zero,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  onPressed: () => _selectAndShowReserve(reserve),
                ),
              );
            }),
          ],
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
