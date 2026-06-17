import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../utils/app_colors.dart';
import '../widgets/green_wave_painter.dart';
import 'phone_input_screen.dart';

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
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page indicator dots
          SmoothPageIndicator(
            controller: _pageController,
            count: _pages.length,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primaryBlue,
              dotColor: AppColors.grey200,
              dotHeight: 8,
              dotWidth: 8,
              expansionFactor: 2.5,
              spacing: 6,
            ),
          ),

          const SizedBox(height: 32),

          // Buttons row
          Row(
            children: [
              // "Continuer" button
              Expanded(
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _onContinuePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                    child: const Text('Continuer'),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Arrow circle button
              SizedBox(
                width: 56,
                height: 56,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkCircle,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                  ),
                  child: const Icon(
                    Icons.double_arrow_rounded,
                    size: 24,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Terms text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text.rich(
              TextSpan(
                text: "L'adhésion à notre application signifie que vous acceptez\nnos ",
                style: const TextStyle(
                  fontSize: 11,
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
                      decorationColor: AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                  ),
                  const TextSpan(text: " et notre "),
                  TextSpan(
                    text: "Politique de confidentialité",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.textSecondary.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),

          const SizedBox(height: 8),
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
    final imageHeight = screenHeight * 0.52;

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
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                child: Image.asset(
                  data.image,
                  fit: BoxFit.cover,
                ),
              ),

              // Green wave overlay
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
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
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
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

                const SizedBox(height: 12),

                // Subtitle
                Text(
                  data.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
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
