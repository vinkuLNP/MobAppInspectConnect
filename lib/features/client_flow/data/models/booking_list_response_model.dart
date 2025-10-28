
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';

class BookingListModel extends BookingListEntity {
  const BookingListModel({
    required super.id,
    required super.clientId,
    required super.inspectorIds,
    required super.certificateSubTypeId,
    required super.images,
    required super.description,
    required super.bookingDate,
    required super.bookingTime,
    required super.bookingLocation,
    required super.status,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookingListModel.fromJson(Map<String, dynamic> json) {
    return BookingListModel(
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
    );
  }
}
