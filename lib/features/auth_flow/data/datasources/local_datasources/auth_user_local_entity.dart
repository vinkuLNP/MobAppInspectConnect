import 'dart:convert';

import 'package:inspect_connect/features/auth_flow/data/models/document_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/service_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/user_document_data_model.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_device_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_location_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class AuthUserLocalEntity {
  int id = 0;
  String userId;
  String? authToken;
  String? name;
  String? email;
  String? phoneNumber;
  String? countryCode;
  String? mailingAddress;
  int? role;
  int? status;
  bool? phoneOtpVerified;
  bool? emailOtpVerified;
  bool? agreedToTerms;
  bool? isTruthfully;
  int? certificateApproved;
  String? rejectedReason;
  String? stripeCustomerId;
  String? stripeAccountId;
  bool? stripePayoutsEnabled;
  bool? stripeTransfersEnabled;
  int? currentSubscriptionTrialDays;
  int? currentSubscriptionAutoRenew;
  CurrentSubscription? currentSubscriptionId;
  String? stripeSubscriptionStatus;
  String? walletId;
  String? locationName;
  double? latitude;
  double? longitude;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? profileImage;
  bool? bookingInProgress;
  bool? isDeleted;
  String? country;
  String? state;
  String? city;
  String? zipCode;

  Map<String, dynamic>? location;
  String? certificateTypeId;
  List<String>? certificateAgencyIds;
  List<String>? certificateDocuments;
  String? certificateExpiryDate;
  List<String>? referenceDocuments;
  UserDocumentDataModel? uploadedIdOrLicenseDocument;
  String? workHistoryDescription;
  DateTime? loginTime;
  bool? statusUpdatedByAdmin;
  bool? docxOk;
  String? connectorLinkUrl;
  String? documentTypeId;
  String? documentExpiryDate;
  String? coiExpiryDate;
  String? serviceAreasJson;
  String? documentsJson;

  @Backlink()
  final devices = ToMany<AuthUserDeviceEntity>();

  AuthUserLocalEntity({
    this.authToken,
    required this.userId,
    this.name,
    this.email,
    this.phoneNumber,
    this.countryCode,
    this.mailingAddress,
    this.role,
    this.status,
    this.phoneOtpVerified,
    this.emailOtpVerified,
    this.agreedToTerms,
    this.isTruthfully,
    this.certificateApproved,
    this.rejectedReason,
    this.stripeCustomerId,
    this.stripeAccountId,
    this.stripePayoutsEnabled,
    this.stripeTransfersEnabled,
    this.currentSubscriptionTrialDays,
    this.currentSubscriptionAutoRenew,
    this.currentSubscriptionId,
    this.stripeSubscriptionStatus,
    this.walletId,
    this.locationName,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
    this.loginTime,
    this.profileImage,
    this.bookingInProgress,
    this.isDeleted,
    this.country,
    this.state,
    this.city,
    this.location,
    this.zipCode,
    this.certificateTypeId,
    this.certificateAgencyIds,
    this.certificateDocuments,
    this.certificateExpiryDate,
    this.referenceDocuments,
    this.uploadedIdOrLicenseDocument,
    this.workHistoryDescription,
    this.statusUpdatedByAdmin,
    this.docxOk,
    this.connectorLinkUrl,
    this.documentTypeId,
    this.documentExpiryDate,
    this.coiExpiryDate,
    this.serviceAreasJson,
    this.documentsJson,
  });
  AuthUserLocalEntity copyWith({
    String? name,
    String? email,
    required String userId,
    String? authToken,
    int? role,
    String? phoneNumber,
    String? mailingAddress,
    String? countryCode,
    bool? phoneOtpVerified,
    bool? emailOtpVerified,
    bool? agreedToTerms,
    bool? isTruthfully,
    String? walletId,
    String? stripeAccountId,
    String? stripeCustomerId,
    UserLocation? location,
    List<UserDevice>? devices,
  }) {
    return AuthUserLocalEntity(
      name: name ?? this.name,
      email: email ?? this.email,
      userId: userId,
      authToken: authToken ?? this.authToken,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      phoneOtpVerified: phoneOtpVerified ?? this.phoneOtpVerified,
      emailOtpVerified: emailOtpVerified ?? this.emailOtpVerified,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      isTruthfully: isTruthfully ?? this.isTruthfully,
      walletId: walletId ?? this.walletId,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      mailingAddress: mailingAddress ?? this.mailingAddress,
    );
  }

  //   factory AuthUserLocalEntity.fromApiResponse(Map<String, dynamic> response) {
  //     final user = response['body'];
  //     final location = user?['location'];

  //     double? latitude;
  //     double? longitude;
  //     String? locationName;

  //     if (location != null && location['coordinates'] != null) {
  //       longitude = (location['coordinates'][0] as num?)?.toDouble();
  //       latitude = (location['coordinates'][1] as num?)?.toDouble();
  //       locationName = location['locationName'];
  //     }

  //     return AuthUserLocalEntity(
  //       userId: user['_id'],
  //       name: user['name'],
  //       email: user['email'],
  //       phoneNumber: user['phoneNumber'],
  //       countryCode: user['countryCode'],
  //       mailingAddress: user['mailingAddress'],
  //       role: user['role'],
  //       status: user['status'],
  //       statusUpdatedByAdmin: user['statusUpdatedByAdmin'],
  //       phoneOtpVerified: user['phoneOtpVerified'],
  //       emailOtpVerified: user['emailOtpVerified'],
  //       agreedToTerms: user['agreedToTerms'],
  //       isTruthfully: user['isTruthfully'],
  //       bookingInProgress: user['bookingInProgress'],
  //       isDeleted: user['isDeleted'],
  //       profileImage: user['profileImage'] == "null"
  //           ? null
  //           : user['profileImage'],
  //       country: user['country'],
  //       state: user['state'],
  //       city: user['city'],
  //       zipCode: user['zip'],

  //       certificateApproved: user['certificateApproved'],
  //       rejectedReason: user['rejectedReason'],
  //       certificateTypeId: user['certificateTypeId']?['_id'],
  //       certificateDocuments: List<String>.from(
  //         user['certificateDocuments'] ?? [],
  //       ),
  //       certificateExpiryDate: user['certificateExpiryDate'],

  //       documentTypeId: user['documentTypeId']?['_id'],
  //       documentExpiryDate: user['documentExpiryDate'],
  //       coiExpiryDate: user['coiExpiryDate'],

  //       stripeCustomerId: user['stripeCustomerId'],
  //       stripeAccountId: user['stripeAccountId'],
  //       stripePayoutsEnabled: user['stripePayoutsEnabled'],
  //       stripeTransfersEnabled: user['stripeTransfersEnabled'],
  //       stripeSubscriptionStatus: user['stripeSubscriptionStatus'],
  //       currentSubscriptionId: user['currentSubscriptionId'] != null
  //           ? (user['currentSubscriptionId'] is String
  //                 ? CurrentSubscription(id: user['currentSubscriptionId'])
  //                 : CurrentSubscription.fromJson(user['currentSubscriptionId']))
  //           : null,
  //       currentSubscriptionTrialDays: user['currentSubscriptionTrialDays'],
  //       currentSubscriptionAutoRenew: user['currentSubscriptionAutoRenew'],

  //       walletId: user['walletId'],
  //       docxOk: user['docxOk'],
  //       connectorLinkUrl: user['connectorLinkUrl'],

  //       locationName: locationName,
  //       latitude: latitude,
  //       longitude: longitude,

  //       serviceAreasJson: jsonEncode(user['serviceAreas'] ?? []),
  //       documentsJson: jsonEncode(user['documents'] ?? []),

  //       loginTime: user['loginTime'] != null
  //           ? DateTime.parse(user['loginTime'])
  //           : null,
  //       createdAt: DateTime.parse(user['createdAt']),
  //       updatedAt: DateTime.parse(user['updatedAt']),
  //     );
  //   }
}

@Entity()
class AuthUserDeviceEntity {
  int id = 0;
  String? deviceToken;
  String? deviceType;

  final user = ToOne<AuthUserLocalEntity>();

  AuthUserDeviceEntity({this.deviceToken, this.deviceType});
}

extension AuthUserLocalMapping on AuthUserLocalEntity {
  AuthUser toDomainEntity() {
    return AuthUser(
      id: id.toString(),
      userId: userId,
      name: name ?? '',
      emailHashed: email ?? '',
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
      currentSubscriptionTrialDays: currentSubscriptionTrialDays,
      currentSubscriptionAutoRenew: currentSubscriptionAutoRenew,
      stripePayoutsEnabled: stripePayoutsEnabled,
      stripeTransfersEnabled: stripeTransfersEnabled,
      certificateApproved: certificateApproved,
      rejectedReason: rejectedReason,
      location: (latitude != null && longitude != null)
          ? UserLocation(
              name: locationName ?? '',
              lat: latitude!,
              lng: longitude!,
            )
          : null,
      devices: devices.map((d) => d.toDomainEntity()).toList(),
      bookingInProgress: bookingInProgress,
      isDeleted: isDeleted,
      status: status,
      statusUpdatedByAdmin: statusUpdatedByAdmin,
      profileImage: profileImage,
      mailingAddress: mailingAddress,
      country: country,
      state: state,
      city: city,
      zip: zipCode,
      certificateTypeId: certificateTypeId,
      certificateAgencyIds: certificateAgencyIds,
      certificateDocuments: certificateDocuments,
      certificateExpiryDate: certificateExpiryDate,
      uploadedIdOrLicenseDocument: uploadedIdOrLicenseDocument,
      documentTypeId: documentTypeId,
      documentExpiryDate: documentExpiryDate,
      coiExpiryDate: coiExpiryDate,
      docxOk: docxOk,
      workHistoryDescription: workHistoryDescription,
      referenceDocuments: referenceDocuments,
      connectorLinkUrl: connectorLinkUrl,
      createdAt: createdAt,
      updatedAt: updatedAt,
      loginTime: loginTime,
      documents: documentsJson != null
          ? (jsonDecode(documentsJson!) as List)
                .map((e) => UserDocument.fromJson(e))
                .toList()
          : null,
      serviceAreas: serviceAreasJson != null
          ? (jsonDecode(serviceAreasJson!) as List)
                .map((e) => ServiceArea.fromJson(e))
                .toList()
          : null,
    );
  }
}

extension AuthUserDeviceMapping on AuthUserDeviceEntity {
  UserDevice toDomainEntity() {
    return UserDevice(token: deviceToken, type: deviceType);
  }
}

extension AuthUserLocalEntityMergeData on AuthUserLocalEntity {
  AuthUserLocalEntity mergeWithNewData(AuthUserLocalEntity newUser) {
    final merged =
        AuthUserLocalEntity(
            userId: newUser.userId,
            name: newUser.name ?? name,
            email: newUser.email ?? email,
            phoneNumber: newUser.phoneNumber ?? phoneNumber,
            countryCode: newUser.countryCode ?? countryCode,
            role: newUser.role ?? role,
            authToken: (newUser.authToken?.isNotEmpty ?? false)
                ? newUser.authToken
                : authToken,
            agreedToTerms: newUser.agreedToTerms ?? agreedToTerms,
            isTruthfully: newUser.isTruthfully ?? isTruthfully,
            mailingAddress: newUser.mailingAddress ?? mailingAddress,
            status: newUser.status ?? status,
            phoneOtpVerified: newUser.phoneOtpVerified ?? phoneOtpVerified,
            emailOtpVerified: newUser.emailOtpVerified ?? emailOtpVerified,
            certificateApproved:
                newUser.certificateApproved ?? certificateApproved,
            rejectedReason: newUser.rejectedReason ?? rejectedReason,
            stripeCustomerId: newUser.stripeCustomerId ?? stripeCustomerId,
            stripeAccountId: newUser.stripeAccountId ?? stripeAccountId,
            stripePayoutsEnabled:
                newUser.stripePayoutsEnabled ?? stripePayoutsEnabled,
            stripeTransfersEnabled:
                newUser.stripeTransfersEnabled ?? stripeTransfersEnabled,
            currentSubscriptionTrialDays:
                newUser.currentSubscriptionTrialDays ??
                currentSubscriptionTrialDays,
            currentSubscriptionAutoRenew:
                newUser.currentSubscriptionAutoRenew ??
                currentSubscriptionAutoRenew,
            currentSubscriptionId:
                newUser.currentSubscriptionId ?? currentSubscriptionId,
            stripeSubscriptionStatus:
                newUser.stripeSubscriptionStatus ?? stripeSubscriptionStatus,
            walletId: newUser.walletId ?? walletId,
            locationName: newUser.locationName ?? locationName,
            latitude: newUser.latitude ?? latitude,
            longitude: newUser.longitude ?? longitude,
            createdAt: createdAt ?? newUser.createdAt,
            zipCode: zipCode ?? newUser.zipCode,
            updatedAt: newUser.updatedAt ?? updatedAt,
            loginTime: newUser.loginTime ?? loginTime,
            docxOk: newUser.docxOk ?? docxOk,
            connectorLinkUrl: newUser.connectorLinkUrl ?? connectorLinkUrl,
            statusUpdatedByAdmin:
                newUser.statusUpdatedByAdmin ?? statusUpdatedByAdmin,
            documentTypeId: newUser.documentTypeId ?? documentTypeId,
            documentExpiryDate:
                newUser.documentExpiryDate ?? documentExpiryDate,
            coiExpiryDate: newUser.coiExpiryDate ?? coiExpiryDate,
            serviceAreasJson: newUser.serviceAreasJson ?? serviceAreasJson,
            documentsJson: newUser.documentsJson ?? documentsJson,
          )
          ..id = id
          ..devices.addAll(
            newUser.devices.isNotEmpty ? newUser.devices : devices,
          );

    return merged;
  }
}
