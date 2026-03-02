import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class StripeStatusChip extends StatelessWidget {
  final bool isConnected;

  const StripeStatusChip({super.key, required this.isConnected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isConnected
            ? AppColors.successColor.withValues(alpha: 0.35)
            : AppColors.warningColor.withValues(alpha: 0.35),
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
            text: isConnected ? stripeConnected : notConnected,
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
