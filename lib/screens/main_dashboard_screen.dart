import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import 'ride_map_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/driver_state_provider.dart';
import '../models/ride_model.dart';
import 'tabs/activite_tab.dart';
import 'tabs/paiements_tab.dart';
import 'tabs/contrat_tab.dart';
import 'tabs/profil_tab.dart';
import 'notifications_screen.dart';

class MainDashboardScreen extends ConsumerStatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  ConsumerState<MainDashboardScreen> createState() =>
      _MainDashboardScreenState();
}

class _MainDashboardScreenState extends ConsumerState<MainDashboardScreen> {
  int _currentIndex = 0;
  int _currentPromoPage = 0;
  final _promoController = PageController(viewportFraction: 0.93);
  Timer? _promoTimer;
  String _statsFilter = 'Aujourd\'hui';
  String _activityFilter = 'Tout';

  final _promoCount = 2;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _startPromoTimer();
  }

  @override
  void dispose() {
    _promoTimer?.cancel();
    _promoController.dispose();
    super.dispose();
  }

  void _startPromoTimer() {
    _promoTimer?.cancel();
    _promoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_promoController.hasClients) {
        final next = (_currentPromoPage + 1) % _promoCount;
        _promoController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _onStatsFilterChanged(String value) {
    setState(() => _statsFilter = value);
  }

  void _onActivityFilterChanged() {
    setState(() {
      _activityFilter = _activityFilter == 'Tout' ? 'Terminées' : 'Tout';
    });
  }

  void _showRideRequest() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildRideRequestModal(),
    );
  }

  Widget _buildRideRequestModal() {
    return Container(
      decoration: BoxDecoration(
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
          // Drag handle
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
            'Demandes de courses',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),

          // Request Card
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.grey200),
            ),
            child: Column(
              children: [
                // Top row: User info & Accept button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: AppColors.grey200,
                              backgroundImage: NetworkImage(
                                'https://i.pravatar.cc/100?img=11',
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                width: 12.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: AppColors.accentGreen,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.white,
                                    width: 2.w,
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
                              'Codjo Igor Z.',
                              style: TextStyle(
                                fontSize: 14.sp,
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
                          ],
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RideMapScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                      child: Text(
                        'Accepter la course',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 20.h),

                // Route timeline
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 3.w,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(height: 2.h, color: AppColors.grey200),
                    ),
                    Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentGreen,
                          width: 3.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gbegamey, Cotonou',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Départ à 5 min de vous',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 16.sp,
                      color: AppColors.grey400,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Boulevard Steinmetz, Cotonou',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Arrivée',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: Divider(color: AppColors.grey200, height: 1.h),
                ),

                // Stats row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tarif estimé',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '1 200F',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1.w, height: 30.h, color: AppColors.grey200),
                    Column(
                      children: [
                        Text(
                          'Distance',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '14,08 km',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Container(width: 1.w, height: 30.h, color: AppColors.grey200),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Durée',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '≈1h20 min',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          SizedBox(
            height: 52.h,
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: Color(0xFF2B364A)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26.r),
                ),
              ),
              child: Text(
                'Ignorer la demande',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Text(
            'Cette demande disparaîtra automatiquement dans 4:59',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.white,
      body: SafeArea(bottom: false, child: _buildBody()),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
          child: _buildBottomNavigationBar(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildAccueilTab();
      case 1:
        return const PaiementsTab();
      case 2:
        return const ContratTab();
      case 3:
        return const ActiviteTab();
      case 4:
        return ProfilTab(
          onBack: () => setState(() => _currentIndex = 0),
        );
      default:
        return Center(
          child: Text('Inconnu', style: TextStyle(color: AppColors.textHint)),
        );
    }
  }

  Widget _buildAccueilTab() {
    final isActive = ref.watch(isDriverActiveProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildWalletCard(),
          _buildStatusSection(),
          _buildServicesToggle(),
          if (isActive) _buildActiveRideCard(),
          _buildEnginCard(),
          _buildContractCard(),
          SizedBox(height: 16.h),
          _buildPromoCarousel(),
          SizedBox(height: 24.h),
          _buildStatisticsSection(),
          _buildRecentActivities(),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final user = ref.watch(userProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo_blue.png',
            height: 32.h,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.broken_image, color: AppColors.primaryBlue, size: 32.sp);
            },
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                onLongPress: _showRideRequest,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Icon(Icons.notifications_none_rounded, size: 28.sp),
                    ),
                    Positioned(
                      right: 4.w,
                      top: 4.h,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _currentIndex = 4;
                  });
                },
                child: CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.grey200,
                  backgroundImage: NetworkImage(user.profileImageUrl),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    final balance = ref.watch(walletBalanceProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portefeuille',
                  style: TextStyle(color: AppColors.white, fontSize: 12.sp),
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
            Row(
              children: [
                _buildCardButton(Icons.add, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rechargement bientôt disponible'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }),
                SizedBox(width: 12.w),
                _buildCardButton(Icons.file_upload, onTap: () {
                  setState(() => _currentIndex = 1);
                }),
                SizedBox(width: 12.w),
                _buildCardButton(Icons.history_rounded, onTap: () {
                  setState(() => _currentIndex = 3);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22.sp),
      ),
    );
  }

  Widget _buildStatusSection() {
    final isActive = ref.watch(isDriverActiveProvider);
    final user = ref.watch(userProvider);

    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bon retour, ${user.firstName}',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Text(
                    isActive ? 'Actif' : 'Inactif',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: isActive
                          ? AppColors.accentGreen
                          : AppColors.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 24.h,
                    width: 44.w,
                    child: Switch(
                      value: isActive,
                      onChanged: (val) {
                        ref.read(isDriverActiveProvider.notifier).state = val;
                      },
                      activeThumbColor: AppColors.white,
                      activeTrackColor: AppColors.accentGreen,
                      inactiveThumbColor: AppColors.white,
                      inactiveTrackColor: AppColors.grey200,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            'Bienvenue sur votre tableau de bord',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesToggle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choisissez le(s) service(s) à activer',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 44.h,
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(22.r),
            ),
            child: Row(
              children: [
                _buildServiceOption('Transport'),
                _buildServiceOption('Livraison'),
                _buildServiceOption('Les deux'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOption(String text) {
    final selectedService = ref.watch(selectedServiceProvider);
    final isSelected = selectedService == text;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedServiceProvider.notifier).state = text;
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2B364A) : Colors.transparent,
            borderRadius: BorderRadius.circular(22.r),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? AppColors.white : AppColors.textHint,
              fontSize: 13.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveRideCard() {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 0.h, 24.w, 16.h),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.grey200,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/100?img=11',
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Codjo Igor Z.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '14:50 - N° 77052B07',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    'En cours',
                    style: TextStyle(
                      color: AppColors.accentGreen,
                      fontWeight: FontWeight.w600,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryBlue,
                          width: 3.w,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(height: 2.h, color: AppColors.primaryBlue),
                    ),
                    Container(
                      width: 12.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.accentGreen,
                          width: 3.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Gbegamey, Cotonou',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Départ à 5 min de vous',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textHint,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Icon(
                        Icons.arrow_forward_rounded,
                        size: 16.sp,
                        color: AppColors.textHint,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Boulevard Steinmetz, Cotonou',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Arrivée',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textHint,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.grey200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Tarif estimé',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '1 200F',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1.w, height: 24.h, color: AppColors.grey200),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Distance',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '14,08 km',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 1.w, height: 24.h, color: AppColors.grey200),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          'Durée',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppColors.textHint,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '≈1h20 min',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnginCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            // Vehicle Circle image
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.all(2.w),
              child: Image.asset('assets/images/moto.png', fit: BoxFit.contain),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Votre engin',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          'BAJAJ 125 - TG 4585 DG',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textHint,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 16.sp,
                        color: AppColors.textHint,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w),
              ),
              child: Text('Covoiturage', style: TextStyle(fontSize: 12.sp)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.r),
            bottomRight: Radius.circular(16.r),
          ),
          border: Border(
            left: BorderSide(color: AppColors.grey200),
            right: BorderSide(color: AppColors.grey200),
            bottom: BorderSide(color: AppColors.grey200),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Type de contrat',
                  style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Propriétaire indépendant',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.accentGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_outlined,
                    size: 14.sp,
                    color: AppColors.accentGreen,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'À jour',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCarousel() {
    return SizedBox(
      height: 104.h,
      child: PageView.builder(
        controller: _promoController,
        padEnds: false,
        onPageChanged: (page) => setState(() => _currentPromoPage = page),
        itemCount: _promoCount,
        itemBuilder: (_, index) {
          final isPromo = index == 0;
          final badgeText = isPromo ? 'Promo' : 'Parrainage';
          final descText = isPromo 
              ? '-25% sur votre\npremière course !' 
              : 'Gagnez 500 F\npar filleul !';

          return Container(
            margin: EdgeInsets.only(
              left: 16.w,
              right: index == _promoCount - 1 ? 16.w : 6.w,
            ),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: AppColors.primaryBlue,
            ),
            child: Stack(
              children: [
                // Right side image taking exactly half the banner, without gradient
                Positioned(
                  right: 0,
                  top: 0,
                  bottom: 0,
                  width: 175.w,
                  child: Image.asset(
                    'assets/images/promo_banner.png',
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.white.withValues(alpha: 0.05),
                      child: Icon(
                        isPromo ? Icons.local_shipping_rounded : Icons.people_rounded,
                        color: Colors.white.withValues(alpha: 0.2),
                        size: 48.sp,
                      ),
                    ),
                  ),
                ),
                // Left side content (Promo badge and text)
                Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  right: 175.w, // Ensures it stays strictly on the blue side
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 4.w, 16.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5AB315),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Expanded(
                          child: Text(
                            descText,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                              height: 1.15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Circular button vertically centered, placed entirely on the blue background
                Positioned(
                  right: 180.w, // Placed safely on the blue background, next to the image
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w), // slight visual centering for arrow
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.primaryBlue,
                          size: 14.sp,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatisticsSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Statistiques',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: _onStatsFilterChanged,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                offset: Offset(0, 36.h),
                itemBuilder: (context) => [
                  'Aujourd\'hui', 'Hier', 'Cette semaine', 'Ce mois', 'Cette année'
                ].map((period) {
                  return PopupMenuItem<String>(
                    value: period,
                    height: 36.h,
                    child: Text(
                      period,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: _statsFilter == period
                            ? AppColors.primaryBlue
                            : AppColors.textPrimary,
                        fontWeight: _statsFilter == period
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.grey200),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _statsFilter,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(Icons.keyboard_arrow_down_rounded, size: 16.sp),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.pedal_bike_rounded,
                  title: '36',
                  subtitle: 'Courses effectuées',
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.payments_outlined,
                  title: '156 960 F',
                  subtitle: 'Total encaissé',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: 64.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            width: 36.w,
            height: 36.h,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(icon, size: 18.sp, color: AppColors.white),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities() {
    final recentRides = ref.watch(recentRidesProvider);
    final filteredRides = _activityFilter == 'Terminées'
        ? recentRides.where((r) => r.status == RideStatus.completed).toList()
        : recentRides;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Dernières activités',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: _onActivityFilterChanged,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _activityFilter == 'Terminées'
                        ? AppColors.primaryBlue.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    children: [
                      Text(
                        _activityFilter == 'Terminées' ? 'Terminées' : 'Tout voir',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: _activityFilter == 'Terminées'
                              ? AppColors.primaryBlue
                              : AppColors.primaryBlue,
                        ),
                      ),
                      AnimatedRotation(
                        turns: _activityFilter == 'Terminées' ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(
                          _activityFilter == 'Terminées'
                              ? Icons.filter_list_off_rounded
                              : Icons.chevron_right_rounded,
                          size: 16.sp,
                          color: AppColors.primaryBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          if (filteredRides.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: Text(
                  'Aucune activité',
                  style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
                ),
              ),
            )
          else
            ...filteredRides.map(
              (ride) => Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor: AppColors.grey200,
                          backgroundImage: NetworkImage(ride.clientImageUrl),
                        ),
                        if (ride.status == RideStatus.completed)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 10.w,
                              height: 10.h,
                              decoration: BoxDecoration(
                                color: AppColors.accentGreen,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.white,
                                  width: 2.w,
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
                          Text(
                            ride.clientName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '${ride.date.hour}:${ride.date.minute.toString().padLeft(2, '0')} • N° ${ride.id.toUpperCase()}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ),
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
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2B364A),
        borderRadius: BorderRadius.circular(40.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.home_outlined, 'Accueil'),
          _buildNavItem(1, Icons.payments_outlined, 'Paiements'),
          _buildNavItem(2, Icons.insert_drive_file_outlined, 'Contrat'),
          _buildNavItem(3, Icons.article_outlined, 'Activité'),
          _buildNavItem(4, Icons.person_outline_rounded, 'Profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.white
                  : AppColors.textHint.withValues(alpha: 0.5),
              size: 22.sp,
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.white
                    : AppColors.textHint.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
