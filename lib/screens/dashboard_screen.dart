import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
            _buildTabs(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo Keke
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: CustomPaint(
                  painter: _MiniKekeLogoPainter(),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                'Littoral >',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          // Icons right
          Row(
            children: [
              Stack(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.notifications_none_rounded, size: 28),
                  ),
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '2',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const MainDashboardScreen()),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primaryBlue,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portefeuille',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '0 FCFA',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                _buildCardButton(Icons.add),
                const SizedBox(width: 12),
                _buildCardButton(Icons.upload_rounded),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardButton(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: AppColors.primaryBlue,
        size: 22,
      ),
    );
  }

  Widget _buildStatusSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Bienvenue, François',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Text(
                    _isInactive ? 'Inactif' : 'Actif',
                    style: TextStyle(
                      fontSize: 12,
                      color: _isInactive ? AppColors.textHint : AppColors.primaryBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 24,
                    width: 44,
                    child: Switch(
                      value: !_isInactive,
                      onChanged: (val) {
                        setState(() {
                          _isInactive = !val;
                        });
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
          const SizedBox(height: 8),
          const Text(
            'Avant de continuer, votre profil doit être validé',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentStep = 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _currentStep == 1 ? AppColors.accentGreen : AppColors.grey200,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    if (_currentStep == 2)
                      const Icon(Icons.check, size: 16, color: AppColors.accentGreen),
                    if (_currentStep == 2) const SizedBox(width: 4),
                    Text(
                      'Étape 1/2',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _currentStep == 1 ? FontWeight.bold : FontWeight.w500,
                        color: _currentStep == 1 ? AppColors.textPrimary : AppColors.textHint,
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _currentStep == 2 ? AppColors.accentGreen : AppColors.grey200,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'Étape 2/2',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: _currentStep == 2 ? FontWeight.bold : FontWeight.w500,
                        color: _currentStep == 2 ? AppColors.textPrimary : AppColors.textHint,
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

  // --- ÉTAPE 1 ---
  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Importez les documents suivants',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          '(Image ou document)',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 16),
        _buildUploadField("Pièce d'identité (CIP, Passeport, etc)"),
        const SizedBox(height: 12),
        _buildUploadField("Attestation de résidence"),
        const SizedBox(height: 12),
        _buildUploadField("Casier judiciaire"),
        const SizedBox(height: 12),
        _buildUploadField("Photo d'identité"),
        
        const SizedBox(height: 24),
        const Text(
          'Personne à contacter en cas d\'urgence',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInputField(hint: 'Nom', icon: Icons.person_outline_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField(hint: 'Prénom', icon: Icons.person_outline_rounded)),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField(hint: 'Numéro de téléphone', icon: Icons.phone_outlined, isPhone: true),

        const SizedBox(height: 24),
        const Text(
          'Avaliseur ou garant',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildInputField(hint: 'Nom', icon: Icons.person_outline_rounded)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField(hint: 'Prénom', icon: Icons.person_outline_rounded)),
          ],
        ),
        const SizedBox(height: 12),
        _buildInputField(hint: 'Numéro de téléphone', icon: Icons.phone_outlined, isPhone: true),
        
        const SizedBox(height: 32),
        SizedBox(
          height: 52,
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
                borderRadius: BorderRadius.circular(26),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Enregistrer et continuer',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // --- ÉTAPE 2 ---
  Widget _buildStep2() {
    if (_appointmentScheduled) {
      return _buildAppointmentScheduledView();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Toggle J'ai un engin / Je souhaite...
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _hasEngine = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _hasEngine ? const Color(0xFF2B364A) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "J'ai un engin",
                      style: TextStyle(
                        color: _hasEngine ? AppColors.white : AppColors.textHint,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _hasEngine = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: !_hasEngine ? const Color(0xFF2B364A) : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "Je souhaite obtenir un engin",
                      style: TextStyle(
                        color: !_hasEngine ? AppColors.white : AppColors.textHint,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const Text(
          'Engin utilisé',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),

        // Vehicles
        Row(
          children: [
            Expanded(child: _buildVehicleCard(0, 'Voiture', 'assets/images/voiture.png')),
            const SizedBox(width: 12),
            Expanded(child: _buildVehicleCard(1, 'Tricycle', 'assets/images/tricycle.png')),
            const SizedBox(width: 12),
            Expanded(child: _buildVehicleCard(2, 'Moto', 'assets/images/moto.png')),
          ],
        ),

        const SizedBox(height: 16),
        _buildInputField(hint: "Numéro d'immatriculation", icon: Icons.feed_outlined),

        const SizedBox(height: 32),
        const Text(
          'Pour finaliser la validation de votre profil, nous devons vous rencontrer.\nQuand êtes-vous disponible ?',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: _buildInputField(hint: 'Jour / Mois', icon: Icons.calendar_today_outlined)),
            const SizedBox(width: 12),
            Expanded(child: _buildInputField(hint: 'Heure', icon: Icons.access_time)),
          ],
        ),

        const SizedBox(height: 48),

        // Bottom buttons
        Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFF2B364A),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  setState(() => _currentStep = 1);
                },
                icon: const Icon(Icons.chevron_left_rounded, color: AppColors.white, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 52,
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
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Enregistrer et valider',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAppointmentScheduledView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Votre rendez-vous',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.grey50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.grey200,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=11'), // Dummy image for avatar
                  ),
                  const SizedBox(width: 12),
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
                  const SizedBox(width: 8),
                  _buildSmallButton('Annuler', true),
                ],
              ),
              
              const SizedBox(height: 16),
              const Text(
                'Lieu de la rencontre',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textHint,
                ),
              ),
              const SizedBox(height: 4),
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
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      child: const Row(
                        children: [
                          Text('Contacter', style: TextStyle(fontSize: 12)),
                          SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded, size: 16),
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
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: isOutlined ? Colors.transparent : const Color(0xFF2B364A),
        borderRadius: BorderRadius.circular(14),
        border: isOutlined ? Border.all(color: const Color(0xFF2B364A)) : null,
      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
          color: isOutlined ? const Color(0xFF2B364A) : AppColors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildVehicleCard(int index, String title, String imagePath) {
    final isSelected = _selectedVehicleIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicleIndex = index),
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : AppColors.grey50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.grey200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 40, fit: BoxFit.contain),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? AppColors.primaryBlue : AppColors.textHint,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadField(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textHint,
              ),
            ),
          ),
          const Icon(
            Icons.file_upload_outlined,
            color: AppColors.grey400,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String hint,
    required IconData icon,
    bool isPhone = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey200),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 13,
            color: AppColors.textHint,
          ),
          prefixIcon: isPhone
              ? const Padding(
                  padding: EdgeInsets.only(right: 8, top: 12, bottom: 12),
                  child: Text('🇧🇯 +229', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                )
              : Icon(icon, size: 20, color: AppColors.grey400),
          prefixIconConstraints: const BoxConstraints(minWidth: 40),
        ),
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.textPrimary,
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
