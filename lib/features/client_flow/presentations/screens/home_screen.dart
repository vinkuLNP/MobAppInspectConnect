import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/booking_form_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: BookingFormWidget(isEditing: false),
      ),
    );
  }
}
