// Generated Geospatial Sources Dialog from geospatial_am_my3.xlsx
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:js' as js;
import '../theme/app_theme.dart';
import '../widgets/map_view_platform.dart';

class GeospatialSourceItem {
  final String id;
  final String section;
  final String sourceAr;
  final String sourceEn;
  final String entity;
  final String description;
  final String scale;
  final String coverage;
  final String period;
  final String studyLevel;
  final String access;
  final String license;
  final String formats;
  final String url;

  const GeospatialSourceItem({
    required this.id,
    required this.section,
    required this.sourceAr,
    required this.sourceEn,
    required this.entity,
    required this.description,
    required this.scale,
    required this.coverage,
    required this.period,
    required this.studyLevel,
    required this.access,
    required this.license,
    required this.formats,
    required this.url,
  });
}

class GeospatialSourcesDialog extends StatefulWidget {
  const GeospatialSourcesDialog({super.key});

  static Future<void> show(BuildContext context) async {
    setModalOpenWeb(true);
    try {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => const GeospatialSourcesDialog(),
      );
    } finally {
      setModalOpenWeb(false);
    }
  }

  @override
  State<GeospatialSourcesDialog> createState() => _GeospatialSourcesDialogState();
}

class _GeospatialSourcesDialogState extends State<GeospatialSourcesDialog> {
  String _searchQuery = '';
  String _selectedSection = 'الكل';

  void _openUrl(String url) {
    if (url.isEmpty) return;
    if (kIsWeb) {
      try {
        js.context.callMethod('open', [url, '_blank']);
      } catch (_) {}
    } else {
      Clipboard.setData(ClipboardData(text: url));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم نسخ الرابط: $url', style: const TextStyle(fontFamily: 'NotoKufi')),
          backgroundColor: AppColors.solidBrown,
        ),
      );
    }
  }

  List<GeospatialSourceItem> get _filteredSources {
    return kGeospatialSources.where((item) {
      final matchesSection = _selectedSection == 'الكل' || item.section == _selectedSection;
      final q = _searchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          item.sourceAr.toLowerCase().contains(q) ||
          item.sourceEn.toLowerCase().contains(q) ||
          item.entity.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.formats.toLowerCase().contains(q);
      return matchesSection && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = (size.width * 0.92).clamp(520.0, 1200.0);
    final dialogHeight = (size.height * 0.94).clamp(500.0, 980.0);
    final filtered = _filteredSources;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
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
            border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'جدول ودليل مصادر البيانات الجيومكانية (53 مصدراً)',
                      style: TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.solidBrown,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Divider(color: AppColors.borderBrown, thickness: 1.5),
              const SizedBox(height: 8),

              // Search Box & Summary Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.borderBrown.withOpacity(0.35)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: TextField(
                        onChanged: (val) => setState(() => _searchQuery = val),
                        decoration: const InputDecoration(
                          hintText: 'ابحث في المصادر أو الجهات أو الصيغ أو المحتوى...',
                          hintStyle: TextStyle(fontFamily: 'NotoKufi', fontSize: 13, color: Colors.grey),
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: AppColors.solidBrown, size: 20),
                        ),
                        style: const TextStyle(fontFamily: 'NotoKufi', fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBrown.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.borderBrown.withOpacity(0.3)),
                    ),
                    child: Text(
                      'عرض ${filtered.length} من ${kGeospatialSources.length} مصدراً',
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.solidBrown,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Section Filter Chips (Horizontal Scroll)
              SizedBox(
                height: 36,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    'الكل',
                    'أ. مصادر المملكة العربية السعودية',
                    'ب. الخرائط الجيولوجية والمعادن والجيوكيمياء',
                    'ج. الزلازل والبراكين والجيوفيزياء',
                    'د. صور الأقمار الصناعية والتحليل الطيفي',
                    'هـ. الارتفاعات والهيدرولوجيا والمناخ',
                    'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
                    'ز. نظم المعلومات الجغرافية والبرمجة والذكاء الاصطناعي الجغرافي المكاني',
                    'ح. التعلم والتدريب والمراجع المفتوحة',
                  ].map((sec) {
                    final isSel = _selectedSection == sec;
                    return Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: FilterChip(
                        label: Text(
                          sec,
                          style: TextStyle(
                            fontFamily: 'NotoKufi',
                            fontSize: 12,
                            fontWeight: isSel ? FontWeight.bold : FontWeight.normal,
                            color: isSel ? Colors.white : AppColors.solidBrown,
                          ),
                        ),
                        selected: isSel,
                        backgroundColor: Colors.white,
                        selectedColor: AppColors.solidBrown,
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: isSel ? AppColors.solidBrown : AppColors.borderBrown.withOpacity(0.4),
                          ),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            _selectedSection = sec;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 10),

              // Sources List Cards
              Expanded(
                child: filtered.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد مصادر مطابقة لبحثك',
                          style: TextStyle(fontFamily: 'NotoKufi', fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (ctx, i) => const SizedBox(height: 8),
                        itemBuilder: (ctx, i) {
                          final item = filtered[i];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderBrown.withOpacity(0.25)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Row 1: Number + Title (Ar & En) + Link button
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: AppColors.solidBrown,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item.id,
                                        style: const TextStyle(
                                          fontFamily: 'NotoKufi',
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.sourceAr,
                                            style: const TextStyle(
                                              fontFamily: 'NotoKufi',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1A365D),
                                            ),
                                          ),
                                          if (item.sourceEn.isNotEmpty)
                                            Text(
                                              item.sourceEn,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[700],
                                              ),
                                              textDirection: TextDirection.ltr,
                                            ),
                                        ],
                                      ),
                                    ),
                                    if (item.url.isNotEmpty)
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryBrown,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                        onPressed: () => _openUrl(item.url),
                                        icon: const Icon(Icons.open_in_new, size: 16),
                                        label: const Text(
                                          'فتح الرابط',
                                          style: TextStyle(fontFamily: 'NotoKufi', fontSize: 12),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Entity (الجهة)
                                if (item.entity.isNotEmpty)
                                  Row(
                                    children: [
                                      const Icon(Icons.account_balance, size: 16, color: AppColors.solidBrown),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          item.entity,
                                          style: const TextStyle(
                                            fontFamily: 'NotoKufi',
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.solidBrown,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 6),

                                // Description (ماذا يقدم)
                                if (item.description.isNotEmpty)
                                  Text(
                                    item.description,
                                    style: const TextStyle(
                                      fontFamily: 'NotoKufi',
                                      fontSize: 13,
                                      height: 1.5,
                                      color: Colors.black87,
                                    ),
                                  ),
                                const SizedBox(height: 8),

                                // Details chips (المقياس، التغطية، الوصول، الصيغ)
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    if (item.scale.isNotEmpty && item.scale != 'غير منطبق')
                                      _buildBadgeChip('المقياس: ${item.scale}', const Color(0xFFE8F5E9), const Color(0xFF2E7D32)),
                                    if (item.coverage.isNotEmpty)
                                      _buildBadgeChip('التغطية: ${item.coverage}', const Color(0xFFE3F2FD), const Color(0xFF1565C0)),
                                    if (item.access.isNotEmpty)
                                      _buildBadgeChip('الوصول: ${item.access}', const Color(0xFFFFF3E0), const Color(0xFFE65100)),
                                    if (item.formats.isNotEmpty)
                                      _buildBadgeChip('الصيغ: ${item.formats}', const Color(0xFFF3E5F5), const Color(0xFF6A1B9A)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              const SizedBox(height: 12),

              // Bottom Close Button
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.solidBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 11),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(
                      fontFamily: 'NotoKufi',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadgeChip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: fg.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(fontFamily: 'NotoKufi', fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Geospatial Sources Data (All 53 items from geospatial_am_my3.xlsx)
// ---------------------------------------------------------------------------
const List<GeospatialSourceItem> kGeospatialSources = [
  GeospatialSourceItem(
    id: '01',
    section: 'أ. مصادر المملكة العربية السعودية',
    sourceAr: 'قاعدة المعلومات الجيولوجية الوطنية',
    sourceEn: 'National Geological Database (NGD)',
    entity: 'هيئة المساحة الجيولوجية السعودية',
    description: 'الخرائط الجيولوجية وبيانات التواجدات المعدنية (MODS) والمسوحات الجيوكيميائية والجيوفيزيائية الإقليمية وبيانات الآبار والعينات',
    scale: '1:1,000,000 إلى 1:250,000',
    coverage: 'المملكة',
    period: 'يُحدَّث؛ آخر حزم مضافة في أكتوبر 2024',
    studyLevel: 'إقليمي ومحلي',
    access: 'مفتوح دون تسجيل للتصفح؛ البيانات بطلب عبر البوابة',
    license: 'وفق سياسات الهيئة',
    formats: 'عرض خرائطي؛ طبقات متجهة وجداول وتقارير بطلب',
    url: 'https://ngd.sgs.gov.sa/ar',
  ),
  GeospatialSourceItem(
    id: '02',
    section: 'أ. مصادر المملكة العربية السعودية',
    sourceAr: 'قاعدة البيانات الببليوغرافية للتقارير والخرائط الجيولوجية',
    sourceEn: 'SGS Bibliographic Database',
    entity: 'هيئة المساحة الجيولوجية السعودية',
    description: 'فهرس التقارير والخرائط الجيولوجية عن المملكة من الهيئة والجهات التي عملت فيها تاريخيًا، للبحث عن الدراسات السابقة',
    scale: 'غير منطبق',
    coverage: 'المملكة',
    period: 'تاريخي حتى الآن',
    studyLevel: 'جميع المستويات',
    access: 'مفتوح دون تسجيل للبحث في الفهرس',
    license: 'النصوص الكاملة بحسب تصنيف التقرير',
    formats: 'فهرس على الويب',
    url: 'https://ngdp.sgs.gov.sa/biblioapp',
  ),
  GeospatialSourceItem(
    id: '03',
    section: 'أ. مصادر المملكة العربية السعودية',
    sourceAr: 'منصة رواسي للمخاطر الجيولوجية',
    sourceEn: 'Rawasi GeoHazards Platform',
    entity: 'هيئة المساحة الجيولوجية السعودية',
    description: 'خرائط المناطق المعرضة للمخاطر الجيولوجية (زلازل وبراكين وانخسافات وانزلاقات وسيول) وقاعدة بيانات وتقارير فنية',
    scale: 'خرائط إقليمية',
    coverage: 'المملكة',
    period: 'يُحدَّث',
    studyLevel: 'إقليمي',
    access: 'مفتوح دون تسجيل للتصفح؛ البيانات التفصيلية بطلب رسمي',
    license: 'وفق سياسات الهيئة',
    formats: 'عرض على الويب',
    url: 'https://rawasi.sgs.gov.sa/ar',
  ),
  GeospatialSourceItem(
    id: '04',
    section: 'أ. مصادر المملكة العربية السعودية',
    sourceAr: 'منصة البيانات المفتوحة الوطنية',
    sourceEn: 'Saudi Open Data Portal',
    entity: 'الهيئة السعودية للبيانات والذكاء الاصطناعي (سدايا)، وتنشر الجهات الحكومية بياناتها على المنصة',
    description: 'أكثر من 18 ألف مجموعة بيانات حكومية في البيئة والمياه والزراعة والطاقة والسكان والنقل',
    scale: 'بحسب المجموعة',
    coverage: 'المملكة',
    period: 'بحسب المجموعة',
    studyLevel: 'إقليمي (بحسب المجموعة)',
    access: 'مفتوح دون تسجيل',
    license: 'ترخيص البيانات المفتوحة المعتمد في المنصة',
    formats: 'CSV وExcel وJSON وغيرها بحسب المجموعة',
    url: 'https://open.data.gov.sa',
  ),
  GeospatialSourceItem(
    id: '05',
    section: 'أ. مصادر المملكة العربية السعودية',
    sourceAr: 'خدمات البيانات المناخية في المركز الوطني للأرصاد',
    sourceEn: 'National Center for Meteorology (NCM) Climate Data Services',
    entity: 'المركز الوطني للأرصاد',
    description: 'بيانات رصد جوي تاريخية مدققة الجودة (أمطار وحرارة ورياح) من محطات المركز، وإحصاءات المناخ ومراقبة الجفاف',
    scale: 'محطات رصد',
    coverage: 'المملكة',
    period: 'سجلات لأكثر من 75 عامًا',
    studyLevel: 'محلي وإقليمي',
    access: 'بطلب رسمي',
    license: 'يخضع النشر أو الاستغلال لتصريح المركز',
    formats: 'جداول بحسب الطلب',
    url: 'https://www.ncm.gov.sa/ar/services/our-services/Historical%20Weather%20Data',
  ),
  GeospatialSourceItem(
    id: '06',
    section: 'أ. مصادر المملكة العربية السعودية',
    sourceAr: 'بوابة بيانات مركز الملك عبدالله للدراسات والبحوث البترولية',
    sourceEn: 'KAPSARC Data Portal',
    entity: 'مركز الملك عبدالله للدراسات والبحوث البترولية (كابسارك)',
    description: 'بيانات الطاقة والاقتصاد والاستدامة مع قسم جيومكاني، ومنها بيانات الطاقة المتجددة والمناخ وإحصاءات الهزات الأرضية',
    scale: 'بحسب المجموعة',
    coverage: 'المملكة والعالم',
    period: 'بحسب المجموعة',
    studyLevel: 'إقليمي',
    access: 'مفتوح دون تسجيل للتصفح والتنزيل؛ واجهة برمجية',
    license: 'بحسب كل مجموعة',
    formats: 'CSV وJSON وواجهة برمجية',
    url: 'https://data.kapsarc.org',
  ),
  GeospatialSourceItem(
    id: '07',
    section: 'أ. مصادر المملكة العربية السعودية',
    sourceAr: 'الخريطة العالمية للمملكة (أرشيف تاريخي)',
    sourceEn: 'Global Map Saudi Arabia 2.0 (ISCGM archive)',
    entity: 'الهيئة العامة للمساحة (مالكة البيانات) ضمن مشروع ISCGM؛ والأرشيف مستضاف على GitHub',
    description: 'عشر طبقات وطنية (حدود وطرق وسكك حديدية ومطارات ومناطق عمرانية وسواحل ومياه وأودية) بحالة عام 2013',
    scale: '1:1,000,000',
    coverage: 'المملكة',
    period: '2013 (أرشيف مغلق)',
    studyLevel: 'إقليمي (تعليمي وتاريخي)',
    access: 'مفتوح دون تسجيل (أرشيف على GitHub)',
    license: 'مقيد: مجاني للاستخدام غير التجاري',
    formats: 'Shapefile',
    url: 'https://github.com/globalmaps/gmsa20',
  ),
  GeospatialSourceItem(
    id: '08',
    section: 'ب. الخرائط الجيولوجية والمعادن والجيوكيمياء',
    sourceAr: 'الخريطة الجيولوجية الرقمية لشبه الجزيرة العربية',
    sourceEn: 'Geology of the Arabian Peninsula, USGS Open-File Report 97-470-B',
    entity: 'هيئة المساحة الجيولوجية الأمريكية (USGS)',
    description: 'طبقتا الجيولوجيا (أعمار الصخور وأنواعها) والأقاليم الجيولوجية والنفطية لشبه الجزيرة العربية',
    scale: '1:2,000,000 و1:5,000,000',
    coverage: 'شبه الجزيرة العربية',
    period: 'خرائط 1997؛ طبقات نُشرت 2021',
    studyLevel: 'إقليمي',
    access: 'مفتوح دون تسجيل',
    license: 'ملكية عامة',
    formats: 'Shapefile',
    url: 'https://pubs.usgs.gov/publication/ofr97470B',
  ),
  GeospatialSourceItem(
    id: '09',
    section: 'ب. الخرائط الجيولوجية والمعادن والجيوكيمياء',
    sourceAr: 'منصة ماكروسترات للخرائط الجيولوجية',
    sourceEn: 'Macrostrat',
    entity: 'مختبر Macrostrat، جامعة ويسكونسن ماديسون (يجمع خرائط من جهات متعددة)',
    description: 'خريطة جيولوجية تفاعلية عالمية مجمعة من 748 خريطة مع قاعدة بيانات للوحدات الطباقية',
    scale: 'متعدد المقاييس',
    coverage: 'عالمي',
    period: 'يُحدَّث',
    studyLevel: 'إقليمي (استكشاف تعليمي)',
    access: 'مفتوح دون تسجيل',
    license: 'CC BY 4.0 مع الإسناد إلى الخريطة الأصلية',
    formats: 'عرض على الويب وواجهة برمجية',
    url: 'https://macrostrat.org/map',
  ),
  GeospatialSourceItem(
    id: '10',
    section: 'ب. الخرائط الجيولوجية والمعادن والجيوكيمياء',
    sourceAr: 'موقع مايندات للمعادن ومواقعها',
    sourceEn: 'Mindat.org',
    entity: 'معهد هدسون لعلم المعادن (مؤسسة غير ربحية)',
    description: 'خصائص المعادن الكيميائية والبلورية والفيزيائية وصورها، وقوائم مواقعها المعروفة ومنها مواقع في المملكة',
    scale: 'غير منطبق',
    coverage: 'عالمي',
    period: 'يُحدَّث',
    studyLevel: 'مرجعي',
    access: 'مفتوح دون تسجيل للتصفح؛ الواجهة البرمجية بمفتاح',
    license: 'CC BY-NC-SA 4.0 للاستخدام الخاص غير التجاري، دون إعادة توزيع حاليًا',
    formats: 'عرض على الويب',
    url: 'https://www.mindat.org',
  ),
  GeospatialSourceItem(
    id: '11',
    section: 'ب. الخرائط الجيولوجية والمعادن والجيوكيمياء',
    sourceAr: 'قواعد البيانات الجيوكيميائية للصخور: جيوروك وإيرث كيم',
    sourceEn: 'GEOROC and EarthChem',
    entity: 'جامعة غوتنغن الألمانية (GEOROC)، ومرصد لامونت دوهرتي بجامعة كولومبيا (EarthChem). وكلتا القاعدتين تجمع بيانات منشورة من مصادرها الأصلية',
    description: 'تحاليل جيوكيميائية منشورة للصخور والمعادن: العناصر الرئيسية والشحيحة والنظائر والأعمار مع مراجعها',
    scale: 'نقاط عينات',
    coverage: 'عالمي',
    period: 'منشورات متراكمة',
    studyLevel: 'إقليمي',
    access: 'مفتوح دون تسجيل؛ واجهة GEOROC البرمجية بمفتاح',
    license: 'GEOROC: CC BY-SA 4.0',
    formats: 'CSV',
    url: 'https://georoc.eu',
  ),
  GeospatialSourceItem(
    id: '12',
    section: 'ب. الخرائط الجيولوجية والمعادن والجيوكيمياء',
    sourceAr: 'المكتبات الطيفية للمعادن والصخور',
    sourceEn: 'USGS Spectral Library Version 7 and ECOSTRESS Spectral Library',
    entity: 'هيئة المساحة الجيولوجية الأمريكية (USGS)، ومختبر الدفع النفاث التابع لناسا (JPL)',
    description: 'أطياف مرجعية مقيسة مخبريًا للمعادن والصخور والترب لتفسير الصور متعددة الأطياف وفائقة الطيفية',
    scale: 'غير منطبق',
    coverage: 'مرجع عالمي',
    period: 'USGS الإصدار 7؛ ECOSTRESS أكثر من 3,400 طيف',
    studyLevel: 'مرجعي',
    access: 'USGS مفتوح دون تسجيل؛ ECOSTRESS بنموذج طلب',
    license: 'USGS: CC0؛ ECOSTRESS: مع الإسناد',
    formats: 'ملفات نصية',
    url: 'https://www.usgs.gov/data/usgs-spectral-library-version-7-data',
  ),
  GeospatialSourceItem(
    id: '13',
    section: 'ب. الخرائط الجيولوجية والمعادن والجيوكيمياء',
    sourceAr: 'الكتاب السنوي للمعادن: فصل المملكة العربية السعودية',
    sourceEn: 'USGS Minerals Yearbook, Saudi Arabia',
    entity: 'المركز الوطني لمعلومات المعادن، هيئة المساحة الجيولوجية الأمريكية (USGS)',
    description: 'تقارير سنوية عن إنتاج المعادن والقطاع المعدني في المملكة مع جداول إحصائية',
    scale: 'غير منطبق',
    coverage: 'المملكة',
    period: '1994 إلى إصدار 2023',
    studyLevel: 'مرجعي',
    access: 'مفتوح دون تسجيل',
    license: 'ملكية عامة',
    formats: 'PDF وExcel',
    url: 'https://www.usgs.gov/centers/national-minerals-information-center/saudi-arabia',
  ),
  GeospatialSourceItem(
    id: '14',
    section: 'ج. الزلازل والبراكين والجيوفيزياء',
    sourceAr: 'كتالوجات الزلازل العالمية',
    sourceEn: 'ISC Bulletin, ISC-GEM Catalogue, USGS Earthquake Catalog and EMSC',
    entity: 'المركز الدولي لرصد الزلازل (ISC)، وهيئة المساحة الجيولوجية الأمريكية (USGS)، والمركز الأوروبي المتوسطي لرصد الزلازل (EMSC)',
    description: 'كتالوجات الزلازل: نشرة ISC التاريخية، وكتالوج ISC-GEM بقدر عزمي متجانس، وكتالوج USGS وEMSC للزلازل الحديثة',
    scale: 'نقاط أحداث',
    coverage: 'عالمي',
    period: 'ISC منذ 1904؛ ISC-GEM من 1904 إلى 2021',
    studyLevel: 'إقليمي',
    access: 'مفتوح دون تسجيل',
    license: 'ISC-GEM: CC BY-SA 3.0؛ الإسناد لكل كتالوج',
    formats: 'CSV وKMZ وQuakeML وGeoJSON وKML',
    url: 'https://www.isc.ac.uk/iscbulletin',
  ),
  GeospatialSourceItem(
    id: '15',
    section: 'ج. الزلازل والبراكين والجيوفيزياء',
    sourceAr: 'مراكز بيانات الموجات الزلزالية والنماذج الأرضية',
    sourceEn: 'EarthScope Consortium (formerly IRIS and UNAVCO) and GEOFON',
    entity: 'اتحاد EarthScope في الولايات المتحدة، ومركز GFZ الألماني لعلوم الأرض',
    description: 'تسجيلات الموجات الزلزالية وبيانات المحطات عبر خدمات FDSN، وأداة Wilber 3، ومستودع النماذج الأرضية (EMC)',
    scale: 'نقاط محطات',
    coverage: 'عالمي؛ شبكات إقليمية ومؤقتة في المنطقة',
    period: 'أرشيف متراكم حتى الآن',
    studyLevel: 'إقليمي ومحلي',
    access: 'مفتوح دون تسجيل لمعظم البيانات؛ حساب مجاني لبعض الخدمات والشبكات',
    license: 'بحسب كل شبكة',
    formats: 'miniSEED وStationXML وNetCDF',
    url: 'https://www.earthscope.org/data',
  ),
  GeospatialSourceItem(
    id: '16',
    section: 'ج. الزلازل والبراكين والجيوفيزياء',
    sourceAr: 'المشروع العالمي لحلول موتر العزم الزلزالي',
    sourceEn: 'Global CMT Project',
    entity: 'مرصد لامونت دوهرتي، جامعة كولومبيا',
    description: 'حلول موتر العزم الزلزالي (آليات المصدر) لعشرات الآلاف من الزلازل',
    scale: 'نقاط أحداث',
    coverage: 'عالمي',
    period: 'منذ 1976 حتى الآن',
    studyLevel: 'إقليمي (الزلازل المتوسطة والكبيرة)',
    access: 'مفتوح دون تسجيل',
    license: 'مع الإسناد إلى المشروع',
    formats: 'ملفات نصية وبحث على الويب',
    url: 'https://www.globalcmt.org',
  ),
  GeospatialSourceItem(
    id: '17',
    section: 'ج. الزلازل والبراكين والجيوفيزياء',
    sourceAr: 'قاعدة الصدوع النشطة وخريطة الخطر الزلزالي العالمية',
    sourceEn: 'GEM Global Active Faults Database and Global Seismic Hazard Map',
    entity: 'مؤسسة النموذج العالمي للزلازل (GEM)',
    description: 'آثار الصدوع النشطة مع خصائصها، وخريطة الخطر الزلزالي العالمية (ذروة التسارع الأرضي)',
    scale: 'خطوط صدوع؛ شبكة خطر إقليمية',
    coverage: 'عالمي؛ صدوع المنطقة من نموذج EMME 2014',
    period: 'الخريطة الإصدار 2026.1',
    studyLevel: 'إقليمي',
    access: 'مفتوح؛ طبقات الخريطة بحسب الترخيص',
    license: 'الصدوع: CC BY-SA 4.0؛ الخريطة الأساسية: CC BY-NC-SA 4.0',
    formats: 'GeoJSON وShapefile وKML وGeoPackage',
    url: 'https://github.com/GEMScienceTools/gem-global-active-faults',
  ),
  GeospatialSourceItem(
    id: '18',
    section: 'ج. الزلازل والبراكين والجيوفيزياء',
    sourceAr: 'برنامج البراكين العالمي',
    sourceEn: 'Global Volcanism Program',
    entity: 'مؤسسة سميثسونيان',
    description: 'صفحات براكين العالم وثوراناتها خلال الهولوسين، ومنها حرات المملكة مع ملخصات جيولوجية ومراجع',
    scale: 'غير منطبق',
    coverage: 'عالمي',
    period: 'الهولوسين حتى الآن',
    studyLevel: 'مرجعي',
    access: 'مفتوح دون تسجيل',
    license: 'مع الإسناد إلى البرنامج',
    formats: 'عرض على الويب',
    url: 'https://volcano.si.edu/volcanolist_countries.cfm?country=Saudi+Arabia',
  ),
  GeospatialSourceItem(
    id: '19',
    section: 'ج. الزلازل والبراكين والجيوفيزياء',
    sourceAr: 'نماذج الجاذبية والمغناطيسية العالمية',
    sourceEn: 'World Gravity Map (WGM2012), EMAG2v3 and ICGEM',
    entity: 'المكتب الدولي للجاذبية (BGI)، والإدارة الوطنية الأمريكية للمحيطات والغلاف الجوي (NOAA)، ومركز GFZ الألماني',
    description: 'شبكات شذوذ الجاذبية (بوجير والهواء الحر والأيزوستاتي) وشذوذ المجال المغناطيسي، وحساب الجيويد من النماذج العالمية',
    scale: 'دقيقتان قوسيتان (نحو 3.7 كم)',
    coverage: 'عالمي',
    period: 'WGM2012؛ EMAG2v3',
    studyLevel: 'إقليمي',
    access: 'WGM2012 بترخيص مقيد (أكاديمي)؛ EMAG2v3 وICGEM مفتوحان دون تسجيل',
    license: 'مع الإسناد',
    formats: 'GeoTIFF وCSV وKMZ',
    url: 'https://bgi.obs-mip.fr/grids-and-models-2',
  ),
  GeospatialSourceItem(
    id: '20',
    section: 'ج. الزلازل والبراكين والجيوفيزياء',
    sourceAr: 'بيانات التشوه الأرضي: الملاحة بالأقمار الصناعية والتداخل الراداري',
    sourceEn: 'Nevada Geodetic Laboratory (GNSS) and COMET LiCSAR (InSAR)',
    entity: 'مختبر نيفادا الجيوديسي بجامعة نيفادا رينو، ومركز COMET البريطاني',
    description: 'سلاسل زمنية لمواقع محطات GNSS وسرعاتها، وتداخلات رادارية وخرائط ترابط منتجة آليًا من Sentinel-1',
    scale: 'LiCSAR نحو 100 م؛ GNSS نقاط محطات',
    coverage: 'عالمي؛ تغطية LiCSAR جزئية للمملكة',
    period: 'حتى الآن',
    studyLevel: 'إقليمي ومحلي',
    access: 'مفتوح دون تسجيل',
    license: 'مع الإسناد؛ LiCSAR وفق شروط كوبرنيكوس',
    formats: 'نصي (NGL)؛ GeoTIFF (LiCSAR)',
    url: 'https://geodesy.unr.edu/',
  ),
  GeospatialSourceItem(
    id: '21',
    section: 'ج. الزلازل والبراكين والجيوفيزياء',
    sourceAr: 'قاعدة بيانات التدفق الحراري العالمية',
    sourceEn: 'Global Heat Flow Database',
    entity: 'اللجنة الدولية للتدفق الحراري (IHFC)، باستضافة مركز GFZ الألماني',
    description: 'أكثر من 91 ألف قياس للتدفق الحراري في نحو 72 ألف موقع مع مؤشرات الجودة وواجهة برمجية',
    scale: 'نقاط قياس',
    coverage: 'عالمي (توزيع غير متجانس)',
    period: 'إصدار 2024',
    studyLevel: 'إقليمي',
    access: 'مفتوح دون تسجيل',
    license: 'يُراجع ترخيص الإصدار في صفحته',
    formats: 'جداول وواجهة برمجية',
    url: 'https://www.heatflow.world',
  ),
  GeospatialSourceItem(
    id: '22',
    section: 'د. صور الأقمار الصناعية والتحليل الطيفي',
    sourceAr: 'مستكشف الأرض التابع لهيئة المساحة الجيولوجية الأمريكية',
    sourceEn: 'USGS EarthExplorer',
    entity: 'مركز EROS، هيئة المساحة الجيولوجية الأمريكية (USGS)',
    description: 'أرشيف لاندسات منذ 1972 مع نماذج الارتفاعات والصور الجوية، والبحث بالمنطقة والفترة والغطاء السحابي',
    scale: '30 م (لاندسات)',
    coverage: 'عالمي',
    period: '1972 حتى الآن؛ 30 م منذ 1982',
    studyLevel: 'محلي وإقليمي',
    access: 'مجاني بحساب لدى USGS',
    license: 'ملكية عامة (لاندسات)',
    formats: 'GeoTIFF (COG)',
    url: 'https://earthexplorer.usgs.gov',
  ),
  GeospatialSourceItem(
    id: '23',
    section: 'د. صور الأقمار الصناعية والتحليل الطيفي',
    sourceAr: 'منظومة كوبرنيكوس للبيانات الفضائية ومتصفحها',
    sourceEn: 'Copernicus Data Space Ecosystem and Copernicus Browser',
    entity: 'برنامج كوبرنيكوس التابع للمفوضية الأوروبية، بالتعاون مع وكالة الفضاء الأوروبية (ESA)',
    description: 'الأرشيف الكامل لأقمار سنتينل (Sentinel-1 الراداري وSentinel-2 البصري وSentinel-5P للغلاف الجوي) ومتصفح للعرض والمقارنة',
    scale: '10 و20 و60 م (Sentinel-2)؛ 10 م (Sentinel-1 GRD)',
    coverage: 'عالمي',
    period: 'Sentinel-1 منذ 2014؛ Sentinel-2 منذ 2015',
    studyLevel: 'محلي وإقليمي',
    access: 'مجاني بحساب، ضمن حصص استخدام',
    license: 'بيانات كوبرنيكوس المجانية والمفتوحة',
    formats: 'JPEG2000 (SAFE) وGeoTIFF',
    url: 'https://browser.dataspace.copernicus.eu',
  ),
  GeospatialSourceItem(
    id: '24',
    section: 'د. صور الأقمار الصناعية والتحليل الطيفي',
    sourceAr: 'بوابات ناسا لبيانات رصد الأرض',
    sourceEn: 'NASA Earthdata Search and NASA Worldview',
    entity: 'وكالة الفضاء الأمريكية (ناسا)',
    description: 'البحث في أكثر من 50 ألف مجموعة بيانات لرصد الأرض وتنزيلها، وعرض شبه فوري لأكثر من 1,000 طبقة',
    scale: 'بحسب المنتج',
    coverage: 'عالمي',
    period: 'بحسب المنتج',
    studyLevel: 'بحسب المنتج',
    access: 'مفتوح دون تسجيل للتصفح؛ التنزيل مجاني بحساب Earthdata Login',
    license: 'بيانات ناسا المفتوحة',
    formats: 'HDF5 وNetCDF وGeoTIFF بحسب المنتج',
    url: 'https://search.earthdata.nasa.gov',
  ),
  GeospatialSourceItem(
    id: '25',
    section: 'د. صور الأقمار الصناعية والتحليل الطيفي',
    sourceAr: 'منصة ألاسكا لبيانات الرادار',
    sourceEn: 'Alaska Satellite Facility (ASF) Vertex and HyP3',
    entity: 'مرفق ألاسكا للأقمار الصناعية، جامعة ألاسكا فيربانكس (مركز بيانات تابع لناسا)',
    description: 'أرشيف الرادار (Sentinel-1 ومنتجات NISAR الأولية) ومعالجة سحابية عند الطلب لإنتاج التداخلات الرادارية',
    scale: '80 أو 40 م (منتجات HyP3)',
    coverage: 'عالمي',
    period: 'Sentinel-1 منذ 2014',
    studyLevel: 'محلي وإقليمي',
    access: 'مجاني بحساب Earthdata Login؛ رصيد معالجة شهري مجاني',
    license: 'بحسب البعثة',
    formats: 'GeoTIFF',
    url: 'https://search.asf.alaska.edu',
  ),
  GeospatialSourceItem(
    id: '26',
    section: 'د. صور الأقمار الصناعية والتحليل الطيفي',
    sourceAr: 'منصة جوجل إيرث إنجن',
    sourceEn: 'Google Earth Engine',
    entity: 'جوجل (منصة تعيد إتاحة بيانات جهات متعددة)',
    description: 'حوسبة سحابية على أكثر من 1,000 مجموعة بيانات (لاندسات وسنتينل والارتفاعات والمناخ والغطاء الأرضي) دون تنزيل',
    scale: 'بحسب المجموعة',
    coverage: 'عالمي',
    period: 'بحسب المجموعة',
    studyLevel: 'محلي وإقليمي',
    access: 'مجاني بحساب (مشروع Google Cloud مسجل) للبحث والتعليم غير التجاري؛ اشتراك مدفوع للاستخدام التجاري',
    license: 'كل مجموعة بترخيص جهتها الأصلية',
    formats: 'واجهات جافاسكربت وبايثون',
    url: 'https://earthengine.google.com',
  ),
  GeospatialSourceItem(
    id: '27',
    section: 'د. صور الأقمار الصناعية والتحليل الطيفي',
    sourceAr: 'التصوير الطيفي لرسم خرائط المعادن',
    sourceEn: 'NASA EMIT, EnMAP and ASTER',
    entity: 'ناسا (EMIT، وASTER بالشراكة مع اليابان)، والمركز الألماني للطيران والفضاء DLR (EnMAP)',
    description: 'خرائط المعادن السطحية من EMIT، وصور EnMAP فائقة الطيفية، وأرشيف ASTER للاستكشاف المعدني',
    scale: 'EMIT 60 م؛ EnMAP 30 م؛ ASTER 15 إلى 90 م',
    coverage: 'عالمي؛ منتج EMIT للمناطق الجافة ومنها شبه الجزيرة العربية',
    period: 'EMIT منذ 2022؛ EnMAP منذ 2022؛ ASTER منذ 2000 (SWIR حتى 2008)',
    studyLevel: 'محلي',
    access: 'مجاني بحساب (Earthdata Login؛ تسجيل EnMAP)',
    license: 'EnMAP يقيد إعادة التوزيع',
    formats: 'NetCDF-4 وGeoTIFF',
    url: 'https://www.earthdata.nasa.gov/data/catalog/lpcloud-emitl2bmin-002',
  ),
  GeospatialSourceItem(
    id: '28',
    section: 'د. صور الأقمار الصناعية والتحليل الطيفي',
    sourceAr: 'الصور الفضائية التجارية عالية الدقة',
    sourceEn: 'Commercial very-high-resolution imagery (Vantor, Airbus)',
    entity: 'شركة Vantor (Maxar Intelligence سابقًا، تغير اسمها في أكتوبر 2025)، وشركة Airbus Defence and Space',
    description: 'صور فضائية تجارية بدقة أقل من متر للدراسات الموقعية والهندسية وتوثيق آثار الكوارث',
    scale: '0.3 إلى 0.5 م',
    coverage: 'عالمي (بحسب الأرشيف)',
    period: 'أرشيف وتكليف جديد',
    studyLevel: 'موقعي وهندسي',
    access: 'تجاري',
    license: 'تراخيص تجارية؛ بيانات Vantor المفتوحة CC BY-NC 4.0 للكوارث المفعلة',
    formats: 'GeoTIFF وغيرها بحسب المنتج',
    url: 'https://registry.opendata.aws/vantor-open-data/',
  ),
  GeospatialSourceItem(
    id: '29',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'نموذج كوبرنيكوس الرقمي للارتفاعات',
    sourceEn: 'Copernicus DEM (GLO-30 and GLO-90)',
    entity: 'برنامج كوبرنيكوس الأوروبي ووكالة الفضاء الأوروبية (ESA)، وبياناته الأصلية من بعثة TanDEM-X للمركز الألماني للطيران والفضاء (DLR) وشركة Airbus؛ وFABDEM من جامعة بريستول وشركة Fathom',
    description: 'نموذج سطحي عالمي للارتفاعات من بعثة TanDEM-X، مع نسخة FABDEM مزالة المباني والأشجار',
    scale: '30 م (GLO-30) و90 م (GLO-90)',
    coverage: 'عالمي',
    period: 'إصدار 2024_1 (نسخة AWS من 2021)',
    studyLevel: 'محلي وإقليمي',
    access: 'مفتوح دون تسجيل من AWS، أو مجاني بحساب في منظومة كوبرنيكوس',
    license: 'ترخيص Copernicus DEM؛ FABDEM: CC BY-NC-SA 4.0',
    formats: 'GeoTIFF',
    url: 'https://dataspace.copernicus.eu/explore-data/data-collections/copernicus-contributing-missions/collections-description/COP-DEM',
  ),
  GeospatialSourceItem(
    id: '30',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'بوابة أوبن توبوغرافي',
    sourceEn: 'OpenTopography',
    entity: 'مرفق تابع للمؤسسة الوطنية الأمريكية للعلوم (NSF) في مركز سان دييغو للحوسبة الفائقة بجامعة كاليفورنيا، ويعيد إتاحة نماذج ارتفاعات تملكها جهات أخرى',
    description: 'تنزيل نماذج الارتفاعات العالمية (SRTM وNASADEM وCopernicus DEM وAW3D30) لمنطقة محددة مع التظليل وخطوط الكنتور',
    scale: '30 إلى 90 م (النماذج العالمية)',
    coverage: 'عالمي؛ ليدار عالي الدقة معظمه خارج المملكة',
    period: 'بحسب النموذج',
    studyLevel: 'محلي وإقليمي',
    access: 'مجاني بحساب ومفتاح برمجي؛ اشتراك مدفوع لبعض البيانات لغير الأكاديميين',
    license: 'بحسب كل نموذج',
    formats: 'GeoTIFF وغيرها',
    url: 'https://opentopography.org',
  ),
  GeospatialSourceItem(
    id: '31',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'نموذج الارتفاعات العالمي من القمر الياباني ALOS',
    sourceEn: 'ALOS World 3D 30 m (AW3D30)',
    entity: 'وكالة استكشاف الفضاء اليابانية (JAXA)',
    description: 'نموذج سطحي عالمي للارتفاعات من الصور المجسمة للقمر الياباني ALOS',
    scale: 'نحو 30 م',
    coverage: 'عالمي',
    period: 'الإصدار 4.1 (أبريل 2024)',
    studyLevel: 'محلي وإقليمي',
    access: 'مجاني بحساب (تسجيل بالبريد الإلكتروني)',
    license: 'شروط JAXA؛ يسمح بالاستخدام التجاري',
    formats: 'GeoTIFF',
    url: 'https://www.eorc.jaxa.jp/ALOS/en/dataset/aw3d30/aw3d30_e.htm',
  ),
  GeospatialSourceItem(
    id: '32',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'الشبكة العالمية لأعماق البحار والمحيطات',
    sourceEn: 'GEBCO Gridded Bathymetry Data',
    entity: 'مشروع GEBCO بإشراف المنظمة الهيدروغرافية الدولية واللجنة الأوقيانوغرافية الحكومية الدولية',
    description: 'شبكة عالمية لتضاريس قاع البحار واليابسة مع تنزيل منطقة محددة',
    scale: '15 ثانية قوسية (نحو 460 م)',
    coverage: 'عالمي',
    period: 'GEBCO_2026 (أبريل 2026)',
    studyLevel: 'إقليمي',
    access: 'مفتوح دون تسجيل',
    license: 'ملكية عامة مع الإسناد؛ لا تصلح للملاحة',
    formats: 'NetCDF وGeoTIFF وEsri ASCII',
    url: 'https://www.gebco.net',
  ),
  GeospatialSourceItem(
    id: '33',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'قاعدة البيانات الهيدرولوجية العالمية',
    sourceEn: 'HydroSHEDS (HydroRIVERS, HydroBASINS) and MERIT Hydro',
    entity: 'الصندوق العالمي للطبيعة (WWF) وجامعة ماكغيل (HydroSHEDS)، وجامعة طوكيو (MERIT Hydro)',
    description: 'شبكات الأنهار والأودية وحدود أحواض التصريف والبحيرات، وبديل MERIT Hydro باتجاهات الجريان والمساحة المساهمة',
    scale: '3 و15 و30 ثانية قوسية (90 م فأكثر)',
    coverage: 'عالمي (المملكة في الإصدار الأول)',
    period: 'HydroSHEDS الإصدار الأول؛ MERIT Hydro 1.0.1',
    studyLevel: 'إقليمي',
    access: 'HydroSHEDS مفتوح دون تسجيل؛ MERIT Hydro مجاني بحساب (تسجيل عبر نموذج)',
    license: 'HydroSHEDS مع الإسناد ودون إعادة توزيع منفرد؛ MERIT: CC BY-NC 4.0 أو ODbL 1.0',
    formats: 'GeoTIFF وطبقات متجهة',
    url: 'https://www.hydrosheds.org',
  ),
  GeospatialSourceItem(
    id: '34',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'بيانات المناخ والأمطار من إعادة التحليل والأقمار الصناعية',
    sourceEn: 'ERA5 (Copernicus Climate Data Store), CHIRPS and GPM IMERG',
    entity: 'المركز الأوروبي للتنبؤات الجوية متوسطة المدى (ECMWF) لصالح خدمة كوبرنيكوس للمناخ، وجامعة كاليفورنيا سانتا باربرا (CHIRPS)، وناسا (IMERG)',
    description: 'إعادة التحليل المناخي ERA5 وتقديرات الأمطار من CHIRPS وIMERG لدراسة الجفاف والسيول وتغير الهطول',
    scale: 'ERA5 0.25 درجة؛ CHIRPS 0.05 درجة؛ IMERG 0.1 درجة',
    coverage: 'عالمي (CHIRPS بين 60 شمالًا و60 جنوبًا)',
    period: 'ERA5 منذ 1940؛ CHIRPS منذ 1981؛ IMERG منذ 2000',
    studyLevel: 'إقليمي',
    access: 'ERA5 وIMERG مجانيان بحساب؛ CHIRPS مفتوح دون تسجيل',
    license: 'CC BY 4.0',
    formats: 'GRIB وNetCDF وGeoTIFF وHDF5',
    url: 'https://cds.climate.copernicus.eu/datasets/reanalysis-era5-single-levels',
  ),
  GeospatialSourceItem(
    id: '35',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'مستكشف المياه السطحية العالمي',
    sourceEn: 'JRC Global Surface Water Explorer',
    entity: 'مركز البحوث المشترك التابع للمفوضية الأوروبية (JRC) بالتعاون مع جوجل',
    description: 'خرائط توزيع المياه السطحية وتكرارها وتغيرها من صور لاندسات، لرصد البحيرات المؤقتة وبحيرات السدود',
    scale: '30 م',
    coverage: 'عالمي',
    period: '1984 إلى 2021 (الإصدار 1.4)',
    studyLevel: 'محلي وإقليمي',
    access: 'مفتوح دون تسجيل',
    license: 'مع الإسناد',
    formats: 'GeoTIFF',
    url: 'https://global-surface-water.appspot.com',
  ),
  GeospatialSourceItem(
    id: '36',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'بعثتا GRACE وGRACE-FO لرصد تغير مخزون المياه',
    sourceEn: 'GRACE and GRACE-FO Mass Change Data',
    entity: 'ناسا ومركز GFZ الألماني؛ وتوزع منتجات JPL عبر مركز PO.DAAC',
    description: 'التغير الشهري في كتلة المياه على اليابسة من قياسات الجاذبية، لتتبع مخزون المياه الجوفية إقليميًا',
    scale: 'شبكة 0.5 درجة؛ دقة فعلية نحو 3 درجات (نحو 300 كم)',
    coverage: 'عالمي',
    period: 'منذ أبريل 2002 حتى الآن',
    studyLevel: 'إقليمي فقط',
    access: 'مجاني بحساب Earthdata Login',
    license: 'بيانات ناسا المفتوحة',
    formats: 'NetCDF-4',
    url: 'https://grace.jpl.nasa.gov/data/get-data/jpl_global_mascons',
  ),
  GeospatialSourceItem(
    id: '37',
    section: 'هـ. الارتفاعات والهيدرولوجيا والمناخ',
    sourceAr: 'منصة الفاو الجيومكانية وبيانات إنتاجية المياه',
    sourceEn: 'FAO Hand-in-Hand Geospatial Platform and WaPOR',
    entity: 'منظمة الأغذية والزراعة للأمم المتحدة (FAO)',
    description: 'طبقات عن الزراعة والمياه والتربة واستخدامات الأراضي، وقاعدة WaPOR للتبخر والنتح والإنتاجية واستهلاك المياه',
    scale: 'WaPOR 300 م (المستوى الأول) و100 م (المستوى الثاني)',
    coverage: 'عالمي؛ المستوى الثاني يشمل المملكة',
    period: 'WaPOR الإصدار الثالث',
    studyLevel: 'إقليمي ومحلي',
    access: 'مفتوح دون تسجيل',
    license: 'بحسب كل مجموعة',
    formats: 'GeoTIFF وخدمات خرائط',
    url: 'https://data.apps.fao.org',
  ),
  GeospatialSourceItem(
    id: '38',
    section: 'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
    sourceAr: 'خرائط الغطاء الأرضي العالمية عالية الدقة',
    sourceEn: 'ESA WorldCover and Dynamic World',
    entity: 'وكالة الفضاء الأوروبية (WorldCover)، وجوجل ومعهد الموارد العالمية (Dynamic World)',
    description: 'خريطة الغطاء الأرضي WorldCover لعامي 2020 و2021، وتصنيف Dynamic World شبه الفوري لكل صورة Sentinel-2',
    scale: '10 م',
    coverage: 'عالمي',
    period: 'WorldCover 2020 و2021؛ Dynamic World منذ 2015',
    studyLevel: 'محلي وإقليمي',
    access: 'مفتوح دون تسجيل؛ بيانات Dynamic World بحساب Google Earth Engine',
    license: 'CC BY 4.0',
    formats: 'GeoTIFF (COG)',
    url: 'https://esa-worldcover.org',
  ),
  GeospatialSourceItem(
    id: '39',
    section: 'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
    sourceAr: 'شبكة خصائص التربة العالمية',
    sourceEn: 'SoilGrids',
    entity: 'المركز الدولي لمراجع ومعلومات التربة (ISRIC)',
    description: 'خرائط تقديرية لخصائص التربة (الحموضة والكربون العضوي والكثافة الظاهرية ونسب الرمل والسلت والطين) مع طبقات عدم اليقين',
    scale: '250 م',
    coverage: 'عالمي',
    period: 'SoilGrids 2.0',
    studyLevel: 'إقليمي واستكشافي',
    access: 'مفتوح دون تسجيل',
    license: 'CC BY 4.0',
    formats: 'GeoTIFF عبر WebDAV وخدمات WCS وWMS',
    url: 'https://soilgrids.org',
  ),
  GeospatialSourceItem(
    id: '40',
    section: 'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
    sourceAr: 'أطلسا الطاقة الشمسية وطاقة الرياح العالميان',
    sourceEn: 'Global Solar Atlas and Global Wind Atlas',
    entity: 'البنك الدولي (برنامج ESMAP) بالتعاون مع شركة Solargis والجامعة التقنية الدنماركية (DTU)',
    description: 'الإشعاع الشمسي والإنتاج الكهروضوئي المتوقع، وسرعات الرياح وكثافة طاقتها على ارتفاعات مختلفة',
    scale: 'نحو 250 م',
    coverage: 'عالمي',
    period: 'متوسطات طويلة المدى؛ أطلس الرياح الإصدار الرابع (2025)',
    studyLevel: 'إقليمي (مسح أولي)',
    access: 'مفتوح دون تسجيل',
    license: 'أطلس الشمس: CC BY 4.0؛ أطلس الرياح: يُراجع في موقعه',
    formats: 'GeoTIFF وAAIGRID',
    url: 'https://globalsolaratlas.info',
  ),
  GeospatialSourceItem(
    id: '41',
    section: 'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
    sourceAr: 'القاعدة العالمية للمناطق المحمية',
    sourceEn: 'Protected Planet (World Database on Protected Areas, WDPA)',
    entity: 'المركز العالمي لرصد حفظ الطبيعة التابع لبرنامج الأمم المتحدة للبيئة (UNEP-WCMC) والاتحاد الدولي لحفظ الطبيعة (IUCN)',
    description: 'حدود المناطق المحمية وتصنيفاتها، ومنها 108 مناطق محمية في المملكة',
    scale: 'حدود متجهة',
    coverage: 'عالمي',
    period: 'تحديث شهري',
    studyLevel: 'إقليمي',
    access: 'مقيد: تنزيل مجاني للاستخدام غير التجاري',
    license: 'غير تجاري دون إعادة توزيع؛ الاستخدام التجاري بإذن',
    formats: 'Shapefile وFile Geodatabase',
    url: 'https://www.protectedplanet.net',
  ),
  GeospatialSourceItem(
    id: '42',
    section: 'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
    sourceAr: 'بيانات السكان والتفاعل بين الإنسان والبيئة',
    sourceEn: 'NASA SEDAC data (CIESIN), including Gridded Population of the World',
    entity: 'مركز شبكة المعلومات الدولية لعلوم الأرض (CIESIN) بجامعة كولومبيا، وتوزَّع البيانات حاليًا عبر ناسا (Earthdata) ومستودع Harvard Dataverse',
    description: 'شبكات توزيع السكان العالمية (GPW) وبيانات التفاعل بين الإنسان والبيئة لتقدير السكان المعرضين للمخاطر',
    scale: '30 ثانية قوسية (نحو 1 كم)',
    coverage: 'عالمي',
    period: '2000 إلى 2020 (كل خمس سنوات)',
    studyLevel: 'إقليمي',
    access: 'مجاني بحساب Earthdata Login',
    license: 'بحسب كل مجموعة',
    formats: 'GeoTIFF وNetCDF',
    url: 'https://www.earthdata.nasa.gov/data/alerts-outages/sedac-data-back-earthdata-search',
  ),
  GeospatialSourceItem(
    id: '43',
    section: 'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
    sourceAr: 'بيانات خريطة الشارع المفتوحة',
    sourceEn: 'OpenStreetMap and Geofabrik data extracts',
    entity: 'مؤسسة OpenStreetMap والمساهمون فيها (مالكو البيانات)، وشركة Geofabrik (التوزيع)',
    description: 'الطرق والمباني والمعالم واستخدامات الأراضي من خريطة الشارع المفتوحة، بصيغ جاهزة لنظم المعلومات الجغرافية',
    scale: 'متجه (تتفاوت الدقة والاكتمال)',
    coverage: 'عالمي؛ المملكة ضمن ملف دول مجلس التعاون الخليجي',
    period: 'تحديث يومي',
    studyLevel: 'محلي بحسب اكتمال البيانات',
    access: 'مفتوح دون تسجيل',
    license: 'ODbL مع الإسناد إلى OpenStreetMap contributors',
    formats: 'PBF وShapefile وGeoPackage',
    url: 'https://www.openstreetmap.org',
  ),
  GeospatialSourceItem(
    id: '44',
    section: 'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
    sourceAr: 'قاعدة الحدود الإدارية المفتوحة',
    sourceEn: 'geoBoundaries',
    entity: 'مختبر geoLab، جامعة ويليام وماري (يجمع حدودًا من مصادر متعددة ويذكر مصدر كل طبقة)',
    description: 'حدود الدولة والمناطق الإدارية الثلاث عشرة والمحافظات (147) للخرائط الإحصائية والمقارنات الدولية',
    scale: 'حدود متجهة',
    coverage: 'عالمي',
    period: 'الإصدار 6.0 (ديسمبر 2023)',
    studyLevel: 'إقليمي',
    access: 'مفتوح دون تسجيل',
    license: 'ODbL 1.0 (الدولة والمناطق)؛ CC BY-SA 2.0 (المحافظات)',
    formats: 'GeoJSON وShapefile',
    url: 'https://www.geoboundaries.org',
  ),
  GeospatialSourceItem(
    id: '45',
    section: 'و. الغطاء الأرضي والبيئة والخرائط المرجعية',
    sourceAr: 'بيانات الأرض الطبيعية لرسم الخرائط',
    sourceEn: 'Natural Earth',
    entity: 'مشروع تطوعي بدعم من جمعية أمريكا الشمالية لمعلومات الخرائط (NACIS)',
    description: 'حدود وسواحل ومدن وأنهار وتضاريس مظللة لرسم خرائط تحديد الموقع والخرائط التوضيحية',
    scale: '1:10 مليون إلى 1:110 مليون',
    coverage: 'عالمي',
    period: 'الإصدار 5.1.2',
    studyLevel: 'خرائط صغيرة المقياس فقط',
    access: 'مفتوح دون تسجيل',
    license: 'ملكية عامة',
    formats: 'Shapefile وGeoPackage وSQLite',
    url: 'https://www.naturalearthdata.com/downloads',
  ),
  GeospatialSourceItem(
    id: '46',
    section: 'ز. نظم المعلومات الجغرافية والبرمجة والذكاء الاصطناعي الجغرافي المكاني',
    sourceAr: 'برنامج QGIS لنظم المعلومات الجغرافية',
    sourceEn: 'QGIS and the QGIS Training Manual',
    entity: 'مشروع QGIS مفتوح المصدر ضمن مؤسسة OSGeo',
    description: 'برنامج مجاني مفتوح المصدر لنظم المعلومات الجغرافية مع إضافات للتحليل الهيدرولوجي والاستشعار عن بُعد، ودليل تدريبي',
    scale: 'غير منطبق',
    coverage: 'غير منطبق',
    period: 'الإصدار طويل الدعم 3.44',
    studyLevel: 'جميع المستويات',
    access: 'مجاني ومفتوح المصدر',
    license: 'GNU GPL',
    formats: 'ويندوز وماك ولينكس',
    url: 'https://qgis.org',
  ),
  GeospatialSourceItem(
    id: '47',
    section: 'ز. نظم المعلومات الجغرافية والبرمجة والذكاء الاصطناعي الجغرافي المكاني',
    sourceAr: 'أدوات رسم الخرائط العلمية GMT وPyGMT',
    sourceEn: 'Generic Mapping Tools (GMT) and PyGMT',
    entity: 'مشروع GMT مفتوح المصدر',
    description: 'أدوات إنتاج الخرائط العلمية للنشر (الزلازل والتضاريس وآليات المصدر والجاذبية) من سطر الأوامر أو بايثون',
    scale: 'غير منطبق',
    coverage: 'غير منطبق',
    period: 'GMT 6.7',
    studyLevel: 'جميع المستويات',
    access: 'مجاني ومفتوح المصدر',
    license: 'LGPL (GMT)؛ BSD-3 (PyGMT)',
    formats: 'سطر أوامر وبايثون',
    url: 'https://www.generic-mapping-tools.org',
  ),
  GeospatialSourceItem(
    id: '48',
    section: 'ز. نظم المعلومات الجغرافية والبرمجة والذكاء الاصطناعي الجغرافي المكاني',
    sourceAr: 'مكتبات بايثون مفتوحة المصدر للتحليل الجيومكاني والتعلم العميق',
    sourceEn: 'geemap, leafmap, segment-geospatial (samgeo) and TorchGeo',
    entity: 'مشروع opengeos مفتوح المصدر (geemap وleafmap وsamgeo)، ومشروع TorchGeo ضمن مؤسسة OSGeo',
    description: 'مكتبات بايثون للتحليل الجيومكاني في Jupyter: الربط بمنصة Earth Engine، والعرض التفاعلي، وتقسيم الصور، والتعلم العميق',
    scale: 'غير منطبق',
    coverage: 'غير منطبق',
    period: 'تُحدَّث باستمرار',
    studyLevel: 'للمستخدمين ذوي الخبرة البرمجية',
    access: 'مجاني ومفتوح المصدر؛ geemap تتطلب حساب Earth Engine',
    license: 'MIT',
    formats: 'حزم بايثون',
    url: 'https://geemap.org',
  ),
  GeospatialSourceItem(
    id: '49',
    section: 'ز. نظم المعلومات الجغرافية والبرمجة والذكاء الاصطناعي الجغرافي المكاني',
    sourceAr: 'النماذج التأسيسية لرصد الأرض',
    sourceEn: 'Prithvi-EO-2.0 and AlphaEarth Foundations Satellite Embedding',
    entity: 'ناسا وIBM (Prithvi)، وGoogle DeepMind (AlphaEarth)',
    description: 'نموذج Prithvi-EO-2.0 التأسيسي لصور HLS، وتمثيل AlphaEarth السنوي من 64 بعدًا لكل خلية للتصنيف وكشف التغير',
    scale: 'Prithvi 30 م؛ AlphaEarth 10 م',
    coverage: 'عالمي',
    period: 'AlphaEarth منذ 2017',
    studyLevel: 'محلي وإقليمي',
    access: 'Prithvi مفتوح دون تسجيل؛ AlphaEarth بحساب Earth Engine',
    license: 'Apache 2.0 (Prithvi)؛ CC BY 4.0 (AlphaEarth)',
    formats: 'أوزان نماذج؛ صور Earth Engine',
    url: 'https://huggingface.co/ibm-nasa-geospatial',
  ),
  GeospatialSourceItem(
    id: '50',
    section: 'ح. التعلم والتدريب والمراجع المفتوحة',
    sourceAr: 'برنامج ناسا للتدريب على الاستشعار عن بُعد التطبيقي',
    sourceEn: 'NASA Applied Remote Sensing Training (ARSET)',
    entity: 'وكالة الفضاء الأمريكية (ناسا)',
    description: 'دورات مجانية عبر الإنترنت في تطبيقات الاستشعار عن بُعد (الفيضانات والجفاف وجودة الهواء والغطاء الأرضي) مع تمارين',
    scale: 'غير منطبق',
    coverage: 'غير منطبق',
    period: 'منذ 2009',
    studyLevel: 'مبتدئ إلى متوسط',
    access: 'مفتوح دون تسجيل للمواد المسجلة؛ تسجيل للدورات المباشرة',
    license: 'غير منطبق',
    formats: 'تسجيلات ومواد قابلة للتنزيل (إنجليزي وإسباني)',
    url: 'https://www.earthdata.nasa.gov/data/projects/arset',
  ),
  GeospatialSourceItem(
    id: '51',
    section: 'ح. التعلم والتدريب والمراجع المفتوحة',
    sourceAr: 'كلية رصد الأرض',
    sourceEn: 'EO College',
    entity: 'مبادرة تعليمية انطلقت من جامعة يينا الألمانية، بالشراكة مع وكالة الفضاء الأوروبية (ESA)',
    description: 'دورات ذاتية التعلم في أساسيات الاستشعار عن بُعد والرادار والتداخل الراداري وتطبيقاتها',
    scale: 'غير منطبق',
    coverage: 'غير منطبق',
    period: 'يُحدَّث',
    studyLevel: 'مبتدئ إلى متقدم',
    access: 'مفتوح دون تسجيل؛ بعض الدورات بتسجيل',
    license: 'موارد تعليمية مفتوحة',
    formats: 'دورات على الويب',
    url: 'https://eo-college.org',
  ),
  GeospatialSourceItem(
    id: '52',
    section: 'ح. التعلم والتدريب والمراجع المفتوحة',
    sourceAr: 'كتاب «الاستشعار عن بُعد السحابي باستخدام Google Earth Engine»',
    sourceEn: 'Cloud-Based Remote Sensing with Google Earth Engine: Fundamentals and Applications',
    entity: 'دار Springer، تحرير Cardille وCrowley وSaah وClinton',
    description: 'كتاب جامعي في 55 فصلًا من أساسيات الصور الفضائية إلى التطبيقات المتقدمة، مع شيفرات ومقاطع مرئية',
    scale: 'غير منطبق',
    coverage: 'غير منطبق',
    period: '2024',
    studyLevel: 'مقرر جامعي',
    access: 'مفتوح دون تسجيل',
    license: 'CC BY 4.0',
    formats: 'كتاب مفتوح الوصول (PDF وويب)',
    url: 'https://link.springer.com/book/10.1007/978-3-031-26588-4',
  ),
  GeospatialSourceItem(
    id: '53',
    section: 'ح. التعلم والتدريب والمراجع المفتوحة',
    sourceAr: 'كتاب «الحوسبة الجغرافية باستخدام بايثون»',
    sourceEn: 'Geocomputation with Python',
    entity: 'مؤلفون أكاديميون (Dorman وGraser وNowosad وLovelace)، ونُشر ورقيًا لدى CRC Press عام 2025',
    description: 'كتاب لتعلم معالجة البيانات المتجهة والشبكية ورسم الخرائط بمكتبات بايثون المفتوحة مع أمثلة قابلة للتنفيذ',
    scale: 'غير منطبق',
    coverage: 'غير منطبق',
    period: 'نسخة ورقية 2025',
    studyLevel: 'طلاب ينتقلون إلى التحليل البرمجي',
    access: 'مفتوح دون تسجيل للقراءة على الإنترنت',
    license: 'CC BY-NC-SA 4.0',
    formats: 'كتاب على الويب',
    url: 'https://py.geocompx.org',
  ),
];
