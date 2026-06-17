enum RideStatus { ongoing, completed, cancelled }

class RideModel {
  final String id;
  final String clientName;
  final String clientImageUrl;
  final String pickupLocation;
  final String dropoffLocation;
  final DateTime date;
  final double price;
  final double distance;
  final String duration;
  final RideStatus status;

  RideModel({
    required this.id,
    required this.clientName,
    required this.clientImageUrl,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.date,
    required this.price,
    required this.distance,
    required this.duration,
    required this.status,
  });
}
