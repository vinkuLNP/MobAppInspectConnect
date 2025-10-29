// class PaymentsBodyEntity {
//   final List<PaymentEntity> payments;

//   PaymentsBodyEntity({required this.payments});
// }

// class PaymentEntity {
//   final String id;
//   final UserEntity user;
//   final String? relatedUserId;
//   final String? bookingId;
//   final String? stripeInvoiceId;
//   final String? stripeSubscriptionId;
//   final double amount;
//   final String currency;
//   final String status;
//   final String billingReason;
//   final String eventId;
//   final String type;
//   final String? source;
//   final DateTime? processedAt;
//   final DateTime? createdAt;
//   final DateTime? updatedAt;
//   final Map<String, dynamic>? invoiceJson;

//   PaymentEntity({
//     required this.id,
//     required this.user,
//     this.relatedUserId,
//     this.bookingId,
//     this.stripeInvoiceId,
//     this.stripeSubscriptionId,
//     required this.amount,
//     required this.currency,
//     required this.status,
//     required this.billingReason,
//     required this.eventId,
//     required this.type,
//     this.source,
//     this.processedAt,
//     this.createdAt,
//     this.updatedAt,
//     this.invoiceJson,
//   });

//   bool get isAdded => type == 'charge' || status == 'paid';
//   bool get isDeducted => type == 'platform_fee' || status == 'succeeded';
// }

// class UserEntity {
//   final String id;
//   final String email;
//   final String name;

//   UserEntity({
//     required this.id,
//     required this.email,
//     required this.name,
//   });
// }

class PaymentsBodyEntity {
  final List<PaymentEntity> payments;
  final int totalCount;
  final int totalPages;
  final int currentPage;
  final int perPageLimit;

  PaymentsBodyEntity({
    required this.payments,
    required this.totalCount,
    required this.totalPages,
    required this.currentPage,
    required this.perPageLimit,
  });
}

class PaymentEntity {
  final String id;
  final UserEntity user;
  final String? relatedUserId;
  final String? bookingId;
  final String? stripeInvoiceId;
  final String? stripeSubscriptionId;
  final double amount;
  final String currency;
  final String status;
  final String billingReason;
  final String eventId;
  final String type;
  final String? source;
  final DateTime? processedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? invoiceJson;

  PaymentEntity({
    required this.id,
    required this.user,
    this.relatedUserId,
    this.bookingId,
    this.stripeInvoiceId,
    this.stripeSubscriptionId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.billingReason,
    required this.eventId,
    required this.type,
    this.source,
    this.processedAt,
    this.createdAt,
    this.updatedAt,
    this.invoiceJson,
  });

  bool get isAdded => type == 'charge' || status == 'paid';
  bool get isDeducted => type == 'platform_fee' || status == 'succeeded';
}

class UserEntity {
  final String id;
  final String email;
  final String name;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
  });
}
