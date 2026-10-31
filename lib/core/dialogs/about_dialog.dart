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
                        'بوابة المصادر الجيومكانية',
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
                        'المحميات، حكاية الأرض ومخاطر الطبيعة',
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

  static void showNaturalResources(BuildContext context) => showMineralLocations(context);

  static Widget _buildStatBadge(String number, String label, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: TextStyle(
              fontFamily: 'NotoKufi',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'NotoKufi',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  static void showMineralLocations(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width > 900 ? 820.0 : size.width * 0.88;

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
              border: Border.all(
                color: AppColors.borderBrown.withOpacity(0.5),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Header with Title, Subtitle, and Close button
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'مواقع الصخور والمعادن الاقتصادية',
                            style: TextStyle(
                              fontFamily: 'NotoKufi',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.solidBrown,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'ثرواتنا من أرضنا',
                            style: TextStyle(
                              fontFamily: 'NotoKufi',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B221E),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 22,
                          color: AppColors.textDark,
                        ),
                      ),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const Divider(color: AppColors.borderBrown, thickness: 1.5),
                const SizedBox(height: 10),

                // Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Quick Metric Badges
                        Wrap(
                          spacing: 12,
                          runSpacing: 10,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildStatBadge('+5,300', 'موقع ومكمن ومؤشر معدني', const Color(0xFF8B221E)),
                            _buildStatBadge('42', 'معدنًا وصخرًا اقتصاديًا', const Color(0xFF7F4D2C)),
                            _buildStatBadge('800', 'موقع للنحاس', const Color(0xFFB87333)),
                            _buildStatBadge('700', 'موقع للذهب', const Color(0xFFD4AF37)),
                            _buildStatBadge('400', 'موقع للزنك', const Color(0xFF5A7282)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Introduction Paragraphs
                        const Text(
                          'تتميز المملكة بتنوع جيولوجي ومعدني كبير، وتنتشر مواقع ومكامن ومؤشرات الثروات المعدنية في مناطق واسعة من المملكة. وقد جرى في المنصة التفاعلية لعلوم الأرض والطبيعة تجميع وتصنيف وتمثيل أكثر من 5,300 موقع للثروات المعدنية والصخور الاقتصادية، وربطها بقاعدة بيانات مكانية وعرضها على الخرائط التفاعلية للمنصة.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 16,
                            height: 1.85,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          'وتضم قاعدة البيانات 42 معدنًا وصخرًا اقتصاديًا تم اختيارها وتصنيفها بعناية وفق أهميتها الجيولوجية والاقتصادية وتوافر المعلومات المكانية عنها. وتشمل المعادن الفلزية وغير الفلزية والصخور والخامات الصناعية ذات الأهمية الاقتصادية.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 16,
                            height: 1.85,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Text(
                          'وتوضح كثافة البيانات حجم التنوع المعدني في المملكة؛ فعلى سبيل المثال، تتضمن قاعدة البيانات نحو 800 موقع ومكمن ومؤشر للنحاس، ونحو 700 للذهب، ونحو 400 للزنك، إلى جانب آلاف المواقع المرتبطة بالمعادن والصخور الاقتصادية الأخرى.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 16,
                            height: 1.85,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Feasibility Callout
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFECC880)),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline_rounded,
                                color: Color(0xFF8B221E),
                                size: 22,
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'ولا تعني الإشارة إلى هذه المواقع بالضرورة أن جميعها احتياطيات معدنية مؤكدة أو مناجم قابلة للاستثمار اقتصاديًا؛ إذ تختلف المواقع في طبيعتها ودرجة دراستها بين مكامن وظهورات ومؤشرات معدنية ومواقع استكشافية ومناجم أو خامات موثقة. كما أن تحديد الجدوى الاقتصادية لأي موقع يتطلب دراسات جيولوجية واستكشافية وفنية واقتصادية مستقلة.',
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontFamily: 'NotoKufi',
                                    fontSize: 15,
                                    height: 1.8,
                                    color: AppColors.textDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Section 1: سياسة عرض الإحداثيات والبيانات المكانية
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.borderBrown.withOpacity(0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.policy_outlined,
                                    color: AppColors.solidBrown,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'سياسة عرض الإحداثيات والبيانات المكانية',
                                    style: TextStyle(
                                      fontFamily: 'NotoKufi',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solidBrown,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'حرصًا على الاستخدام المسؤول للمعلومات الجيولوجية والمكانية، واحترام مصادر البيانات وحقوق الجهات والأطراف ذات العلاقة، وعدم استخدام المعلومات خارج سياقها العلمي أو الاستثماري الصحيح، تعرض المنصة التوزيع الجغرافي والمعلومات العامة للصخور والمعادن الاقتصادية، بينما لا تُتاح الإحداثيات التفصيلية لبعض المواقع المعدنية بصورة مباشرة ومفتوحة للجميع. ويرجع ذلك إلى أن قاعدة البيانات جُمعت وطُورت بالاستفادة من مصادر وبيانات متعددة، وبعض المعلومات المكانية قد تكون مرتبطة بجهات أخرى أو خاضعة لشروط استخدام أو مشاركة، كما أن بعض المواقع تحتاج إلى التحقق من دقتها وتصنيفها قبل استخدامها لأغراض بحثية أو استثمارية. ويهدف هذا الإجراء إلى تحقيق التوازن بين إتاحة المعرفة الجيولوجية للجمهور والباحثين والمستثمرين من جهة، والمحافظة على سلامة استخدام البيانات واحترام الحقوق والضوابط المرتبطة بمصادرها من جهة أخرى.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontFamily: 'NotoKufi',
                                  fontSize: 15,
                                  height: 1.8,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Section 2: للباحثين والمستثمرين
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.borderBrown.withOpacity(0.35),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: const [
                                  Icon(
                                    Icons.business_center_outlined,
                                    color: AppColors.solidBrown,
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'للباحثين والمستثمرين',
                                    style: TextStyle(
                                      fontFamily: 'NotoKufi',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solidBrown,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'ترحب المنصة التفاعلية للأرض والطبيعة بطلبات الباحثين والجهات العلمية والمستثمرين الراغبين في الحصول على معلومات أكثر تفصيلًا عن معدن أو صخر اقتصادي أو نطاق جغرافي محدد. وتتم دراسة الطلبات كلٌ بحسب غرضه ونطاقه وطبيعة البيانات المطلوبة ومصدرها ومدى إمكانية مشاركتها، ويمكن توفير المعلومات المتاحة والمسموح بمشاركتها بما يخدم البحث العلمي والاستكشاف والاستثمار، دون أن يشكل ذلك ضمانًا لوجود احتياطي اقتصادي أو توصية استثمارية أو بديلًا عن الدراسات الفنية والقانونية والاقتصادية اللازمة.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontFamily: 'NotoKufi',
                                  fontSize: 15,
                                  height: 1.8,
                                  color: AppColors.textDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Section 3: Contact Email Card
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryBrown.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.solidBrown.withOpacity(0.4),
                            ),
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.mail_outline_rounded,
                                    color: AppColors.solidBrown,
                                    size: 22,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'للتواصل والاستفسارات المتعلقة بالبيانات المعدنية:',
                                    style: TextStyle(
                                      fontFamily: 'NotoKufi',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.solidBrown,
                                    ),
                                  ),
                                ],
                              ),
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.solidBrown.withOpacity(0.5),
                                    ),
                                  ),
                                  child: const SelectableText(
                                    'alamri.geo@gmail.com',
                                    style: TextStyle(
                                      fontFamily: 'NotoKufi',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8B221E),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(
                      fontFamily: 'NotoKufi',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
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
}
