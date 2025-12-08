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
  final List<double>? bookingLocationCoordinates;
  final String? bookingLocationZip;

  final int? status;
  final bool? isDeleted;

  final String? createdAt;
  final String? updatedAt;

  final String? inspectorId;

  final String? timerStartedAt;
  final String? timerEndedAt;
  final int? timerDuration;

  final int? finalBillingHours;
  final String? totalBillingAmount;
  final String? platformFee;
  final String? overRideAmount;
  final String? globalCharge;
  final int? finalRaisedAmount;
  final bool? showUpFeeApplied;
  final String? showUpFee;
  final bool? lateCancellation;
  final String? lateCancellationFee;

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
    this.bookingLocationCoordinates,
    this.bookingLocationZip,
    this.status,
    this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.inspectorId,
    this.timerStartedAt,
    this.timerEndedAt,
    this.timerDuration,
    this.finalBillingHours,
    this.totalBillingAmount,
    this.platformFee,
    this.overRideAmount,
    this.globalCharge,
    this.finalRaisedAmount,
    this.showUpFeeApplied,
    this.showUpFee,
    this.lateCancellation,
    this.lateCancellationFee,
  });

  factory BookingListEntity.fromJson(Map<String, dynamic> json) {
    return BookingListEntity(
      id: json['_id'] ?? '',

      client: json['clientId'] is Map
          ? AuthUser.fromJson(json['clientId'])
          : null,

      inspectorIds: List<String>.from(json['inspectorIds'] ?? []),

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

      bookingLocationZip: json['bookingLocationZip'] ?? '',

      status: json['status'],
      isDeleted: json['isDeleted'],

      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],

      inspectorId: json['inspectorId']?.toString(),

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
  BookingListEntity copyWith({
  String? id,
  AuthUser? client,
  List<String>? inspectorIds,
  List<CertificateSubTypeModelData>? certificateSubTypes,
  List<String>? images,
  String? description,
  String? bookingDate,
  String? bookingTime,
  String? bookingLocation,
  List<double>? bookingLocationCoordinates,
  String? bookingLocationZip,
  int? status,
  bool? isDeleted,
  String? createdAt,
  String? updatedAt,
  String? inspectorId,
  String? timerStartedAt,
  String? timerEndedAt,
  int? timerDuration,
  int? finalBillingHours,
  String? totalBillingAmount,
  String? platformFee,
  String? overRideAmount,
  String? globalCharge,
  int? finalRaisedAmount,
  bool? showUpFeeApplied,
  String? showUpFee,
  bool? lateCancellation,
  String? lateCancellationFee,
}) {
  return BookingListEntity(
    id: id ?? this.id,
    client: client ?? this.client,
    inspectorIds: inspectorIds ?? this.inspectorIds,
    certificateSubTypes: certificateSubTypes ?? this.certificateSubTypes,
    images: images ?? this.images,
    description: description ?? this.description,
    bookingDate: bookingDate ?? this.bookingDate,
    bookingTime: bookingTime ?? this.bookingTime,
    bookingLocation: bookingLocation ?? this.bookingLocation,
    bookingLocationCoordinates:
        bookingLocationCoordinates ?? this.bookingLocationCoordinates,
    bookingLocationZip: bookingLocationZip ?? this.bookingLocationZip,
    status: status ?? this.status,
    isDeleted: isDeleted ?? this.isDeleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    inspectorId: inspectorId ?? this.inspectorId,
    timerStartedAt: timerStartedAt ?? this.timerStartedAt,
    timerEndedAt: timerEndedAt ?? this.timerEndedAt,
    timerDuration: timerDuration ?? this.timerDuration,
    finalBillingHours: finalBillingHours ?? this.finalBillingHours,
    totalBillingAmount: totalBillingAmount ?? this.totalBillingAmount,
    platformFee: platformFee ?? this.platformFee,
    overRideAmount: overRideAmount ?? this.overRideAmount,
    globalCharge: globalCharge ?? this.globalCharge,
    finalRaisedAmount: finalRaisedAmount ?? this.finalRaisedAmount,
    showUpFeeApplied: showUpFeeApplied ?? this.showUpFeeApplied,
    showUpFee: showUpFee ?? this.showUpFee,
    lateCancellation: lateCancellation ?? this.lateCancellation,
    lateCancellationFee: lateCancellationFee ?? this.lateCancellationFee,
  );
}

}
