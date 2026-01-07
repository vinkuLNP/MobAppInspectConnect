class JurisdictionEntity {
  final String id;
  final String name;
  final String type;
  final int status;
  final String? createdAt;
  final String? updatedAt;
  final String? v;

  JurisdictionEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
}
