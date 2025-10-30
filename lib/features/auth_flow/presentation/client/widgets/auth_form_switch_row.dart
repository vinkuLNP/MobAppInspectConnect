import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';

class AuthFormSwitchRow extends StatelessWidget {
  final String question;
  final String actionText;
  final VoidCallback onTap;
  final Color? actionColor;
  final double? fontSize;

  const AuthFormSwitchRow({
    super.key,
    required this.question,
    required this.actionText,
    required this.onTap,
    this.actionColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        textWidget(text: question, fontSize: fontSize ?? 14),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: onTap,
          child: textWidget(
            text: actionText,
            fontWeight: FontWeight.w400,
            fontSize: fontSize ?? 14,
            colour: actionColor ?? AppColors.authThemeLightColor,
          ),
        ),
      ],
    );
  }
}
