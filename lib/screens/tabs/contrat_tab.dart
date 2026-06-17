import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../client_details_screen.dart';

class ContratTab extends StatefulWidget {
  const ContratTab({super.key});

  @override
  State<ContratTab> createState() => _ContratTabState();
}

class _ContratTabState extends State<ContratTab> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Votre contrat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Consultez les détails de votre contrat et de vos paiements',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Status Banner
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.check, color: AppColors.white, size: 14),
                            const SizedBox(width: 4),
                            const Text(
                              'Actif',
                              style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Du 25 Fev. 2026 au 25 Aoû. 2026',
                          style: TextStyle(color: AppColors.white, fontSize: 12),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildCircleButton(Icons.remove_red_eye_outlined),
                        const SizedBox(width: 8),
                        _buildCircleButton(Icons.download_rounded),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Statistics
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Statistiques',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.info_outline,
                      title: '6 000 F',
                      subtitle: 'À payer demain',
                      bgColor: const Color(0xFFE53935),
                      textColor: AppColors.white,
                      iconColor: const Color(0xFFE53935),
                      iconBgColor: AppColors.white,
                      showArrow: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.account_balance_wallet_outlined,
                      title: '25 %',
                      subtitle: 'Total payé',
                      bgColor: AppColors.grey50,
                      textColor: AppColors.textPrimary,
                      iconColor: AppColors.textPrimary,
                      iconBgColor: AppColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.pie_chart_outline,
                      title: '75 %',
                      subtitle: 'Reste à payer',
                      bgColor: AppColors.grey50,
                      textColor: AppColors.textPrimary,
                      iconColor: AppColors.textPrimary,
                      iconBgColor: AppColors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.check_circle_outline,
                      title: '27 800 F',
                      subtitle: 'Bénéfice actuel',
                      bgColor: AppColors.grey50,
                      textColor: AppColors.textPrimary,
                      iconColor: AppColors.textPrimary,
                      iconBgColor: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Container(
            color: AppColors.white,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Historique des paiements',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.check_circle_outline, size: 12, color: AppColors.accentGreen),
                          SizedBox(width: 4),
                          Text(
                            'À jour',
                            style: TextStyle(fontSize: 10, color: AppColors.accentGreen, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildPaymentItem(
                  date: 'Jeudi 24 Avril 2026',
                  time: '14:50 • N° 77052807',
                  description: 'Paiement du montant journalier',
                  amount: '3 600 F',
                  status: 'Effectué',
                ),
                _buildPaymentItem(
                  date: 'Jeudi 24 Avril 2026',
                  time: '14:50 • N° 77052807',
                  description: 'Paiement du montant journalier + retards',
                  amount: '10 800 F',
                  status: 'Effectué',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircleButton(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.textPrimary, size: 18),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color textColor,
    required Color iconColor,
    required Color iconBgColor,
    bool showArrow = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: bgColor == AppColors.grey50 ? Border.all(color: AppColors.grey200) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              if (showArrow)
                Icon(Icons.chevron_right_rounded, color: textColor.withValues(alpha: 0.7), size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem({
    required String date,
    required String time,
    required String description,
    required String amount,
    required String status,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.only(bottom: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.grey200,
            backgroundImage: NetworkImage('https://i.pravatar.cc/100?img=11'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      amount,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textHint.withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientDetailsScreen()),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Télécharger la facture',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
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
