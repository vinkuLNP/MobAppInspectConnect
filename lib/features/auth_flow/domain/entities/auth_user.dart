import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

class AuthUser {
  final String id;
  final String name;
  final String emailHashed;
  final String authToken;
  final int? role;
  final String? phoneNumber;
  final String? countryCode;
  final bool phoneOtpVerified;
  final bool emailOtpVerified;
  final bool agreedToTerms;
  final bool isTruthfully;
  final bool? bookingInProgress;
  final bool? isDeleted;

  final String? walletId;
  final String? stripeAccountId;
  final String? stripeCustomerId;
  final String? stripeSubscriptionStatus;
  final String? currentSubscriptionId;
  final int? currentSubscriptionTrialDays;
  final int? currentSubscriptionAutoRenew;
  final bool? stripePayoutsEnabled;
  final bool? stripeTransfersActive;

  final int? approvalStatusByAdmin;
  final String? rejectedReason;

  final UserLocation? location;
  final List<UserDevice> devices;

  final String? profileImage;
  final int? status;
  final String? mailingAddress;
  final String? country;
  final String? state;
  final String? city;
  final String? zip;
  final String? certificateTypeId;
  final List<String>? certificateAgencyIds;
  final List<String>? certificateDocuments;
  final String? certificateExpiryDate;
  final List<String>? referenceDocuments;
  final String? uploadedIdOrLicenseDocument;
  final String? workHistoryDescription;
  final String? connectorLinkUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? loginTime;

  const AuthUser({
    required this.id,
    required this.name,
    required this.emailHashed,
    required this.authToken,
    this.role,
    this.phoneNumber,
    this.countryCode,
    this.phoneOtpVerified = false,
    this.emailOtpVerified = false,
    this.agreedToTerms = false,
    this.isTruthfully = false,
    this.walletId,
    this.stripeAccountId,
    this.stripeCustomerId,
    this.stripeSubscriptionStatus,
    this.currentSubscriptionId,
    this.currentSubscriptionTrialDays,
    this.currentSubscriptionAutoRenew,
    this.stripePayoutsEnabled,
    this.stripeTransfersActive,
    this.approvalStatusByAdmin,
    this.rejectedReason,
    this.location,
    this.devices = const [],
    this.profileImage,
    this.status,
    this.bookingInProgress,
    this.isDeleted,
    this.country,
    this.state,
    this.city,
    this.zip,
    this.mailingAddress,
    this.certificateTypeId,
    this.certificateAgencyIds,
    this.certificateDocuments,
    this.certificateExpiryDate,
    this.referenceDocuments,
    this.uploadedIdOrLicenseDocument,
    this.workHistoryDescription,
    this.connectorLinkUrl,
    this.createdAt,
    this.updatedAt,
    this.loginTime,
  });

  // ✅ fromJson factory
  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];
    return AuthUser(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      emailHashed: json['email'] ?? '',
      authToken: json['authToken'] ?? '',
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      phoneOtpVerified: json['phoneOtpVerified'] ?? false,
      emailOtpVerified: json['emailOtpVerified'] ?? false,
      agreedToTerms: json['agreedToTerms'] ?? false,
      isTruthfully: json['isTruthfully'] ?? false,
      walletId: json['walletId'],
      stripeAccountId: json['stripeAccountId'],
      stripeCustomerId: json['stripeCustomerId'],
      stripeSubscriptionStatus: json['stripeSubscriptionStatus'],
      currentSubscriptionId: json['currentSubscriptionId'],
      currentSubscriptionTrialDays: json['currentSubscriptionTrialDays'],
      currentSubscriptionAutoRenew: json['currentSubscriptionAutoRenew'],
      stripePayoutsEnabled: json['stripePayoutsEnabled'],
      stripeTransfersActive: json['stripeTransfersActive'],
      approvalStatusByAdmin: json['approvalStatusByAdmin'],
      rejectedReason: json['rejectedReason'],
      connectorLinkUrl: json['connectorLinkUrl'],
      bookingInProgress: json['bookingInProgress'],
      isDeleted: json['isDeleted'],
      status: json['status'],
      profileImage: json['profileImage'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      zip: json['zip'],
      mailingAddress: json['mailingAddress'],
      certificateTypeId: json['certificateTypeId'],
      certificateAgencyIds: (json['certificateAgencyIds'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      certificateDocuments: (json['certificateDocuments'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      certificateExpiryDate: json['certificateExpiryDate'],
      referenceDocuments: (json['referenceDocuments'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      uploadedIdOrLicenseDocument: json['uploadedIdOrLicenseDocument'],
      workHistoryDescription: json['workHistoryDescription'],
      location: loc != null
          ? UserLocation(
              name: loc['locationName'] ?? '',
              lat: (loc['coordinates']?[1] ?? 0).toDouble(),
              lng: (loc['coordinates']?[0] ?? 0).toDouble(),
            )
          : null,
      devices:
          (json['devices'] as List?)
              ?.map(
                (d) => UserDevice(
                  token: d['deviceToken'] ?? '',
                  type: d['deviceType'] ?? '',
                ),
              )
              .toList() ??
          [],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      loginTime: json['loginTime'] != null
          ? DateTime.tryParse(json['loginTime'])
          : null,
    );
  }

  // ✅ toJson
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': emailHashed,
      'authToken': authToken,
      'role': role,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'phoneOtpVerified': phoneOtpVerified,
      'emailOtpVerified': emailOtpVerified,
      'agreedToTerms': agreedToTerms,
      'isTruthfully': isTruthfully,
      'walletId': walletId,
      'stripeAccountId': stripeAccountId,
      'stripeCustomerId': stripeCustomerId,
      'stripeSubscriptionStatus': stripeSubscriptionStatus,
      'currentSubscriptionId': currentSubscriptionId,
      'currentSubscriptionTrialDays': currentSubscriptionTrialDays,
      'currentSubscriptionAutoRenew': currentSubscriptionAutoRenew,
      'stripePayoutsEnabled': stripePayoutsEnabled,
      'stripeTransfersActive': stripeTransfersActive,
      'approvalStatusByAdmin': approvalStatusByAdmin,
      'rejectedReason': rejectedReason,
      'bookingInProgress': bookingInProgress,
      'isDeleted': isDeleted,
      'status': status,
      'profileImage': profileImage,
      'country': country,
      'state': state,
      'city': city,
      'zip': zip,
      'mailingAddress': mailingAddress,
      'certificateTypeId': certificateTypeId,
      'certificateAgencyIds': certificateAgencyIds,
      'certificateDocuments': certificateDocuments,
      'certificateExpiryDate': certificateExpiryDate,
      'referenceDocuments': referenceDocuments,
      'uploadedIdOrLicenseDocument': uploadedIdOrLicenseDocument,
      'workHistoryDescription': workHistoryDescription,
      'connectorLinkUrl': connectorLinkUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'loginTime': loginTime?.toIso8601String(),
      'location': location != null
          ? {
              'type': 'Point',
              'locationName': location!.name,
              'coordinates': [location!.lng, location!.lat],
            }
          : null,
      // 'devices': devices.map((e) => e.toJson()).toList(),
    };
  }
}

extension AuthUserMapping on AuthUser {
  AuthUserLocalEntity toLocalEntity() {
    return AuthUserLocalEntity(
      authToken: authToken,
      name: name,
      email: emailHashed,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      role: role,
      phoneOtpVerified: phoneOtpVerified,
      emailOtpVerified: emailOtpVerified,
      agreedToTerms: agreedToTerms,
      isTruthfully: isTruthfully,
      walletId: walletId,
      stripeAccountId: stripeAccountId,
      stripeCustomerId: stripeCustomerId,
      stripeSubscriptionStatus: stripeSubscriptionStatus,
      currentSubscriptionId: currentSubscriptionId,
      currentSubscriptionTrialDays: currentSubscriptionTrialDays,
      currentSubscriptionAutoRenew: currentSubscriptionAutoRenew,
      stripePayoutsEnabled: stripePayoutsEnabled,
      stripeTransfersActive: stripeTransfersActive,
      approvalStatusByAdmin: approvalStatusByAdmin,
      rejectedReason: rejectedReason,
      locationName: location?.name,
      latitude: location?.lat,
      longitude: location?.lng,
      bookingInProgress: bookingInProgress,
      isDeleted: isDeleted,
      status: status,
      profileImage: profileImage,
      mailingAddress: mailingAddress,
      country: country,
      state: state,
      city: city,
      zipCode: zip,
      // connectorLinkUrl: connectorLinkUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      loginTime: loginTime,
      certificateTypeId: certificateTypeId,
      certificateAgencyIds: certificateAgencyIds,
      certificateDocuments: certificateDocuments,
      certificateExpiryDate: certificateExpiryDate,
      referenceDocuments: referenceDocuments,
      uploadedIdOrLicenseDocument: uploadedIdOrLicenseDocument,
      workHistoryDescription: workHistoryDescription,
    );
  }
}

// class AuthUser {
//   final String id;
//   final String name;
//   final String emailHashed;
//   final String authToken;
//   final int? role;
//   final String? phoneNumber;
//   final String? countryCode;
//   final bool phoneOtpVerified;
//   final bool emailOtpVerified;
//   final bool agreedToTerms;
//   final bool isTruthfully;
//   final String? walletId;
//   final String? stripeAccountId;
//   final String? stripeCustomerId;
//   final UserLocation? location;
//   final List<UserDevice> devices;
//   final String? profileImage;
//   final int? status;
//   final bool? bookingInProgress;
//   final bool? isDeleted;
//   final String? country;
//   final String? state;
//   final String? city;
//   final String? mailingAddress;
//   final String? certificateTypeId;
//   final List<String>? certificateAgencyIds;
//   final List<String>? certificateDocuments;
//   final String? certificateExpiryDate;
//   final List<String>? referenceDocuments;
//   final String? uploadedIdOrLicenseDocument;
//   final String? workHistoryDescription;

//   const AuthUser({
//     required this.id,
//     required this.name,
//     required this.emailHashed,
//     required this.authToken,
//     this.role,
//     this.phoneNumber,
//     this.countryCode,
//     this.phoneOtpVerified = false,
//     this.emailOtpVerified = false,
//     this.agreedToTerms = false,
//     this.isTruthfully = false,
//     this.walletId,
//     this.stripeAccountId,
//     this.stripeCustomerId,
//     this.location,
//     this.devices = const [],
//     this.profileImage,
//     this.status,
//     this.bookingInProgress,
//     this.isDeleted,
//     this.country,
//     this.state,
//     this.city,
//     this.mailingAddress,
//     this.certificateTypeId,
//     this.certificateAgencyIds,
//     this.certificateDocuments,
//     this.certificateExpiryDate,
//     this.referenceDocuments,
//     this.uploadedIdOrLicenseDocument,
//     this.workHistoryDescription,
//   });
// }

// extension AuthUserMapping on AuthUser {
//   AuthUserLocalEntity toLocalEntity() {
//     return AuthUserLocalEntity(
//       authToken: authToken,
//       name: name,
//       email: emailHashed,
//       phoneNumber: phoneNumber,
//       countryCode: countryCode,
//       role: role,
//       phoneOtpVerified: phoneOtpVerified,
//       emailOtpVerified: emailOtpVerified,
//       agreedToTerms: agreedToTerms,
//       isTruthfully: isTruthfully,
//       walletId: walletId,
//       stripeAccountId: stripeAccountId,
//       stripeCustomerId: stripeCustomerId,
//       locationName: location?.name,
//       latitude: location?.lat,
//       longitude: location?.lng,
//       bookingInProgress: bookingInProgress,
//       certificateAgencyIds: certificateAgencyIds,
//       certificateDocuments: certificateDocuments,
//       certificateExpiryDate: certificateExpiryDate,
//       isDeleted: isDeleted,
//       referenceDocuments: referenceDocuments,
//       status: status,
//       mailingAddress: mailingAddress,
//       profileImage: profileImage,
//       certificateTypeId: certificateTypeId,
//       country: country,
//       state: state,
//       city: city,
//       uploadedIdOrLicenseDocument: uploadedIdOrLicenseDocument,
//       workHistoryDescription: workHistoryDescription,
//     );
//   }

//   AuthUser copyWith({
//     String? id,
//     String? fullName,
//     String? emailHashed,
//     String? token,
//     int? role,
//     String? phoneNumber,
//     String? countryCode,
//     bool? phoneOtpVerified,
//     bool? emailOtpVerified,
//     bool? agreedToTerms,
//     bool? isTruthfully,
//     String? walletId,
//     String? stripeAccountId,
//     String? stripeCustomerId,
//     UserLocation? location,
//     List<UserDevice>? devices,
//   }) {
//     return AuthUser(
//       id: id ?? this.id,
//       name: fullName ?? this.name,
//       emailHashed: emailHashed ?? this.emailHashed,
//       authToken: token ?? this.authToken,
//       role: role ?? this.role,
//       phoneNumber: phoneNumber ?? this.phoneNumber,
//       countryCode: countryCode ?? this.countryCode,
//       phoneOtpVerified: phoneOtpVerified ?? this.phoneOtpVerified,
//       emailOtpVerified: emailOtpVerified ?? this.emailOtpVerified,
//       agreedToTerms: agreedToTerms ?? this.agreedToTerms,
//       isTruthfully: isTruthfully ?? this.isTruthfully,
//       walletId: walletId ?? this.walletId,
//       stripeAccountId: stripeAccountId ?? this.stripeAccountId,
//       stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
//       location: location ?? this.location,
//       devices: devices ?? this.devices,
//     );
//   }
// }

extension AuthUserLocalEntityMerge on AuthUserLocalEntity {
  AuthUserLocalEntity mergeWithUserDetail(UserDetail detail) {
    return AuthUserLocalEntity(
      authToken: authToken,
      name: detail.name != null
          ? detail.name!.isNotEmpty
                ? detail.name
                : name
          : name,
      email: detail.name != null
          ? detail.email!.isNotEmpty
                ? detail.email
                : email
          : email,
      phoneNumber: detail.phoneNumber ?? phoneNumber,
      countryCode: detail.countryCode ?? countryCode,
      mailingAddress: detail.mailingAddress ?? mailingAddress,
      role: role,
      status: detail.status ?? status,
      phoneOtpVerified: phoneOtpVerified,
      emailOtpVerified: emailOtpVerified,
      agreedToTerms: agreedToTerms,
      isTruthfully: isTruthfully,
      approvalStatusByAdmin: approvalStatusByAdmin,
      rejectedReason: rejectedReason,
      stripeCustomerId: stripeCustomerId,
      stripeAccountId: stripeAccountId,
      stripePayoutsEnabled: stripePayoutsEnabled,
      stripeTransfersActive: stripeTransfersActive,
      currentSubscriptionTrialDays: currentSubscriptionTrialDays,
      currentSubscriptionAutoRenew: currentSubscriptionAutoRenew,
      currentSubscriptionId: currentSubscriptionId,
      stripeSubscriptionStatus: stripeSubscriptionStatus,
      walletId: walletId,
      locationName: locationName,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
      loginTime: loginTime,
    );
  }
}

// {
//     "success": true,
//     "message": "Sign-in successful",
//     "body": {
//         "location": {
//             "type": "Point",
//             "locationName": "Midtown",
//             "coordinates": [
//                 -73.9857,
//                 40.7484
//             ]
//         },
//         "_id": "69005ddee9264efd0d59a395",
//         "role": 1,
//         "email": "6b22a48b6a2dd0b962c8bf101c2ee52f89a347fc74e2d4656aa55b698905a49b",
//         "name": "client@yopmail.com",
//         "status": 1,
//         "statusUpdatedByAdmin": null,
//         "phoneNumber": "7814185613",
//         "countryCode": "+91",
//         "bookingInProgress": false,
//         "isDeleted": false,
//         "mailingAddress": "test address",
//         "referenceDocuments": null,
//         "uploadedIdOrLicenseDocument": null,
//         "workHistoryDescription": null,
//         "phoneOtpVerified": true,
//         "emailOtpVerified": false,
//         "agreedToTerms": true,
//         "isTruthfully": true,
//         "loginTime": null,
//         "stripeSubscriptionStatus": "inactive",
//         "currentSubscriptionId": null,
//         "currentSubscriptionTrialDays": 0,
//         "currentSubscriptionAutoRenew": 0,
//         "approvalStatusByAdmin": 0,
//         "rejectedReason": null,
//         "stripeAccountId": "acct_1SNAQDABK5SR8crg",
//         "connectorLinkUrl": null,
//         "walletId": "69005ddfe9264efd0d59a397",
//         "stripePayoutsEnabled": false,
//         "stripeTransfersActive": false,
//         "devices": [
//             {
//                 "deviceToken": "BP41.250822.007_3afb434f-0405-4e06-bcd0-192c63135635",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "ckifrnfr_sbffOX4EcrSuM:APA91bE51KQRCMdKryRsUM5vPb5qEHOsvntNZ5tyG9cVqCEWO4erbxApbrmxPq0oUB8M1Kq2iULczJ-gZaOhJc-QRlxlx7sJEVXe9zbbaFIjzsl90X7BwGc",
//                 "deviceType": "windows"
//             },
//             {
//                 "deviceToken": "dqJ4rFnTQaoMk4jLFtkjNq:APA91bGWlFtLKPQJFNWa02dNQDLPObzTg4L8wnPgaRyjCdEKY9fKZL7H_4mZ4XaR2BRcV30E160CvZWaZYiB_ED2XwwB5rKN-gcKpbVeuyg3mNgJ-jnQcaI",
//                 "deviceType": "windows"
//             },
//             {
//                 "deviceToken": "dummy_token",
//                 "deviceType": "windows"
//             },
//             {
//                 "deviceToken": "dummy_token",
//                 "deviceType": "ios"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_d997c353-1034-4b8a-b316-d35622d8fff0",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_72de2396-e0e2-435e-8b34-3a52ffa494b1",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_d78dce31-3dae-4d79-a8b6-d6a506a68a05",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_cdc2fb4f-fcd0-4ced-baa4-e6464f1bd254",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_43a4b59f-d66b-412e-a63e-778af1b8d0c6",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "ebKFz40bOrLkZcw_evUb7N:APA91bEu7pOLyXR7W6ELSF7uT8YjUNaEFK_wTZtrvcEzwQlJyoipeEZ9onffNRLjmomRg3-6V8Cyx_LXDpPsjW2tBCQiZ1q6xW57xcE0n1iy7LiWAxO7kr4",
//                 "deviceType": "mac"
//             },
//             {
//                 "deviceToken": "fBzoN_2NWo46gbQ4GwIZPj:APA91bE7MOiBkW0IjRvQL7dVtwMAmFBZW2MydxUZKp7gqGz4Jiinl_GeNMnv_81p54kG9ujwKLlgRfbP41TTdmHplkYubhb4itcmZp2cnmQjmfOKTL_dzCY",
//                 "deviceType": "windows"
//             },
//             {
//                 "deviceToken": "P41.250822.007_7475d0ec-f51c-495f-ae1d-66147d9a9a55",
//                 "deviceType": "windows"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_c931da38-8045-44e8-9dfd-b19c5b8c68e9",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_c318339d-efe9-4dc9-afaf-b7d20179a925",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_cedefbd0-6168-4842-831d-fad82d9e5fab",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_541d04ae-b949-42a5-a7e7-7dfb8da0d83b",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_e411f9cf-b797-4bfa-94ad-b755ca2e389b",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_a6d6bc17-d30f-498b-ae58-fff63a5efa70",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_caefba9b-3421-4326-b8af-ddeb2d869693",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_6f970746-08f5-4574-b2ec-96d68e9f694d",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "fr90M0K-yFPspH87K1ZsrH:APA91bHyo7UOPsGRIMeMt3BfFc8V_UHognrQzXAWX_gvN2-JgTv-NXA4HPEipJR_LtNVI1JK27RcIj-rMWp54Tv6O-gSJ0rQgYMVv8RqJ-o3UCRagwDzaPk",
//                 "deviceType": "windows"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_13dbb739-a4d5-469b-8661-970c05c78f8e",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_ce496adf-72e4-4f9f-9af4-1009dbda43c4",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BP41.250822.007_d0beda0b-5164-4390-b961-011130e6e4b1",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BE2A.250530.026.F3_c7a5dad2-dd5b-40a2-93cf-3691bf3bf390",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "BE2A.250530.026.F3_e0761d3d-7a99-4695-8408-5fed50f898da",
//                 "deviceType": "android"
//             },
//             {
//                 "deviceToken": "9DD38F2E-448E-4748-98C5-10A65B2AA399_96ea2554-6d45-449c-8d7d-e98cf9d377bf",
//                 "deviceType": "ios"
//             },
//             {
//                 "deviceToken": "01804D8D-522F-499C-9FB2-159E98B9D1C1_9655aa80-303a-402e-a092-f42bbf2eaf39",
//                 "deviceType": "ios"
//             }
//         ],
//         "createdAt": "2025-10-28T06:08:30.849Z",
//         "updatedAt": "2025-11-10T11:22:34.788Z",
//         "__v": 0,
//         "phoneOtp": null,
//         "phoneOtpExpiryTime": null,
//         "stripeCustomerId": "cus_TBUKRnSXZSjngR",
//         "city": "New York",
//         "country": "USA",
//         "state": "New York",
//         "zip": "10001",
//         "authToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY5MDA1ZGRlZTkyNjRlZmQwZDU5YTM5NSIsImVtYWlsIjoiNmIyMmE0OGI2YTJkZDBiOTYyYzhiZjEwMWMyZWU1MmY4OWEzNDdmYzc0ZTJkNDY1NmFhNTViNjk4OTA1YTQ5YiIsImlhdCI6MTc2Mjc3NDgyNiwiZXhwIjoxNzYzMzc5NjI2fQ.Ddje8mML6ZwzilIkje9eCpVMN9Hvf7maOSgjD4VLxuQ"
//     }
// }
