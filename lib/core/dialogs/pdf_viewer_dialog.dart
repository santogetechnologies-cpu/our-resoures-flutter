import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../theme/app_theme.dart';
import '../constants/app_assets.dart';
import '../widgets/map_view_platform.dart';

class PdfViewerDialog extends StatefulWidget {
  final String title;
  final String assetPath;
  final Widget? continuationWidget;

  const PdfViewerDialog({
    super.key,
    required this.title,
    required this.assetPath,
    this.continuationWidget,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String assetPath,
    Widget? continuationWidget,
  }) async {
    setModalOpenWeb(true);
    try {
      await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => PdfViewerDialog(
          title: title,
          assetPath: assetPath,
          continuationWidget: continuationWidget,
        ),
      );
    } finally {
      setModalOpenWeb(false);
    }
  }

  @override
  State<PdfViewerDialog> createState() => _PdfViewerDialogState();
}

class _PdfViewerDialogState extends State<PdfViewerDialog> {
  late PdfViewerController _pdfViewerController;
  Uint8List? _pdfBytes;
  int _pageCount = 0;
  int _currentPage = 1;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = PdfViewerController();
    _loadPdfData();
  }

  Future<void> _loadPdfData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ByteData data = await rootBundle.load(widget.assetPath);
      final Uint8List bytes = data.buffer.asUint8List();
      if (mounted) {
        setState(() {
          _pdfBytes = bytes;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'تعذر تحميل ملف الكتاب: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dialogWidth = widget.continuationWidget != null
        ? (size.width * 0.92).clamp(520.0, 1180.0)
        : (size.width * 0.85).clamp(480.0, 1100.0);
    final dialogHeight = widget.continuationWidget != null
        ? (size.height * 0.95).clamp(480.0, 980.0)
        : (size.height * 0.92).clamp(400.0, 950.0);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppColors.borderRadius),
        ),
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Container(
          width: dialogWidth,
          height: dialogHeight,
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
            border: Border.all(color: AppColors.borderBrown.withOpacity(0.5), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Row: Title & Close 'X' Button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.solidBrown,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
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
              const SizedBox(height: 4),
              const Divider(color: AppColors.borderBrown, thickness: 1.5),
              const SizedBox(height: 8),

              // Controls Bar (Zoom + Page count)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBrown.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderBrown.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicator
                    Text(
                      _pageCount > 0
                          ? 'الصفحة $_currentPage من $_pageCount'
                          : (_isLoading ? 'جاري قراءة وتحميل المستند...' : 'المستند جاهز'),
                      style: const TextStyle(
                        fontFamily: 'NotoKufi',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkBrown,
                      ),
                    ),

                    // Zoom Controls
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.zoom_in, color: AppColors.solidBrown, size: 22),
                          tooltip: 'تكبير',
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            _pdfViewerController.zoomLevel =
                                (_pdfViewerController.zoomLevel + 0.25).clamp(1.0, 3.0);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.zoom_out, color: AppColors.solidBrown, size: 22),
                          tooltip: 'تصغير',
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            _pdfViewerController.zoomLevel =
                                (_pdfViewerController.zoomLevel - 0.25).clamp(1.0, 3.0);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main PDF Viewer Area
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderBrown.withOpacity(0.4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _buildViewerContent(),
                ),
              ),

              if (widget.continuationWidget != null) ...[
                const SizedBox(height: 10),
                widget.continuationWidget!,
              ],

              const SizedBox(height: 14),

              // Bottom Close Button matching standard dialogs
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBrown,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 11),
                  ),
                  child: const Text(
                    'إغلاق',
                    style: TextStyle(
                      fontFamily: 'NotoKufi',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewerContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.solidBrown),
            SizedBox(height: 14),
            Text(
              'جاري تحميل وتجهيز الكتاب...',
              style: TextStyle(
                fontFamily: 'NotoKufi',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'NotoKufi',
                  fontSize: 15,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _loadPdfData,
                icon: const Icon(Icons.refresh),
                label: const Text('إعادة المحاولة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.solidBrown,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_pdfBytes == null) {
      return const SizedBox.shrink();
    }

    return SfPdfViewer.memory(
      _pdfBytes!,
      controller: _pdfViewerController,
      canShowScrollHead: true,
      canShowScrollStatus: true,
      enableDoubleTapZooming: true,
      onDocumentLoaded: (PdfDocumentLoadedDetails details) {
        if (mounted) {
          setState(() {
            _pageCount = details.document.pages.count;
          });
        }
      },
      onPageChanged: (PdfPageChangedDetails details) {
        if (mounted) {
          setState(() {
            _currentPage = details.newPageNumber;
          });
        }
      },
      onDocumentLoadFailed: (PdfDocumentLoadFailedDetails details) {
        if (mounted) {
          setState(() {
            _errorMessage = 'تعذر فتح ملف الكتاب: ${details.description}';
          });
        }
      },
    );
  }
}
