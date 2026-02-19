import 'package:inspect_connect/features/auth_flow/data/models/ui_icc_document.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';

class UserApiDocument {
  final String id;
  final CertificateType documentType;
  final String fileUrl;
  final String fileName;
  final DateTime expiryDate;
  final int adminApproval;
  final String? adminNotes;
  final String? serviceCity;

  UserApiDocument({
    required this.id,
    required this.documentType,
    required this.fileUrl,
    required this.fileName,
    required this.expiryDate,
    required this.adminApproval,
    this.adminNotes,
    this.serviceCity,
  });

  factory UserApiDocument.fromJson(Map<String, dynamic> json) {
    return UserApiDocument(
      id: json['_id'],
      documentType: CertificateType.fromJson(json['documentTypeId']),
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      expiryDate: DateTime.parse(json['expiryDate']),
      adminApproval: json['adminApproval'],
      adminNotes: json['adminNotes'],
      serviceCity: json['serviceCity'],
    );
  }
}

extension IccUiMapper on UserApiDocument {
  IccUiDocument toIccUi() {
    return IccUiDocument(
      uploadedUrl: fileUrl,
      expiryDate: expiryDate,
      iccFileName: fileName,
      documentId: id,
    );
  }
}
