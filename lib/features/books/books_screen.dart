import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/map_shell.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/dialogs/pdf_viewer_dialog.dart';

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
  // Data Lists for Sub-Buttons
  // ---------------------------------------------------------------------------

  // 1. الموسوعة التعليمية (34 items)
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

  static const Map<String, String> _educationalBooksAssets = {
    'تمهيد الموسوعة': 'assets/books/educational/edu_book_01.pdf',
    'تقدير عمر الأرض': 'assets/books/educational/edu_book_02.pdf',
    'شكل الأرض وحركاتها': 'assets/books/educational/edu_book_03.pdf',
    'الجاذبية الأرضية وتطبيقاتها': 'assets/books/educational/edu_book_04.pdf',
    'التركيب الداخلي للأرض': 'assets/books/educational/edu_book_05.pdf',
    'المعادن والتعدين': 'assets/books/educational/edu_book_06.pdf',
    'المد والجزر': 'assets/books/educational/edu_book_07.pdf',
    'موجات التسونامي': 'assets/books/educational/edu_book_08.pdf',
    'الزلازل والتفجيرات': 'assets/books/educational/edu_book_09.pdf',
    'تقييم مخاطر الزلازل': 'assets/books/educational/edu_book_10.pdf',
    'البراكين وسبل مجابهتها': 'assets/books/educational/edu_book_11.pdf',
    'جيولوجية القمر': 'assets/books/educational/edu_book_12.pdf',
    'الأغلفة المحيطة بالأرض': 'assets/books/educational/edu_book_13.pdf',
    'المشاكل البيئية وحلولها': 'assets/books/educational/edu_book_14.pdf',
    'التغيرات المناخية والإحتباس الحراري':
        'assets/books/educational/edu_book_15.pdf',
    'التشجير التحديات والحلول': 'assets/books/educational/edu_book_16.pdf',
    'الإنزلاقات والإنهيارات والفيضانات':
        'assets/books/educational/edu_book_17.pdf',
    'الامطار والسيول والسدود': 'assets/books/educational/edu_book_18.pdf',
    'التصحر والجفاف': 'assets/books/educational/edu_book_19.pdf',
    'مستقبل الطاقة في عالمنا': 'assets/books/educational/edu_book_20.pdf',
    'الطاقة الحرارية الأرضية': 'assets/books/educational/edu_book_21.pdf',
    'هل انتهى عصر النفط': 'assets/books/educational/edu_book_22.pdf',
    'الجيوفيزياء النووية': 'assets/books/educational/edu_book_23.pdf',
    'الجيولوجيا الطبية': 'assets/books/educational/edu_book_24.pdf',
    'أنظمة الإنذار المبكر': 'assets/books/educational/edu_book_25.pdf',
    'الدليل الى كتابة الرسائل الجامعية والنشر العلمي عربي':
        'assets/books/educational/edu_book_26.pdf',
    'الدليل الى كتابة الرسائل الجامعية والنشر العلمي إنجليزي':
        'assets/books/educational/edu_book_27.pdf',
    '321 سؤال وجواب في أصل وتطور الأرض':
        'assets/books/educational/edu_book_28.pdf',
    '358 سؤال وجواب في علم الصخور والجيوكيمياء والاستشعار عن بعد':
        'assets/books/educational/edu_book_29.pdf',
    '358 سؤال وجواب في الثروات الطبيعية':
        'assets/books/educational/edu_book_30.pdf',
    '380 سؤال وجواب في المخاطر الجيولوجية':
        'assets/books/educational/edu_book_31.pdf',
    '303 سؤال وجواب في علم الزلازل والزلزالية الهندسية':
        'assets/books/educational/edu_book_32.pdf',
    '300 سؤال وجواب في الجيوفيزياء التطبيقية':
        'assets/books/educational/edu_book_33.pdf',
    'تطبيقات الذكاء الاصطناعي في علوم الأرض':
        'assets/books/educational/edu_book_34.pdf',
  };

  // 2. الموسوعة التخصصية (6 items)
  final List<String> _specializedEncyclopediaItems = const [
    'تمهيد',
    'تاريخ العلوم',
    'الأرض والفضاء',
    'المخاطر الطبيعية',
    'البيئة والمياه',
    'التعدين والطاقة',
  ];

  static const Map<String, String> _specializedBooksAssets = {
    'تمهيد': 'assets/books/specialized/spec_book_01.pdf',
    'تاريخ العلوم': 'assets/books/specialized/spec_book_02.pdf',
    'الأرض والفضاء': 'assets/books/specialized/spec_book_03.pdf',
    'المخاطر الطبيعية': 'assets/books/specialized/spec_book_04.pdf',
    'البيئة والمياه': 'assets/books/specialized/spec_book_05.pdf',
    'التعدين والطاقة': 'assets/books/specialized/spec_book_06.pdf',
  };

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

  static const Map<String, String> _zamzamBooksAssets = {
    'عربي': 'assets/books/zamzam/zamzam_ar.pdf',
    'انجليزي': 'assets/books/zamzam/zamzam_ar.pdf',
    'فرنسي': 'assets/books/zamzam/zamzam_ar.pdf',
    'ملاوي': 'assets/books/zamzam/zamzam_ar.pdf',
    'تركي': 'assets/books/zamzam/zamzam_ar.pdf',
    'روسي': 'assets/books/zamzam/zamzam_ar.pdf',
    'اوردو': 'assets/books/zamzam/zamzam_ar.pdf',
    'فارسي': 'assets/books/zamzam/zamzam_ar.pdf',
    'اسباني': 'assets/books/zamzam/zamzam_ar.pdf',
    'هندي': 'assets/books/zamzam/zamzam_ar.pdf',
    'بنغالي': 'assets/books/zamzam/zamzam_ar.pdf',
    'صيني': 'assets/books/zamzam/zamzam_ar.pdf',
    'سواحلي': 'assets/books/zamzam/zamzam_ar.pdf',
    'ياباني': 'assets/books/zamzam/zamzam_ar.pdf',
    'عبري': 'assets/books/zamzam/zamzam_ar.pdf',
  };

  // 4. الكتب (4 items)
  final List<String> _booksItems = const [
    'الجيولوجيا العامة',
    'كروية الأرض',
    'الجيوفيزياء التطبيقية',
    'رحلة كفاح بين السروات وطويق',
  ];

  static const Map<String, String> _generalBooksAssets = {
    'الجيولوجيا العامة': 'assets/books/general_books/book_01.pdf',
    'كروية الأرض': 'assets/books/general_books/book_02.pdf',
    'الجيوفيزياء التطبيقية': 'assets/books/general_books/book_03.pdf',
    'رحلة كفاح بين السروات وطويق': 'assets/books/general_books/book_04.pdf',
  };

  void _toggleMenu(String menuKey) {
    setState(() {
      if (_expandedMenu == menuKey) {
        _expandedMenu = null;
      } else {
        _expandedMenu = menuKey;
      }
    });
  }

  void _openPdfBook(String title, String? assetPath) {
    if (assetPath != null) {
      PdfViewerDialog.show(
        context,
        title: title,
        assetPath: assetPath,
      );
    }
  }

  Widget _buildSubItem(String text, VoidCallback onTap) {
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
          onTap: onTap,
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
      initialStyleAsset: 'assets/maps/saudi_geo/sahel.json',
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
            ..._educationalEncyclopediaItems.map(
              (text) => _buildSubItem(
                text,
                () => _openPdfBook(text, _educationalBooksAssets[text]),
              ),
            ),

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
            ..._specializedEncyclopediaItems.map(
              (text) => _buildSubItem(
                text,
                () => _openPdfBook(text, _specializedBooksAssets[text]),
              ),
            ),

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
            ..._zamzamEncyclopediaItems.map(
              (text) => _buildSubItem(
                text,
                () => _openPdfBook(
                    'موسوعة زمزم - $text', _zamzamBooksAssets[text]),
              ),
            ),

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
            ..._booksItems.map(
              (text) => _buildSubItem(
                text,
                () => _openPdfBook(text, _generalBooksAssets[text]),
              ),
            ),
        ],
      ),
    );
  }
}
