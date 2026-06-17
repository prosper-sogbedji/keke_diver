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
final selectedVehicleIndexProvider = StateProvider<int>((ref) => 0);
final selectedServiceProvider = StateProvider<String>((ref) => 'Les deux');

// Rides Provider
final recentRidesProvider = Provider<List<RideModel>>((ref) {
  return DummyData.recentRides;
});

// Active Ride Provider (nullable if no active ride)
final activeRideProvider = Provider<RideModel?>((ref) {
  final rides = ref.watch(recentRidesProvider);
  try {
    return rides.firstWhere((ride) => ride.status == RideStatus.ongoing);
  } catch (e) {
    return null;
  }
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
