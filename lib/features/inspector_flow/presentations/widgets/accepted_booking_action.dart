import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/show_up_fee_button.dart';

class AcceptedBookingActions extends StatelessWidget {
  final bool canDecline;
  final bool showUpFeeApplied;
  final VoidCallback onToggleFee;
  final VoidCallback onDecline;
  final VoidCallback onStart;

  const AcceptedBookingActions({
    super.key,
    required this.canDecline,
    required this.showUpFeeApplied,
    required this.onToggleFee,
    required this.onDecline,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ShowUpFeeButton(isApplied: showUpFeeApplied, onConfirmTap: onToggleFee),
        const SizedBox(height: 10),
        if (canDecline)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AppButton(
                width: MediaQuery.of(context).size.width / 2.8,
                isBorder: true,
                borderColor: Colors.red,
                buttonBackgroundColor: AppColors.backgroundColor,
                textColor: Colors.red,
                text: declineTxt,
                onTap: onDecline,
              ),
              AppButton(
                width: MediaQuery.of(context).size.width / 2.8,
                text: startTxt,
                onTap: onStart,
              ),
            ],
          )
        else
          AppButton(text: startTxt, onTap: onStart),
      ],
    );
  }
}
