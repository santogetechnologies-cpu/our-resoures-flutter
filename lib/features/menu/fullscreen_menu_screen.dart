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
        border: Border.all(color: Colors.white.withOpacity(0.85), width: 1.5),
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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 27, // Increased by 40% from 19
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

  Widget _buildFullLengthBannerButton({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 48,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.categoryBtnBg,
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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'ثرواتنا من أرضنا',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'NotoKufi',
                      fontSize: 27, // Increased by 40%
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  width: 1.5,
                  height: 22,
                  color: const Color(0xFF8E1B1B).withOpacity(0.4),
                ),
                const SizedBox(width: 16),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Our Wealth from Our Land',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'NotoKufi',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8E1B1B),
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

  Widget _buildBottomNavButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    double width = 200,
    double height = 44,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.categoryBtnBg,
        borderRadius: BorderRadius.circular(AppColors.borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.85), width: 1.5),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 27, // Increased by 40% from 19
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
                      height: 64,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.categoryBtnBg,
                        borderRadius: BorderRadius.circular(AppColors.borderRadius),
                        border: Border.all(color: Colors.white.withOpacity(0.85), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Saudi Vision 2030 logo
                          Image.asset(
                            AppAssets.saudiVision,
                            width: 85,
                            height: 55,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const SizedBox(width: 85),
                          ),

                          // Centered Title (Increased Arabic text size by 40% to 40px)
                          const Expanded(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'علوم الأرض في خدمة الجميع',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'NotoKufi',
                                  fontSize: 40, // Increased by 40% from 28
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textBlack,
                                ),
                              ),
                            ),
                          ),

                          // KSU logo
                          Image.asset(
                            AppAssets.dLogo,
                            width: 85,
                            height: 55,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const SizedBox(width: 85),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Separate full length button for "Our Wealth from Our Land"
                    _buildFullLengthBannerButton(
                      context: context,
                      onTap: () => AboutDialogs.showNaturalResources(context),
                    ),

                    const SizedBox(height: 8),

                    // Main 2-Column Grid (10 Category Buttons with reduced height & no English text)
                    // In RTL:
                    // Column 1 (Visual Right - Odd: 1, 3, 5, 7, 9):
                    // 1: الاستشعار عن بعد وال GIS
                    // 3: مواقع المعادن الاقتصادية
                    // 5: مصادر المياه والتحديات
                    // 7: المحميات الطبيعية
                    // 9: الموسوعات والكتب
                    //
                    // Column 2 (Visual Left - Even: 2, 4, 6, 8, 10):
                    // 2: جيولوجية و جيومورفولوجية المملكة
                    // 4: الطاقة المتجددة و تقنياتها
                    // 6: المواقع الاثرية والقرى التراثية
                    // 8: استراتيجية المخاطر الطبيعية
                    // 10: قاعدة البيانات الزلزالية
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Row 1 (1 & 2)
                            Expanded(
                              child: Row(
                                children: [
                                  // Right (1): الاستشعار عن بعد وال GIS
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'الاستشعار عن بعد وال GIS',
                                      onTap: () => AboutDialogs.showRemoteSensing(context),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Left (2): جيولوجية و جيومورفولوجية المملكة
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'جيولوجية و جيومورفولوجية المملكة',
                                      onTap: () => _navigate(context, const GeologyScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Row 2 (3 & 4)
                            Expanded(
                              child: Row(
                                children: [
                                  // Right (3): مواقع المعادن الاقتصادية
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'مواقع المعادن الاقتصادية',
                                      onTap: () => _navigate(context, const MaterialsScreen()),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Left (4): الطاقة المتجددة و تقنياتها
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'الطاقة المتجددة و تقنياتها',
                                      onTap: () => _navigate(context, const OilGasScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Row 3 (5 & 6)
                            Expanded(
                              child: Row(
                                children: [
                                  // Right (5): مصادر المياه والتحديات
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'مصادر المياه والتحديات',
                                      onTap: () => _navigate(context, const WaterFormationsScreen()),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Left (6): المواقع الاثرية والقرى التراثية
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'المواقع الاثرية والقرى التراثية',
                                      onTap: () => _navigate(context, const TourismScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Row 4 (7 & 8)
                            Expanded(
                              child: Row(
                                children: [
                                  // Right (7): المحميات الطبيعية
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'المحميات الطبيعية',
                                      onTap: () => AboutDialogs.showNaturalReserves(context),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Left (8): استراتيجية المخاطر الطبيعية
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'استراتيجية المخاطر الطبيعية',
                                      onTap: () => AboutDialogs.showHazards(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Row 5 (9 & 10)
                            Expanded(
                              child: Row(
                                children: [
                                  // Right (9): الموسوعات والكتب
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'الموسوعات والكتب',
                                      onTap: () => AboutDialogs.showEncyclopedia(context),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Left (10): قاعدة البيانات الزلزالية
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'قاعدة البيانات الزلزالية',
                                      onTap: () => _navigate(context, const EarthquakeScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

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
                        const SizedBox(width: 20),
                        _buildBottomNavButton(
                          context: context,
                          title: 'نبذة تعريفية',
                          onTap: () => AboutDialogs.showIntroduction(context),
                        ),
                        const SizedBox(width: 20),
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
