class AgenncyInnerCertificateTypeEntity {
  final String id;
  final String name;

  AgenncyInnerCertificateTypeEntity({
    required this.id,
    required this.name,
  });
    Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
    };
  }
}

class AgencyEntity {
  final String id;
  final String name;
  final AgenncyInnerCertificateTypeEntity? certificateType;
  final int status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AgencyEntity({
    required this.id,
    required this.name,
    this.certificateType,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });
}
