// import 'package:inspect_connect/features/auth_flow/data/models/device_dto.dart';
// import 'package:inspect_connect/features/auth_flow/data/models/location_dto.dart';
// import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
// import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
// import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

// class AuthUserDto {
//   final String id;
//   final int? role;
//   final String emailHashed;
//   final String name;
//   final int? status;
//   final String? phoneNumber;
//   final String? countryCode;
//   final bool? phoneOtpVerified;
//   final bool? emailOtpVerified;
//   final bool? agreedToTerms;
//   final bool? isTruthfully;
//   final String? walletId;
//   final String? stripeAccountId;
//   final String? stripeCustomerId;
//   final String authToken;
//   final LocationDto location;
//   final List<DeviceDto> devices;

//   AuthUserDto({
//     required this.id,
//     required this.emailHashed,
//     required this.name,
//     required this.authToken,
//     required this.location,
//     required this.devices,
//     this.role,
//     this.status,
//     this.phoneNumber,
//     this.countryCode,
//     this.phoneOtpVerified,
//     this.emailOtpVerified,
//     this.agreedToTerms,
//     this.isTruthfully,
//     this.walletId,
//     this.stripeAccountId,
//     this.stripeCustomerId,
//   });

//   factory AuthUserDto.fromBody(Map<String, dynamic> b) => AuthUserDto(
//         id: b['_id']?.toString() ?? '',
//         role: b['role'] as int?,
//         emailHashed: b['email'] as String? ?? '',
//         name: b['name'] as String? ?? '',
//         status: b['status'] as int?,
//         phoneNumber: b['phoneNumber'] as String?,
//         countryCode: b['countryCode'] as String?,
//         phoneOtpVerified: b['phoneOtpVerified'] as bool?,
//         emailOtpVerified: b['emailOtpVerified'] as bool?,
//         agreedToTerms: b['agreedToTerms'] as bool?,
//         isTruthfully: b['isTruthfully'] as bool?,
//         walletId: b['walletId'] as String?,
//         stripeAccountId: b['stripeAccountId'] as String?,
//         stripeCustomerId: b['stripeCustomerId'] as String?,
//         authToken: b['authToken'] as String? ?? '',
//         location: LocationDto.fromJson(b['location'] as Map<String, dynamic>?),
//         devices: (b['devices'] is List)
//             ? (b['devices'] as List)
//                 .whereType<Map<String, dynamic>>()
//                 .map(DeviceDto.fromJson)
//                 .toList()
//             : const [],
//       );

//   AuthUser toEntity() => AuthUser(
//         id: id,
//         name: name,
//         emailHashed: emailHashed,
//         authToken: authToken,
//         role: role,
//         phoneNumber: phoneNumber,
//         countryCode: countryCode,
//         phoneOtpVerified: phoneOtpVerified ?? false,
//         emailOtpVerified: emailOtpVerified ?? false,
//         agreedToTerms: agreedToTerms ?? false,
//         isTruthfully: isTruthfully ?? false,
//         walletId: walletId,
//         stripeAccountId: stripeAccountId,
//         stripeCustomerId: stripeCustomerId,
//         location: (location.coordinates?.length == 2)
//             ? UserLocation(
//                 name: location.locationName,
//                 lat: location.coordinates![0],
//                 lng: location.coordinates![1],
//               )
//             : null,
//         devices: devices
//             .map((d) => UserDevice(token: d.deviceToken, type: d.deviceType))
//             .toList(),
//       );
// }


import 'package:inspect_connect/features/auth_flow/data/models/device_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/location_dto.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

class AuthUserDto {
  final String id;
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

  // Inspector-specific fields
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

  // Shared between both
  final LocationDto? location;
  final List<DeviceDto>? devices;

  const AuthUserDto({
    required this.id,
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
    this.location,
    this.devices,
  });

  /// ✅ Factory constructor to parse from API response
  factory AuthUserDto.fromBody(Map<String, dynamic> json) {
    return AuthUserDto(
      id: json['_id']?.toString() ?? '',
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

      // Inspector-specific
      bookingInProgress: json['bookingInProgress'],
      isDeleted: json['isDeleted'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      mailingAddress: json['mailingAddress'],
      certificateTypeId: json['certificateTypeId'],
      certificateAgencyIds:
          (json['certificateAgencyIds'] is List) ? List<String>.from(json['certificateAgencyIds']) : [],
      certificateDocuments:
          (json['certificateDocuments'] is List) ? List<String>.from(json['certificateDocuments']) : [],
      certificateExpiryDate: json['certificateExpiryDate'],
      referenceDocuments:
          (json['referenceDocuments'] is List) ? List<String>.from(json['referenceDocuments']) : [],
      uploadedIdOrLicenseDocument: json['uploadedIdOrLicenseDocument'],
      workHistoryDescription: json['workHistoryDescription'],

      // Common
      location: json['location'] != null
          ? LocationDto.fromJson(json['location'])
          : null,
      devices: (json['devices'] is List)
          ? (json['devices'] as List)
              .whereType<Map<String, dynamic>>()
              .map(DeviceDto.fromJson)
              .toList()
          : const [],
    );
  }

  /// ✅ Convert to domain entity
  AuthUser toEntity() => AuthUser(
        id: id,
        name: name,
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
        location: (location?.coordinates?.length == 2)
            ? UserLocation(
                name: location?.locationName,
                lat: location!.coordinates![0],
                lng: location!.coordinates![1],
              )
            : null,
        devices: devices
                ?.map(
                  (d) => UserDevice(token: d.deviceToken, type: d.deviceType),
                )
                .toList() ??
            const [],
      );
}
