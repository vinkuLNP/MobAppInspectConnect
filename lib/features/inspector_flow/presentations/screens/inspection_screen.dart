import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/booking_actions_approved.dart';
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
          title: approvedInspectionTxt,
          filterStatuses: [
            bookingStatusAccepted,
            bookingStatusStarted,
            bookingStatusPaused,
            bookingStatusStoppped,
            bookingStatusAwaiting,
          ],
          bookingActionBuilder: (context, booking) {
            return BookingActionResolver.resolve(
              context: context,
              booking: booking,
              provider: provider,
            );
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
