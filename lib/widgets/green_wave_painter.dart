import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';

/// Paints decorative green wavy/swoosh curves over the onboarding images
class GreenWavePainter extends CustomPainter {
  final int variant; // 0, 1, 2 for different wave shapes per page

  GreenWavePainter({this.variant = 0});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // First green wave (darker green)
    paint.color = AppColors.accentGreen.withValues(alpha: 0.85);
    final path1 = _buildWavePath1(w, h);
    canvas.drawPath(path1, paint);

    // Second green wave (lighter, offset)
    paint.color = AppColors.accentGreenLight.withValues(alpha: 0.7);
    paint.strokeWidth = 14;
    final path2 = _buildWavePath2(w, h);
    canvas.drawPath(path2, paint);
  }

  Path _buildWavePath1(double w, double h) {
    final path = Path();

    switch (variant) {
      case 0:
        // S-curve from left-center down to right
        path.moveTo(-w * 0.05, h * 0.45);
        path.cubicTo(
          w * 0.15, h * 0.55,
          w * 0.10, h * 0.75,
          w * 0.30, h * 0.80,
        );
        path.cubicTo(
          w * 0.50, h * 0.85,
          w * 0.45, h * 0.60,
          w * 0.65, h * 0.65,
        );
        path.cubicTo(
          w * 0.85, h * 0.70,
          w * 0.80, h * 0.90,
          w * 1.05, h * 0.85,
        );
        break;
      case 1:
        // Wide S from left to right
        path.moveTo(-w * 0.08, h * 0.40);
        path.cubicTo(
          w * 0.20, h * 0.50,
          w * 0.05, h * 0.70,
          w * 0.35, h * 0.72,
        );
        path.cubicTo(
          w * 0.55, h * 0.74,
          w * 0.50, h * 0.55,
          w * 0.75, h * 0.60,
        );
        path.cubicTo(
          w * 1.00, h * 0.65,
          w * 0.90, h * 0.85,
          w * 1.10, h * 0.80,
        );
        break;
      case 2:
      default:
        // More complex wave
        path.moveTo(-w * 0.05, h * 0.50);
        path.cubicTo(
          w * 0.15, h * 0.55,
          w * 0.20, h * 0.70,
          w * 0.35, h * 0.60,
        );
        path.cubicTo(
          w * 0.50, h * 0.50,
          w * 0.45, h * 0.78,
          w * 0.65, h * 0.72,
        );
        path.cubicTo(
          w * 0.85, h * 0.66,
          w * 0.80, h * 0.90,
          w * 1.05, h * 0.82,
        );
        break;
    }

    return path;
  }

  Path _buildWavePath2(double w, double h) {
    final path = Path();

    switch (variant) {
      case 0:
        path.moveTo(-w * 0.03, h * 0.55);
        path.cubicTo(
          w * 0.20, h * 0.62,
          w * 0.15, h * 0.80,
          w * 0.40, h * 0.82,
        );
        path.cubicTo(
          w * 0.60, h * 0.84,
          w * 0.55, h * 0.68,
          w * 0.80, h * 0.72,
        );
        path.cubicTo(
          w * 0.95, h * 0.75,
          w * 0.90, h * 0.92,
          w * 1.10, h * 0.88,
        );
        break;
      case 1:
        path.moveTo(-w * 0.05, h * 0.50);
        path.cubicTo(
          w * 0.15, h * 0.58,
          w * 0.10, h * 0.75,
          w * 0.30, h * 0.78,
        );
        path.cubicTo(
          w * 0.50, h * 0.81,
          w * 0.60, h * 0.62,
          w * 0.80, h * 0.68,
        );
        path.cubicTo(
          w * 1.00, h * 0.74,
          w * 0.95, h * 0.90,
          w * 1.10, h * 0.86,
        );
        break;
      case 2:
      default:
        path.moveTo(-w * 0.03, h * 0.58);
        path.cubicTo(
          w * 0.18, h * 0.63,
          w * 0.25, h * 0.76,
          w * 0.40, h * 0.68,
        );
        path.cubicTo(
          w * 0.55, h * 0.60,
          w * 0.50, h * 0.82,
          w * 0.70, h * 0.78,
        );
        path.cubicTo(
          w * 0.90, h * 0.74,
          w * 0.85, h * 0.95,
          w * 1.08, h * 0.88,
        );
        break;
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant GreenWavePainter oldDelegate) =>
      variant != oldDelegate.variant;
}
