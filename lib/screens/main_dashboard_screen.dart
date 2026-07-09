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
                            const CircleAvatar(
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
                        const Column(
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
                    const Column(
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
                    const Column(
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
                    const Column(
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
                    const Column(
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
                    const Column(
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
        return const ProfilTab();
      default:
        return const Center(
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
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Icons.notifications_none_rounded, size: 28.sp),
                    ),
                    Positioned(
                      right: 4,
                      top: 4,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: const BoxDecoration(
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Scaffold(
                        appBar: AppBar(
                          backgroundColor: AppColors.white,
                          elevation: 0,
                          iconTheme: const IconThemeData(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        body: const ProfilTab(),
                      ),
                    ),
                  );
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
                _buildCardButton(Icons.upload_rounded, onTap: () {
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
        decoration: const BoxDecoration(
          color: AppColors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primaryBlue, size: 20.sp),
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
          const Text(
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
                const CircleAvatar(
                  radius: 20.r,
                  backgroundColor: AppColors.grey200,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/100?img=11',
                  ),
                ),
                SizedBox(width: 12.w),
                const Expanded(
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
                  padding: const EdgeInsets.symmetric(
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
                        children: const [
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
                        children: const [
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
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.grey200)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: const [
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
                      children: const [
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
                      children: const [
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
          borderRadius: const BorderRadius.only(
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
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8.w),
              child: Image.asset('assets/images/moto.png', fit: BoxFit.contain),
            ),
            SizedBox(width: 12.w),
            const Expanded(
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
          borderRadius: const BorderRadius.only(
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
            const Column(
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

  Widget _buildStatisticsSection() {
    return Padding(
      padding: EdgeInsets.all(24.w),
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 4.h,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.grey200),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: const Row(
                  children: [
                    Text(
                      'Aujourd\'hui',
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
                  bgColor: AppColors.grey50,
                  textColor: AppColors.textPrimary,
                  iconBgColor: const Color(0xFF2B364A),
                  iconColor: AppColors.white,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.payments_outlined,
                  title: '156 960 F',
                  subtitle: 'Total encaissé',
                  bgColor: AppColors.grey50,
                  textColor: AppColors.textPrimary,
                  iconBgColor: const Color(0xFF2B364A),
                  iconColor: AppColors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.access_time_rounded,
                  title: '6 000 F',
                  subtitle: 'À payer',
                  bgColor: const Color(0xFFB91D34),
                  textColor: AppColors.white,
                  iconBgColor: AppColors.white,
                  iconColor: const Color(0xFFB91D34),
                  showArrow: true,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.star_border_rounded,
                  title: '4,3/5',
                  subtitle: 'Note globale',
                  bgColor: AppColors.accentGreen,
                  textColor: AppColors.white,
                  iconBgColor: AppColors.white,
                  iconColor: AppColors.accentGreen,
                  showArrow: true,
                  onTap: () => setState(() => _currentIndex = 4),
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
    required Color bgColor,
    required Color textColor,
    required Color iconBgColor,
    required Color iconColor,
    bool showArrow = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(icon, size: 16.sp, color: iconColor),
                ),
                if (showArrow)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: textColor.withValues(alpha: 0.7),
                    size: 18.sp,
                  ),
              ],
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11.sp,
                color: textColor.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivities() {
    final recentRides = ref.watch(recentRidesProvider);

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
                onTap: () => setState(() => _currentIndex = 3),
                child: const Row(
                  children: [
                    Text(
                      'Tout voir',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16.sp,
                      color: AppColors.primaryBlue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...recentRides.map(
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

/// Mini logo Keke for header
class _MiniKekeLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;

    final verticalPath = Path();
    verticalPath.moveTo(w * 0.3, h * 0.2);
    verticalPath.lineTo(w * 0.3, h * 0.8);
    canvas.drawPath(verticalPath, paint);

    final upperDiag = Path();
    upperDiag.moveTo(w * 0.3, h * 0.5);
    upperDiag.lineTo(w * 0.7, h * 0.2);
    canvas.drawPath(upperDiag, paint);

    final lowerDiag = Path();
    lowerDiag.moveTo(w * 0.3, h * 0.5);
    lowerDiag.lineTo(w * 0.7, h * 0.8);
    canvas.drawPath(lowerDiag, paint);

    final accent = Paint()
      ..color = AppColors.accentGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final accentPath = Path();
    accentPath.moveTo(w * 0.45, h * 0.38);
    accentPath.lineTo(w * 0.55, h * 0.30);
    canvas.drawPath(accentPath, accent);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
