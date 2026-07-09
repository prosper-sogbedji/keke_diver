import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

/// A custom numeric keypad matching the mockup design.
/// Layout:
///   1  2  3
///   4  5  6
///   7  8  9
///   +  0  ⌫
class CustomNumpad extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;
  final VoidCallback onBackspace;
  final VoidCallback? onPlus;

  const CustomNumpad({
    super.key,
    required this.onKeyPressed,
    required this.onBackspace,
    this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 227.h,
      width: double.infinity,
      color: const Color(0xFFF8F8F8),
      padding: EdgeInsets.all(10.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(child: _buildRow(['1', '2', '3'])),
          SizedBox(height: 15.h),
          Expanded(child: _buildRow(['4', '5', '6'])),
          SizedBox(height: 15.h),
          Expanded(child: _buildRow(['7', '8', '9'])),
          SizedBox(height: 15.h),
          Expanded(child: _buildSpecialRow()),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Row(
      children: [
        for (int i = 0; i < keys.length; i++) ...[
          Expanded(
            child: _NumpadKey(
              label: keys[i],
              onTap: () {
                HapticFeedback.lightImpact();
                onKeyPressed(keys[i]);
              },
            ),
          ),
          if (i < keys.length - 1) SizedBox(width: 15.w),
        ],
      ],
    );
  }

  Widget _buildSpecialRow() {
    return Row(
      children: [
        // "+" key
        Expanded(
          child: _NumpadKey(
            label: '+',
            onTap: () {
              HapticFeedback.lightImpact();
              if (onPlus != null) {
                onPlus!();
              } else {
                onKeyPressed('+');
              }
            },
          ),
        ),
        SizedBox(width: 15.w),
        // "0" key
        Expanded(
          child: _NumpadKey(
            label: '0',
            onTap: () {
              HapticFeedback.lightImpact();
              onKeyPressed('0');
            },
          ),
        ),
        SizedBox(width: 15.w),
        // Backspace key
        Expanded(
          child: _NumpadKey(
            icon: Icons.backspace_outlined,
            onTap: () {
              HapticFeedback.mediumImpact();
              onBackspace();
            },
          ),
        ),
      ],
    );
  }
}

class _NumpadKey extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  const _NumpadKey({this.label, this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        splashColor: AppColors.primaryBlue.withValues(alpha: 0.08),
        highlightColor: AppColors.primaryBlue.withValues(alpha: 0.04),
        child: Container(
          alignment: Alignment.center,
          child: icon != null
              ? Icon(icon, size: 24.sp, color: AppColors.grey700)
              : Text(
                  label!,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey800,
                  ),
                ),
        ),
      ),
    );
  }
}
