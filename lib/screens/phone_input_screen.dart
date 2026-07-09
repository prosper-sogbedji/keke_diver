import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import '../utils/phone_rules.dart';
import '../utils/phone_validator.dart';
import '../widgets/custom_numpad.dart';
import 'otp_screen.dart';

class PhoneInputScreen extends StatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  State<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends State<PhoneInputScreen> {
  String _phoneNumber = '';
  String _countryCode = '+229';
  String _countryFlag = '🇧🇯';
  bool _isValidating = false;

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

  void _onKeyPressed(String key) {
    final int maxLength = expectedLengthFor(_countryCode);
    if (_phoneNumber.length < maxLength) {
      setState(() => _phoneNumber += key);
    }
  }

  void _onBackspace() {
    if (_phoneNumber.isNotEmpty) {
      setState(
        () => _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1),
      );
    }
  }

  String _formatPhone(String raw) {
    if (raw.isEmpty) return '';
    final buffer = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      buffer.write(raw[i]);
      if ((i + 1) % 2 == 0 && i != raw.length - 1) buffer.write(' ');
    }
    return buffer.toString();
  }

  bool get _isPhoneValid => isValidPhone(_countryCode, _phoneNumber);

  Future<void> _onContinue() async {
    if (!_isPhoneValid) return;

    setState(() => _isValidating = true);

    // TODO: remplace par ta vraie logique de validation asynchrone (API, etc.)
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    setState(() => _isValidating = false);

    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => OtpScreen(
          phoneNumber: '$_countryCode ${_formatPhone(_phoneNumber)}',
        ),
        transitionsBuilder: (_, animation, __, child) => SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        bottom: true,
        child: Column(
          children: [
            Expanded(
              flex: 260,
              child: Center(
                child: Image.asset(
                  'assets/images/auth_phone.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Expanded(
              flex: 494,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 16.h),
                      child: Column(
                        children: [
                          Text(
                            'Indiquez votre numéro',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),

                          SizedBox(height: 10.h),

                          Text(
                            'Nous vous enverrons un code pour vérifier\nvotre numéro de téléphone',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.textHint,
                              height: 1.5,
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 180.ms),

                          SizedBox(height: 20.h),

                          _buildPhoneInput().animate().fadeIn(
                            duration: 400.ms,
                            delay: 260.ms,
                          ),

                          SizedBox(height: 14.h),

                          SizedBox(
                            width: double.infinity,
                            height: 48.h,
                            child: _buildAnimatedContinueButton(),
                          ).animate().fadeIn(duration: 400.ms, delay: 320.ms),
                        ],
                      ),
                    ),

                    SizedBox(height: 10.h),

                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.grey100,
                    ),
                    Expanded(
                      child: CustomNumpad(
                        onKeyPressed: _onKeyPressed,
                        onBackspace: _onBackspace,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedContinueButton() {
    final bool isActive = _isPhoneValid && !_isValidating;
    const Color activeColor = Color(0xFF003AB9);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor
            : activeColor.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.r),
          onTap: isActive ? _onContinue : null,
          child: Center(
            child: _isValidating
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.white,
                      ),
                    ),
                  )
                : AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 300),
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white.withValues(
                        alpha: isActive ? 1.0 : 0.7,
                      ),
                    ),
                    child: const Text('Continuer'),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 0),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F8F8),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE6E6E6), width: 1.w),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                countryListTheme: CountryListThemeData(
                  bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                  inputDecoration: InputDecoration(
                    labelText: 'Rechercher un pays',
                    hintText: 'Commencez à taper...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: AppColors.grey200),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                onSelect: (Country country) {
                  setState(() {
                    _countryCode = '+${country.phoneCode}';
                    _countryFlag = country.flagEmoji;
                    _phoneNumber =
                        ''; // reset : évite un numéro invalide résiduel
                  });
                },
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Text(_countryFlag, style: TextStyle(fontSize: 22.sp)),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.sp,
                    color: AppColors.grey500,
                  ),
                ],
              ),
            ),
          ),

          Container(
            width: 1.w,
            height: 28.h,
            margin: EdgeInsets.symmetric(horizontal: 12.w),
            color: AppColors.grey200,
          ),

          Text(
            _countryCode,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(width: 8.w),

          Expanded(
            child: Text(
              _phoneNumber.isEmpty
                  ? '01 96 00 00 00'
                  : _formatPhone(_phoneNumber),
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: _phoneNumber.isEmpty
                    ? AppColors.textHint
                    : AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),

          if (_isValidating)
            SizedBox(
              width: 16.w,
              height: 16.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryBlue,
                ),
              ),
            )
          else if (_phoneNumber.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _phoneNumber = ''),
              child: Icon(
                Icons.close_rounded,
                size: 18.sp,
                color: AppColors.grey400,
              ),
            ),
        ],
      ),
    );
  }
}
