import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/dialogs/water_infographic_dialog.dart';
import '../../core/dialogs/app_popup_dialog.dart';

class DamLocation {
  final String name;
  final String gov;
  final String region;
  final String type;
  final double length;
  final double height;
  final double crestHeight;
  final double capacity;
  final String theDate;
  final double latitude;
  final double longitude;

  DamLocation({
    required this.name,
    required this.gov,
    required this.region,
    required this.type,
    required this.length,
    required this.height,
    required this.crestHeight,
    required this.capacity,
    required this.theDate,
    required this.latitude,
    required this.longitude,
  });
}

class WaterFormationsScreen extends StatefulWidget {
  const WaterFormationsScreen({super.key});

  @override
  State<WaterFormationsScreen> createState() => _WaterFormationsScreenState();
}

class _WaterFormationsScreenState extends State<WaterFormationsScreen> {
  MapShellController? _mapController;
  bool _valleysExpanded = false;
  bool _damsExpanded = false;
  bool _mainFormationsExpanded = false;
  bool _subFormationsExpanded = false;
  bool _isLoading = false;

  List<DamLocation> _dams = [];
  final Map<String, DamLocation> _annotationDamMap = {};

  final Map<String, ({String path, Color color, String nameAr, double length})> _valleys = {
    'Wadi_Aba_Al_Qu': (path: 'assets/maps/valleys/Wadi_Aba_Al_Qu.geojson', color: const Color(0xFF1AA33F), nameAr: 'وادي أبا القور', length: 120.0),
    'Wadi_Aba_Ar_Ruwath': (path: 'assets/maps/valleys/Wadi_Aba_Ar_Ruwath.geojson', color: const Color(0xFFA31F1A), nameAr: 'وادي أبا الروث', length: 85.0),
    'Wadi_Al_Ahsabah': (path: 'assets/maps/valleys/Wadi_Al_Ahsabah.geojson', color: const Color(0xFFA3411A), nameAr: 'وادي الأحسبة', length: 110.0),
    'Wadi_Al_Akhda': (path: 'assets/maps/valleys/Wadi_Al_Akhda.geojson', color: const Color(0xFF73A31A), nameAr: 'وادي الآخضر', length: 95.0),
    'Wadi_Al_Amq': (path: 'assets/maps/valleys/Wadi_Al_Amq.geojson', color: const Color(0xFF3CA31A), nameAr: 'وادي العمق', length: 130.0),
    'Wadi_Al_Batin': (path: 'assets/maps/valleys/Wadi_Al_Batin.geojson', color: const Color(0xFF1AA333), nameAr: 'وادي الباطن', length: 240.0),
    'Wadi_Al_Farshah': (path: 'assets/maps/valleys/Wadi_Al_Farshah.geojson', color: const Color(0xFF1AA333), nameAr: 'وادي الفرشة', length: 70.0),
    'Wadi_Al_Gharr': (path: 'assets/maps/valleys/Wadi_Al_Gharr.geojson', color: const Color(0xFF1AA375), nameAr: 'وادي الغار', length: 90.0),
    'Wadi_al_Ghinah': (path: 'assets/maps/valleys/Wadi_al_Ghinah.geojson', color: const Color(0xFF1AA375), nameAr: 'وادي الغينة', length: 65.0),
    'Wadi_Al_Hamal': (path: 'assets/maps/valleys/Wadi_Al_Hamal.geojson', color: const Color(0xFF1A93A3), nameAr: 'وادي الحمل', length: 140.0),
    'Wadi_Al_Hamd': (path: 'assets/maps/valleys/Wadi_Al_Hamd.geojson', color: const Color(0xFF1A75A3), nameAr: 'وادي الحمض', length: 465.0),
    'Wadi_Al_Hinu': (path: 'assets/maps/valleys/Wadi_Al_Hinu.geojson', color: const Color(0xFF1A45A3), nameAr: 'وادي الحنو', length: 75.0),
    'Wadi_Al_Jarir': (path: 'assets/maps/valleys/Wadi_Al_Jarir.geojson', color: const Color(0xFF251AA3), nameAr: 'وادي الجرير', length: 260.0),
    'Wadi_Al_Jizil': (path: 'assets/maps/valleys/Wadi_Al_Jizil.geojson', color: const Color(0xFF5C30C2), nameAr: 'وادي الجزل', length: 280.0),
    'Wadi_al_Judwal': (path: 'assets/maps/valleys/Wadi_al_Judwal.geojson', color: const Color(0xFF641CA3), nameAr: 'وادي الجدول', length: 55.0),
    'Wadi_Al_Khurmah': (path: 'assets/maps/valleys/Wadi_Al_Khurmah.geojson', color: const Color(0xFF7D1CA3), nameAr: 'وادي الخرمة', length: 210.0),
    'Wadi_Al_Lith': (path: 'assets/maps/valleys/Wadi_Al_Lith.geojson', color: const Color(0xFFA31C9C), nameAr: 'وادي الليث', length: 160.0),
    'Wadi_Al_Makhit': (path: 'assets/maps/valleys/Wadi_Al_Makhit.geojson', color: const Color(0xFFA31C7B), nameAr: 'وادي المخيط', length: 80.0),
    'Wadi_Al_Maqran': (path: 'assets/maps/valleys/Wadi_Al_Maqran.geojson', color: const Color(0xFFA31C5F), nameAr: 'وادي المقرن', length: 90.0),
    'Wadi_Al_Mira': (path: 'assets/maps/valleys/Wadi_Al_Mira.geojson', color: const Color(0xFFA31C40), nameAr: 'وادي الميرة', length: 115.0),
    'Wadi_al_Qimra': (path: 'assets/maps/valleys/Wadi_al_Qimra.geojson', color: const Color(0xFFA31C29), nameAr: 'وادي القمرة', length: 60.0),
    'Wadi_Ar_Raka': (path: 'assets/maps/valleys/Wadi_Ar_Raka.geojson', color: const Color(0xFF7D803B), nameAr: 'وادي الركاء', length: 175.0),
    'Wadi_Ar_Risha': (path: 'assets/maps/valleys/Wadi_Ar_Risha.geojson', color: const Color(0xFF61803B), nameAr: 'وادي الريشة', length: 70.0),
    'Wadi_Ar_Rumah': (path: 'assets/maps/valleys/Wadi_Ar_Rumah.geojson', color: const Color(0xFF42803B), nameAr: 'وادي الرمة', length: 600.0),
    'Wadi_Arar': (path: 'assets/maps/valleys/Wadi_Arar.geojson', color: const Color(0xFF3B8050), nameAr: 'وادي عرعر', length: 165.0),
    'Wadi_As_Sahba': (path: 'assets/maps/valleys/Wadi_As_Sahba.geojson', color: const Color(0xFF3B8063), nameAr: 'وادي السهباء', length: 220.0),
    'Wadi_As_surrah': (path: 'assets/maps/valleys/Wadi_As_surrah.geojson', color: const Color(0xFF3B7B80), nameAr: 'وادي السرة', length: 145.0),
    'Wadi_Ash_Shu_bah': (path: 'assets/maps/valleys/Wadi_Ash_Shu_bah.geojson', color: const Color(0xFF3B6B80), nameAr: 'وادي الشعبة', length: 190.0),
    'Wadi_Baysh': (path: 'assets/maps/valleys/Wadi_Baysh.geojson', color: const Color(0xFF3B5480), nameAr: 'وادي بيش', length: 180.0),
    'Wadi_Bishah': (path: 'assets/maps/valleys/Wadi_Bishah.geojson', color: const Color(0xFF3B3C80), nameAr: 'وادي بيشة', length: 450.0),
    'Wadi_Bitat': (path: 'assets/maps/valleys/Wadi_Bitat.geojson', color: const Color(0xFF513B80), nameAr: 'وادي بطاط', length: 65.0),
    'Wadi_Damad': (path: 'assets/maps/valleys/Wadi_Damad.geojson', color: const Color(0xFF673B80), nameAr: 'وادي ضمد', length: 125.0),
    'Wadi_Dawqah': (path: 'assets/maps/valleys/Wadi_Dawqah.geojson', color: const Color(0xFF7E3B80), nameAr: 'وادي دوقة', length: 95.0),
    'Wadi_Fajr': (path: 'assets/maps/valleys/Wadi_Fajr.geojson', color: const Color(0xFF803B69), nameAr: 'وادي فجر', length: 215.0),
    'Wadi_Hali': (path: 'assets/maps/valleys/Wadi_Hali.geojson', color: const Color(0xFF803B4F), nameAr: 'وادي حلي', length: 160.0),
    'Wadi_Hamir': (path: 'assets/maps/valleys/Wadi_Hamir.geojson', color: const Color(0xFFDB6353), nameAr: 'وادي حامض', length: 110.0),
    'Wadi_Hanifah': (path: 'assets/maps/valleys/Wadi_Hanifah.geojson', color: const Color(0xFF9ADB53), nameAr: 'وادي حنيفة', length: 120.0),
    'Wadi_Hirjab': (path: 'assets/maps/valleys/Wadi_Hirjab.geojson', color: const Color(0xFF63DB53), nameAr: 'وادي هرجاب', length: 140.0),
    'Wadi_Hubuna': (path: 'assets/maps/valleys/Wadi_Hubuna.geojson', color: const Color(0xFF53DB85), nameAr: 'وادي حبونا', length: 150.0),
    'Wadi_Itwad': (path: 'assets/maps/valleys/Wadi_Itwad.geojson', color: const Color(0xFF53DBC9), nameAr: 'وادي عتود', length: 105.0),
    'Wadi_Najran': (path: 'assets/maps/valleys/Wadi_Najran.geojson', color: const Color(0xFF539ADB), nameAr: 'وادي نجران', length: 190.0),
    'Wadi_Nayyal': (path: 'assets/maps/valleys/Wadi_Nayyal.geojson', color: const Color(0xFF6A53DB), nameAr: 'وادي نيال', length: 85.0),
    'Wadi_Qatan': (path: 'assets/maps/valleys/Wadi_Qatan.geojson', color: const Color(0xFF9A53DB), nameAr: 'وادي قطن', length: 90.0),
    'Wadi_Ranyah': (path: 'assets/maps/valleys/Wadi_Ranyah.geojson', color: const Color(0xFFCB53DB), nameAr: 'وادي رنية', length: 350.0),
    'Wadi_Rash': (path: 'assets/maps/valleys/Wadi_Rash.geojson', color: const Color(0xFFDB53BC), nameAr: 'وادي رش', length: 95.0),
    'Wadi_Shuwayhat': (path: 'assets/maps/valleys/Wadi_Shuwayhat.geojson', color: const Color(0xFFDB538E), nameAr: 'وادي شويحط', length: 70.0),
    'Wadi_Tabalah': (path: 'assets/maps/valleys/Wadi_Tabalah.geojson', color: const Color(0xFF8EDB53), nameAr: 'وادي تبالة', length: 180.0),
    'Wadi_Tathlith': (path: 'assets/maps/valleys/Wadi_Tathlith.geojson', color: const Color(0xFFDB8E53), nameAr: 'وادي تثليث', length: 650.0),
    'Wadi_Tayyah': (path: 'assets/maps/valleys/Wadi_Tayyah.geojson', color: const Color(0xFF53DBAA), nameAr: 'وادي تية', length: 75.0),
    'Wadi_Turbah': (path: 'assets/maps/valleys/Wadi_Turbah.geojson', color: const Color(0xFF5367DB), nameAr: 'وادي تربة', length: 400.0),
    'Wadi_Yiba': (path: 'assets/maps/valleys/Wadi_Yiba.geojson', color: const Color(0xFFC753DB), nameAr: 'وادي يبة', length: 150.0),
  };

  final Map<String, ({String nameAr, String desc})> _mainFormations = {
    'saq': (
      nameAr: 'تكوين الساق',
      desc: 'يمتد تكوين الساق من جنوب الأردن عبر منطقة تبوك وحائل والقصيم حتى قرب الزلفي، ويتكون أساساً من الحجر الرملي المسامي عالي النفاذية ويعد من أهم الخزانات الجوفية العميقة العذبة في المملكة ويستغل بشكل واسع في المشاريع الزراعية والبلدية.'
    ),
    'wajid': (
      nameAr: 'تكوين الوجيد',
      desc: 'ينكشف تكوين الوجيد في جنوب وجنوب غرب المملكة (وادي الدواسر، نجران، الربع الخالي) ويتكون من الحجر الرملي القاري والبحري ويتميز باحتياطيات مائية هائلة ذات نوعية ممتازة ويعتبر المصدر الرئيسي للمياه في المناطق الجنوبية.'
    ),
    'tabuk': (
      nameAr: 'تكوين تبوك',
      desc: 'يمتد تكوين تبوك في شمال غرب وشمال المملكة من الأردن حتى منطقة القصيم ويتألف من تتابعات من صخور الحجر الرملي والغرين والصلصال، ويعتبر من الخزانات الإنتاجية الهامة للمياه الجوفية.'
    ),
    'minjur': (
      nameAr: 'تكوين المنجور',
      desc: 'ينكشف في وسط المملكة بمحاذاة جبال طويق ويتكون من الحجر الرملي الفتاتي الخشن، وهو خزان مياه جوفية عميق هام جداً يغذي منطقة الرياض والمحافظات المجاورة بمياه صالحة بعد المعالجة.'
    ),
    'wasii': (
      nameAr: 'تكوين الوسيع',
      desc: 'تكوين رملي طباشيري يمتد لمسافات شاسعة عبر وسط وشرق المملكة، ويعد من أغنى الخزانات الجوفية بالمياه في وسط وشرق البلاد ويدعم إمدادات المياه لمنطقة الرياض والمنطقة الشرقية.'
    ),
    'radmaa': (
      nameAr: 'تكوين أم الرضمة',
      desc: 'تكوين جيري ودولوميتي بحري من العصر الباليوسيني يمتد عبر المنطقة الشرقية والحدود الشمالية، ويتميز بنفاذية كربوناتية كارستية عالية وإنتاجية وفيرة لمشاريع الري والصناعة.'
    ),
    'dammam': (
      nameAr: 'تكوين الدمام',
      desc: 'تكوين جيري إيوسيني يغطي مساحات واسعة في شرق المملكة ويحتوي على طبقات مياه جوفية رئيسية تستغل في الواحات والمناطق الزراعية والساحلية في الأحساء والقطيف والدمام.'
    ),
    'neojen': (
      nameAr: 'تكوين النيوجين',
      desc: 'مجموعة تكاوين فتاتية وكربوناتية حديثة تشمل تكاوين الهفوف والدام والغار، وتعتبر من أهم الخزانات الضحلة في شرق المملكة ذات التغذية المباشرة وتغذي واحات الأحساء والساحل الشرقي.'
    ),
  };

  final Map<String, ({String nameAr, String desc})> _subFormations = {
    'jilh': (
      nameAr: 'تكوين الجله',
      desc: 'تكوين ترياسي يتكون من الحجر الرملي والجبس والدولوميت، يحتوي على مياه متوسطة الملوحة تستغل في بعض المناطق الزراعية في وسط المملكة.'
    ),
    'darmaa': (
      nameAr: 'تكوين ضرما',
      desc: 'تكوين جوراسي من الحجر الرملي والجيري والصلصال، يضم طبقات مائية محلية هامة في منطقة الرياض والمحافظات الغربية المحيطة بها.'
    ),
    'khuf': (
      nameAr: 'تكوين الخف',
      desc: 'تكوين برمي كربوناتي ومتبخراتي يمتد في باطن الأرض في وسط وشرق المملكة، ويحتوي على مياه عميقة مالحة إلى متوسطة الملوحة ومكامن غاز هيدروكربونية عملاقة.'
    ),
    'joof': (
      nameAr: 'تكوين الجوف',
      desc: 'تكوين ديفوني من الحجر الرملي والجيري في شمال المملكة (منطقة الجوف)، ويعد مصدراً مائياً هاماً للزراعة في حوض الجوف وسكاكا.'
    ),
    'biyadh': (
      nameAr: 'تكوين البياض',
      desc: 'أحجار رملية طباشيرية تقع أسفل تكوين الوسيع وتتكامل معه هيدرولوجياً كخزان مائي عظيم الإنتاجية في وسط وشرق المملكة.'
    ),
    'skaka': (
      nameAr: 'تكوين سكاكا',
      desc: 'أحجار رملية طباشيرية تعلو تكوين الجوف في منطقة سكاكا بالجوف وتمتاز بمياه عذبة جيدة الاستغلال للأغراض الزراعية والبلدية.'
    ),
    'aruma': (
      nameAr: 'تكوين العرمه',
      desc: 'يتبع هذا التكوين العصر الكريتاوي العلوي ويوجد تحت تكوين أم رضه وفوق الوسيع. ينكشف لمسافة 1600 كم من وادي الدواسر جنوباً حتى الحدود العراقية، ويتكون من الدلوميت والطفل مع بعض حجر الرمل ويصل سمكه إلى 142 م. ويعتبر من التكاوين الجيدة وهو على اتصال بتكوين أم رضمه ولكنه أقل أهمية منه. مياه العرمة جيدة وتستغل في منطقة حفر الباطن وفي أجزاء من المنطقة الشرقية وفي رفحة وبدنه وتتراوح ملوحة مياهه بين 850 – 2100 ملجم / لتر.'
    ),
  };

  @override
  void initState() {
    super.initState();
    _loadDams();
  }

  Future<void> _loadDams() async {
    try {
      final String jsonString = await rootBundle.loadString(AppAssets.damsJson);
      final List<dynamic> rawList = jsonDecode(jsonString);

      final List<DamLocation> list = rawList.map((item) {
        return DamLocation(
          name: item['name']?.toString() ?? '',
          gov: item['gov']?.toString() ?? '',
          region: item['region']?.toString() ?? '',
          type: item['type']?.toString() ?? '',
          length: (item['length'] as num?)?.toDouble() ?? 0.0,
          height: (item['height'] as num?)?.toDouble() ?? 0.0,
          crestHeight: (item['crest'] as num?)?.toDouble() ?? 0.0,
          capacity: (item['cap'] as num?)?.toDouble() ?? 0.0,
          theDate: item['theDate']?.toString() ?? '',
          latitude: (item['lat'] as num?)?.toDouble() ?? 0.0,
          longitude: (item['lon'] as num?)?.toDouble() ?? 0.0,
        );
      }).toList();

      if (mounted) {
        setState(() {
          _dams = list;
        });
      }
    } catch (_) {}
  }

  Future<void> _showDamsOnMap() async {
    if (_mapController?.pointAnnotationManager == null) return;
    final manager = _mapController!.pointAnnotationManager!;
    await manager.deleteAll();
    _annotationDamMap.clear();

    try {
      final ByteData byteData = await rootBundle.load(AppAssets.droplet);
      final Uint8List imageBytes = byteData.buffer.asUint8List();

      final validDams = _dams.where((d) => d.latitude > 0 && d.longitude > 0).toList();
      final optionsList = validDams.map((dam) {
        return PointAnnotationOptions(
          geometry: Point(coordinates: Position(dam.longitude, dam.latitude)),
          image: imageBytes,
          iconSize: 0.25,
        );
      }).toList();

      final annotations = await manager.createMulti(optionsList);
      for (int i = 0; i < annotations.length && i < validDams.length; i++) {
        final ann = annotations[i];
        if (ann != null) {
          _annotationDamMap[ann.id] = validDams[i];
        }
      }

      manager.addOnPointAnnotationClickListener(
        AppPointAnnotationClickListener((annotation) {
          final dam = _annotationDamMap[annotation.id];
          if (dam != null) {
            _showDamPopup(dam);
          }
        }),
      );

      _mapController?.flyTo(latitude: 20.275332, longitude: 41.438495, zoom: 6.3);
    } catch (e) {
      debugPrint('Error creating dam annotations: $e');
    }
  }

  void _showDamPopup(DamLocation dam) {
    if (_mapController != null) {
      _mapController!.flyTo(
        latitude: dam.latitude,
        longitude: dam.longitude,
        zoom: 10.0,
      );
    }
    final theCapacity = dam.capacity.toStringAsFixed(0);
    AppPopupDialog.show(
      context,
      title: dam.name,
      description: 'اسم السد: ${dam.name}\n'
          'الموقع: ${dam.gov}\n'
          'المحافظة: ${dam.region}\n'
          'ارتفاع السد: ${dam.height} متر \n'
          'طول السد: ${dam.length.toInt()} متر \n'
          'سعة السد: $theCapacity متر مكعب \n'
          'نوع السد: ${dam.type}\n'
          'انشاء السد: ${dam.theDate}',
    );
  }

  Future<void> _selectValley(String valleyKey) async {
    final valley = _valleys[valleyKey];
    if (valley == null) return;

    setState(() => _isLoading = true);
    try {
      final jsonStr = await rootBundle.loadString(valley.path);
      final data = json.decode(jsonStr);

      double lat = 24.694291;
      double lon = 47.189224;
      double lengthKm = valley.length;

      if (data is Map && data.containsKey('features')) {
        final features = data['features'] as List;
        for (final f in features) {
          final props = f['properties'];
          if (props != null && props['length'] != null) {
            lengthKm = double.tryParse(props['length'].toString()) ?? valley.length;
          }
          final geom = f['geometry'];
          if (geom != null) {
            final coords = geom['coordinates'];
            if (coords is List && coords.isNotEmpty) {
              final first = coords.first;
              if (first is List && first.length >= 2) {
                if (first[0] is num && first[1] is num) {
                  lon = (first[0] as num).toDouble();
                  lat = (first[1] as num).toDouble();
                } else if (first[0] is List) {
                  final pt = first[0] as List;
                  lon = (pt[0] as num).toDouble();
                  lat = (pt[1] as num).toDouble();
                }
              }
            }
          }
        }
      }

      setState(() => _isLoading = false);

      if (_mapController != null) {
        _mapController!.flyTo(latitude: lat, longitude: lon, zoom: 8.5);
      }

      AppPopupDialog.show(
        context,
        title: valley.nameAr,
        description: 'الأسم: ${valley.nameAr}\nالطول: $lengthKm كم',
      );
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  void _showFormationPopup(String key, String title, String desc) {
    final styleAsset = 'assets/maps/water_formation/$key.json';
    _mapController?.setStyleFromAsset(styleAsset);
    _mapController?.flyTo(latitude: 25.0, longitude: 44.0, zoom: 5.5);

    AppPopupDialog.show(
      context,
      title: title,
      description: desc,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'مصادر المياه',
      onBriefPressed: () => WaterInfographicDialog.show(context),
      briefButtonText: 'مقدمة ',
      initialStyleAsset: 'assets/maps/water_formation/allformations.json',
      isLoading: _isLoading,
      onMapCreated: (controller) => _mapController = controller,
      sidebarContent: Column(
        children: [
          // Button 1: الأودية الرئيسية
          CustomButton(
            text: 'الأودية الرئيسية',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                _valleysExpanded = !_valleysExpanded;
                if (_valleysExpanded) {
                  _damsExpanded = false;
                  _mainFormationsExpanded = false;
                  _subFormationsExpanded = false;
                }
              });
            },
          ),

          if (_valleysExpanded)
            ..._valleys.entries.map(
              (v) => CustomButton(
                text: v.value.nameAr,
                styleType: ButtonStyleType.subMenu,
                onPressed: () => _selectValley(v.key),
              ),
            ),

          // Button 2: سدود الشرب
          CustomButton(
            text: 'سدود الشرب',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                _damsExpanded = !_damsExpanded;
                if (_damsExpanded) {
                  _valleysExpanded = false;
                  _mainFormationsExpanded = false;
                  _subFormationsExpanded = false;
                  _showDamsOnMap();
                } else {
                  _mapController?.pointAnnotationManager?.deleteAll();
                }
              });
            },
          ),

          if (_damsExpanded)
            ..._dams.map(
              (dam) => CustomButton(
                text: dam.name,
                styleType: ButtonStyleType.subMenu,
                onPressed: () => _showDamPopup(dam),
              ),
            ),

          // Button 3: التكوينات الرئيسية
          CustomButton(
            text: 'التكوينات الرئيسية',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                _mainFormationsExpanded = !_mainFormationsExpanded;
                if (_mainFormationsExpanded) {
                  _valleysExpanded = false;
                  _damsExpanded = false;
                  _subFormationsExpanded = false;
                }
              });
            },
          ),

          if (_mainFormationsExpanded)
            ..._mainFormations.entries.map(
              (f) => CustomButton(
                text: f.value.nameAr,
                styleType: ButtonStyleType.subMenu,
                onPressed: () => _showFormationPopup(f.key, f.value.nameAr, f.value.desc),
              ),
            ),

          // Button 4: التكوينات الفرعية
          CustomButton(
            text: 'التكوينات الفرعية',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                _subFormationsExpanded = !_subFormationsExpanded;
                if (_subFormationsExpanded) {
                  _valleysExpanded = false;
                  _damsExpanded = false;
                  _mainFormationsExpanded = false;
                }
              });
            },
          ),

          if (_subFormationsExpanded)
            ..._subFormations.entries.map(
              (f) => CustomButton(
                text: f.value.nameAr,
                styleType: ButtonStyleType.subMenu,
                onPressed: () => _showFormationPopup(f.key, f.value.nameAr, f.value.desc),
              ),
            ),
        ],
      ),
    );
  }
}
