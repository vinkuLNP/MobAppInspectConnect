import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/payment_screens/recent_payment_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/payment_screens/wallet_header_widget.dart';

class WalletView extends StatelessWidget {
  final WalletProvider provider;
  final VoidCallback onAddMoney;

  const WalletView({
    super.key,
    required this.provider,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    final wallet = provider.wallet;
    final payments = provider.payments;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        child: Column(
          children: [
            WalletHeaderCard(
              balance: wallet?.available ?? 0,
              pending: wallet?.pending ?? 0,
              onAddMoney: onAddMoney,
            ),
            const SizedBox(height: 24),
            RecentTransactions(
              payments: payments,
              isFetching: provider.isFetching,
            ),
          ],
        ),
      ),
    );
  }
}
