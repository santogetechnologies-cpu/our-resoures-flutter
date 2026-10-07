import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/dialogs/app_brief_dialog.dart';
import '../../core/dialogs/app_popup_dialog.dart';

class MaterialLocation {
  final double latitude;
  final double longitude;
  final String nameEn;
  final String nameAr;
  final String region;
  final String locationName;

  MaterialLocation({
    required this.latitude,
    required this.longitude,
    required this.nameEn,
    required this.nameAr,
    required this.region,
    required this.locationName,
  });
}

class MaterialInfoData {
  final String nameAr;
  final String nameEn;
  final String description;
  final String photoAsset;
  final String iconAsset;

  const MaterialInfoData({
    required this.nameAr,
    required this.nameEn,
    required this.description,
    required this.photoAsset,
    required this.iconAsset,
  });
}

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  MapShellController? _mapController;
  List<MaterialLocation> _allLocations = [];
  bool _isLoading = false;
  final Map<String, MaterialLocation> _annotationMaterialMap = {};

  final Map<String, MaterialInfoData> _mineralsData = {
    'Copper': const MaterialInfoData(
      nameAr: 'النحاس Copper',
      nameEn: 'Copper',
      description: 'يتميز النحاس بقدرته العالية على السحب والطرق واللدونة وموصل جيد للكهرباء والحرارة ويعتبر الثاني في الترتيب بالنسبة للتوصيل الحراري بعد معدن الفضة، وأول معدن استخدمه الإنسان قديما في صناعة السهام والسكاكين والأدوات الحربية وأدوات قطع الأشجار. كما يتميز بإمكانية تدوير استعماله مرات عديدة دون أن يفقد خواصه ولأنه معدن غير سام فيمكن تشكيله على البارد والساخن حيث يتم سبك النحاس في قوالب مع عناصر أخرى. له أهمية كبيرة في الصناعات الكيميائية مثل الأغذية والأسمدة والمبيدات وفي الأصباغ والطلاء. تم اكتشاف ما يزيد عن 800 مكمن لخام النحاس وأهمها جبل صايد كذلك تتواجد رواسب جيدة للنحاس في كل من جبل سمران ومنطقة النقرة وحلاحيلة.',
      photoAsset: 'assets/images/copper.jpg',
      iconAsset: 'assets/images/ic_copper.png',
    ),
    'Feldspar': const MaterialInfoData(
      nameAr: 'الفلدسبار Feldspar',
      nameEn: 'Feldspar',
      description: 'الفلدسبار معدن ذو ألوان فاتحة غالبا كالأبيض والوردي والأخضر والبرتقالي أو الرمادي. ويستخدم في العديد من الصناعات أهمها: صناعة الزجاج حيث يعطي قوة ميكانيكية ومقاومة حرارية للزجاج، وصناعة الخزف ويستخدم فيها كعامل مساعد للصهر وفي صناعة مواد الكشط نظرا لقدرته على التكسر ويستخدم أيضا كمواد حشو في صناعة البلاستيك، والدهانات، والمطاط، وصناعة العوازل الكهربائية. ومن أهم مناطق تواجد الفلدسبار في المملكة: منطقة الرويضة غرب الرياض وهو ملائم لصناعة الخزف. منطقة بئر نبط شمال ينبع البحر وهو ملائم لصناعة السيراميك. منطقة بئر سرار شمال مدينة بيشة وهو ملائم لصناعة الخزف و منطقة جبل سودة جنوب مدينة حقل.',
      photoAsset: 'assets/images/feldspar.jpg',
      iconAsset: 'assets/images/ic_feldspar.png',
    ),
    'Gold': const MaterialInfoData(
      nameAr: 'الذهب Gold',
      nameEn: 'Gold',
      description: 'الذهب معدن ثمين رقيق ولين سهل الطرق وخامل وغير نشط كيميائيا، ونقاوته تقاس عالميا بدرجة الصفاء ويتصف بقوة توصيله للحرارة والكهرباء وعدم التحلل ولذلك كان من أفضل المعادن في صناعة المجوهرات والعملات، ويستخدم في أغراض الزينة والزخرفة لدوام بريقه وعدم تأكسده أو تلفه عند تعرضه للهواء أو الماء. يعتبر أكثر المعادن قابلية للطرق وله استعمالات صناعية وكيميائية عديدة حيث يدخل ضمن المواد الكيميائية المستخدمة لأغراض التصوير وكحشوات للأسنان وفي صناعة الترانزستور والمحفزات ومواد اللحام والنقود وأجزاء من الأجهزة الالكترونية والطبية والكهربائية وأجهزة الحاسوب والهواتف الخلوية. تم اكتشاف ما يقارب 1000 مكمن للذهب في المملكة وأهم مناجم الذهب المنتجة في المملكة هي: منجم مهد الذهب ومنجم الأمار ومنجم الصخيبرات ومنجم الحجار.',
      photoAsset: 'assets/images/gold.jpg',
      iconAsset: 'assets/images/ic_gold.png',
    ),
    'Granite': const MaterialInfoData(
      nameAr: 'الجرانيت Granite',
      nameEn: 'Granite',
      description: 'الجرانيت صخر ناري متبلور قابل للقطع والصقل والتلميع ، ويعتبر أهم ما يمكن إضافته إلى المنشآت المعمارية. يتميز بالقدرة على تحمل الخدش والعوامل الجوية الأخرى. ويستخدم الجرانيت في المنشأت في تغطية الواجهات والأرضيات لإكسابها الجمال ويوجد بالمملكة الكثير من مواقع الجرانيت وأهمها: الرويضة بمحافظة القويعية - بر عسكر: شمال غرب نجران ويتميز باللون البني. النجوف: غرب نجران ويتميز باللون الأحمر القرمزي، جبل كور شمال غرب رنية يتميز باللون الأخضر وجبل وردات شمال رنية يتميز باللون الوردي وجبل البكري شمال شرق عفيف يتميز باللون الرمادي. كما يوجد في منطقة مكة المكرمة في الهدا ووادي ليه والجموم وفي منطقة حائل.',
      photoAsset: 'assets/images/granite.jpg',
      iconAsset: 'assets/images/ic_granite.png',
    ),
    'Gypsum': const MaterialInfoData(
      nameAr: 'الجبس Gypsum',
      nameEn: 'Gypsum',
      description: 'الجبس من أكثر المعادن انتشارا في الطبيعة سواء كمعدن أو كصخر رسوبي. ويتواجد في الطبيعة مع الحجر الجيري والطين ويتدرج لونه من الزجاجي الشفاف إلى الأبيض شبه الشفاف إلى الرمادي ومن البني إلى الأحمر. وللجبس استخدامات صناعية عديدة في البناء وبلاط الأسقف، والفواصل. وكذلك يستخدم كعوازل حرارية وكمنظمات لقياس الرطوبة، وفي إنتاج الاسمنت البورتلاندي، ويستخدم الجبس الطبيعي كسماد طبيعي، كما يستخدم في صناعة الزجاج، ويستخدم الجبس الناعم في صناعة الدهانات والصمغ، وفي صناعة حشوات الورق. وأهم مواقع الجبس في المملكة على امتداد ساحل البحر الأحمر من خليج العقبة شمالا إلى جازان جنوبا، وتتركز بين خليج العقبة ومدينة ينبع البحر: منطقة مقنا - شرم محار- شرم حسي، في جبل بوانه شمال شرم محار. منطقة القصب: يتواجد الجبس شمال ينبع البحر. شرم الخور مصدر للجبس الأبيض. كما يتواجد أيضا في منطقة الخرج القريبة من مدينة الرياض وخاصة في السهول الجنوبية وجنوب شرق أشقر مراغة وفي العيون. توجد رواسب الجبس شمال مدينة بريدة. ويتواجد الجبس أيضا بكميات كبيرة في المنطقة الشمالية وكذلك في المنطقة الشرقية بموقع خشم أم حويض على خليج سلوى وفي منطقة عين دار.',
      photoAsset: 'assets/images/gypsum.jpg',
      iconAsset: 'assets/images/ic_gypsum.png',
    ),
    'Iron': const MaterialInfoData(
      nameAr: 'الحديد Iron',
      nameEn: 'Iron',
      description: 'يتميز الحديد بقابليته للسحب والطرق والثني وله خاصية التمغنط، ولونه الأصلي عندما يكون نقيا يميل إلى الفضي وسرعان ما يتغير إلى اللون الأحمر أو البني إذا تعرض للهواء الرطب. الحديد هو المكون الرئيسي لصخور النيازك، ويعد الحديد من أكثر المعادن وأوسعها استعمالا من قبل الإنسان ويرجع ذلك لمميزاته العديدة وخواصه وتوفره في القشرة الأرضية وإمكانية استخلاصه وفصله من الصخور المكونة له. ويعتبر الحديد هو أساس الصناعات وخاصة الصناعة الهيكلية فسبائكه شائعة الاستعمال في جميع الهياكل المعدنية والهندسية البنائية والخراطة والمشغولات ووسائل النقل والمكابس والأربطة الحديدية والمكائن. وتتواجد رواسب الحديد في عدة مواقع أهمها وادي الصواوين جنوب غرب مدينة تبوك وكذلك حديد أدساس جنوب غرب مدينة الرياض، وحديد وادي فاطمة في منطقة الشميسي غرب مكة المكرمة.',
      photoAsset: 'assets/images/iron.jpg',
      iconAsset: 'assets/images/ic_iron.png',
    ),
    'Kyanite': const MaterialInfoData(
      nameAr: 'الكايانيت Kyanite',
      nameEn: 'Kyanite',
      description: 'الكايانيت معدن سيليكاتي لونه أزرق مميز، ويستخدم في صناعة المواد المقاومة للصهر والحرارة العالية، وفي صناعة البورسلين الكهربائي وعوازل شمعات الاشتعال (البواجي)، وأدوات القطع والمكابح. يتواجد في صخور الدرع العربي في وادي مربط وجبل الرقابة وجبل شدا.',
      photoAsset: 'assets/images/kyanite.jpg',
      iconAsset: 'assets/images/ic_kyanite.png',
    ),
    'Limestone': const MaterialInfoData(
      nameAr: 'الحجر الجيري Limestone',
      nameEn: 'Limestone',
      description: 'صخر رسوبي يتكون أساساً من كربونات الكالسيوم. المادة الخام الرئيسية لصناعة الإسمنت، وصهر الحديد، وإنتاج الجير الحي والمطفأ، وصناعة الزجاج، ومواد البناء ورصف الطرق، وتكسية الواجهات. ينتشر في هضاب طويق والخرج والعرمة والمنطقة الشرقية في أكثر من 400 موقع.',
      photoAsset: 'assets/images/limestone.jpg',
      iconAsset: 'assets/images/ic_limestone.png',
    ),
    'Magnesite': const MaterialInfoData(
      nameAr: 'المغنسيت Magnesite',
      nameEn: 'Magnesite',
      description: 'المغنسيت معدن كربونات المغنيسيوم لونه أبيض إلى رمادي، ويعتبر الخام الأساسي لإنتاج المغنيسيا عالية المقاومة للحرارة لتبطين أفران صهر الحديد والفولاذ ومصانع الإسمنت والزجاج، كما يدخل في الصناعات الكيميائية والدوائية والزراعة. يوجد في منجم ضرغط بمنطقة حائل وجبل الرخام جنوب شرق المدينة المنورة وجبل بطران.',
      photoAsset: 'assets/images/magnezite.jpg',
      iconAsset: 'assets/images/ic_magnesite.png',
    ),
    'Marble': const MaterialInfoData(
      nameAr: 'الرخام Marble',
      nameEn: 'Marble',
      description: 'صخر كربوني متحول ذو مظهر جذاب وألوان متنوعة من الأبيض النقي إلى الرمادي والوردي والأسود، يستخدم في تكسية الواجهات والأرضيات والسلالم والتماثيل وأعمال الديكور المعماري الفاخر. يتواجد في جبل فرسان برابغ ومدركة ووادي فاطمة وجبل خانوقة بالبجادية وجبل غزلان بعفيف.',
      photoAsset: 'assets/images/marble.jpg',
      iconAsset: 'assets/images/ic_marble.png',
    ),
    'Nickel': const MaterialInfoData(
      nameAr: 'النيكل Nickel',
      nameEn: 'Nickel',
      description: 'النيكل معدن صلب لامع يتميز بلون أبيض فضي، وموصل للكهرباء والحرارة نسبيا وله القدرة في الاندماج مع غيره من المعادن وتتشابه الصفات الكيميائية للنيكل مع صفات معدن الحديد، لديه قابلية للمغنطة وللطرق والسحب ويمنع الصدأ والتآكل عن المعادن الأخرى. يستخدم بشكل رئيسي في صناعة الفولاذ المقاوم للصدأ (الستانلس ستيل) وبطاريات السيارات الكهربائية. يتواجد في وادي قطن جنوب الدرع العربي وجبل جدير جنوب شرق رنية ووادي كمال شمال ينبع.',
      photoAsset: 'assets/images/nickel.jpg',
      iconAsset: 'assets/images/ic_nickel.png',
    ),
    'Phosphate': const MaterialInfoData(
      nameAr: 'الفوسفات Phosphate',
      nameEn: 'Phosphate',
      description: 'الفوسفات مركب معدني لا يتواجد في الطبيعة في شكله الذاتي حيث أنه سريع التفاعل مع الأوكسجين، وتتباين ألوانه ما بين الداكن إلى الفاتح ويظهر على شكل رواسب فتاتية أو متصلبة. يستعمل الفوسفات في صناعة الأسمدة الفوسفاتية (نحو 77%)، والأعلاف، وحامض الفوسفوريك، ومعالجة المعادن. تم اكتشاف الفوسفات شمال غرب المملكة في منطقة الحدود الشمالية والجوف، وأهم مناطقه: حزم الجلاميد شمال غرب عرعر وأم وعال شرق طريف، مما جعل المملكة من أكبر مصدري الأسمدة الفوسفاتية في العالم.',
      photoAsset: 'assets/images/phosphate.jpg',
      iconAsset: 'assets/images/ic_phosphate.png',
    ),
    'Sandstone': const MaterialInfoData(
      nameAr: 'الحجر الرملي Sandstone',
      nameEn: 'Sandstone',
      description: 'صخر رسوبي يتألف من حبيبات الكوارتز، يستخدم على نطاق واسع كأحجار بناء وزينة وفي رصف الطرق، وتستخدم أنواعه النقية كمصدر للسيليكا في صناعة الزجاج ومواد الصب. ينتشر في تكاوين ساق وتبوك والوجيد في مختلف مناطق المملكة.',
      photoAsset: 'assets/images/sandstone.jpg',
      iconAsset: 'assets/images/ic_sandstone.png',
    ),
    'Bauxite': const MaterialInfoData(
      nameAr: 'البوكسايت Bauxite',
      nameEn: 'Bauxite',
      description: 'البوكسيت هو الخام الطبيعي الأساسي لإنتاج فلز الألمنيوم، ويتكون من هيدروكسيدات الألمنيوم مع كميات متفاوتة من أكاسيد الحديد والسيليكا. يعد البوكسيت من أهم الثروات المعدنية في المملكة، ويستخرج بشكل رئيسي من منجم الزبيرة في منطقة حائل ومنطقة القصيم، حيث ينقل عبر قطار التعدين إلى مدينة رأس الخير للصناعات التعدينية لمعالجته وتحويله إلى ألومينا ومن ثم ألمنيوم نقي.',
      photoAsset: 'assets/images/bauxite.jpg',
      iconAsset: 'assets/images/ic_bauxite.png',
    ),
    'Chromium': const MaterialInfoData(
      nameAr: 'الكروم Chromium',
      nameEn: 'Chromium',
      description: 'معدن فلزي صلب رمادي لامع يضفي على السبائك صلابة فائقة ولمعاناً ومقاومة تامة للتآكل والحرارة. يدخل في صناعة الفولاذ المقاوم للصدأ وطلاء المعادن بالكروم والمواد الحرارية لتبطين الأفران. يتواجد في المملكة في صخور الأفيوليت المعقدة في الدرع العربي مثل منطقة الدوادمي وجبل الصواوين ووادي فاطمة والعيص.',
      photoAsset: 'assets/images/chrome.jpg',
      iconAsset: 'assets/images/ic_chromium.png',
    ),
    'SilicaSand': const MaterialInfoData(
      nameAr: 'رمل السيليكا Silica Sand',
      nameEn: 'SilicaSand',
      description: 'رمال نقية تتكون من معدن الكوارتز بنسبة نقاء تتجاوز 98%. المادة الخام لصناعة الزجاج المسطح والقوارير والزجاج البصري والخلايا الكهروضوئية والسيليكون ورقائق الحواسب، ومواد قوالب الصب ومواد البناء الحديثة. تتواجد في جبل الدغم بالرياض وتكوين وسيع وجبل أدف والمجمعة وتبوك.',
      photoAsset: 'assets/images/silicasand.jpg',
      iconAsset: 'assets/images/ic_silicasand.png',
    ),
    'Silver': const MaterialInfoData(
      nameAr: 'الفضة Silver',
      nameEn: 'Silver',
      description: 'الفضة عنصر كيميائي وفلز انتقالي أبيض لامع، وهو أعلى العناصر توصيلاً للحرارة والكهرباء وأكثرها عكساً للضوء. استخدمت الفضة منذ القدم في صك العملات وصناعة الحلي والأواني، ولها اليوم تطبيقات حيوية في صناعة الألواح الشمسية، والأجهزة الإلكترونية، والسبائك الطبية المعقمة. تتواجد الفضة في المملكة مصاحبة لخامات الذهب والنحاس والزنك في صخور الدرع العربي في مناجم مثل مهد الذهب والأمار وجبل صايد.',
      photoAsset: 'assets/images/silver.jpg',
      iconAsset: 'assets/images/ic_silver.png',
    ),
    'Zinc': const MaterialInfoData(
      nameAr: 'الزنك Zinc',
      nameEn: 'Zinc',
      description: 'معدن فلزي متوسط الصلابة لونه أبيض رمادي مقاوم للتآكل والصدأ، ويستخدم بشكل أساسي في جلفنة الحديد والصلب لحمايته من الصدأ، وفي صناعة البطاريات، وسبائك النحاس الأصفر (البرونز والبراس)، ومستحضرات التجميل والدهانات. تتواجد خامات الزنك في المملكة مصاحبة للنحاس والذهب في مكامن الكبريتيدات الكتلية في صخور الدرع العربي في منجم الحجار، والخنيقية، وجبل صايد.',
      photoAsset: 'assets/images/zinc.jpg',
      iconAsset: 'assets/images/ic_zinc.png',
    ),
    'NephelineSyenite': const MaterialInfoData(
      nameAr: 'النيفلين سينيت Nepheline Syenite',
      nameEn: 'NephelineSyenite',
      description: 'صخر ناري جوفي قلوي عديم الكوارتز يتكون من النيفيلين والفلدسبار، يستخدم في صناعة السيراميك والزجاج كبديل للفلدسبار نظراً لانخفاض درجة انصهاره ونقاوته العالية، كما يستخدم في صناعة الألمنيوم ومواد الحشو. يتواجد في جبل ثهلان وجبل الدومة بالدرع العربي.',
      photoAsset: 'assets/images/nephelinesyenite.jpg',
      iconAsset: 'assets/images/ic_nephelinesyenite.png',
    ),
    'Diatomite': const MaterialInfoData(
      nameAr: 'الدياتومايت Diatomite',
      nameEn: 'Diatomite',
      description: 'صخر رسوبي سيليكاتي خفيف ناعم الحبيبات يتكون من هياكل الدياتومات المجهرية المتحجرة، يتميز بمسامية وقدرة ترشيح فائقة، ويستخدم في ترشيح وتصفية السوائل والزيوت ومياه الشرب، ومواد العزل الحراري ومبيدات الحشرات الطبيعية ومواد الحشو. يتواجد في منطقة تيماء والقصيم والمدينة المنورة.',
      photoAsset: 'assets/images/diatomite.jpg',
      iconAsset: 'assets/images/ic_diatomite.png',
    ),
    'Perlite': const MaterialInfoData(
      nameAr: 'البيرلايت Perlite',
      nameEn: 'Perlite',
      description: 'زجاج بركاني غير بلوري يتميز بخاصية التمدد والانتفاخ إلى عدة أضعاف حجمه الأصلي عند تسخينه، ويستخدم كعازل حراري وصوتي خفيف الوزن في البناء، وفي تحسين التربة الزراعية والاحتفاظ برطوبتها، وفي ترشيح السوائل. يتواجد في الحرات البركانية مثل حرة الشاقة وحرة رهط.',
      photoAsset: 'assets/images/perlite.jpg',
      iconAsset: 'assets/images/ic_perlite.png',
    ),
    'Bentonite': const MaterialInfoData(
      nameAr: 'البنتونايت Bentonite',
      nameEn: 'Bentonite',
      description: 'نوع من الطين يتكون أساساً من المونتموريلونايت الناتج عن تحلل الرماد البركاني، يتميز بقدرته العالية على امتصاص الماء والانتفاخ، ويستخدم كطين حفر في آبار النفط والغاز، وفي صناعة حبيبات الحديد، وبطانة لمنع تسرب المياه في السدود والبرك المائية. يتواجد في منطقة خليص وتبوك وجنوب جدة.',
      photoAsset: 'assets/images/bentonite.jpg',
      iconAsset: 'assets/images/ic_bentonite.png',
    ),
    'Barite': const MaterialInfoData(
      nameAr: 'البارايت Barite',
      nameEn: 'Barite',
      description: 'معدن كبريتات الباريوم الثقيل عالي الكثافة، يستخدم بشكل أساسي (نحو 85%) كعامل تثقيل في سوائل حفر آبار النفط والغاز لمنع اندفاع الغازات، وفي الدهانات والأشعة الطبية. يتواجد في جبل إدساس ووادي كمال وأم الباب بالدرع العربي.',
      photoAsset: 'assets/images/barite.jpg',
      iconAsset: 'assets/images/ic_barite.png',
    ),
    'Quartzite': const MaterialInfoData(
      nameAr: 'الكوارتزايت Quartzite',
      nameEn: 'Quartzite',
      description: 'صخر متحول يتكون من بلورات الكوارتز المتلاصقة بقوة فائقة، يتميز بصلادته ومقاومته للحرارة والأحماض. يستعمل في صناعة سبائك الفيروسليكون والمواد الحرارية المقاومة للصهر وأحجار الزينة وأرضيات البناء المقاومة للاهتراء الشديد. يتواجد في وسط وشرق الدرع العربي.',
      photoAsset: 'assets/images/quartzite.jpg',
      iconAsset: 'assets/images/ic_quartzite.png',
    ),
    'Clay': const MaterialInfoData(
      nameAr: 'الطين والصلصال Clay',
      nameEn: 'Clay',
      description: 'مواد رسوبية ترابية ناعمة تستخدم في صناعة الطوب الأحمر الفخاري، والسيراميك، والبلاط، ومواد العزل وسدود احتواء المياه ومواد الحفر النفطي. تنتشر رواسب الطين في مختلف مناطق المملكة حول الأودية ومصبات السيول وفي حوض الخرج والقصيم وتبوك.',
      photoAsset: 'assets/images/clay.jpg',
      iconAsset: 'assets/images/ic_clay.png',
    ),
    'Pozzolan': const MaterialInfoData(
      nameAr: 'البوزولان Pozzolan',
      nameEn: 'Pozzolan',
      description: 'مواد بركانية تحتوي على السيليكا والألومينا تتفاعل مع هيدروكسيد الكالسيوم عند إضافة الماء لتكوين مركبات أسمنتية رابطة. يستخدم في تصنيع الإسمنت البوزولاني المقاوم للكبريتات والأملاح ولمياه البحر، وفي الخرسانة عالية المقاومة. يتواجد في الحرات البركانية كحرة خيبر وحرة رهط وحرة الحرة.',
      photoAsset: 'assets/images/pozzolan.jpg',
      iconAsset: 'assets/images/ic_pozzolan.png',
    ),
    'Salt': const MaterialInfoData(
      nameAr: 'الملح الصخري Salt',
      nameEn: 'Salt',
      description: 'معدن الهالايت (كلوريد الصوديوم) الناتج من تبخر المياه المالحة في السباخ والبحيرات المغلقة. يدخل في صناعة الصودا الكاوية، وغاز الكلور، والصناعات البتروكيماوية والغذائية وإذابة الجليد. يتواجد في القباب الملحية بجازان وجزر فرسان والسباخ الساحلية بالخليج العربي والقريات.',
      photoAsset: 'assets/images/salt.jpg',
      iconAsset: 'assets/images/ic_salt.png',
    ),
    'Kaolin': const MaterialInfoData(
      nameAr: 'الكاولين Kaolin',
      nameEn: 'Kaolin',
      description: 'صلصال أبيض نقي يتكون من سيليكات الألمنيوم المائية، يستخدم في صناعة السيراميك والخزف والبورسلان، وطلاء الورق لإكسابه البياض والنعومة، وفي صناعة الدهانات والمطاط والمستحضرات الطبية ومستحضرات التجميل. يتواجد في منطقة الزبيرة والخرج وتبوك وخشم عثيث.',
      photoAsset: 'assets/images/kaolin.jpg',
      iconAsset: 'assets/images/ic_kaolin.png',
    ),
    'AggregateMaterials': const MaterialInfoData(
      nameAr: 'مواد الركام Aggregate Materials',
      nameEn: 'AggregateMaterials',
      description: 'الحصى والرمل والركام الطبيعي والمكسر من صخور الصوان والجرانيت والحجر الجيري، وتشكل المكون الحجمي الأساسي للخرسانة الإنشائية والإسفلت وطبقات أساس الطرق وسكك الحديد. تنتشر في بطون الأودية والكسارات حول المدن الرئيسية.',
      photoAsset: 'assets/images/aggregatematerials.jpg',
      iconAsset: 'assets/images/ic_aggregatematerials.png',
    ),
    'Talc': const MaterialInfoData(
      nameAr: 'التلك Talc',
      nameEn: 'Talc',
      description: 'أنعم المعادن المعروفة في الطبيعة (درجة 1 على مقياس موهس للصلادة)، يتميز بملمس صابوني دهني ولون أبيض مخضر. يستخدم في مساحيق التلك للأطفال ومستحضرات التجميل وصناعة الورق والبلاستيك والدهانات ومواد التزليق وصناعة السيراميك. يتواجد في صخور الدرع العربي بوادي فلح وخيبر.',
      photoAsset: 'assets/images/talc.jpg',
      iconAsset: 'assets/images/ic_talc.png',
    ),
    'Uranium': const MaterialInfoData(
      nameAr: 'اليورانيوم Uranium',
      nameEn: 'Uranium',
      description: 'عنصر فلزي مشع ثقيل يستخدم كوقود في محطات الطاقة النووية لتوليد الكهرباء النظيفة والتحلية النووية للمياه، وفي التطبيقات الطبية والصناعية. تم استكشاف مؤشرات واعدة لخامات اليورانيوم والثوريوم في صخور الجرانيت بالدرع العربي في غريات وحائل وجبل سعيد ورواسب الفوسفات بالشمال.',
      photoAsset: 'assets/images/uranium.jpg',
      iconAsset: 'assets/images/ic_uranium.png',
    ),
    'Aluminium': const MaterialInfoData(
      nameAr: 'الألمنيوم Aluminium',
      nameEn: 'Aluminium',
      description: 'فلز خفيف الوزن قوي ومقاوم للتآكل وموصل ممتاز للكهرباء والحرارة. يدخل في صناعة هياكل الطائرات، والسيارات، وعلب المشروبات، وأسلاك نقل الكهرباء، وإطارات النوافذ ومواد التغليف. يستخرج خامه (البوكسايت) من منجم الزبيرة ويعالج في مجمع رأس الخير الصناعي.',
      photoAsset: 'assets/images/aluminium.jpg',
      iconAsset: 'assets/images/ic_aluminium.png',
    ),
    'Lead': const MaterialInfoData(
      nameAr: 'الرصاص Lead',
      nameEn: 'Lead',
      description: 'معدن فلزي ثقيل ناعم ومرن لونه رمادي داكن، يتميز بكثافته العالية ومقاومته للإشعاعات وحمض الكبريتيك. يستعمل الرصاص أساساً في صناعة بطاريات السيارات والألواح الواقية من الإشعاعات في المستشفيات والمختبرات النووية وصناعة الكابلات والسبائك المقاومة للاحتكاك. يتواجد الرصاص في المملكة في منطقة الخنيقية وجبل درباعة وحلاحيلة.',
      photoAsset: 'assets/images/lead.jpg',
      iconAsset: 'assets/images/ic_lead.png',
    ),
    'Asbestos': const MaterialInfoData(
      nameAr: 'الأسبستوس Asbestos',
      nameEn: 'Asbestos',
      description: 'مجموعة من المعادن السيليكاتية الليفية المقاومة للحرارة والحرائق والمواد الكيميائية. استعمل تاريخياً في العزل الحراري والفرامل ومواد البناء وأنابيب الضغط العالي. يتواجد في الصخور فوق القاعدية المتحولة في الدرع العربي مثل حرة الجعلاني ووادي رنية وجبل غياضة.',
      photoAsset: 'assets/images/asbestos.jpg',
      iconAsset: 'assets/images/ic_asbestos.png',
    ),
    'Ilmenite': const MaterialInfoData(
      nameAr: 'الإلمينايت Ilmenite',
      nameEn: 'Ilmenite',
      description: 'معدن أكسيد الحديد والتيتانيوم الأسود، وهو المصدر الرئيسي لإنتاج معدن التيتانيوم القوي وفائق الخفة المقاوم للحرارة وثاني أكسيد التيتانيوم المستخدم كصبغة بيضاء ناصعة في الدهانات والبلاستيك والورق. يتواجد في الرمال السوداء الساحلية على البحر الأحمر وفي صخور الجابرو بالدرع العربي.',
      photoAsset: 'assets/images/ilmenite.jpg',
      iconAsset: 'assets/images/ic_ilmenite.png',
    ),
    'Olivine': const MaterialInfoData(
      nameAr: 'الزبرجد الزيتوني (الأوليفين) Olivine',
      nameEn: 'Olivine',
      description: 'معدن سيليكات المغنيسيوم والحديد ذو لون أخضر زيتوني شفاف. يستخدم كحجر كريم (الزبرجد)، وفي صهر الحديد، وكمادة حرارية مقاومة للأفران ومرشحات الرمل، ولديه قدرة طبيعية على امتصاص ثاني أكسيد الكربون من الغلاف الجوي. ينتشر بكثرة في صخور البازلت بالحرات البركانية كحرة كشب وخيبر.',
      photoAsset: 'assets/images/olivine.jpg',
      iconAsset: 'assets/images/ic_olivine.png',
    ),
    'Garnet': const MaterialInfoData(
      nameAr: 'العقيق (الجارنت) Garnet',
      nameEn: 'Garnet',
      description: 'مجموعة من المعادن السيليكاتية الصلبة ذات ألوان بلورية حمراء وبنية وبنفسجية جذابة. تستخدم كأحجار كريمة للزينة والحلي، وكمادة كاشطة طبيعية عالية الكفاءة في قطع المعادن بنفث الماء المضغوط (Waterjet) وصنفرة الأسطح وتنقية المياه. يتواجد في صخور الشيست بمناطق عسير وحائل ووادي ميسان.',
      photoAsset: 'assets/images/garnet.png',
      iconAsset: 'assets/images/ic_garnet.png',
    ),
    'Zeolite': const MaterialInfoData(
      nameAr: 'الزيولايت Zeolite',
      nameEn: 'Zeolite',
      description: 'معدن سيليكاتي مسامي ذو بنية شبكية دقيقة تسمح له باحتجاز السوائل والغازات، يستخدم كمنخل جزيئي في معالجة مياه الشرب والصرف الصحي، وتنقية الغاز، وتحسين التربة الزراعية، وفي صناعة المنظفات والمحفزات النفطية. يتواجد في الحرات البركانية مثل حرة خيبر وحرة كشب.',
      photoAsset: 'assets/images/zeolite.jpg',
      iconAsset: 'assets/images/ic_zeolite.png',
    ),
    'Graphite': const MaterialInfoData(
      nameAr: 'الجرافيت Graphite',
      nameEn: 'Graphite',
      description: 'أحد أشكال الكربون الطبيعي، موصل ممتاز للكهرباء ومقاوم للحرارة الشديدة وذو ملمس دهني. يستعمل في أقطاب بطاريات الليثيوم للسيارات الكهربائية، ومواد التزليق الجافة، وأقطاب الأفران الكهربائية وصناعة أقلام الرصاص. يتواجد في صخور الشيست المتحولة في الدرع العربي مثل حلبان وجبل الأمار.',
      photoAsset: 'assets/images/graphite.jpg',
      iconAsset: 'assets/images/ic_graphite.png',
    ),
    'Dolomite': const MaterialInfoData(
      nameAr: 'الدلومايت Dolomite',
      nameEn: 'Dolomite',
      description: 'صخر كربوني يتكون من كربونات الكالسيوم والمغنيسيوم. يستعمل في صناعة الفولاذ كمساعد صهر، وفي صناعة الزجاج لزيادة الصلابة ومقاومة الكسر، وفي المباني وأحجار الرصف والزينة، وسماد زراعي لتعديل حموضة التربة. ينتشر في تكاوين الخف والجلح وحجر جير طويق.',
      photoAsset: 'assets/images/dolomite.png',
      iconAsset: 'assets/images/ic_dolomite.png',
    ),
    'Basalt': const MaterialInfoData(
      nameAr: 'البازلت Basalt',
      nameEn: 'Basalt',
      description: 'صخر ناري بركاني داكن اللون صلب جداً وغني بالحديد والمغنيسيوم. يستخدم في رصف الطرق وسكك الحديد وإنتاج الصوف الصخري العازل للحرارة والصوت وصناعة الأنابيب المقاومة للتآكل الكيميائي. يغطي الحرات البركانية الشاسعة في غرب المملكة بمساحة تتجاوز 80,000 كم2.',
      photoAsset: 'assets/images/basalt.jpg',
      iconAsset: 'assets/images/ic_basalt.png',
    ),
  };

  // Button labels matching exact Arabic strings in activity_materials.xml
  final Map<String, String> _metalButtonLabels = const {
    'Copper': 'النحاس',
    'Feldspar': 'الفلدسبار',
    'Gold': 'الذهب',
    'Granite': 'الجرانيت',
    'Gypsum': 'الجبس',
    'Iron': 'الحديد',
    'Kyanite': 'الكايانيت',
    'Limestone': 'الحجر الجيري',
    'Magnesite': 'المغنسيت',
    'Marble': 'الرخام',
    'Nickel': 'النيكل',
    'Phosphate': 'الفوسفات',
    'Sandstone': 'الحجر الرملي',
    'Bauxite': 'البوكسايت',
    'Chromium': 'الكروم',
    'SilicaSand': 'رمل السيليكا',
    'Silver': 'الفضة',
    'Zinc': 'الزنك',
    'NephelineSyenite': 'النيفلين سينيت',
    'Diatomite': 'الدياتومايت',
    'Perlite': 'البيرلايت',
    'Bentonite': 'البنتونايت',
    'Barite': 'البارايت',
    'Quartzite': 'الكوارتزايت',
    'Clay': 'الطين والصلصال',
    'Pozzolan': 'البوزولان',
    'Salt': 'الملح الصخري',
    'Kaolin': 'الكاولين',
    'AggregateMaterials': 'مواد الركام والركام الطبيعي',
    'Talc': 'التلك',
    'Uranium': 'اليورانيوم',
    'Aluminium': 'الألمنيوم',
    'Lead': 'الرصاص',
    'Asbestos': 'الأسبستوس',
    'Ilmenite': 'الإلمينايت',
    'Olivine': 'الزبرجد الزيتوني (الأوليفين)',
    'Garnet': 'العقيق (الجارنت)',
    'Zeolite': 'الزيولايت',
    'Graphite': 'الجرافيت',
    'Dolomite': 'الدلومايت',
    'Basalt': 'البازلت',
  };

  @override
  void initState() {
    super.initState();
    _loadExcelData();
  }

  Future<void> _loadExcelData() async {
    setState(() => _isLoading = true);
    try {
      final String jsonString = await rootBundle.loadString(AppAssets.materialsJson);
      final List<dynamic> rawList = jsonDecode(jsonString);

      final List<MaterialLocation> list = rawList.map((item) {
        return MaterialLocation(
          latitude: (item['lat'] as num).toDouble(),
          longitude: (item['lon'] as num).toDouble(),
          nameEn: item['nameEn']?.toString() ?? '',
          nameAr: item['nameAr']?.toString() ?? '',
          region: item['region']?.toString() ?? '',
          locationName: item['loc']?.toString() ?? '',
        );
      }).toList();

      if (mounted) {
        setState(() {
          _allLocations = list;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _onMetalSelected(String metalEn) async {
    final info = _mineralsData[metalEn];

    // Filter locations for this metal
    final filtered = _allLocations.where(
      (m) => m.nameEn.toLowerCase() == metalEn.toLowerCase(),
    ).toList();

    if (kIsWeb && _mapController != null) {
      _mapController!.clearWebMarkers();
      final iconPath = info?.iconAsset ?? AppAssets.mineralIcon(metalEn);
      for (final loc in filtered) {
        _mapController!.addWebMarker(
          latitude: loc.latitude,
          longitude: loc.longitude,
          iconAsset: iconPath,
          id: '${loc.latitude}_${loc.longitude}',
          onTap: () {
            AppPopupDialog.show(
              context,
              title: loc.nameAr.isNotEmpty ? loc.nameAr : (info?.nameAr ?? metalEn),
              description: 'الموقع: ${loc.region}\n'
                  'المنطقة الإدارية: ${loc.locationName}\n'
                  'خط الطول شرقاً: ${loc.longitude}\n'
                  'خط العرض شمالاً: ${loc.latitude}',
            );
          },
        );
      }
    } else if (_mapController?.pointAnnotationManager != null) {
      final manager = _mapController!.pointAnnotationManager!;
      await manager.deleteAll();
      _annotationMaterialMap.clear();

      try {
        final iconPath = info?.iconAsset ?? AppAssets.mineralIcon(metalEn);
        ByteData byteData;
        try {
          byteData = await rootBundle.load(iconPath);
        } catch (_) {
          byteData = await rootBundle.load(AppAssets.markerIcon);
        }
        final Uint8List imageBytes = byteData.buffer.asUint8List();

        final optionsList = filtered.map((loc) {
          return PointAnnotationOptions(
            geometry: Point(coordinates: Position(loc.longitude, loc.latitude)),
            image: imageBytes,
            iconSize: 0.35,
          );
        }).toList();

        final annotations = await manager.createMulti(optionsList);
        for (int i = 0; i < annotations.length && i < filtered.length; i++) {
          final ann = annotations[i];
          if (ann != null) {
            _annotationMaterialMap[ann.id] = filtered[i];
          }
        }

        manager.addOnPointAnnotationClickListener(
          AppPointAnnotationClickListener((annotation) {
            final loc = _annotationMaterialMap[annotation.id];
            if (loc != null) {
              AppPopupDialog.show(
                context,
                title: loc.nameAr.isNotEmpty ? loc.nameAr : (info?.nameAr ?? metalEn),
                description: 'الموقع: ${loc.region}\n'
                    'المنطقة الإدارية: ${loc.locationName}\n'
                    'خط الطول شرقاً: ${loc.longitude}\n'
                    'خط العرض شمالاً: ${loc.latitude}',
              );
            }
          }),
        );
      } catch (e) {
        debugPrint('Error updating material annotations: $e');
      }
    }

    // Show specimen popup dialog matching Android popup_layout.xml (metalInfoPopUp)
    if (info != null) {
      AppPopupDialog.show(
        context,
        title: info.nameAr,
        imageAsset: info.photoAsset,
        description: info.description,
      );
    }

    // Fly 3D globe camera if locations exist
    if (filtered.isNotEmpty && _mapController != null) {
      _mapController!.flyTo(
        latitude: filtered.first.latitude,
        longitude: filtered.first.longitude,
        zoom: 6.5,
      );
    }
  }

  void _showIntroBrief() {
    AppBriefDialog.show(
      context,
      title: 'المعادن الإقتصادية',
      description: ' المعدن Mineral مادة صلبة متجانسة وغير عضوية تكونت بفعل عوامل طبيعية لها تركيب كيميائي محدد وترتيب ذري داخلي محدد .تعتبر الذرة هي أصغر جزء من المادة وتحتفظ بخواصها الطبيعية ، تتجمع الذرات مع بعضها لتكون العنصر وتتجمع العناصر مع بعضها لتكون المعادن وتتجمع المعادن مع بعضها لتكون الصخر ، فإذا احتوى المعدن على عناصر ذات قيمة اقتصادية فيسمى معدن خام أو معدن اقتصادي ...\n'
          'وإذا احتوى الصخر على معدن خام يسمى راسب معدني.\n'
          ' المعدن الخام Ore Mineral هو المعدن الذي يمكن استخلاص فلز أو أكثر منه بصورة اقتصادية . إما أن يكون على هيئة فلز حر مثل الذهب والبلاتين أو على هيئة الفلز متحد مع عنصر أو عناصر أخرى مكوناً مركبات كيميائية متعددة ( أكاسيد ، كبريتيدات ). \n'
          'المعادن تنقسم إلى معادن فلزية و معادن لافلزية أو مواد أرضية مثل الفحم, والصلصال, والبترول.\n\n'
          'المعادن الفلزية\n'
          'مثل الذهب والنحاس والحديد والنيكل فهي ذات ألوان طبيعية ثابتة, كما أن لها بريقاً معدنياً, ولها شكل خاص , فهي إما كلوية الشكل مثل بعض معادن الحديد, أو شجرية مثل معادن المنجنيز. وتتميز المعادن الفلزية أيضاً بأنها ذات صفات خاصة من حيث الصلادة, فالمعدن الصلد يمكن أن يخدش ما هو أقل منه صلادة.\n'
          '• المعادن الفلزية النقية : الذهب - الفضة - النحاس - القصدير.\n'
          '• معادن فلزية غير نقية : الألمنيوم - البوكسايت - الأنتيمون - الكروم - الكوبالت - خامات الحديد - الرصاص - الليثيوم - المنجنيز - النيكل - التيتانيوم - الزنك.\n\n'
          'المعادن اللافلزية\n'
          'فتختلف عن الفلزات في أنها تستخدم وهي على صورتها التي تستخرج بها من الطبيعة, فالصلصال مثلا يستخدمه الإنسان لخواصه الطبيعية وليس لاحتوائه على الألومنيوم, كما أن الأسبستوس يستخدمه الإنسان لبريقه الحريري وشكله الليفي.\n'
          '• المعادن غير الفلزية : السيليكا - الكوارتز - الفلسبار - البارايت - الهالايت - الجبس - الكبريت - الحجر الجيري - الفوسفات - الميكا - معادن الطين - الأسبستوس - اليورانيوم.\n\n'
          'تنتشر الثروات المعدنية في المملكة في أكثر من 5,300 موقع، وتقدر قيمتها بنحو خمسة تريليونات ريال، وثمة نحو 360 مجمعاً تعدينياً تنتج العديد من المعادن والمنتجات المعدنية التي لها دور مهم في تطوير سلاسل القيمة للمعادن الفلزية واللافلزية؛ إذ يبلغ إنتاج المملكة من البوكسايت حوالي 4.9 ملايين طن سنوياً، يتم معالجته لإنتاج حوالي مليون طن من الألمنيوم سنوياً، كما يتم إنتاج حوالي 409 آلاف أوقية من الذهب بمنطقة الدرع العربي الغنية بالمعادن النفيسة والمعادن الأساس، ونحو 68 ألف طن سنوياً من مركّزات النحاس والزنك، و24.6 مليون طن من خام الفوسفات سنوياً.\n\n'
          'تستهدف المملكة -ضمن رؤية 2030- رفع الناتج المحلي من قطاع التعدين من 17 مليار دولار إلى 64 مليار دولار بحلول 2030م، ورفع نسبة مشاركة قطاع التعدين في الناتج المحلي الوطني لتتجاوز 5% بزيادة الاستثمارات التعدينية من نحو 3.9 مليار ريال إلى 115 مليار ريال.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'المعادن الإقتصادية',
      onBriefPressed: _showIntroBrief,
      briefButtonText: 'مقدمة',
      initialStyleAsset: 'assets/maps/materials/allMaterials.json',
      isLoading: _isLoading,
      onMapCreated: (controller) => _mapController = controller,
      sidebarContent: Column(
        children: _metalButtonLabels.entries.map((entry) {
          final key = entry.key;
          final arabicLabel = entry.value;

          return Container(
            width: double.infinity,
            height: 70,
            margin: const EdgeInsets.only(left: 21, right: 21, top: 16),
            decoration: BoxDecoration(
              color: AppColors.mainMenuBtnBg,
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
              border: Border.all(
                color: Colors.white.withOpacity(0.8),
                width: 1.5,
              ),
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
                onTap: () => _onMetalSelected(key),
                child: Center(
                  child: Text(
                    arabicLabel,
                    textAlign: TextAlign.center,
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
          );
        }).toList(),
      ),
    );
  }
}
