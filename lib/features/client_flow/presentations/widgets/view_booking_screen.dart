import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';

class ViewBookingDetailsScreen extends StatelessWidget {
  final BookingDetailModel booking;

  const ViewBookingDetailsScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imageSection(),

            const SizedBox(height: 20),
            _section(
              title: "Inspection Information",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    "Inspection Type",
                    booking.certificateSubTypes.isNotEmpty
                        ? booking.certificateSubTypes.first.name
                        : "--",
                  ),
                  _infoRow("Description", booking.description),
                  _infoRow("Location", booking.bookingLocation),
                ],
              ),
            ),

            _section(
              title: "Booking Schedule",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow("Booking Date", _formatDate(booking.bookingDate)),
                  _infoRow("Time", booking.bookingTime),
                ],
              ),
            ),

            _section(
              title: "Billing & Fees",
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    "Platform Fee",
                    '\$${booking.platformFee.toString()}',
                  ),
                  _infoRow(
                    "Global Charge",
                    '\$${booking.globalCharge.toString()}',
                  ),
                  _infoRow(
                    "Show-Up Fee Applied",
                    booking.showUpFeeApplied ? "Yes" : "No",
                  ),
                  if (booking.showUpFeeApplied)
                    _infoRow("Show-Up Fee", booking.showUpFee.toString()),
                  _infoRow(
                    "Late Cancellation",
                    booking.lateCancellation ? "Yes" : "No",
                  ),
                ],
              ),
            ),

            _section(
              title: "Inspector Details",
              child: booking.inspector == null
                  ? _infoRow("Inspector", "--")
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _infoRow("Inspector Name", booking.inspector!.name),
                        _infoRow("Email", booking.inspector!.email),
                        _infoRow(
                          "Phone",
                          "${booking.inspector!.countryCode} ${booking.inspector!.phoneNumber}",
                        ),
                      ],
                    ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _imageSection() {
    if (booking.images.isEmpty) {
      return Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.grey.shade200,
        ),
        child: Center(
          child: textWidget(
            text: "No Images",
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: CarouselSlider(
        items: booking.images.map((img) {
          return SizedBox(
            width: double.infinity,
            child: Image.network(img, fit: BoxFit.cover),
          );
        }).toList(),
        options: CarouselOptions(
          height: 200,
          enlargeCenterPage: true,
          viewportFraction: 1.0,
          autoPlay: true,
        ),
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(text: title, fontSize: 14, fontWeight: FontWeight.w600),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: textWidget(text: label, fontSize: 12, color: Colors.grey),
          ),
          Expanded(
            flex: 5,
            child: textWidget(
              text: value,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return DateFormat("MMM dd, yyyy").format(d);
    } catch (_) {
      return date;
    }
  }
}
