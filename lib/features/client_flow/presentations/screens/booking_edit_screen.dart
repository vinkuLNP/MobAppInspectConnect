import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/booking_form_widget.dart';

class BookingEditScreen extends StatelessWidget {
  final dynamic booking;
  final bool isEdiatble,isReadOnly;
  const BookingEditScreen({
    super.key,
    required this.booking,
    required this.isEdiatble,
    required this.isReadOnly,

  });

  @override
  Widget build(BuildContext context) {
    log('called');
    return Scaffold(
      backgroundColor:  Colors.grey[100],
      appBar:  CommonAppBar(title:isReadOnly ? 'View Booking' : 'Edit Booking', showBackButton: true,showLogo: false,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BookingFormWidget(
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
