import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
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

  // Palette extracted directly from the design mockup
  static const Color _kBrownBg = Color(0xFF70392F);
  static const Color _kGoldBorder = Color(0xFFC59965);
  static const Color _kRowGrey = Color(0xFFD1D2D4);
  static const Color _kRowCream = Color(0xFFFEFCE8);
  static const Color _kNavyDivider = Color(0xFF253F8E);

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

  // Top beveled brown header banner with gold border
  Widget _buildTopBanner({required String title}) {
    return Container(
      height: 72,
      decoration: ShapeDecoration(
        color: _kBrownBg,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: _kGoldBorder, width: 2.5),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'NotoKufi',
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Beveled brown badge for "ثرواتنا من أرضنا"
  Widget _buildBadge({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: ShapeDecoration(
        color: _kBrownBg,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: _kGoldBorder, width: 2.0),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'NotoKufi',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Row inside the 10-button table grid (Exact border design: open perimeter, 5px dividers, double central line)
  Widget _buildGridRow({
    required BuildContext context,
    required String rightTitle,
    required VoidCallback rightOnTap,
    required String leftTitle,
    required VoidCallback leftOnTap,
    required Color bgColor,
    double height = 74,
  }) {
    return Container(
      height: height,
      color: bgColor,
      child: Row(
        children: [
          // Right button (First column in RTL)
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: rightOnTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      rightTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Central vertical double royal navy line (5px blue, 4px white gap, 5px blue)
          Container(
            width: 14,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border.symmetric(
                vertical: BorderSide(color: _kNavyDivider, width: 5.0),
              ),
            ),
          ),

          // Left button (Second column in RTL)
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: leftOnTap,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  alignment: Alignment.center,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      leftTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal royal navy divider between table rows (5px thick)
  Widget _buildRowDivider() {
    return Container(
      height: 5.0,
      color: _kNavyDivider,
    );
  }

  // Bottom navigation buttons
  Widget _buildBottomNavButton({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
    double width = 210,
    double height = 48,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: _kBrownBg,
        shape: BeveledRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: _kGoldBorder, width: 1.5),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          customBorder: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'NotoKufi',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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
        backgroundColor: Colors.white,
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Subtle wallpaper background with very low opacity
            Opacity(
              opacity: 0.10,
              child: Image.asset(
                AppAssets.wallpaper5,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.white),
              ),
            ),

            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // Responsive logo sizing
                  final logoSize =
                      (constraints.maxHeight * 0.17).clamp(90.0, 140.0);

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 860),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // 1. Top Beveled Banner
                                _buildTopBanner(
                                  title:
                                      'منصة العمري التفاعلية لعلوم الأرض والطبيعة',
                                ),

                                const SizedBox(height: 10),

                                // 2. Central Circular Alamry Logo
                                Center(
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

                                const SizedBox(height: 8),

                                // 3. Beveled Badge: "ثرواتنا من أرضنا"
                                _buildBadge(
                                  context: context,
                                  title: 'ثرواتنا من أرضنا',
                                  onTap: () =>
                                      AboutDialogs.showMineralLocations(context),
                                ),

                                const SizedBox(height: 14),

                                // 4. The 10 Buttons Unified Table / Grid (Exact design from mockup: open perimeter, 5px dividers, double central line)
                                Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // Row 1 (Grey)
                                      _buildGridRow(
                                        context: context,
                                        rightTitle:
                                            'جيولوجية و جيومورفولوجية المملكة',
                                        rightOnTap: () => _navigate(
                                          context,
                                          const GeologyScreen(),
                                        ),
                                        leftTitle: 'الصخور والمعادن الإقتصادية',
                                        leftOnTap: () => _navigate(
                                          context,
                                          const MaterialsScreen(),
                                        ),
                                        bgColor: _kRowGrey,
                                      ),
                                      _buildRowDivider(),

                                      // Row 2 (Cream)
                                      _buildGridRow(
                                        context: context,
                                        rightTitle: 'البترول والغاز',
                                        rightOnTap: () => _navigate(
                                          context,
                                          const OilGasScreen(),
                                        ),
                                        leftTitle: 'مصادر المياه',
                                        leftOnTap: () => _navigate(
                                          context,
                                          const WaterFormationsScreen(),
                                        ),
                                        bgColor: _kRowCream,
                                      ),
                                      _buildRowDivider(),

                                      // Row 3 (Grey)
                                      _buildGridRow(
                                        context: context,
                                        rightTitle: 'السياحة والآثار',
                                        rightOnTap: () => _navigate(
                                          context,
                                          const TourismScreen(),
                                        ),
                                        leftTitle: 'المحميات الطبيعية',
                                        leftOnTap: () =>
                                            AboutDialogs.showNaturalReserves(
                                                context),
                                        bgColor: _kRowGrey,
                                      ),
                                      _buildRowDivider(),

                                      // Row 4 (Cream)
                                      _buildGridRow(
                                        context: context,
                                        rightTitle:
                                            'استراتيجية المخاطر الطبيعية',
                                        rightOnTap: () =>
                                            AboutDialogs.showHazards(context),
                                        leftTitle: 'الموسوعات والكتب',
                                        leftOnTap: () => _navigate(
                                          context,
                                          const BooksScreen(),
                                        ),
                                        bgColor: _kRowCream,
                                      ),
                                      _buildRowDivider(),

                                      // Row 5 (Grey)
                                      _buildGridRow(
                                        context: context,
                                        rightTitle: 'قاعدة البيانات الزلزالية',
                                        rightOnTap: () => _navigate(
                                          context,
                                          const EarthquakeScreen(),
                                        ),
                                        leftTitle: 'الاستشعار عن بعد وال GIS',
                                        leftOnTap: () =>
                                            AboutDialogs.showRemoteSensing(
                                                context),
                                        bgColor: _kRowGrey,
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // 5. Bottom Navigation Row (2 Buttons)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildBottomNavButton(
                                      context: context,
                                      title: 'نبذة تعريفية',
                                      onTap: () =>
                                          AboutDialogs.showIntroduction(context),
                                    ),
                                    const SizedBox(width: 24),
                                    _buildBottomNavButton(
                                      context: context,
                                      title: 'صفحة البداية',
                                      onTap: () {
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context).pop();
                                        } else {
                                          _navigate(
                                            context,
                                            const StartScreen(),
                                          );
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
