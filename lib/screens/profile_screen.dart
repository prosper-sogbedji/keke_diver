import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import 'dashboard_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _mailController = TextEditingController();
  final _villeController = TextEditingController();

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
    _nomController.dispose();
    _prenomController.dispose();
    _mailController.dispose();
    _villeController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
        (route) => false,
      );
    }
  }

  void _onGoogleSignIn() {
    // TODO: Implement Google sign-in
  }

  void _onAppleSignIn() {
    // TODO: Implement Apple sign-in
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 16.h),

                          // Illustration
                          SizedBox(
                                height: 170.h,
                                child: Image.asset(
                                  'assets/images/auth_profile.png',
                                  fit: BoxFit.contain,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .slideY(begin: -0.1, end: 0, duration: 500.ms),

                          SizedBox(height: 20.h),

                          // Title
                          Text(
                            'Vous y êtes presque !',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.3,
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 150.ms),

                          SizedBox(height: 4.h),

                          // Subtitle
                          Text(
                            'Renseignez ces informations pour personnaliser votre expérience.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textHint,
                              height: 2,
                            ),
                          ),

                          SizedBox(height: 14.h),

                          // Nom + Prénom row
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _nomController,
                                  hint: 'Nom',
                                  icon: Icons.person_outline_rounded,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: _buildTextField(
                                  controller: _prenomController,
                                  hint: 'Prénom',
                                  icon: Icons.person_outline_rounded,
                                ),
                              ),
                            ],
                          ).animate().fadeIn(duration: 400.ms, delay: 250.ms),

                          SizedBox(height: 14.h),

                          // Mail
                          _buildTextField(
                            controller: _mailController,
                            hint: 'Mail',
                            icon: Icons.mail_outline_rounded,
                            keyboardType: TextInputType.emailAddress,
                          ).animate().fadeIn(duration: 400.ms, delay: 350.ms),

                          SizedBox(height: 14.h),

                          // Ville
                          _buildTextField(
                            controller: _villeController,
                            hint: 'Ville',
                            icon: Icons.location_on_outlined,
                          ).animate().fadeIn(duration: 400.ms, delay: 450.ms),

                          SizedBox(height: 16.h),

                          // "C'est parti !" button
                          SizedBox(
                            height: 48.h,
                            child: ElevatedButton(
                              onPressed: _onSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryBlue,
                                foregroundColor: AppColors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              child: const Text("C'est parti !"),
                            ),
                          ).animate().fadeIn(duration: 400.ms, delay: 500.ms),

                          SizedBox(height: 16.h),

                          // Divider text
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1.h,
                                  color: AppColors.grey200,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12.w),
                                child: Text(
                                  'Ou finalisez la création de votre compte autrement',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.textHint,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1.h,
                                  color: AppColors.grey200,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16.h),

                          // Google button
                          _buildSocialButton(
                            label: 'Continuer avec Google',
                            iconPath: null,
                            icon: Icons.g_mobiledata_rounded,
                            onTap: _onGoogleSignIn,
                            isGoogle: true,
                          ),

                          SizedBox(height: 12.h),

                          // Apple button
                          _buildSocialButton(
                            label: 'Continuer avec Apple',
                            iconPath: null,
                            icon: Icons.apple_rounded,
                            onTap: _onAppleSignIn,
                            isGoogle: false,
                          ),

                          SizedBox(height: 32.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.textHint,
        ),
        prefixIcon: Icon(icon, size: 20.sp, color: AppColors.grey400),
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 14.h,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(
            color: AppColors.primaryBlue,
            width: 1.5.w,
          ),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Ce champ est requis';
        }
        return null;
      },
    );
  }

  Widget _buildSocialButton({
    required String label,
    required String? iconPath,
    required IconData icon,
    required VoidCallback onTap,
    required bool isGoogle,
  }) {
    return SizedBox(
      height: 48.h,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: BorderSide(color: const Color(0xFF727783), width: 1.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGoogle)
              Image.asset('assets/images/Icon_google.jpeg', width: 22.w, height: 22.w)
            else
              Icon(icon, size: 22.sp, color: AppColors.textPrimary),
            SizedBox(width: 10.w),
            Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.grey700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
