class ServiceAreaDetails {
  String city = '';
  List<String> serviceAreas = [];

  Map<String, dynamic> toJson() => {
        'city': city,
        'serviceAreas': serviceAreas,
      };
}