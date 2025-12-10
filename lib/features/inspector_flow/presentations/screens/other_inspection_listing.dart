import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/features/inspector_flow/presentations/widgets/common_inspection_listing.dart';

class OtherInspectionsScreen extends StatelessWidget {
  const OtherInspectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseInspectionListScreen(
      title: "Past Inspections",
      showAppBar: true,
      filterStatuses: [
        bookingStatusRejected,
        bookingStatusCompleted,
        bookingStatusCancelledByClient,
        bookingStatusCancelledByInspector,
        bookingStatusExpired,
        // bookingStatusAwaiting,
        // bookingStatusPaused,
        // bookingStatusStoppped,
      ],
    );
  }
}
