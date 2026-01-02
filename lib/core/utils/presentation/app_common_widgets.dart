import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/auto_router_setup/auto_router.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:intl/intl.dart';
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
                    text: cancelTxt,
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
      title: textWidget(text: logOutTxt),
      content: textWidget(text: logOutMsgTxt),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: textWidget(text: cancelTxt),
        ),
        AppButton(
          width: 120,
          onTap: () async {
            await context.read<UserProvider>().clearUser();
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: textWidget(text: loggedOutTxt, color: Colors.white),
                ),
              );
              context.router.replaceAll([const OnBoardingRoute()]);
            }
          },
          buttonBackgroundColor: Colors.redAccent,
          textColor: AppColors.backgroundColor,
          text: logOutTxt,
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
                textWidget(
                  text: slctRaiseAmtTxt,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                        child: textWidget(
                          text: "\$${amounts[index]}",
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),

                textWidget(
                  text: slctRaiseAmtMsgTxt,
                  alignment: TextAlign.center,
                  fontSize: 13,
                  color: Colors.grey,
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        onTap: () => Navigator.pop(context),
                        text: cancelTxt,
                        buttonBackgroundColor: AppColors.backgroundColor,
                        borderColor: Colors.red,
                        isBorder: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppButton(
                        onTap: () {
                          Navigator.pop(context);
                          onConfirm(selectedAmount);
                        },
                        text: cnfrmRaiseTxt,
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

Future<bool> validateFileSize(File file, BuildContext context) async {
  if (await file.length() <= 2 * 1024 * 1024) return true;

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: textWidget(
          text: fileMstBeUnder2Txt,
          color: AppColors.backgroundColor,
        ),
      ),
    );
  }
  return false;
}

void showError(BuildContext context, String message) {
  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: textWidget(text: message, color: AppColors.backgroundColor),
    ),
  );
}

void showShowUpFeeDialog({
  required BuildContext context,
  required bool isApplied,
  required VoidCallback onConfirm,
}) {
  showConfirmationDialog(
    context: context,
    icon: isApplied ? Icons.undo : Icons.attach_money,
    confirmColor: AppColors.authThemeColor,
    title: isApplied ? cancelFeeTxt : applyShowUpFeeTxt,
    message: isApplied ? cnclShowUpFeeMsgTxt : applyShowUpFeeMsgTxt,
    confirmText: isApplied ? cancelFeeTxt : applyShowUpFeeTxt,
    onConfirm: onConfirm,
  );
}

DateTime bookingDateTime(BookingListEntity booking) {
  final date = DateTime.parse(booking.bookingDate);
  final t = booking.bookingTime.trim().toUpperCase().replaceAll('.', '');
  try {
    DateTime time;
    if (t.contains('AM') || t.contains('PM')) {
      time = DateFormat('h:mm a').parse(t);
    } else {
      time = DateFormat('HH:mm').parse(t);
    }
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  } catch (_) {
    return DateTime(date.year, date.month, date.day, 10, 0);
  }
}
