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
import '../../core/dialogs/pdf_viewer_dialog.dart';

class FieldLocation {
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final bool isGas;

  const FieldLocation({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
    this.isGas = false,
  });
}

class OilGasScreen extends StatefulWidget {
  const OilGasScreen({super.key});

  @override
  State<OilGasScreen> createState() => _OilGasScreenState();
}

class _OilGasScreenState extends State<OilGasScreen> {
  MapShellController? _mapController;
  bool _oilExpanded = true;
  bool _gasExpanded = false;
  final Map<String, FieldLocation> _annotationFieldMap = {};

  final List<FieldLocation> _oilFields = const [
    FieldLocation(
      latitude: 25.141366,
      longitude: 49.557756,
      title: 'حقل الغوار',
      isGas: false,
      description:
          'جاءت تسمية الحقل بالغوّار من الكلمة العربية )غَارَ( التي تعني شديد العمق، أو البعيد في باطن الأرض.\n'
          'حقل نفط سعودي في محافظة الأحساء، بالمنطقة الشرقية ويبلغ قياس أبعاده 280 كم في 30 كم، وهو أكبر حقل نفط تقليدي في العالم حيث يصل احتياط النفط فيه إلى حوالي 5 مليار طن، بينما يبلغ متوسط عمق الحفرة التي يستخرج منها النفط فيه إلى حوالي 33 متر. أكتشف عام 1948م. صخور المصدر هي تكوين حنيفة الجوراسي. صخور المكمن أحجار جيرية من العصر الجوراسي، قُسّم الغوار إلى خمس مناطق إنتاج، من الشمال إلى الجنوب: عين دار وشدقم والعثمانية والحوية وحرض. يحتوي الجزء الشمالي على نفط خفيف الكثافة، ويصل طبقات هذا الجزء إلى حوالي 49 متر، أما القسم الجنوبي، فكلما تقدمنا نحو الجنوب كلما كان النفط أقل كثافةً، وطبقاته أرقّ.',
    ),
    FieldLocation(
      latitude: 25.069444,
      longitude: 48.195000,
      title: 'حقل خريص',
      isGas: false,
      description:
          'حقل خريص يبعد 150 كم شمال شرق الرياض . بطول 127 كم. أكتشف عام 1957م. صخور المصدر هي تكوين القصيبة. صخور المكمن أحجار جيرية من العصر الجوراسي. ينتج هذا الحقل 1.2 مليون برميل يومياً',
    ),
    FieldLocation(
      latitude: 24.357939,
      longitude: 50.876248,
      title: 'حقل اللغفة',
      isGas: false,
      description:
          'يبعد هذا الحقل 500 كم جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار جيرية من العصر الجوراسي) وصخور المصدر من صخور الحنيفة وجبل طويق (أحجار جيرية من العصر الجوراسي).',
    ),
    FieldLocation(
      latitude: 24.300065,
      longitude: 50.824400,
      title: 'حقل الجوب',
      isGas: false,
      description:
          'يبعد هذا الحقل 500 كم من جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار جيرية من العصر الجوراسي) و صخور المصدر من صخور الحنيفة و جبل طويق (أحجار جيرية من العصر الجوراسي).',
    ),
    FieldLocation(
      latitude: 22.743470,
      longitude: 52.637144,
      title: 'حقل الشطفة',
      isGas: false,
      description:
          'يقع الحقل في صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. صخور المكمن من الشعيبة (أحجار جيرية من العصر الجوراسي). صخور متكون الوسيع هي الصخور الحاجزة ( Seal ).',
    ),
    FieldLocation(
      latitude: 22.477833,
      longitude: 54.843267,
      title: 'حقل الشيبة',
      isGas: false,
      description:
          'يقع الحقل شرقي صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. أكتشف عام 1968م. في عام 1998 بدأت شركة أرامكو إنتاج البترول. يمكن أن يضخ حقل الشيبة مليون وثلاث مائة ألف برميل يوميًا لمدة 70 عامًا. صخور المكمن من الشعيبة (أحجار جيرية من العصر الجوراسي). صخور متكون الوسيع هي الصخور الحاجزة (Seal ).',
    ),
    FieldLocation(
      latitude: 22.252042,
      longitude: 54.093359,
      title: 'حقل الرملة',
      isGas: false,
      description:
          'يقع الحقل شرقي صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. أكتشف عام 1974م. صخور المكمن أحجار جيرية من العصر الجوراسي. صخور متكون الوسيع هي الصخور الحاجزة ( Seal )',
    ),
    FieldLocation(
      latitude: 23.808800,
      longitude: 46.873320,
      title: 'حقل الحوطة',
      isGas: false,
      description:
          'يقع الحقل شرقي صحراء الربع الخالي ويبعد 180 كم جنوب الرياض. أكتشف عام 1988م . صخور المكمن من متكون عنيزة (أحجار رملية من العمر الكربوني البيرمي). يتكون الحقل من زيت عربي خفيف ممتاز وقد بلغ الإنتاج الاختباري للبئر الأول 8 آلاف برميل يوميًا عند اكتشافه بينما ينتج حاليًا 200 ألف برميل، وكثافته 49.9 درجة على حسب مقياس معهد البترول الأمريكي.',
    ),
    FieldLocation(
      latitude: 25.936694,
      longitude: 49.602634,
      title: 'حقل بقيق',
      isGas: false,
      description:
          'حقل نفط سعودي في محافظة الأحساء، بالمنطقة الشرقية. أكتشف عام 1940م. صخور المصدر هي تكوين حنيفة الجوراسي. صخور المكمن أحجار جيرية من العصر الجوراسي. يحتوي حقل بقيق على معمل لمعالجة الزيت الخام، ومعمل لمعالجة الغاز الطبيعي. ومعامل توليد الطاقة الكهربائية، وإنتاج البخار وتحلية المياه. ومعامل ضخ الزيت وتنقية وضغط الهواء. يمثّل إنتاج معامل حقل بقيق نحو 6% من إجمالي استهلاك المشتقات النفطية العالمي، في حين يُقدّر إجمالي الاحتياطيات المؤكدة في الحقل بنحو 22.5 مليار برميل. يحظى حقل بقيق بأهمية خاصة على المستوى الدولي، إذ إنه يربط بين السعودية والبحرين من خلال خط أنابيب تأسس عام 1945 بطول 110 كيلومترات، كما تبلغ سعته الإجمالية 350 ألف برميل من النفط الخام يوميًا.',
    ),
    FieldLocation(
      latitude: 28.211935,
      longitude: 48.751281,
      title: 'حقل السفانية',
      isGas: false,
      description:
          'يقع حقل السفانية في مياه الخليج العربي على بعد نحو 265 كيلومترا شمال مقر شركة أرامكو في الظهران. وهو أكبر حقل نفطي مغمور تحت الماء في العالم، تصل مساحته إلى 50 كيلو مترا طولا و15 كيلو مترا عرضا. أكتشف عام 1951 م. صخور المكمن من متكون السفانية (أحجار رملية من العصر الكريتاسي) وصخور المصدر من متكون جبل طويق من العصر الجوراسي. يعتبر ثالث أكبر حقل نفط في العالم من حيث الإنتاج، حيث ينتج حوالي 1.5 مليون برميل في اليوم.',
    ),
    FieldLocation(
      latitude: 27.704328,
      longitude: 48.875146,
      title: 'حقل منيفة',
      isGas: false,
      description:
          'حقل منيفة هو حقل نفط مغمور، وخامس أكبر حقول النفط في العالم. وأحد أقدم الحقول البحرية النفطية. يقع في المياه الإقليمية للمملكة العربية السعودية على الخليج العربي، على بعد قرابة 110 كلم شمال مدينة الظهران. أكتشف عام 1957 م. صخور المكمن من متكون منيفة (أحجار جيرية من العصر الجوراسي). تصل مساحة الحقل المكون من 6 مكامن، إلى نحو 45 كيلومترًا طولاً، و18 كيلومترًا عرضًا. تصل طاقة حقل منيفة الإنتاجية بعد تطويره إلى 900 ألف برميل من الزيت العربي الثقيل يوميًا.',
    ),
    FieldLocation(
      latitude: 27.704328,
      longitude: 49.603264,
      title: 'حقل البري',
      isGas: false,
      description:
          'حقل البري هو حقل نفطي تديره شركة أرامكو السعودية، يقع جنوب محافظة الجبيل نتج الحقل 250 ألف برميل من النفط الخام العربي الخفيف يوميًا. ويتكون الحقل من منطقتين إحداهما على اليابسة والأخرى على البحر. صخور المكمن من متكون الحنيفة (أحجار جيرية من العصر الجوراسي). يبلغ حجم احتياطي النفط العربي الخام فيه ما يزيد عن 15 مليار برميل.',
    ),
  ];

  final List<FieldLocation> _gasFields = const [
    FieldLocation(
      latitude: 28.181080,
      longitude: 34.858831,
      title: 'حقل مدين',
      isGas: true,
      description:
          'حقل غاز طبيعي يقع في رأس الشيخ حميد ويبعد حوالي 200 كيلومتر عن منطقة تبوك. أكتشف عام 1990م.يعتمد الحقل على عملية الإنتاج للغاز غير المصاحب. ',
    ),
    FieldLocation(
      latitude: 28.181080,
      longitude: 34.858831,
      title: 'حقل برقان',
      isGas: true,
      description:
          'يقع الحقل في الشمال الغربي من البحر الأحمر ويبعد عن تبوك 150 كلم. أكتشف عام 1969م. المكمن من صخور متكون البرقان (أحجار رملية من عصر الميوسين)',
    ),
    FieldLocation(
      latitude: 23.439367,
      longitude: 46.722663,
      title: 'حقل الحلوة',
      isGas: true,
      description:
          'يبعد هذا الحقل 140 كم جنوب الرياض  وأكتشف عام 1990م. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون عنيزة (أحجار رملية من العصر البيرمي) وصخور المصدر من صخور القصيبة (أحجار من العصر السليوري)',
    ),
    FieldLocation(
      latitude: 24.105692,
      longitude: 49.020345,
      title: 'حقل شمعة',
      isGas: true,
      description:
          'يبعد هذا الحقل 500 كم جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار رملية من العصر البيرمي) وصخور المصدر من صخور القصيبة من العصر السليوري.',
    ),
    FieldLocation(
      latitude: 22.359301,
      longitude: 53.130374,
      title: 'حقل الكدن الشمالي',
      isGas: true,
      description:
          'يقع الحقل في صحراء الربع الخالي ويبعد 700 كم جنوب شرق الرياض. أكتشف عام 1967م. صخور المكمن من متكون الجلة (أحجار جيرية من العصر الترياسي). ',
    ),
    FieldLocation(
      latitude: 21.826041,
      longitude: 53.135559,
      title: 'حقل الكدن الجنوبي',
      isGas: true,
      description:
          'يقع الحقل شرقي صحراء الربع الخالي ويبعد 750 كم جنوب شرق الرياض. أكتشف عام 1968م.  صخور المكمن من متكون الجلة (أحجار جيرية من العصر الترياسي). ',
    ),
    FieldLocation(
      latitude: 0.0,
      longitude: 0.0,
      title: 'حقل حيران',
      isGas: true,
      description:
          'يقع في منطقة الربع الخالي بالمملكة على مساحة تتجاوز 600 ألف كيلومتر مربع. يتدفق الغاز من مكمن "حنيفة" في بئر (الحيران - 1) بمعدل 30 مليون قدم مكعبة قياسية في اليوم، و 1600 برميلٍ من المكثفات، بالإضافة إلى تدفق الغاز من مكمن "العرب – ج" في الحقل نفسه بمعدل 3.1 مليون قدم مكعبة قياسية في اليوم.',
    ),
    FieldLocation(
      latitude: 0.0,
      longitude: 0.0,
      title: 'حقل الشرفة',
      isGas: true,
      description:
          'مجاور لحقل الحيران في منطقة الربع الخالي، إذ يقع على بُعد 120 كيلومترًا جنوب غرب حقل الشيبة، ويحتوي على بئر واحدة للغاز الطبيعي، وهي "الشرف - 2"، يتدفّق منها الغاز بمعدل 16.9 مليون قدم مكعبة يوميًا، مع 50 برميلًا من المكثفات.',
    ),
    FieldLocation(
      latitude: 21.155611,
      longitude: 52.522044,
      title: 'حقل المحاكيك',
      isGas: true,
      description:
          'يقع حقل المحاكيك للغاز الطبيعي بمنطقة الربع الخالي السعودية، والتي تمتد على مساحة تبلغ نحو 600 ألف كيلومتر مربع . يتدفق الغاز من بئر المحاكيك – 2 بمعدل 0.85 مليون قدم مكعبة قياسية في اليوم.',
    ),
    FieldLocation(
      latitude: 0.0,
      longitude: 0.0,
      title: 'حقل عسيكرة',
      isGas: true,
      description:
          'يقع حقل عسيكرة في مكمن "الجله" في الربع الخالي، يتدفق الغاز بمعدل 46 مليون قدم مكعبة قياسية في اليوم.',
    ),
    FieldLocation(
      latitude: 24.388763,
      longitude: 48.312905,
      title: 'حقل شدون',
      isGas: true,
      description:
          'يقع غرب مركز حرض، حيث اكتُشِف الغاز الطبيعي في مكمن "عنيزة – أ" بعد أن تدفق الغاز بمعدل 15.5 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 460 برميلاً من المكثفات.',
    ),
    FieldLocation(
      latitude: 24.486152,
      longitude: 48.672641,
      title: 'حقل الوضيحي',
      isGas: true,
      description:
          'أكتشف في مكمن "الصارة" حيث تدفق الغاز الطبيعي بمعدل 11.7 مليون قدم مكعبة قياسية في اليوم.',
    ),
    FieldLocation(
      latitude: 24.715138,
      longitude: 48.878095,
      title: 'حقل أوتاد',
      isGas: true,
      description:
          'أكتشف الغاز الطبيعي في مكمن "القصيباء" جنوب غرب مدينة الهفوف، حيث تدفق الغاز بمعدل 5.1 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 57 برميلاً يومياً من المكثفات.',
    ),
    FieldLocation(
      latitude: 24.510276,
      longitude: 48.467188,
      title: 'حقل مزاليج',
      isGas: true,
      description:
          'اكتشاف الغاز الطبيعي في مكمن "عنيزة ب/ج" في حقل "مزاليج" جنوب غرب الظهران، حيث تدفق الغاز بمعدل 14 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 4150 برميلاً يومياً من المكثفات.',
    ),
  ];

  Future<void> _loadMarkers(MapShellController controller) async {
    final List<FieldLocation> allFields = [
      ..._oilFields,
      ..._gasFields,
    ];

    final validFields = allFields
        .where((f) => f.latitude > 0.0 && f.longitude > 0.0)
        .toList();

    if (kIsWeb) {
      final batchList = validFields
          .map((field) => {
                'id': '${field.latitude}_${field.longitude}',
                'lat': field.latitude,
                'lng': field.longitude,
                'iconUrl':
                    'assets/${field.isGas ? AppAssets.gasMarker : AppAssets.oilMarker}',
              })
          .toList();

      final fieldMap = {
        for (final field in validFields)
          '${field.latitude}_${field.longitude}': field
      };

      controller.setWebMarkersBatch(jsonEncode(batchList), (markerId) {
        final field = fieldMap[markerId];
        if (field != null) {
          _selectField(field);
        }
      });
      return;
    }

    final manager = controller.pointAnnotationManager;
    if (manager == null) return;

    try {
      final ByteData oilByteData = await rootBundle.load(AppAssets.oilMarker);
      final Uint8List oilBytes = oilByteData.buffer.asUint8List();

      final ByteData gasByteData = await rootBundle.load(AppAssets.gasMarker);
      final Uint8List gasBytes = gasByteData.buffer.asUint8List();

      final List<PointAnnotationOptions> optionsList = [];

      for (final field in allFields) {
        if (field.latitude > 0 && field.longitude > 0) {
          final imageBytes = field.isGas ? gasBytes : oilBytes;
          optionsList.add(
            PointAnnotationOptions(
              geometry:
                  Point(coordinates: Position(field.longitude, field.latitude)),
              image: imageBytes,
              iconSize: 0.3,
            ),
          );
        }
      }

      final annotations = await manager.createMulti(optionsList);
      for (int i = 0; i < annotations.length && i < validFields.length; i++) {
        final ann = annotations[i];
        if (ann != null) {
          _annotationFieldMap[ann.id] = validFields[i];
        }
      }

      manager.addOnPointAnnotationClickListener(
        AppPointAnnotationClickListener((annotation) {
          final field = _annotationFieldMap[annotation.id];
          if (field != null) {
            _selectField(field);
          }
        }),
      );
    } catch (e) {
      debugPrint('Error creating oil/gas annotations: $e');
    }
  }

  void _selectField(FieldLocation field) {
    if (field.latitude > 0.0 &&
        field.longitude > 0.0 &&
        _mapController != null) {
      _mapController!.flyTo(
        latitude: field.latitude,
        longitude: field.longitude,
        zoom: 10.0,
      );
    }

    AppPopupDialog.show(
      context,
      title: field.title,
      description: field.description,
    );
  }

  void _showIntroBrief() {
    AppBriefDialog.show(
      context,
      title: 'حقول البترول والغاز',
      bannerAsset: AppAssets.oilBrief,
      description:
          'يتكون النفط والغاز في باطن الأرض بنفس الظروف الطبيعية، وعادةً ما يتواجدان في حقلٍ واحدٍ، إلا أنه يمكن إيجاد حقول للغاز منفردة، والفرق بين تكوين النفط والغاز الطبيعي هو الاختلاف في تعرضهما لدرجة حرارة، فالنفط عادة ما يكون على عمق 1000 م إلى 6000 م أما إذا تكوّن النفط على عمق أكبر فإن درجة الحرارة التي يتعرض لها تكون أكبر فهنا يتحول النفط إلى غاز، وكلما زاد عمق تكوّن النفط كلّما تحوّل إلى غاز أكثر نقاءً إذ يكون من نوع الغاز الجاف الذي تنخفض به المواد العالقة، فبعد تكوّنه غازاً يبدأ بالتسرّب إلى طبقات القشرة الأرضية، وعند اصطدامه بطبقة صخرية قاسية قليلة المسامية تعمل على منع تسربه فإنّه ينحبس في هذه المصائد. وحيث أن البترول و الغاز الطبيعي كلاهما أخف من الماء و أقل كثافة من الصخور المحيطة فإنهما ينتقلان لأعلى عبر القشرة الأرضية لمسافات طويلة أحياناً و في النهاية تُـحبس بعض هذه المواد الهيدروكربونية المنتقلة لأعلى في طبقة لا مسامية (غير منفذة للماء) من الصخور تُعرف بـ صخور الغطاء (Cap Rock).. ولأن الغاز الطبيعي أخف من البترول فيقوم بتكوين طبقة فوق البترول تسمى غطاء الغاز  (Gas Cap)  ولا بد أن يصاحب البترول غاز يسمى بـ الغاز المصاحِب ” APG “ وهو شكل من أشكال الغاز الطبيعي ويوجد مع مستودعات النفط ويكون إما مذوب في النفط أو كقبة غازية فوق النفط في المستودع.\n\n'
          'يمر النفط بمراحل عدة خلال تكونه وهي: المرحلة الأولى: كانت المسطحات المائية من بحارٍ ومحيطاتٍ غنيةٍ بالطحالب والأحياء البحرية الدقيقة فعند موتها ترسبت هذه المواد في أسفل البحار، ومع مرور الزمن تكوّنت فوقها طبقة رسوبية سميكة مما عرّض هذه المواد إلى الضغط الشديد، وهذا الضغط تسبّب بارتفاع درجة حرارتها، فتحللت هذه المواد لتصبح مواد سائلةً ترتفع بها نسبة الكربون (هيدروكربونية). المرحلة الثانية: مرحلة هجرة المواد السائلة من مناطق تكوّنها، إذ تكون واقعةً تحت ضغطٍ شديدٍ، فتتسرّب إلى مناطق أقل ضغطاً عبر مسامات وشقوق وكسور الصخور المحيطة فيها ويكون هذا التسرب إما تسرباً لأفقياً وإما تسرباً عمودياً. المرحلة الثالثة: وهي مرحلة تجمع السائل المتسرّب، فيتجمع هذا السائل في طبقات الصخور الرسوبية إذ تعمل هذه الطبقة على امتصاصه بسبب وجود الفراغات أو المسامات بين جزيئاتها، فتعمل كقطعة إسفنج تجذب السائل إليها، وعادةً ما تكون هذه الطبقة الصخرية الرسوبية فوق طبقة صخرية ناريةٍ فتمنع تسرّب السائل منها إذ تعمل كحاجزٍ في أسفل الطبقات الرسوبية، وتسمّى هذه الحالة مكامن أو مصيدة النفط، ويختلف العمق الذي تكون فيه هذه المصائد من منطقة إلى أخرى حسب قربه أو بعده عن مكان تكونه وكذلك حسب التركيب الصخري للمنطقة.\n\n'
          'يُعرّف الغاز الطبيعي بأنّه أحد مصادر الطاقة الأحفورية التي تُستخرج من باطن الأرض، ويدخل الغاز الطبيعي في صناعات الوقود والعديد من المواد الكيميائية الأخرى، ويتكون الغاز الطبيعي من بعض المكونات الكيميائية، وأهمّها:\n'
          'غاز الميثان (CH4): وهو المكوّن الأكبر للغاز الطبيعي، غاز شديد الاحتراق ويستخدم في توليد الكهرباء والتطبيقات المنزلية والصناعية.\n'
          'غاز الإيثان (C2H6): ثاني أهم مكّون للغاز الطبيعي، وينتمي إلى سلالة البرافين.\n'
          'غاز البيوتان (C4H10): يدخل في صناعة الغاز كوقود وغازات التبريد.\n'
          'غاز البروبان (C3H8): أحد أهم أنواع الغازات المُكونة للغاز الطبيعي.\n\n'
          'وتماشياً مع رؤية المملكة 2030 ومبادرة السعودية الخضراء، تقود المملكة مزيجاً متكاملاً من حقول الطاقة التقليدية وتطوير تقنيات الطاقة المتجددة والنظيفة كالطاقة الشمسية وطاقة الرياح ومشاريع الهيدروجين الأخضر العالمية.',
    );
  }


  // ----------------------------------------------------
  // Energy Summary PDF Sections (From -oil-gas-تلخيص الطاقة ok.pdf)
  // ----------------------------------------------------
  final List<Map<String, String>> _energyPdfSections = const [
    {
      'title': 'مصادر الطاقة',
      'asset': 'assets/books/energy/01_energy_sources.pdf',
    },
    {
      'title': 'التحديات التي تواجه قطاع الطاقة',
      'asset': 'assets/books/energy/02_energy_challenges.pdf',
    },
    {
      'title': 'الطاقة الشمسية',
      'asset': 'assets/books/energy/03_solar_energy.pdf',
    },
    {
      'title': 'طاقة الرياح',
      'asset': 'assets/books/energy/04_wind_energy.pdf',
    },
    {
      'title': 'الطاقة الحرارية الأرضية',
      'asset': 'assets/books/energy/05_geothermal_energy.pdf',
    },
    {
      'title': 'طاقة الهيدروجين الأخضر',
      'asset': 'assets/books/energy/06_green_hydrogen.pdf',
    },
    {
      'title': 'الطاقة الحيوية',
      'asset': 'assets/books/energy/07_bioenergy.pdf',
    },
    {
      'title': 'طاقة البحار',
      'asset': 'assets/books/energy/08_ocean_energy.pdf',
    },
    {
      'title': 'الطاقة الغير متجددة (الأحفورية)',
      'asset': 'assets/books/energy/09_nonrenewable_energy.pdf',
    },
    {
      'title': 'موارد الطاقة الغير متجددة',
      'asset': 'assets/books/energy/10_nonrenewable_resources.pdf',
    },
    {
      'title': 'النظام النفطي',
      'asset': 'assets/books/energy/11_petroleum_system.pdf',
    },
    {
      'title': 'سلاسل القيم في صناعة النفط',
      'asset': 'assets/books/energy/12_oil_value_chain.pdf',
    },
    {
      'title': 'سلاسل التوريد في النفط والغاز',
      'asset': 'assets/books/energy/13_oil_gas_supply_chain.pdf',
    },
  ];


  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'الطاقة المتجددة وتطبيقاتها',
      onBriefPressed: null,
      initialStyleAsset: 'assets/maps/saudi_geo/sahel.json',
      onMapCreated: (c) {
        _mapController = c;
        _loadMarkers(c);
      },
      sidebarContent: Column(
        children: [
          // 1. Top 13 Energy PDF Section Buttons
          ..._energyPdfSections.map((sec) => CustomButton(
                text: sec['title']!,
                styleType: ButtonStyleType.mainMenu,
                onPressed: () {
                  PdfViewerDialog.show(
                    context,
                    title: sec['title']!,
                    assetPath: sec['asset']!,
                  );
                },
              )),

          // 2. زر مواقع حقول النفط والغاز
          CustomButton(
            text: 'مواقع حقول النفط والغاز',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                _oilExpanded = true;
                _gasExpanded = true;
              });
              _mapController?.flyTo(
                latitude: 24.694291,
                longitude: 47.189224,
                zoom: 4.8,
              );
              if (_mapController != null) {
                _loadMarkers(_mapController!);
              }
            },
          ),


          // 4. Existing Buttons Moved Down
          // زر مقدمة
          CustomButton(
            text: 'مقدمة',
            styleType: ButtonStyleType.mainMenu,
            onPressed: _showIntroBrief,
          ),

          // Button 1: حقول البترول
          CustomButton(
            text: 'حقول البترول',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                _oilExpanded = !_oilExpanded;
              });
              if (_mapController != null) {
                _loadMarkers(_mapController!);
              }
            },
          ),

          // Oil Fields List
          if (_oilExpanded)
            ..._oilFields.map(
              (f) => CustomButton(
                text: f.title,
                styleType: ButtonStyleType.subMenu,
                onPressed: () => _selectField(f),
              ),
            ),

          // Button 2: حقول الغاز
          CustomButton(
            text: 'حقول الغاز',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () {
              setState(() {
                _gasExpanded = !_gasExpanded;
              });
              if (_mapController != null) {
                _loadMarkers(_mapController!);
              }
            },
          ),

          // Gas Fields List
          if (_gasExpanded)
            ..._gasFields.map(
              (f) => CustomButton(
                text: f.title,
                styleType: ButtonStyleType.subMenu,
                onPressed: () => _selectField(f),
              ),
            ),
        ],
      ),
    );
  }
}
