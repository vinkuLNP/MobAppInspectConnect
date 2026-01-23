class WalletEntity {
  final String id;
  final String userId;
  final double available;
  final double pending;
  final double totalAmount;
  final bool isDeleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  WalletEntity({
    required this.id,
    required this.userId,
    required this.available,
    required this.pending,
    required this.totalAmount,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalBalance => available + pending;

  bool get isActive => !isDeleted;
}
