import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/payment_screens/recent_payment_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/screens/payment_screens/wallet_header_widget.dart';

class WalletView extends StatelessWidget {
  final WalletProvider provider;
  final VoidCallback onAddMoney;
  final VoidCallback onWithdraw;

  const WalletView({
    super.key,
    required this.provider,
    required this.onAddMoney,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    final wallet = provider.wallet;
    final payments = provider.payments;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      children: [
        WalletHeaderCard(
          balance: wallet?.available ?? 0,
          totalAmount: wallet?.totalAmount ?? 0,
          pending: wallet?.pending ?? 0,
          onAddMoney: onAddMoney,
          provider: provider,
          onWithdraw: onWithdraw,
        ),
        const SizedBox(height: 24),
        RecentTransactions(payments: payments, isFetching: provider.isFetching),
        const SizedBox(height: 80),
      ],
    );
  }
}
