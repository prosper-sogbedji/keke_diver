class UserModel {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String profileImageUrl;
  final String memberSince;
  final double rating;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.profileImageUrl,
    required this.memberSince,
    required this.rating,
    this.isVerified = false,
  });

  String get fullName => '$firstName $lastName';
}
