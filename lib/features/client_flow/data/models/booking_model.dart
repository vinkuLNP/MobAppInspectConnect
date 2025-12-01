import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/client_flow/data/models/certificate_subtype_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_list_entity.dart';

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

class BookingData extends BookingListEntity {
  final AuthUser? clientUser;
  final AuthUser? inspector;

  const BookingData({
    required super.id,
    this.clientUser,
    this.inspector,
    super.inspectorIds = const [],
    super.certificateSubTypes = const [],
    super.images = const [],
    required super.description,
    required super.bookingDate,
    required super.bookingTime,
    required super.bookingLocation,
    super.status,
    super.isDeleted,
    super.createdAt,
    super.updatedAt,
    super.timerStartedAt,
    super.timerEndedAt,
    super.timerDuration,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    final rawSubTypes = json['certificateSubTypeId'] ?? [];
    final parsedSubTypes = <CertificateSubTypeModelData>[];

    if (rawSubTypes is List) {
      for (final item in rawSubTypes) {
        if (item is String) {
          parsedSubTypes.add(
            CertificateSubTypeModelData(
              id: item,
              name: '',
              status: 0,
              certificateTypeName: '',
            ),
          );
        } else if (item is Map<String, dynamic>) {
          parsedSubTypes.add(CertificateSubTypeModelData.fromJson(item));
        }
      }
    }

    return BookingData(
      id: json['_id'] ?? '',
      clientUser: json['clientId'] is Map<String, dynamic>
          ? AuthUser.fromJson(json['clientId'])
          : (json['clientId'] != null
              ? AuthUser(id: json['clientId'].toString(),emailHashed: json['email'],
      name: json['name'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],)
              : null),
      inspector: json['inspectorId'] is Map<String, dynamic>
          ? AuthUser.fromJson(json['inspectorId'])
          : (json['inspectorId'] != null
              ? AuthUser(id: json['inspectorId'].toString())
              : null),
      inspectorIds: List<String>.from(json['inspectorIds'] ?? []),
      certificateSubTypes: parsedSubTypes,
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      bookingDate: json['bookingDate'] ?? '',
      bookingTime: json['bookingTime'] ?? '',
      bookingLocation: json['bookingLocation'] ?? '',
      status: json['status'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      timerStartedAt: json['timerStartedAt'],
      timerEndedAt: json['timerEndedAt'],
      timerDuration: json['timerDuration'],
    );
  }


}
