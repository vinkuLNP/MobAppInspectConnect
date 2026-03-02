import 'package:inspect_connect/features/client_flow/data/models/payment_user_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';

class PaymentModel extends PaymentEntity {
  PaymentModel({
    required super.id,
    required super.user,
    super.relatedUserId,
    super.bookingId,
    super.stripeInvoiceId,
    super.stripeSubscriptionId,
    required super.amount,
    required super.currency,
    required super.status,
    required super.billingReason,
    required super.eventId,
    required super.type,
    super.source,
    super.processedAt,
    super.createdAt,
    super.updatedAt,
    super.invoiceJson,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['_id'] ?? '',
      user: UserModel.fromJson(json['userId'] ?? {}),
      relatedUserId:
          json['relatedUserId'] != null &&
              json['relatedUserId'] is Map<String, dynamic>
          ? UserModel.fromJson(json['relatedUserId'])
          : null,

      bookingId: json['bookingId'],
      stripeInvoiceId: json['stripeInvoiceId'],
      stripeSubscriptionId: json['stripeSubscriptionId'],
      amount: (json['amount'] ?? 0).toDouble(),
      currency: json['currency'] ?? '',
      status: json['status'] ?? '',
      billingReason: json['billingReason'] ?? '',
      eventId: json['eventId'] ?? '',
      type: json['type'] ?? '',
      source: json['source'],
      processedAt: json['processedAt'] != null
          ? DateTime.parse(json['processedAt'])
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'userId': (user as UserModel).toJson(),
    'relatedUserId': relatedUserId != null
        ? (relatedUserId as UserModel).toJson()
        : null,
    'bookingId': bookingId,
    'stripeInvoiceId': stripeInvoiceId,
    'stripeSubscriptionId': stripeSubscriptionId,
    'amount': amount,
    'currency': currency,
    'status': status,
    'billingReason': billingReason,
    'eventId': eventId,
    'type': type,
    'source': source,
    'processedAt': processedAt?.toIso8601String(),
    'createdAt': createdAt?.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
    'invoiceJson': invoiceJson,
  };
}
