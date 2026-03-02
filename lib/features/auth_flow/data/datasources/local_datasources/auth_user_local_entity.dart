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
  bool? statusUpdatedByAdmin;
  int? certificateApproved;
  String? certificateTypeId;
  String? certificateTypeJson;
  List<String>? certificateAgencyIds;
  List<String>? certificateDocuments;
  String? certificateExpiryDate;
  bool? noRejectedDocx;
  String? documentTypeId;
  String? documentExpiryDate;
  String? coiExpiryDate;
  String? documentsJson;
  String? serviceAreasJson;
  String? lockedServiceCitiesJson;
  int? docxOk;
  String? profileImage;
  bool? bookingInProgress;
  bool? isDeleted;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? locationName;
  double? latitude;
  double? longitude;
  Map<String, dynamic>? location;
  String? stripeCustomerId;
  String? stripeAccountId;
  bool? stripePayoutsEnabled;
  bool? stripeTransfersEnabled;
  String? stripeSubscriptionStatus;
  String? stripeConnectStatus;
  int? currentSubscriptionTrialDays;
  int? currentSubscriptionAutoRenew;
  CurrentSubscription? currentSubscriptionId;
  String? walletId;
  String? connectorLinkUrl;
  String? rejectedReason;
  String? workHistoryDescription;
  UserDocumentDataModel? uploadedIdOrLicenseDocument;
  List<String>? referenceDocuments;

  @Backlink()
  final devices = ToMany<AuthUserDeviceEntity>();

  AuthUserLocalEntity({
    required this.userId,
    this.authToken,
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
    this.statusUpdatedByAdmin,
    this.certificateApproved,
    this.certificateTypeId,
    this.certificateTypeJson,
    this.certificateAgencyIds,
    this.certificateDocuments,
    this.certificateExpiryDate,
    this.noRejectedDocx,
    this.documentTypeId,
    this.documentExpiryDate,
    this.coiExpiryDate,
    this.documentsJson,
    this.serviceAreasJson,
    this.lockedServiceCitiesJson,
    this.docxOk,
    this.profileImage,
    this.bookingInProgress,
    this.isDeleted,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.locationName,
    this.latitude,
    this.longitude,
    this.location,
    this.stripeCustomerId,
    this.stripeAccountId,
    this.stripePayoutsEnabled,
    this.stripeTransfersEnabled,
    this.stripeSubscriptionStatus,
    this.stripeConnectStatus,
    this.currentSubscriptionTrialDays,
    this.currentSubscriptionAutoRenew,
    this.currentSubscriptionId,
    this.walletId,
    this.connectorLinkUrl,
    this.rejectedReason,
    this.workHistoryDescription,
    this.uploadedIdOrLicenseDocument,
    this.referenceDocuments,
  });

  AuthUserLocalEntity copyWith({
    int? id,
    String? userId,
    String? authToken,
    String? name,
    String? email,
    String? phoneNumber,
    String? countryCode,
    String? mailingAddress,
    int? role,
    int? status,
    bool? phoneOtpVerified,
    bool? emailOtpVerified,
    bool? agreedToTerms,
    bool? isTruthfully,
    bool? statusUpdatedByAdmin,
    int? certificateApproved,
    String? certificateTypeId,
    String? certificateTypeJson,
    List<String>? certificateAgencyIds,
    List<String>? certificateDocuments,
    String? certificateExpiryDate,
    bool? noRejectedDocx,
    String? documentTypeId,
    String? documentExpiryDate,
    String? coiExpiryDate,
    String? documentsJson,
    String? serviceAreasJson,
    String? lockedServiceCitiesJson,
    int? docxOk,
    String? profileImage,
    bool? bookingInProgress,
    bool? isDeleted,
    String? country,
    String? state,
    String? city,
    String? zipCode,
    String? locationName,
    double? latitude,
    double? longitude,
    Map<String, dynamic>? location,
    String? stripeCustomerId,
    String? stripeAccountId,
    bool? stripePayoutsEnabled,
    bool? stripeTransfersEnabled,
    String? stripeSubscriptionStatus,
    String? stripeConnectStatus,
    int? currentSubscriptionTrialDays,
    int? currentSubscriptionAutoRenew,
    CurrentSubscription? currentSubscriptionId,
    String? walletId,
    String? connectorLinkUrl,
    String? rejectedReason,
    String? workHistoryDescription,
    UserDocumentDataModel? uploadedIdOrLicenseDocument,
    List<String>? referenceDocuments,
  }) {
    return AuthUserLocalEntity(
      userId: userId ?? this.userId,
      authToken: authToken ?? this.authToken,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      countryCode: countryCode ?? this.countryCode,
      mailingAddress: mailingAddress ?? this.mailingAddress,
      role: role ?? this.role,
      status: status ?? this.status,
      phoneOtpVerified: phoneOtpVerified ?? this.phoneOtpVerified,
      emailOtpVerified: emailOtpVerified ?? this.emailOtpVerified,
      agreedToTerms: agreedToTerms ?? this.agreedToTerms,
      isTruthfully: isTruthfully ?? this.isTruthfully,
      statusUpdatedByAdmin: statusUpdatedByAdmin ?? this.statusUpdatedByAdmin,
      certificateApproved: certificateApproved ?? this.certificateApproved,
      certificateTypeId: certificateTypeId ?? this.certificateTypeId,
      certificateTypeJson: certificateTypeJson ?? this.certificateTypeJson,
      certificateAgencyIds: certificateAgencyIds ?? this.certificateAgencyIds,
      certificateDocuments: certificateDocuments ?? this.certificateDocuments,
      certificateExpiryDate:
          certificateExpiryDate ?? this.certificateExpiryDate,
      noRejectedDocx: noRejectedDocx ?? this.noRejectedDocx,
      documentTypeId: documentTypeId ?? this.documentTypeId,
      documentExpiryDate: documentExpiryDate ?? this.documentExpiryDate,
      coiExpiryDate: coiExpiryDate ?? this.coiExpiryDate,
      documentsJson: documentsJson ?? this.documentsJson,
      serviceAreasJson: serviceAreasJson ?? this.serviceAreasJson,
      lockedServiceCitiesJson:
          lockedServiceCitiesJson ?? this.lockedServiceCitiesJson,
      docxOk: docxOk ?? this.docxOk,
      profileImage: profileImage ?? this.profileImage,
      bookingInProgress: bookingInProgress ?? this.bookingInProgress,
      isDeleted: isDeleted ?? this.isDeleted,
      country: country ?? this.country,
      state: state ?? this.state,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      locationName: locationName ?? this.locationName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      location: location ?? this.location,
      stripeCustomerId: stripeCustomerId ?? this.stripeCustomerId,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
      stripePayoutsEnabled: stripePayoutsEnabled ?? this.stripePayoutsEnabled,
      stripeTransfersEnabled:
          stripeTransfersEnabled ?? this.stripeTransfersEnabled,
      stripeSubscriptionStatus:
          stripeSubscriptionStatus ?? this.stripeSubscriptionStatus,
      stripeConnectStatus: stripeConnectStatus ?? this.stripeConnectStatus,
      currentSubscriptionTrialDays:
          currentSubscriptionTrialDays ?? this.currentSubscriptionTrialDays,
      currentSubscriptionAutoRenew:
          currentSubscriptionAutoRenew ?? this.currentSubscriptionAutoRenew,
      currentSubscriptionId:
          currentSubscriptionId ?? this.currentSubscriptionId,
      walletId: walletId ?? this.walletId,
      connectorLinkUrl: connectorLinkUrl ?? this.connectorLinkUrl,
      rejectedReason: rejectedReason ?? this.rejectedReason,
      workHistoryDescription:
          workHistoryDescription ?? this.workHistoryDescription,
      uploadedIdOrLicenseDocument:
          uploadedIdOrLicenseDocument ?? this.uploadedIdOrLicenseDocument,
      referenceDocuments: referenceDocuments ?? this.referenceDocuments,
    );
  }
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
      stripeConnectStatus: stripeConnectStatus,
      noRejectedDocx: noRejectedDocx,
      coiExpiryDate: coiExpiryDate,
      workHistoryDescription: workHistoryDescription,
      docxOk: docxOk,
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
      certificateDocuments: certificateDocuments,
      certificateExpiryDate: certificateExpiryDate,
      uploadedIdOrLicenseDocument: uploadedIdOrLicenseDocument,
      documentTypeId: documentTypeId,
      documentExpiryDate: documentExpiryDate,
      referenceDocuments: referenceDocuments,
      connectorLinkUrl: connectorLinkUrl,
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
      lockedServiceCities: lockedServiceCitiesJson != null
          ? List<String>.from(jsonDecode(lockedServiceCitiesJson!))
          : null,
      devices: devices.map((d) => d.toDomainEntity()).toList(),
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
            zipCode: zipCode ?? newUser.zipCode,
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
