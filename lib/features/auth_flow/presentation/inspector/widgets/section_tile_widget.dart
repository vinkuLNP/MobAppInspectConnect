import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class AppSection extends StatelessWidget {
  final String title;
  final Widget? child;
  final FontWeight fontWeight;
  final double fontSize;
  final double spacing;
  final bool error;
  final String errorMessage;

  const AppSection({
    super.key,
    required this.title,
    this.child,
    this.fontWeight = FontWeight.w500,
    this.fontSize = 14,
    this.spacing = 8,
    this.error = false,
    this.errorMessage = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textWidget(text: title, fontWeight: fontWeight, fontSize: fontSize),
        SizedBox(height: spacing),
        if (child != null) ...[child!, SizedBox(height: spacing)],
        if (error)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: textWidget(
              text: errorMessage,
              color: Colors.red,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
