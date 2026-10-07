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
  // Expanded state for the 4 main dropdown items:
  // 'educational', 'specialized', 'zamzam', 'books', or null
  String? _expandedMenu;

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
    'عربي',
    'انجليزي',
    'فرنسي',
    'ملاوي',
    'تركي',
    'روسي',
    'اوردو',
    'فارسي',
    'اسباني',
    'هندي',
    'بنغالي',
    'صيني',
    'سواحلي',
    'ياباني',
    'عبري',
  ];

  // 4. الكتب (4 items)
  final List<String> _booksItems = const [
    'الجيولوجيا العامة',
    'كروية الأرض',
    'الجيوفيزياء التطبيقية',
    'رحلة كفاح بين السروات وطويق',
  ];

  void _toggleMenu(String menuKey) {
    setState(() {
      if (_expandedMenu == menuKey) {
        _expandedMenu = null;
      } else {
        _expandedMenu = menuKey;
      }
    });
  }

  Widget _buildDummySubItem(String text) {
    return Container(
      width: double.infinity,
      height: 46,
      margin: const EdgeInsets.symmetric(horizontal: 22, vertical: 3.5),
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
                    fontSize: 16.5,
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
      title: 'الموسوعات والكتب',
      sidebarContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // =================================================================
          // 1. الموسوعة التعليمية
          // =================================================================
          CustomButton(
            text: 'الموسوعة التعليمية',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () => _toggleMenu('educational'),
          ),
          if (_expandedMenu == 'educational')
            ..._educationalEncyclopediaItems.map(_buildDummySubItem),

          const SizedBox(height: 6),

          // =================================================================
          // 2. الموسوعة التخصصية
          // =================================================================
          CustomButton(
            text: 'الموسوعة التخصصية',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () => _toggleMenu('specialized'),
          ),
          if (_expandedMenu == 'specialized')
            ..._specializedEncyclopediaItems.map(_buildDummySubItem),

          const SizedBox(height: 6),

          // =================================================================
          // 3. موسوعة زمزم
          // =================================================================
          CustomButton(
            text: 'موسوعة زمزم',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () => _toggleMenu('zamzam'),
          ),
          if (_expandedMenu == 'zamzam')
            ..._zamzamEncyclopediaItems.map(_buildDummySubItem),

          const SizedBox(height: 6),

          // =================================================================
          // 4. الكتب
          // =================================================================
          CustomButton(
            text: 'الكتب',
            styleType: ButtonStyleType.mainMenu,
            onPressed: () => _toggleMenu('books'),
          ),
          if (_expandedMenu == 'books')
            ..._booksItems.map(_buildDummySubItem),
        ],
      ),
    );
  }
}
