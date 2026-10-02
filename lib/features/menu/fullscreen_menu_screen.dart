import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/dialogs/about_dialog.dart';
import '../start/start_screen.dart';
import '../geology/geology_screen.dart';
import '../materials/materials_screen.dart';
import '../water/water_formations_screen.dart';
import '../oil_gas/oil_gas_screen.dart';
import '../tourism/tourism_screen.dart';

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
  }) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.categoryBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.14),
            blurRadius: 10,
            offset: const Offset(0, 4),
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
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
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
    double width = 200,
    double height = 48,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.categoryBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
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
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background wallpaper
            Image.asset(
              AppAssets.wallpaper5,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: const Color(0xFFF7F4EF)),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    // Top Header Bar with Translucent White Card Background
                    Container(
                      height: 78,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.categoryBtnBg,
                        borderRadius: BorderRadius.circular(AppColors.borderRadius),
                        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Saudi Vision 2030 logo
                          Image.asset(
                            AppAssets.saudiVision,
                            width: 90,
                            height: 65,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const SizedBox(width: 90),
                          ),

                          // Centered Titles
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'علوم الأرض في خدمة الجميع',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'NotoKufi',
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textBlack,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    'Our Wealth from Our Land',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: 'NotoKufi',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF8E1B1B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // KSU logo
                          Image.asset(
                            AppAssets.dLogo,
                            width: 90,
                            height: 65,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const SizedBox(width: 90),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Main 2-Column Grid (5 Rows x 2 Columns)
                    // In RTL:
                    // Column 1 (Visual Right): الاستشعار عن بعد و GIS, الصخور والمعادن الإقتصادية, البترول والغاز, محمية طبيعية, زلزال
                    // Column 2 (Visual Left): جيولوجية المملكة, مصادر المياه, السياحة و الآثار, الموسوعات و الكتب, بيئة
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Row 1
                            Expanded(
                              child: Row(
                                children: [
                                  // Right in RTL: الاستشعار عن بعد و GIS
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'الاستشعار عن بعد و GIS',
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left in RTL: جيولوجية المملكة
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'جيولوجية المملكة',
                                      onTap: () => _navigate(context, const GeologyScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Row 2
                            Expanded(
                              child: Row(
                                children: [
                                  // Right in RTL: الصخور والمعادن الإقتصادية
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'الصخور والمعادن الإقتصادية',
                                      onTap: () => _navigate(context, const MaterialsScreen()),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left in RTL: مصادر المياه
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'مصادر المياه',
                                      onTap: () => _navigate(context, const WaterFormationsScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Row 3
                            Expanded(
                              child: Row(
                                children: [
                                  // Right in RTL: البترول والغاز
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'البترول والغاز',
                                      onTap: () => _navigate(context, const OilGasScreen()),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left in RTL: السياحة و الآثار
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'السياحة و الآثار',
                                      onTap: () => _navigate(context, const TourismScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Row 4
                            Expanded(
                              child: Row(
                                children: [
                                  // Right in RTL: محمية طبيعية
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'محمية طبيعية',
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left in RTL: الموسوعات و الكتب
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'الموسوعات و الكتب',
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),

                            // Row 5
                            Expanded(
                              child: Row(
                                children: [
                                  // Right in RTL: زلزال
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'زلزال',
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left in RTL: بيئة
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'بيئة',
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Bottom Navigation Row (3 Buttons):
                    // In RTL: Right = المصادر | Center = نبذة تعريفية | Left = صفحة البداية
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildBottomNavButton(
                          context: context,
                          title: 'المصادر',
                          onTap: () => AboutDialogs.showReferences(context),
                        ),
                        const SizedBox(width: 22),
                        _buildBottomNavButton(
                          context: context,
                          title: 'نبذة تعريفية',
                          onTap: () => AboutDialogs.showIntroduction(context),
                        ),
                        const SizedBox(width: 22),
                        _buildBottomNavButton(
                          context: context,
                          title: 'صفحة البداية',
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
          ],
        ),
      ),
    );
  }
}
