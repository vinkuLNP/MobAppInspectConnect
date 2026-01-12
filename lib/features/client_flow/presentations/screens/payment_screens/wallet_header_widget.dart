import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';

class WalletHeaderCard extends StatelessWidget {
  final double balance;
  final double pending;
  final VoidCallback onAddMoney;
  final WalletProvider provider;
  final VoidCallback onWithdraw;
  const WalletHeaderCard({
    super.key,
    required this.provider,
    required this.balance,
    required this.pending,
    required this.onAddMoney,
    required this.onWithdraw,
  });

  @override
  Widget build(BuildContext context) {
    final isStripeReady = provider.isStripeReady;
    return AppCardContainer(
      padding: const EdgeInsets.all(18),
      backgroundColor: AppColors.authThemeColor.withValues(alpha: 0.9),
      shadowColor: AppColors.themeColor.withValues(alpha: 0.2),
      blurRadius: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              textWidget(
                text: availableBalance,
                color: Colors.white70,
                fontSize: 13,
              ),
              const SizedBox(width: 8),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isStripeReady
                      ? Colors.green.withOpacity(0.3)
                      : Colors.orange.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      isStripeReady
                          ? Icons.check_circle
                          : Icons.warning_amber_rounded,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    textWidget(
                      text: isStripeReady ? "Connected" : "Not Connected",
                      color: Colors.white,
                      fontSize: 11,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          textWidget(
            text: "\$${balance.toStringAsFixed(2)}",
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: isStripeReady ? addMoney : "Connect Stripe",
                  // addMoney,
                  isLoading: provider.isConnectingStripe,
                  onTap: () {
                    if (!isStripeReady) {
                      provider.startStripeOnboarding(context);
                      return;
                    }
                    onAddMoney();
                  },
                  buttonBackgroundColor: AppColors.backgroundColor.withValues(
                    alpha: 0.9,
                  ),
                  textColor: AppColors.authThemeColor,
                ),
              ),
              if (provider.canWithdraw) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    text: 'withdrawMoney',
                    onTap: () {
                      if (!isStripeReady) {
                        provider.startStripeOnboarding(context);
                        return;
                      }

                      if ((provider.wallet?.available ?? 0) <= 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Insufficient wallet balance"),
                          ),
                        );
                        return;
                      }

                      onWithdraw();
                    },
                    buttonBackgroundColor: Colors.red.shade600,
                    textColor: Colors.white,
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
