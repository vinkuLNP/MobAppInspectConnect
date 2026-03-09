import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import '../constants/app_colors.dart';

class ToastService {
  static void success(String message) {
    _show(message, AppColors.successColor, Icons.check_circle, successToastTxt);
  }

  static void error(String message) {
    _show(message, AppColors.errorColor, Icons.error, errorToastTxt);
  }

  static void warning(String message) {
    _show(message, AppColors.warningColor, Icons.warning, warningToastTxt);
  }

  static void info(String message) {
    _show(message, AppColors.infoColor, Icons.info, infoToastTxt);
  }

  static void _show(
    String message,
    Color bgColor,
    IconData icon,
    String title,
  ) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: bgColor,
      colorText: AppColors.whiteColor,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
      borderRadius: 8,
      icon: Icon(icon, color: AppColors.whiteColor),
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOut,
    );
  }
}
