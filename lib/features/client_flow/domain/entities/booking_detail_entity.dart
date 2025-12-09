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
  final String totalPaidToInspector;


  final List<double> bookingLocationCoordinates;
  final String bookingLocationZip;

  final int status;
  final bool isDeleted;
  final String? timerStartedAt;
  final String? timerEndedAt;
  final int timerDuration;

  final double finalBillingHours;
  final String totalBillingAmount;
  final String platformFee;
  final String overRideAmount;
  final String globalCharge;
  final double finalRaisedAmount;
  final bool showUpFeeApplied;
  final String showUpFee;
  final bool lateCancellation;
  final String lateCancellationFee;

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
    required this.totalPaidToInspector,
    required this.bookingDate,
    required this.bookingTime,
    required this.bookingLocation,
    required this.bookingLocationCoordinates,
    required this.bookingLocationZip,
    required this.status,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,

    this.timerStartedAt,
    this.timerEndedAt,
    this.timerDuration = 0,

    this.finalBillingHours = 0,
    this.totalBillingAmount = "",
    this.platformFee = "",
    this.overRideAmount = "",
    this.globalCharge = "",
    this.finalRaisedAmount = 0,
    this.showUpFeeApplied = false,
    this.showUpFee = "",
    this.lateCancellation = false,
    this.lateCancellationFee = "",

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
