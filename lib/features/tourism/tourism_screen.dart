import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../../core/constants/app_assets.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/dialogs/app_brief_dialog.dart';
import '../../core/dialogs/app_popup_dialog.dart';

class TourismLandmark {
  final String title;
  final String description;
  final String region;
  final double latitude;
  final double longitude;
  final String imageAsset;

  const TourismLandmark({
    required this.title,
    required this.description,
    required this.region,
    required this.latitude,
    required this.longitude,
    required this.imageAsset,
  });
}

class TourismScreen extends StatefulWidget {
  const TourismScreen({super.key});

  @override
  State<TourismScreen> createState() => _TourismScreenState();
}

class _TourismScreenState extends State<TourismScreen> {
  final List<TourismLandmark> _landmarks = const [
    // منطقة المدينة المنورة
    TourismLandmark(
      title: 'جبل الفيل',
      region: 'منطقة المدينة المنورة',
      latitude: 26.696954,
      longitude: 37.982290,
      imageAsset: 'assets/images/feel.jpg',
      description: 'جبل الفيل من العجائب الجيولوجية في مدينة العلا بالمملكة العربية السعودية ويقع ’’جبل الفيل’’ في منطقة متسعة تكسوها الرمال الذهبية على بعد 7 كم إلى جهة الشرق من محافظة العلا التابعة لمنطقة المدينة المنورة. وهو عبارة عن صخرة عملاقة من الحجر الرملي الطبيعي يبلغ ارتفاعها عن الأرض 52 مترا، ويجسد الجبل الشهير شكل خرطوم يلامس الأرض وجسد الفيل، ونُحت بفعل قوة الطبيعة على مدار ملايين السنين من عوامل الحتّ والتعرية بالرياح والماء. يعتبر من أقدم المعالم السياحية التاريخية الأثرية في المملكة. ',
    ),
    TourismLandmark(
      title: 'قوس مقرط الدبوس شمال العلا',
      region: 'منطقة المدينة المنورة',
      latitude: 27.049444,
      longitude: 37.765833,
      imageAsset: 'assets/images/daboos.jpg',
      description: 'يعد جبل القوس، المعروف أيضاً باسم ’مقرط الدبوس’ ويقع على بعد 60 كم شمال العلا، أحد أشهر التكوينات الصخرية في صحراء العلا، ويمتاز بهيكله على شكل الجسر، والذي يشبه قوس قزح محاط بسحابتين، هو مشهد نادر بالفعل، كما تحيط بهذا الجبل مترامي الأطراف من الحجر الرملي ماسات صحراوية شبه كريمة، ويمكنك مشاهدة هذه القطع متعددة الألوان من الكوارتز المضمنة في الصخرة نفسها والمنتشرة على الأرض المحيطة بها. نتج هذا القوس عن طريق عمليات التعرية والحت التفاضلية في صخور الحجر الرملي. ',
    ),
    TourismLandmark(
      title: 'غراميل العلا',
      region: 'منطقة المدينة المنورة',
      latitude: 27.359440,
      longitude: 37.795560,
      imageAsset: 'assets/images/gramel.jpg',
      description: 'غراميل هي منطقة جبلية في شمال غرب المملكة العربية السعودية، في محافظة العلا باتجاه منطقة تبوك التي تبعد عنها 300 كيلومتر، فهي تكوينات صخرية حمراء ذات أشكال متفاوتة نحتتها الرياح على مر الأزمنة، لتصبح أيقونة فريدة في مشهد صحراوي ساحر، وهي من المناطق المرتفعة التي يمكن رؤية مجرة درب التبانة بوضوح من خلالها. تقع أرض الغراميل على بعد ساعة تقريباً من وسط مدينة العلا، ويمكنك فيها اكتشاف مجموعة من الأعمدة الحجرية الرقيقة والداكنة والمعروفة باسم ’’الغراميل’’، تعد الغراميل بقايا جبل كان عملاقاً ، وهي أرضاً ليس لها مثيل، وتشعر فيها بالانتقال إلى كوكب آخر، وتظن أنك بين أطلال مدينة خاوية على عروشها.. بينما هي صخور داكنة مرتكزة كجذوع النخيل أو الأعمدة. الغراميل عبارة عن جبل كبير، لكنه تفتت إلى أعمدة رقيقة، تحتوي على أكاسيد الحديد، بما يجعلها تقاوم تغيرات المناخ، وعوامل التعرية، فتظل صامدة.',
    ),
    TourismLandmark(
      title: 'بركان جبل الملساء',
      region: 'منطقة المدينة المنورة',
      latitude: 24.384720,
      longitude: 39.830530,
      imageAsset: 'assets/images/malsaa.jpg',
      description: 'تحتوي حرة رهط على أكثر من 700 فوهة بركانية. وهي واحد من 12 حقلًا بركانيًا في المملكة تغطي ما يقارب من 80000 كيلومتر مربع. وتقع حرة رهط ضمن سلسلة الطفوح البركانية بمنطقة المدينة المنورة. ويعد الجزء الشمالي من حرة رهط أكثر أجزاء تلك الحرة نشاطًا، والتي تقع إلى الجنوب من المدينة المنورة. يقع بركان جبل الملساء في جنوب شرق المدينة المنورة، وهو أحدث بركان انفجر في أرض الحجاز وتحديدا في عام 654هـ 1256م وله فوهة مخروطية يصل عمقها إلى 40 مترًا ويتشكل في قاعها الصخور والتكلسات الكبريتية، وقد استمر ثورانه لعدة أيام، وكانت حممه البركانية سارية حتى مسافة 23كم، وقد توقف أطول لسان لهذه الحمم البركانية على بعد 8.2 كم من مسجد الرسول الكريم.',
    ),
    TourismLandmark(
      title: 'بركان جبل البيضاء بحرة خيبر',
      region: 'منطقة المدينة المنورة',
      latitude: 25.669430,
      longitude: 39.922700,
      imageAsset: 'assets/images/baidaa.jpg',
      description: 'حرة خيبر او بني رشيد واحدة من اكبر الحقول البركانية ،و تغطي مساحة تقدر بأكثر من 14،000 كيلومتر مربع الى الشمال من المدينة المنورة. يتكون جبل البيضاء والذي يأخذ اللون المائل للأبيض والمكونة من صخور بركانية من نوع الكومندايت، جعلت منه واحدة من أندر المعالم الجيولوجية في الجزيرة العربية، حيث يبلغ ارتفاعه قرابة 2000 متر عن سطح البحر، وتنبت بداخله الكثير من النباتات والأشجار الصحراوية المتنوعة. إن فوهة بركان جبل البيضاء يعد من أندر البراكين في جزيرة العرب والعالم.',
    ),
    TourismLandmark(
      title: 'جبل القدر',
      region: 'منطقة المدينة المنورة',
      latitude: 25.718060,
      longitude: 39.951650,
      imageAsset: 'assets/images/qadar.jpg',
      description: 'جبل القِدر هو جبل بركاني خامد يقع في منطقة المدينة المنورة غرب المملكة، ويقع تحديداً في حرة خيبر. يبلغ ارتفاع الجبل نحو 2022 م. تم تصنيفه واختياره ضمن أفضل 100 موقع جيولوجي من الاتحاد الدولي للعلوم الجيولوجية ومنظمة الأمم المتحدة للتربية والعلم والثقافة (اليونسكو). جبل القدر بحرة خيبر في المملكة العربية السعودية يعتبر من أكبر الحقول البركانية وضمن آخر البراكين التي ثارت قبل 1000 سنة وكونت شكلاً جمالياً خلاباً وهو مخروط بركاني كبير يبلغ ارتفاعه النسبي نحو 400 متر.',
    ),
    TourismLandmark(
      title: 'صخرة "العروسة"',
      region: 'منطقة المدينة المنورة',
      latitude: 27.428639,
      longitude: 38.073980,
      imageAsset: 'assets/images/arosa.jpg',
      description: 'صخرة "العروسة" ، التي تقع شمال محافظة العلا بقرابة 100كلم، هي واحدة من مئات التشكيلات الصخرية التي تشتهر بها المحافظة، تشابه بشكلها الفريد العروسة التي ترتدي فستان زفافها شُكّلت على مدى آلاف السنين. وباتت صخرة "العروسة" إحدى أهم المواقع السياحية التي يقصدها الزوار من مختلف المناطق، التي تتربع وسط مجموعة من الرمال والصخور الأخرى المتنوعة.',
    ),
    TourismLandmark(
      title: 'مدائن صالح',
      region: 'منطقة المدينة المنورة',
      latitude: 26.807941,
      longitude: 37.968962,
      imageAsset: 'assets/images/saleh.jpg',
      description: 'تقع مدائن صالح أو ما تُدعى بالحِجر في منطقة المدينة المنورة وتبُعد 20 كم شمال مدينة العُلا، تعود سميت مدائن صالح بهذا الاسم؛ لأنّ النبيّ صالح -عليه السلام- بُعث إلى سكّانها، وهم قوم ثمود؛ فنسبت إليه، قال تعالى: (وَإِلَى ثَمُودَ أَخَاهُمْ صَالِحًا). يعود غالبية الآثار في هذا الموقع الأثري إلى المملكة النبطيّة خلال فترة القرن الأول ميلادي، حيث تُعدّ مدائن صالح أكبر مُدن الأنباط بعد عاصمتهم البتراء. يضّم الموقع 131 مقبرة تمّ نحتها وبناؤها في الصخور المُحيطة.',
    ),
    TourismLandmark(
      title: 'جبل رضوى',
      region: 'منطقة المدينة المنورة',
      latitude: 24.568857,
      longitude: 38.308616,
      imageAsset: 'assets/images/radwa.jpg',
      description: 'جبل رضوى هو جبل يقع في محافظة ينبع بمنطقة المدينة المنورة ويبلغ ارتفاعه 2170 متراً. يعتبر من أشهر جبال المدينة المنورة ويتميز بارتفاعه وجماله وشهرته على مر التاريخ وهو من الجبال الوعرة التي يصعب صعودها ومن قمته ترى مدينة ينبع كاملة. ويتكون من أنواع عدة من الصخور، منها: الصخور النارية كالجرانيت، والصخور المتحولة كالنيس والشست، وتمتاز هذه المكونات بصلابتها ومقاومتها لعمليات التعرية.',
    ),

    // منطقة الرياض
    TourismLandmark(
      title: 'جبل طويق',
      region: 'منطقة الرياض',
      latitude: 24.085830,
      longitude: 46.163330,
      imageAsset: 'assets/images/towaiq.jpg',
      description: 'جبل طويق عبارة عن هضبة ضيقة من الصخر الجيري ويمتد لما يقارب 800 كلم من صحراء نفود الثويرات في الزلفي شمالًا وحتى مشارف وادي الدواسر والربع الخالي جنوبًا على شكل قوس (أو «طوق» لأنه يطوّق ويحيط بمنطقة واسعة) يتجه طرفاه نحو الغرب. وتنحدر السفوح الشرقية لطويق بشكل تدريجي، بخلاف الجانب الغربي الذي ينقطع بشكل مفاجئ. اشتهرت جبال طويق باسم نهاية العالم لأنها تتشابه بتضاريسها ومعالمها الجغرافية مع المطل الذي اشتهر في ’’جراند كانيون’’.',
    ),
    TourismLandmark(
      title: 'دحول عين هيت',
      region: 'منطقة الرياض',
      latitude: 24.487409,
      longitude: 46.997068,
      imageAsset: 'assets/images/ainhet.jpg',
      description: 'تقع دحول عين هيت في جنوب شرق مدينة الرياض بالقرب من مدينة الخرج، وتعتبر مدخلاً لخزان ماء جوفي واسع يقع على عمق كبير تحت سطح الأرض، وأشهر هذه الحفر هي ’’عين هيت’’، حيث اكتشف الجيولوجيون أول اكتشاف سطحي لصخر الأنهيدريت في المملكة، عندما كانوا في نزهة، ثم زار عدد من مستكشفي الكهوف ’’عين هيت’’ ووصلوا إلى حافة بحيرة تقع على مسافة 120 متراً تحت السطح.',
    ),
    TourismLandmark(
      title: 'كهف الطحالب الخضراء',
      region: 'منطقة الرياض',
      latitude: 26.459790,
      longitude: 47.233596,
      imageAsset: 'assets/images/green.jpg',
      description: '’’دحل الطحلب أو الدحل الأخضر’’ يعد أحد الروافد الاقتصادية للمملكة وفق رؤيتها 2030 لكونه ثروة وطنية لمعرفة التاريخ الجيولوجي والطبيعي للجزيرة العربية. يقع في الشمال الشرقي من مدينة الرياض، بالقرب من مركز شوية في هضبة الصمّان التي تفصلها عروق رمال الدهناء عن هضبة نجد. يتراوح عمر هذه الكهوف ما بين 55 - 65 مليون سنة.',
    ),
    TourismLandmark(
      title: 'مائدة جبال سنامة بوادي الدواسر',
      region: 'منطقة الرياض',
      latitude: 20.159930,
      longitude: 44.185010,
      imageAsset: 'assets/images/snamh.jpg',
      description: 'الموائد الصخرية أو ’’الفطر’’ يبلغ عددها في المملكة أكثر من مائة مائدة وهي عبارة عن تشكيلات صخرية جيومورفولوجية، تنتشر بشكل واسع في منطقة الغطاء الرسوبي وخصوصًا شمال المملكة بسبب انتشار طبقات الحجر الرملي التي يسهل تفتتها مع عوامل التجوية مع بعض الموائد الصخرية في منطقة الدرع العربي.',
    ),
    TourismLandmark(
      title: 'جبل التوباد',
      region: 'منطقة الرياض',
      latitude: 22.575653,
      longitude: 46.523759,
      imageAsset: 'assets/images/tobad.jpg',
      description: 'يقع جبل التوباد في مدينة الأفلاج جنوب غرب مدينة الرياض وتبعد عنها بمسافة تقدر بـ 350 كم، ويحظى جبل التوباد بشهرة بالغة في السعودية نظراً لأنه دليل وشاهد على قصة حب ليلى العامرية وقيس بن الملوح والتي نشأت في بداية القرن الأول الهجري بين عامي 24 و68 هجرياً ، وهو السبب الرئيس في تسميته بما يُعرف بـ”جبل الحب أو جبل العاشقين.',
    ),
    TourismLandmark(
      title: 'وادي الطوقي',
      region: 'منطقة الرياض',
      latitude: 25.456631,
      longitude: 46.537946,
      imageAsset: 'assets/images/toqy.jpg',
      description: 'يعد وادي الطوقي (والذي يعرف بشعيب الطوقي) أحد أطول الأودية في المملكة، ويتميز بالطبيعة الجبلية الفريدة، والشلالات الطبيعية، والصخور والأشجار وخاصة أشجار الطلح. يقع وادي الطوقي شمال شرق الرياض، ويمتد بطول 110 كيلو متر، مع انحدار 0.2 ميل لكل كيلو متر، ويبدأ من خشم الطوقي في العرمة وحتى الدهناء.',
    ),

    // منطقة القصيم
    TourismLandmark(
      title: 'صخرة عنترة',
      region: 'منطقة القصيم',
      latitude: 26.521830,
      longitude: 43.564060,
      imageAsset: 'assets/images/antra.jpg',
      description: 'تقع صخرة عنترة في مركز غاف في عيون الجواء بمنطقة القصيم .تحتوي واجهة الصخرة على مجموعة من النقوش الثمودية والأشكال الحيوانية المتنوعة وتدل هذه النقوش على الأهمية التي كانت تتمتع بها المنطقة خلال الفترة من القرنين الثاني قبل الميلاد إلى الأول أو الثاني الميلادية. وتعد صخرة عنترة من شواهد قصة حياة عنترة وابنة عمه عبلة.',
    ),
    TourismLandmark(
      title: 'جبل الحصان',
      region: 'منطقة القصيم',
      latitude: 26.788310,
      longitude: 43.467280,
      imageAsset: 'assets/images/hourse.jpg',
      description: 'يقع جبل الحصان في شمال منطقة القوارة أحد مراكز منطقة القصيم. حيث تبلغ مساحته 0.20 كيلومتر، ويبلغ ارتفاعه 2200 قدم عن سطح البحر.',
    ),

    // منطقة عسير
    TourismLandmark(
      title: 'قرية الحبلة',
      region: 'منطقة عسير',
      latitude: 18.036170,
      longitude: 42.859580,
      imageAsset: 'assets/images/hablah.jpg',
      description: 'تعتبر منطقة الحبلة من أهم مناطق الجذب السياحي في منطقة عسير، حيث أنها تتميز بالقطوع العمودية الطويلة في الجبال، وتتواجد على ارتفاع يزيد عن 2000 متر فوق سطح البحر، ويتم الأفراد من الرؤية من أعلى القطع لقرية الحبلة القديمة. الحبلة هي قرية آثرية وتراثية وسياحية ، وكان أصلها قرية عتيقة بُنيت منازلها من الحجارة وأسفل جرف صخري ينحدر 300 متر من حافة جبال السروات.',
    ),
    TourismLandmark(
      title: 'الأعمدة البازلتية',
      region: 'منطقة عسير',
      latitude: 18.103350,
      longitude: 41.696480,
      imageAsset: 'assets/images/columns.jpg',
      description: 'أحد أبرز المواقع المميزة في عسير الأعمدة البازلتية في وادي يعوض في محافظة الحرجة، وقرية دبسا في محافظة البرك بمنطقة عسير. وتشكلت الأعمدة البازلتية في أعقاب ثوران البراكين، حيث بردت حممها، وانكمشت، وتشقّقت متّخذة أشكالًا هندسية بأضلاع خماسية، وسداسية، وسباعية.',
    ),
    TourismLandmark(
      title: 'جبال تنومة',
      region: 'منطقة عسير',
      latitude: 18.970170,
      longitude: 42.145450,
      imageAsset: 'assets/images/tanoma.jpg',
      description: 'تقع «تنومة» شمال منطقة عسير على الطريق الواصل بين مدينتي الطائف وعلى بعد 150 كيلومتراً من مدينة أبها. وتتميز جبال تنومة بكثرة التراكيب التي تضمها حيث تشكل كتلاً صخرية ضخمة بارتفاعات شاهقة، وشلالات الماء العذب وخاصة أثناء هطول الأمطار الموسمية في الصيف.',
    ),
    TourismLandmark(
      title: 'جزيرة كدمبل',
      region: 'منطقة عسير',
      latitude: 18.151670,
      longitude: 41.536670,
      imageAsset: 'assets/images/kadmbl.jpg',
      description: 'تُعد جزيرة كدمبل الواقعة على ساحل منطقة عسير إحدى الجزر التابعة لمركز القحمة، من أجمل الجزر الطبيعية البكر التي تنتظر مستقبلاً واعداً، وتتميز برمالها البيضاء الملتفة حولها من ثلاث جهات، ويبرز جبلها الشامخ واقفاً كفوهة البركان في جهتها الغربية.',
    ),
    TourismLandmark(
      title: 'جبل الصايرة ( الجيل الجليدي)',
      region: 'منطقة عسير',
      latitude: 19.931080,
      longitude: 42.689222,
      imageAsset: 'assets/images/saira.jpg',
      description: 'يعتبر جبل الصايرة من أهم وأجمل المعالم في بيشة، حيث أنه يختلف عن الجبال المحيطة به التي يكسوها اللون الأسود، فهو يتميز بلونه الأبيض الذي ينتشر فيه بعض الأحجار الملونة من صخور المرو والكوارتز.',
    ),
    TourismLandmark(
      title: 'جبل السودة',
      region: 'منطقة عسير',
      latitude: 18.051137,
      longitude: 42.732394,
      imageAsset: 'assets/images/soda.jpg',
      description: 'يقع جبل السودة في المنطقة الجنوبية الغربية من المملكة ويبعُد حوالي 20 كيلومترًا عن مدينة أبها، ويحتل جبل سودة المرتبة الأولى كأعلى قمة جبلية بالمملكة حيث يصل ارتفاعه إلى 3015 متراً فوق مستوى سطح البحر.',
    ),
    TourismLandmark(
      title: 'مدينة جُرش',
      region: 'منطقة عسير',
      latitude: 18.202808,
      longitude: 42.824430,
      imageAsset: 'assets/images/jorash.jpg',
      description: 'تقع مدينة جُرش الأثرية بين جبل حمومة الأثري وجبل شكر بمحافظة أحد رفيدة على بعد ١٥ كيلاً جنوبي محافظة خميس مشيط، وتضم معثورات ومباني ضخمة يعود تاريخها إلى فترة ما قبل الإسلام والفترات الإسلامية المتعاقبة.',
    ),

    // منطقة جازان
    TourismLandmark(
      title: 'العيون الحارة بالخوبة',
      region: 'منطقة جازان',
      latitude: 17.270841,
      longitude: 43.217098,
      imageAsset: 'assets/images/ainkoba.jpg',
      description: 'تقع ينابيع الخوبة على بعد 75 كلم من وسط مدينة جيزان وهي تتميز بمياهها الساخنة المناسبة للعلاج الطبيعي، وتصل درجة الحرارة في المياه إلى 45 درجة مئوية وتحتوي على 14 مادة كيميائية ومعدنية تفيد في الاستشفاء.',
    ),
    TourismLandmark(
      title: 'وادي لجب',
      region: 'منطقة جازان',
      latitude: 17.604420,
      longitude: 42.930650,
      imageAsset: 'assets/images/lojb.jpg',
      description: 'صدع وانكسار جيولوجي في الجزء الشرقي من جبل القهر (زهوان) بمحافظة الريث، لا يتجاوز عرضه أربعة أمتار بينما ترتفع حوافه الصخرية الشاهقة لأكثر من 800 متر مع تدفق الينابيع والشلالات العذبة.',
    ),
    TourismLandmark(
      title: 'جزيرة فَرَسان',
      region: 'منطقة جازان',
      latitude: 16.711670,
      longitude: 42.000000,
      imageAsset: 'assets/images/farasan.jpg',
      description: 'أرخبيل من الجزر المرجانية البكر يضم 150 جزيرة في البحر الأحمر بمساحة تتجاوز 1050 كم²، وتعد محمية طبيعية غنية بالشعاب المرجانية وغزال فرسان والطيور النادرة وآثار القلاع العثمانية والبيوت النجدية القديمة.',
    ),
    TourismLandmark(
      title: 'جبال فيفا',
      region: 'منطقة جازان',
      latitude: 17.741230,
      longitude: 43.002963,
      imageAsset: 'assets/images/fifa.jpg',
      description: 'جبال فيفا أو جارة القمر تقع شرق جازان وترتفع لنحو 7 آلاف قدم عن سطح البحر، وتتميز بمدرجاتها الزراعية الخضراء الساحرة وقممها التي تلفها السحب والضباب وأجوائها المعتدلة طوال العام.',
    ),

    // منطقة تبوك
    TourismLandmark(
      title: 'صخرة تيماء',
      region: 'منطقة تبوك',
      latitude: 27.229630,
      longitude: 38.571670,
      imageAsset: 'assets/images/taima.jpg',
      description: 'صخرة أو حصاة النصلة جنوب تيماء بقرابة 70 كم، كتلة صخرية ضخمة انشطرت إلى نصفين بشكل هندسي مذهل بفعل الطبيعة وتستند على قاعدتين رقيقتين وتحمل نقوشاً ثمودية وصوراً لحيوانات تعود لآلاف السنين.',
    ),
    TourismLandmark(
      title: 'وادي الديسة',
      region: 'منطقة تبوك',
      latitude: 27.602180,
      longitude: 36.420430,
      imageAsset: 'assets/images/desa.jpg',
      description: 'وادي قراقر أو الديسة جنوب تبوك، مضيق جبلي ساحر تنتصب فيه جبال الحجر الرملي الحمراء كأعمدة وقصور شاهقة، وتجري في وسطه عيون الماء العذبة وتنتشر فيه أشجار النخيل والحمضيات والريحان البري.',
    ),
    TourismLandmark(
      title: 'جزيرتا تيران وصنافير',
      region: 'منطقة تبوك',
      latitude: 27.942780,
      longitude: 34.566670,
      imageAsset: 'assets/images/teran.jpg',
      description: 'جزيرتان استراتيجيتان عند مدخل خليج العقبة في البحر الأحمر، تتميزان بشعابهما المرجانية العائمة والمياه الكريستالية الصافية والسلاحف والأسماك النادرة، وتعدان مقصداً عالمياً للغوص.',
    ),
    TourismLandmark(
      title: 'جبل الغلالة',
      region: 'منطقة تبوك',
      latitude: 26.250962,
      longitude: 37.214550,
      imageAsset: 'assets/images/galala.jpg',
      description: 'جبل الغلالة يقع بين العلا وتيماء، ويتميز بكهوفه وتجاويفه العجيبة التي كانت استراحة للمسافرين والقوافل قديماً، وورد ذكره في أشعار جميل بثينة.',
    ),
    TourismLandmark(
      title: 'جبل اللوز',
      region: 'منطقة تبوك',
      latitude: 28.645891,
      longitude: 35.286090,
      imageAsset: 'assets/images/loza.jpg',
      description: 'أعلى قمم منطقة تبوك بارتفاع 2549 متراً عن سطح البحر في جبال حسمى، يكتسي بالثلوج البيضاء شتاءً ويضم رسوماً صخرية أثرية يعود تاريخها لنحو 10 آلاف عام قبل الميلاد.',
    ),

    // منطقة مكة المكرمة
    TourismLandmark(
      title: 'مقلع طمية',
      region: 'منطقة مكة المكرمة',
      latitude: 22.901400,
      longitude: 41.139196,
      imageAsset: 'assets/images/taimaa2.jpg',
      description: 'فوهة الوعبة (مقلع طمية) أضخم فوهة بركانية في الشرق الأوسط بعمق 380 متراً وقطر 3 كم في حرة كشب، يتوسط قاعها سطح ملحي ناصع البياض يلمع مع أشعة الشمس.',
    ),
    TourismLandmark(
      title: 'جزيرة أم العود ',
      region: 'منطقة مكة المكرمة',
      latitude: 19.683330,
      longitude: 40.738890,
      imageAsset: 'assets/images/oud.jpg',
      description: 'جزيرة مرجانية خلابة قبالة رأس محيسن في البحر الأحمر، تمتاز برمالها البيضاء البكر والشعاب المرجانية المتنوعة والطيور البحرية النادرة وأشجار القرم.',
    ),
    TourismLandmark(
      title: 'جبال الدخول وحومل',
      region: 'منطقة مكة المكرمة',
      latitude: 22.233025,
      longitude: 43.569573,
      imageAsset: 'assets/images/dakol.jpg',
      description: 'معلم تاريخي وأدبي شهير في عالية نجد خلدته معلقة امرئ القيس الخالدة: "قفا نبكِ من ذكرى حبيب ومنزل بسقط اللوى بين الدخول فحومل"، عبارة عن تشكيلات صخرية سوداء وحمراء.',
    ),

    // منطقة حائل
    TourismLandmark(
      title: 'كهف شعيفان ’’الشويمس’’',
      region: 'منطقة حائل',
      latitude: 28.013156,
      longitude: 41.005101,
      imageAsset: 'assets/images/shoimes.jpg',
      description: 'أحد أطول وأهم الكهوف والأنفاق البركانية في المملكة بحرة النار قرب الشويمس، يمتد لنحو 2 كم وبارتفاع يصل إلى 8 أمتار، ويحتوي على تكوينات صخرية بازلتية عجيبة.',
    ),
    TourismLandmark(
      title: 'النقوش الصخرية في حائل',
      region: 'منطقة حائل',
      latitude: 26.158031,
      longitude: 40.266288,
      imageAsset: 'assets/images/hail.jpg',
      description: 'موقع مسجل في قائمة التراث العالمي لليونسكو في جبة والشويمس، يضم آلاف الرسوم والنقوش المنحوتة في الحجر الرملي التي توثق حياة الإنسان والحيوانات عبر 14 ألف عام.',
    ),

    // المنطقة الشرقية
    TourismLandmark(
      title: 'جزيرة تاروت',
      region: 'المنطقة الشرقية',
      latitude: 26.573610,
      longitude: 50.066670,
      imageAsset: 'assets/images/taroot.jpg',
      description: 'ثاني أكبر جزر المملكة في الخليج العربي قبالة القطيف، تعد من أقدم المستوطنات البشرية في شبه الجزيرة العربية منذ أكثر من 5000 سنة قبل الميلاد وتضم قلعة تاروت الفينيقية البرتغالية الشهيرة.',
    ),
    TourismLandmark(
      title: 'جزيرة حرقوص',
      region: 'المنطقة الشرقية',
      latitude: 27.930560,
      longitude: 49.681940,
      imageAsset: 'assets/images/harqoos.jpg',
      description: 'جزيرة مرجانية رملية في الخليج العربي تبعد 80 كم عن الجبيل الصناعية، تعد أهم موطن طبيعي لتعشيش السلاحف البحرية والطيور المهاجرة والشعاب المرجانية الفريدة.',
    ),
    TourismLandmark(
      title: 'كهوف جبل القارة',
      region: 'المنطقة الشرقية',
      latitude: 25.412089,
      longitude: 49.692674,
      imageAsset: 'assets/images/caves.jpg',
      description: 'جبل القارة بالأحساء مسجل بالتراث العالمي لليونسكو، صخور رسوبية جيرية ذات تكسرات وشقوق شكلت شبكة كهوف وممرات هوائية باردة صيفاً ودافئة شتاءً ترتفع 210 أمتار عن سطح البحر.',
    ),
    TourismLandmark(
      title: 'واحة الاحساء',
      region: 'المنطقة الشرقية',
      latitude: 25.413592,
      longitude: 49.638843,
      imageAsset: 'assets/images/ahsaa.jpg',
      description: 'أكبر واحة نخيل في العالم مسجلة في موسوعة غينيس والتراث العالمي لليونسكو، تضم أكثر من 3 ملايين نخلة تتغذى من طبقات المياه الجوفية والعيون الارتوازية المتدفقة منذ القدم.',
    ),

    // منطقة الجوف
    TourismLandmark(
      title: 'قرية كاف',
      region: 'منطقة الجوف',
      latitude: 31.397084,
      longitude: 37.494812,
      imageAsset: 'assets/images/kaf.jpg',
      description: 'قرية أثرية وتاريخية تبعد 20 كم عن القريات، تشتهر بعيونها الكبريتية الجارية المستخدمة في الاستشفاء وبساتين النخيل وقصر كاف وقلعة الصعيدي النبطية على قمة الجبل المطل.',
    ),

    // منطقة نجران
    TourismLandmark(
      title: 'آبار حمى',
      region: 'منطقة نجران',
      latitude: 18.250665,
      longitude: 44.451402,
      imageAsset: 'assets/images/hema.jpg',
      description: 'موقع التراث العالمي لليونسكو في نجران، يضم آباراً صخرية تاريخية ومسار قوافل يزخر بمئات اللوحات الصخرية والنقوش بالخطوط الثمودية والمسند والكوفي الممتدة لآلاف السنين.',
    ),
    TourismLandmark(
      title: 'الأُخدود',
      region: 'منطقة نجران',
      latitude: 17.478322,
      longitude: 44.181214,
      imageAsset: 'assets/images/akdod.jpg',
      description: 'مدينة الأخدود الأثرية على ضفاف وادي نجران (رقمات قديماً)، تعود للقرن الخامس قبل الميلاد وتضم أسواراً حجرية مشذبة ضخمة ونقوش مسندية ورسوماً خلدت الحادثة التاريخية المذكورة في القرآن الكريم.',
    ),
  ];

  static const List<String> _regionNames = [
    'منطقة المدينة المنورة',
    'منطقة الرياض',
    'منطقة القصيم',
    'منطقة عسير',
    'منطقة جازان',
    'منطقة تبوك',
    'منطقة مكة المكرمة',
    'منطقة حائل',
    'المنطقة الشرقية',
    'منطقة الجوف',
    'منطقة نجران',
  ];

  MapShellController? _mapController;
  String? _expandedRegion;
  final Map<String, TourismLandmark> _annotationLandmarkMap = {};

  Future<void> _loadMarkers(MapShellController controller) async {
    if (kIsWeb) {
      controller.clearWebMarkers();
      for (final landmark in _landmarks) {
        controller.addWebMarker(
          latitude: landmark.latitude,
          longitude: landmark.longitude,
          iconAsset: AppAssets.markerIcon,
          id: '${landmark.latitude}_${landmark.longitude}',
          onTap: () {
            _showLandmark(landmark);
          },
        );
      }
      return;
    }

    final manager = controller.pointAnnotationManager;
    if (manager == null) return;

    try {
      final ByteData byteData = await rootBundle.load(AppAssets.markerIcon);
      final Uint8List imageBytes = byteData.buffer.asUint8List();

      final optionsList = _landmarks.map((landmark) {
        return PointAnnotationOptions(
          geometry: Point(coordinates: Position(landmark.longitude, landmark.latitude)),
          image: imageBytes,
          iconSize: 0.25,
        );
      }).toList();

      final annotations = await manager.createMulti(optionsList);
      for (int i = 0; i < annotations.length && i < _landmarks.length; i++) {
        final ann = annotations[i];
        if (ann != null) {
          _annotationLandmarkMap[ann.id] = _landmarks[i];
        }
      }

      manager.addOnPointAnnotationClickListener(
        AppPointAnnotationClickListener((annotation) {
          final landmark = _annotationLandmarkMap[annotation.id];
          if (landmark != null) {
            _showLandmark(landmark);
          }
        }),
      );
    } catch (e) {
      debugPrint('Error creating tourism annotations: $e');
    }
  }

  void _showLandmark(TourismLandmark landmark) {
    _mapController?.flyTo(
      latitude: landmark.latitude,
      longitude: landmark.longitude,
      zoom: 9.5,
    );
    AppPopupDialog.show(
      context,
      title: landmark.title,
      description: landmark.description,
      imageAsset: landmark.imageAsset,
    );
  }

  void _showIntroBrief() {
    AppBriefDialog.show(
      context,
      title: 'السياحة والآثار',
      description: 'ظهر مفهوم السياحة الجيولوجية للمرة الأولى في 1995م من قِبل توماس هوز، لتشكّل وسيلة لتعزيز الحفظ الجغرافي وفهم التراث، كما تعزز المسؤولية البيئية والاجتماعية والاستدامة. السياحة الجيولوجية الآن هي جزء من السياحة الجغرافية كما تركّز على السمات غير الحيوية مثل التراكيب الجيولوجية من فوالق وطيات وعلى فوهات البراكين الخامدة ومجموعة كبيرة جداً من الأحافير من كل الأزمنة الجيولوجية.\n'
          'تحظى المملكة بالعديد من المواقع الجيولوجية في جميع مناطقها ومدنها، بسبب التنوع الجغرافي لها، وبدأ استغلال هذه الطبيعة لتكون جزءاً مهماً من التنمية السياحية. إن السياحة الجيولوجية في المملكة تمتاز بمساحتها الشاسعة وطبيعتها المتنوعة من صحراء وبحار وجبال وأودية وسواحل، كل ذلك مكّن السائحين من الاستمتاع بتجارب استكشافية لمعالم يعود تاريخها إلى آلاف السنين.\n'
          'إن المملكة متحف جيولوجي مفتوح تكشف فيه الصخور عن معظم العصور الجيولوجية، بدءاً من صخور القاعدة التي تشكل صخور الدرع العربي، تعلوها صخور دهر الحياة الظاهرة، وفي ظل رؤية 2030 تستثمر المملكة هذا الإرث الجيولوجي والسياحي كرافد اقتصادي وتراثي وطني عظيم.',
    );
  }

  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'السياحة والآثار',
      onBriefPressed: _showIntroBrief,
      briefButtonText: 'مقدمة',
      onMapCreated: (c) {
        _mapController = c;
        _loadMarkers(c);
      },
      sidebarContent: Column(
        children: _regionNames.map((regionName) {
          final isExpanded = _expandedRegion == regionName;
          final regionLandmarks = _landmarks.where((l) => l.region == regionName).toList();

          return Column(
            children: [
              CustomButton(
                text: regionName,
                styleType: ButtonStyleType.mainMenu,
                onPressed: () {
                  setState(() {
                    if (_expandedRegion == regionName) {
                      _expandedRegion = null;
                    } else {
                      _expandedRegion = regionName;
                      if (regionLandmarks.isNotEmpty && _mapController != null) {
                        _mapController!.flyTo(
                          latitude: regionLandmarks.first.latitude,
                          longitude: regionLandmarks.first.longitude,
                          zoom: 7.0,
                        );
                      }
                    }
                  });
                },
              ),
              if (isExpanded)
                ...regionLandmarks.map(
                  (landmark) => CustomButton(
                    text: landmark.title,
                    styleType: ButtonStyleType.subMenu,
                    onPressed: () => _showLandmark(landmark),
                  ),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
