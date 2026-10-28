import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';
import '../widgets/map_view_platform.dart';

class AboutDialogs {
  static Future<void> _showStyledDialog(BuildContext context, WidgetBuilder builder) async {
    setModalOpenWeb(true);
    try {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: builder,
      );
    } finally {
      setModalOpenWeb(false);
    }
  }

  static void showIntroduction(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.75;

    _showStyledDialog(
      context,
      (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(maxHeight: size.height * 0.9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6EE),
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'نبذة تعريفية عن المشروع',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.solidBrown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderBrown, thickness: 1.5),
                const SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(
                          child: Text(
                            'بسم الله الرحمن الرحيم\nالحمد لله رب العالمين وبعد ...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'NotoKufi',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'تعزيزاً وتحقيقاً لرؤية المملكة 2030 في توطين واستثمار الثروات الطبيعية في المملكة وتوفير طاقة نظيفة صديقة للبيئة. قام الفريق العلمي والتقني المكون من:\n'
                          '• أ. د. عبد الله بن محمد العمري\n'
                          '• م. مشعل آل كدم\n'
                          '• م. عبد العزيز الدحيم\n'
                          '• م. مشاري الجهني\n'
                          '• م. محمد بن عراج\n'
                          '• م. نايف العتيبي\n\n'
                          'بتوظيف المعطيات والمعلومات الجيولوجية والجيوفيزيائية المتاحة في المملكة لتحقيق أهداف الرؤية من خلال رفع البيانات المعدنية والبترولية والمائية والزلزالية ومعالم السياحة الجيولوجية والآثار على خرائط تفاعلية ثلاثية الأبعاد عالية الدقة والتي تعتبر الأولى من نوعها وذلك لخدمة الجهات ذات العلاقة والباحثين والطلاب للحصول على المعلومة الجيولوجية بكل يسر وسهولة. سوف يقوم الفريق بتحميل الخرائط التفاعلية في الوسائط الاجتماعية والهواتف النقالة على شكل تطبيق.\n\n'
                          'وأخيراً لا يسعنا إلا أن نتقدم بخالص الشكر إلى هيئة المساحة الجيولوجية ووزارة البيئة والمياه والزراعة على تزويدنا بالمعلومات المعدنية والمائية والزلزالية بالإضافة إلى الاستفادة من الدراسات وقواعد البيانات المدرجة في موسوعة العمري في علوم الأرض وأطلسي المياه والمعادن.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 17,
                            height: 1.8,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Image.asset(
                            AppAssets.sign,
                            height: 80,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Center(
                          child: Text(
                            'أ. د. عبد الله بن محمد العمري\nرئيس الجمعية السعودية لعلوم الأرض والمشرف على المشروع',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'NotoKufi',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppColors.solidBrown,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showReferences(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.75;

    _showStyledDialog(
      context,
      (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(maxHeight: size.height * 0.9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6EE),
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'المصادر والمراجع',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColors.solidBrown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderBrown, thickness: 1.5),
                const SizedBox(height: 10),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'المصادر والمراجع العربية:\n\n'
                          '• أطلس المياه (1984). وزارة الزراعة والمياه - المملكة العربية السعودية - الرياض – 111 صفحة.\n'
                          '• أطلس المعادن الصناعية (2016). وكالة وزارة الطاقة والصناعة للثروة المعدنية – جدة - 130 صفحة.\n'
                          '• الثروات المعدنية في المملكة العربية السعودية (2016). وكالة وزارة الطاقة والصناعة للثروة المعدنية – جدة.\n'
                          '• قاعدة البيانات المعدنية والزلزالية (2023) - هيئة المساحة الجيولوجية – جدة.\n'
                          '• موسوعة العمري في علوم الأرض - 30 كتاب (2023). الجمعية السعودية لعلوم الأرض - الرياض.\n\n'
                          'المراجع الدولية (English References):\n\n'
                          '• Development of Mineral Exploration in the Kingdom of Saudi Arabia (1999), Ministry of Petroleum and Minerals, Saudi Arabia.\n'
                          '• Hamimi, Z., Fowler, A., Liégeois, J., Collins, A., Abdelsalam, M., Abd EI-Wahed, M. (Editors). The Geology of the Arabian-Nubian Shield, 2021, 786 P., Springer Nature Switzerland.\n'
                          '• Powers, R.W.; Ramirez, Leon F.; Redmond, C.D.; Elberg, E.L. Jr. (1963). Geology of the Arabian Peninsula: Sedimentary Geology of Saudi Arabia. USGS, PP 560-D, Washington, USA.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 17,
                            height: 1.9,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showRemoteSensing(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.75;

    _showStyledDialog(
      context,
      (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(maxHeight: size.height * 0.9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6EE),
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'الاستشعار عن بعد ونظم المعلومات الجغرافية (Remote Sensing & GIS)',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.solidBrown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderBrown, thickness: 1.5),
                const SizedBox(height: 10),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'تطبيقات الاستشعار عن بعد ونظم المعلومات الجغرافية في علوم الأرض:\n\n'
                          '• معالجة الصور الفضائية وبيانات الأقمار الصناعية عالية الدقة لاستكشاف التراكيب الجيولوجية.\n'
                          '• رصد التغيرات البيئية والطبوغرافية وتحديد مواقع التمعدنات والمسطحات المائية والأودية.\n'
                          '• بناء قواعد البيانات الجغرافية والطبقات المكانية المتكاملة لدعم اتخاذ القرار والتخطيط التنموي المستدام وفق رؤية المملكة 2030.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 18,
                            height: 1.9,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showNaturalReserves(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.75;

    _showStyledDialog(
      context,
      (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(maxHeight: size.height * 0.9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6EE),
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'المحميات الطبيعية في المملكة العربية السعودية',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.solidBrown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderBrown, thickness: 1.5),
                const SizedBox(height: 10),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'المحميات الملكية والطبيعية في المملكة:\n\n'
                          '• محمية الإمام عبد العزيز بن محمد الملكية ومحمية الملك عبد العزيز الملكية.\n'
                          '• محمية الوعول ومحمية عروق بني معارض ومحمية جزر فرسان البحرية.\n'
                          '• محمية الأمير محمد بن سلمان ومحمية الملك سلمان بن عبد العزيز الملكية.\n\n'
                          'تهدف هذه المحميات إلى صون التنوع الأحيائي، وحماية النظم البيئية والجيولوجية النادرة، وإعادة توطين الكائنات المهددة بالانقراض وتنشيط السياحة البيئية المستدامة.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 18,
                            height: 1.9,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showEncyclopedia(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.75;

    _showStyledDialog(
      context,
      (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(maxHeight: size.height * 0.9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6EE),
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'موسوعات وكتب علوم الأرض',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.solidBrown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderBrown, thickness: 1.5),
                const SizedBox(height: 10),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'الموسوعات والمؤلفات العلمية المرجعية:\n\n'
                          '• موسوعة العمري في علوم الأرض (سلسلة شاملة تضم أكثر من 30 مجلداً علمياً).\n'
                          '• أطلس المعادن الصناعية والثروات المعدنية في المملكة العربية السعودية.\n'
                          '• أطلس المياه والمصادر المائية الجوفية والسطحية.\n'
                          '• دراسات وأبحاث الجمعية السعودية لعلوم الأرض وهيئة المساحة الجيولوجية السعودية.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 18,
                            height: 1.9,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showHazards(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.75;

    _showStyledDialog(
      context,
      (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(maxHeight: size.height * 0.9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6EE),
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'المخاطر الجيولوجية والبيئية',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.solidBrown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderBrown, thickness: 1.5),
                const SizedBox(height: 10),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'رصد وتقييم المخاطر الجيولوجية والطبيعية في المملكة:\n\n'
                          '• مخاطر الزلازل والنشاط البركاني في الحرات البركانية وسواحل البحر الأحمر.\n'
                          '• الانهيارات الصخرية والانزلاقات الأرضية في المناطق الجبلية والمنحدرات.\n'
                          '• مخاطر السيول الجارفة والفيضانات في مجاري الأودية والأحواض المائية.\n'
                          '• زحف الرمال والكثبان الرملية وتأثيرها على البنية التحتية والمشاريع التنموية.\n'
                          '• الهبوط الأرضي والتكهفات الكارستية في التكوينات الجيرية والجبسية.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 18,
                            height: 1.9,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showNaturalResources(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.75;

    _showStyledDialog(
      context,
      (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
          ),
          backgroundColor: Colors.transparent,
          child: Container(
            width: dialogWidth,
            constraints: BoxConstraints(maxHeight: size.height * 0.9),
            decoration: BoxDecoration(
              color: const Color(0xFFFAF6EE),
              borderRadius: BorderRadius.circular(AppColors.borderRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.40),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'المصادر والثروات الطبيعية',
                        style: TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.solidBrown,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderBrown, thickness: 1.5),
                const SizedBox(height: 10),
                const Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'تكامل الثروات والمصادر الطبيعية في المملكة:\n\n'
                          '• الطاقة المتجددة (الطاقة الشمسية وطاقة الرياح والطاقة الحرارية الأرضية).\n'
                          '• الموارد التعدينية والفلزية والصناعية الواعدة في الدرع العربي والغطاء الرسوبي.\n'
                          '• الثروات المائية والأحواض الجوفية الاستراتيجية.\n'
                          '• الموارد النفطية والغاز الطبيعي التقليدي وغير التقليدي.\n'
                          '• المعالم السياحية والبيئية والمحميات الطبيعية المستدامة.',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 18,
                            height: 1.9,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
