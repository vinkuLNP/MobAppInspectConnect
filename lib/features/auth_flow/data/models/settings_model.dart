import 'package:inspect_connect/features/auth_flow/domain/entities/settings_entity.dart';

class SettingsDataModel extends SettingEntity {
  SettingsDataModel({
    required super.id,
    required super.type,
    required super.timeInHours,
    required super.maxCities,
    required super.priceOrPercentage,
    required super.status,
    required super.isDeleted,
    super.createdAt,
    super.updatedAt,
    super.v,
  });
  factory SettingsDataModel.fromEntity(SettingEntity entity) {
    return SettingsDataModel(
      id: entity.id,
      type: entity.type,
      timeInHours: entity.timeInHours,
      maxCities: entity.maxCities,
      priceOrPercentage: entity.priceOrPercentage,
      status: entity.status,
      isDeleted: entity.isDeleted,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      v: entity.v,
    );
  }
  factory SettingsDataModel.fromJson(Map<String, dynamic> json) {
    return SettingsDataModel(
      id: json['_id'] ?? '',
      type: json['type'] ?? 0,
      timeInHours: json['timeInHours'] ?? 0,
      maxCities: json['maxCities'] ?? 0,
      priceOrPercentage: json['priceOrPercentage'] ?? 0,
      status: json['status'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'type': type,
    'timeInHours': timeInHours,
    'maxCities': maxCities,
    'priceOrPercentage': priceOrPercentage,
    'status': status,
    'isDeleted': isDeleted,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}
