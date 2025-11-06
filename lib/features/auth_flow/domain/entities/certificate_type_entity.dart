class CertificateInspectorTypeEntity {
  final String id;
  final String name;
  final int status;
  final String? createdAt;
  final String? updatedAt;
  final String? v;


  CertificateInspectorTypeEntity({
    required this.id,
    required this.name,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.v
  });
}
