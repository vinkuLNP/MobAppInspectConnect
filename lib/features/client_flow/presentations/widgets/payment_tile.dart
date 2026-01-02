import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';

class PaymentTile extends StatelessWidget {
  final PaymentEntity txn;
  const PaymentTile({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    final isCredit = txn.isAdded;
    final color = isCredit ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isCredit ? Icons.south_west : Icons.north_east,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textWidget(
                  text: isCredit ? "Deposit" : "Withdrawal",
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                const SizedBox(height: 2),
                textWidget(
                  text: txn.createdAt != null
                      ? "${txn.createdAt!.day}/${txn.createdAt!.month}/${txn.createdAt!.year}"
                      : "N/A",
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
          textWidget(
            text: "${isCredit ? '+' : '-'}\$${txn.amount.toStringAsFixed(2)}",
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ],
      ),
    );
  }
}
