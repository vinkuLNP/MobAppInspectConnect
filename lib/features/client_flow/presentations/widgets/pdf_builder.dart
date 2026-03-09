import 'dart:typed_data';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/helpers/app_common_functions/app_common_functions.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class BookingReportPdfBuilder {
  Future<Uint8List> build(BookingDetailModel booking) async {
    final pdf = pw.Document();
    final images = await _loadImages(booking.images);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) => [
          _header(),
          pw.SizedBox(height: 16),
          _clientInfo(booking),
          _inspectorInfo(booking),
          _imagesSection(images),
          _bookingInfo(booking),
          _description(booking),
          _footer(booking),
        ],
      ),
    );

    return pdf.save();
  }

  Future<List<pw.ImageProvider>> _loadImages(List<String> urls) async {
    final list = <pw.ImageProvider>[];
    for (final url in urls) {
      try {
        list.add(await networkImage(url));
      } catch (_) {}
    }
    return list;
  }

  pw.Widget _imagesSection(List<pw.ImageProvider> images) {
    if (images.isEmpty) {
      return _section(inspectionImages, [pw.Text(noImagesTxt)]);
    }

    return _section(
      inspectionImages,
      images
          .map(
            (img) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              height: 150,
              child: pw.Image(img, fit: pw.BoxFit.contain),
            ),
          )
          .toList(),
    );
  }

  pw.Widget _header() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          inspectConnectTitle.toUpperCase(),
          style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(bookingInspectionReport),
        pw.SizedBox(height: 4),
        pw.Text(
          '$generatedOn ${formatDateFlexible(DateTime.now().toString())}',
          style: pw.TextStyle(fontSize: 10),
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  static pw.Widget _clientInfo(BookingDetailModel booking) {
    return _section(clientInformation, [
      _row(clientName, booking.client.name),
      _row(emailLabel, booking.client.email),
      _row(
        phoneTxt,
        '${booking.client.countryCode} ${booking.client.phoneNumber}',
      ),
    ]);
  }

  static pw.Widget _inspectorInfo(BookingDetailModel booking) {
    if (booking.inspector == null) return pw.SizedBox();

    return _section(inspectorInformation, [
      _row(inspectorName, booking.inspector!.name),
      _row(emailLabel, booking.inspector!.email),
      _row(
        phoneTxt,
        '${booking.inspector!.countryCode} ${booking.inspector!.phoneNumber}',
      ),
    ]);
  }

  pw.Widget _bookingInfo(BookingDetailModel booking) {
    return _section(bookingInformation, [
      _row(
        inspectionType,
        booking.certificateSubTypes.firstOrNull?.name ?? '--',
      ),
      _row(bookingDate, formatDateFlexible(booking.bookingDate)),
      _row(bookingTime, booking.bookingTime),
      _row(locationTxt, booking.bookingLocation),
      _row(createdAtLabel, formatDateFlexible(booking.createdAt)),
      _row(updatedAtLabel, formatDateFlexible(booking.updatedAt)),

      _row(inspectionStatus, bookingStatusToText(booking.status)),
    ]);
  }

  static pw.Widget _description(BookingDetailModel booking) {
    return _section(descriptionTxt.toUpperCase(), [
      pw.Text(
        booking.description.isNotEmpty
            ? booking.description
            : noDescriptionProvided,
      ),
    ]);
  }

  static pw.Widget _footer(BookingDetailModel booking) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        children: [
          pw.Divider(),
          pw.Text(reportFooterText, style: pw.TextStyle(fontSize: 10)),
          pw.Text(
            '$reportIdLabel: ${booking.id}',
            style: pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }

  static pw.Widget _section(String title, List<pw.Widget> children) {
    return pw.Container(
      width: double.infinity,
      margin: const pw.EdgeInsets.only(bottom: 16),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            title,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 14),
          ),
          pw.SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  static pw.Widget _row(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          pw.Expanded(child: pw.Text(value, textAlign: pw.TextAlign.right)),
        ],
      ),
    );
  }
}
