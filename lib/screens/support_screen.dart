import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/app_colors.dart';
import 'chat_screen.dart';
import 'create_ticket_screen.dart';

// ─── Modèles de données ───────────────────────────────────────────────────────

class _FaqItem {
  final String question;
  final String answer;
  bool isExpanded = false;

  _FaqItem({
    required this.question,
    required this.answer,
  });
}

class _FaqCategory {
  final String title;
  final List<_FaqItem> items;

  const _FaqCategory({
    required this.title,
    required this.items,
  });
}

class _TicketItem {
  final String title;
  final String lastMessage;
  final String time;
  final bool hasUnread;

  const _TicketItem({
    required this.title,
    required this.lastMessage,
    required this.time,
    required this.hasUnread,
  });
}

// ─── Données FAQ ──────────────────────────────────────────────────────────────

final List<_FaqCategory> _allFaqCategories = [
  _FaqCategory(
    title: 'Informations générales',
    items: [
      _FaqItem(
        question: 'C\'est quoi l\'application KEKE BENIN Driver ?',
        answer:
            'C\'est l\'application dédiée aux chauffeurs et livreurs partenaires (moto, voiture, tricycle) qui permet de recevoir des courses ou livraisons, suivre ses revenus et gérer sa disponibilité.',
      ),
      _FaqItem(
        question: 'Quels types de services puis-je effectuer avec l\'application ?',
        answer:
            'Transport de personnes (moto, voiture, tricycle) et/ou livraison (repas, colis, produits). Vous choisissez d\'activer un seul service ou les deux en même temps.',
      ),
      _FaqItem(
        question: 'Comment créer un compte Driver sur KEKE BENIN ?',
        answer:
            'Téléchargez l\'application, renseignez vos informations personnelles et celles de votre véhicule, puis soumettez les documents demandés. Votre compte est activé après validation par l\'équipe KEKE BENIN.',
      ),
    ],
  ),
  _FaqCategory(
    title: 'Statuts de Conducteur & Contrats',
    items: [
      _FaqItem(
        question:
            'Quelle est la différence entre "Conducteur Indépendant" et "Conducteur sous contrat" ?',
        answer:
            'Le conducteur indépendant utilise son propre véhicule et active/désactive librement sa disponibilité. Le conducteur sous contrat utilise un véhicule appartenant à l\'entreprise, signe un contrat, et paie un montant journalier pour l\'utiliser ; il perçoit un revenu sur chaque course.',
      ),
      _FaqItem(
        question:
            'Comment fonctionne le versement journalier pour les véhicules sous contrat ?',
        answer:
            'Le paiement se fait directement dans l\'app (Mobile Money ou portefeuille interne). Une alerte arrive 24h avant l\'échéance, puis une alerte finale. En cas de non-paiement, le véhicule est désactivé à distance. Un reçu est disponible après chaque versement.',
      ),
      _FaqItem(
        question: 'Que signifient les couleurs de statut de mon compte ?',
        answer:
            'Vert = compte en règle. Orange = plusieurs avertissements, comportement à surveiller. Rouge = trop d\'avertissements ou de retards, le compte/contrat peut être résilié à la moindre infraction.',
      ),
      _FaqItem(
        question: 'Comment consulter mon contrat et son échéance ?',
        answer:
            'Dans la rubrique « Contrat & Véhicule », vous voyez le document signé, la date de début/fin, le montant déjà payé, le montant restant et le statut (actif, suspendu, résilié). Une notification arrive 7 jours avant expiration, avec possibilité de renouveler directement depuis l\'app.',
      ),
    ],
  ),
  _FaqCategory(
    title: 'Paiements & Revenus',
    items: [
      _FaqItem(
        question: 'Comment retirer mes gains ?',
        answer:
            'Dans la rubrique « Revenus », consultez votre solde disponible et faites une demande de retrait vers Mobile Money (MTN ou Moov).',
      ),
      _FaqItem(
        question: 'Où voir le détail de mes gains par course ou livraison ?',
        answer:
            'Votre tableau de bord affiche vos revenus du jour, de la semaine et du mois, avec le détail par course/livraison et l\'historique complet des paiements.',
      ),
    ],
  ),
  _FaqCategory(
    title: 'Support, Incidents & Sécurité',
    items: [
      _FaqItem(
        question:
            'Que faire si un client ne répond pas ou en cas de problème sur le trajet ?',
        answer:
            'Contactez le client par appel ou message depuis l\'app. Si le problème persiste, utilisez « Signaler un problème » pendant la course/livraison.',
      ),
      _FaqItem(
        question: 'Comment contacter le service client ?',
        answer:
            'Depuis la page Support, appuyez sur « Vous avez une autre préoccupation ? » pour ouvrir un ticket, ou consultez l\'historique de vos tickets déjà envoyés.',
      ),
      _FaqItem(
        question:
            'Que faire en cas d\'accident ou d\'incident grave pendant une course ?',
        answer:
            'Utilisez le bouton « Signaler un incident » pour alerter immédiatement l\'équipe support, qui vous recontactera pour la suite à donner.',
      ),
    ],
  ),
];

// ─── Données tickets ──────────────────────────────────────────────────────────

final List<_TicketItem> _ticketData = [
  _TicketItem(
    title: 'Paiement non reçu',
    lastMessage:
        'Bonjour ! Nous avons bien reçu votre demande et allons revenir vers vous rapidement.',
    time: "Aujourd'hui • 13:02",
    hasUnread: true,
  ),
  _TicketItem(
    title: 'Problème de connexion',
    lastMessage:
        'Votre problème a bien été pris en charge. Un agent vous contactera sous 24h.',
    time: 'Hier • 22:07',
    hasUnread: false,
  ),
];

// ─── Support Screen ───────────────────────────────────────────────────────────

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int _selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late List<_FaqCategory> _faqCategories;

  @override
  void initState() {
    super.initState();
    _faqCategories = _allFaqCategories
        .map(
          (cat) => _FaqCategory(
            title: cat.title,
            items: cat.items
                .map((item) =>
                    _FaqItem(question: item.question, answer: item.answer))
                .toList(),
          ),
        )
        .toList();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_FaqCategory> get _filteredCategories {
    if (_searchQuery.isEmpty) return _faqCategories;

    return _faqCategories
        .map((cat) {
          final matchingItems = cat.items.where((item) {
            return item.question.toLowerCase().contains(_searchQuery) ||
                item.answer.toLowerCase().contains(_searchQuery);
          }).toList();
          if (matchingItems.isEmpty) return null;
          return _FaqCategory(title: cat.title, items: matchingItems);
        })
        .whereType<_FaqCategory>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Header sous l'AppBar
          _buildHeader(),
          // Barre de recherche
          _buildSearchBar(),
          SizedBox(height: 20.h),
          // Onglets
          _buildTabs(),
          SizedBox(height: 4.h),
          // Contenu principal
          Expanded(
            child: _selectedTab == 0
                ? _buildFaqContent()
                : _buildTicketsContent(),
          ),
          // Bouton bas
          _buildBottomButton(),
        ],
      ),
    );
  }

  // ─── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 22.sp,
        ),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
          SizedBox(height: 6.h),
          Text(
            'Vous avez une question ? Nous sommes là pour vous aider.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textHint,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  // ─── Barre de recherche ────────────────────────────────────────────────────

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.grey50,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: AppColors.grey200),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: 'Rechercher',
            hintStyle: TextStyle(color: AppColors.textHint, fontSize: 14.sp),
            prefixIcon: Icon(
              Icons.search,
              color: AppColors.textHint,
              size: 20.sp,
            ),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.close, size: 18.sp, color: AppColors.textHint),
                    onPressed: () => _searchController.clear(),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
          ),
        ),
      ),
    );
  }

  // ─── Onglets ───────────────────────────────────────────────────────────────

  Widget _buildTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          _buildTabItem(0, 'Questions fréquentes', showDot: false),
          SizedBox(width: 10.w),
          _buildTabItem(1, 'Tickets', showDot: true),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String label, {required bool showDot}) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2B364A) : AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
          border: isSelected
              ? null
              : Border.all(color: AppColors.grey400, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showDot) ...[
              Container(
                width: 7.w,
                height: 7.w,
                decoration: BoxDecoration(
                  color: AppColors.accentGreen,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 6.w),
            ],
            Text(
              label,
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

  // ─── FAQ ──────────────────────────────────────────────────────────────────

  Widget _buildFaqContent() {
    final categories = _filteredCategories;

    if (categories.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded, size: 48.sp, color: AppColors.grey400),
              SizedBox(height: 16.h),
              Text(
                'Aucun résultat pour\n"$_searchQuery"',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
      itemCount: categories.length,
      itemBuilder: (context, catIndex) {
        return _buildCategorySection(categories[catIndex]);
      },
    );
  }

  Widget _buildCategorySection(_FaqCategory category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Titre de la catégorie
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 0),
          child: Text(
            category.title,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 4.h),
        // Questions en liste plate avec séparateurs
        ...category.items.map(
          (item) => _FaqAccordionItem(
            item: item,
            searchQuery: _searchQuery,
          ),
        ),
      ],
    );
  }

  // ─── TICKETS ──────────────────────────────────────────────────────────────

  Widget _buildTicketsContent() {
    if (_ticketData.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline_rounded,
                  size: 48.sp, color: AppColors.grey400),
              SizedBox(height: 16.h),
              Text(
                'Aucun ticket ouvert',
                style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
      itemCount: _ticketData.length,
      itemBuilder: (context, index) {
        final ticket = _ticketData[index];
        return _buildTicketCard(ticket);
      },
    );
  }

  Widget _buildTicketCard(_TicketItem ticket) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(title: ticket.title),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icône drapeau
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: ticket.hasUnread
                    ? AppColors.primaryBlue.withValues(alpha: 0.12)
                    : AppColors.grey50,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.flag_rounded,
                size: 22.sp,
                color: ticket.hasUnread
                    ? AppColors.primaryBlue
                    : AppColors.grey400,
              ),
            ),
            SizedBox(width: 14.w),
            // Contenu
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          ticket.title,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      // Heure + point vert si non lu
                      Row(
                        children: [
                          if (ticket.hasUnread) ...[
                            Container(
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: AppColors.accentGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 4.w),
                          ],
                          Text(
                            ticket.time,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: ticket.hasUnread
                                  ? AppColors.textPrimary
                                  : AppColors.textHint,
                              fontWeight: ticket.hasUnread
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18.sp,
                            color: AppColors.textHint,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    ticket.lastMessage,
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
            ),
          ],
        ),
      ),
    );
  }


  // ─── Bouton bas ───────────────────────────────────────────────────────────

  Widget _buildBottomButton() {
    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateTicketScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(26.r),
              ),
            ),
            child: Text(
              'Vous avez une autre préoccupation ?',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Widget Accordion FAQ ─────────────────────────────────────────────────────

class _FaqAccordionItem extends StatefulWidget {
  final _FaqItem item;
  final String searchQuery;

  const _FaqAccordionItem({
    required this.item,
    required this.searchQuery,
  });

  @override
  State<_FaqAccordionItem> createState() => _FaqAccordionItemState();
}

class _FaqAccordionItemState extends State<_FaqAccordionItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.item.isExpanded;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    if (_isExpanded) _controller.value = 1.0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
      widget.item.isExpanded = _isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grey200),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ligne question
          InkWell(
            onTap: _toggle,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: _buildHighlightedText(
                      widget.item.question,
                      widget.searchQuery,
                      TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.textHint,
                        height: 1.4,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Icône + / -
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) {
                      return Icon(
                        _isExpanded ? Icons.remove : Icons.add,
                        size: 20.sp,
                        color: AppColors.textHint,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Réponse animée
          SizeTransition(
            sizeFactor: _expandAnimation,
            child: Padding(
              padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
              child: Text(
                widget.item.answer,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Mise en surbrillance des mots-clés de recherche
  Widget _buildHighlightedText(String text, String query, TextStyle style) {
    if (query.isEmpty) {
      return Text(text, style: style);
    }

    final lowerText = text.toLowerCase();
    final List<TextSpan> spans = [];
    int start = 0;

    while (true) {
      final index = lowerText.indexOf(query, start);
      if (index == -1) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
        text: text.substring(index, index + query.length),
        style: style.copyWith(
          backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.15),
          color: AppColors.primaryBlue,
          fontWeight: FontWeight.w700,
        ),
      ));
      start = index + query.length;
    }

    return Text.rich(TextSpan(children: spans, style: style));
  }
}
