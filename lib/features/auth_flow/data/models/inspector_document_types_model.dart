import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_documents_type.dart';

class InspectorDocumentTypesDataModel extends InspectorDocumentsTypeEntity {
  InspectorDocumentTypesDataModel({
    required super.id,
    required super.name,
    required super.status,
    required super.createdAt,
    required super.isDeleted,
    required super.updatedAt,
    required super.v,
  });

  factory InspectorDocumentTypesDataModel.fromJson(Map<String, dynamic> json) {
    return InspectorDocumentTypesDataModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      isDeleted: json['isDeleted'] ?? false,
      status: json['status'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'status': status,
    'isDeleted': isDeleted,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}
