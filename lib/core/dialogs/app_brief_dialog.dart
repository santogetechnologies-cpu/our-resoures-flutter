import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';

import '../widgets/map_view_platform.dart';

class AppBriefDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? bannerAsset;
  final String? bottomImageAsset;
  final Widget? bottomWidget;

  const AppBriefDialog({
    super.key,
    required this.title,
    required this.description,
    this.bannerAsset,
    this.bottomImageAsset,
    this.bottomWidget,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    String? bannerAsset,
    String? bottomImageAsset,
    Widget? bottomWidget,
  }) async {
    setModalOpenWeb(true);
    try {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => AppBriefDialog(
          title: title,
          description: description,
          bannerAsset: bannerAsset,
          bottomImageAsset: bottomImageAsset,
          bottomWidget: bottomWidget,
        ),
      );
    } finally {
      setModalOpenWeb(false);
    }
  }

  void _showZoomableImage(BuildContext context, String imageAsset) async {
    setModalOpenWeb(true);
    try {
      await showDialog(
        context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.92),
        insetPadding: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Center(
              child: InteractiveViewer(
                minScale: 0.5,
                maxScale: 6.0,
                child: Image.asset(
                  imageAsset,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 24),
                ),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ),
          ],
        ),
      ),
    );
    } finally {
      setModalOpenWeb(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.78;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
        ),
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(maxHeight: size.height * 0.9),
          decoration: BoxDecoration(
            color: const Color(0xFFFAF6EE),
            borderRadius: BorderRadius.circular(AppColors.borderRadius),
            image: const DecorationImage(
              image: AssetImage(AppAssets.infoback),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.40),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close, size: 22, color: AppColors.textDark),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: AppColors.borderBrown, thickness: 1.5),
              const SizedBox(height: 10),

              // Scrollable body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (bannerAsset != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            bannerAsset!,
                            fit: BoxFit.contain,
                            height: 220,
                            errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      Text(
                        description,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          fontFamily: 'NotoKufi',
                          fontSize: 18,
                          height: 1.8,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (bottomImageAsset != null) ...[
                        const SizedBox(height: 20),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => _showZoomableImage(context, bottomImageAsset!),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.borderBrown.withOpacity(0.5),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.12),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  bottomImageAsset!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (ctx, err, stack) => const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      if (bottomWidget != null) ...[
                        const SizedBox(height: 16),
                        bottomWidget!,
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontFamily: 'NotoKufi', fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
