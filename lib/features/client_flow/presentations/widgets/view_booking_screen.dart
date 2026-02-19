import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';

class ViewBookingDetailsScreen extends StatelessWidget {
  final BookingDetailModel booking;

  final bool isInspectorView;

  const ViewBookingDetailsScreen({
    super.key,
    required this.booking,
    this.isInspectorView = false,
  });

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

            isInspectorView
                ? _payoutInformationSection()
                : _financialInformationSection(),
            isInspectorView
                ? _section(
                    title: "Client Details",
                    child: booking.inspector == null
                        ? _infoRow("Client", "--")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow("Client Name", booking.client.name),
                              _infoRow("Email", booking.client.email),
                              _infoRow(
                                "Phone",
                                "${booking.client.countryCode} ${booking.client.phoneNumber}",
                              ),
                            ],
                          ),
                  )
                : _section(
                    title: "Inspector Details",
                    child: booking.inspector == null
                        ? _infoRow("Inspector", "--")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(
                                "Inspector Name",
                                booking.inspector!.name,
                              ),
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

  Widget _financialInformationSection() {
    return _section(
      title: "Financial Information",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          booking.totalBillingAmount != ""
              ? _infoRow(
                  "Total Billing Amount",
                  _formatMoneyFromDynamic(booking.totalBillingAmount),
                )
              : const SizedBox.shrink(),
          booking.showUpFee != ""
              ? _infoRow(
                  "Show Up Fee",
                  _formatMoneyFromDynamic(booking.showUpFee),
                )
              : const SizedBox.shrink(),
          _infoRow(
            "Platform Fee",
            _formatMoneyFromDynamic(booking.platformFee),
          ),
          _infoRow(
            "Show-Up Fee Applied",
            booking.showUpFeeApplied ? "Yes" : "No",
          ),
          booking.finalRaisedAmount > 0
              ? _infoRow(
                  "Raised Amount Applied",
                  _formatMoneyFromDynamic(booking.finalRaisedAmount),
                )
              : const SizedBox.shrink(),
          _infoRow(
            "Late Cancellation",
            booking.lateCancellation ? "Yes" : "No",
          ),
        ],
      ),
    );
  }

  Widget _payoutInformationSection() {
    final double ratePerHour = _parseToDouble(booking.globalCharge);
    final double minPayout4h = ratePerHour * 4;
    final double maxPayout8h = ratePerHour * 8;

    final String totalPayout =
        (booking.totalPaidToInspector == "" ||
            booking.totalPaidToInspector.toString().isEmpty)
        ? "N/A"
        : _formatMoneyFromDynamic(booking.totalPaidToInspector);

    return _section(
      title: "Payout Information",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow("Payout Rate (per hour)", _formatMoney(ratePerHour)),
          _infoRow("Minimum Payout (4 hours)", _formatMoney(minPayout4h)),
          _infoRow("Maximum Payout (8 hours)", _formatMoney(maxPayout8h)),
          _infoRow("Total Payout Amount after deductions", totalPayout),
        ],
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
    return AppCardContainer(
      borderRadius: 14,
      margin: const EdgeInsets.only(bottom: 18),
      shadowOffset: const Offset(0, 4),
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

  double _parseToDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }

  String _formatMoney(double amount) {
    return "\$$amount";
  }

  String _formatMoneyFromDynamic(dynamic value) {
    final double amount = _parseToDouble(value);
    if (amount == 0) return "\$0.0";
    return _formatMoney(amount);
  }
}
