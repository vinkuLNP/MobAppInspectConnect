import 'package:inspect_connect/features/client_flow/domain/entities/booking_mini_entity.dart';

class BookingMiniModel {
  final String id;
  final String description;
  final int status;

  BookingMiniModel({
    required this.id,
    required this.description,
    required this.status,
  });

  factory BookingMiniModel.fromJson(Map<String, dynamic> json) {
    return BookingMiniModel(
      id: json['_id'],
      description: json['description'],
      status: json['status'],
    );
  }

  BookingMiniEntity toEntity() {
    return BookingMiniEntity(id: id, description: description, status: status);
  }
}
