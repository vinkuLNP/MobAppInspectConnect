import 'package:inspect_connect/features/auth_flow/domain/entities/jurisdiction_entity.dart';

class JurisdictionDataModel extends JurisdictionEntity {
  JurisdictionDataModel({
    required super.id,
    required super.name,
    required super.status,
    required super.type,
    required super.createdAt,
    required super.updatedAt,
    required super.v,
  });

  factory JurisdictionDataModel.fromJson(Map<String, dynamic> json) {
    return JurisdictionDataModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
      type: json['type'] ?? "city",
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'type': type,
    'status': status,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}
