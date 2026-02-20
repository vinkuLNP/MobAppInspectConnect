import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String url;

  const PDFViewerScreen({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return SfPdfViewer.network(url);
  }
}
