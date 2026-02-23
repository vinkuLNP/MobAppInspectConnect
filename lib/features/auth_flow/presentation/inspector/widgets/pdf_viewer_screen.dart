import 'dart:io';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFViewerScreen extends StatelessWidget {
  final String path;
  final bool isNetwork;

  const PDFViewerScreen({
    super.key,
    required this.path,
    required this.isNetwork,
  });

  @override
  Widget build(BuildContext context) {
    return isNetwork ? SfPdfViewer.network(path) : SfPdfViewer.file(File(path));
  }
}
