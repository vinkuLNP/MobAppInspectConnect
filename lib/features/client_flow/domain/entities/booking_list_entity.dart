class BookingListEntity {
  final String id;
  final String clientId;
  final List<String> inspectorIds;
  final List<String> certificateSubTypeId;
  final List<String> images;
  final String description;
  final String bookingDate;
  final String bookingTime;
  final String bookingLocation;
  final int status;
  final bool isDeleted;
  final String createdAt;
  final String updatedAt;

  const BookingListEntity({
    required this.id,
    required this.clientId,
    required this.inspectorIds,
    required this.certificateSubTypeId,
    required this.images,
    required this.description,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingLocation,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });
}
