import 'dart:convert';
import 'package:flutter/foundation.dart';
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
    'Wadi_Aba_Al_Qu': (path: 'assets/maps/valleys/Wadi_Aba_Al_Qu.geojson', color: const Color(0xFF1AA33F), nameAr: 'وادي أبا القور', length: 203.1),
    'Wadi_Aba_Ar_Ruwath': (path: 'assets/maps/valleys/Wadi_Aba_Ar_Ruwath.geojson', color: const Color(0xFFA31F1A), nameAr: 'وادي أبا الرواث', length: 173.8),
    'Wadi_Al_Ahsabah': (path: 'assets/maps/valleys/Wadi_Al_Ahsabah.geojson', color: const Color(0xFFA3411A), nameAr: 'وادي الأحسبة', length: 69.1),
    'Wadi_Al_Akhda': (path: 'assets/maps/valleys/Wadi_Al_Akhda.geojson', color: const Color(0xFF73A31A), nameAr: 'وادي الأخضر', length: 172.8),
    'Wadi_Al_Amq': (path: 'assets/maps/valleys/Wadi_Al_Amq.geojson', color: const Color(0xFF3CA31A), nameAr: 'وادي العمق', length: 117.2),
    'Wadi_Al_Batin': (path: 'assets/maps/valleys/Wadi_Al_Batin.geojson', color: const Color(0xFF1AA333), nameAr: 'وادي الباطن', length: 373),
    'Wadi_Al_Farshah': (path: 'assets/maps/valleys/Wadi_Al_Farshah.geojson', color: const Color(0xFF1AA333), nameAr: 'وادي الفرشة', length: 123.9),
    'Wadi_Al_Gharr': (path: 'assets/maps/valleys/Wadi_Al_Gharr.geojson', color: const Color(0xFF1AA375), nameAr: 'وادي الغر', length: 178.3),
    'Wadi_al_Ghinah': (path: 'assets/maps/valleys/Wadi_al_Ghinah.geojson', color: const Color(0xFF1AA375), nameAr: 'وادي الغينة', length: 120.4),
    'Wadi_Al_Hamal': (path: 'assets/maps/valleys/Wadi_Al_Hamal.geojson', color: const Color(0xFF1A93A3), nameAr: 'وادي الحمل', length: 163.4),
    'Wadi_Al_Hamd': (path: 'assets/maps/valleys/Wadi_Al_Hamd.geojson', color: const Color(0xFF1A75A3), nameAr: 'وادي الحمض', length: 402),
    'Wadi_Al_Hinu': (path: 'assets/maps/valleys/Wadi_Al_Hinu.geojson', color: const Color(0xFF1A45A3), nameAr: 'وادي الحنو', length: 111.4),
    'Wadi_Al_Jarir': (path: 'assets/maps/valleys/Wadi_Al_Jarir.geojson', color: const Color(0xFF251AA3), nameAr: 'وادي الجرير', length: 256.1),
    'Wadi_Al_Jizil': (path: 'assets/maps/valleys/Wadi_Al_Jizil.geojson', color: const Color(0xFF5C30C2), nameAr: 'وادي الجزل', length: 273.9),
    'Wadi_al_Judwal': (path: 'assets/maps/valleys/Wadi_al_Judwal.geojson', color: const Color(0xFF641CA3), nameAr: 'وادي الجدول', length: 160.2),
    'Wadi_Al_Khurmah': (path: 'assets/maps/valleys/Wadi_Al_Khurmah.geojson', color: const Color(0xFF7D1CA3), nameAr: 'وادي الخرمة', length: 209.4),
    'Wadi_Al_Lith': (path: 'assets/maps/valleys/Wadi_Al_Lith.geojson', color: const Color(0xFFA31C9C), nameAr: 'وادي الليث', length: 115.6),
    'Wadi_Al_Makhit': (path: 'assets/maps/valleys/Wadi_Al_Makhit.geojson', color: const Color(0xFFA31C7B), nameAr: 'وادي المخيط', length: 166.7),
    'Wadi_Al_Maqran': (path: 'assets/maps/valleys/Wadi_Al_Maqran.geojson', color: const Color(0xFFA31C5F), nameAr: 'وادي المقرن', length: 127.7),
    'Wadi_Al_Mira': (path: 'assets/maps/valleys/Wadi_Al_Mira.geojson', color: const Color(0xFFA31C40), nameAr: 'وادي المراء', length: 159.3),
    'Wadi_al_Qimra': (path: 'assets/maps/valleys/Wadi_al_Qimra.geojson', color: const Color(0xFFA31C29), nameAr: 'وادي القمراء', length: 195.3),
    'Wadi_Ar_Raka': (path: 'assets/maps/valleys/Wadi_Ar_Raka.geojson', color: const Color(0xFF7D803B), nameAr: 'وادي الركا', length: 270.9),
    'Wadi_Ar_Risha': (path: 'assets/maps/valleys/Wadi_Ar_Risha.geojson', color: const Color(0xFF61803B), nameAr: 'وادي الرشاء', length: 205.4),
    'Wadi_Ar_Rumah': (path: 'assets/maps/valleys/Wadi_Ar_Rumah.geojson', color: const Color(0xFF42803B), nameAr: 'وادي الرمة', length: 452.3),
    'Wadi_Arar': (path: 'assets/maps/valleys/Wadi_Arar.geojson', color: const Color(0xFF3B8050), nameAr: 'وادي عرعر', length: 193.6),
    'Wadi_As_Sahba': (path: 'assets/maps/valleys/Wadi_As_Sahba.geojson', color: const Color(0xFF3B8063), nameAr: 'وادي السهباء', length: 422),
    'Wadi_As_surrah': (path: 'assets/maps/valleys/Wadi_As_surrah.geojson', color: const Color(0xFF3B7B80), nameAr: 'وادي السرة', length: 249.6),
    'Wadi_Ash_Shu-bah': (path: 'assets/maps/valleys/Wadi_Ash_Shu-bah.geojson', color: const Color(0xFF3B6B80), nameAr: 'وادي الشعبة', length: 287.8),
    'Wadi_Baysh': (path: 'assets/maps/valleys/Wadi_Baysh.geojson', color: const Color(0xFF3B5480), nameAr: 'وادي بيش', length: 169.6),
    'Wadi_Bishah': (path: 'assets/maps/valleys/Wadi_Bishah.geojson', color: const Color(0xFF3B3C80), nameAr: 'وادي بيشة', length: 493.8),
    'Wadi_Bitat': (path: 'assets/maps/valleys/Wadi_Bitat.geojson', color: const Color(0xFF513B80), nameAr: 'وادي بطاط', length: 29.9),
    'Wadi_Damad': (path: 'assets/maps/valleys/Wadi_Damad.geojson', color: const Color(0xFF673B80), nameAr: 'وادي ضمد', length: 111.8),
    'Wadi_Dawqah': (path: 'assets/maps/valleys/Wadi_Dawqah.geojson', color: const Color(0xFF7E3B80), nameAr: 'وادي دوقة', length: 93.2),
    'Wadi_Fajr': (path: 'assets/maps/valleys/Wadi_Fajr.geojson', color: const Color(0xFF803B69), nameAr: 'وادي فجر', length: 287.6),
    'Wadi_Hali': (path: 'assets/maps/valleys/Wadi_Hali.geojson', color: const Color(0xFF803B4F), nameAr: 'وادي حلي', length: 181.6),
    'Wadi_Hamir': (path: 'assets/maps/valleys/Wadi_Hamir.geojson', color: const Color(0xFFDB6353), nameAr: 'وادي حامر', length: 138.2),
    'Wadi_Hanifah': (path: 'assets/maps/valleys/Wadi_Hanifah.geojson', color: const Color(0xFF9ADB53), nameAr: 'وادي حنيفة', length: 188.8),
    'Wadi_Hirjab': (path: 'assets/maps/valleys/Wadi_Hirjab.geojson', color: const Color(0xFF63DB53), nameAr: 'وادي هرجاب', length: 134.9),
    'Wadi_Hubuna': (path: 'assets/maps/valleys/Wadi_Hubuna.geojson', color: const Color(0xFF53DB85), nameAr: 'وادي حبونا', length: 159.4),
    'Wadi_Itwad': (path: 'assets/maps/valleys/Wadi_Itwad.geojson', color: const Color(0xFF53DBC9), nameAr: 'وادي عتود', length: 98.6),
    'Wadi_Najran': (path: 'assets/maps/valleys/Wadi_Najran.geojson', color: const Color(0xFF539ADB), nameAr: 'وادي نجران', length: 138.2),
    'Wadi_Nayyal': (path: 'assets/maps/valleys/Wadi_Nayyal.geojson', color: const Color(0xFF6A53DB), nameAr: 'وادي نيال', length: 173.8),
    'Wadi_Qatan': (path: 'assets/maps/valleys/Wadi_Qatan.geojson', color: const Color(0xFF9A53DB), nameAr: 'وادي قطن', length: 108),
    'Wadi_Ranyah': (path: 'assets/maps/valleys/Wadi_Ranyah.geojson', color: const Color(0xFFCB53DB), nameAr: 'وادي رنية', length: 395.1),
    'Wadi_Rash': (path: 'assets/maps/valleys/Wadi_Rash.geojson', color: const Color(0xFFDB53BC), nameAr: 'وادي راش', length: 33.4),
    'Wadi_Shuwayhat': (path: 'assets/maps/valleys/Wadi_Shuwayhat.geojson', color: const Color(0xFFDB538E), nameAr: 'وادي شويحط', length: 133.7),
    'Wadi_Tabalah': (path: 'assets/maps/valleys/Wadi_Tabalah.geojson', color: const Color(0xFFDB5353), nameAr: 'وادي تبالة', length: 126.3),
    'Wadi_Tarif': (path: 'assets/maps/valleys/Wadi_Tarif.geojson', color: const Color(0xFF197D05), nameAr: 'وادي طريف', length: 125),
    'Wadi_Tarj': (path: 'assets/maps/valleys/Wadi_Tarj.geojson', color: const Color(0xFF057D6F), nameAr: 'وادي ترج', length: 173.1),
    'Wadi_Tathlith': (path: 'assets/maps/valleys/Wadi_Tathlith.geojson', color: const Color(0xFF05337D), nameAr: 'وادي تثليث', length: 376),
    'Wadi_Turubah': (path: 'assets/maps/valleys/Wadi_Turubah.geojson', color: const Color(0xFF35057D), nameAr: 'وادي تربة', length: 177.7),
    'Wadi_Yabah': (path: 'assets/maps/valleys/Wadi_Yabah.geojson', color: const Color(0xFF7D054B), nameAr: 'وادي يبة', length: 139.9),
  };

final Map<String, ({String nameAr, String desc})> _mainFormations = {
    'saq': (
      nameAr: 'تكوين الساق',
      desc: 'يمتد من شمال غرب المملكة ( الحدود الأردنية ) حتى نفوذ السر جنوبا , ويبلغ امتدادة 1200 كيلومتر , وهو يتكون من الأحجار الرملية التي تعو إلى العصر الكمبري , ويقدر عمر مياة الساق بين 22 الف إلى 28 الف سنة ,ويتراوح عمق المياه في تكوين الساق بين 100م في منطقة الجنوب إلى 1850م في القصيم.\n،ويستفيد من الجزء الشرقي من التكوين منطقة القصيم مثل بريدة وعنيزة ومنطقة السر والأسياح وشرق حائل ومنطقة تبوك وتيماء. يعتبر أهم مكامن المياه في المملكة على الإطلاق، وذلك لأن متكون ساق يعلو صخور الدرع العربي المصمتة مباشرة بسمك متوسط يزيد على خمسمائة متر، ويغلب على تركيـبه الصخور الرملية عالية المسامية و النفاذية. ويتبع متكون ساق في عمره عصر الكمبري المتأخر/ الأوردو فيشي المبكر، وتغطي صخور المتكون مساحة تقدر بمئات الآلاف من الكيلومترات المربعة من أرض المملكة. وتبلغ مساحة الجزء المنكشف من متكون ساق أكثر من 65000 كيلومتر مربع، وتقدر تغذية هذا الجزء المنكشف بمياه الأمطار بحوالي 260 مليون متر مكعب في السنة. ويمتاز الخزان المائي في متكون ساق بوفرة إنتاجـه بصفة عامـة، وتـتراوح ملوحتـه في شمال المملكة بين 500 و 1500 ملليجرام / لتر. يتغذى الساق بواسطة هطول الامطار على منكشفه الواقع شمال المملكة وقدرت كمية التغذية بحوالي 230 مليون متر مكعب /سنة ومن السيول حوالي 20 مليون متر مكعب/سنة، وتعد مياه الساق من النوعية الجيدة .',
    ),
    'tabuk': (
      nameAr: 'تكوين تبوك',
      desc: 'يمتد تكوين تبوك جنوب وشرق الحدود الاردنية والى وادي الرمة جنوبا , حيث تبلغ مساحتة 100 الف كيلومتر مربع , كما ينفصل التكوين عن بعضة البعض بالحزام الرملي لصحراء النفوذ الكبرى , هذا ويظهر تكوين تبوك الى الغرب من النفوذ الكبير في ثلاث مناطق وهي تبوك والطويل والجوف , وتستفيد منه المناطق السابقة في تكوين الساق عدا منطقة السر. تـرجع مجموعـة تبوك إلى العصرين الأوردو فيشي المتوسط / السيلوري ، وتـتكون المجمـوعـة من ثلاث وحدات من الصخور الرملية المتبادلـة مع ثلاث وحدات من الصخور الطفلية. ويـبلغ متوسط سمك الوحدات الرملية الحاملـة للمياه في هذه المجموعـة حوالي 200 متر وإن كان سمك المجمـوعـة يتجاوز الألف متر في بعض الأماكن. ويغطي الجزء المنكشف منها مساحة تقدر بأكثر من مائة ألف كيلو متر مربع ، ومياه تلك المجموعـة جيدة إذ تتراوح ملوحتها بين 400 إلى 600 ملليجرام / لتر في المتوسـط وتزداد الملوحـة في الاتجاه الجنوبي، وتعتمد مناطق تبوك والقصيم على مياه تلك المكامن بالإضافـة إلى مياه مكمن متكون ساق. ويختلف سمك تكوين تبوك من منطقة لاخرى تبعا لوجود جميع اجزائه او بعضا منها، ويبلغ سمكة 1070 م ويوجد منكشفه في مناطق تبوك وتيماء وحائل والقصيم ويعتبر من أغنى التكوينات الحاملة للماء بالمملكة . ويبلغ عمر المياه في متكون تبوك اكثر من ثلاثين الف سنة وتم تقدير المخزون بحوالي 1300 مليون متر مكعب.',
    ),
    'wajid': (
      nameAr: 'تكوين الوجيد',
      desc: 'يوجد في جنوب ووسط المملكة، وتستفيد منه منطقة وادي الدواسر.  يمتد مابين وادي نجران وشرورة في الجنوب و وادي الدواسر في الشمال لمسافة 300 كم ولا يزيد عرضة عن 100 كم , ويتكون من الاحجار الرملية ذات الحبيبات الخشنة والناعمة ترجع إلى حقب الحياة القديمة ’ كما تقع الصخور الرملية لتكوين الوجيد على الصخور النارية والمتحولة ويتراوح سمك تكوين الوجيد من 200 إلى 900 متر . تغطي صخوره مساحـة في جنوب غربي المملكة تقدر بحوالي عشرين ألف كيلو متر مربع، بسمك متوسط في حدود 400 متر، وإن كان ذلك السمك يزداد تدريجيا كلما اتجهنا شرقاً ليصل إلى قرابـة الألف متر. وتتراوح أعماق مياهه من 100 إلى 1100 متر كما يقدر عمر مياهه بحوالي 300 ألف سنـة أو أكثر. وتقل الملوحـة في مياه تكوين الوجيد عن 1000 ملليجرام / لتر، وقدرت كمية مياه الأمطار التي تغذي المتكون بنحو 500 مليون متر مكعب سنوياً. وتستغل مياه الوجيد في وادي الدواسـر منذ 1966م حيث تندفن صخوره تحت متكونات أحدث عمراً بين وادي الدواسـر ووادي نجران، وتندفع شرقاً تحت الأجزاء الغربيـة من الربع الخالي إلى مسافـة كبيرة محتفظـة بتركيبها الرملي، مما يزيد في إمكانيـة تلك المكامن المائـية التي تشبـه مياهها في خواصها الكيميائية والطبيـعية مياه مكمن متكون ساق.',
    ),
    'minjur': (
      nameAr: 'تكوين المنجور',
      desc: 'يقع تكوين المنجور وسط المملكة والى الشرق من تكوين الساق وتبلغ مساحتة نحو 6500 كيلومتر مربع , وهو يتكون من الاحجار الرملية ذات الاصل القاري المتعددة الطبقات وتوجد عليها طبقات رقيقة من الصخور الجيرية والطفل والجبس . وهو يعتبر من التكوينات العميقة نسبياً حيث يوجد على أعماق تصل لأكثر من 1800م،  وتستفيد منه منطقة الرياض وسدير والوشم والخرج والأفلاج والسليل. يرجع متكون المنجور في العمر إلى الترياسي المتأخر / الجوراسي المبكر ويتكون من الرمل الخشن عالي المسامية والنفاذيـة، ولذلك فهو مشبع بالمياه. وقد درست عينات من مياهه من بئر الشميسي في الرياض فوجد أن عمرها يرجع إلى ما بين 35 و 40 ألف سنـة، بينما يرجـع عمر متكون ضرما إلى الجوراسي المتوسط ويغلب على تركيبـه الطفل والطفل الكلسي والحجر الجيري، وتتحول تلك الصخور في الجزء الجنوبي من المملكة إلى صخور رملية مما يسمح بتشبعها بالمياه فتشكل مع متكون المنجور- الذي تعلوه بصورة لا توافقية- خزاناً مائياً واحداً يطلق عليه مكمن المنجور / ضرما وذلك جـنوب خط عـرض °20 شمالاً، وتتراوح نسبـة الأمـلاح في مياه ذلك الخزان المائي بين 400 و 1500 ملليجرام / لتر. وتزداد الملوحـة باتجاه الشرق وكذلك مع زيادة العمق. وتبلغ مساحة منكشف المنجور حوالي 2500 كيلومتر مربع كما تصل سماكـة التكوين إلى 400 متر تشمل طبقتين حاملتين للمياه تحت السطحيـة. يعتبر المنجور واحد من الخزانات الجوفية المهمة ذات المياه الغزيرة في المملكة حيث تخترقه الكثير جدا من الابار في منطقة الرياض وما حولها وهو ذو مسامية ونفاذية عالية جدا. وتختلف خصائصه الهيدروليكية بدرجة كبيرة من مكان لاخر يتغذى المنجور بواسطة هطول الامطار على منكشفه وقدرت كمية التغذية بحوالي 85 مليون متر مكعب سنويا على امتداد منكشفه.',
    ),
    'biyadh': (
      nameAr: 'تكوين البياض',
      desc: 'يمتد تكوين البياض على شكل شريط هلالي من وادي الدواسر جنوبا حتى وادي العتش شمالا لمسافة 650 كلم ويبلغ عرض منكشفة 50 كلم في وادي الدواسر. وتوجد اجزاءه المحصورة المغطاه بمختلف الرسوبيات في المنطقة الشرقية والشمالية الشرقيه والربع الخالي وتمتد داخل حدود قطر والكويت والعراق، ومعظم اجزائه المحصورة مغطاه بالاحجار الرمليه لتكوين الوسيع وفي معظم المناطق خاصة في المنكشفات لا يمكن الفصل بين البياض والوسيع حيث يكونان وحدة مائية واحدة، يحد البياض من الأسفل تكوين البويب المكون من الاحجار الجيرية مع الاحجار الرملية والطفل. تكوين البياض قاري الاصل من العصر الطباشيري الاسفل ويتكون اساسا من حبيبات الرمل والاحجار الرملية مع طبقات رقيقة من الطفل والمارل والدلومايت والحجر الحديدي وتتغير السحنة في اتجاه الشرق من احجار رملية الى رمليه طفلية الى احجار جيريه. يبلغ اقصى سمك للمتكون 625 متر ويقل سمكة كلما اتجهنا شمالا. نوعية الياه في المتكون مالحة الى شديدة الملوحة وتبلغ كمية الاملاح الذائبة قرب المنكشف حوالي 1500 ملجم/لتر بينما تصل الى اكثر من 6000 ملجم/لتر في المنطقة الشرقية، اما في منطقه الخرج فان المياه ذ ات نوعيه جيده وتبلغ الاملاح الذائبه حوالي 550 -900 ملجم / لتر. يستغل تكوين البياض في مناطق الخرج ووادي السهبا ووادي نساح وخريص.',
    ),
    'wasii': (
      nameAr: 'تكوين الوسيع',
      desc: 'تتألف صخور تكوين الوسيع ، من صخور رملية رقيقة نسبيا ، وطفل وعدسات من الكربونات . ويمتد منكشف الوسيع حوالي 1450 كم من الربع الخالي في اتجاه الشمال على شكل قوس ضخم يمر تحت الطرف الغربي من النفود الكبير . يوجد منكشف الوسيع في شكل مقطع كامل في خشم الوسيع الواقع شمال وادي السهبا ، يمتد منكشف الوسيع مسافة 1460 كم على شكل شريط هلالي من شمال وادي الدواسر حتى النفوذ الكبير بالشمال حيث يختفى تحت كثبانه ثم يظهر على سطح الارض ثانية وينكشف بالقرب من سكاكا حيث يعرف بحجر رمل سكاكا، ويعلوه احجار جيرية تابعة لتكوين العرمة. يشكل متكونا البياض والوسيع وحدة مائية واحدة ويعتبر من خرانات المياة الجوفية الممتازة في المملكة . متكون الوسيع قاري الاصل ترسب في العصر الطباشيري الاوسط ويتكون من حبيبات رملية غير متماسكه متوسطة الى خشنة. يتراوح سمك التكوين بين 200 و230 م  ويزداد سمكه تجاه الشمال حتى يبلغ 285 م بالقرب من سكاكا.  ويبلغ اقصى سمك له في الجنوب 600 م تحت الربع الخالي. يغذى المتكون مع متكون البياض منطقة الرياض و حفر.الباطن وقدر مجموع ما يستخرج من هذه التكوين بواقع 75 مليون متر مكعب. يقدر حجم المخزون في تكون الوسيع تقريبا حوالي 57000 مليون متر مكعب. قدرت كمية التغذية السنوية للتكوين من مياه الامطار والسيول حوالي 419 مليون متر مكعب. تغذي طبقة الوسيع - البياض جبال طويق , ويقدر عمر الماء عند المنكشف بالقرب من خريص بنحو 16 الف سنة ويرجع متكونا البياض والوسيع إلى العصر الطباشيري المبكر والمتوسط،. وعلى الرغم من ذلك فإن كلا المتكونين يغلب عليهما الصخور الرملية عالية المسامية والنفاذيـة، التي يمتد ظاهرها لمسافات كبيرة تتعدى الألف كيلومتر في الطول وعشرات الكيلومترات في العرض، ولذا فكلاهما مشبع بالمياه، وغالباً ما يتصل الخزانان ليكونا مكمناً مائياً واحداً يعرف بـاسم مكمن البياض - الوسيع، الذي يعتبر من أوفر مكامن المياه بالمملكة، وتتراوح نسبـة الأملاح في مياه هذا المكمن المائي بين 550 و 6000 ملليجرام / لتر. ويقدر عمر المياه عند المنكشف بالقرب من خريص بنحو 16 ألف سنـة.',
    ),
    'radmaa': (
      nameAr: 'تكوين أم الرضمة',
      desc: ' يمتد من الحدود العراقية والاردنية في الشمال الى جنوب وادي الدواسر لمسافة 1200 كم ، ويتكون من الحجر الحبيبي الطباشيري والدولومايت وبعض الطفل الذي ينتمي الى الاصل الحجري , ويتفاوت سمك التكوين بشكل عام من الغرب الى الشرق ومن الشمال الى الجنوب , وتختلف نوعية مياهه تبعاً لبعده عن المناطق الساحلية. وتستفيد منه الظهران وشدقم والخبر والدمام وحرض وبعض المناطق في الإحساء ووادي المياه. يتبع متكون أم رضمة عصري الباليوسين المتأخر / الإيوسين المبكر ويتكون أساساً من صخور جيريـة تتحول بدورها إلى صخور رملية في الأجزاء الجنوبية الغربية من أرض المملكة. ويمتد ظاهر متكون أم رضمة في حزام يبلغ طوله 1200 كيلومتر، ويتراوح عرضه بين 60 و 120 كيلومتراً (من وادي الدواسر جنوباً إلى الحدود الشمالية للمملكة)، ثم يظهر مرة أخرى بتركيب صخري مغاير قليلاً في حوض وادي السرحان (حوض سكاكا- تبوك) من غرب عرعر إلى الحدود السعوديـة- الأردنيـة. ويبلغ متوسط سمك متكون أم رضمة في قطاعاتـه الظاهرة فوق سطح الأرض حوالي 250 متراً، ويزداد ذلك إلى حوالي 700 متر تحت سطح المنطقة الشرقية. والمتكون ملئ بحفر الإذابـة التي مكنتـه من تخزين كميات من مياه الأمطار. ونوعـية المياه في متكون أم رضمـة جيدة بالقرب من طبقاته حيث يبلغ مجموع الأملاح الذائبـة بها حوالي 1000 ملليجرام / لتر، إلا أن ذلك يزداد شرقاً وشمالاً ليصل إلى 4000 ملليجرام / لتر. وتتدهور خصائص مياهـه في المناطق الساحلية نظراً لتسرب بعض مياه الخليج إليه. وتقدر كمية مياه الأمطار التي تغذي هذا المكمن بنحو 2405 مليون متر مكعب سـنوياً. يعتبر تكوين أم الرضمة من أهم الخزانات الجوفية العذبة في المملكة حيث أن حجر الجير النقي ذو خصائص هيدروليكية لا مثيل لها في غيرها من التكاوين المائية فمساميته عالية ونفاذيته جيدة جدا.',
    ),
    'dammam': (
      nameAr: 'تكوين الدمام',
      desc: 'يمتد تكوين الدمام في مناطق متفرقة حول ساحل الخليج العربي , و يتكون من خمسة طبقات ( صخور ذات اصل بحري ) , غير ان هناك طبقتين فقط حاملتين للمياه وهما طبقة العلاة وطبقة الخبر , تتكون طبقة العلاة من الحجر الجيري الدلوميتي المسامي وفي أسفله طبقة مارل بينما تتكون طبقة الخبر من الحجر الجيري والحجر الجيري المارلي، وقد تعرضت الطبقتان لعوامل تعرية كيميائية ونتج منها شقوق وفجوات في كلتا الطبقتين مما أدى إلى زيادة نفاذيتها، وهناك اتصال مائي طبيعي بين الطبقتين. ويتراوح سمك تكوين الدمام من 50 الى 75 متر ويعتبر من أهم التكوينات المائية اقتصادياً نظراً لقلة عمقه وسهولة الحفر فيه ونوعية مياهه، وتستفيد منه الخبر والدمام والقطيف والهفوف. يظهر هذا المتكون في شرق المملكة ويرجـع إلى عصر الإيوسين المتوسط ويتكون أساساً من الحجر الجيري. ويعتبر متكون الدمام المكمن المائي الرئيس لشرقي الجزيرة العربية، وتظهر صخوره في حزام غير متصل يبلغ طوله حوالي 180 كيلومتراً، وعرضـه من حوالي خمسة كيلومترات إلى مائتي كيلومتر. مياه متكون الدمام غزيرة وهي مياه متوسطـة النوعيـة حيث تقل الأملاح الذائبـة فيها عن 2000 ملليجرام / لتر، إلا أن ملوحتها تزداد كلما اتجهنا شرقاً أو جـنـوباً حتى تصل إلى أكثر من 6000 ملليجرام / لتر في المناطق الساحلية. ويقدر عمر المياه في متكون الدمام بنحو 25 ألف سنـة ويتراوح سمك التكوين من 50 إلى 75 متراً. ويبلغ معدل التغذية السـنوية من مياه الأمطار 1601 مليون متر مكعب. وقدرت كمية المخزون في الأجزاء غير المحصورة بحوالي 5000 مليون متر مكعب بينما قدرات التغذية السنوية بحوالي 200 مليون متر مكعب.',
    ),
    'neojen': (
      nameAr: 'تكوين النيوجين',
      desc: 'ينتشر هذا التكوين في شرق المملكة بدءاً من وادي الدواسر جنوباً إلى وادي السرحان شمالاً , وهو يمتد ايضا تحت رمال الربع الخالي , ويتكون هذا التكوين من رسوبيات العصر الرباعي من الحجر الجيري وهو ذو اصل بحري ، وتعتمد الزراعة في وادي المياه ومنطقة الإحساء بشكل رئيس على هذا التكوين حيث تستمد معظم العيون الموجودة هناك مياهها منه. ينقسم التكوين إلى أربع طبقات وهي :متكون الهدروخ ويتكون من الطفل الطيني الأخضر وحجر الرمل الغريني الجيري والمارل الرمادي وبعض الجبس وحجر الجير الرملي، وهو يرتكز دون توافق على متكون الدمام ويبلغ سمكه حوال 85 كم، وعمره يتبع المبوسين المبكر. متكون الدام ويتكون من حجر الجير الرملي والمارل والطفل وقليل من حجر الرمل، ويعلو متكون الهدروخ وسمكه حوالي 90 م ويتبع عصر الميوسين الأوسط .متكون الهفوف ويتركب من حجر رملي ومارل رملي وحجر جيري رملي وكونجلوميرات ويصل سمكه إلى 95 م ويعلو متكون الدام، ويتبع عصر الميوسين المتأخر والبليوسين. متكون الخرج ويتركب من حجر الجير والجبس وطبقات من الكونجلوميرات والحصى والرمل الجبسي، ويصل سمكه إلى 28 م ويتبع عصر البليوسين. يزيد سمك هذه المتكونات عن 250 م في المنطقة الشرقية ويقل كلما اتجهنا إلى الغرب. ويعد تكوين النيوجين من التكوينات الهامة في منطقة الهفوف إذ يختزن كميات من كبيرة من المياه ومعظم مياه العيون والآبار في الإحساء تأتي من متكون النيوجين. تحوي هذه المكامن بين طبقاتها الكثير من أسطح التـعرية التي زادت من مساميتها ونفاذيتها الثانويتين فأصبحت تشكل أهم الخزانات المائيـة في منطقـة الأحساء حيث تتدفق العيون وتكثر الآبار. والخزان المائي في صخور هـذه المجموعـة هو في غالبيتـه خزان غير حبـيس، وإن كانت المياه تُحبَس في بعض أجزائه حبساً موضعياً نظراً لوجود بعض الراقات غير المنفذة بين تتـابع طبقاتـه. وتختلف نـوعيـة مياه خزانات صخور النيوجين من مكان إلى آخر باختلاف تركيب الصخور التي تحتويها، ويتراوح مجموع الأملاح المذابـة فيها بين 1000 و 4000 ملليجرام / لتر. وتقدر كمية التغذية بحوالي 328 مليون متر مكعب سنوياً.',
    ),
  };

  final Map<String, ({String nameAr, String desc})> _subFormations = {
    'joof': (
      nameAr: 'تكوين الجوف',
      desc: 'يتبع عصر الديفوني السفلى وتتكون طبقاته من صخور الطفل الغريني وحجر الرمل وحجر الجير والدلوميت. ويقع فوق متكون تبوك. وينكشف شمال شرق النفود ويمتد حتى الأردن. ويبلغ طول المنكشف 100 كم، ويحتفظ هذا التكوين بكميات متوسطة من الماء. يستغل المتكون في منطقة الجوف، ويبلغ معامل النقولية له 95 م /يوم، وملوحة مياهه 1200 ملجم/لتر. تغلب الصخور الرملية ذات الحبيبات الناعمة والمتوسطة على محتويات تكوين الجوف ويبلغ سمكه في المنطقة بين سكاكا وعرعر 431 متر إلا أن سمكه يصل في سكاكا إلى 700 متر وتتراوح إنتاجيته من المياه بين 16 – 24 لتر / ثانية كما تختلف الناقلية في الخزان حيث تتراوح بين 0.0011 و 0.002 م/ ثانية ويصل تركيز الأملاح في مياهه بالجوف إلى 700 ملجم/لتر.',
    ),
    'khuf': (
      nameAr: 'تكوين الخف',
      desc: 'يتبع عصر البرمي العلوي ويتركب أساساً من حجر الرمل وحجر الجير والطفل، وينكشف على طول حزام ضيق يحاذي الحافة الشرقية للدرع العربي ويبلغ سمكه حوالي 171 م. يغطي الخف تكوين الساق في القصيم وصخور الدرع العربي في الوسط. تتراوح نوعية مياهه ما بين 2000 – 3000 ملجم/لتر في القويعية، وتستغل مياهه في مناطق الدوادمي والقويعية والقصيم ووادي الدواسر.',
    ),
    'jilh': (
      nameAr: 'تكوين الجله',
      desc: 'يتبع العصر الترياسي ويتكون من الأحجار الرملية والطفل وبعض الأحجار الجيرية، ويمتد منكشفه على هيئة شريط ضيق عرضه يتراوح بين 8 الى 12 كم ويعلو الجله تكوين المنجور ويعلوه طفل سدير. يصل سمك الجله إلى 326 م. حفرت عدة آبار في مدينة الرياض تخترق منكتشف الجله إلا أن مياهها رديئة حيث بلغت ملوحته أكثر من 6000 ملجم/لتر في القصيم.',
    ),
    'darmaa': (
      nameAr: 'تكوين ضرماء',
      desc: 'يتبع الجوراسي الأوسط ويتكون من حجر الجير والطفل وتتغير سحنته إلى حجر رملي كلما اتجهنا إلى الشمال أو الجنوب. يمتد منكشفه لمسافة 900 كم، ويصل سمك التكوين إلى 375 م. وهو يعلو متكون مرات ويسفل متكون طويق، ويعتبر من التكاوين المائية الجيدة حينما تسود السحنة الرملية. يستغل المتكون في وادي الدواسر والزلفى وتتراوح ملوحة مياهه بين 400-500 ملجم/لتر.',
    ),
    'skaka': (
      nameAr: 'تكوين سكاكا',
      desc: 'يتبع العصر الكريتاوي (الطباشيري) الأوسط وله أهمية كبيرة في منطقة سكاكا . يتألف تكوين سكاكا من صخور رملية ويبلغ سمكه في سكاكا نحو 285 متر وإنتاجه في إقليم سكاكا 18 لتر / ثانية ويتراوح الناقلية فيه عند المنكشف بين 0.0003 و 0.0028 م/ ثانية ويصل تركيز الأملاح في مياهه بمحافظة سكاكا إلى 600 ملجم/ لتر .',
    ),
    'aruma': (
      nameAr: 'تكوين العرمه',
      desc: 'يتبع هذا التكوين العصر الكريتاوي العلوي ويوجد تحت تكوين أم رضه وفوق الوسيع. ينكشف لمسافة 1600 كم من وادي الدواسر جنوباً حتى الحدود العراقية، ويتكون من الدلوميت والطفل مع بعض حجر الرمل ويصل سمكه إلى 142 م. ويعتبر من التكاوين الجيدة وهو على اتصال بتكوين أم رضمه ولكنه أقل أهمية منه. مياه العرمة جيدة وتستغل في منطقة حفر الباطن وفي أجزاء من المنطقة الشرقية وفي رفحة وبدنه وتتراوح ملوحة مياهه بين 850 – 2100 ملجم / لتر.',
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
    await _clearValleyLines();
    await _mapController?.setStyleFromAsset('assets/maps/saudi_geo/sahel.json');
    await Future.delayed(const Duration(milliseconds: 200));

    if (kIsWeb && _mapController != null) {
      _mapController!.clearWebMarkers();
      for (final dam in _dams) {
        if (dam.latitude > 0.0 && dam.longitude > 0.0) {
          _mapController!.addWebMarker(
            latitude: dam.latitude,
            longitude: dam.longitude,
            iconAsset: AppAssets.droplet,
            id: '${dam.latitude}_${dam.longitude}',
            onTap: () => _showDamPopup(dam),
          );
        }
      }
      _mapController?.flyTo(latitude: 20.275332, longitude: 41.438495, zoom: 6.3);
      return;
    }

    if (_mapController?.pointAnnotationManager == null) return;
    final manager = _mapController!.pointAnnotationManager!;
    await manager.deleteAll();
    _annotationDamMap.clear();

    try {
      final ByteData byteData = await rootBundle.load(AppAssets.droplet);
      final Uint8List imageBytes = byteData.buffer.asUint8List();

      final optionsList = _dams
          .where((d) => d.latitude > 0.0 && d.longitude > 0.0)
          .map((dam) {
        return PointAnnotationOptions(
          geometry: Point(coordinates: Position(dam.longitude, dam.latitude)),
          image: imageBytes,
          iconSize: 0.35,
        );
      }).toList();

      final annotations = await manager.createMulti(optionsList);
      final validDams = _dams.where((d) => d.latitude > 0.0 && d.longitude > 0.0).toList();
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
    if (_mapController != null && dam.latitude > 0.0 && dam.longitude > 0.0) {
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

  Future<void> _clearValleyLines() async {
    final layerIds = _valleys.keys.toList();
    final sourceIds = _valleys.keys.map((k) => 'source-$k').toList();
    await _mapController?.clearGeoJsonLineLayers(layerIds, sourceIds);
  }

  // Draws all 52 valley GeoJSON lines on a sahel base map.
  Future<void> _addAllValleyLines() async {
    setState(() => _isLoading = true);
    try {
      if (kIsWeb) {
        _mapController?.clearWebMarkers();
      } else {
        await _mapController?.pointAnnotationManager?.deleteAll();
      }
      await _mapController?.setStyleFromAsset('assets/maps/saudi_geo/sahel.json');
      _mapController?.flyTo(latitude: 24.694291, longitude: 47.189224, zoom: 4.3);

      await Future.delayed(const Duration(milliseconds: 300));

      for (final entry in _valleys.entries) {
        final key = entry.key;
        final valley = entry.value;
        try {
          final geoJsonStr = await rootBundle.loadString(valley.path);
          final sourceId = 'source-$key';
          final layerId = key;
          final cv = valley.color.value;
          final r = ((cv >> 16) & 0xFF).toRadixString(16).padLeft(2, '0');
          final g = ((cv >> 8) & 0xFF).toRadixString(16).padLeft(2, '0');
          final b = (cv & 0xFF).toRadixString(16).padLeft(2, '0');
          final colorHex = '#$r$g$b';

          await _mapController?.addGeoJsonLineLayer(
            sourceId: sourceId,
            layerId: layerId,
            geoJsonString: geoJsonStr,
            colorHex: colorHex,
            lineWidth: 3.0,
          );
        } catch (e) {
          debugPrint('Valley layer $key error: $e');
        }
      }
    } catch (e) {
      debugPrint('_addAllValleyLines error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  Future<void> _showFormationPopup(String key, String title, String desc) async {
    if (kIsWeb) {
      _mapController?.clearWebMarkers();
    } else {
      await _mapController?.pointAnnotationManager?.deleteAll();
    }
    await _clearValleyLines();

    final styleAsset = 'assets/maps/water_formation/$key.json';
    await _mapController?.setStyleFromAsset(styleAsset);
    _mapController?.flyTo(latitude: 24.694291, longitude: 47.189224, zoom: 4.8);

    if (mounted) {
      AppPopupDialog.show(
        context,
        title: title,
        description: desc,
      );
    }
  }

  Future<void> _onBriefPressed() async {
    setState(() {
      _valleysExpanded = false;
      _damsExpanded = false;
      _mainFormationsExpanded = false;
      _subFormationsExpanded = false;
    });
    await _clearValleyLines();
    await _mapController?.setStyleFromAsset('assets/maps/water_formation/allformations.json');
    _mapController?.flyTo(latitude: 24.694291, longitude: 47.189224, zoom: 4.3);
    if (mounted) {
      WaterInfographicDialog.show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'مصادر المياه',
      onBriefPressed: _onBriefPressed,
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
                  _addAllValleyLines();
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
                  if (kIsWeb) {
                    _mapController?.clearWebMarkers();
                  } else {
                    _mapController?.pointAnnotationManager?.deleteAll();
                  }
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
