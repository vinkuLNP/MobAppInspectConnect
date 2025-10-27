class BookingEntity {
  final String bookingDate;
  final String bookingTime;
  final String bookingLocation;
  final String certificateSubTypeId;
  final List<String> images;
  final String description;

  const BookingEntity({
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingLocation,
    required this.certificateSubTypeId,
    required this.images,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      "bookingDate": bookingDate,
      "bookingTime": bookingTime,
      "bookingLocation": bookingLocation,
      "certificateSubTypeId": [certificateSubTypeId], 
      "images": images,
      "description": description,
    };
  }
}