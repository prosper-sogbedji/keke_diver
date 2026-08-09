import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import '../utils/app_colors.dart';

/// Écran interne pour afficher un PDF depuis les assets de l'application.
/// Paramètres :
///   - [title]     : Titre affiché dans l'AppBar
///   - [assetPath] : Chemin vers le fichier PDF dans les assets (ex: "assets/doc/CGU.pdf")
class PdfViewerScreen extends StatefulWidget {
  final String title;
  final String assetPath;

  const PdfViewerScreen({
    super.key,
    required this.title,
    required this.assetPath,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? _localPath;
  bool _isLoading = true;
  bool _hasError = false;
  int _totalPages = 0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _loadPdfFromAssets();
  }

  /// Copie le PDF depuis les assets vers un fichier temporaire local
  /// car flutter_pdfview nécessite un chemin de fichier physique.
  Future<void> _loadPdfFromAssets() async {
    try {
      final ByteData data = await rootBundle.load(widget.assetPath);
      final List<int> bytes = data.buffer.asUint8List(
        data.offsetInBytes,
        data.lengthInBytes,
      );

      final Directory tempDir = await getTemporaryDirectory();
      final String fileName = widget.assetPath.split('/').last;
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(bytes, flush: true);

      if (mounted) {
        setState(() {
          _localPath = file.path;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
          size: 20.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
      bottom: _totalPages > 0
          ? PreferredSize(
              preferredSize: Size.fromHeight(24.h),
              child: Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Text(
                  'Page $_currentPage sur $_totalPages',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColors.primaryBlue,
              strokeWidth: 2.5,
            ),
            SizedBox(height: 16.h),
            Text(
              'Chargement du document…',
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      );
    }

    if (_hasError || _localPath == null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: AppColors.grey400,
                size: 48.sp,
              ),
              SizedBox(height: 16.h),
              Text(
                'Impossible de charger le document.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Veuillez réessayer ultérieurement.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PDFView(
      filePath: _localPath!,
      enableSwipe: true,
      swipeHorizontal: false,
      autoSpacing: true,
      pageFling: true,
      pageSnap: true,
      fitPolicy: FitPolicy.BOTH,
      onRender: (pages) {
        if (mounted) {
          setState(() {
            _totalPages = pages ?? 0;
            _currentPage = 1;
          });
        }
      },
      onPageChanged: (page, total) {
        if (mounted) {
          setState(() {
            _currentPage = (page ?? 0) + 1;
            _totalPages = total ?? 0;
          });
        }
      },
      onError: (error) {
        if (mounted) {
          setState(() => _hasError = true);
        }
      },
    );
  }
}
