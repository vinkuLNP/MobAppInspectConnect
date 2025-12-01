import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:provider/provider.dart';

void showConfirmationDialog({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmText,
  required Color confirmColor,
  required IconData icon,
  required VoidCallback onConfirm,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: confirmColor, size: 50),
            const SizedBox(height: 16),
            textWidget(text: title, fontSize: 20, fontWeight: FontWeight.w700),
            const SizedBox(height: 10),
            textWidget(
              text: message,
              alignment: TextAlign.center,
              fontSize: 15,
              color: Colors.grey[700]!,
              height: 1.4,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    onTap: () => Navigator.pop(context),
                    buttonBackgroundColor: AppColors.authThemeColor,
                    isBorder: true,
                    borderColor: AppColors.authThemeColor,
                    textColor: AppColors.authThemeColor,
                    text: "Cancel",
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppButton(
                    onTap: onConfirm,
                    buttonBackgroundColor: confirmColor,
                    text: confirmText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

void logOutUser(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: textWidget(text: 'log OUT?'),
      content: textWidget(text: 'Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: textWidget(text: 'Cancel'),
        ),
        AppButton(
          width: 120,
          onTap: () async {
            await context.read<UserProvider>().clearUser();
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: textWidget(text: 'Logged out',color: Colors.white)));
              context.router.replaceAll([const OnBoardingRoute()]);
            }
          },
          buttonBackgroundColor: Colors.redAccent,
          textColor: AppColors.backgroundColor,
          text: 'log Out',
        ),
      ],
    ),
  );
}
