import 'dart:io';

import 'package:uuid/uuid.dart';

class IccUiDocument {
  final File? localFile;
  final String documentId;
  final String? uploadedUrl;
  final String? iccFileName;

  DateTime? expiryDate;

  IccUiDocument({
    this.localFile,
    this.uploadedUrl,
    this.expiryDate,
    String? documentId,
    this.iccFileName,
  }) : documentId = documentId ?? const Uuid().v4();

  String get fileName {
    if (localFile != null) {
      return localFile!.path.split('/').last;
    }
    return iccFileName.toString();
  }

  bool get isUploaded => uploadedUrl != null;
}
