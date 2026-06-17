class TransactionModel {
  final String id;
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final bool isCredit;

  TransactionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.isCredit,
  });
}
