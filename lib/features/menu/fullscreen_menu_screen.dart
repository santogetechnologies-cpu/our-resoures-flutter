import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/dialogs/about_dialog.dart';
import '../start/start_screen.dart';
import '../geology/geology_screen.dart';
import '../materials/materials_screen.dart';
import '../water/water_formations_screen.dart';
import '../tourism/tourism_screen.dart';
import '../earthquake/earthquake_screen.dart';
import '../oil_gas/oil_gas_screen.dart';
import '../books/books_screen.dart';

class FullscreenMenuScreen extends StatelessWidget {
  const FullscreenMenuScreen({super.key});

  void _navigate(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  Widget _buildCategoryButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    double height = 64,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.categoryBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    double width = 210,
    double height = 50,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.categoryBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 6,
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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F4EF),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background wallpaper with reduced opacity
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                AppAssets.wallpaper5,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) =>
                    Container(color: const Color(0xFFF7F4EF)),
              ),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final logoSize =
                      (constraints.maxHeight * 0.115).clamp(65.0, 95.0);

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Top Header Bar
                              Container(
                                height: 78,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 6),
                                decoration: BoxDecoration(
                                  color: AppColors.categoryBtnBg,
                                  borderRadius: BorderRadius.circular(
                                      AppColors.borderRadius),
                                  border: Border.all(
                                      color: Colors.white.withOpacity(0.85),
                                      width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.14),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Alamry platform logo
                                    Image.asset(
                                      AppAssets.alamryLogo,
                                      width: 110,
                                      height: 66,
                                      fit: BoxFit.contain,
                                      errorBuilder: (c, e, s) =>
                                          const SizedBox(width: 110),
                                    ),

                                    // Centered Title
                                    const Expanded(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          'منصة العمري التفاعلية لعلوم الأرض والطبيعة',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: 'NotoKufi',
                                            fontSize: 52,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.textBlack,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // KSU logo
                                    Image.asset(
                                      AppAssets.dLogo,
                                      width: 110,
                                      height: 66,
                                      fit: BoxFit.contain,
                                      errorBuilder: (c, e, s) =>
                                          const SizedBox(width: 110),
                                    ),
                                  ],
                                ),
                              ),

                              // Centrally positioned circular Alamry Logo between the two headings
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2),
                                child: Center(
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/alamry_logo.png',
                                      width: logoSize,
                                      height: logoSize,
                                      fit: BoxFit.contain,
                                      errorBuilder: (c, e, s) =>
                                          const SizedBox.shrink(),
                                    ),
                                  ),
                                ),
                              ),

                              // Clickable Button: "ثرواتنا من أرضنا" (opens مواقع المعادن dialog)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Center(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.categoryBtnBg,
                                      borderRadius:
                                          BorderRadius.circular(AppColors.borderRadius),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.95),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.12),
                                          blurRadius: 6,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius:
                                            BorderRadius.circular(AppColors.borderRadius),
                                        onTap: () =>
                                            AboutDialogs.showMineralLocations(context),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 28, vertical: 6),
                                          child: Text(
                                            'ثرواتنا من أرضنا',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'NotoKufi',
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF8B221E),
                                              shadows: [
                                                Shadow(
                                                  color: Colors.white,
                                                  offset: Offset(0, 1),
                                                  blurRadius: 4,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Main 2-Column Grid (10 Category Buttons with increased height and proper alignment)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Row 1 (1 & 2)
                                    Row(
                                      children: [
                                        // Right (1): جيولوجية و جيومورفولوجية المملكة
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title:
                                                'جيولوجية و جيومورفولوجية المملكة',
                                            height: 64,
                                            onTap: () => _navigate(
                                                context, const GeologyScreen()),
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        // Left (2): الصخور والمعادن الإقتصادية
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title:
                                                'الصخور والمعادن الإقتصادية',
                                            height: 64,
                                            onTap: () => _navigate(context,
                                                const MaterialsScreen()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Row 2 (3 & 4)
                                    Row(
                                      children: [
                                        // Right (3): البترول والغاز
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title: 'البترول والغاز',
                                            height: 64,
                                            onTap: () => _navigate(
                                                context, const OilGasScreen()),
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        // Left (4): مصادر المياه
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title: 'مصادر المياه',
                                            height: 64,
                                            onTap: () => _navigate(context,
                                                const WaterFormationsScreen()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Row 3 (5 & 6)
                                    Row(
                                      children: [
                                        // Right (5): السياحة والآثار
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title: 'السياحة والآثار',
                                            height: 64,
                                            onTap: () => _navigate(
                                                context, const TourismScreen()),
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        // Left (6): المحميات الطبيعية
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title: 'المحميات الطبيعية',
                                            height: 64,
                                            onTap: () => AboutDialogs
                                                .showNaturalReserves(context),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Row 4 (7 & 8)
                                    Row(
                                      children: [
                                        // Right (7): استراتيجية المخاطر الطبيعية
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title:
                                                'استراتيجية المخاطر الطبيعية',
                                            height: 64,
                                            onTap: () =>
                                                AboutDialogs.showHazards(
                                                    context),
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        // Left (8): الموسوعات والكتب
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title: 'الموسوعات والكتب',
                                            height: 64,
                                            onTap: () => _navigate(
                                                context, const BooksScreen()),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),

                                    // Row 5 (9 & 10)
                                    Row(
                                      children: [
                                        // Right (9): قاعدة البيانات الزلزالية
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title: 'قاعدة البيانات الزلزالية',
                                            height: 64,
                                            onTap: () => _navigate(context,
                                                const EarthquakeScreen()),
                                          ),
                                        ),
                                        const SizedBox(width: 24),
                                        // Left (10): الاستشعار عن بعد وال GIS
                                        Expanded(
                                          child: _buildCategoryButton(
                                            context: context,
                                            title: 'الاستشعار عن بعد وال GIS',
                                            height: 64,
                                            onTap: () =>
                                                AboutDialogs.showRemoteSensing(
                                                    context),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              // Bottom Navigation Row (2 Buttons):
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildBottomNavButton(
                                    context: context,
                                    title: 'نبذة تعريفية',
                                    width: 210,
                                    height: 50,
                                    onTap: () =>
                                        AboutDialogs.showIntroduction(context),
                                  ),
                                  const SizedBox(width: 24),
                                  _buildBottomNavButton(
                                    context: context,
                                    title: 'صفحة البداية',
                                    width: 210,
                                    height: 50,
                                    onTap: () {
                                      if (Navigator.of(context).canPop()) {
                                        Navigator.of(context).pop();
                                      } else {
                                        _navigate(context, const StartScreen());
                                      }
                                    },
                                  ),
                                ],
                              ),

                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
