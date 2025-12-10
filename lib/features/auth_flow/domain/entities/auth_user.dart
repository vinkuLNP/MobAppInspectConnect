import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';

class AuthUser {
  final String id;
  final String? name;
  final String userId;
  final String? emailHashed;
  final String? authToken;
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
     this.name,
   required  this.userId,
     this.emailHashed,
     this.authToken,
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

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];
    return AuthUser(
      id: json['_id'] ?? '',
      userId: json['_id'] ?? '',
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
    };
  }
  factory AuthUser.fromLocalEntity(AuthUserLocalEntity entity) {
  return AuthUser(
    id: entity.id.toString(),
    name: entity.name,
    userId: entity.userId,
    emailHashed: entity.email,
    authToken: entity.authToken,
    phoneNumber: entity.phoneNumber,
    countryCode: entity.countryCode,
    phoneOtpVerified: entity.phoneOtpVerified ?? false,
    emailOtpVerified: entity.emailOtpVerified?? false,
    agreedToTerms: entity.agreedToTerms?? true,
    isTruthfully: entity.isTruthfully?? true,
    stripeSubscriptionStatus: entity.stripeSubscriptionStatus,
    currentSubscriptionId: entity.currentSubscriptionId,
    currentSubscriptionTrialDays: entity.currentSubscriptionTrialDays,
    currentSubscriptionAutoRenew: entity.currentSubscriptionAutoRenew,
    approvalStatusByAdmin: entity.approvalStatusByAdmin,
    rejectedReason: entity.rejectedReason,
    location: entity.latitude != null && entity.longitude != null
        ? UserLocation(
            name: entity.locationName ?? '',
            lat: entity.latitude!,
            lng: entity.longitude!,
          )
        : null,
    devices: [], 
    createdAt: entity.createdAt,
    updatedAt: entity.updatedAt,
    loginTime: entity.loginTime,
    status: entity.status,
    mailingAddress: entity.mailingAddress,
    country: entity.country,
    state: entity.state,
    city: entity.city,
    zip: entity.zipCode,
    certificateTypeId: entity.certificateTypeId,
    certificateAgencyIds: entity.certificateAgencyIds,
    certificateDocuments: entity.certificateDocuments,
    certificateExpiryDate: entity.certificateExpiryDate,
    referenceDocuments: entity.referenceDocuments,
    uploadedIdOrLicenseDocument: entity.uploadedIdOrLicenseDocument,
    workHistoryDescription: entity.workHistoryDescription,
  );
}

}

extension AuthUserMapping on AuthUser {
  AuthUserLocalEntity toLocalEntity() {
    return AuthUserLocalEntity(
      authToken: authToken,
      name: name,
      userId: userId,
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


extension AuthUserLocalEntityMerge on AuthUserLocalEntity {
  AuthUserLocalEntity mergeWithUserDetail(UserDetail detail) {
    return AuthUserLocalEntity(
      authToken: authToken,
      userId: detail.userId,
      name: detail.name != null && detail.name!.isNotEmpty ? detail.name : name,
      email: detail.email != null && detail.email!.isNotEmpty
          ? detail.email
          : email,
      phoneNumber: detail.phoneNumber ?? phoneNumber,
      countryCode: detail.countryCode ?? countryCode,
      mailingAddress: detail.mailingAddress ?? mailingAddress,
      role: role,
      status: detail.status ?? status,
      phoneOtpVerified: detail.phoneOtpVerified ?? phoneOtpVerified,
      emailOtpVerified: detail.emailOtpVerified ?? emailOtpVerified,
      agreedToTerms: detail.agreedToTerms ?? agreedToTerms,
      isTruthfully: detail.isTruthfully ?? isTruthfully,
      approvalStatusByAdmin: detail.approvalStatusByAdmin ?? approvalStatusByAdmin,
      rejectedReason: detail.rejectedReason ?? rejectedReason,
      stripeCustomerId: detail.stripeCustomerId ?? stripeCustomerId,
      stripeAccountId: detail.stripeAccountId ?? stripeAccountId,
      stripeSubscriptionStatus:
          detail.stripeSubscriptionStatus ?? stripeSubscriptionStatus,
      currentSubscriptionId:
          detail.currentSubscriptionId?.id ?? currentSubscriptionId,
      currentSubscriptionTrialDays:
          detail.currentSubscriptionTrialDays ?? currentSubscriptionTrialDays,
      currentSubscriptionAutoRenew:
          detail.currentSubscriptionAutoRenew ?? currentSubscriptionAutoRenew,
      stripePayoutsEnabled: detail.stripePayoutsEnabled ?? stripePayoutsEnabled,
      stripeTransfersActive: detail.stripeTransfersActive ?? stripeTransfersActive,
      walletId: detail.walletId ?? walletId,
      locationName: detail.location?.locationName ?? locationName,
      latitude: detail.location?.coordinates?[1] ?? latitude,
      longitude: detail.location?.coordinates?[0] ?? longitude,
      bookingInProgress: detail.bookingInProgress ?? bookingInProgress,
      isDeleted: detail.isDeleted ?? isDeleted,
      createdAt: detail.createdAt != null
          ? DateTime.tryParse(detail.createdAt!)
          : createdAt,
      updatedAt: detail.updatedAt != null
          ? DateTime.tryParse(detail.updatedAt!)
          : updatedAt,
      loginTime: detail.loginTime != null
          ? DateTime.tryParse(detail.loginTime!)
          : loginTime,
      certificateTypeId: detail.certificateTypeId?.id ?? certificateTypeId,
      certificateAgencyIds: detail.certificateAgencyIds
              ?.map((e) => e.id ?? '')
              .toList() ??
          certificateAgencyIds,
      certificateDocuments: detail.certificateDocuments ?? certificateDocuments,
      certificateExpiryDate: detail.certificateExpiryDate ?? certificateExpiryDate,
      referenceDocuments: detail.referenceDocuments ?? referenceDocuments,
      uploadedIdOrLicenseDocument:
          detail.uploadedIdOrLicenseDocument ?? uploadedIdOrLicenseDocument,
      workHistoryDescription:
          detail.workHistoryDescription ?? workHistoryDescription,
    );
  }
}
