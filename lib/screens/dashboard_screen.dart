import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import 'main_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentStep = 1; // 1 for Étape 1, 2 for Étape 2
  bool _isInactive = true;
  bool _hasEngine = true;
  int _selectedVehicleIndex = 0; // 0: Voiture, 1: Tricycle, 2: Moto
  bool _appointmentScheduled = false;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final day = picked.day.toString().padLeft(2, '0');
      final month = picked.month.toString().padLeft(2, '0');
      _dateController.text = "$day/$month/${picked.year}";
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      if (!context.mounted) return;
      final localizations = MaterialLocalizations.of(context);
      _timeController.text = localizations.formatTimeOfDay(
        picked,
        alwaysUse24HourFormat: true,
      );
    }
  }

  Future<void> _pickFile(String docName) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sélectionner un fichier pour : $docName')),
    );
  }

  void _showPhotoPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                'Photo d\'identité',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Prendre une photo (Caméra)'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ouverture de la caméra...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choisir dans la galerie'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ouverture de la galerie...')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            _buildWalletCard(),
            _buildStatusSection(),
            if (!_appointmentScheduled) _buildTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                child: _currentStep == 1 ? _buildStep1() : _buildStep2(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo_blue.png',
                  width: 36.w,
                  height: 32.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Littoral >',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Row(
            children: [
              Stack(
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
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 36.w,
                  height: 36.h,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletCard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Portefeuille',
                  style: TextStyle(color: AppColors.white, fontSize: 12.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  '0 FCFA',
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
                _buildCardButton(Icons.add),
                SizedBox(width: 12.w),
                _buildCardButton(Icons.file_upload_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(IconData icon) {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 24.sp),
    );
  }

  Widget _buildStatusSection() {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bienvenue, François',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Text(
                    _isInactive ? 'Inactif' : 'Actif',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _isInactive
                          ? AppColors.textHint
                          : AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  SizedBox(
                    height: 24.h,
                    width: 44.w,
                    child: Switch(
                      value: !_isInactive,
                      onChanged: (val) {
                        setState(() {
                          _isInactive = !val;
                        });
                        if (val) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MainDashboardScreen(),
                            ),
                          );
                        }
                      },
                      activeThumbColor: AppColors.white,
                      activeTrackColor: AppColors.primaryBlue,
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
            'Avant de continuer, votre profil doit être validé',
            style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentStep = 1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _currentStep == 1
                          ? AppColors.accentGreen
                          : AppColors.grey200,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (_currentStep == 2)
                      Icon(
                        Icons.check,
                        size: 16.sp,
                        color: AppColors.accentGreen,
                      ),
                    if (_currentStep == 2) SizedBox(width: 4.w),
                    Text(
                      'Étape 1/2',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: _currentStep == 1
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: _currentStep == 1
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentStep = 2),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _currentStep == 2
                          ? AppColors.accentGreen
                          : AppColors.grey200,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Étape 2/2',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: _currentStep == 2
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: _currentStep == 2
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Importez les documents suivants',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '(Image ou document)',
          style: TextStyle(fontSize: 12.sp, color: AppColors.textHint),
        ),
        SizedBox(height: 16.h),
        _buildUploadField(
          "Pièce d'identité (CIP, Passeport, etc)",
          onTap: () => _pickFile("Pièce d'identité"),
        ),
        SizedBox(height: 10.h),
        _buildUploadField(
          "Attestation de résidence",
          onTap: () => _pickFile("Attestation de résidence"),
        ),
        SizedBox(height: 10.h),
        _buildUploadField(
          "Casier judiciaire",
          onTap: () => _pickFile("Casier judiciaire"),
        ),
        SizedBox(height: 10.h),
        _buildUploadField(
          "Photo d'identité",
          onTap: () => _showPhotoPickerOptions(),
        ),

        SizedBox(height: 24.h),
        Text(
          'Personne à contacter en cas d\'urgence',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                hint: 'Nom',
                icon: Icons.person_outline_rounded,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInputField(
                hint: 'Prénom',
                icon: Icons.person_outline_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildInputField(
          hint: 'Numéro de téléphone',
          icon: Icons.phone_outlined,
          isPhone: true,
        ),

        SizedBox(height: 24.h),
        Text(
          'Avaliseur ou garant',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildInputField(
                hint: 'Nom',
                icon: Icons.person_outline_rounded,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInputField(
                hint: 'Prénom',
                icon: Icons.person_outline_rounded,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildInputField(
          hint: 'Numéro de téléphone',
          icon: Icons.phone_outlined,
          isPhone: true,
        ),

        SizedBox(height: 32.h),
        SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _currentStep = 2;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 0,
            ),
            child: Text(
              'Enregistrer et continuer',
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildStep2() {
    if (_appointmentScheduled) {
      return _buildAppointmentScheduledView();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: AppColors.primaryBlue.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _hasEngine = true),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: _hasEngine
                          ? const Color(0xFF2B364A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "J'ai un engin",
                      style: TextStyle(
                        color: _hasEngine
                            ? AppColors.white
                            : AppColors.textHint,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _hasEngine = false),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: !_hasEngine
                          ? const Color(0xFF2B364A)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Je souhaite obtenir un engin",
                      style: TextStyle(
                        color: !_hasEngine
                            ? AppColors.white
                            : AppColors.textHint,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 24.h),
        Text(
          'Engin utilisé',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: _buildVehicleCard(
                0,
                'Voiture',
                'assets/images/Vehicul.png',
                isRawIcon: true,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildVehicleCard(
                1,
                'Tricycle',
                'assets/images/tricycle.png',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildVehicleCard(2, 'Moto', 'assets/images/moto.png'),
            ),
          ],
        ),

        SizedBox(height: 16.h),
        _buildInputField(
          hint: "Numéro d'immatriculation",
          icon: Icons.feed_outlined,
        ),

        SizedBox(height: 32.h),
        Text(
          'Pour finaliser la validation de votre profil, nous devons vous rencontrer.\nQuand êtes-vous disponible ?',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
        SizedBox(height: 16.h),

        Row(
          children: [
            Expanded(
              child: _buildInputField(
                hint: 'Jour / Mois',
                icon: Icons.calendar_today_outlined,
                readOnly: true,
                onTap: () => _selectDate(context),
                controller: _dateController,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInputField(
                hint: 'Heure',
                icon: Icons.access_time,
                readOnly: true,
                onTap: () => _selectTime(context),
                controller: _timeController,
              ),
            ),
          ],
        ),

        SizedBox(height: 48.h),

        Row(
          children: [
            Container(
              width: 48.w,
              height: 48.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2B364A),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: IconButton(
                onPressed: () {
                  setState(() => _currentStep = 1);
                },
                icon: Icon(
                  Icons.chevron_left_rounded,
                  color: AppColors.white,
                  size: 28.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: SizedBox(
                height: 52.h,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _appointmentScheduled = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Enregistrer et valider',
                    style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),
      ],
    );
  }

  Widget _buildAppointmentScheduledView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Votre rendez-vous',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),

        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFE6E6E6), width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.grey200,
                    backgroundImage: const NetworkImage(
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
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Mer. 17 Juin • 14:00',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildSmallButton('Modifier', false),
                  SizedBox(width: 8.w),
                  _buildSmallButton('Annuler', true),
                ],
              ),

              SizedBox(height: 16.h),
              Text(
                'Lieu de la rencontre',
                style: TextStyle(fontSize: 11.sp, color: AppColors.textHint),
              ),
              SizedBox(height: 4.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Siège de KEKE Bénin - Mènontin',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.h,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                      ),
                      child: Row(
                        children: [
                          Text('Contacter', style: TextStyle(fontSize: 12.sp)),
                          SizedBox(width: 4.w),
                          Icon(Icons.chevron_right_rounded, size: 16.sp),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallButton(String text, bool isOutlined) {
    return Container(
      height: 28.h,
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : const Color(0xFF2B364A),
        borderRadius: BorderRadius.circular(14.r),
        border: isOutlined ? Border.all(color: const Color(0xFF2B364A)) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isOutlined ? const Color(0xFF2B364A) : AppColors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildVehicleCard(
    int index,
    String title,
    String imagePath, {
    bool isRawIcon = false,
  }) {
    final isSelected = _selectedVehicleIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicleIndex = index),
      child: Container(
        height: 90.h,
        decoration: BoxDecoration(
          color: isRawIcon ? const Color(0xFFF8F8F8) : null,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.transparent,
            width: 2,
          ),
        ),
        child: isRawIcon
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(imagePath, height: 30.h, fit: BoxFit.contain),
                  SizedBox(height: 12.h),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: Image.asset(imagePath, fit: BoxFit.fill),
              ),
      ),
    );
  }

  Widget _buildUploadField(String label, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.grey200, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              Icons.file_upload_outlined,
              color: AppColors.grey400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    bool isPhone = false,
    bool readOnly = false,
    VoidCallback? onTap,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200, width: 1),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType:
            keyboardType ??
            (isPhone ? TextInputType.phone : TextInputType.text),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 14.w,
            vertical: 14.h,
          ),
          hintText: hint,
          hintStyle: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          prefixIcon: isPhone
              ? Padding(
                  padding: EdgeInsets.only(
                    left: 14.w,
                    right: 8.w,
                    top: 14.h,
                    bottom: 14.h,
                  ),
                  child: Text(
                    '🇧🇯 +229',
                    style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.only(left: 14.w, right: 8.w),
                  child: Icon(icon, size: 20.sp, color: AppColors.grey400),
                ),
          prefixIconConstraints: BoxConstraints(minWidth: 40.w),
        ),
        style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
      ),
    );
  }
}


