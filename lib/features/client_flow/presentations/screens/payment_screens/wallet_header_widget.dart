import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/amount_info_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/stripe_status_chip.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/wallet_action_button.dart';

class WalletHeaderCard extends StatelessWidget {
  final double balance;
  final double totalAmount;

  final double pending;
  final VoidCallback onAddMoney;
  final WalletProvider provider;
  final VoidCallback onWithdraw;

  const WalletHeaderCard({
    super.key,
    required this.provider,
    required this.balance,
    required this.pending,
    required this.totalAmount,
    required this.onAddMoney,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    final isStripeReady = provider.isStripeReady;
    final canUserWithdraw = provider.canWithdraw && isStripeReady;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.authThemeColor, AppColors.darkShadeAuthColor],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.authThemeColor.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textWidget(
                text: provider.isUserClient ? walletBalance : accountBalance,
                color: Colors.white70,
                fontSize: 13,
              ),

              StripeStatusChip(isConnected: isStripeReady),
            ],
          ),

          const SizedBox(height: 10),

          textWidget(
            text:
                "\$${provider.isUserClient ? balance.toStringAsFixed(2) : totalAmount.toStringAsFixed(2)}",
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),

          if (!provider.isUserClient) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                AmountInfo(label: available, value: balance),
                const SizedBox(width: 24),
                AmountInfo(
                  label: pendingLabelTxt,
                  value: pending,
                  showInfo: true,
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: WalletActionButton(
                  text: isStripeReady ? addMoney : connectStripe,
                  icon: isStripeReady ? Icons.add : Icons.link,
                  isLoading: provider.isConnectingStripe,
                  enabled: true,
                  onTap: () {
                    if (!isStripeReady) {
                      provider.startStripeOnboarding(context);
                    } else {
                      onAddMoney();
                    }
                  },
                ),
              ),
              if (isStripeReady) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: WalletActionButton(
                    text: withdraw,
                    icon: Icons.arrow_upward_rounded,
                    isLoading: provider.isWithdrawingFromWallet,
                    enabled: canUserWithdraw,
                    onTap: onWithdraw,
                    disabledMessage: withdrawMsg,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
