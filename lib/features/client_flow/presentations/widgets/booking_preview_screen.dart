import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/pdf_builder.dart';
import 'package:printing/printing.dart';

class BookingReportPreviewScreen extends StatelessWidget {
  final BookingDetailModel booking;

  const BookingReportPreviewScreen({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: textWidget(text: bookingReport, color: AppColors.whiteColor),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () async {
              final pdf = await BookingReportPdfBuilder().build(booking);
              await Printing.sharePdf(
                bytes: pdf,
                filename: 'booking-report-${booking.id}.pdf',
              );
            },
          ),
        ],
      ),
      body: PdfPreview(
        build: (format) => BookingReportPdfBuilder().build(booking),
        canChangeOrientation: false,
        allowPrinting: false,
        canDebug: false,
        canChangePageFormat: false,
      ),
    );
  }
}
