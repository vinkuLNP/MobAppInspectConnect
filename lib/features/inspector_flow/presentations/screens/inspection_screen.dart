import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_widgets.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/common_inspection_listing.dart';
import 'package:provider/provider.dart';

class ApprovedInspectionsScreen extends StatelessWidget {
  const ApprovedInspectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingProvider>();

    return Stack(
      children: [
        BaseInspectionListScreen(
          title: "Approved Inspections",
          filterStatuses: [
            bookingStatusAccepted,
            bookingStatusStarted,
            bookingStatusPaused,
            bookingStatusStoppped,
            bookingStatusAwaiting,
          ],
          bookingActionBuilder: (context, booking) {
            final status = booking.status;
            final isStarted = status == bookingStatusStarted;
            final isPaused = status == bookingStatusPaused;
            final isStopped = status == bookingStatusStoppped;

            final isRunning = provider.isTimerRunning[booking.id] ?? false;
            final timerDuration = provider.activeTimers[booking.id];
            final bool showUpFeeApplied =
                provider.showUpFeeStatusMap[booking.id] ??
                booking.showUpFeeApplied ??
                false;

            if (status == bookingStatusAccepted) {
              return Column(
                children: [
                  AppButton(
                    width: MediaQuery.of(context).size.width / 1.4,
                    text: showUpFeeApplied
                        ? "Cancel Show-Up Fee"
                        : "Apply Show-Up Fee",
                    buttonBackgroundColor: showUpFeeApplied
                        ? AppColors.darkShadeAuthColor
                        : AppColors.authThemeColor,
                    onTap: () {
                      showConfirmationDialog(
                        context: context,
                        icon: showUpFeeApplied
                            ? Icons.undo
                            : Icons.attach_money,
                        confirmColor: AppColors.authThemeColor,
                        title: showUpFeeApplied
                            ? "Cancel Show-Up Fee"
                            : "Apply Show-Up Fee",
                        message: showUpFeeApplied
                            ? "Do you want to cancel the applied Show-Up Fee?"
                            : "Are you sure you want to apply a Show-Up Fee to this booking?",
                        confirmText: showUpFeeApplied
                            ? "Cancel Fee"
                            : "Apply Fee",
                        onConfirm: () async {
                          Navigator.pop(context);
                          await provider.updateShowUpFeeStatus(
                            context: context,
                            bookingId: booking.id,
                            showUpFeeApplied: !showUpFeeApplied,
                          );
                        },
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AppButton(
                        width: MediaQuery.of(context).size.width / 2.8,
                        isBorder: true,
                        borderColor: Colors.red,
                        textColor: Colors.red,
                        buttonBackgroundColor: AppColors.backgroundColor,
                        text: "Decline Inspection",
                        onTap: () => showConfirmationDialog(
                          context: context,
                          confirmColor: Colors.redAccent,
                          icon: Icons.cancel_outlined,
                          title: "Decline Booking",
                          message:
                              "Are you sure you want to decline this booking request?",
                          confirmText: "Decline",
                          onConfirm: () async {
                       final user = context.read<UserProvider>().user;
                            Navigator.pop(context);
                            await provider.updateBookingStatus(
                              context: context,
                              bookingId: booking.id,
                              newStatus: bookingStatusCancelledByInspector,
                              userId: user!.userId,
                            );
                          },
                        ),
                      ),
                      AppButton(
                        width: MediaQuery.of(context).size.width / 2.8,
                        text: "Start Inspection",
                        onTap: () async {
                          await provider.startInspectionTimer(
                            context: context,
                            bookingId: booking.id,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            }

            if (isStarted || isPaused || isStopped) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (timerDuration != null)
                    textWidget(
                      text: "Timer: ${provider.formatDuration(timerDuration)}",

                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  const SizedBox(height: 10),
                  if (!isStopped)
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: isRunning ? "Pause" : "Resume",
                            buttonBackgroundColor: Colors.orangeAccent,
                            onTap: () async {
                              if (isRunning) {
                                await provider.pauseInspectionTimer(
                                  context: context,
                                  bookingId: booking.id,
                                );
                              } else {
                                await provider.startInspectionTimer(
                                  context: context,
                                  bookingId: booking.id,
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            text: "Stop",
                            buttonBackgroundColor: Colors.redAccent,
                            onTap: () async {
                              await provider.stopInspectionTimer(
                                context: context,
                                bookingId: booking.id,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  if (isStopped)
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            text: showUpFeeApplied
                                ? "Cancel Show-Up Fee"
                                : "Apply Show-Up Fee",
                            buttonBackgroundColor: showUpFeeApplied
                                ? AppColors.darkShadeAuthColor
                                : AppColors.authThemeColor,
                            onTap: () {
                              showConfirmationDialog(
                                context: context,
                                icon: showUpFeeApplied
                                    ? Icons.undo
                                    : Icons.attach_money,
                                confirmColor: AppColors.authThemeColor,
                                title: showUpFeeApplied
                                    ? "Cancel Show-Up Fee"
                                    : "Apply Show-Up Fee",
                                message: showUpFeeApplied
                                    ? "Do you want to cancel the applied Show-Up Fee?"
                                    : "Are you sure you want to apply a Show-Up Fee to this booking?",
                                confirmText: showUpFeeApplied
                                    ? "Cancel Fee"
                                    : "Apply Fee",
                                onConfirm: () async {
                                  Navigator.pop(context);
                                  await provider.updateShowUpFeeStatus(
                                    context: context,
                                    bookingId: booking.id,
                                    showUpFeeApplied: !showUpFeeApplied,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: AppButton(
                            text: "Complete Inspection",
                            buttonBackgroundColor: AppColors.authThemeColor,
                            onTap: () async {
                              final user = context.read<UserProvider>().user;
                              await provider.updateBookingStatus(
                                context: context,
                                bookingId: booking.id,
                                newStatus: bookingStatusAwaiting,
                                userId: user!.userId,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),

        if (provider.isUpdatingBooking)
          Container(
            color: Colors.black.withValues(alpha: 0.3),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.authThemeColor),
            ),
          ),
      ],
    );
  }
}
