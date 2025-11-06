
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';

class CertificateInspectorTypeModelData extends CertificateInspectorTypeEntity {
  CertificateInspectorTypeModelData({
    required super.id,
    required super.name,
    required super.status,
    required super. createdAt,
    required super. updatedAt,
    required super. v,

  });

  factory CertificateInspectorTypeModelData.fromJson(Map<String, dynamic> json) {
    return CertificateInspectorTypeModelData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
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
        'createdAt': createdAt,
        'updatedAt': updatedAt,   
        '__v': v,
      };
}
