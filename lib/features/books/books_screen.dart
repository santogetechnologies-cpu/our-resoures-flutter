import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  // Main Category expanded state: null, 'encyclopedias', 'books', 'research', 'reports'
  String? _expandedCategory;

  // Sub-category expanded states inside 'الموسوعات'
  String? _expandedEncyclopedia;

  // ---------------------------------------------------------------------------
  // Data Lists for Sub-Buttons (DUMMY)
  // ---------------------------------------------------------------------------

  // 1. الموسوعة التعليمية (35 items)
  final List<String> _educationalEncyclopediaItems = const [
    'تمهيد الموسوعة',
    'تقدير عمر الأرض',
    'شكل الأرض وحركاتها',
    'الجاذبية الأرضية وتطبيقاتها',
    'التركيب الداخلي للأرض',
    'المعادن والتعدين',
    'المد والجزر',
    'موجات التسونامي',
    'الزلازل والتفجيرات',
    'تقييم مخاطر الزلازل',
    'البراكين وسبل مجابهتها',
    'جيولوجية القمر',
    'الأغلفة المحيطة بالأرض',
    'المشاكل البيئية وحلولها',
    'التغيرات المناخية والإحتباس الحراري',
    'التشجير التحديات والحلول',
    'الإنزلاقات والإنهيارات والفيضانات',
    'الامطار والسيول والسدود',
    'التصحر والجفاف',
    'مستقبل الطاقة في عالمنا',
    'الطاقة الحرارية الأرضية',
    'هل انتهى عصر النفط',
    'الجيوفيزياء النووية',
    'الجيولوجيا الطبية',
    'أنظمة الإنذار المبكر',
    'الدليل الى كتابة الرسائل الجامعية والنشر العلمي عربي',
    'الدليل الى كتابة الرسائل الجامعية والنشر العلمي إنجليزي',
    '321 سؤال وجواب في أصل وتطور الأرض',
    '358 سؤال وجواب في علم الصخور والجيوكيمياء والاستشعار عن بعد',
    '358 سؤال وجواب في الثروات الطبيعية',
    '380 سؤال وجواب في المخاطر الجيولوجية',
    '303 سؤال وجواب في علم الزلازل والزلزالية الهندسية',
    '300 سؤال وجواب في الجيوفيزياء التطبيقية',
    'تطبيقات الذكاء الاصطناعي في علوم الأرض',
  ];

  // 2. الموسوعة التخصصية (6 items)
  final List<String> _specializedEncyclopediaItems = const [
    'تمهيد',
    'تاريخ العلوم',
    'الأرض والفضاء',
    'المخاطر الطبيعية',
    'البيئة والمياه',
    'التعدين والطاقة',
  ];

  // 3. موسوعة زمزم (15 items)
  final List<String> _zamzamEncyclopediaItems = const [
    'عربي - Arabic',
    'انجليزي - English',
    'فرنسي - French',
    'ملاوي - Malawi',
    'تركي - Turkish',
    'روسي - Russian',
    'اوردو - Urdo',
    'فارسي - Persian',
    'اسباني - Spanish',
    'هندي - Hindi',
    'بنغالي - Bengali',
    'صيني - Chinese',
    'سواحلي - Swahili',
    'ياباني - Japanese',
    'عبري - Hebrew',
  ];

  // 4. الكتب (4 items)
  final List<String> _booksItems = const [
    'الجيولوجيا العامه',
    'كروية الأرض',
    'الجيوفيزياء التطبيقية',
    'رحلة كفاح بين السروات وطويق',
  ];

  void _toggleCategory(String categoryKey) {
    setState(() {
      if (_expandedCategory == categoryKey) {
        _expandedCategory = null;
        _expandedEncyclopedia = null;
      } else {
        _expandedCategory = categoryKey;
        _expandedEncyclopedia = null;
      }
    });
  }

  void _toggleEncyclopedia(String encKey) {
    setState(() {
      if (_expandedEncyclopedia == encKey) {
        _expandedEncyclopedia = null;
      } else {
        _expandedEncyclopedia = encKey;
      }
    });
  }

  Widget _buildDummySubItem(String text) {
    return Container(
      width: double.infinity,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 3.5),
      decoration: BoxDecoration(
        color: AppColors.subMenuBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.85), width: 1.2),
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
          onTap: () {
            // Dummy button - no click action
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 16,
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

  Widget _buildSubSectionHeader({
    required String title,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: isExpanded ? AppColors.categoryBtnBg : AppColors.mainMenuBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 6,
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textBlack,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      size: 22,
                      color: AppColors.textBlack,
                    ),
                  ],
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
      title: 'الموسوعات والكتب',
      sidebarContent: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // =================================================================
            // 1. الموسوعات (Encyclopedias)
            // =================================================================
            CustomButton(
              text: 'الموسوعات',
              styleType: ButtonStyleType.mainMenu,
              onPressed: () => _toggleCategory('encyclopedias'),
            ),
            if (_expandedCategory == 'encyclopedias') ...[
              // 1.1 الموسوعة التعليمية
              _buildSubSectionHeader(
                title: 'الموسوعة التعليمية',
                isExpanded: _expandedEncyclopedia == 'educational',
                onTap: () => _toggleEncyclopedia('educational'),
              ),
              if (_expandedEncyclopedia == 'educational')
                ..._educationalEncyclopediaItems.map(_buildDummySubItem),

              // 1.2 الموسوعة التخصصية
              _buildSubSectionHeader(
                title: 'الموسوعة التخصصية',
                isExpanded: _expandedEncyclopedia == 'specialized',
                onTap: () => _toggleEncyclopedia('specialized'),
              ),
              if (_expandedEncyclopedia == 'specialized')
                ..._specializedEncyclopediaItems.map(_buildDummySubItem),

              // 1.3 موسوعة زمزم
              _buildSubSectionHeader(
                title: 'موسوعة زمزم',
                isExpanded: _expandedEncyclopedia == 'zamzam',
                onTap: () => _toggleEncyclopedia('zamzam'),
              ),
              if (_expandedEncyclopedia == 'zamzam')
                ..._zamzamEncyclopediaItems.map(_buildDummySubItem),
            ],

            const SizedBox(height: 6),

            // =================================================================
            // 2. الكتب (Books)
            // =================================================================
            CustomButton(
              text: 'الكتب',
              styleType: ButtonStyleType.mainMenu,
              onPressed: () => _toggleCategory('books'),
            ),
            if (_expandedCategory == 'books')
              ..._booksItems.map(_buildDummySubItem),

            const SizedBox(height: 6),

            // =================================================================
            // 3. الأبحاث والأوراق العلمية (Research & Scientific Papers)
            // =================================================================
            CustomButton(
              text: 'الأبحاث والأوراق العلمية',
              styleType: ButtonStyleType.mainMenu,
              onPressed: () => _toggleCategory('research'),
            ),
            if (_expandedCategory == 'research') ...[
              _buildDummySubItem('لا توجد أبحاث حالياً'),
            ],

            const SizedBox(height: 6),

            // =================================================================
            // 4. التقارير والدراسات (Reports & Studies)
            // =================================================================
            CustomButton(
              text: 'التقارير والدراسات',
              styleType: ButtonStyleType.mainMenu,
              onPressed: () => _toggleCategory('reports'),
            ),
            if (_expandedCategory == 'reports') ...[
              _buildDummySubItem('لا توجد تقارير حالياً'),
            ],
          ],
        ),
      ),
    );
  }
}
