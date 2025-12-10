class LocationDto {
  final String? type;
  final String? locationName;
  final List<double>? coordinates; 

  LocationDto({this.type, this.locationName, this.coordinates});

  factory LocationDto.fromJson(Map<String, dynamic>? j) => LocationDto(
        type: j?['type'] as String?,
        locationName: j?['locationName'] as String?,
        coordinates: (j?['coordinates'] is List)
            ? (j?['coordinates'] as List)
                .map((e) => (e as num).toDouble())
                .toList()
            : null,
      );
}
