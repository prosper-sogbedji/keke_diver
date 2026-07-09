import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import '../../providers/driver_state_provider.dart';
import '../../utils/app_colors.dart';

class ProfilTab extends ConsumerStatefulWidget {
  const ProfilTab({super.key});

  @override
  ConsumerState<ProfilTab> createState() => _ProfilTabState();
}

class _ProfilTabState extends ConsumerState<ProfilTab> {
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);

    return Container(
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ),
                Text(
                  'Votre profil',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Consultez les informations de votre profil',
                style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
              ),
              SizedBox(height: 24.h),

              // Profile Card — height:80.h, border-radius:20.r, gradient
              Container(
                height: 80.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF003AB9), Color(0xFF001A53)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  children: [
                    // Avatar + verified badge
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 28.r,
                          backgroundColor: AppColors.white,
                          child: CircleAvatar(
                            radius: 26.r,
                            backgroundColor: AppColors.grey200,
                            backgroundImage: NetworkImage(user.profileImageUrl),
                          ),
                        ),
                        if (user.isVerified)
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              width: 20.w,
                              height: 20.h,
                              decoration: BoxDecoration(
                                color: const Color(0xFF59B900),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2.w,
                                ),
                              ),
                              child: Icon(
                                Icons.check,
                                size: 11.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 14.w),
                    // Name + subtitle + rating stacked on left
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.fullName,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Membre KEKE+ depuis ${user.memberSince}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Color(0xFFFFD700),
                                size: 14.sp,
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                '${user.rating}',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Share button — 48x48, border-radius:20.r
                    Container(
                      width: 48.w,
                      height: 48.h,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: const Icon(
                        Icons.open_in_new_rounded,
                        color: Color(0xFF001A53),
                        size: 22.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: ListView(
            padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 100.h),
            children: [
              Text(
                'Compte',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),

              // Section Compte — width:358.w, height:192.h, border-radius:20.r, border-width:1px
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1.w),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: CupertinoIcons.person,
                      title: 'Informations personnelles',
                      subtitle: 'Nom, adresse mail, téléphone',
                      onTap: () => _showPersonalInfoModal(context),
                      isFirst: true,
                      isLast: false,
                    ),
                    const Divider(
                      height: 1.h,
                      thickness: 1,
                      color: Color(0xFFE0E0E0),
                      indent: 16,
                      endIndent: 16,
                    ),
                    _buildSettingsItem(
                      icon: IconlyLight.wallet,
                      title: 'Moyens de paiement',
                      subtitle: 'MTN MoMo, Moov Money, carte de crédit...',
                      onTap: () {},
                      isFirst: false,
                      isLast: false,
                    ),
                    const Divider(
                      height: 1.h,
                      thickness: 1,
                      color: Color(0xFFE0E0E0),
                      indent: 16,
                      endIndent: 16,
                    ),
                    _buildSettingsItem(
                      icon: IconlyLight.star,
                      title: 'Avis et notations',
                      subtitle: 'Commentaires',
                      onTap: () {},
                      isFirst: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
              Text(
                'Préférences',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 12.h),

              // Section Préférences — width:358.w, height:128.h, border-radius:20.r, border-width:1px
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFE0E0E0), width: 1.w),
                ),
                child: Column(
                  children: [
                    _buildSettingsItem(
                      icon: Icons.notifications_active_outlined,
                      title: 'Notifications',
                      subtitle: 'Push, email',
                      trailing: Switch(
                        value: _notificationsEnabled,
                        onChanged: (val) =>
                            setState(() => _notificationsEnabled = val),
                        activeTrackColor: AppColors.accentGreen,
                        activeThumbColor: AppColors.white,
                      ),
                      onTap: () {},
                      isFirst: true,
                      isLast: false,
                    ),
                    const Divider(
                      height: 1.h,
                      thickness: 1,
                      color: Color(0xFFE0E0E0),
                      indent: 16,
                      endIndent: 16,
                    ),
                    _buildSettingsItem(
                      icon: Icons.translate,
                      title: 'Langue',
                      subtitle: 'Français',
                      onTap: () {},
                      isFirst: false,
                      isLast: true,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 28.h),

              // Footer — "Conditions d'utilisation" link
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text(
                      "Conditions d'utilisation et politique de confidentialité",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryBlue,
                      size: 18.sp,
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Footer — Déconnexion
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Icon(Icons.logout, color: AppColors.textPrimary, size: 20.sp),
                    SizedBox(width: 12.w),
                    Text(
                      'Déconnexion',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
    bool isFirst = false,
    bool isLast = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.vertical(
            top: isFirst ? const Radius.circular(20.r) : Radius.zero,
            bottom: isLast ? const Radius.circular(20.r) : Radius.zero,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: const Color(0xFFEAEAEA),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.textPrimary, size: 20.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null)
              trailing
            else
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textHint,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  void _showPersonalInfoModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24.r),
              topRight: Radius.circular(24.r),
            ),
          ),
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Text(
                'Informations personnelles',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 24.h),

              _buildEditableField('Nom', 'YACOUBOU'),
              SizedBox(height: 16.h),
              _buildEditableField('Prénom', 'Dieu-donné'),
              SizedBox(height: 16.h),
              _buildEditableField('Adresse mail', 'ddonneyacoubou@gmail.com'),

              SizedBox(height: 32.h),

              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: AppColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                ),
                child: Text(
                  'Enregistrer',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: TextFormField(
        initialValue: value,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontSize: 12.sp,
            color: AppColors.textHint,
            fontWeight: FontWeight.normal,
          ),
          border: InputBorder.none,
          suffixIcon: Icon(
            Icons.edit_outlined,
            size: 16.sp,
            color: AppColors.textHint,
          ),
        ),
      ),
    );
  }
}
