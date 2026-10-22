import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/dialogs/app_brief_dialog.dart';
import '../../core/dialogs/app_popup_dialog.dart';

class EarthquakePoint {
  final double latitude;
  final double longitude;
  final double magnitude;
  final String date;
  final String time;
  final String iconAsset;

  EarthquakePoint({
    required this.latitude,
    required this.longitude,
    required this.magnitude,
    required this.date,
    required this.time,
    required this.iconAsset,
  });
}

class EarthquakeScreen extends StatefulWidget {
  const EarthquakeScreen({super.key});

  @override
  State<EarthquakeScreen> createState() => _EarthquakeScreenState();
}

class _EarthquakeScreenState extends State<EarthquakeScreen> {
  MapShellController? _mapController;
  bool _isLoading = false;
  final Map<String, EarthquakePoint> _annotationEarthquakeMap = {};

  Future<void> _loadEarthquakeData(String dataFile, String iconAsset) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final jsonFile = dataFile.replaceAll('.xlsx', '.json');
      final String jsonString = await rootBundle.loadString('assets/earthquake/$jsonFile');
      final List<dynamic> rawList = jsonDecode(jsonString);

      final List<EarthquakePoint> points = rawList.map((p) {
        return EarthquakePoint(
          latitude: (p['lat'] as num).toDouble(),
          longitude: (p['lon'] as num).toDouble(),
          magnitude: (p['mag'] as num).toDouble(),
          date: p['date']?.toString() ?? '',
          time: p['time']?.toString() ?? '',
          iconAsset: iconAsset,
        );
      }).toList();

      if (kIsWeb && _mapController != null) {
        _mapController!.clearWebMarkers();
        for (final p in points) {
          _mapController!.addWebMarker(
            latitude: p.latitude,
            longitude: p.longitude,
            iconAsset: iconAsset,
            id: '${p.latitude}_${p.longitude}_${p.date}',
            onTap: () {
              AppPopupDialog.show(
                context,
                title: 'زلزال مسجل',
                description: 'قدر الزلزال (Magnitude) : ${p.magnitude}\nالتاريخ: ${p.date}\nالوقت: ${p.time} (GMT)',
              );
            },
          );
        }
      } else if (_mapController?.pointAnnotationManager != null) {
        final manager = _mapController!.pointAnnotationManager!;
        await manager.deleteAll();
        _annotationEarthquakeMap.clear();

        final ByteData byteData = await rootBundle.load(iconAsset);
        final Uint8List imageBytes = byteData.buffer.asUint8List();

        final optionsList = points.map((p) {
          return PointAnnotationOptions(
            geometry: Point(coordinates: Position(p.longitude, p.latitude)),
            image: imageBytes,
            iconSize: 0.3,
          );
        }).toList();

        final annotations = await manager.createMulti(optionsList);
        for (int i = 0; i < annotations.length && i < points.length; i++) {
          final ann = annotations[i];
          if (ann != null) {
            _annotationEarthquakeMap[ann.id] = points[i];
          }
        }

        manager.addOnPointAnnotationClickListener(
          AppPointAnnotationClickListener((annotation) {
            final p = _annotationEarthquakeMap[annotation.id];
            if (p != null) {
              AppPopupDialog.show(
                context,
                title: '',
                description: 'قدر الزلزال (Magnitude) : ${p.magnitude}\nالتاريخ: ${p.date}\nالوقت: ${p.time} (GMT)',
              );
            }
          }),
        );
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      if (points.isNotEmpty && _mapController != null) {
        _mapController!.flyTo(
          latitude: 24.694291,
          longitude: 47.189224,
          zoom: 4.3,
        );
      }
    } catch (e) {
      debugPrint('Error loading earthquake points: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showIntroBrief() {
    AppBriefDialog.show(
      context,
      title: 'قاعدة البيانات الزلزالية',
      bannerAsset: AppAssets.earth,
      description: 'تعتبر الزلازل من الكوارث الطبيعية التي عرفها الإنسان منذ القدم والتي تتسبب عادة في وقوع أعداد كبيرة من الضحايا بالإضافة إلى الخسائر المادية والاقتصادية والاجتماعية الهائلة الناجمة عنها وذلك لأنها تحدث بشكل مفاجئ وسريع وبدون سابق إنذار. الزلازل عبارة عن اهتزازات في القشرة الأرضية تحدث بمشيئة الله ثم بسبب انطلاق وتحرر الطاقة الناتجة عن احتكاك الصخور وتحرك الطبقات الأرضية حول الصدوع الكبيرة، كما تحدث نتيجة لعدة أسباب أخرى منها: الثورات البركانية والاختراق المفاجئ للمواد المنصهرة في باطن الأرض للأجزاء الهشة من القشرة الأرضية، والتفجيرات النووية تحت السطحية وسقوط النيازك كبيرة الحجم على سطح الأرض وانهيارات الكهوف الكبيرة تحت سطح الأرض وإنشاء السدود والبحيرات الصناعية وضح المياه والمخلفات داخل الآبار.\n'
          'تقع شبه الجزيرة العربية في نطاق الصفيحة العربية التي تتحرك نحو الشمال الشرقي والتي تحدها خمسة حدود حركية نشطة م : هي: (1) حد زاجروس التقاربي وهو حد زلزالي نشط نتيجة الاصطدام القاري بين الصفيحة العربية وصفيحة إيران بمعدل 2 سم/ السنة تقريبا ونشوء حزام على امتداد الجزء الغربي من إيران وشمال شرق العراق (2) حد البحر الأحمر التباعدي نتيجة انفصال الصفيحة العربية عن الصفيحة الأفريقية، ويزداد هذا الانفصال باتجاه الجنوب ويصل إلى 12 ملم سنويا، ونتيجة لهذا الانفصال تكون ما يسمى بمثلث عفار النشط Triple Junction))  (3)  حد خليج العقبة والبحر الميت التحولي: وهو أيضا حد زلزالي نشط ويقع خليج العقبة في طرفه الجنوبي ويبلغ طوله 1000 كم، وترتبط حركته بحركة اتساع البحر الأحمر وحركة تصادم الصفائح في جنوب تركيا وإيران، ولذا يعرف نظام هذا الحد بنظام التحول النافذ " Leaky Transform "، وقد تعرض هذا الحد لمراحل تشوه متعددة خلال حقب زمنية متعاقبة ومتزامنة مع مراحل اتساع البحر الأحمر. بدأت الحركة الجانبية الانزلاقية على حد البحر الميت التحولي منذ ما يقارب 20 مليون عام، حيث أشارت الدراسات الجيوفيزيائية والجيولوجية إلى انزلاق الصفيحة العربية لمسافة تزيد على 105 كم بالمقارنة مع صفيحة سيناء. هذا الصدع يتميز بوجود عدد من المنخفضات المنتشرة على طوله. (4) حد سلسلة جبال مكران - خليج عمان التقاربي (5) حد البحر العربي وخليج عدن التحولي والذي يعتبر من أقل الحدود نشاطا.\n'
          'لقد كان الاعتقاد سائداً بأن شبه الجزيرة العربية خالية من أي نشاط زلزالي على مر العصور، ولكن الواقع هو العكس، حيث دلت الدراسات التاريخية والحديثة على أن المنطقة سبق وان تعرضت لبعض الهزات الأرضية والبراكين إن هذا الاعتقاد السائد كان مصدره أولا عدم وجود أجهزة رصد زلزالية في المنطقة علاوة على أن مراكز الهزات في مواقع ذات كثافة سكانية قليلة - والله الحمد - وفي مناطق متباعدة، وهذا بدوره أدى إلى عدم الإحساس بأثرها. على الرغم من قلة النشاط الزلزالي في معظم مناطق المملكة وخاصة الدرع العربي والمسطح العربي إلا أن قربها من المناطق النشطة زلزاليا في إيران وتركيا من ناحية الشمال الشرقي والبحر الأحمر والدرع العربي من جهة الغرب والجنوب الغربي وصدع البحر الميت التحولي شمالا يتطلب دراسة مواقع الزلازل بدقة عالية للاستفادة منها في تحديد مناطق الخطر الزلزالي المحتمل. عموما يتركز النشاط الزلزالي في شبه الجزيرة العربية على امتداد حدود الصفيحة العربية في ثلاث مناطق هي : منطقة خليج العقبة ؛ منطقة جنوب غرب المملكة وجنوب البحر الأحمر واليمن ومنطقة مكة أما وسط شبه الجزيرة العربية وشرقها والدرع العربي فتعتبر اقل المناطق نشاطا.\n'
          'قام مركز الدراسات الزلزالية بجامعة الملك سعود عام 1998 م بإصدار أول قاعدة بيانات زلزالية لشبه الجزيرة العربية والدول المجاورة ( SAED ) واشتملت تلك القاعدة على الأحداث الزلزالية التاريخية والحديثة للفترة من  112- 2023 م بمختلف المقادير الزلزالية والواقعة بين خطى طول 30 - 60 درجة شرقاً وخطى عرض 10 - 35 درجة شمالاً. يجري تحديث قواعد البيانات الزلزالية سنويا بما يستجد من الأحداث الزلزالية. وفي هذا الإصدار أيضا يمكن توقيع الزلازل إلى أي فترة زمنية معينة يريدها المستخدم وحسب أي قدر زلزالي معين. كما يمكن اختيار أي موقع جغرافي على الخارطة وتحديد الزلازل التي حدثت فيه حسب الاختيارات المطلوبة. يعتبر هذا الإصدار مرجعاً أساسياً للدراسات والبحوث التي يقوم بإعدادها المختصون في مجال الزلازل والهندسة المدنية للاستفادة منه في تحديث معايير كود البناء السعودي وتحديد مكامن الخطورة الزلزالية على مستوى المملكة بالدقة المطلوبة، ووضع مواصفات قياسية للمباني ومدى مقاومتها لأخطار الزلازل، علاوة على دعم الدراسات الجيولوجية والإنشائية والبيئية للمناطق الآهلة بالسكان والمناطق ذات الأهمية الصناعية والاقتصادية.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'قاعدة البيانات الزلزالية',
      onBriefPressed: _showIntroBrief,
      briefButtonText: 'مقدمة',
      initialStyleAsset: 'assets/maps/earthquake/allearth.json',
      isLoading: _isLoading,
      onMapCreated: (c) => _mapController = c,
      sidebarContent: Column(
        children: [
          // Button: الزلازل التاريخية (112م - 1899م)
          CustomButton(
            text: 'الزلازل التاريخية (112م - 1899م)',
            styleType: ButtonStyleType.mainMenu,
            fontSize: 22,
            iconWidget: Image.asset(AppAssets.squareEarth, width: 22, height: 22),
            onPressed: () => _loadEarthquakeData('Histroical.xlsx', AppAssets.squareEarth),
          ),

          // Button: الزلازل الحديثة (1900م - 2023م)
          CustomButton(
            text: 'الزلازل الحديثة (1900م - 2023م)',
            styleType: ButtonStyleType.mainMenu,
            fontSize: 22,
            onPressed: () {
              // Header button matching Android activity_earthquake.xml
            },
          ),

          // Magnitude 4 - 4.99
          CustomButton(
            text: 'زلازل مقدارها 4 - 4.99 درجة',
            styleType: ButtonStyleType.subMenu,
            fontSize: 18,
            iconWidget: Image.asset(AppAssets.smallEarth, width: 22, height: 22),
            onPressed: () => _loadEarthquakeData('4 to 5.xlsx', AppAssets.smallEarth),
          ),

          // Magnitude 5 - 5.99
          CustomButton(
            text: 'زلازل مقدارها 5 - 5.99 درجة',
            styleType: ButtonStyleType.subMenu,
            fontSize: 18,
            iconWidget: Image.asset(AppAssets.mediumEarth, width: 22, height: 22),
            onPressed: () => _loadEarthquakeData('5 to 6.xlsx', AppAssets.mediumEarth),
          ),

          // Magnitude 6 - 6.99
          CustomButton(
            text: 'زلازل مقدارها 6 - 6.99 درجة',
            styleType: ButtonStyleType.subMenu,
            fontSize: 18,
            iconWidget: Image.asset(AppAssets.largEarth, width: 22, height: 22),
            onPressed: () => _loadEarthquakeData('6 to 7.xlsx', AppAssets.largEarth),
          ),

          // Magnitude >= 7.0
          CustomButton(
            text: 'زلازل مقدارها أعلى من 7 درجات',
            styleType: ButtonStyleType.subMenu,
            fontSize: 18,
            iconWidget: Image.asset(AppAssets.extraLargEarth, width: 22, height: 22),
            onPressed: () => _loadEarthquakeData('7 and above.xlsx', AppAssets.extraLargEarth),
          ),
        ],
      ),
    );
  }
}
