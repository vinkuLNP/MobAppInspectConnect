import 'package:flutter/material.dart';

//   Added => type == 'charge' || status == 'paid';
//   Deducted => type == 'platform_fee' || status == 'succeeded';

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

class UserEntity {
  final String id;
  final String email;
  final String name;

  UserEntity({required this.id, required this.email, required this.name});
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

  bool get isAdded {
    switch (status.toLowerCase()) {
      case 'paid':
        return true;
      case 'pending':
      case 'processing':
      case 'action_required':
      case 'failed':
        return false;
      default:
        return type == 'charge';
    }
  }

  bool get isDeducted {
    switch (status.toLowerCase()) {
      case 'failed':
      case 'action_required':
      case 'pending':
      case 'processing':
        return false;
      case 'succeeded':
        return type == 'platform_fee' || type == 'refund';
      default:
        return false;
    }
  }

  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'succeeded':
        return Colors.red;
      case 'pending':
      case 'processing':
        return Colors.orange;
      case 'action_required':
        return Colors.amber;
      case 'failed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'paid':
        return 'Added';
      case 'succeeded':
        return 'Deducted';
      case 'pending':
        return 'Pending';
      case 'processing':
        return 'Processing';
      case 'action_required':
        return 'Action Required';
      case 'failed':
        return 'Failed';
      default:
        return status.toUpperCase();
    }
  }
}
