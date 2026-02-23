import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/helpers/app_common_functions/app_common_functions.dart';
import 'package:inspect_connect/core/utils/helpers/extension_functions/extension_functions.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/paymnet_status_chip.dart';

class PaymentTile extends StatelessWidget {
  final PaymentEntity txn;
  final int index;

  const PaymentTile({super.key, required this.txn, required this.index});

  @override
  Widget build(BuildContext context) {
    final isCredit = txn.isAdded;
    final amountColor = isCredit
        ? AppColors.successColor
        : AppColors.errorColor;
    final backgroundColor = index.isEven ? Colors.white : Colors.grey.shade50;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 250 + (index * 40)),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: txn.iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    txn.transactionIcon,
                    color: txn.iconColor,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget(
                        text: txn.relatedUserId?.name ?? youTxt,
                        maxLine: 1,
                        textOverflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      const SizedBox(height: 6),
                      textWidget(
                        text:
                            "$typeTxt - ${txn.type.replaceAll("_", " ").capitalizeEachWord()}",
                        fontSize: 11,
                      ),
                      const SizedBox(height: 6),
                      textWidget(
                        text: formatDateFlexible(
                          txn.createdAt,
                          dateFormat: dateFormatWithTime,
                        ),
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    textWidget(
                      text:
                          '${isCredit ? '+' : '-'}\$${txn.amount.toStringAsFixed(2)}',
                      color: amountColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                    const SizedBox(height: 6),
                    StatusChip(label: txn.statusLabel, color: txn.statusColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
