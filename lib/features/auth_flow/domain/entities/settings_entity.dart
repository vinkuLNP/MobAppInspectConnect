class SettingEntity {
  final String id;
  final int type;
  final int timeInHours;
  final int maxCities;
  final int priceOrPercentage;
  final int status;
  final bool isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  SettingEntity({
    required this.id,
    required this.type,
    required this.timeInHours,
    required this.maxCities,
    required this.priceOrPercentage,
    required this.status,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.v,
  });
}
