import '../models/user_model.dart';
import '../models/ride_model.dart';
import '../models/transaction_model.dart';
import '../models/notification_model.dart';

class DummyData {
  static final UserModel currentUser = UserModel(
    id: 'u1',
    firstName: 'François',
    lastName: 'Dupont',
    email: 'francois.dupont@email.com',
    phone: '+229 01 65 58 64 86',
    profileImageUrl: 'https://i.pravatar.cc/100?img=12',
    memberSince: '2024',
    rating: 4.93,
    isVerified: true,
  );

  static final List<RideModel> recentRides = [
    RideModel(
      id: 'r1',
      clientName: 'Codjo Igor Z.',
      clientImageUrl: 'https://i.pravatar.cc/100?img=11',
      pickupLocation: 'Gbegamey, Cotonou',
      dropoffLocation: 'Boulevard Steinmetz, Cotonou',
      date: DateTime.now().subtract(const Duration(minutes: 5)),
      price: 1200,
      distance: 14.08,
      duration: '1h20 min',
      status: RideStatus.ongoing,
    ),
    RideModel(
      id: 'r2',
      clientName: 'Codjo Igor Z.',
      clientImageUrl: 'https://i.pravatar.cc/100?img=11',
      pickupLocation: '9C&M+F3M, Boulevard Steinmetz, Cotonou',
      dropoffLocation: 'Etoile Rouge',
      date: DateTime.now().subtract(const Duration(hours: 2)),
      price: 1200,
      distance: 5.2,
      duration: '15 min',
      status: RideStatus.completed,
    ),
    RideModel(
      id: 'r3',
      clientName: 'Codjo Igor Z.',
      clientImageUrl: 'https://i.pravatar.cc/100?img=11',
      pickupLocation: '9C&M+F3M, Boulevard Steinmetz, Cotonou',
      dropoffLocation: 'Fidjrosse',
      date: DateTime.now().subtract(const Duration(days: 1)),
      price: 1200,
      distance: 8.5,
      duration: '25 min',
      status: RideStatus.cancelled,
    ),
  ];

  static final List<TransactionModel> recentTransactions = [
    TransactionModel(
      id: 't1',
      title: 'Virement bancaire',
      description: 'Terminée • Frais 0 F',
      amount: 12400,
      date: DateTime.now().subtract(const Duration(hours: 1)),
      isCredit: false,
    ),
    TransactionModel(
      id: 't2',
      title: 'Paiement en espèces',
      description: 'Terminée • Trajet n°12345',
      amount: 4500,
      date: DateTime.now().subtract(const Duration(days: 1)),
      isCredit: true,
    ),
    TransactionModel(
      id: 't3',
      title: 'Virement bancaire',
      description: 'Terminée • Frais 0 F',
      amount: 25000,
      date: DateTime.now().subtract(const Duration(days: 2)),
      isCredit: false,
    ),
    TransactionModel(
      id: 't4',
      title: 'Paiement mobile',
      description: 'Terminée • Trajet n°12342',
      amount: 1200,
      date: DateTime.now().subtract(const Duration(days: 3)),
      isCredit: true,
    ),
  ];

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'n1',
      title: 'Paiement reçu',
      message: 'Vous avez reçu un paiement de 1 200 FCFA pour la course N° 77052807.',
      date: DateTime.now().subtract(const Duration(minutes: 10)),
      type: NotificationType.payment,
    ),
    NotificationModel(
      id: 'n2',
      title: 'Nouveau message de support',
      message: 'Votre compte a été vérifié avec succès. Bienvenue sur Keke !',
      date: DateTime.now().subtract(const Duration(days: 1)),
      type: NotificationType.message,
      isRead: true,
    ),
    NotificationModel(
      id: 'n3',
      title: 'Bonus activé',
      message: 'Félicitations ! Vous avez complété 10 courses aujourd\'hui et débloqué un bonus de 2 000 FCFA.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      type: NotificationType.success,
      isRead: true,
    ),
  ];
}
