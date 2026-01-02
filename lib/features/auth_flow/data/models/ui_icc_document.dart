import 'dart:io';

class IccUiDocument {
  final File? localFile;
  final String? uploadedUrl;
  DateTime? expiryDate;

  IccUiDocument({this.localFile, this.uploadedUrl, this.expiryDate});

  String get fileName {
    if (localFile != null) {
      return localFile!.path.split('/').last;
    }
    return uploadedUrl!.split('/').last;
  }

  bool get isUploaded => uploadedUrl != null;
}
