import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';

class BookingDetailEntity {
  final String id;
  final ClientInfoEntity client;
  final List<String> inspectorIds;
  final List<CertificateSubTypeEntity> certificateSubTypes;
  final List<String> images;
  final String description;
  final String bookingDate;
  final String bookingTime;
  final String bookingLocation;
  final int status;
  final bool isDeleted;
  final String? timerStartedAt;
  final String? timerEndedAt;
  final int timerDuration;
  final String createdAt;
  final String updatedAt;
  final ClientInfoEntity? inspector;

  BookingDetailEntity({
    required this.id,
    required this.client,
    required this.inspectorIds,
    required this.certificateSubTypes,
    required this.images,
    required this.description,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingLocation,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.timerStartedAt,
    this.timerEndedAt,
    this.timerDuration = 0,
    this.inspector,
  });
}

class ClientInfoEntity {
  final String id;
  final String email;
  final String name;
  final String phoneNumber;
  final String countryCode;

  ClientInfoEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.countryCode,
  });
}

// class CertificateSubTypeEntity {
//   final String id;
//   final String name;
//   final int status;

//   CertificateSubTypeEntity({
//     required this.id,
//     required this.name,
//     required this.status,
//   });
// }
