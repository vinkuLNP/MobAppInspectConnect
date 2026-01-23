import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/payment_tile.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecentTransactions extends StatefulWidget {
  final List<PaymentEntity> payments;
  final bool isFetching;

  const RecentTransactions({
    super.key,
    required this.payments,
    required this.isFetching,
  });

  @override
  State<RecentTransactions> createState() => RecentTransactionsState();
}

class RecentTransactionsState extends State<RecentTransactions> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final provider = context.read<WalletProvider>();
      if (!provider.isFetching) {
        provider.loadMorePayments(context);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WalletProvider>();
    final payments = provider.payments;
    String? lastGroup;

    return AppCardContainer(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 8),
      borderRadius: 22,
      shadowColor: Colors.black.withValues(alpha: 0.05),
      blurRadius: 10,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            text: recentTransactions,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          const SizedBox(height: 12),
          if (payments.isEmpty && !provider.isFetching)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: textWidget(text: noTransactionsYet, color: Colors.grey),
              ),
            )
          else
            ListView.builder(
              controller: _scrollController,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 4, bottom: 8),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: payments.length + 1,
              itemBuilder: (context, index) {
                if (index >= payments.length) {
                  return provider.isFetching
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }

                final txn = payments[index];
                final date = txn.createdAt?.toLocal();
                final label = date != null ? groupLabel(date) : null;

                final showHeader = label != null && label != lastGroup;
                lastGroup = label;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (showHeader)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(4, 16, 4, 8),
                        child: Text(
                          label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    PaymentTile(txn: txn, index: index),
                  
                  ],
                );
              },
            ),
         
        ],
      ),
    );
  }
}

bool isToday(DateTime date) {
  final now = DateTime.now();
  return date.year == now.year &&
      date.month == now.month &&
      date.day == now.day;
}

bool isYesterday(DateTime date) {
  final yesterday = DateTime.now().subtract(const Duration(days: 1));
  return date.year == yesterday.year &&
      date.month == yesterday.month &&
      date.day == yesterday.day;
}

String groupLabel(DateTime date) {
  if (isToday(date)) return 'Today';
  if (isYesterday(date)) return 'Yesterday';
  return DateFormat('dd MMM yyyy').format(date);
}
