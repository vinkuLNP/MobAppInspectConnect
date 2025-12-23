import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/booking_form_widget.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/view_booking_screen.dart';

class BookingEditScreen extends StatelessWidget {
  final dynamic booking;
  final bool isEdiatble, isReadOnly;
  final bool isInspectorView;
  const BookingEditScreen({
    super.key,
    required this.booking,
    required this.isEdiatble,
    required this.isReadOnly,
    this.isInspectorView = false,
  });

  @override
  Widget build(BuildContext context) {
    log('called');
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CommonAppBar(
        title: isReadOnly ? 'View Booking' : 'Edit Booking',
        showBackButton: true,
        showLogo: false,
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: isReadOnly
              ? ViewBookingDetailsScreen(
                  booking: booking,
                  isInspectorView: isInspectorView,
                )
              : BookingFormWidget(
                  isEditing: true,
                  isReadOnly: isReadOnly,
                  initialBooking: booking,
                  onSubmitSuccess: () {
                    Navigator.pop(context);
                  },
                ),
        ),
      ),
    );
  }
}
