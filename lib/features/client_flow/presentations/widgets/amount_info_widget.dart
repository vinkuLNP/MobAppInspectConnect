import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class AmountInfo extends StatelessWidget {
  final String label;
  final double value;
  final bool showInfo;

  const AmountInfo({
    super.key,
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
                message: stripeAmountReleaseDate,
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
