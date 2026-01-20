import 'package:inspect_connect/features/auth_flow/data/models/device_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/location_dto.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

class AuthUserDto {
  final String id;
  final String userId;
  final int? role;
  final String email;
  final String name;
  final String? profileImage;
  final int? status;
  final String? phoneNumber;
  final String? countryCode;
  final bool? phoneOtpVerified;
  final bool? emailOtpVerified;
  final bool? agreedToTerms;
  final bool? isTruthfully;
  final String? walletId;
  final String? stripeAccountId;
  final String? stripeCustomerId;
  final String? authToken;
  final String? stripeSubscriptionStatus;
  final CurrentSubscription? currentSubscriptionId;
  final int? currentSubscriptionTrialDays;
  final int? currentSubscriptionAutoRenew;
  final bool? stripePayoutsEnabled;
  final bool? stripeTransfersEnabled;
  final int? certificateApproved;
  final String? rejectedReason;
  final bool? bookingInProgress;
  final bool? isDeleted;
  final String? country;
  final String? state;
  final String? city;
  final String? mailingAddress;
  final String? certificateTypeId;
  final List<String>? certificateAgencyIds;
  final List<String>? certificateDocuments;
  final String? certificateExpiryDate;
  final List<String>? referenceDocuments;
  final String? uploadedIdOrLicenseDocument;
  final String? workHistoryDescription;
  final String? connectorLinkUrl;
  final LocationDto? location;
  final List<DeviceDto>? devices;
  final String? loginTime;
  final String? createdAt;
  final String? updatedAt;

  const AuthUserDto({
    required this.id,
    required this.userId,
    required this.email,
    required this.name,
    this.profileImage,
    this.authToken,
    this.role,
    this.status,
    this.phoneNumber,
    this.countryCode,
    this.phoneOtpVerified,
    this.emailOtpVerified,
    this.agreedToTerms,
    this.isTruthfully,
    this.walletId,
    this.stripeAccountId,
    this.stripeCustomerId,
    this.stripeSubscriptionStatus,
    this.currentSubscriptionId,
    this.currentSubscriptionTrialDays,
    this.currentSubscriptionAutoRenew,
    this.stripePayoutsEnabled,
    this.stripeTransfersEnabled,
    this.certificateApproved,
    this.rejectedReason,
    this.bookingInProgress,
    this.isDeleted,
    this.country,
    this.state,
    this.city,
    this.mailingAddress,
    this.certificateTypeId,
    this.certificateAgencyIds,
    this.certificateDocuments,
    this.certificateExpiryDate,
    this.referenceDocuments,
    this.uploadedIdOrLicenseDocument,
    this.workHistoryDescription,
    this.connectorLinkUrl,
    this.location,
    this.devices,
    this.loginTime,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUserDto.fromBody(Map<String, dynamic> json) {
    final dynamic subscriptionRaw = json['currentSubscriptionId'];

    CurrentSubscription? parsedSubscription;

    if (subscriptionRaw is Map<String, dynamic>) {
      parsedSubscription = CurrentSubscription.fromJson(subscriptionRaw);
    } else if (subscriptionRaw is String && subscriptionRaw.isNotEmpty) {
      parsedSubscription = CurrentSubscription(id: subscriptionRaw);
    } else {
      parsedSubscription = null;
    }
    return AuthUserDto(
      id: json['_id']?.toString() ?? '',
      userId: json['_id']?.toString() ?? '',
      role: json['role'] as int?,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      profileImage: json['profileImage'],
      status: json['status'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      phoneOtpVerified: json['phoneOtpVerified'],
      emailOtpVerified: json['emailOtpVerified'],
      agreedToTerms: json['agreedToTerms'],
      isTruthfully: json['isTruthfully'],
      walletId: json['walletId'],
      stripeAccountId: json['stripeAccountId'],
      stripeCustomerId: json['stripeCustomerId'],
      authToken: json['authToken'],
      stripeSubscriptionStatus: json['stripeSubscriptionStatus'],
      currentSubscriptionId: parsedSubscription,
      currentSubscriptionTrialDays: json['currentSubscriptionTrialDays'],
      currentSubscriptionAutoRenew: json['currentSubscriptionAutoRenew'],
      stripePayoutsEnabled: json['stripePayoutsEnabled'],
      stripeTransfersEnabled: json['stripeTransfersEnabled'],
      certificateApproved: json['certificateApproved'],
      rejectedReason: json['rejectedReason'],
      bookingInProgress: json['bookingInProgress'],
      isDeleted: json['isDeleted'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      mailingAddress: json['mailingAddress'],
      certificateTypeId: json['certificateTypeId'],
      certificateAgencyIds: (json['certificateAgencyIds'] is List)
          ? List<String>.from(json['certificateAgencyIds'])
          : [],
      certificateDocuments: (json['certificateDocuments'] is List)
          ? List<String>.from(json['certificateDocuments'])
          : [],
      certificateExpiryDate: json['certificateExpiryDate'],
      referenceDocuments: (json['referenceDocuments'] is List)
          ? List<String>.from(json['referenceDocuments'])
          : [],
      workHistoryDescription: json['workHistoryDescription'],
      connectorLinkUrl: json['connectorLinkUrl'],
      location: json['location'] != null
          ? LocationDto.fromJson(json['location'])
          : null,
      devices: (json['devices'] is List)
          ? (json['devices'] as List)
                .whereType<Map<String, dynamic>>()
                .map(DeviceDto.fromJson)
                .toList()
          : const [],
      loginTime: json['loginTime'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  AuthUser toEntity() => AuthUser(
    id: id,
    name: name,
    userId: userId,
    emailHashed: email,
    authToken: authToken ?? '',
    role: role,
    phoneNumber: phoneNumber,
    countryCode: countryCode,
    phoneOtpVerified: phoneOtpVerified ?? false,
    emailOtpVerified: emailOtpVerified ?? false,
    agreedToTerms: agreedToTerms ?? false,
    isTruthfully: isTruthfully ?? false,
    walletId: walletId,
    stripeAccountId: stripeAccountId,
    stripeCustomerId: stripeCustomerId,
    stripeSubscriptionStatus: stripeSubscriptionStatus,
    currentSubscriptionId: currentSubscriptionId,
    certificateApproved: certificateApproved,
    rejectedReason: rejectedReason,
    location: (location?.coordinates?.length == 2)
        ? UserLocation(
            name: location?.locationName,
            lat: location!.coordinates![0],
            lng: location!.coordinates![1],
          )
        : null,
    devices:
        devices
            ?.map((d) => UserDevice(token: d.deviceToken, type: d.deviceType))
            .toList() ??
        const [],
  );
}
