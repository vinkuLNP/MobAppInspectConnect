import 'package:inspect_connect/features/auth_flow/data/models/ui_icc_document.dart';

class DocumentType {
  final String id;
  final String name;
  final int? status;

  const DocumentType({required this.id, required this.name, this.status});

  factory DocumentType.fromJson(Map<String, dynamic> json) {
    return DocumentType(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'_id': id, 'name': name, 'status': status};
  }
}

class UserDocument {
  final String id;
  final DocumentType? documentType;
  final String? fileUrl;
  final DateTime? expiryDate;
  final int? adminApproval; // 0=pending, 1=approved, 2=rejected
  final String? adminNotes;
  final String? serviceCity;
  final String? fileName;

  const UserDocument({
    required this.id,
    this.documentType,
    this.fileUrl,
    this.expiryDate,
    this.adminApproval,
    this.adminNotes,
    this.fileName,
    this.serviceCity,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) {
    return UserDocument(
      id: json['_id'] ?? '',
      documentType: json['documentTypeId'] != null
          ? DocumentType.fromJson(json['documentTypeId'])
          : null,
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],

      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'])
          : null,
      adminApproval: json['adminApproval'],
      adminNotes: json['adminNotes'],
      serviceCity: json['serviceCity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'documentTypeId': documentType?.toJson(),
      'fileUrl': fileUrl,
      'fileName': fileName,

      'expiryDate': expiryDate?.toIso8601String(),
      'adminApproval': adminApproval,
      'adminNotes': adminNotes,
      'serviceCity': serviceCity,
    };
  }

  bool get isRejected => adminApproval == 2;
  bool get isPending => adminApproval == 0;
  bool get isApproved => adminApproval == 1;
}

extension IccUiMapper on UserDocument {
  IccUiDocument toIccUi() {
    return IccUiDocument(
      uploadedUrl: fileUrl,
      expiryDate: expiryDate,
      iccFileName: fileName,
      documentId: id,
    );
  }
}

extension UserDocumentsX on List<UserDocument>? {
  UserDocument? firstByType(String type) {
    if (this == null) return null;
    for (final d in this!) {
      if (d.documentType!.name == type) return d;
    }
    return null;
  }

  List<UserDocument> allByType(String type) {
    if (this == null) return [];
    return this!.where((d) => d.documentType!.name == type).toList();
  }
}
