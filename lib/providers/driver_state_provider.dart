import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../models/ride_model.dart';
import '../models/transaction_model.dart';
import '../models/notification_model.dart';
import '../data/dummy_data.dart';

// User Provider
final userProvider = Provider<UserModel>((ref) {
  return DummyData.currentUser;
});

// Driver State Providers
final isDriverActiveProvider = StateProvider<bool>((ref) => false);
final selectedServiceProvider = StateProvider<String>((ref) => 'Les deux');

// Rides Provider
final recentRidesProvider = Provider<List<RideModel>>((ref) {
  return DummyData.recentRides;
});

// Transactions Provider
final recentTransactionsProvider = Provider<List<TransactionModel>>((ref) {
  return DummyData.recentTransactions;
});

// Wallet Balance Provider
final walletBalanceProvider = Provider<double>((ref) {
  return 0.0; // Initially 0 FCFA in the mockup
});

// Notifications Provider
final notificationsProvider = Provider<List<NotificationModel>>((ref) {
  return DummyData.notifications;
});
