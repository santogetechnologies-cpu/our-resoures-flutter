import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';
import '../menu/fullscreen_menu_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
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
        pageBuilder: (context, animation, secondaryAnimation) => const FullscreenMenuScreen(),
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
            // Background wallpaper2.jpg
            Image.asset(
              AppAssets.wallpaper2,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(color: const Color(0xFFF7F4EF)),
            ),

            // Top Logos (Vision 2030 on left, KSU on right) matching activity_start.xml (200x200 dp)
            SafeArea(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vision 2030 logo (200x200)
                      Image.asset(
                        AppAssets.saudiVision,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const SizedBox(width: 200, height: 200),
                      ),
                      // King Saud University logo (200x200)
                      Image.asset(
                        AppAssets.dLogo,
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const SizedBox(width: 200, height: 200),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Center interactive click target with pulse animation matching 150x150 dp
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
                        width: 150,
                        height: 150,
                        fit: BoxFit.contain,
                        errorBuilder: (c, e, s) => const Icon(
                          Icons.touch_app,
                          size: 120,
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
