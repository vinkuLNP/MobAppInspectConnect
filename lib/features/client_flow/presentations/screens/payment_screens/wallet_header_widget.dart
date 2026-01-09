import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class WalletHeaderCard extends StatelessWidget {
  final double balance;
  final double pending;
  final VoidCallback onAddMoney;

  const WalletHeaderCard({
    super.key,
    required this.balance,
    required this.pending,
    required this.onAddMoney,
  });

  @override
  Widget build(BuildContext context) {
    return AppCardContainer(
      padding: const EdgeInsets.all(18),
      backgroundColor: AppColors.authThemeColor.withValues(alpha: 0.9),
      shadowColor: AppColors.themeColor.withValues(alpha: 0.2),
      blurRadius: 8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(
            text: "Available Balance",
            color: Colors.white70,
            fontSize: 13,
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
                  text: "Add Money",
                  onTap: onAddMoney,
                  buttonBackgroundColor: AppColors.backgroundColor.withValues(
                    alpha: 0.9,
                  ),
                  textColor: AppColors.authThemeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
