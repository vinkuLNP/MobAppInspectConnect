import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

class ServiceArea {
  final String id;
  final UserLocation location;
  final String countryCode;
  final String stateCode;
  final String cityName;
  final String zipCode;

  const ServiceArea({
    required this.id,
    required this.location,
    required this.countryCode,
    required this.stateCode,
    required this.cityName,
    required this.zipCode,
  });

  factory ServiceArea.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];

    return ServiceArea(
      id: json['_id'] ?? '',
      countryCode: json['countryCode'] ?? '',
      stateCode: json['stateCode'] ?? '',
      cityName: json['cityName'] ?? '',
      zipCode: json['zipCode'] ?? '',

      location: UserLocation(
        name: json['cityName'] ?? '',
        lat: (loc?['coordinates']?[1] ?? 0).toDouble(),
        lng: (loc?['coordinates']?[0] ?? 0).toDouble(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'countryCode': countryCode,
      'stateCode': stateCode,
      'cityName': cityName,
      'zipCode': zipCode,
      'location': {
        'type': 'Point',
        'coordinates': [location.lng, location.lat],
      },
    };
  }
}

extension ServiceAreaMapper on ServiceArea {
  ServiceAreaLocalEntity toLocal() {
    return ServiceAreaLocalEntity(
      countryCode: countryCode,
      stateCode: stateCode,
      cityName: cityName,
      zipCode: zipCode,
      locationType: 'Point',
      latitude: location.lat,
      longitude: location.lng,
    );
  }
}
