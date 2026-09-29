import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppPopupDialog extends StatelessWidget {
  final String title;
  final String description;
  final String? imageAsset;
  final Widget? customContent;

  const AppPopupDialog({
    super.key,
    required this.title,
    required this.description,
    this.imageAsset,
    this.customContent,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
    String? imageAsset,
    Widget? customContent,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AppPopupDialog(
        title: title,
        description: description,
        imageAsset: imageAsset,
        customContent: customContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = size.width * 0.55 > 450 ? size.width * 0.55 : 450.0;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
        ),
        backgroundColor: Colors.white.withOpacity(0.96),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Container(
          width: dialogWidth,
          constraints: BoxConstraints(maxHeight: size.height * 0.85),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Title and Close Button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 24,
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
                      child: const Icon(Icons.close, size: 20, color: AppColors.textDark),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(color: AppColors.borderBrown, thickness: 1),
              const SizedBox(height: 8),

              // Scrollable content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (imageAsset != null) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            imageAsset!,
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
                          height: 1.7,
                          color: AppColors.textDark,
                        ),
                      ),
                      if (customContent != null) ...[
                        const SizedBox(height: 16),
                        customContent!,
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              // Bottom Close Button matching Android
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBrown,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                ),
                child: const Text(
                  'إغلاق',
                  style: TextStyle(fontFamily: 'NotoKufi', fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
