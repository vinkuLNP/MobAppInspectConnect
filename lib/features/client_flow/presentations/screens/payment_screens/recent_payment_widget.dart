import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/payment_list_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/payment_tile.dart';
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
            SizedBox(
              height: MediaQuery.of(context).size.height / 1.7,
              child: ListView.builder(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: payments.length + 1,
                itemBuilder: (context, index) {
                  if (index < payments.length) {
                    return PaymentTile(txn: payments[index]);
                  } else if (provider.isFetching) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
