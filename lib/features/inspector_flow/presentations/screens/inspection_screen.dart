import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_widgets.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/user_provider.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/common_inspection_listing.dart';
import 'package:intl/intl.dart';
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
              final now = DateTime.now();
              final bookingTime = bookingDateTime(booking);
              final diffHours = bookingTime.difference(now).inMinutes / 60;
              final bool canDecline = diffHours > 8;

              if (canDecline) {
                return Column(
                  children: [
                    TextButton(
                      onPressed: () {
                        showConfirmationDialog(
                          context: context,
                          icon: showUpFeeApplied
                              ? Icons.undo
                              : Icons.attach_money,
                          confirmColor: AppColors.authThemeColor,
                          title: showUpFeeApplied
                              ? "Cancel Fee"
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
                      child: textWidget(
                        text: showUpFeeApplied
                            ? "Cancel Fee"
                            : "Apply Show-Up Fee",
                        color: showUpFeeApplied
                            ? AppColors.darkShadeAuthColor
                            : AppColors.authThemeColor,
                      ),
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
                          text: "Decline",
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
                          text: "Start",
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
              } else {
                return Column(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () {
                        showConfirmationDialog(
                          context: context,
                          icon: showUpFeeApplied
                              ? Icons.undo
                              : Icons.attach_money,
                          confirmColor: AppColors.authThemeColor,
                          title: showUpFeeApplied
                              ? "Cancel Fee"
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
                      child: textWidget(
                        text: showUpFeeApplied
                            ? "Cancel Fee"
                            : "Apply Show-Up Fee",
                        color: showUpFeeApplied
                            ? AppColors.darkShadeAuthColor
                            : AppColors.authThemeColor,
                      ),
                    ),

                    AppButton(
                      text: "Start",
                      onTap: () async {
                        await provider.startInspectionTimer(
                          context: context,
                          bookingId: booking.id,
                        );
                      },
                    ),
                  ],
                );
              }
            }

            if (isStarted || isPaused || isStopped) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (timerDuration != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textWidget(
                          text:
                              "Timer: ${provider.formatDuration(timerDuration)}",

                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        TextButton(
                          onPressed: () {
                            showConfirmationDialog(
                              context: context,
                              icon: showUpFeeApplied
                                  ? Icons.undo
                                  : Icons.attach_money,
                              confirmColor: AppColors.authThemeColor,
                              title: showUpFeeApplied
                                  ? "Cancel Fee"
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
                          child: textWidget(
                            text: showUpFeeApplied
                                ? "Cancel Fee"
                                : "Apply Show-Up Fee",
                            color: showUpFeeApplied
                                ? AppColors.darkShadeAuthColor
                                : AppColors.authThemeColor,
                          ),
                        ),
                      ],
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
                    AppButton(
                      text: "Complete",
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
}
