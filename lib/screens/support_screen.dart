import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import 'chat_screen.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int _selectedTab = 0; // 0 = FAQ, 1 = Tickets

  final List<Map<String, dynamic>> _faqData = [
    {
      'category': 'Informations générales',
      'questions': [
        'C\'est quoi l\'application KEKE BENIN Driver ?',
        'Quels types de services puis-je effectuer avec l\'application ?',
        'Comment créer un compte Driver sur KEKE BENIN ?',
      ],
    },
    {
      'category': 'Statuts de Conducteur & Contrats',
      'questions': [
        'Quelle est la différence entre "Conducteur Indépendant" et "Conducteur sous contrat" ?',
        'Comment fonctionne le versement journalier pour les véhicules sous contrat ?',
        'Que signifient les couleurs de statut de mon compte ?',
      ],
    },
    {
      'category': 'Support, Incidents & Sécurité',
      'questions': [
        'Que faire si un client ne répond pas ou en cas de problème sur le trajet ?',
      ],
    },
  ];

  final List<Map<String, dynamic>> _ticketsData = [
    {
      'title': 'Objet de la préoccupation',
      'desc':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      'time': 'Aujourd\'hui • 13:02',
      'unread': true,
    },
    {
      'title': 'Objet de la préoccupation',
      'desc':
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore.',
      'time': 'Hier • 22:07',
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.textPrimary,
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildTabs(),
          Expanded(
            child: _selectedTab == 0 ? _buildFaqList() : _buildTicketsList(),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Column(
        children: [
          Text(
            'Support KEKE',
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Vous avez une question ? Nous sommes là pour vous aider.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Rechercher',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textHint,
              size: 20.sp,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Row(
        children: [
          _buildTabItem(0, 'Questions fréquentes', hasIndicator: false),
          SizedBox(width: 12.w),
          _buildTabItem(1, 'Tickets', hasIndicator: true),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String text, {required bool hasIndicator}) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B364A) : AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: isSelected ? null : Border.all(color: AppColors.grey400),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasIndicator)
              Container(
                margin: EdgeInsets.only(right: 8.w),
                width: 6.w,
                height: 6.w,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                ),
              ),
            Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
                fontSize: 13.sp,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: _faqData.length,
      itemBuilder: (context, index) {
        final category = _faqData[index];
        final questions = category['questions'] as List<String>;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16.h, bottom: 8.h),
              child: Text(
                category['category'],
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            ...questions.map((q) => _buildFaqItem(q)),
          ],
        );
      },
    );
  }

  Widget _buildFaqItem(String question) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.grey200)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          question,
          style: TextStyle(fontSize: 13.sp, color: AppColors.textHint),
        ),
        trailing: Icon(Icons.add, color: AppColors.textHint, size: 20.sp),
        onTap: () {
          // Action pour ouvrir la question (ex: BottomSheet ou navigation)
        },
      ),
    );
  }

  Widget _buildTicketsList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemCount: _ticketsData.length,
      itemBuilder: (context, index) {
        final ticket = _ticketsData[index];
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.grey200)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket['title'],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    children: [
                      if (ticket['unread'])
                        Container(
                          margin: EdgeInsets.only(right: 6.w),
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: AppColors.accentGreen,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Text(
                        ticket['time'],
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textPrimary,
                          fontWeight: ticket['unread']
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                ticket['desc'],
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textHint,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButton() {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const ChatScreen(),
            );
          },

          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            elevation: 0,
            minimumSize: Size(double.infinity, 52.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(26.r),
            ),
          ),
          child: Text(
            'Vous avez une autre préoccupation ?',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
