import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/dialogs/app_brief_dialog.dart';
import '../../core/dialogs/app_popup_dialog.dart';

class GeologyScreen extends StatefulWidget {
  const GeologyScreen({super.key});

  @override
  State<GeologyScreen> createState() => _GeologyScreenState();
}

class _GeologyScreenState extends State<GeologyScreen> {
  MapShellController? _mapController;

  final Map<String, ({String title, String desc})> _haratInfo = {
    'hart_unayyir-bgxfcy': (
      title: 'حرة الشاقة_لونيير',
      desc: 'الوصف : تقع بين العيص من الشرق ، وأملج من الغرب وتمتد من الجنوب الشرقي إلى الشمال الغربي بطول 63كم تقريباً ، وبعرض 58 كم تقريباً ، وقد انساحت الحرة – بحكم الميل – باتجاه الغرب وقد وصلت إلى السهل الساحلي ، وأشرفت على مدينة املج ، وإلى الغرب من حرة الشاقة توجد حرة صغيرة على شكل ذراع تسمى حرة العتبة ، تقع شمال أملج بمسافة 25كم بالقرب من مرسى البحير ، طرفها الجنوبي يحف البحر الأحمر ، ويبلغ طولها 6كم ، وعرضها كيلو متر.\n'
    ),
    'hart_kishb-815dj1': (
      title: 'حرة كشب',
      desc: 'الوصف : منطقة بركانية واسعة شديدة التضاريس تقع شمال بلدة رضوان، تتوزع بها أكثر من ( 150 ) من المخاريط ، وتحف أطرافها سباخ عظيمة مثل : سبخة الأشعرية و دغيبجة جنوباً. وعلى أطرافها الجنوبية توجد قرى: المويه القديم ودغيبجة وأم الدوم، وفي وسطها قرى حفر كشب، ويبلغ طولها من الجنوب إلى الشمال 110 كم تقريباً وعرضها من الغرب إلى الشرق 70 كلم تقريباً. ومن أشهر جبالها جبل الهيل، وجبل أبوحريص، وجبل شلمان، وجبل يهيي، وجبل الوعبة وتشتهر هذه الحرة بوجود فوهة عميقة وكبيرة تسمى الوعبة ويطلق عليها ( مقلع طمية) ويبلغ قطرها نحو 2300م وعمقها 200م.\n'
    ),
    'hart_khaybar-d6449k': (
      title: 'حرة خيبر',
      desc: 'الوصف : خيبر :حرة عظيمة ، تقع شمال شرقي المدينة المنورة ، وتعد أكبر الحرات في المملكة وأشهرها ، وتنحدر منها أعالي روافد وادي الرمة ، وتمتد هذه الحرة طولياً باتجاه شمالي جنوبي تقريباً بطول يقدر بنحو 280كم ، من شمال بلدة الصويدرة جنوباً ( شرق المدينة المنورة ) حتى دائرة العرض 27 ْ شمالاً ، أما أقصى عرض لها فيبلغ 170كم تقريباً ، وتتميز هذه الحرة بارتفاع جبالها البركانية التي توجد على خط مستقيم تقريباً ، وتتركز على أطرافها الشرقية والغربية بعض المدن والقرى ، ففي الجهة الشرقية توجد ، الحناكية ، والشويمس ، كما يوجد في الجهة الغربية : خيبر ، والعشاش ، ويطلق على أجزاء من الحرة بعض الأسماء المحلية ففي الناحية الجنوبية هناك : حرة الصفة ، وحرة الحزم ، وحرة العظامية ، ولسان من الحرة يمتد غرب الحناكية يسمى حرة مديسيس ، وفي شمالها تأخذ بعض الأسماء المحلية مثل : حرة الغويطات ، وحرة الوشام ، وحرة إثنان ، كما يطلق على أطرافها الشرقية اسم حرة بني رشيد ، ويطلق الأهالي في هذه المنطقة على البراكين التي على هيئة جبال ( حلاة ) وجمعها( حلي ) ، ومن أهم جبالها : جبل الابيض ( 2093م )، وجبل القدر( 2022م ) والذي يتميز بقمة تشبه القدر منخفضة في الوسط يبلغ قطرها نحو 400م بعمق 85م ، وجبل البيضاء ( 1936م ) والذي يتميز بشكله الأبيض ويبلغ قطر فوهته حوالي 1500م ، بعمق يصل إلى نحو 70م ، وجبل الإكليل ( 1938م ) ، ويقع إلى الجنوب من حرة خيبر حرات القفيف ، والناعمة ، وحرة هرمة التي توجد بها فوهة بركانية واسعة يبلغ قطرها 7000م بعمق يصل إلى نحو 50م توجد فيها قرية هرمة ، كما يوجد في طرفها الشمالي الشرقي بعض الينابيع المائية.\n'
    ),
    'hart_hadan-4qulnq': (
      title: 'حرة حضن',
      desc: 'الوصف : تقع غرب حرة نواصف ، ويفصل بينهما وادي تربة ، ويحدها من الغرب منطقة الجرد ، ومن الشمال سهل ركبة ، ويبلغ طولها نحو 120كم ، وعرضها 45كم تقريباً ، كما يطلق عليها جبال حضن .ويوجد إلى الغرب من حرة حضن حرة صغيرة ناتجة من بركان واحد تسمى حرة البرث ، وهي تقع عند نهاية وادي لبة ، عندما يتلاشى في سهل الجرد ، ويبلغ طولها 10كم ، وعرضها 5كم .\n'
    ),
    'hart_awarad-5bksz1': (
      title: 'حرة عويرض',
      desc: 'الوصف : تقع غرب العلا ومدائن صالح ، وتمتد من الجنوب الشرقي إلى الشمال الغربي بطول 140كم تقريباً ، وأقصى عرض لها يبلغ نحو 40كم ، تتفرع على هيئة ألسن وأذرع كثيرة جداً بين الشعاب والأودية ، ولها فوهات بركانية على خط مستقيم على طول الحرة ، ومن أهم جبالها جبل عناز ( 1839م ) ، وتشتهر بوجود الفوهات البركانية المنخفضة ، ومنها : فوهة الهوية التي يبلغ قطرها نحو 1500م ، وبعمق يصل إلى نحو 55م ، ويوجد بعض الحرات التي تعد امتداداً لحرة عويرض وهي : حرة الرحا في الشمال وحرة الزبن في الجنوب.\n'
    ),
    'hart_alsarah-7t4hk2': (
      title: 'حرة السراة',
      desc: 'الوصف : تبدأ من ظهران الجنوب باتجاه الشمال وتمتد مسافة 80كم تقريباً ، وتبدو واضحة فوق قمم الجبال لأن غالبيتها انجرفت بفعل التعرية وهي تحيط بسراة عبيدة .\n'
    ),
    'hart_alhtaymh-1yw1sy': (
      title: 'حرة الهتيمة',
      desc: 'الوصف : تقع بمحاذاة جبل سلمى من الشرق إلى الجنوب الشرقي من مدينة حائل ، يبلغ طولها نحو 55كم ، وأقصى عرض لها 30كم ، وهي الحرة الوحيدة البعيدة عن خط النشاط البركاني ، ويوجد في هذه الحرة منخفض طابة وهو عبارة عن فوهة بركانية يبلغ قطرها نحو 1500م بعمق يصل إلى نحو 35م ، وتقع فيه قرية طابة القديمة ، ويوجد بالقرب منها – وسط جبال سلمى – بلدة النعي التي تقع في منخفض تحيط به حافات جبلية شديدة الانحدار ، وتشتهر الحرة بوجود المناطق المنخفضة وسط قمم الجبال وتسمى ( دارات ) ويطلق على بعض أطرافها أسماء محلية مثل : حرة الصاع ، وحرة هروج.\n'
    ),
    'hart_nawsaf_albogom-1i8dcl': (
      title: 'حرة نواصف البقوم',
      desc: 'الوصف : حرة واسعة تقع بين وادي رنية من الجنوب والجنوب الشرقي ، ووادي تربة من الشمال والشمال الغربي ومن الجنوب مدينة العقيق ( عقيق الباحة ) ومن الشمال الشرقي الطريق الواصل بين رنية و الخرمة ، ويبلغ طولها نحو 205كم ، وأقصى عرض 120كم ، ويوجد داخلها قرى مثل : العويلة ، وجراب ، والقوامة ، ومن المدن التي تقع على أطرافها : العقيق وجعلة جنوباً ، والعفيرية والغافة والأملح شرقاً ، والخرمة في الشمال الغربي ، وتتميز هذه الحرة بأن براكينها منتشرة في جميع أنحائها ، وليست في خط مستقيم كحرة رهاط أو خيبر.\n'
    ),
    'hart_rahat-2ojan9': (
      title: 'حرة رهط',
      desc: 'الوصف : تسمى في بعض المواقع حرة القرى أو الكرى وحرة الحجاز، وحرة رهط حرة كبيرة وطويلة، تقع إلى الجنوب من حرة خيبر، وتمتد طولياً باتجاه شمالي جنوبي، ومعظم براكينها تقع على خط طول 40 درجة شرقاً أو قريباً منه، وتنحرف البراكين قليلاً جنوبي هذه الحرة باتجاه الشرق حتى تصل إلى خط طول 15’ 40 درجة شرقاً، أما شمال الحرة فإن البراكين تنحرف قليلاً باتجاه الغرب، وتصل إلى خط طول 45’ 39 درجة شرقاً ، كما تضم الحرة نظام الشقوق الأرضية بطول حوالي 11 كلم ويتكون من عدة شقوق منتظمة على هيئة متدرجة يعود تاريخها من 2000 إلى 3000 عام، وقد تسبب انفتاح هذا الشق في حدوث زلزال المدينة المنورة، ويصحب نظام الشقوق البركانية التكوينية هذه عادة أنشطة زلزالية خفيفة كما هو مؤكد عند انبثاق الحرة الشرقية.\n'
    ),
    'hart_alharh-9osy8j': (
      title: 'حرة الحرة',
      desc: 'الوصف : هي الغطاء البركاني الوحيد داخل النطاق الرسوبي في المملكة العربية السعودية. وهي مكونة من البازلت. وتمتد من جبل الدروز في سوريا جنوبا عبر الأردن إلى المملكة العربية السعودية، وتأخذ اتجاه الجنوب الشرقي إلى الشمال الغربي ، تحدها هضبة الحماد شرقاً، ووادي السرحان غرباً، ويبلغ طولها نحو 230 كلم، وأقصى عرض لها يبلغ 85 كم تقريباً، وتقع مدينة طريف في الطرف الشرقي منها، على حين تقع مدينة القريات في الطرف الغربي، ويطلق على بعض أجزائها أسماء محلية : حرة المابية على الحافة الشمالية لسبخة حضوضاء، وحرة قليب خضر شمال العيساوية، وأشهر جبالها : جبل لس، وجبل نعيج.\n'
    ),
    'sahal_thamah-8ryrba': (
      title: 'حرات سهل تهامة',
      desc: 'الوصف : يوجد بعض الحرات الصغيرة المتناثرة في السهل الساحلي ( سهل تهامة ) من جنوب مكة حتى مدينة جازان مرتبة من الشمال إلى الجنوب ، وهي : حرة الدام ، ، وحرة شامة ، وحرة الصواملة ، شمال مدينة الليث ، وحرة البرك والقحمة ، وحرة خميس البحر ، وحرة محايل عسير وحرة عكوة ، إلى الشمال الشرقي من مدينة صبيا ، وحرة أبو عريش ، وحرة القمم إلى الجنوب الشرقي من مدينة أبو عريش.\n'
    ),
  };

  // ----------------------------------------------------
  // Geomorphology Dialogs & Actions
  // ----------------------------------------------------
  void _showGeomorphologyOverview() {
    AppBriefDialog.show(
      context,
      title: 'جيومورفولوجية المملكة العربية السعودية',
      description: 'تتميز تضاريس المملكة العربية السعودية بتنوع جيومورفولوجي واسع ناتج عن العمليات التكتونية وحركات الرفع والتعرية عبر العصور الجيولوجية.\n\n'
          'وتنقسم التضاريس الجيومورفولوجية الرئيسية في المملكة إلى خمس وحدات كبرى:\n\n'
          '1. المرتفعات الغربية: وتشمل جبال مدين والحجاز والسروات وتمتد بمحاذاة البحر الأحمر.\n'
          '2. الهضاب: وتشمل هضبة نجد وهضاب الصمان وحسمة والحماد والوديان.\n'
          '3. التكوينات الرملية: وتشمل صحراء النفود الكبير وصحراء الدهناء وصحراء الجافورة.\n'
          '4. صحراء الربع الخالي: أكبر بحر رملي متصل في العالم بمساحة تقارب 650 ألف كم2.\n'
          '5. السهول الساحلية: سهل تهامة في الغرب وسهول الخليج العربي المنبسطة في الشرق.',
    );
  }

  void _showWesternHighlands() {
    _mapController?.flyTo(latitude: 19.5, longitude: 42.0, zoom: 6.2);
    AppPopupDialog.show(
      context,
      title: 'المرتفعات الغربية',
      imageAsset: AppAssets.arabianShield,
      description: 'تمتد المرتفعات الغربية (جبال السروات والحجاز ومدين) على طول الساحل الشرقي للبحر الأحمر لمسافة تزيد عن 1500 كم من حدود الأردن شمالاً إلى اليمن جنوباً.\n\n'
          '• جبال مدين في الشمال الغربي: وتتميز بجبالها الوعرة وتكويناتها الجرانيتية الحادة.\n'
          '• جبال الحجاز في الوسط: متوسطة الارتفاع وتتخللها الأودية والحرات البركانية.\n'
          '• جبال السروات في الجنوب: أعلى مناطق المملكة ارتفاعاً حيث تبلغ قمة جبل السودة حوالي 3000 متر فوق مستوى سطح البحر.\n\n'
          'تنحدر هذه المرتفعات بشدة نحو الغرب باتجاه سهل تهامة، بينما تنحدر تدريجياً نحو الشرق لتتصل بهضاب نجد.',
    );
  }

  void _showPlateaus() {
    _mapController?.flyTo(latitude: 24.5, longitude: 45.0, zoom: 5.8);
    AppPopupDialog.show(
      context,
      title: 'الهضاب في المملكة',
      imageAsset: AppAssets.arabianPlatform,
      description: 'تشغل الهضاب مساحات شاسعة من أراضي المملكة العربية السعودية، وتتدرج في الارتفاع من الغرب إلى الشرق:\n\n'
          '• هضبة نجد: كبرى هضاب المملكة، تتألف من هضبة عالية نجد في الغرب وهضبة نجد السفلى في الشرق، وتخترقها حواف صخرية شهيرة مثل جبال طويق وجبال العارض.\n'
          '• هضبة حسمة: في الشمال الغربي وتشتهر بتكويناتها الصخرية الرملية الرائعة في تبوك وديسة.\n'
          '• هضبة الحِماد والحَجَرة: في أقصى الشمال.\n'
          '• هضبة الصمان: هضبة جيرية منبسطة تمتد بمحاذاة الدهناء شرقاً باتجاه الخليج العربي.',
    );
  }

  void _showSandFormations() {
    _mapController?.flyTo(latitude: 27.5, longitude: 42.0, zoom: 5.8);
    AppPopupDialog.show(
      context,
      title: 'التكوينات الرملية',
      description: 'تغطي التكوينات الرملية حوالي ثلث مساحة المملكة وتتوزع على عدة بحار وكثبان رملية عملاقة:\n\n'
          '• صحراء النَفود الكبير: في شمال المملكة، تبلغ مساحتها حوالي 65,000 كم2 وتتألف من كثبان طولية وعروق رملية حمراء غنية.\n'
          '• صحراء الدَّهْناء: شريط رملي قوسي ضيق يمتد لأكثر من 1,200 كم ليربط بين النفود الكبير في الشمال والربع الخالي في الجنوب.\n'
          '• صحراء الجافورة: تقع في المنطقة الشرقية بمحاذاة سواحل الخليج العربي وجنوب الأحساء.',
    );
  }

  void _showEmptyQuarter() {
    _mapController?.flyTo(latitude: 20.0, longitude: 50.0, zoom: 5.4);
    AppPopupDialog.show(
      context,
      title: 'صحراء الربع الخالي',
      description: 'يعد الربع الخالي أكبر صحراء رملية متصلة في العالم، بمساحة تقارب 650,000 كم2 يشغل الجزء الأكبر منها جنوب وجنوب شرقي المملكة العربية السعودية.\n\n'
          '• يتميز بوجود كثبان رملية نجمية عملاقة يصل ارتفاع بعضها إلى أكثر من 250 متراً فوق القيعان.\n'
          '• تشتمل بيئته على مساحات شاسعة من السباخ القارية والمطرية.\n'
          '• يضم الربع الخالي أحواضاً رسوبية عميقة تحتوي على أضخم حقول النفط والغاز الطبيعي في العالم (مثل حقل الشيبة)، بالإضافة إلى خزانات مياه جوفية عميقة.',
    );
  }

  // ----------------------------------------------------
  // Geology Dialogs & Actions
  // ----------------------------------------------------
  void _showIntroBrief() {
    AppBriefDialog.show(
      context,
      title: 'جيولوجية المملكة',
      bottomImageAsset: AppAssets.geologicMapArabianPeninsula,
      description: 'تعود أقدم الصخور في المملكة إلى عصر ما قبل الكمبري، أي قبل حوالي 3 مليارات سنة. وهي تشكل أجزاء من الصفيحة العربية التي تشمل شبه الجزيرة العربية.\n\n'
          'وباختصار تنقسم المملكة جيولوجياً إلى وحدات متميزة:\n'
          '• الدرع العربي وهو يتبع دهر طلائع الحياة ويتمثل في التتابعات البركانية الرسوبية المتحولة التي يتداخل فيها الجرانيت والجابرو.\n'
          '• الرصيف القاري العربي وهو يتبع دهر الحياة الظاهرة ويحتوي على تتابعات رسوبية فتاتية وجيرية ومتبخرات تميل بدرجات خفيفة نحو الشرق مبتعدة عن الدرع العربي.\n'
          '• حرات العصر الثلاثي والرباعي البركانية وهي في الغالب تعلو صخور الدرع العربي.\n'
          '• السهل الساحلي للبحر الأحمر والخليج العربي.',
    );
  }

  void _showArabianShield() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/arabian_shield.json');
    _mapController?.flyTo(latitude: 23.5, longitude: 41.5, zoom: 6.0);
    AppPopupDialog.show(
      context,
      title: 'الدرع العربي',
      imageAsset: AppAssets.arabianShield,
      description: 'يعتبر الدرع العربي في شبه الجزيرة العربية والدرع النوبي في مصر والسودان جزءً من كتلة شرق أفريقيا والمكونة قلب قارة جوندوانا الكبيرة في نهاية عصر ما قبل الكمبري، وقد انفصل الدرع العربي عن نظيره الدرع النوبي بواسطة أخدود البحر الأحمر.\n\n'
          'يظهر الدرع العربي على شكل شبه منحرف تبلغ مساحته حوالي (660,000 كم2) حيث يمثل الجزء الغربي من الجزيرة العربية، ويتميز بتنوع المعادن الفلزية مثل الذهب والفضة والنحاس والزنك والرصاص والحديد.',
    );
  }

  void _showArabianPlatform() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/arabian_platform.json');
    _mapController?.flyTo(latitude: 24.5, longitude: 48.0, zoom: 5.8);
    AppPopupDialog.show(
      context,
      title: 'الرصيف القاري العربي',
      imageAsset: AppAssets.arabianPlatform,
      description: 'يمثل الرصيف القاري العربي (الغطاء الرسوبي) الجزء الأكبر من أراضي المملكة العربية السعودية شرق الدرع العربي، ويشغل نحو ثلثي مساحة المملكة (حوالي 68%) وتقدر مساحته الإجمالية بـ 1,320,000 كم2.\n\n'
          'ترسبت الصخور الرسوبية فوق صخور القاعدة القديمة وتتألف من صخور رملية وجيرية ومتبخرات، ويحتوي على أضخم المكامن الهيدروكربونية (النفط والغاز) وخزانات المياه الجوفية العميقة والمعادن الصناعية كالفوسفات والبوكسيت.',
    );
  }

  void _showHarrat() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/harat.json');
    _mapController?.flyTo(latitude: 25.0, longitude: 40.0, zoom: 6.5);
    AppPopupDialog.show(
      context,
      title: 'الحرات البركانية',
      imageAsset: AppAssets.harat,
      description: 'الحرات البركانية عبارة عن هضاب بازلتية وتدفقات حمم بركانية تكونت خلال العصرين الثلاثي والرباعي نتيجة لانفتاح أخدود البحر الأحمر وانفصال الصفيحة العربية عن الصفيحة الإفريقية.\n\n'
          'تغطي الحرات مساحة تزيد عن 80,000 كم2 في المملكة وتنتشر في غرب وشمال غرب البلاد (حرة رهط، خيبر، كشب، عويرض، الحرة، الشاقة وغيرها).',
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Divider(),
          const Text(
            'قائمة الحرات الرئيسية:',
            style: TextStyle(fontFamily: 'NotoKufi', fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _haratInfo.values.map((h) {
              return ActionChip(
                backgroundColor: AppColors.mainMenuBtnBg,
                label: Text(h.title, style: const TextStyle(fontFamily: 'NotoKufi', fontSize: 14)),
                onPressed: () {
                  AppPopupDialog.show(context, title: h.title, description: h.desc);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showVolcanicActivity() {
    _mapController?.flyTo(latitude: 24.5, longitude: 39.8, zoom: 6.5);
    AppPopupDialog.show(
      context,
      title: 'النشاط البركاني',
      imageAsset: AppAssets.harat,
      description: 'شهدت شبه الجزيرة العربية نشاطاً بركانياً مكثفاً ارتبط بتصدع وانفتاح البحر الأحمر عبر ملايين السنين:\n\n'
          '• سجل التاريخ ثوران بركان المدينة المنورة الشهير عام 1256م (654هـ) في حرة رهط الشرقية، حيث تدفقت الحمم لمسافة وصلت إلى مقربة من المدينة المنورة.\n'
          '• في عام 2009م، شهدت حرة الشاقة (لونيير) نشاطاً زلزالياً وبركانياً وصعوداً للصهارة أدى إلى حدوث تشققات أرضية واسعة.\n'
          '• تنتشر في المملكة المئات من الفوهات البركانية الخامدة مثل فوهة الوعبة وفوهات جبل القدر والبيضاء.',
    );
  }

  void _showEarthquakes() {
    _mapController?.flyTo(latitude: 24.0, longitude: 42.0, zoom: 5.5);
    AppPopupDialog.show(
      context,
      title: 'الزلازل في شبه الجزيرة العربية',
      imageAsset: AppAssets.earth,
      description: 'يرتبط النشاط الزلزالي في شبه الجزيرة العربية بالحدود التكتونية الحركية للصفيحة العربية:\n\n'
          '• خليج العقبة وشمال البحر الأحمر: منطقة نشطة زلزالياً نتيجة الصدع التحويلي للبحر الميت.\n'
          '• محور انفتاح البحر الأحمر وخليج عدن: نشاط زلزالي متكرر مرافق لتوسع قاع البحر.\n'
          '• الحرات البركانية الغربية: حدوث أسراب زلزالية بركانية مرافقة لحركة الصهارة والغازات في باطن الأرض.\n'
          '• تتابع هيئة المساحة الجيولوجية السعودية عبر الشبكة الوطنية للرصد الزلزالي كافة الهزات بدقة عالية على مدار الساعة.',
    );
  }

  void _showSwahel() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/sahel.json');
    _mapController?.flyTo(latitude: 21.0, longitude: 40.0, zoom: 6.0);
    AppPopupDialog.show(
      context,
      title: 'السهول الساحلية',
      imageAsset: AppAssets.swahel,
      description: 'السهول الساحلية في المملكة العربية السعودية تضم السهل الساحلي للبحر الأحمر (سهل تهامة) في الغرب والسهول الساحلية للخليج العربي في الشرق.\n\n'
          'سهل تهامة: يمتد بمحاذاة البحر الأحمر من خليج العقبة شمالاً حتى الحدود مع اليمن جنوباً، ويتراوح اتساعه من بضعة كيلومترات في الشمال إلى أكثر من 40 كم في جازان جنوباً.\n\n'
          'سهول الخليج العربي: سهول منبسطة منخفضة تغطي الرمال والسباخ الساحلية أجزاء كبيرة منها وتتميز بوجود تكوينات المتبخرات والأحجار الجيرية البحرية الحديثة.',
    );
  }

  // ----------------------------------------------------
  // Section Button & Sub-item Builder Widgets
  // ----------------------------------------------------
  Widget _buildMainSectionHeader({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 58,
      margin: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 6),
      decoration: BoxDecoration(
        color: AppColors.mainMenuBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textBlack,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubItemButton({
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 3.5),
      decoration: BoxDecoration(
        color: AppColors.subMenuBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBrown,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FittedBox(
                    alignment: Alignment.centerRight,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textBlack,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'جيولوجية و جيومورفولوجية المملكة',
      initialStyleAsset: 'assets/maps/saudi_geo/saudigeo.json',
      onMapCreated: (controller) => _mapController = controller,
      sidebarContent: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ==========================================
            // Main Button 1: جيومورفولوجية المملكة
            // ==========================================
            _buildMainSectionHeader(
              title: 'جيومورفولوجية المملكة',
              onTap: _showGeomorphologyOverview,
            ),
            _buildSubItemButton(
              title: 'المرتفعات الغربية',
              onTap: _showWesternHighlands,
            ),
            _buildSubItemButton(
              title: 'الهضاب',
              onTap: _showPlatelays,
            ),
            _buildSubItemButton(
              title: 'التكوينات الرملية',
              onTap: _showSandFormations,
            ),
            _buildSubItemButton(
              title: 'الربع الخالي',
              onTap: _showEmptyQuarter,
            ),
            _buildSubItemButton(
              title: 'السهول الساحلية',
              onTap: _showSwahel,
            ),

            const SizedBox(height: 10),

            // ==========================================
            // Main Button 2: جيولوجية المملكة
            // ==========================================
            _buildMainSectionHeader(
              title: 'جيولوجية المملكة',
              onTap: _showIntroBrief,
            ),
            _buildSubItemButton(
              title: 'الدرع العربي',
              onTap: _showArabianShield,
            ),
            _buildSubItemButton(
              title: 'الرصيف القاري العربي',
              onTap: _showArabianPlatform,
            ),
            _buildSubItemButton(
              title: 'الحرات البركانية',
              onTap: _showHarrat,
            ),
            _buildSubItemButton(
              title: 'النشاط البركاني',
              onTap: _showVolcanicActivity,
            ),
            _buildSubItemButton(
              title: 'الزلازل في شبه الجزيرة العربية',
              onTap: _showEarthquakes,
            ),
          ],
        ),
      ),
    );
  }

  // Alias for plateaus spelling
  void _showPlatelays() => _showPlateaus();
}
