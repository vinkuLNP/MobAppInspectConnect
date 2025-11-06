import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_agency_entity.dart';

class CertificateTypeModel extends AgenncyInnerCertificateTypeEntity {
  CertificateTypeModel({
    required super.id,
    required super.name,
  });

  factory CertificateTypeModel.fromJson(Map<String, dynamic> json) {
    return CertificateTypeModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
      };
}

class AgencyModel extends AgencyEntity {
  AgencyModel({
    required super.id,
    required super.name,
    super.certificateType,
    required super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory AgencyModel.fromJson(Map<String, dynamic> json) {
    return AgencyModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      certificateType: json['certificateTypeId'] != null
          ? CertificateTypeModel.fromJson(json['certificateTypeId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'status': status,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'certificateTypeId': certificateType?.toJson(),
      };
}


