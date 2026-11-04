import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/map_view_platform.dart';
import '../../core/dialogs/app_brief_dialog.dart';
import '../../core/dialogs/app_popup_dialog.dart';

class ReserveItem {
  final int index;
  final String id;
  final String nameAr;
  final String nameEn;
  final String category; // 'royal_natural' or 'ncw'
  final String layer;
  final String governance;
  final String status;
  final String description;
  final double minLng;
  final double minLat;
  final double maxLng;
  final double maxLat;
  final double centerLng;
  final double centerLat;

  const ReserveItem({
    required this.index,
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.category,
    required this.layer,
    required this.governance,
    required this.status,
    required this.description,
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
  String? _expandedCategory = 'royal_natural';
  String? _selectedReserveId;
  final List<ReserveItem> _allReserves = [];

  // Metadata dictionary for rich descriptive details for each reserve
  static const Map<int, ({String en, String desc})> _reserveMeta = {
    0: (
      en: 'Al-Gharameel Reserve',
      desc: 'تقع شمال محافظة العلا، وتشتهر بتكويناتها الصخرية الفريدة وأعمدتها الداكنة الشاهقة وسماؤها الصافية المصنفة عالمياً كواحدة من أفضل وجهات السياحة الفلكية ومراقبة النجوم، وتوفر ملاذاً طبيعياً للحياة الفطرية الصحراوية.'
    ),
    1: (
      en: 'Sharaan Nature Reserve',
      desc: 'محمية طبيعية تقع في محافظة العلا على مساحة تقارب 1,500 كم²، وتتميز بتضاريس جبال الحجر الرملي الأخاذة، وتعد موطناً لبرامج إكثار وحماية النمر العربي المهدد بالانقراض والوعل النوبي وغزلان الريم والإدمي.'
    ),
    2: (
      en: 'Harrat Uwayrid Reserve',
      desc: 'محمية مسجلة في برنامج الإنسان والمحيط الحيوي (MAB) التابع لليونسكو، تقع غرب العلا على مساحة تقارب 3,800 كم²، وتضم صخوراً بازلتية بركانية وأودية خصبة تحتضن نباتات نادرة وحيوانات جبلية أصيلة.'
    ),
    3: (
      en: 'Harrat Az-Zabin Reserve',
      desc: 'محمية طبيعية جيولوجية تقع في امتداد حرة الزبن، وتتميز بتكويناتها البركانية وهضابها البازلتية ونباتاتها الحولية والمعمرة المتكيفة مع بيئات الصخور البركانية في غرب المملكة.'
    ),
    4: (
      en: 'Wadi Nakhla Reserve',
      desc: 'محمية أودية طبيعية تزخر بغطاء نباتي كثيف ومجاري سيول عذبة وتجمعات لأشجار النخيل والسمر البري، وتعد موئلاً بيئياً خصباً للطيور المتوطنة والمهاجرة والزواحف والثدييات الصغيرة.'
    ),
    5: (
      en: 'King Salman Royal Reserve',
      desc: 'أكبر المحميات الملكية في المملكة والشرق الأوسط بمساحة تتجاوز 130,700 كم²، وتضم مناطق الطبيق وحرة الحرة والخنفة، وتتميز بتنوع بيئاتها من الهضاب والصحاري والجبال وملاذها للمها والريم والذئاب.'
    ),
    6: (
      en: 'NEOM Nature Reserve',
      desc: 'منطقة محمية رائدة تمتد عبر قطاعات نيوم بمساحة تبلغ 25,000 كم²، وتستهدف استعادة 95% من الطبيعة البكر وإعادة توطين المها العربي والوعل الجبلي والظباء وحماية البيئات الساحلية الخلابة.'
    ),
    7: (
      en: 'Prince Mohammed bin Salman Royal Reserve',
      desc: 'محمية ملكية استراتيجية تمتد بين مشروعي نيوم والبحر الأحمر بمساحة تبلغ 24,500 كم²، وتغطي 15 نظاماً بيئياً ممتداً من قمم الجبال الشاهقة إلى أعماق الشعاب المرجانية في البحر الأحمر.'
    ),
    8: (
      en: 'Imam Turki bin Abdullah Royal Reserve',
      desc: 'محمية ملكية تقع في شمال شرق المملكة بمساحة تتجاوز 91,300 كم²، وتشتهر بغطائها النباتي الفريد من أشجار السدر والطلح وتعد مقصداً للسياحة البيئية وموطناً لإعادة توطين غزال الريم والمها العربي.'
    ),
    9: (
      en: 'King Abdulaziz Royal Reserve',
      desc: 'محمية ملكية تقع شمال شرق الرياض في منطقتي الصمان والدهناء بمساحة تبلغ 28,000 كم²، وتضم روضة التنهات وروضة الخفس، وتعد نموذجاً رائداً لإعادة تأهيل المراعي وحماية الحياة الفطرية الصحراوية.'
    ),
    10: (
      en: 'Imam Abdulaziz bin Mohammed Royal Reserve',
      desc: 'محمية ملكية تقع في هضبة العرمة شمال شرق مدينة الرياض بمساحة 11,300 كم²، وتضم روضة خريم ومحيطها الجغرافي، وتتميز بالتنوع الأحيائي النباتي الغني وإعادة توطين الظباء والحيوانات الفطرية.'
    ),
    11: (
      en: 'Nufud Al-Urayq Reserve',
      desc: 'محمية طبيعية تقع في منطقة القصيم بمساحة 2,036 كم²، وتتميز بكثبانها الرملية الذهبية ونباتات الرمث والأرطى، وتعد محطة حيوية لاستراحة الطيور المهاجرة وموطناً مناسباً لإعادة توطين طائر الحبارى.'
    ),
    12: (
      en: 'Jubail Marine Wildlife Sanctuary',
      desc: 'محمية بحرية ساحلية على الخليج العربي شمال الجبيل بمساحة تتجاوز 2,400 كم²، أنشئت لحماية البيئات البحرية والشعاب المرجانية وغابات المانغروف (الشورى) وجزر تكاثر السلاحف البحرية والطيور المائية.'
    ),
    13: (
      en: 'Ibex Reserve',
      desc: 'محمية طبيعية جبلية وعرة تقع جنوب الرياض في محافظتي حوطة بني تميم والحريق بمساحة 1,840 كم²، وتعد المعقل التاريخي لحماية الوعل النوبي في جبال طويق وأوديتها الخصبة بأشجار الطلح والسمر.'
    ),
    14: (
      en: 'Saja and Umm Ar-Rimth Reserve',
      desc: 'محمية طبيعية واسعة تقع في عالية نجد بمساحة تبلغ 5,860 كم²، وتمتاز بتضاريسها السهلية المتموجة وغطائها النباتي الشجيري، وتستخدم كموقع رئيسي لإعادة توطين طيور الحبارى والمها العربي والنعام.'
    ),
    15: (
      en: 'Imam Saud bin Abdulaziz Royal Reserve',
      desc: 'محمية ملكية تقع في منطقة مكة المكرمة بمساحة 2,241 كم² (محمية محازة الصيد سابقاً)، وتعد أول محمية مسيجة بالكامل وتضم ثاني أكبر مجتمع في العالم للمها العربي الطليق وغزلان الريم والنعام.'
    ),
    16: (
      en: 'Majami Al-Hadb Reserve',
      desc: 'محمية طبيعية تقع شرق محافظة رنية بمساحة 2,251 كم²، وتجمع بين التلال والقباب الجرانيتية والأودية الحصوية وسهول الرمال، وتعد موئلاً آمناً للذئب العربي والضبع المخطط والوعل الجبلي.'
    ),
    17: (
      en: 'Uruq Bani Ma\'arid Reserve',
      desc: 'أول موقع للتراث العالمي الطبيعي لليونسكو في المملكة، يقع على الحافة الجنوبية الغربية للربع الخالي بمساحة 12,787 كم²، ويشكل موطناً تاريخياً طليقاً للمها العربي والظباء وحيوانات الرمال.'
    ),
    18: (
      en: 'King Khalid Royal Reserve',
      desc: 'محمية ملكية تقع شمال شرق مدينة الرياض بمساحة 721 كم² (محمية الثمامة سابقاً)، وتعد متنفساً طبيعياً رائداً يجمع بين مشاريع التشجير وإكثار الأنواع الفطرية والتوعية البيئية المستدامة.'
    ),
    19: (
      en: 'Jabal Shada Al-A\'la Reserve',
      desc: 'محمية جبلية تقع في محافظة المخواة بمنطقة الباحة بمساحة تقارب 68 كم²، وترتفع قمتها لنحو 2,200 م، وتتميز بتنوع فريد في النباتات الطبية وأشجار العرعر وملاذ طبيعي للنمر العربي والطيور الجبلية.'
    ),
    20: (
      en: 'Umm Al-Qamari Islands Reserve',
      desc: 'محمية جزر مرجانية خلابة تقع جنوب غرب القنفذة في البحر الأحمر، وتشتهر بتكاثر أعداد استثنائية من طيور القماري المهاجرة وتنوع غني في الشعاب المرجانية والأسماك النادرة والكائنات البحرية.'
    ),
    21: (
      en: 'Raydah Reserve',
      desc: 'محمية جبلية تابعة للمركز الوطني للحياة الفطرية في جبال السروات شمال غرب أبها بمساحة 9 كم²، وتضم غابة كثيفة من أشجار العرعر المعمرة والزيتون البري وتعد الموئل الوحيد لطائر العقعق العسيري النادر.'
    ),
    22: (
      en: 'Ra\'s Hatiba Marine Area',
      desc: 'منطقة محمية بحرية وساحلية تابعة للمركز الوطني للحياة الفطرية على ساحل البحر الأحمر شمال محافظة جدة، تحمي موائل السلاحف البحرية ومناطق الحشائش البحرية ومستنقعات أشجار الشورى الساحلية.'
    ),
    23: (
      en: 'Blue Holes Marine Protected Area',
      desc: 'محمية بحرية نادرة استكشفها المركز الوطني لتنمية الحياة الفطرية في البحر الأحمر، وتعد ظاهرة جيولوجية بحرية استثنائية بتجاويفها المرجانية الغائرة وتنوعها الأحيائي المذهل للكائنات البحرية وأسماك القرش.'
    ),
  };

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
        jsonStr = await rootBundle.loadString('assets/maps/reserves/SGS.geojson');
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

        String nameAr = (props['Name'] ?? props['arabic_nam'] ?? 'محمية ${i + 1}').toString().trim();
        if (nameAr == 'نـــيـــــوم') nameAr = 'منطقة نيوم المحمية';
        if (nameAr == 'الجبيل للأحياء البحرية') nameAr = 'محمية الجبيل للأحياء البحرية';
        if (nameAr == 'عروق بني معارض') nameAr = 'محمية عروق بني معارض';
        if (nameAr == 'جبل شدا الاعلى') nameAr = 'محمية جبل شدا الأعلى';
        if (nameAr == 'جزر ام القماري') nameAr = 'محمية جزر أم القماري';
        if (nameAr == 'رأس حاطبة') nameAr = 'محمية رأس حاطبة';
        if (nameAr == 'الثقوب الزرقاء') nameAr = 'محمية الثقوب الزرقاء';

        final meta = _reserveMeta[i];
        final nameEn = meta?.en ?? (props['english_na']?.toString() ?? '');
        final desc = meta?.desc ?? (props['descriptio']?.toString() ?? '');
        final layer = props['layer']?.toString() ?? '';
        final category = (layer == 'NCW_PA') ? 'ncw' : 'royal_natural';
        final id = props['id']?.toString() ?? 'reserve_$i';

        _allReserves.add(ReserveItem(
          index: i,
          id: id,
          nameAr: nameAr,
          nameEn: nameEn,
          category: category,
          layer: layer,
          governance: props['governance']?.toString() ?? (category == 'ncw' ? 'NCW' : 'Royal'),
          status: props['status']?.toString() ?? 'PA',
          description: desc,
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

  void _onPolygonTapped(String reserveId) {
    final matched = _allReserves.firstWhere(
      (r) => r.id == reserveId || 'reserve_${r.index}' == reserveId || r.nameAr == reserveId,
      orElse: () => _allReserves.first,
    );
    _selectAndShowReserve(matched);
  }

  void _selectAndShowReserve(ReserveItem reserve) {
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

    final catLabel = (reserve.category == 'ncw')
        ? 'المركز الوطني لتنمية الحياة الفطرية (NCW)'
        : 'المحميات الملكية والطبيعية بالمملكة';

    AppPopupDialog.show(
      context,
      title: reserve.nameAr,
      description: 'الاسم بالإنجليزية: ${reserve.nameEn}\n'
          'التصنيف الإداري: $catLabel\n'
          'النوع: منطقة محمية معتمدة (PA)\n'
          'إحداثيات المركز: ${reserve.centerLat.toStringAsFixed(3)}°N, ${reserve.centerLng.toStringAsFixed(3)}°E\n\n'
          'نبذة عن المحمية والأهداف البيئية:\n${reserve.description}',
    );
  }

  void _showIntroBrief() {
    AppBriefDialog.show(
      context,
      title: 'المحميات، حكاية الأرض ومخاطر الطبيعة',
      description:
          'تعد المحميات الملكية والطبيعية في المملكة العربية السعودية إحدى الركائز الأساسية لمبادرة السعودية الخضراء ومستهدفات رؤية المملكة 2030 لحماية البيئة وتنميتها المستدامة.\n\n'
          'تمتد هذه المحميات على مساحات شاسعة تغطي أكثر من 16% من مساحة المملكة، وتهدف إلى:\n'
          '1. صون التنوع الأحيائي وحماية النظم البيئية والجيولوجية النادرة في الصحاري والجبال وسواحل البحر الأحمر والخليج العربي.\n'
          '2. إعادة توطين وإكثار الكائنات المهددة بالانقراض مثل المها العربي، النمر العربي، الوعل النوبي، غزال الريم، وطائر الحبارى.\n'
          '3. الحد من التصحر وإعادة تأهيل الغطاء النباتي الطبيعي عبر زراعة ملايين الأشجار البرية كأشجار السمر، الطلح، السدر، والعرعر.\n'
          '4. تنشيط السياحة البيئية المسؤولة وتعزيز الوعي المجتمعي لحماية الطبيعة والحد من مخاطر التدهور البيئي والجفاف.\n\n'
          'تضم هذه الخريطة التفاعلية كافة الحدود الجغرافية الرسمية لـ 24 محمية معتمدة تمثل المحميات الملكية الكبرى ومحميات المركز الوطني لتنمية الحياة الفطرية (NCW).',
    );
  }

  @override
  Widget build(BuildContext context) {
    final royalReserves = _allReserves.where((r) => r.category == 'royal_natural').toList();
    final ncwReserves = _allReserves.where((r) => r.category == 'ncw').toList();

    return MapShell(
      title: 'المحميات، حكاية الأرض ومخاطر الطبيعة',
      onBriefPressed: _showIntroBrief,
      briefButtonText: 'مقدمة',
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
          // Category 1: المحميات الملكية والطبيعية
          CustomButton(
            text: 'المحميات الملكية والطبيعية (${royalReserves.length})',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                if (_expandedCategory == 'royal_natural') {
                  _expandedCategory = null;
                } else {
                  _expandedCategory = 'royal_natural';
                }
              });
            },
          ),
          if (_expandedCategory == 'royal_natural') ...[
            const SizedBox(height: 6),
            ...royalReserves.map((reserve) {
              final isSelected = reserve.id == _selectedReserveId;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 21, vertical: 3.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFE65100).withValues(alpha: 0.45),
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

          // Category 2: محميات المركز الوطني للحياة الفطرية
          CustomButton(
            text: 'محميات الحياة الفطرية (NCW) (${ncwReserves.length})',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                if (_expandedCategory == 'ncw') {
                  _expandedCategory = null;
                } else {
                  _expandedCategory = 'ncw';
                }
              });
            },
          ),
          if (_expandedCategory == 'ncw') ...[
            const SizedBox(height: 6),
            ...ncwReserves.map((reserve) {
              final isSelected = reserve.id == _selectedReserveId;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 21, vertical: 3.5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppColors.borderRadius),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFE65100).withValues(alpha: 0.45),
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
