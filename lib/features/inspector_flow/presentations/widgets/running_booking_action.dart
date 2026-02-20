import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class RunningBookingActions extends StatelessWidget {
  final bool isRunning;
  final bool isStopped;
  final bool showUpFeeApplied;
  final String timerText;
  final VoidCallback onToggleFee;
  final VoidCallback onPauseResume;
  final VoidCallback onStop;
  final VoidCallback onComplete;

  const RunningBookingActions({
    super.key,
    required this.isRunning,
    required this.isStopped,
    required this.showUpFeeApplied,
    required this.timerText,
    required this.onToggleFee,
    required this.onPauseResume,
    required this.onStop,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            textWidget(
              text: "$timerTxt: $timerText",
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (!isStopped)
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: isRunning ? pauseTxt : resumeTxt,
                  buttonBackgroundColor: Colors.orangeAccent,
                  onTap: onPauseResume,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  text: stopTxt,
                  buttonBackgroundColor: Colors.redAccent,
                  onTap: onStop,
                ),
              ),
            ],
          ),
        if (isStopped) ...[
          const SizedBox(height: 8),
          AppButton(text: workDoneTxt, onTap: onComplete),
        ],
      ],
    );
  }
}
