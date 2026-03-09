import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_common_card_container.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/helpers/app_common_functions/app_common_functions.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/booking_preview_screen.dart';
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
              title: inspectionInfo,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    inspectionType,
                    booking.certificateSubTypes.isNotEmpty
                        ? booking.certificateSubTypes.first.name
                        : "--",
                  ),
                  _infoRow(descriptionTxt, booking.description),
                  _infoRow(locationTxt, booking.bookingLocation),
                  _infoRow(
                    inspectionStatus,
                    bookingStatusToText(booking.status),
                  ),
                ],
              ),
            ),

            _section(
              title: bookingSchedule,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow(
                    bookingDate,
                    formatDateFlexible(booking.bookingDate),
                  ),
                  _infoRow(bookingTime, booking.bookingTime),
                ],
              ),
            ),

            isInspectorView
                ? _payoutInformationSection()
                : _financialInformationSection(),
            isInspectorView
                ? _section(
                    title: clientDetails,
                    child: booking.inspector == null
                        ? _infoRow(clientTxt, "--")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(clientName, booking.client.name),
                              _infoRow(emailLabel, booking.client.email),
                              _infoRow(
                                phoneTxt,
                                "${booking.client.countryCode} ${booking.client.phoneNumber}",
                              ),
                            ],
                          ),
                  )
                : _section(
                    title: inspectorDetails,
                    child: booking.inspector == null
                        ? _infoRow(inspectorTxt, "--")
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _infoRow(inspectorName, booking.inspector!.name),
                              _infoRow(emailLabel, booking.inspector!.email),
                              _infoRow(
                                phoneTxt,
                                "${booking.inspector!.countryCode} ${booking.inspector!.phoneNumber}",
                              ),
                            ],
                          ),
                  ),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.picture_as_pdf),
              label: textWidget(text: viewReport, color: AppColors.whiteColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        BookingReportPreviewScreen(booking: booking),
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _financialInformationSection() {
    return _section(
      title: financialInfo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          booking.totalBillingAmount != ""
              ? _infoRow(
                  totalBillingAmount,
                  formatMoneyFromDynamic(booking.totalBillingAmount),
                )
              : const SizedBox.shrink(),
          booking.showUpFee != ""
              ? _infoRow(
                  showUpFeeTxt,
                  formatMoneyFromDynamic(booking.showUpFee),
                )
              : const SizedBox.shrink(),
          _infoRow(platformFeeTxt, formatMoneyFromDynamic(booking.platformFee)),
          _infoRow(
            showUpFeeAppliedTxt,
            booking.showUpFeeApplied ? yesTxt : noTxt,
          ),
          booking.finalRaisedAmount > 0
              ? _infoRow(
                  raisedAmountTxt,
                  formatMoneyFromDynamic(booking.finalRaisedAmount),
                )
              : const SizedBox.shrink(),
          _infoRow(
            lateCancellationTxt,
            booking.lateCancellation ? yesTxt : noTxt,
          ),
        ],
      ),
    );
  }

  Widget _payoutInformationSection() {
    final double ratePerHour = parseToDouble(booking.globalCharge);
    final double minPayout4h = ratePerHour * 4;
    final double maxPayout8h = ratePerHour * 8;

    final String totalPayout =
        (booking.totalPaidToInspector == "" ||
            booking.totalPaidToInspector.toString().isEmpty)
        ? notAvailableTxt
        : formatMoneyFromDynamic(booking.totalPaidToInspector);

    return _section(
      title: payoutInfo,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow(payoutRatePerHour, formatMoney(ratePerHour)),
          _infoRow(minPayout4hTxt, formatMoney(minPayout4h)),
          _infoRow(maxPayout8hTxt, formatMoney(maxPayout8h)),
          _infoRow(totalPayoutTxt, totalPayout),
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
            text: noImagesTxt,
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
}
