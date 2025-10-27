
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';

class CertificateSubTypeModel extends CertificateSubTypeEntity {
  const CertificateSubTypeModel({
    required super.id,
    required super.name,
    required super.certificateTypeName,
  });

  factory CertificateSubTypeModel.fromJson(Map<String, dynamic> json) {
    return CertificateSubTypeModel(
      id: json['_id'],
      name: json['name'],
      certificateTypeName: json['certificateTypeId']['name'],
    );
  }
}
