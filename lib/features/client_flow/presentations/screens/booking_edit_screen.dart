import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/booking_form_widget.dart';

class BookingEditScreen extends StatelessWidget {
  final dynamic booking;
  const BookingEditScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Edit Booking',showBackButton: true,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BookingFormWidget(
            isEditing: true,
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
