import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_button.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
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

            if (status == bookingStatusAccepted) {
              return AppButton(
                text: "Start Inspection",
                onTap: () async {
                  await provider.startInspectionTimer(
                    context: context,
                    bookingId: booking.id,
                  );
                },
              );
            }

            if (isStarted || isPaused || isStopped) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (timerDuration != null)
                    Text(
                      "Timer: ${provider.formatDuration(timerDuration)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                      text: "Complete Inspection",
                      buttonBackgroundColor: AppColors.authThemeColor,
                      onTap: () async {
                        await provider.updateBookingStatus(
                          context: context,
                          bookingId: booking.id,
                          newStatus: bookingStatusAwaiting,
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
            color: Colors.black.withOpacity(0.3),
            child: const Center(
              child: CircularProgressIndicator(color: AppColors.authThemeColor),
            ),
          ),
      ],
    );
  }
}
