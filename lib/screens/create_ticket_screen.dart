import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import 'chat_screen.dart';

/// Écran de création d'un ticket de support.
/// L'utilisateur saisit l'objet de sa demande, puis est redirigé
/// vers le chat dont le titre sera cet objet.
class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final TextEditingController _objectController = TextEditingController();
  bool _canSubmit = false;

  @override
  void initState() {
    super.initState();
    _objectController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _objectController.removeListener(_onTextChanged);
    _objectController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final trimmed = _objectController.text.trim();
    final newState = trimmed.length >= 3;
    if (newState != _canSubmit) {
      setState(() => _canSubmit = newState);
    }
  }

  void _openChat() {
    final objectText = _objectController.text.trim();
    if (objectText.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(title: objectText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
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
        'Nouveau ticket',
        style: TextStyle(
          fontSize: 17.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody() {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 32.h),

            // Illustration / icône
            Center(
              child: Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: AppColors.grey50,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.grey200),
                ),
                child: Icon(
                  Icons.support_agent_rounded,
                  size: 40.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Titre
            Center(
              child: Text(
                'Décrivez votre préoccupation',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            SizedBox(height: 8.h),

            Center(
              child: Text(
                'Définissez l\'objet de votre demande pour\nêtre orienté vers le bon support.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textHint,
                  height: 1.5,
                ),
              ),
            ),

            SizedBox(height: 40.h),

            // Label
            Text(
              'Objet de la demande',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),

            SizedBox(height: 10.h),

            // Champ de saisie
            Container(
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: AppColors.grey200,
                  width: 1.5,
                ),
              ),
              child: TextField(
                controller: _objectController,
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 100,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'Ex : Problème avec un paiement…',
                  hintStyle: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 14.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 16.h,
                  ),
                  counterStyle: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ),
            ),

            SizedBox(height: 12.h),

            // Suggestions rapides
            Text(
              'Sujets fréquents :',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textHint,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 8.h),

            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildChip('Paiement bloqué'),
                _buildChip('Course annulée'),
                _buildChip('Problème de compte'),
                _buildChip('Retrait de gains'),
                _buildChip('Incident en cours'),
              ],
            ),

            SizedBox(height: 48.h),

            // Bouton Commencer
            AnimatedOpacity(
              opacity: _canSubmit ? 1.0 : 0.4,
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                width: double.infinity,
                height: 52.h,
                child: ElevatedButton(
                  onPressed: _canSubmit ? _openChat : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.primaryBlue,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Commencer la discussion',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 18.sp,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label) {
    return GestureDetector(
      onTap: () {
        _objectController.text = label;
        _objectController.selection = TextSelection.fromPosition(
          TextPosition(offset: label.length),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.grey200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
