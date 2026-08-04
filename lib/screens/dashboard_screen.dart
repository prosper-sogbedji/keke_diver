import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../utils/app_colors.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_appointment_picker.dart';
import 'main_dashboard_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _currentStep = 1;
  bool _isInactive = true;
  bool _hasEngine = true;
  int _selectedVehicleIndex = 0; // 0: Voiture, 1: Tricycle, 2: Moto
  bool _appointmentScheduled = false;
  bool _isSubmitting = false;

  // Étape 1 — Documents
  String? _docIdentitePath;
  String? _docResidencePath;
  String? _docCasierPath;
  String? _docPhotoPath;

  // Étape 1 — Chauffeur
  final TextEditingController _driverNomController = TextEditingController();
  final TextEditingController _driverPrenomController = TextEditingController();
  final TextEditingController _driverTelController = TextEditingController();

  // Étape 1 — Contacts
  final TextEditingController _urgenceNomController = TextEditingController();
  final TextEditingController _urgencePrenomController = TextEditingController();
  final TextEditingController _urgenceTelController = TextEditingController();
  final TextEditingController _garantNomController = TextEditingController();
  final TextEditingController _garantPrenomController = TextEditingController();
  final TextEditingController _garantTelController = TextEditingController();
  final TextEditingController _garant2NomController = TextEditingController();
  final TextEditingController _garant2PrenomController = TextEditingController();
  final TextEditingController _garant2TelController = TextEditingController();

  // Étape 2 — Véhicule
  final TextEditingController _immatriculationController = TextEditingController();
  
  DateTime? _selectedAppointment;
  final TextEditingController _appointmentController = TextEditingController();

  final List<String> _vehiculeTypes = ['Voiture', 'Tricycle', 'Moto'];

  Future<void> _pickFile(String docKey) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final ext = path.split('.').last.toLowerCase();
      String? finalPath = path;
      // Compresser si c'est une image
      if (['jpg', 'jpeg', 'png'].contains(ext)) {
        finalPath = await _compressImage(path);
      }
      setState(() {
        switch (docKey) {
          case 'identite':
            _docIdentitePath = finalPath;
            break;
          case 'residence':
            _docResidencePath = finalPath;
            break;
          case 'casier':
            _docCasierPath = finalPath;
            break;
        }
      });
    }
  }

  /// Prend une photo via la caméra ou la galerie, puis la compresse
  Future<void> _pickImage({required ImageSource source}) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85, // Pré-compression de ImagePicker
      maxWidth: 1920,
      maxHeight: 1920,
    );
    if (picked == null) return;

    final compressed = await _compressImage(picked.path);
    setState(() => _docPhotoPath = compressed ?? picked.path);
  }

  /// Compresse une image et retourne le chemin du fichier compressé
  Future<String?> _compressImage(String sourcePath) async {
    final targetPath = sourcePath.replaceAll(
      RegExp(r'\.(jpg|jpeg|png)$', caseSensitive: false),
      '_compressed.jpg',
    );
    final result = await FlutterImageCompress.compressAndGetFile(
      sourcePath,
      targetPath,
      quality: 70, // Qualité 70% — bon équilibre qualité/taille
      minWidth: 1024,
      minHeight: 1024,
      format: CompressFormat.jpeg,
    );
    return result?.path;
  }

  void _showPhotoPickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Poignée
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 12.h),
                  decoration: BoxDecoration(
                    color: AppColors.grey200,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Text(
                  'Photo de profil',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.camera_alt_outlined, color: AppColors.primaryBlue, size: 22.sp),
                ),
                title: Text('Prendre une photo', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                subtitle: Text('Ouvrir la caméra', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(source: ImageSource.camera);
                },
              ),
              Divider(indent: 16.w, endIndent: 16.w, height: 1),
              ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.photo_library_outlined, color: AppColors.accentGreen, size: 22.sp),
                ),
                title: Text('Choisir dans la galerie', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
                subtitle: Text('Depuis votre galerie de photos', style: TextStyle(fontSize: 12.sp, color: AppColors.textHint)),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickImage(source: ImageSource.gallery);
                },
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitDossier() async {
    // Vérification que tous les documents sont sélectionnés
    if (_docIdentitePath == null || _docResidencePath == null ||
        _docCasierPath == null || _docPhotoPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez importer tous les documents requis'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final authApiService = ref.read(authApiServiceProvider);
    final vehicule = _vehiculeTypes[_selectedVehicleIndex];

    String formatPhone(String raw) {
      if (raw.isEmpty) return '';
      final digits = raw.replaceAll(RegExp(r'\D'), '');
      return '+229$digits';
    }

    final response = await authApiService.registerContract(
      nom: _driverNomController.text,
      prenom: _driverPrenomController.text,
      telephone: formatPhone(_driverTelController.text),
      email: '', // L'email ne semble pas requis selon l'erreur
      ville: '',
      urgenceNom: _urgenceNomController.text,
      urgencePrenom: _urgencePrenomController.text,
      urgenceTel: formatPhone(_urgenceTelController.text),
      garantNom: _garantNomController.text,
      garantPrenom: _garantPrenomController.text,
      garantTel: formatPhone(_garantTelController.text),
      garant2Nom: _garant2NomController.text,
      garant2Prenom: _garant2PrenomController.text,
      garant2Tel: formatPhone(_garant2TelController.text),
      vehiculeType: vehicule,
      immatriculation: _immatriculationController.text,
      docIdentitePath: _docIdentitePath!,
      docResidencePath: _docResidencePath!,
      docCasierPath: _docCasierPath!,
      docPhotoPath: _docPhotoPath!,
      rdvDate: _selectedAppointment != null 
          ? '${_selectedAppointment!.year}-${_selectedAppointment!.month.toString().padLeft(2, '0')}-${_selectedAppointment!.day.toString().padLeft(2, '0')}' 
          : '',
      rdvStartTime: _selectedAppointment != null 
          ? '${_selectedAppointment!.hour.toString().padLeft(2, '0')}:${_selectedAppointment!.minute.toString().padLeft(2, '0')}:00' 
          : '',
      rdvEndTime: _selectedAppointment != null 
          ? '${_selectedAppointment!.add(const Duration(minutes: 45)).hour.toString().padLeft(2, '0')}:${_selectedAppointment!.add(const Duration(minutes: 45)).minute.toString().padLeft(2, '0')}:00' 
          : '',
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (response.isSuccess) {
      // --- MOCK ---
      // On passe le statut à 'active' manuellement en attendant le backend.
      await ref.read(authProvider.notifier).updateDriverStatus('active');
      // ------------

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                        onChanged: (val) async {
                          setState(() {
                            _isInactive = !val;
                          });
                          if (val) {
                            // On force le statut à active manuellement
                            await ref.read(authProvider.notifier).updateDriverStatus('active');
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const MainDashboardScreen(),
                                ),
                              );
                            }
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
          fileName: _docIdentitePath,
          onTap: () => _pickFile('identite'),
        ),
        SizedBox(height: 10.h),
        _buildUploadField(
          "Attestation de résidence",
          fileName: _docResidencePath,
          onTap: () => _pickFile('residence'),
        ),
        SizedBox(height: 10.h),
        _buildUploadField(
          "Casier judiciaire",
          fileName: _docCasierPath,
          onTap: () => _pickFile('casier'),
        ),
        SizedBox(height: 10.h),
        _buildUploadField(
          "Photo d'identité",
          fileName: _docPhotoPath,
          onTap: () => _showPhotoPickerOptions(),
        ),

        SizedBox(height: 24.h),
        Text(
          'Vos informations personnelles',
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
                controller: _driverNomController,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInputField(
                hint: 'Prénom',
                icon: Icons.person_outline_rounded,
                controller: _driverPrenomController,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildInputField(
          hint: 'Numéro de téléphone',
          icon: Icons.phone_outlined,
          isPhone: true,
          controller: _driverTelController,
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
                controller: _urgenceNomController,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInputField(
                hint: 'Prénom',
                icon: Icons.person_outline_rounded,
                controller: _urgencePrenomController,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildInputField(
          hint: 'Numéro de téléphone',
          icon: Icons.phone_outlined,
          isPhone: true,
          controller: _urgenceTelController,
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
                controller: _garantNomController,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInputField(
                hint: 'Prénom',
                icon: Icons.person_outline_rounded,
                controller: _garantPrenomController,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildInputField(
          hint: 'Numéro de téléphone',
          icon: Icons.phone_outlined,
          isPhone: true,
          controller: _garantTelController,
        ),

        SizedBox(height: 24.h),
        Text(
          'Second Avaliseur ou garant',
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
                controller: _garant2NomController,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildInputField(
                hint: 'Prénom',
                icon: Icons.person_outline_rounded,
                controller: _garant2PrenomController,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        _buildInputField(
          hint: 'Numéro de téléphone',
          icon: Icons.phone_outlined,
          isPhone: true,
          controller: _garant2TelController,
        ),

        SizedBox(height: 32.h),
        SizedBox(
          height: 52.h,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : () => setState(() => _currentStep = 2),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Enregistrer et continuer',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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
          controller: _immatriculationController,
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

        _buildInputField(
          hint: 'Mois/jour / Horaire',
          icon: Icons.calendar_today_outlined,
          readOnly: true,
          controller: _appointmentController,
          onTap: () async {
            final picked = await CustomAppointmentPicker.show(context, initialDate: _selectedAppointment);
            if (picked != null) {
              setState(() {
                _selectedAppointment = picked;
                final day = picked.day.toString().padLeft(2, '0');
                final month = picked.month.toString().padLeft(2, '0');
                final hour = picked.hour.toString().padLeft(2, '0');
                final minute = picked.minute.toString().padLeft(2, '0');
                _appointmentController.text = '$day/$month/${picked.year} - $hour:$minute';
              });
            }
          },
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
                  onPressed: _isSubmitting ? null : _submitDossier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : const Text(
                          'Enregistrer et valider',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
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

  Widget _buildUploadField(String label, {VoidCallback? onTap, String? fileName}) {
    final hasFile = fileName != null;
    final displayName = hasFile ? fileName.split('/').last.split('\\').last : label;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 48.h,
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        decoration: BoxDecoration(
          color: hasFile
              ? AppColors.accentGreen.withValues(alpha: 0.07)
              : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: hasFile ? AppColors.accentGreen : AppColors.grey200,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                displayName,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: hasFile ? AppColors.accentGreen : AppColors.textHint,
                  fontWeight: hasFile ? FontWeight.w500 : FontWeight.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              hasFile ? Icons.check_circle_outline : Icons.file_upload_outlined,
              color: hasFile ? AppColors.accentGreen : AppColors.grey400,
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


