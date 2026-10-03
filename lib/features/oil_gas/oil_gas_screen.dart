import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/dialogs/app_brief_dialog.dart';
import '../../core/dialogs/app_popup_dialog.dart';

class FieldLocation {
  final double latitude;
  final double longitude;
  final String title;
  final String description;
  final bool isGas;
  final bool isRenewable;

  const FieldLocation({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
    this.isGas = false,
    this.isRenewable = false,
  });
}

class OilGasScreen extends StatefulWidget {
  const OilGasScreen({super.key});

  @override
  State<OilGasScreen> createState() => _OilGasScreenState();
}

class _OilGasScreenState extends State<OilGasScreen> {
  MapController? _mapController;
  bool _renewableExpanded = true;
  bool _oilExpanded = false;
  bool _gasExpanded = false;

  final List<FieldLocation> _renewableProjects = const [
    FieldLocation(
      latitude: 29.9697,
      longitude: 40.2064,
      title: 'محطة سكاكا للطاقة الشمسية',
      isRenewable: true,
      description: 'أول مشروع ضمن البرنامج الوطني للطاقة المتجددة في المملكة العربية السعودية تحت مظلة رؤية 2030. تبلغ طاقتها الإنتاجية 300 ميجاواط وتغطي مساحة 6 كيلومترات مربعة بمنطقة الجوف، وتكفي لتزويد أكثر من 45 ألف وحدة سكنية بالطاقة النظيفة وتخفيض 500 ألف طن من الانبعاثات الكربونية سنوياً.',
    ),
    FieldLocation(
      latitude: 29.8167,
      longitude: 39.8667,
      title: 'محطة دومة الجندل لطاقة الرياح',
      isRenewable: true,
      description: 'أكبر محطة لتوليد الكهرباء من طاقة الرياح في الشرق الأوسط والأولى من نوعها في المملكة العربية السعودية. تبلغ طاقتها الإنتاجية 400 ميجاواط وتضم 99 توربيناً عملاقاً للرياح بمنطقة الجوف، وتغذي 70 ألف منزل بالطاقة الكهربائية النظيفة وتسهم في خفض انبعاثات الكربون بنحو مليون طن سنوياً.',
    ),
    FieldLocation(
      latitude: 25.5833,
      longitude: 45.6167,
      title: 'محطة سدير للطاقة الشمسية',
      isRenewable: true,
      description: 'واحدة من أكبر محطات الطاقة الشمسية في العالم بتكلفة استثمارية ضخمة وقدرة إنتاجية تصل إلى 1,500 ميجاواط في منطقة الرياض، وتعتمد على أحدث تقنيات الألواح الكهروضوئية ثنائية الوجه وأنظمة التتبع الشمسي لتزويد نحو 185 ألف منزل بالكهرباء النظيفة.',
    ),
    FieldLocation(
      latitude: 28.0000,
      longitude: 35.3000,
      title: 'مشروع نيوم للهيدروجين الأخضر',
      isRenewable: true,
      description: 'أكبر منشأة لإنتاج الهيدروجين الأخضر الخالي من الكربون في العالم بالشراكة بين نيوم وأكوا باور وإير برودكتس. تعتمد كلياً على طاقتي الشمس والرياح لإنتاج 600 طن متري يومياً من الهيدروجين النظيف وتصديره عالمياً على شكل أمونيا خضراء لدعم تحول الطاقة النظيفة.',
    ),
    FieldLocation(
      latitude: 20.6750,
      longitude: 39.5200,
      title: 'محطة الشعيبة للطاقة الشمسية',
      isRenewable: true,
      description: 'مشروع عملاق للطاقة الشمسية الكهروضوئية في منطقة مكة المكرمة بقدرة إجمالية تتجاوز 2,060 ميجاواط، يسهم في تعزيز مزيج الطاقة الأمثل وتوليد الكهرباء المستدامة وتغذية مدن ومشاريع الساحل الغربي.',
    ),
    FieldLocation(
      latitude: 24.4686,
      longitude: 39.6142,
      title: 'الطاقة الحرارية الأرضية (الحرات البركانية)',
      isRenewable: true,
      description: 'استكشاف واستغلال الطاقة الحرارية الأرضية (Geothermal Energy) الكامنة في أعماق الحرات البركانية (مثل حرة رهط وخيبر) بالمنطقة الغربية كمصدر واعد ونظيف ومستدام لتوليد الحمل الأساسي للكهرباء وتحلية المياه الحرارية.',
    ),
  ];

  final List<FieldLocation> _oilFields = const [
    FieldLocation(
      latitude: 25.141366,
      longitude: 49.557756,
      title: 'حقل الغوار',
      isGas: false,
      description: 'جاءت تسمية الحقل بالغوّار من الكلمة العربية )غَارَ( التي تعني شديد العمق، أو البعيد في باطن الأرض.\n'
          'حقل نفط سعودي في محافظة الأحساء، بالمنطقة الشرقية ويبلغ قياس أبعاده 280 كم في 30 كم، وهو أكبر حقل نفط تقليدي في العالم حيث يصل احتياط النفط فيه إلى حوالي 5 مليار طن، بينما يبلغ متوسط عمق الحفرة التي يستخرج منها النفط فيه إلى حوالي 33 متر. أكتشف عام 1948م. صخور المصدر هي تكوين حنيفة الجوراسي. صخور المكمن أحجار جيرية من العصر الجوراسي، قُسّم الغوار إلى خمس مناطق إنتاج، من الشمال إلى الجنوب: عين دار وشدقم والعثمانية والحوية وحرض. يحتوي الجزء الشمالي على نفط خفيف الكثافة، ويصل طبقات هذا الجزء إلى حوالي 49 متر، أما القسم الجنوبي، فكلما تقدمنا نحو الجنوب كلما كان النفط أقل كثافةً، وطبقاته أرقّ.',
    ),
    FieldLocation(
      latitude: 25.069444,
      longitude: 48.195000,
      title: 'حقل خريص',
      isGas: false,
      description: 'حقل خريص يبعد 150 كم شمال شرق الرياض . بطول 127 كم. أكتشف عام 1957م. صخور المصدر هي تكوين القصيبة. صخور المكمن أحجار جيرية من العصر الجوراسي. ينتج هذا الحقل 1.2 مليون برميل يومياً',
    ),
    FieldLocation(
      latitude: 24.357939,
      longitude: 50.876248,
      title: 'حقل اللغفة',
      isGas: false,
      description: 'يبعد هذا الحقل 500 كم جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار جيرية من العصر الجوراسي) وصخور المصدر من صخور الحنيفة وجبل طويق (أحجار جيرية من العصر الجوراسي).',
    ),
    FieldLocation(
      latitude: 24.300065,
      longitude: 50.824400,
      title: 'حقل الجوب',
      isGas: false,
      description: 'يبعد هذا الحقل 500 كم من جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار جيرية من العصر الجوراسي) و صخور المصدر من صخور الحنيفة و جبل طويق (أحجار جيرية من العصر الجوراسي).',
    ),
    FieldLocation(
      latitude: 22.743470,
      longitude: 52.637144,
      title: 'حقل الشطفة',
      isGas: false,
      description: 'يقع الحقل في صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. صخور المكمن من الشعيبة (أحجار جيرية من العصر الجوراسي). صخور متكون الوسيع هي الصخور الحاجزة ( Seal ).',
    ),
    FieldLocation(
      latitude: 22.477833,
      longitude: 54.843267,
      title: 'حقل الشيبة',
      isGas: false,
      description: 'يقع الحقل شرقي صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. أكتشف عام 1968م. في عام 1998 بدأت شركة أرامكو إنتاج البترول. يمكن أن يضخ حقل الشيبة مليون وثلاث مائة ألف برميل يوميًا لمدة 70 عامًا. صخور المكمن من الشعيبة (أحجار جيرية من العصر الجوراسي). صخور متكون الوسيع هي الصخور الحاجزة (Seal ).',
    ),
    FieldLocation(
      latitude: 22.252042,
      longitude: 54.093359,
      title: 'حقل الرملة',
      isGas: false,
      description: 'يقع الحقل شرقي صحراء الربع الخالي ويبعد 800 كم جنوب شرق الرياض. أكتشف عام 1974م. صخور المكمن أحجار جيرية من العصر الجوراسي. صخور متكون الوسيع هي الصخور الحاجزة ( Seal )',
    ),
    FieldLocation(
      latitude: 23.808800,
      longitude: 46.873320,
      title: 'حقل الحوطة',
      isGas: false,
      description: 'يقع الحقل شرقي صحراء الربع الخالي ويبعد 180 كم جنوب الرياض. أكتشف عام 1988م . صخور المكمن من متكون عنيزة (أحجار رملية من العمر الكربوني البيرمي). يتكون الحقل من زيت عربي خفيف ممتاز وقد بلغ الإنتاج الاختباري للبئر الأول 8 آلاف برميل يوميًا عند اكتشافه بينما ينتج حاليًا 200 ألف برميل، وكثافته 49.9 درجة على حسب مقياس معهد البترول الأمريكي.',
    ),
    FieldLocation(
      latitude: 25.936694,
      longitude: 49.602634,
      title: 'حقل بقيق',
      isGas: false,
      description: 'حقل نفط سعودي في محافظة الأحساء، بالمنطقة الشرقية. أكتشف عام 1940م. صخور المصدر هي تكوين حنيفة الجوراسي. صخور المكمن أحجار جيرية من العصر الجوراسي. يحتوي حقل بقيق على معمل لمعالجة الزيت الخام، ومعمل لمعالجة الغاز الطبيعي. ومعامل توليد الطاقة الكهربائية، وإنتاج البخار وتحلية المياه. ومعامل ضخ الزيت وتنقية وضغط الهواء. يمثّل إنتاج معامل حقل بقيق نحو 6% من إجمالي استهلاك المشتقات النفطية العالمي، في حين يُقدّر إجمالي الاحتياطيات المؤكدة في الحقل بنحو 22.5 مليار برميل. يحظى حقل بقيق بأهمية خاصة على المستوى الدولي، إذ إنه يربط بين السعودية والبحرين من خلال خط أنابيب تأسس عام 1945 بطول 110 كيلومترات، كما تبلغ سعته الإجمالية 350 ألف برميل من النفط الخام يوميًا.',
    ),
    FieldLocation(
      latitude: 28.211935,
      longitude: 48.751281,
      title: 'حقل السفانية',
      isGas: false,
      description: 'يقع حقل السفانية في مياه الخليج العربي على بعد نحو 265 كيلومترا شمال مقر شركة أرامكو في الظهران. وهو أكبر حقل نفطي مغمور تحت الماء في العالم، تصل مساحته إلى 50 كيلو مترا طولا و15 كيلو مترا عرضا. أكتشف عام 1951 م. صخور المكمن من متكون السفانية (أحجار رملية من العصر الكريتاسي) وصخور المصدر من متكون جبل طويق من العصر الجوراسي. يعتبر ثالث أكبر حقل نفط في العالم من حيث الإنتاج، حيث ينتج حوالي 1.5 مليون برميل في اليوم.',
    ),
    FieldLocation(
      latitude: 27.704328,
      longitude: 48.875146,
      title: 'حقل منيفة',
      isGas: false,
      description: 'حقل منيفة هو حقل نفط مغمور، وخامس أكبر حقول النفط في العالم. وأحد أقدم الحقول البحرية النفطية. يقع في المياه الإقليمية للمملكة العربية السعودية على الخليج العربي، على بعد قرابة 110 كلم شمال مدينة الظهران. أكتشف عام 1957 م. صخور المكمن من متكون منيفة (أحجار جيرية من العصر الجوراسي). تصل مساحة الحقل المكون من 6 مكامن، إلى نحو 45 كيلومترًا طولاً، و18 كيلومترًا عرضًا. تصل طاقة حقل منيفة الإنتاجية بعد تطويره إلى 900 ألف برميل من الزيت العربي الثقيل يوميًا.',
    ),
    FieldLocation(
      latitude: 27.704328,
      longitude: 49.603264,
      title: 'حقل البري',
      isGas: false,
      description: 'حقل البري هو حقل نفطي تديره شركة أرامكو السعودية، يقع جنوب محافظة الجبيل نتج الحقل 250 ألف برميل من النفط الخام العربي الخفيف يوميًا. ويتكون الحقل من منطقتين إحداهما على اليابسة والأخرى على البحر. صخور المكمن من متكون الحنيفة (أحجار جيرية من العصر الجوراسي). يبلغ حجم احتياطي النفط العربي الخام فيه ما يزيد عن 15 مليار برميل.',
    ),
  ];

  final List<FieldLocation> _gasFields = const [
    FieldLocation(
      latitude: 28.181080,
      longitude: 34.858831,
      title: 'حقل مدين',
      isGas: true,
      description: 'حقل غاز طبيعي يقع في رأس الشيخ حميد ويبعد حوالي 200 كيلومتر عن منطقة تبوك. أكتشف عام 1990م.يعتمد الحقل على عملية الإنتاج للغاز غير المصاحب. ',
    ),
    FieldLocation(
      latitude: 24.105692,
      longitude: 49.020345,
      title: 'حقل شمعة',
      isGas: true,
      description: 'يبعد هذا الحقل 500 كم جنوب شرق الرياض. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون العرب (أحجار رملية من العصر البيرمي) وصخور المصدر من صخور القصيبة من العصر السليوري.',
    ),
    FieldLocation(
      latitude: 23.439367,
      longitude: 46.722663,
      title: 'حقل الحلوة',
      isGas: true,
      description: 'يبعد هذا الحقل 140 كم جنوب الرياض  وأكتشف عام 1990م. النظام التركيبي لهذا الحقل نتج من حركة تكتونية أدت لتراكيب باتجاه شمال -جنوب. المكمن من صخور متكون عنيزة (أحجار رملية من العصر البيرمي) وصخور المصدر من صخور القصيبة (أحجار من العصر السليوري)',
    ),
    FieldLocation(
      latitude: 22.359301,
      longitude: 53.130374,
      title: 'حقل الكدن الشمالي',
      isGas: true,
      description: 'يقع الحقل في صحراء الربع الخالي ويبعد 700 كم جنوب شرق الرياض. أكتشف عام 1967م. صخور المكمن من متكون الجلة (أحجار جيرية من العصر الترياسي). ',
    ),
    FieldLocation(
      latitude: 21.826041,
      longitude: 53.135559,
      title: 'حقل الكدن الجنوبي',
      isGas: true,
      description: 'يقع الحقل شرقي صحراء الربع الخالي ويبعد 750 كم جنوب شرق الرياض. أكتشف عام 1968م.  صخور المكمن من متكون الجلة (أحجار جيرية من العصر الترياسي). ',
    ),
    FieldLocation(
      latitude: 21.155611,
      longitude: 52.522044,
      title: 'حقل المحاكيك',
      isGas: true,
      description: 'يقع حقل المحاكيك للغاز الطبيعي بمنطقة الربع الخالي السعودية، والتي تمتد على مساحة تبلغ نحو 600 ألف كيلومتر مربع . يتدفق الغاز من بئر المحاكيك – 2 بمعدل 0.85 مليون قدم مكعبة قياسية في اليوم.',
    ),
    FieldLocation(
      latitude: 24.388763,
      longitude: 48.312905,
      title: 'حقل شدون',
      isGas: true,
      description: 'يقع غرب مركز حرض، حيث اكتُشِف الغاز الطبيعي في مكمن "عنيزة – أ" بعد أن تدفق الغاز بمعدل 15.5 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 460 برميلاً من المكثفات.',
    ),
    FieldLocation(
      latitude: 24.715138,
      longitude: 48.878095,
      title: 'حقل أوتاد',
      isGas: true,
      description: 'أكتشف الغاز الطبيعي في مكمن "القصيباء" جنوب غرب مدينة الهفوف، حيث تدفق الغاز بمعدل 5.1 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 57 برميلاً يومياً من المكثفات.',
    ),
    FieldLocation(
      latitude: 24.510276,
      longitude: 48.467188,
      title: 'حقل مزاليج',
      isGas: true,
      description: 'اكتشاف الغاز الطبيعي في مكمن "عنيزة ب/ج" في حقل "مزاليج" جنوب غرب الظهران، حيث تدفق الغاز بمعدل 14 مليون قدم مكعبة قياسية في اليوم، مصحوباً بنحو 4150 برميلاً يومياً من المكثفات.',
    ),
  ];

  List<Marker> get _allMarkers {
    final List<Marker> list = [];

    // Renewable Markers
    for (final field in _renewableProjects) {
      if (field.latitude > 0 && field.longitude > 0) {
        list.add(
          Marker(
            point: LatLng(field.latitude, field.longitude),
            width: 36,
            height: 36,
            child: GestureDetector(
              onTap: () => _selectField(field),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1B8E5A),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        );
      }
    }

    // Oil Markers
    for (final field in _oilFields) {
      if (field.latitude > 0 && field.longitude > 0) {
        list.add(
          Marker(
            point: LatLng(field.latitude, field.longitude),
            width: 32,
            height: 32,
            child: GestureDetector(
              onTap: () => _selectField(field),
              child: Image.asset(AppAssets.oilMarker),
            ),
          ),
        );
      }
    }

    // Gas Markers
    for (final field in _gasFields) {
      if (field.latitude > 0 && field.longitude > 0) {
        list.add(
          Marker(
            point: LatLng(field.latitude, field.longitude),
            width: 32,
            height: 32,
            child: GestureDetector(
              onTap: () => _selectField(field),
              child: Image.asset(AppAssets.gasMarker),
            ),
          ),
        );
      }
    }

    return list;
  }

  void _selectField(FieldLocation field) {
    if (field.latitude > 0.0 && field.longitude > 0.0 && _mapController != null) {
      _mapController!.move(LatLng(field.latitude, field.longitude), 9.0);
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
      title: 'الطاقة المتجددة وتقنيات الطاقة في المملكة',
      bannerAsset: AppAssets.oilBrief,
      description: 'تشهد المملكة العربية السعودية تحولاً تاريخياً رائداً في قطاع الطاقة تماشياً مع مستهدفات رؤية المملكة 2030 ومبادرة السعودية الخضراء للوصول إلى الحياد الصفري للانبعاثات الكربونية بحلول عام 2060م.\n\n'
          '1. الطاقة المتجددة والنظيفة:\n'
          'تهدف المملكة إلى الوصول للمزيج الأمثل لإنتاج الكهرباء بنسبة 50% من الطاقة المتجددة (الطاقة الشمسية وطاقة الرياح) وإزاحة الوقود السائل، ويشمل ذلك أضخم المشاريع العالمية مثل محطة سكاكا، محطة دومة الجندل لطاقة الرياح، محطة سدير والشعيبة، وأكبر مجمع لإنتاج الهيدروجين الأخضر في العالم في نيوم.\n\n'
          '2. استكشاف وتطوير مصادر النفط والغاز:\n'
          'تعد المملكة موطناً لأضخم احتياطيات وحقول الهيدروكربونات التقليدية وغير التقليدية في العالم (مثل حقل الغوار، خريص، السفانية، حقل الجافورة للغاز غير التقليدي)، وتطبق أعلى المعايير البيئية وتقنيات احتجاز وتخزين الكربون (CCUS).',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'الطاقة المتجددة و تقنياتها',
      onBriefPressed: _showIntroBrief,
      briefButtonText: 'مقدمة',
      markers: _allMarkers,
      onMapReady: (c) => _mapController = c,
      sidebarContent: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 70),
        child: Column(
          children: [
            // Button 1: مشاريع الطاقة المتجددة
            CustomButton(
              text: 'مشاريع الطاقة المتجددة',
              styleType: ButtonStyleType.mainMenu,
              onPressed: () {
                setState(() {
                  _renewableExpanded = !_renewableExpanded;
                });
              },
            ),

            // Renewable Projects List
            if (_renewableExpanded)
              ..._renewableProjects.map(
                (f) => CustomButton(
                  text: f.title,
                  styleType: ButtonStyleType.subMenu,
                  onPressed: () => _selectField(f),
                ),
              ),

            // Button 2: حقول البترول
            CustomButton(
              text: 'حقول البترول',
              styleType: ButtonStyleType.mainMenu,
              onPressed: () {
                setState(() {
                  _oilExpanded = !_oilExpanded;
                });
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

            // Button 3: حقول الغاز
            CustomButton(
              text: 'حقول الغاز',
              styleType: ButtonStyleType.mainMenu,
              onPressed: () {
                setState(() {
                  _gasExpanded = !_gasExpanded;
                });
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
      ),
    );
  }
}
