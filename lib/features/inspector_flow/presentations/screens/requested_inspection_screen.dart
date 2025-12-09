import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/di/app_sockets/app_socket.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_widgets.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/common_inspection_listing.dart';
import 'package:provider/provider.dart';

class RequestedInspectionScreen extends StatelessWidget {
  const RequestedInspectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseInspectionListScreen(
      title: "Pending Inspections",
      filterStatuses: [bookingStatusPending],
      bookingActionBuilder: (context, booking) {
        final provider = context.read<BookingProvider>();

        return Column(
          children: [
            AppButton(
              width: MediaQuery.of(context).size.width / 1.4,
              text: 'Raise Amount',
              icon: Icon(
                Icons.monetization_on,
                color: AppColors.backgroundColor,
              ),
              showIcon: true,
              iconLeftMargin: 10,
              buttonBackgroundColor: AppColors.authThemeColor,
              onTap: () {
                showRaiseAmountSheet(
                  context: context,
                  onConfirm: (amount) async {
                    final socket = locator<SocketService>();
                    final user = context.read<UserProvider>().user;
                    log(amount.toString());
                    socket.sendRaiseInspectionRequest({
                      "bookingId": booking.id,
                      "raisedAmount": amount,
                      "agreedToRaise": 0,
                      "inspectorId": user!.userId,
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: "Accept",
                    icon: Icon(
                      Icons.thumb_up,
                      color: AppColors.backgroundColor,
                    ),
                    showIcon: true,
                    iconLeftMargin: 10,
                    onTap: () => showConfirmationDialog(
                      context: context,
                      title: "Accept Booking",
                      message:
                          "Are you sure you want to accept this booking request?",
                      confirmText: "Accept",
                      confirmColor: AppColors.authThemeColor,
                      icon: Icons.check_circle_outline,
                      onConfirm: () async {
                        Navigator.pop(context);
                        await provider.updateBookingStatus(
                          context: context,
                          bookingId: booking.id,
                          newStatus: bookingStatusAccepted,
                        );
                                final socket = locator<SocketService>();
                        socket.leaveBookingRoom(booking.id);

                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppButton(
                    icon: Icon(
                      Icons.thumb_down,
                      color: AppColors.authThemeColor,
                    ),
                    showIcon: true,
                    iconLeftMargin: 10,

                    text: "Reject",
                    onTap: () => showConfirmationDialog(
                      context: context,
                      title: "Reject Booking",
                      message: "Do you want to reject this booking request?",
                      confirmText: "Reject",
                      confirmColor: Colors.redAccent,
                      icon: Icons.cancel_outlined,
                      onConfirm: () async {
                        Navigator.pop(context);
                        await provider.updateBookingStatus(
                          context: context,
                          bookingId: booking.id,
                          newStatus: bookingStatusRejected,
                        );
                               final socket = locator<SocketService>();
                        socket.leaveBookingRoom(booking.id);
                      },
                    ),
                    buttonBackgroundColor: AppColors.backgroundColor,
                    textColor: AppColors.authThemeColor,
                    borderColor: AppColors.authThemeColor,
                    isBorder: true,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
