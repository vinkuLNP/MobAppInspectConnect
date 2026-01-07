class InspectorDocumentsTypeEntity {
  final String id;
  final String name;
  final bool? isDeleted;
  final int status;
  final String? createdAt;
  final String? updatedAt;
  final String? v;

  InspectorDocumentsTypeEntity({
    required this.id,
    required this.name,
    this.isDeleted = false,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
}
