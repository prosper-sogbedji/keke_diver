import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import '../widgets/green_wave_painter.dart';
import 'phone_input_screen.dart';
import 'pdf_viewer_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      image: 'assets/images/onboarding_1.png',
      title: "Gagnez de l'argent grâce à\nvotre moyen de déplacement",
      subtitle: "Moto, voiture ou tricycle ?",
      waveVariant: 0,
    ),
    OnboardingData(
      image: 'assets/images/onboarding_2.png',
      title: "C'est vous qui décidez\nquand vous êtes actif !",
      subtitle: "Choisissez librement votre disponibilité",
      waveVariant: 1,
    ),
    OnboardingData(
      image: 'assets/images/onboarding_3.png',
      title: "Suivez vos déplacements et\nbénéfices en temps réel.",
      subtitle: "Gardez le contrôle de votre activité !",
      waveVariant: 2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _navigateToNext();
    }
  }

  void _onPrevPressed() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _onContinuePressed() {
    _navigateToNext();
  }

  void _navigateToNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const PhoneInputScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
            )),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          // PageView — top image + text area
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _pages.length,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return _OnboardingPage(
                  data: _pages[index],
                  isActive: _currentPage == index,
                );
              },
            ),
          ),

          // Bottom section: dots + buttons + terms
          _buildBottomSection(),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    final bool showBack = _currentPage > 0;
    final bool showLast = _currentPage == _pages.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 24.h),

          // Page indicator dots
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: ExpandingDotsEffect(
              activeDotColor: AppColors.primaryBlue,
              dotColor: AppColors.grey200,
              dotHeight: 8.w,
              dotWidth: 8.w,
              expansionFactor: 2.5,
              spacing: 6.w,
            ),
          ),

          SizedBox(height: 24.h),

          // ── Boutons (adaptatifs, jamais de débordement) ─────────────
          // Layout : [Retour 48] [14] [Continuer Expanded] [14] [Suivant 48]
          // Retour et Suivant gardent leur place (maintainSize) → Continuer
          // garde la même taille sur toutes les pages, quel que soit l'écran.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              children: [
                // ── Bouton RETOUR (caché page 1, espace réservé) ──────────
                Visibility(
                  visible: showBack,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: ElevatedButton(
                      onPressed: _onPrevPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003AB9),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        size: 22.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 14.w),

                // ── Bouton CONTINUER (Expanded = s'adapte à l'écran) ──────
                Expanded(
                  child: SizedBox(
                    height: 48.w, // garder aligné avec la hauteur des autres boutons
                    child: ElevatedButton(
                      onPressed: _onContinuePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003AB9),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        textStyle: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      child: const Text('Continuer'),
                    ),
                  ),
                ),

                SizedBox(width: 14.w),

                // ── Bouton SUIVANT (caché dernière page, espace réservé) ──
                Visibility(
                  visible: !showLast,
                  maintainSize: true,
                  maintainAnimation: true,
                  maintainState: true,
                  child: SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: ElevatedButton(
                      onPressed: _onNextPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF313642),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        Icons.keyboard_double_arrow_right_rounded,
                        size: 22.sp,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Terms text — liens cliquables vers PDF Viewer
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text.rich(
              TextSpan(
                text: "L'adhésion à notre application signifie que vous acceptez\nnos ",
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textHint,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: "Conditions d'utilisation",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PdfViewerScreen(
                              title: "Conditions d'utilisation",
                              assetPath: 'assets/doc/CGU_KEKE_BENIN.pdf',
                            ),
                          ),
                        );
                      },
                  ),
                  const TextSpan(text: " et notre "),
                  TextSpan(
                    text: "Politique de confidentialité",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor:
                          AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PdfViewerScreen(
                              title: 'Politique de confidentialité',
                              assetPath:
                                  'assets/doc/Politique_de_Confidentialite_KEKE_BENIN.pdf',
                            ),
                          ),
                        );
                      },
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Espace bas : marge visible sur la maquette + barre de navigation système
          Builder(
            builder: (context) {
              final bottomInset = MediaQuery.of(context).padding.bottom;
              return SizedBox(height: bottomInset > 0 ? bottomInset + 8.h : 24.h);
            },
          ),
        ],
      ),
    );
  }
}

// ─── Individual onboarding page ──────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  final bool isActive;

  const _OnboardingPage({
    required this.data,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // Conteneur blanc = 341px (Figma), image prend le reste + 30px de chevauchement
    final imageHeight = screenHeight - 341.h + 30.h;

    return Column(
      children: [
        // Image section with green waves
        SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                ),
                child: Image.asset(
                  data.image,
                  fit: BoxFit.cover,
                ),
              ),

              // Green wave overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                  child: CustomPaint(
                    painter: GreenWavePainter(variant: data.waveVariant),
                  ),
                ),
              ),

              // Bottom white curve overlay to blend with content
              Positioned(
                bottom: -1,
                left: 0,
                right: 0,
                child: Container(
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.r),
                      topRight: Radius.circular(30.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Text content section
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    height: 1.3,
                    letterSpacing: -0.3,
                  ),
                )
                    .animate(
                      target: isActive ? 1 : 0,
                    )
                    .fadeIn(
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.15,
                      end: 0,
                      duration: 500.ms,
                      curve: Curves.easeOut,
                    ),

                SizedBox(height: 12.h),

                // Subtitle
                Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textHint,
                    height: 1.4,
                  ),
                )
                    .animate(
                      target: isActive ? 1 : 0,
                    )
                    .fadeIn(
                      duration: 500.ms,
                      delay: 150.ms,
                      curve: Curves.easeOut,
                    )
                    .slideY(
                      begin: 0.2,
                      end: 0,
                      duration: 500.ms,
                      delay: 150.ms,
                      curve: Curves.easeOut,
                    ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Data model ──────────────────────────────────────────────────────────────

class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final int waveVariant;

  const OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.waveVariant,
  });
}
