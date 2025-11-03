import 'package:inspect_connect/features/client_flow/data/models/certificate_subtype_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/certificate_sub_type_entity.dart';

import '../../domain/entities/booking_detail_entity.dart';

class BookingDetailModel extends BookingDetailEntity {
  BookingDetailModel({
    required super.id,
    required super.client,
    required super.inspectorIds,
    required super.certificateSubTypes,
    required super.images,
    required super.description,
    required super.bookingDate,
    required super.bookingTime,
    required super.bookingLocation,
    required super.status,
    required super.isDeleted,
    required super.createdAt,
    required super.updatedAt,
    super.timerStartedAt,
    super.timerEndedAt,
    super.timerDuration,
    super.inspector,
  });

  factory BookingDetailModel.fromJson(Map<String, dynamic> json) {
    return BookingDetailModel(
      id: json['_id'] ?? '',
      client: ClientInfoModel.fromJson(json['clientId'] ?? {}),
      inspectorIds: List<String>.from(json['inspectorIds'] ?? []),
      certificateSubTypes: (json['certificateSubTypeId'] as List?)
              ?.map((e) => CertificateSubTypeModelData.fromJson(e))
              .toList() ??
          [],
      images: List<String>.from(json['images'] ?? []),
      description: json['description'] ?? '',
      bookingDate: json['bookingDate'] ?? '',
      bookingTime: json['bookingTime'] ?? '',
      bookingLocation: json['bookingLocation'] ?? '',
      status: json['status'] ?? 0,
      isDeleted: json['isDeleted'] ?? false,
      timerStartedAt: json['timerStartedAt'],
      timerEndedAt: json['timerEndedAt'],
      timerDuration: json['timerDuration'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      inspector: json['inspectorId'] != null
          ? ClientInfoModel.fromJson(json['inspectorId'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'clientId': (client as ClientInfoModel).toJson(),
      'inspectorIds': inspectorIds,
      'certificateSubTypeId':
          certificateSubTypes.map((e) => (e as CertificateSubTypeModelData).toJson()).toList(),
      'images': images,
      'description': description,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'bookingLocation': bookingLocation,
      'status': status,
      'isDeleted': isDeleted,
      'timerStartedAt': timerStartedAt,
      'timerEndedAt': timerEndedAt,
      'timerDuration': timerDuration,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'inspectorId': inspector != null ? (inspector as ClientInfoModel).toJson() : null,
    };
  }
}

class ClientInfoModel extends ClientInfoEntity {
  ClientInfoModel({
    required super.id,
    required super.email,
    required super.name,
    required super.phoneNumber,
    required super.countryCode,
  });

  factory ClientInfoModel.fromJson(Map<String, dynamic> json) {
    return ClientInfoModel(
      id: json['_id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      countryCode: json['countryCode'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'email': email,
        'name': name,
        'phoneNumber': phoneNumber,
        'countryCode': countryCode,
      };
}
