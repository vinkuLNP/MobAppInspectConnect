class CertificateInspectorTypeModelData {
  final String id;
  final String name;
  final int status;
  final String createdAt;
  final String updatedAt;
  final String v;

  CertificateInspectorTypeModelData({
    required this.id,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CertificateInspectorTypeModelData.fromJson(
    Map<String, dynamic> json,
  ) {
    return CertificateInspectorTypeModelData(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      status: json['status'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v']?.toString() ?? '',
    );
  }

  // CertificateInspectorTypeEntity toEntity() {
  //   return CertificateInspectorTypeEntity(
  //     id: id,
  //     name: name,
  //     status: status,
  //     createdAt: createdAt,
  //     updatedAt: updatedAt,
  //     v: v,
  //   );
  // }
}
