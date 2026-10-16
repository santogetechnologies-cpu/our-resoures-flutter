import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../menu/fullscreen_menu_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _navigateToMenu() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const FullscreenMenuScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _navigateToMenu,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background wallpaper
            Image.asset(
              AppAssets.wallpaper2,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) =>
                  Container(color: const Color(0xFFF7F4EF)),
            ),

            // Top Header: Vision 2030 on Left, Title in Center, KSU on Right
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Vision 2030 logo on Left
                        Image.asset(
                          AppAssets.saudiVision,
                          width: 140,
                          height: 95,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const SizedBox(width: 140),
                        ),

                        // Center Arabic Title: منصة العمري التفاعلية لعلوم الأرض والطبيعة (single line, scaled)
                        const Expanded(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'منصة العمري التفاعلية لعلوم الأرض والطبيعة',
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                  fontFamily: 'NotoKufi',
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6B3A22),
                                  shadows: [
                                    Shadow(
                                      color: Colors.white,
                                      offset: Offset(0, 2),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // King Saud University logo on Right
                        Image.asset(
                          AppAssets.dLogo,
                          width: 140,
                          height: 95,
                          fit: BoxFit.contain,
                          errorBuilder: (c, e, s) => const SizedBox(width: 140),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Center interactive click target with pulse animation
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: InkWell(
                    onTap: _navigateToMenu,
                    borderRadius: BorderRadius.circular(100),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Image.asset(
                        AppAssets.click,
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.touch_app,
                          size: 110,
                          color: Color(0xFF7F4D2C),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
