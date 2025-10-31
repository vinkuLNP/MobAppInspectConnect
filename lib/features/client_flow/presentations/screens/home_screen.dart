import 'package:flutter/material.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/common_app_bar.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/booking_form_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: const CommonAppBar(title: 'Book Inspection'),
      body: const SafeArea(
        
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: BookingFormWidget(isEditing: false),
        ),
      ),
    );
  }
}