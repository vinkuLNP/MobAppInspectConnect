import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/user_entity.dart';

class PaymentEntity {
  final String id;
  final UserEntity user;
  final UserEntity? relatedUserId;
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
    switch (type.toLowerCase()) {
      case 'charge':
      case 'wallet_credit':
        return true;
      default:
        return false;
    }
  }

  bool get isDeducted {
    switch (status.toLowerCase()) {
      case 'failed':
      case 'action_required':
      case 'pending':
      case 'wallet_deduct':
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
      case 'succeeded':
      case 'paid':
        return Colors.green;

      case 'pending':
      case 'processing':
        return Colors.orange;

      case 'failed':
        return Colors.red;

      case 'action_required':
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }

  String get statusLabel {
    return status
        .replaceAll('_', ' ')
        .split(' ')
        .map(
          (word) =>
              word.isEmpty ? word : word[0].toUpperCase() + word.substring(1),
        )
        .join(' ');
  }

  IconData get transactionIcon {
    final lowerStatus = status.toLowerCase();
    final lowerType = type.toLowerCase();

    if (lowerStatus == 'failed' || lowerStatus == 'action_required') {
      return Icons.cancel_rounded;
    }

    if (lowerStatus == 'pending' || lowerStatus == 'processing') {
      return Icons.access_time_rounded;
    }

    if (lowerStatus == 'succeeded' || lowerStatus == 'paid') {
      return Icons.check_circle_rounded;
    }

    switch (lowerType) {
      case 'charge':
      case 'subscription':
        return Icons.trending_up;

      case 'refund':
        return Icons.trending_down;

      case 'wallet_credit':
        return Icons.account_balance_wallet;

      case 'payout':
        return Icons.account_balance;

      case 'transfer':
        return Icons.swap_horiz;
      default:
        return Icons.attach_money;
    }
  }

  Color get iconColor {
    final lowerStatus = status.toLowerCase();

    if (lowerStatus == 'failed') return Colors.red;
    if (lowerStatus == 'action_required') return Colors.blue;
    if (lowerStatus == 'pending' || lowerStatus == 'processing') {
      return Colors.orange;
    }
    if (lowerStatus == 'succeeded' || lowerStatus == 'paid') {
      return Colors.green;
    }

    return Colors.grey;
  }
}
