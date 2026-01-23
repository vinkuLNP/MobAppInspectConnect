import 'dart:convert';

import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';

class PaymentsBodyModel extends PaymentsBodyEntity {
  PaymentsBodyModel({
    required super.payments,
    required super.totalCount,
    required super.totalPages,
    required super.currentPage,
    required super.perPageLimit,
  });

  factory PaymentsBodyModel.fromJson(Map<String, dynamic> json) {
    return PaymentsBodyModel(
      payments: (json['payments'] as List? ?? [])
          .map((e) => PaymentModel.fromJson(e))
          .toList(),
      totalCount: json['totalCount'] ?? 0,
      totalPages: json['totalPages'] ?? 0,
      currentPage: json['currentPage'] ?? 0,
      perPageLimit: json['perPageLimit'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'payments': payments.map((e) => (e as PaymentModel).toJson()).toList(),
    'totalCount': totalCount,
    'totalPages': totalPages,
    'currentPage': currentPage,
    'perPageLimit': perPageLimit,
  };
}

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

class UserModel extends UserEntity {
  UserModel({required super.id, required super.email, required super.name});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'_id': id, 'email': email, 'name': name};
}

PaymentsBodyModel paymentsResponseFromJson(String str) =>
    PaymentsBodyModel.fromJson(json.decode(str));

String paymentsResponseToJson(PaymentsBodyModel data) =>
    json.encode(data.toJson());
