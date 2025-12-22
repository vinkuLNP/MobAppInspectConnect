import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: textWidget(text: 'Logged out', color: Colors.white),
                ),
              );
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

void showRaiseAmountSheet({
  required BuildContext context,
  required Function(int amount) onConfirm,
}) {
  final List<int> amounts = [5, 10, 15, 20, 25];
  int selectedAmount = amounts.first;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Select Raise Amount",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: amounts.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.8,
                  ),
                  itemBuilder: (context, index) {
                    bool isSelected = selectedAmount == amounts[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedAmount = amounts[index]);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isSelected
                              ? AppColors.authThemeColor
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? AppColors.authThemeColor
                                : Colors.grey.shade400,
                          ),
                        ),
                        child: Text(
                          "\$${amounts[index]}",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),

                const Text(
                  "This amount will be added to the booking charge and requires client approval.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.authThemeColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm(selectedAmount);
                        },
                        child: const Text("Confirm & Raise"),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          );
        },
      );
    },
  );
}

Future<void> requestNotificationPermissionIfNeeded() async {
  final messaging = FirebaseMessaging.instance;

  log('🔔 [FCM] Checking notification permission...');

  final settings = await messaging.getNotificationSettings();
  log(
    '🔔 [FCM] Current authorizationStatus: '
    '${settings.authorizationStatus}',
  );

  if (settings.authorizationStatus == AuthorizationStatus.notDetermined) {
    log('🔔 [FCM] Requesting notification permission...');

    final result = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log(
      '🔔 [FCM] Permission request result: '
      '${result.authorizationStatus}',
    );

    if (result.authorizationStatus != AuthorizationStatus.authorized) {
      log('❌ [FCM] User denied notification permission');
      return;
    }
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.denied) {
    log('⚠️ [FCM] Notification permission previously denied');
    return;
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.authorized) {
    log('✅ [FCM] Notification permission already granted');
  } else if (settings.authorizationStatus ==
      AuthorizationStatus.provisional) {
    log('🟡 [FCM] Provisional permission granted (iOS)');
  }

  log('🔔 [FCM] Setting foreground notification presentation options...');

  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  log('✅ [FCM] Foreground presentation options set');

  // 🔥 Token check (VERY IMPORTANT FOR DEBUGGING)
  final token = await messaging.getToken();
  log('🔑 [FCM] FCM token: $token');
}
