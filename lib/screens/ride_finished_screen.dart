import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

class RideFinishedScreen extends StatefulWidget {
  const RideFinishedScreen({super.key});

  @override
  State<RideFinishedScreen> createState() => _RideFinishedScreenState();
}

class _RideFinishedScreenState extends State<RideFinishedScreen> {
  int _selectedRating = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Votre course est terminée !',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Comment était la course ? Donnez une note au client.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textHint,
                ),
              ),
              SizedBox(height: 32.h),
              
              // User info
              CircleAvatar(
                radius: 32.r,
                backgroundColor: AppColors.grey200,
                backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=12'),
              ),
              SizedBox(height: 12.h),
              Text(
                'Dieu-donné Y.',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '14:50 • N° 77052807',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Rating stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                    },
                    child: Container(
                      width: 52.w,
                      height: 52.h,
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: AppColors.grey50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: AppColors.grey200),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.star,
                          color: index < _selectedRating ? const Color(0xFFFFB800) : AppColors.grey200,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  );
                }),
              ),
              
              SizedBox(height: 32.h),
              
              // Amount
              Text(
                '5 200 F',
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Total à récupérer',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textHint,
                ),
              ),
              
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Divider(color: AppColors.grey200),
              ),
              
              // Itinerary
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Itinéraire',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              
              _buildItineraryRow('à 159m de F7', 'Adresse de départ', '15:32'),
              SizedBox(height: 16.h),
              _buildItineraryRow('9C&M+F3M, Boulevard Steinmetz, Cotonou', 'Adresse de destination', '16:07'),
              
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.h),
                child: Divider(color: AppColors.grey200),
              ),
              
              // Facture
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Facture',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
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
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              
              _buildFactureRow('Montant', 'Tarif de la livraison', '2 850 F'),
              SizedBox(height: 16.h),
              _buildFactureRow('Payé en espèces', '', '2 850 F', isBold: true),
              
              SizedBox(height: 32.h),
              
              // Bottom Buttons
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Support en cours de développement'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B364A),
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text('Support client', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        // Return to Dashboard and pop the modal if any
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                      ),
                      child: Text('Confirmer', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItineraryRow(String title, String subtitle, String time) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ),
        Text(
          time,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildFactureRow(String title, String subtitle, String amount, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textHint,
                ),
              ),
            ]
          ],
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
