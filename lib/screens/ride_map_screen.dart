import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../utils/app_colors.dart';
import 'chat_screen.dart';
import 'ride_finished_screen.dart';
import 'support_screen.dart';

enum RideState {
  enRouteToPickup,
  arrivedAtPickup,
  enRouteToDestination,
}

class RideMapScreen extends StatefulWidget {
  const RideMapScreen({super.key});

  @override
  State<RideMapScreen> createState() => _RideMapScreenState();
}

class _RideMapScreenState extends State<RideMapScreen> {
  RideState _currentState = RideState.enRouteToPickup;
  int _waitingSeconds = 300; // 5 minutes timer
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startWaitingTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_waitingSeconds > 0) {
        setState(() {
          _waitingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get _formattedTime {
    final minutes = _waitingSeconds ~/ 60;
    final seconds = _waitingSeconds % 60;
    return '${minutes.toString()}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grey200,
      body: Stack(
        children: [
          // Simulated Map Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/map_bg.png',
              fit: BoxFit.cover,
              color: Colors.white.withValues(alpha: 0.6),
              colorBlendMode: BlendMode.lighten,
            ),
          ),
          
          // Map Route overlay placeholder
          Positioned.fill(
            child: CustomPaint(
              painter: _MockRoutePainter(),
            ),
          ),

          // Back Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16.h,
            left: 16.w,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))
                ],
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Bottom Sheet Content
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBottomSheet(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    final isEnRouteToPickup = _currentState == RideState.enRouteToPickup;
    final isArrived = _currentState == RideState.arrivedAtPickup;
    final isEnRouteToDest = _currentState == RideState.enRouteToDestination;
    
    Color headerColor;
    if (isEnRouteToPickup) {
      headerColor = AppColors.accentGreen;
    } else if (isArrived) {
      headerColor = const Color(0xFFE53935);
    } else {
      headerColor = AppColors.primaryBlue;
    }

    return Container(
      decoration: BoxDecoration(
        color: headerColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(top: 12.h, bottom: 12.h),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          
          // Header with GestureDetector for prototype state transition
          GestureDetector(
            onTap: () {
              setState(() {
                if (_currentState == RideState.enRouteToPickup) {
                  _currentState = RideState.arrivedAtPickup;
                } else if (_currentState == RideState.arrivedAtPickup) {
                  _currentState = RideState.enRouteToDestination;
                }
              });
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isEnRouteToPickup ? 'Rendez-vous au point de départ !' 
                    : isArrived ? 'Vous êtes arrivé au lieu de départ'
                    : 'Vous êtes en route pour votre destination',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isArrived)
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '+0F',
                          style: TextStyle(
                            color: Color(0xFFE53935),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '-$_formattedTime',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    '19:32',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          ),
          
          SizedBox(height: 8.h),
          
          // White Card Content
          Container(
            height: 390.h,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24.r),
                topRight: Radius.circular(24.r),
              ),
            ),
            child: Column(
              children: [
                // User Info Row
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 24.r,
                          backgroundColor: AppColors.grey200,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=12'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 14.w,
                            height: 14.h,
                            decoration: BoxDecoration(
                              color: AppColors.accentGreen,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.white, width: 2.w),
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
                          Text(
                            'Dieu-donné Y.',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '14:50 • N° 77052807',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, color: Color(0xFFFFB800), size: 14.sp),
                              SizedBox(width: 4.w),
                              Text('4.93', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCircleButton(Icons.phone, () {}),
                    SizedBox(width: 12.w),
                    _buildCircleButton(Icons.chat_bubble_outline, () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ChatScreen(),
                      );
                    }),
                  ],
                ),
                
                SizedBox(height: 24.h),
                
                // Route Info Container
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.primaryBlue, width: 3.w),
                                ),
                              ),
                              Container(
                                width: 2.w,
                                height: 30.h,
                                color: AppColors.grey200,
                              ),
                              Container(
                                width: 12.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.accentGreen, width: 3.w),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Adresse de départ', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                                Text('à 159m de F7', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Divider(color: AppColors.grey200, height: 1.h),
                                ),
                                Text('Destination', style: TextStyle(fontSize: 11.sp, color: AppColors.textHint)),
                                Text('9C&M+F3M, Boulevard Steinmetz, Cotonou', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                SizedBox(height: 16.h),
                
                // Price detail
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey50,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.local_offer_outlined, size: 18.sp, color: AppColors.primaryBlue),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Text(
                          'Détails du tarif - Paiement en espèces',
                          style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 20.sp, color: AppColors.grey400),
                    ],
                  ),
                ),
                
                SizedBox(height: 24.h),
                
                // Action Buttons based on state
                if (isEnRouteToPickup)
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: Color(0xFF2B364A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                          ),
                          child: Text('Annuler', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentState = RideState.arrivedAtPickup;
                            });
                            _startWaitingTimer();
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
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Je suis arrivé', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  )
                else if (isArrived)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const SupportScreen()),
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
                          child: Text('Contacter le support client', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  )
                else if (isEnRouteToDest)
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            side: const BorderSide(color: Color(0xFF2B364A)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 16.h),
                          ),
                          child: Text('Pause', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const RideFinishedScreen()),
                            );
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
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('Terminer la course', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.h,
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.white, size: 20.sp),
      ),
    );
  }
}

/// Draws a fake map route
class _MockRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(size.width * 0.3, size.height * 0.45);
    path.lineTo(size.width * 0.6, size.height * 0.38);
    path.lineTo(size.width * 0.55, size.height * 0.25);
    path.lineTo(size.width * 0.85, size.height * 0.15);

    canvas.drawPath(path, paint);

    // Draw nodes
    final nodePaint = Paint()..color = AppColors.white;
    final strokePaint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
      
    final startPaint = Paint()
      ..color = AppColors.accentGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.45), 6, nodePaint);
    canvas.drawCircle(Offset(size.width * 0.3, size.height * 0.45), 6, startPaint);

    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 6, nodePaint);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.15), 6, strokePaint);
    
    // Draw current location circle
    final currentLocPaint = Paint()..color = AppColors.primaryBlue.withValues(alpha: 0.2);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.38), 20, currentLocPaint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.38), 6, Paint()..color = AppColors.primaryBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
