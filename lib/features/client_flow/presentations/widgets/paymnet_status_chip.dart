import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class StatusChip extends StatelessWidget {
  final String label;
  final Color color;

  const StatusChip({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: textWidget(
        text: label,
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
