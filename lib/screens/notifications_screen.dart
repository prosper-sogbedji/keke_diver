import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/driver_state_provider.dart';
import '../models/notification_model.dart';
import '../utils/app_colors.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen> {
  String _selectedFilter = 'Tout';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Ne ratez rien de tout ce qui se passe !',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textHint,
                  ),
                ),
                SizedBox(height: 24.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildFilterChip('Tout'),
                        SizedBox(width: 8.w),
                        _buildFilterChip('Non lues'),
                      ],
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Toutes les notifications marquées comme lues'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      icon: Icon(Icons.done_all_rounded, size: 16.sp, color: AppColors.textPrimary),
                      label: Text(
                        'Tout marquer comme lu',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: Builder(
              builder: (context) {
                final notifications = ref.watch(notificationsProvider);

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notif = notifications[index];

                    IconData? icon;
                    Color? iconBgColor;

                    switch (notif.type) {
                      case NotificationType.payment:
                        icon = Icons.attach_money;
                        iconBgColor = AppColors.accentGreen;
                        break;
                      case NotificationType.message:
                        icon = Icons.message;
                        iconBgColor = AppColors.primaryBlue;
                        break;
                      case NotificationType.success:
                        icon = Icons.check;
                        iconBgColor = AppColors.accentGreen;
                        break;
                    }

                    return _buildNotificationItem(
                      icon: icon,
                      iconColor: AppColors.white,
                      iconBgColor: iconBgColor,
                      title: notif.title,
                      message: notif.message,
                      time: '${notif.date.hour}:${notif.date.minute.toString().padLeft(2, '0')}',
                      isUnread: !notif.isRead,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B364A) : AppColors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF2B364A) : AppColors.grey200,
          ),
        ),
        child: Row(
          children: [
            if (!isSelected)
              Container(
                width: 6.w,
                height: 6.h,
                margin: EdgeInsets.only(right: 6.w),
                decoration: const BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    IconData? icon,
    Color? iconColor,
    Color? iconBgColor,
    String? avatarUrl,
    required String title,
    required String message,
    required String time,
    required bool isUnread,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.only(bottom: 16.h),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (avatarUrl != null)
            CircleAvatar(
              radius: 18.r,
              backgroundColor: AppColors.grey200,
              backgroundImage: NetworkImage(avatarUrl),
            )
          else if (icon != null)
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18.sp),
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        if (isUnread)
                          Container(
                            width: 6.w,
                            height: 6.h,
                            margin: EdgeInsets.only(right: 4.w),
                            decoration: const BoxDecoration(
                              color: AppColors.accentGreen,
                              shape: BoxShape.circle,
                            ),
                          ),
                        Text(
                          time,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.textHint.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textHint,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
