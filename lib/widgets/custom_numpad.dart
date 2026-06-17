import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      color: AppColors.grey50,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(['1', '2', '3']),
          _buildRow(['4', '5', '6']),
          _buildRow(['7', '8', '9']),
          _buildSpecialRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: keys
            .map((key) => Expanded(child: _NumpadKey(
                label: key,
                onTap: () {
                  HapticFeedback.lightImpact();
                  onKeyPressed(key);
                },
              )))
            .toList(),
      ),
    );
  }

  Widget _buildSpecialRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
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
      ),
    );
  }
}

class _NumpadKey extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  const _NumpadKey({
    this.label,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primaryBlue.withValues(alpha: 0.08),
        highlightColor: AppColors.primaryBlue.withValues(alpha: 0.04),
        child: Container(
          height: 56,
          alignment: Alignment.center,
          child: icon != null
              ? Icon(
                  icon,
                  size: 24,
                  color: AppColors.grey700,
                )
              : Text(
                  label!,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    color: AppColors.grey800,
                  ),
                ),
        ),
      ),
    );
  }
}
