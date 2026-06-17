import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),

                  // Illustration
                  SizedBox(
                    height: 170,
                    child: Image.asset(
                      'assets/images/auth_profile.png',
                      fit: BoxFit.contain,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideY(begin: -0.1, end: 0, duration: 500.ms),

                  const SizedBox(height: 20),

                  // Title
                  const Text(
                    'Vous y êtes presque !',
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
                  const Text(
                    'Renseignez ces informations pour personnaliser votre expérience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textHint,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 28),

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
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          controller: _prenomController,
                          hint: 'Prénom',
                          icon: Icons.person_outline_rounded,
                        ),
                      ),
                    ],
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 250.ms),

                  const SizedBox(height: 14),

                  // Mail
                  _buildTextField(
                    controller: _mailController,
                    hint: 'Mail',
                    icon: Icons.mail_outline_rounded,
                    keyboardType: TextInputType.emailAddress,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 350.ms),

                  const SizedBox(height: 14),

                  // Ville
                  _buildTextField(
                    controller: _villeController,
                    hint: 'Ville',
                    icon: Icons.location_on_outlined,
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 450.ms),

                  const SizedBox(height: 28),

                  // "C'est parti !" button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _onSubmit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: const Text("C'est parti !"),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 400.ms, delay: 500.ms),

                  const SizedBox(height: 24),

                  // Divider text
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: AppColors.grey200),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Ou finalisez la création de votre compte autrement',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(height: 1, color: AppColors.grey200),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Google button
                  _buildSocialButton(
                    label: 'Continuer avec Google',
                    iconPath: null,
                    icon: Icons.g_mobiledata_rounded,
                    onTap: _onGoogleSignIn,
                    isGoogle: true,
                  ),

                  const SizedBox(height: 10),

                  // Apple button
                  _buildSocialButton(
                    label: 'Continuer avec Apple',
                    iconPath: null,
                    icon: Icons.apple_rounded,
                    onTap: _onAppleSignIn,
                    isGoogle: false,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
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
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textHint,
        ),
        prefixIcon: Icon(
          icon,
          size: 20,
          color: AppColors.grey400,
        ),
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
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
      height: 50,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.grey200),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGoogle)
              // Google "G" icon with colors
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Center(
                  child: Text(
                    'G',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF4285F4),
                    ),
                  ),
                ),
              )
            else
              Icon(
                icon,
                size: 22,
                color: AppColors.textPrimary,
              ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
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
