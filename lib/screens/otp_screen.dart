import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_numpad.dart';
import 'profile_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<String> _code = [];
  static const int _codeLength = 5;
  bool _canResend = false;
  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendCountdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        setState(() => _canResend = true);
        timer.cancel();
      }
    });
  }

  void _onKeyPressed(String key) {
    if (_code.length < _codeLength) {
      setState(() {
        _code.add(key);
      });
      if (_code.length == _codeLength) {
        // Auto-validate when all digits entered
        Future.delayed(const Duration(milliseconds: 300), _onValidate);
      }
    }
  }

  void _onBackspace() {
    if (_code.isNotEmpty) {
      setState(() {
        _code.removeLast();
      });
    }
  }

  void _onValidate() {
    if (_code.length == _codeLength) {
      // TODO: verify OTP with API
      Navigator.of(context).push(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ProfileScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position:
                  Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  void _onResend() {
    if (_canResend) {
      // TODO: call resend API
      _startResendTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 75.h),

                    // Illustration
                    SizedBox(
                          height: 180.h,
                          child: Image.asset(
                            'assets/images/auth_otp.png',
                            fit: BoxFit.contain,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.1, end: 0, duration: 500.ms),

                    SizedBox(height: 45.h),

                    // Title
                    Text(
                      'Code de vérification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                    SizedBox(height: 8.h),

                    // Subtitle with phone number
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40.w),
                      child: Text(
                        'Entrez le code à $_codeLength chiffres que nous avons envoyé\nau ${widget.phoneNumber}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: AppColors.textHint,
                          height: 1.5,
                        ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // OTP boxes
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48.h,
                        child: _buildOtpBoxes(),
                      ).animate().fadeIn(duration: 400.ms, delay: 250.ms),
                    ),

                    SizedBox(height: 12.h),

                    // Resend row
                    _buildResendRow(),
                  ],
                ),
              ),
            ),

            // Bouton ancré au-dessus du clavier (même position que "Continuer")
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _code.length == _codeLength ? _onValidate : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003AB9),
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: const Color(
                      0xFF003AB9,
                    ).withValues(alpha: 0.4),
                    disabledForegroundColor: AppColors.white.withValues(
                      alpha: 0.7,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Text('Valider le code'),
                ),
              ),
            ),

            // Custom numpad
            CustomNumpad(
              onKeyPressed: _onKeyPressed,
              onBackspace: _onBackspace,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOtpBoxes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(_codeLength, (index) {
        final hasValue = index < _code.length;
        final isActive = index == _code.length;

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 6.w),

            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 48.h,
              decoration: BoxDecoration(
                color: hasValue
                    ? AppColors.primaryBlue.withValues(alpha: 0.06)
                    : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: isActive
                      ? AppColors.primaryBlue
                      : hasValue
                      ? AppColors.primaryBlue.withValues(alpha: 0.3)
                      : AppColors.grey200,
                  width: isActive ? 2.w : 1.w,
                ),
              ),
              alignment: Alignment.center,
              child: hasValue
                  ? Text(
                      _code[index],
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ).animate().scale(
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.0, 1.0),
                      duration: 200.ms,
                      curve: Curves.elasticOut,
                    )
                  : null,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildResendRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Vous n'avez pas reçu le code ? ",
          style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
        ),
        GestureDetector(
          onTap: _canResend ? _onResend : null,
          child: Text(
            _canResend ? 'Renvoyer' : 'Renvoyer (${_resendCountdown}s)',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: _canResend ? AppColors.primaryBlue : AppColors.textHint,
              decoration: _canResend ? TextDecoration.underline : null,
              decorationColor: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}
