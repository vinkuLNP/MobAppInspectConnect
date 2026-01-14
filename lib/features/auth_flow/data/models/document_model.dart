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

  const UserDocument({
    required this.id,
    this.documentType,
    this.fileUrl,
    this.expiryDate,
    this.adminApproval,
    this.adminNotes,
    this.serviceCity,
  });

  factory UserDocument.fromJson(Map<String, dynamic> json) {
    return UserDocument(
      id: json['_id'] ?? '',
      documentType: json['documentTypeId'] != null
          ? DocumentType.fromJson(json['documentTypeId'])
          : null,
      fileUrl: json['fileUrl'],
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
