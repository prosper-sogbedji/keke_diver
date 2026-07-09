import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/driver_state_provider.dart';
import '../../utils/app_colors.dart';
import '../client_details_screen.dart';

class PaiementsTab extends ConsumerStatefulWidget {
  const PaiementsTab({super.key});

  @override
  ConsumerState<PaiementsTab> createState() => _PaiementsTabState();
}

class _PaiementsTabState extends ConsumerState<PaiementsTab> {
  @override
  Widget build(BuildContext context) {
    final balance = ref.watch(walletBalanceProvider);
    final transactions = ref.watch(recentTransactionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 8.h),
              Text(
                'Vos revenus',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Consultez l\'historique de vos entrées et sorties',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                ),
              ),
              SizedBox(height: 24.h),
              
              // Wallet Card
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Portefeuille',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '${balance.toInt()} FCFA',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    ),
                    Row(
                      children: [
                        _buildCardButton(Icons.add, () {}),
                        SizedBox(width: 12.w),
                        _buildCardButton(Icons.file_upload_outlined, () {
                          _showWithdrawModal(context);
                        }),
                      ],
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24.h),
              
              // Filters
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterDropdown('Tout', isSelected: true),
                    SizedBox(width: 8.w),
                    _buildFilterDropdown('Date'),
                    SizedBox(width: 8.w),
                    _buildFilterDropdown('Débit/Crédit'),
                    SizedBox(width: 8.w),
                    _buildFilterDropdown('Catégorie', showArrow: false),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 100.h),
            itemCount: transactions.length + 1, // +1 for the header
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h, top: 8.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '25 Avril 2026',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '2 transaction',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                );
              }
              final tx = transactions[index - 1];
              return _buildTransactionItem(
                title: 'Chez Maman Ella',
                subtitle: 'Livraison de [ 1x Côme + Poisson + Supplément ]',
                amount: '1 200 F',
                status: 'Effectué',
                isCredit: true,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCardButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48.w,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Icon(
          icon,
          color: AppColors.textPrimary,
          size: 24.sp,
        ),
      ),
    );
  }

  Widget _buildFilterDropdown(String label, {bool showArrow = true, bool isSelected = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF2B364A) : Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isSelected ? const Color(0xFF2B364A) : AppColors.textPrimary),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.textPrimary,
              fontSize: 12.sp,
            ),
          ),
          if (showArrow) ...[
            SizedBox(width: 4.w),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16.sp, color: isSelected ? AppColors.white : AppColors.textPrimary),
          ],
        ],
      ),
    );
  }



  Widget _buildTransactionItem({
    required String title,
    required String subtitle,
    required String amount,
    required String status,
    required bool isCredit,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.only(bottom: 16.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  const CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.grey200,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=13'),
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
                        border: Border.all(color: AppColors.white, width: 2.w),
                      ),
                      child: const Center(
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '14:50 • N° 77052807',
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textHint.withValues(alpha: 0.8),
                          ),
                        ),
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentGreen,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppColors.textHint,
            ),
          ),
          SizedBox(height: 8.h),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ClientDetailsScreen()),
              );
            },
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

  void _showWithdrawModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
              'Retrait de vos fonds',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: 24.h),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '20 000 F',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Montant à retirer',
                        style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.textHint, width: 1.5),
                    ),
                    child: Icon(Icons.close, size: 10.sp, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    '+2290196000102',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Numéro de téléphone',
                    style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.grey50,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.grey200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Mobile Money',
                    style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textHint),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            
            Row(
              children: [
                Icon(Icons.file_download_outlined, size: 20.sp, color: AppColors.textPrimary),
                SizedBox(width: 12.w),
                const Expanded(
                  child: Text(
                    'Télécharger la facture après le paiement',
                    style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
                  ),
                ),
                Switch(
                  value: true,
                  onChanged: (val) {},
                  activeTrackColor: AppColors.accentGreen,
                ),
              ],
            ),
            
            SizedBox(height: 24.h),
            
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
              child: Text('Retirer mes fonds', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}
