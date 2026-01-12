import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

class ServiceArea {
  final String id;
  final UserLocation location;
  final String countryCode;
  final String stateCode;
  final String cityName;

  const ServiceArea({
    required this.id,
    required this.location,
    required this.countryCode,
    required this.stateCode,
    required this.cityName,
  });

  factory ServiceArea.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];

    return ServiceArea(
      id: json['_id'] ?? '',
      countryCode: json['countryCode'] ?? '',
      stateCode: json['stateCode'] ?? '',
      cityName: json['cityName'] ?? '',
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
      'location': {
        'type': 'Point',
        'coordinates': [location.lng, location.lat],
      },
    };
  }
}
