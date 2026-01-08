import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';

class ShowUpFeeButton extends StatelessWidget {
  final bool isApplied;
  final VoidCallback onConfirmTap;

  const ShowUpFeeButton({
    super.key,
    required this.isApplied,
    required this.onConfirmTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      buttonBackgroundColor: AppColors.whiteColor,
      textColor: isApplied ? Colors.red : AppColors.authThemeColor,
      isBorder: true,
      borderColor: isApplied ? Colors.red : AppColors.authThemeColor,
      text: isApplied ? cancelFeeTxt : applyShowUpFeeTxt,
      onTap: onConfirmTap,
    );
  }
}
