import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/wallet_provider.dart';

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
                text: provider.isUserClient
                    ? "Wallet Balance"
                    : "Account Balance",
                color: Colors.white70,
                fontSize: 13,
              ),

              _StripeStatusChip(isConnected: isStripeReady),
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
                _AmountInfo(label: "Available", value: balance),
                const SizedBox(width: 24),
                _AmountInfo(label: "Pending", value: pending, showInfo: true),
              ],
            ),
          ],

          const SizedBox(height: 20),

          Column(
            children: [
              AppButton(
                text: isStripeReady ? "Add Money" : "Connect Stripe",
                isLoading: provider.isConnectingStripe,
                onTap: () {
                  if (!isStripeReady) {
                    provider.startStripeOnboarding(context);
                  } else {
                    onAddMoney();
                  }
                },
                buttonBackgroundColor: Colors.white.withValues(alpha: 0.25),
                textColor: Colors.white,
              ),

              if (provider.canWithdraw && isStripeReady) ...[
                const SizedBox(height: 12),
                AppButton(
                  text: "Withdraw",
                  isLoading: provider.isWithdrawingFromWallet,
                  onTap: () {
                    onWithdraw();
                  },
                  buttonBackgroundColor: Colors.white.withValues(alpha: 0.18),
                  textColor: Colors.white,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _StripeStatusChip extends StatelessWidget {
  final bool isConnected;

  const _StripeStatusChip({required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isConnected
            ? Colors.green.withValues(alpha: 0.35)
            : Colors.orange.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            isConnected ? Icons.check_circle : Icons.warning_amber_rounded,
            size: 14,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          textWidget(
            text: isConnected ? "Connected" : "Not Connected",
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _AmountInfo extends StatelessWidget {
  final String label;
  final double value;
  final bool showInfo;

  const _AmountInfo({
    required this.label,
    required this.value,
    this.showInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            textWidget(text: label, color: Colors.white70, fontSize: 11),

            if (showInfo) ...[
              const SizedBox(width: 4),
              Tooltip(
                message: "Will be released by Stripe within 7–30 days",
                triggerMode: TooltipTriggerMode.tap,
                decoration: BoxDecoration(
                  color: AppColors.authThemeLightColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 12,
                  color: Colors.white60,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 4),
        textWidget(
          text: "\$${value.toStringAsFixed(2)}",
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
