class BookingEntity {
  final String bookingDate;
  final String bookingTime;
  final String bookingLocation;
  final String certificateSubTypeId;
  final List<String> images;
  final List<String> bookingLocationCoordinates;

  final String description;

  const BookingEntity({
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingLocation,
    required this.certificateSubTypeId,
    required this.bookingLocationCoordinates,
    required this.images,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "bookingDate": bookingDate,
      "bookingTime": bookingTime,
      "bookingLocation": bookingLocation,
      "certificateSubTypeId": certificateSubTypeId, 
      "bookingLocationCoordinates":bookingLocationCoordinates,
      "images": images,
      "description": description,
    };
  }
}