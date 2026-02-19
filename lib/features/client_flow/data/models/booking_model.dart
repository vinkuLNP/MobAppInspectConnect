import 'dart:convert';

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
    super.bookingLocationCoordinates,
    super.bookingLocationZip,
    super.status,
    super.isDeleted,
    super.createdAt,
    super.updatedAt,
    super.timerStartedAt,
    super.timerEndedAt,
    super.timerDuration,
    super.finalBillingHours,
    super.totalBillingAmount,
    super.platformFee,
    super.overRideAmount,
    super.globalCharge,
    super.finalRaisedAmount,
    super.showUpFeeApplied,
    super.showUpFee,
    super.lateCancellation,
    super.lateCancellationFee,
  });

  factory BookingData.fromJson(Map<String, dynamic> json) {
    return BookingData(
      id: json['_id'] ?? '',

      clientUser: json['clientId'] is Map<String, dynamic>
          ? AuthUser.fromJson(json['clientId'])
          : json['clientId'] is String
          ? AuthUser(id: json['clientId'], userId: json['clientId'])
          : null,

      inspector: json['inspectorId'] is Map<String, dynamic>
          ? AuthUser.fromJson(json['inspectorId'])
          : json['inspectorId'] is String
          ? AuthUser(id: json['inspectorId'], userId: json['inspectorId'])
          : null,

      inspectorIds: (json['inspectors'] as List<dynamic>? ?? [])
          .map((item) {
            if (item is Map && item['inspectorId'] is Map) {
              return (item['inspectorId']['_id'] ?? '').toString();
            }
            return null;
          })
          .where((id) => id != null && id.isNotEmpty)
          .cast<String>()
          .toList(),

      certificateSubTypes: (json['certificateSubTypeId'] as List? ?? [])
          .map(
            (e) => e is Map<String, dynamic>
                ? CertificateSubTypeModelData.fromJson(e)
                : null,
          )
          .whereType<CertificateSubTypeModelData>()
          .toList(),

      images: List<String>.from(json['images'] ?? []),

      description: json['description'] ?? '',
      bookingDate: json['bookingDate'] ?? '',
      bookingTime: json['bookingTime'] ?? '',
      bookingLocation: json['bookingLocation'] ?? '',

      bookingLocationCoordinates: (json['bookingLocationCoordinates'] as List?)
          ?.map((e) => (e as num).toDouble())
          .toList(),

      bookingLocationZip: json['bookingLocationZip'],

      status: json['status'],
      isDeleted: json['isDeleted'],

      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],

      timerStartedAt: json['timerStartedAt'],
      timerEndedAt: json['timerEndedAt'],
      timerDuration: json['timerDuration'],

      finalBillingHours: json['finalBillingHours'],
      totalBillingAmount: json['totalBillingAmount'],
      platformFee: json['platformFee'],
      overRideAmount: json['overRideAmount'],
      globalCharge: json['globalCharge'],
      finalRaisedAmount: json['finalRaisedAmount'],
      showUpFeeApplied: json['showUpFeeApplied'],
      showUpFee: json['showUpFee'],
      lateCancellation: json['lateCancellation'],
      lateCancellationFee: json['lateCancellationFee'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'clientUser': clientUser?.toJson(),
      'inspector': inspector?.toJson(),
      'inspectorIds': inspectorIds,
      'certificateSubTypes': certificateSubTypes
          .map((e) => e.toJson())
          .toList(),
      'images': images,
      'description': description,
      'bookingDate': bookingDate,
      'bookingTime': bookingTime,
      'bookingLocation': bookingLocation,
      'bookingLocationCoordinates': bookingLocationCoordinates,
      'bookingLocationZip': bookingLocationZip,
      'status': status,
      'isDeleted': isDeleted,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'timerStartedAt': timerStartedAt,
      'timerEndedAt': timerEndedAt,
      'timerDuration': timerDuration,
      'finalBillingHours': finalBillingHours,
      'totalBillingAmount': totalBillingAmount,
      'platformFee': platformFee,
      'overRideAmount': overRideAmount,
      'globalCharge': globalCharge,
      'finalRaisedAmount': finalRaisedAmount,
      'showUpFeeApplied': showUpFeeApplied,
      'showUpFee': showUpFee,
      'lateCancellation': lateCancellation,
      'lateCancellationFee': lateCancellationFee,
    };
  }

  @override
  String toString() {
    return const JsonEncoder.withIndent('  ').convert(toJson());
  }
}
