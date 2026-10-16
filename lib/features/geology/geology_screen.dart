import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/dialogs/app_popup_dialog.dart';
import '../../core/dialogs/pdf_viewer_dialog.dart';

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
    PdfViewerDialog.show(
      context,
      title: 'جيومورفولوجية المملكة',
      assetPath: 'assets/books/geology/geomorphology_intro.pdf',
    );
  }

  // ----------------------------------------------------
  // Harrat Continuation Block (Matches attached image)
  // ----------------------------------------------------
  Widget _buildHarratContinuationBlock() {
    // Top Row (Right to Left in RTL):
    final topRowKeys = [
      'hart_unayyir-bgxfcy', // حرة الشاقة_لونيير
      'hart_kishb-815dj1',    // حرة كشب
      'hart_khaybar-d6449k',  // حرة خيبر
      'hart_hadan-4qulnq',    // حرة حضن
      'hart_awarad-5bksz1',   // حرة عويرض
      'hart_alsarah-7t4hk2',  // حرة السراة
      'hart_alhtaymh-1yw1sy', // حرة الهتيمة
    ];

    // Bottom Row (Right to Left in RTL):
    final bottomRowKeys = [
      'hart_nawsaf_albogom-1i8dcl', // حرة نواصف البقوم
      'hart_rahat-2ojan9',          // حرة رهط
      'hart_alharh-9osy8j',         // حرة الحرة
      'sahal_thamah-8ryrba',        // حرات سهل تهامة
    ];

    Widget buildHarrahChip(String key) {
      final item = _haratInfo[key];
      if (item == null) return const SizedBox.shrink();

      return Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            AppPopupDialog.show(
              context,
              title: item.title,
              description: item.desc,
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6.5),
            decoration: BoxDecoration(
              color: const Color(0xFFFCF9F3),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFC7B19C),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 3,
                  offset: const Offset(0, 1.5),
                ),
              ],
            ),
            child: Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'NotoKufi',
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3E2D1D),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(color: Color(0xFFC7B19C), thickness: 1.0),
          const SizedBox(height: 4),
          const Align(
            alignment: Alignment.centerRight,
            child: Text(
              'قائمة الحرات الرئيسية:',
              style: TextStyle(
                fontFamily: 'NotoKufi',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E2218),
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Top Row: 7 chips
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: topRowKeys.map(buildHarrahChip).toList(),
          ),
          const SizedBox(height: 8),
          // Bottom Row: 4 chips
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: bottomRowKeys.map(buildHarrahChip).toList(),
          ),
        ],
      ),
    );
  }

  void _showIntroBrief() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/saudigeo.json');
    _mapController?.flyTo(latitude: 24.694291, longitude: 47.189224, zoom: 4.3);
    PdfViewerDialog.show(
      context,
      title: 'جيولوجية المملكة',
      assetPath: 'assets/books/geology/geology_intro.pdf',
    );
  }

  void _showWesternHighlands() {
    _mapController?.flyTo(latitude: 19.5, longitude: 42.0, zoom: 6.2);
    PdfViewerDialog.show(
      context,
      title: 'المرتفعات الغربية',
      assetPath: 'assets/books/geology/western_highlands.pdf',
    );
  }

  void _showPlateaus() {
    _mapController?.flyTo(latitude: 24.5, longitude: 45.0, zoom: 5.8);
    PdfViewerDialog.show(
      context,
      title: 'الهضاب',
      assetPath: 'assets/books/geology/plateaus.pdf',
    );
  }

  void _showSandFormations() {
    _mapController?.flyTo(latitude: 27.5, longitude: 42.0, zoom: 5.8);
    PdfViewerDialog.show(
      context,
      title: 'التكوينات الرملية',
      assetPath: 'assets/books/geology/sand_formations.pdf',
    );
  }

  void _showEmptyQuarter() {
    _mapController?.flyTo(latitude: 20.0, longitude: 50.0, zoom: 5.4);
    PdfViewerDialog.show(
      context,
      title: 'الربع الخالي',
      assetPath: 'assets/books/geology/empty_quarter.pdf',
    );
  }

  void _showSwahel() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/sahel.json');
    _mapController?.flyTo(latitude: 21.0, longitude: 40.0, zoom: 6.0);
    PdfViewerDialog.show(
      context,
      title: 'السهول الساحلية',
      assetPath: 'assets/books/geology/coastal_plains.pdf',
    );
  }

  void _showArabianShield() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/arabian_shield.json');
    _mapController?.flyTo(latitude: 23.5, longitude: 41.5, zoom: 6.0);
    PdfViewerDialog.show(
      context,
      title: 'الدرع العربي',
      assetPath: 'assets/books/geology/arabian_shield.pdf',
    );
  }

  void _showArabianPlatform() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/arabian_platform.json');
    _mapController?.flyTo(latitude: 24.5, longitude: 48.0, zoom: 5.8);
    PdfViewerDialog.show(
      context,
      title: 'الرصيف القاري العربي',
      assetPath: 'assets/books/geology/arabian_platform.pdf',
    );
  }

  void _showHarrat() {
    _mapController?.setStyleFromAsset('assets/maps/saudi_geo/harat.json');
    _mapController?.flyTo(latitude: 25.0, longitude: 40.0, zoom: 6.5);
    PdfViewerDialog.show(
      context,
      title: 'الحرات البركانية',
      assetPath: 'assets/books/geology/volcanic_harrat.pdf',
      continuationWidget: _buildHarratContinuationBlock(),
    );
  }

  void _showVolcanicActivity() {
    _mapController?.flyTo(latitude: 24.5, longitude: 39.8, zoom: 6.5);
    PdfViewerDialog.show(
      context,
      title: 'النشاط البركاني',
      assetPath: 'assets/books/geology/volcanic_activity.pdf',
    );
  }

  void _showEarthquakes() {
    _mapController?.flyTo(latitude: 24.0, longitude: 42.0, zoom: 5.5);
    PdfViewerDialog.show(
      context,
      title: 'الزلازل في شبه الجزيرة العربية',
      assetPath: 'assets/books/geology/earthquakes.pdf',
    );
  }

  bool _geomorphologyExpanded = false;
  bool _geologyExpanded = false;

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
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    return MapShell(
      title: 'جيولوجية و جيومورفولوجية المملكة',
      initialStyleAsset: 'assets/maps/saudi_geo/saudigeo.json',
      onMapCreated: (controller) => _mapController = controller,
      sidebarContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ==========================================
          // Main Button 1: جيومورفولوجية المملكة
          // ==========================================
          _buildMainSectionHeader(
            title: 'جيومورفولوجية المملكة',
            onTap: () {
              setState(() {
                _geomorphologyExpanded = !_geomorphologyExpanded;
              });
              _showGeomorphologyOverview();
            },
          ),
          if (_geomorphologyExpanded) ...[
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
          ],

          const SizedBox(height: 10),

          // ==========================================
          // Main Button 2: جيولوجية المملكة
          // ==========================================
          _buildMainSectionHeader(
            title: 'جيولوجية المملكة',
            onTap: () {
              setState(() {
                _geologyExpanded = !_geologyExpanded;
              });
              _showIntroBrief();
            },
          ),
          if (_geologyExpanded) ...[
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
        ],
      ),
    );
  }

  // Alias for plateaus spelling
  void _showPlatelays() => _showPlateaus();
}
