import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_theme.dart';
import '../../core/dialogs/about_dialog.dart';
import '../geology/geology_screen.dart';
import '../materials/materials_screen.dart';
import '../water/water_formations_screen.dart';
import '../oil_gas/oil_gas_screen.dart';
import '../tourism/tourism_screen.dart';
import '../earthquake/earthquake_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background wallpaper5.jpg
            Image.asset(
              AppAssets.wallpaper5,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: const Color(0xFFF7F4EF)),
            ),

            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  children: [
                    // Top Header Bar
                    Container(
                      height: 75,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.categoryBtnBg,
                        borderRadius: BorderRadius.circular(AppColors.borderRadius),
                        border: Border.all(color: Colors.white.withOpacity(0.7), width: 1.5),
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
                            width: 90,
                            height: 65,
                            fit: BoxFit.contain,
                            errorBuilder: (c, e, s) => const SizedBox(width: 90),
                          ),

                          // Center Title
                          const Expanded(
                            child: Text(
                              'علوم الأرض في خدمة الجميع',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'NotoKufi',
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textBlack,
                              ),
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

                    // Top "نبذة تعريفية" Button
                    Container(
                      width: 280,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.categoryBtnBg,
                        borderRadius: BorderRadius.circular(AppColors.borderRadius),
                        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(AppColors.borderRadius),
                          onTap: () => AboutDialogs.showIntroduction(context),
                          child: const Center(
                            child: Text(
                              'نبذة تعريفية',
                              style: TextStyle(
                                fontFamily: 'NotoKufi',
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 4x2 Grid of 8 Buttons in the exact order attached:
                    // Row 1: Right = جيولوجية المملكة  | Left = الصخور والمعادن الإقتصادية
                    // Row 2: Right = مصادر المياه      | Left = البترول والغاز
                    // Row 3: Right = السياحة والآثار   | Left = قاعدة البيانات الزلزالية
                    // Row 4: Right = المخاطر           | Left = مصادر طبيعية
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: [
                            // Row 1
                            Expanded(
                              child: Row(
                                children: [
                                  // Right column in RTL
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'جيولوجية المملكة',
                                      onTap: () => _navigate(context, const GeologyScreen()),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left column in RTL
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'الصخور والمعادن الإقتصادية',
                                      onTap: () => _navigate(context, const MaterialsScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Row 2
                            Expanded(
                              child: Row(
                                children: [
                                  // Right column in RTL
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'مصادر المياه',
                                      onTap: () => _navigate(context, const WaterFormationsScreen()),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left column in RTL
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'البترول والغاز',
                                      onTap: () => _navigate(context, const OilGasScreen()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Row 3
                            Expanded(
                              child: Row(
                                children: [
                                  // Right column in RTL
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'السياحة والآثار',
                                      onTap: () => _navigate(context, const TourismScreen()),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left column in RTL
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
                            const SizedBox(height: 12),

                            // Row 4
                            Expanded(
                              child: Row(
                                children: [
                                  // Right column in RTL
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'المخاطر',
                                      onTap: () => AboutDialogs.showHazards(context),
                                    ),
                                  ),
                                  const SizedBox(width: 22),
                                  // Left column in RTL
                                  Expanded(
                                    child: _buildCategoryButton(
                                      context: context,
                                      title: 'مصادر طبيعية',
                                      onTap: () => AboutDialogs.showNaturalResources(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
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
