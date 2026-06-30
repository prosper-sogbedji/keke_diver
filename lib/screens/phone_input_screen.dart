import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:country_picker/country_picker.dart';
import '../utils/app_colors.dart';
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
    if (_phoneNumber.length < 12) {
      setState(() {
        _phoneNumber += key;
      });
    }
  }

  void _onBackspace() {
    if (_phoneNumber.isNotEmpty) {
      setState(() {
        _phoneNumber = _phoneNumber.substring(0, _phoneNumber.length - 1);
      });
    }
  }

  String _formatPhone(String raw) {
    if (raw.isEmpty) return '';
    // Format: XX XX XX XX XX
    final buffer = StringBuffer();
    for (int i = 0; i < raw.length; i++) {
      buffer.write(raw[i]);
      if ((i + 1) % 2 == 0 && i != raw.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  void _onContinue() {
    if (_phoneNumber.length >= 8) {
      Navigator.of(context).push(
        PageRouteBuilder<void>(
          pageBuilder: (context, animation, secondaryAnimation) =>
              OtpScreen(
                phoneNumber: '$_countryCode ${_formatPhone(_phoneNumber)}',
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable top content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Illustration
                    SizedBox(
                      height: 180,
                      child: Image.asset(
                        'assets/images/auth_phone.png',
                        fit: BoxFit.contain,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 500.ms)
                        .slideY(begin: -0.1, end: 0, duration: 500.ms),

                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Indiquez votre numéro',
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

                    // Subtitle
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 48),
                      child: Text(
                        'Nous vous enverrons un code pour vérifier\nvotre numéro de téléphone',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                          height: 1.5,
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Phone input row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _buildPhoneInput(),
                    )
                        .animate()
                        .fadeIn(duration: 400.ms, delay: 250.ms),

                    const SizedBox(height: 20),

                    // Continue button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _phoneNumber.length >= 8 ? _onContinue : null,
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
                          child: const Text('Continuer'),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Custom numpad at bottom
            CustomNumpad(
              onKeyPressed: _onKeyPressed,
              onBackspace: _onBackspace,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.grey200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Flag & Dropdown
          GestureDetector(
            onTap: () {
              showCountryPicker(
                context: context,
                showPhoneCode: true,
                countryListTheme: CountryListThemeData(
                  bottomSheetHeight: MediaQuery.of(context).size.height * 0.7,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  inputDecoration: InputDecoration(
                    labelText: 'Rechercher un pays',
                    hintText: 'Commencez à taper...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.grey200,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                onSelect: (Country country) {
                  setState(() {
                    _countryCode = '+${country.phoneCode}';
                    _countryFlag = country.flagEmoji;
                  });
                },
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  Text(
                    _countryFlag,
                    style: const TextStyle(fontSize: 22),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20,
                    color: AppColors.grey500,
                  ),
                ],
              ),
            ),
          ),

          // Divider
          Container(
            width: 1,
            height: 28,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            color: AppColors.grey200,
          ),

          // Country code
          Text(
            _countryCode,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 8),

          // Phone number
          Expanded(
            child: Text(
              _phoneNumber.isEmpty
                  ? '01 96 00 00 00'
                  : _formatPhone(_phoneNumber),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: _phoneNumber.isEmpty
                    ? AppColors.textHint
                    : AppColors.textPrimary,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Refresh icon
          if (_phoneNumber.isNotEmpty)
            GestureDetector(
              onTap: () => setState(() => _phoneNumber = ''),
              child: const Icon(
                Icons.close_rounded,
                size: 18,
                color: AppColors.grey400,
              ),
            ),
        ],
      ),
    );
  }
}
