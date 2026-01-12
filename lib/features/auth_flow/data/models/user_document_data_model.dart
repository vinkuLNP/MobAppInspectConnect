import 'package:inspect_connect/features/auth_flow/domain/entities/user_document_entity.dart';

class UserDocumentDataModel extends UserDocumentEntity {
  UserDocumentDataModel({required super.documentUrl, required super.fileName});

  factory UserDocumentDataModel.fromEntity(UserDocumentEntity entity) {
    return UserDocumentDataModel(
      documentUrl: entity.documentUrl,
      fileName: entity.fileName,
    );
  }
  factory UserDocumentDataModel.fromJson(Map<String, dynamic> json) {
    return UserDocumentDataModel(
      documentUrl: json['documentUrl'] ?? '',
      fileName: json['fileName'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'documentUrl': documentUrl,
    'fileName': fileName,
  };
}
