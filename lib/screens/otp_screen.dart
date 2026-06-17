import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                    const SizedBox(height: 16),

                    // Illustration
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        'assets/images/auth_otp.png',
                        fit: BoxFit.contain,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.1, end: 0, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Code de vérification',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: -0.3,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 150.ms),

                    const SizedBox(height: 8),

                    // Subtitle with phone number
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        'Entrez le code à $_codeLength chiffres que nous avons envoyé\nau ${widget.phoneNumber}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // OTP boxes
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: _buildOtpBoxes(),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 250.ms),

                    const SizedBox(height: 16),

                    // Resend row
                    _buildResendRow(),

                    const SizedBox(height: 20),

                    // Validate button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _code.length == _codeLength ? _onValidate : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            foregroundColor: AppColors.white,
                            disabledBackgroundColor: AppColors.primaryBlue.withValues(alpha: 0.4),
                            disabledForegroundColor: AppColors.white.withValues(alpha: 0.7),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            textStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          child: const Text('Valider le code'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_codeLength, (index) {
        final hasValue = index < _code.length;
        final isActive = index == _code.length;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          width: 50,
          height: 56,
          margin: EdgeInsets.only(right: index < _codeLength - 1 ? 10 : 0),
          decoration: BoxDecoration(
            color: hasValue
                ? AppColors.primaryBlue.withValues(alpha: 0.06)
                : AppColors.grey50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isActive
                  ? AppColors.primaryBlue
                  : hasValue
                      ? AppColors.primaryBlue.withValues(alpha: 0.3)
                      : AppColors.grey200,
              width: isActive ? 2 : 1,
            ),
          ),
          alignment: Alignment.center,
          child: hasValue
              ? Text(
                  _code[index],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                )
                  .animate()
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    end: const Offset(1.0, 1.0),
                    duration: 200.ms,
                    curve: Curves.elasticOut,
                  )
              : null,
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
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textHint,
          ),
        ),
        GestureDetector(
          onTap: _canResend ? _onResend : null,
          child: Text(
            _canResend ? 'Renvoyer' : 'Renvoyer (${_resendCountdown}s)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _canResend
                  ? AppColors.primaryBlue
                  : AppColors.textHint,
              decoration: _canResend ? TextDecoration.underline : null,
              decorationColor: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }
}
