class CreateBookingResponseModel {
  final bool success;
  final String message;
  final BookingData body;

  CreateBookingResponseModel({
    required this.success,
    required this.message,
    required this.body,
  });

  factory CreateBookingResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateBookingResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      body: BookingData.fromJson(json['body'] ?? {}),
    );
  }
}

class BookingData {
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
  final int v;

  BookingData({
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
    required this.v,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['_id'] ?? '',
      clientId: json['clientId'] ?? '',
      inspectorIds: List<String>.from(json['inspectorIds'] ?? []),
      certificateSubTypeId: List<String>.from(json['certificateSubTypeId'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      bookingDate: json['bookingDate'] ?? '',
      bookingTime: json['bookingTime'] ?? '',
      bookingLocation: json['bookingLocation'] ?? '',
      status: json['status'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }
}
