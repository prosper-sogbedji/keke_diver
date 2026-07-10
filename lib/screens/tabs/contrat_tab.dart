import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/app_colors.dart';
import '../client_details_screen.dart';

class ContratTab extends StatefulWidget {
  const ContratTab({super.key});

  @override
  State<ContratTab> createState() => _ContratTabState();
}

class _ContratTabState extends State<ContratTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 100.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Votre contrat',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Consultez les détails de votre contrat et de vos paiements',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Status Banner
              Container(
                height: 80.h,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF59B900), Color(0xFF2F5010)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF73C92B), // Light green pill background
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check,
                                color: AppColors.white,
                                size: 14.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Actif',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Du 25 Fev. 2026 au 25 Aoû. 2026',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ClientDetailsScreen(),
                              ),
                            );
                          },
                          child: _buildCircleButton(Icons.remove_red_eye_outlined),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Téléchargement bientôt disponible'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                          child: _buildCircleButton(Icons.download_rounded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24.h),

              // Statistics
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Statistiques',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.info_outline_rounded,
                      title: '6 000 F',
                      subtitle: 'À payer demain',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE4455E), Color(0xFF810619)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      textColor: AppColors.white,
                      iconColor: const Color(0xFFB91D34),
                      iconBgColor: AppColors.white,
                      showArrow: true,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.check_circle_outline,
                      title: '27 800 F',
                      subtitle: 'Bénéfice actuel',
                      bgColor: AppColors.grey50,
                      textColor: AppColors.textPrimary,
                      iconColor: AppColors.white,
                      iconBgColor: const Color(0xFF2B364A),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.money, size: 14.sp, color: AppColors.textHint),
                      SizedBox(width: 4.w),
                      Text(
                        'Évolution de votre paiement',
                        style: TextStyle(fontSize: 11.sp, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  Text(
                    '100 %',
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 6.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey200,
                      borderRadius: BorderRadius.circular(3.r),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.5,
                    child: Container(
                      height: 6.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5BA710),
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: -2,
                    child: Align(
                      alignment: const FractionalOffset(0.5, 0.0),
                      child: Container(
                        width: 10.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: Color(0xFF5BA710),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 14.h,
                    child: Align(
                      alignment: const FractionalOffset(0.5, 0.0),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5BA710),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '25%',
                          style: TextStyle(color: AppColors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),

        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Historique des paiements',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 12.sp,
                            color: AppColors.accentGreen,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'À jour',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: AppColors.accentGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                _buildPaymentItem(
                  date: 'Jeudi 24 Avril 2026',
                  time: '14:50 • N° 77052807',
                  description: 'Paiement du montant journalier',
                  amount: '3 600 F',
                  status: 'Effectué',
                ),
                _buildPaymentItem(
                  date: 'Jeudi 24 Avril 2026',
                  time: '14:50 • N° 77052807',
                  description: 'Paiement du montant journalier + retards',
                  amount: '10 800 F',
                  status: 'Effectué',
                ),
            ],
          ),
        ),
      ],
    ),
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 22.sp),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? bgColor,
    Gradient? gradient,
    required Color textColor,
    required Color iconColor,
    required Color iconBgColor,
    bool showArrow = false,
  }) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: gradient != null ? null : bgColor,
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        border: bgColor == AppColors.grey50
            ? Border.all(color: AppColors.grey200)
            : Border.all(color: Colors.transparent, width: 1.w),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, size: 16.sp, color: iconColor),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: textColor.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (showArrow) ...[
            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right_rounded,
              color: textColor.withValues(alpha: 0.7),
              size: 16.sp,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentItem({
    required String date,
    required String time,
    required String description,
    required String amount,
    required String status,
  }) {
    return Container(
      height: 98.h,
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 16.r,
                        backgroundColor: AppColors.grey200,
                        backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=11'),
                      ),
                      Positioned(
                        bottom: -2,
                        right: -2,
                        child: Container(
                          width: 14.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.grey50, width: 2.w),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.check,
                              color: AppColors.white,
                              size: 8.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                amount,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  description,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.accentGreen,
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Télécharger la facture',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
