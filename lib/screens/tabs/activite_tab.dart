import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/driver_state_provider.dart';
import '../../models/ride_model.dart';
import '../../utils/app_colors.dart';

class ActiviteTab extends ConsumerStatefulWidget {
  const ActiviteTab({super.key});

  @override
  ConsumerState<ActiviteTab> createState() => _ActiviteTabState();
}

class _ActiviteTabState extends ConsumerState<ActiviteTab> {
  String _selectedCategory = 'Livraisons';
  String _selectedFilter = 'Tout';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 8.h),
          child: Column(
            children: [
              SizedBox(height: 8.h),
              Text(
                'Activités récentes',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Consultez l\'historique de vos déplacements',
                style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
              ),
              SizedBox(height: 24.h),

              // Categories
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildCategoryChip('Livraisons'),
                    SizedBox(width: 8.w),
                    _buildCategoryChip('Achats'),
                    SizedBox(width: 8.w),
                    _buildCategoryChip('Transports'),
                    SizedBox(width: 8.w),
                    _buildCategoryChip('Covoiturages'),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // Filters
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: AppColors.grey200, width: 1.w),
                  ),
                ),
                child: Row(
                  children: [
                    _buildSubFilter('Tout'),
                    SizedBox(width: 16.w),
                    _buildSubFilter('En cours', color: AppColors.primaryBlue),
                    SizedBox(width: 16.w),
                    _buildSubFilter('Terminées', color: AppColors.accentGreen),
                    SizedBox(width: 16.w),
                    _buildSubFilter('Annulées', color: const Color(0xFFE53935)),
                  ],
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: Builder(
            builder: (context) {
              final rides = ref.watch(recentRidesProvider);
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 100.h),
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  final ride = rides[index];
                  String statusText = 'Livraison terminée';
                  Color statusColor = AppColors.accentGreen;
                  if (ride.status == RideStatus.cancelled) {
                    statusText = 'Annulée';
                    statusColor = const Color(0xFFE53935);
                  } else if (ride.status == RideStatus.ongoing) {
                    statusText = 'En cours';
                    statusColor = AppColors.primaryBlue;
                  }

                  return _buildActivityItem(
                    ride: ride,
                    status: statusText,
                    statusColor: statusColor,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String label) {
    final isSelected = _selectedCategory == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedCategory = label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.grey200,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.textPrimary,
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildSubFilter(String label, {Color? color}) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.textHint : Colors.transparent,
              width: 2.w,
            ),
          ),
        ),
        child: Row(
          children: [
            if (color != null)
              Container(
                width: 4.w,
                height: 4.h,
                margin: EdgeInsets.only(right: 6.w),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected ? AppColors.textPrimary : AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityItem({
    required RideModel ride,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16.r,
                    backgroundColor: AppColors.grey200,
                    backgroundImage: NetworkImage(ride.clientImageUrl),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ride.clientName,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '${ride.date.hour}:${ride.date.minute.toString().padLeft(2, '0')} • N° ${ride.id.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppColors.textHint.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${ride.price.toInt()} F',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryBlue,
                              width: 2.w,
                            ),
                          ),
                        ),
                        Container(
                          width: 1.w,
                          height: 16.h,
                          color: AppColors.grey200,
                        ),
                        Container(
                          width: 8.w,
                          height: 8.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentGreen,
                              width: 2.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ride.pickupLocation,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            ride.dropoffLocation,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 6.h,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
