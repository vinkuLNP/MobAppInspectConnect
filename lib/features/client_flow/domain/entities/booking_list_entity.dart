import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/client_flow/data/models/certificate_subtype_model.dart';

class BookingListEntity {
  final String id;
  final AuthUser? client;
  final List<String> inspectorIds;
  final List<CertificateSubTypeModelData> certificateSubTypes;
  final List<String> images;
  final String description;
  final String bookingDate;
  final String bookingTime;
  final String bookingLocation;
  final int? status;
  final bool? isDeleted;
  final String? createdAt;
  final String? updatedAt;
  final String? inspectorId;
  final String? timerStartedAt;
  final String? timerEndedAt;
  final int? timerDuration;

  const BookingListEntity({
    required this.id,
    this.client,
    this.inspectorIds = const [],
    this.certificateSubTypes = const [],
    this.images = const [],
   required this.description,
   required this.bookingDate,
   required this.bookingTime,
   required this.bookingLocation,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.inspectorId,
    this.timerStartedAt,
    this.timerEndedAt,
    this.timerDuration,
  });

  factory BookingListEntity.fromJson(Map<String, dynamic> json) {
    return BookingListEntity(
      id: json['_id'] ?? '',
      client: json['clientId'] != null
          ? (json['clientId'] is Map
              ? AuthUser.fromJson(json['clientId'])
              : AuthUser(id: json['clientId'].toString()))
          : null,
      inspectorIds: List<String>.from(json['inspectorIds'] ?? []),
      certificateSubTypes: (json['certificateSubTypeId'] as List?)
              ?.map((e) => CertificateSubTypeModelData.fromJson(e))
              .toList() ??
          [],
      images: List<String>.from(json['images'] ?? []),
      description: json['description'],
      bookingDate: json['bookingDate'],
      bookingTime: json['bookingTime'],
      bookingLocation: json['bookingLocation'],
      status: json['status'],
      isDeleted: json['isDeleted'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      inspectorId: json['inspectorId'],
      timerStartedAt: json['timerStartedAt'],
      timerEndedAt: json['timerEndedAt'],
      timerDuration: json['timerDuration'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': client?.toJson(),
      'inspectorIds': inspectorIds,
      'certificateSubTypeId':
          certificateSubTypes.map((e) => e.toJson()).toList(),
      'images': images,
      'description': description,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'bookingLocation': bookingLocation,
      'status': status,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'inspectorId': inspectorId,
      'timerStartedAt': timerStartedAt,
      'timerEndedAt': timerEndedAt,
      'timerDuration': timerDuration,
    };
  }

  BookingListEntity copyWith({
    int? status,
    String? description,
    String? bookingDate,
    String? bookingTime,
    String? bookingLocation,
  }) {
    return BookingListEntity(
      id: id,
      client: client,
      inspectorIds: inspectorIds,
      certificateSubTypes: certificateSubTypes,
      images: images,
      description: description ?? this.description,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      bookingLocation: bookingLocation ?? this.bookingLocation,
      status: status ?? this.status,
      isDeleted: isDeleted,
      createdAt: createdAt,
      updatedAt: updatedAt,
      inspectorId: inspectorId,
      timerStartedAt: timerStartedAt,
      timerEndedAt: timerEndedAt,
      timerDuration: timerDuration,
    );
  }
}
