import 'dart:developer';

import 'package:flutter/material.dart';

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
      case 'paid':
      case 'wallet_credit':
        return true;
      case 'pending':
      case 'wallet_deduct':
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
    switch (type.toLowerCase()) {
      case 'paid':
      case 'wallet_credit':
        return Colors.green;
      case 'succeeded':
      case 'wallet_deduct':
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
    log('---------type. $type');
    log('---------status. $status');

    switch (type.toLowerCase()) {
      case 'paid':
      case 'wallet_credit':
        return 'Added';
      case 'succeeded':
      case 'wallet_deduct':
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


/*
const getStatusColor = (status: string) => {
    switch (status) {
      case "succeeded":
      case "paid":
        return "success";
      case "pending":
      case "processing":
        return "warning";
      case "failed":
      case "action_required":
        return "error";
      default:
        return "default";
    }
  };




   const getTransactionIcon = (type: string, status: string) => {
    if (status === "failed" || status === "action_required")
      return <XCircle size={16} color="#ef4444" />;
    if (status === "pending" || status === "processing")
      return <Clock size={16} color="#f59e0b" />;
    if (status === "succeeded" || status === "paid")
      return <CheckCircle size={16} color="#10b981" />;
    if (type === "charge" || type === "subscription")
      return <TrendingUp size={16} color="#10b981" />;
    if (type === "refund") return <TrendingDown size={16} color="#ef4444" />;
    if (type === "wallet_credit")
      return <BanknoteArrowUp size={16} color="#10b981" />;
    if (type === "payout")
      return <BanknoteArrowDown size={16} color="#ef4444" />;
    if (type === "transfer") return <TrendingUp size={16} color="#3b82f6" />;
    return <DollarSign size={16} color="#6b7280" />;
  };
   {getTransactionIcon(payment.type, payment.status)}
                          <Typography
                            variant="body2"
                            sx={{ textTransform: "capitalize", fontWeight: 500 }}
                          >
                            {payment.type.replace("_", " ")}



                              {payment.stripePayoutId ||
                            payment.stripeTransferId ||
                            payment.stripeChargeId ||
                            payment.eventId ||
                            payment.invoiceNumber ||
                            "N/A"}



                         
*/








