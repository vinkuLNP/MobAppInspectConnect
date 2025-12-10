
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';

class CertificateSubTypeModelData extends CertificateSubTypeEntity {
  CertificateSubTypeModelData({
    required super.id,
    required super.name,
    required super.status,
    required super.certificateTypeName,
  });

  factory CertificateSubTypeModelData.fromJson(Map<String, dynamic> json) {
    return CertificateSubTypeModelData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
      certificateTypeName: json['certificateTypeId'] is Map
          ? json['certificateTypeId']['name'] ?? ''
          : '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'status': status,
        'certificateTypeName': certificateTypeName,
      };
}
