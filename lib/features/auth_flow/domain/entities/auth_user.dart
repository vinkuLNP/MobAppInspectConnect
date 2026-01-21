import 'dart:convert';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/data/models/document_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/service_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/user_document_data_model.dart';
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
  final CurrentSubscription? currentSubscriptionId;
  final int? currentSubscriptionTrialDays;
  final int? currentSubscriptionAutoRenew;
  final bool? stripePayoutsEnabled;
  final bool? stripeTransfersEnabled;

  final int? certificateApproved;
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
  final UserDocumentDataModel? uploadedIdOrLicenseDocument;
  final String? workHistoryDescription;
  final String? connectorLinkUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? loginTime;
  final bool? statusUpdatedByAdmin;
  final bool? docxOk;
  final String? documentTypeId;
  final String? documentExpiryDate;
  final String? coiExpiryDate;

  final List<ServiceArea>? serviceAreas;
  final List<UserDocument>? documents;

  const AuthUser({
    required this.id,
    this.name,
    required this.userId,
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
    this.stripeTransfersEnabled,
    this.certificateApproved,
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
    this.statusUpdatedByAdmin,
    this.docxOk,
    this.documentTypeId,
    this.documentExpiryDate,
    this.coiExpiryDate,
    this.serviceAreas,
    this.documents,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    final loc = json['location'];

    return AuthUser(
      id: json['_id'] ?? '',
      userId: json['_id'] ?? '',
      name: json['name'],
      emailHashed: json['email'],
      authToken: json['authToken'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      phoneOtpVerified: json['phoneOtpVerified'] ?? false,
      emailOtpVerified: json['emailOtpVerified'] ?? false,
      agreedToTerms: json['agreedToTerms'] ?? false,
      isTruthfully: json['isTruthfully'] ?? false,

      bookingInProgress: json['bookingInProgress'],
      isDeleted: json['isDeleted'],
      walletId: json['walletId'],
      stripeAccountId: json['stripeAccountId'],
      stripeCustomerId: json['stripeCustomerId'],
      stripeSubscriptionStatus: json['stripeSubscriptionStatus'],

      currentSubscriptionId: json['currentSubscriptionId'] != null
          ? CurrentSubscription.fromJson(json['currentSubscriptionId'])
          : null,

      currentSubscriptionTrialDays: json['currentSubscriptionTrialDays'],
      currentSubscriptionAutoRenew: json['currentSubscriptionAutoRenew'],
      stripePayoutsEnabled: json['stripePayoutsEnabled'],
      stripeTransfersEnabled: json['stripeTransfersEnabled'],

      certificateApproved: json['certificateApproved'],
      rejectedReason: json['rejectedReason'],

      profileImage: json['profileImage'],
      status: json['status'],
      mailingAddress: json['mailingAddress'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      zip: json['zip'],

      certificateTypeId: json['certificateTypeId']?['_id'],
      certificateDocuments: (json['certificateDocuments'] as List?)
          ?.map((e) => e.toString())
          .toList(),

      certificateExpiryDate: json['certificateExpiryDate'],
      referenceDocuments: (json['referenceDocuments'] as List?)
          ?.map((e) => e.toString())
          .toList(),

      uploadedIdOrLicenseDocument: json['uploadedIdOrLicenseDocument'] != null
          ? UserDocumentDataModel.fromJson(json['uploadedIdOrLicenseDocument'])
          : null,

      workHistoryDescription: json['workHistoryDescription'],
      connectorLinkUrl: json['connectorLinkUrl'],

      documentTypeId: json['documentTypeId']?['_id'],
      documentExpiryDate: json['documentExpiryDate'],
      coiExpiryDate: json['coiExpiryDate'],

      serviceAreas: (json['serviceAreas'] as List?)
          ?.map((e) => ServiceArea.fromJson(e))
          .toList(),

      documents: (json['documents'] as List?)
          ?.map((e) => UserDocument.fromJson(e))
          .toList(),

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
                (d) =>
                    UserDevice(token: d['deviceToken'], type: d['deviceType']),
              )
              .toList() ??
          [],

      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      loginTime: DateTime.tryParse(json['loginTime'] ?? ''),

      statusUpdatedByAdmin: json['statusUpdatedByAdmin'],
      docxOk: json['docxOk'],
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

      'currentSubscriptionId': currentSubscriptionId?.toJson(),
      'currentSubscriptionTrialDays': currentSubscriptionTrialDays,
      'currentSubscriptionAutoRenew': currentSubscriptionAutoRenew,
      'stripePayoutsEnabled': stripePayoutsEnabled,
      'stripeTransfersEnabled': stripeTransfersEnabled,

      'certificateApproved': certificateApproved,
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
      'certificateDocuments': certificateDocuments,
      'certificateExpiryDate': certificateExpiryDate,
      'referenceDocuments': referenceDocuments,

      'uploadedIdOrLicenseDocument': uploadedIdOrLicenseDocument?.toJson(),

      'workHistoryDescription': workHistoryDescription,
      'connectorLinkUrl': connectorLinkUrl,

      'documentTypeId': documentTypeId,
      'documentExpiryDate': documentExpiryDate,
      'coiExpiryDate': coiExpiryDate,

      'documents': documents?.map((e) => e.toJson()).toList(),
      'serviceAreas': serviceAreas?.map((e) => e.toJson()).toList(),

      'location': location != null
          ? {
              'type': 'Point',
              'locationName': location!.name,
              'coordinates': [location!.lng, location!.lat],
            }
          : null,

      'devices': devices
          .map((e) => {'deviceToken': e.token, 'deviceType': e.type})
          .toList(),

      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'loginTime': loginTime?.toIso8601String(),

      'statusUpdatedByAdmin': statusUpdatedByAdmin,
      'docxOk': docxOk,
    };
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
      stripeTransfersEnabled: stripeTransfersEnabled,
      certificateApproved: certificateApproved,
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
      statusUpdatedByAdmin: statusUpdatedByAdmin,
      docxOk: docxOk,
      connectorLinkUrl: connectorLinkUrl,
      documentTypeId: documentTypeId,
      documentExpiryDate: documentExpiryDate,
      coiExpiryDate: coiExpiryDate,
      documentsJson: documents != null
          ? jsonEncode(documents!.map((e) => e.toJson()).toList())
          : null,

      serviceAreasJson: serviceAreas != null
          ? jsonEncode(serviceAreas!.map((e) => e.toJson()).toList())
          : null,
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
      certificateApproved: detail.certificateApproved ?? certificateApproved,
      rejectedReason: detail.rejectedReason ?? rejectedReason,
      stripeCustomerId: detail.stripeCustomerId ?? stripeCustomerId,
      stripeAccountId: detail.stripeAccountId ?? stripeAccountId,
      stripeSubscriptionStatus:
          detail.stripeSubscriptionStatus ?? stripeSubscriptionStatus,
      currentSubscriptionId:
          detail.currentSubscriptionId ?? currentSubscriptionId,
      currentSubscriptionTrialDays:
          detail.currentSubscriptionTrialDays ?? currentSubscriptionTrialDays,
      currentSubscriptionAutoRenew:
          detail.currentSubscriptionAutoRenew ?? currentSubscriptionAutoRenew,
      stripePayoutsEnabled: detail.stripePayoutsEnabled ?? stripePayoutsEnabled,
      stripeTransfersEnabled:
          detail.stripeTransfersEnabled ?? stripeTransfersEnabled,
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
      certificateAgencyIds:
          detail.certificateAgencyIds?.map((e) => e.id ?? '').toList() ??
          certificateAgencyIds,
      certificateDocuments: detail.certificateDocuments ?? certificateDocuments,
      certificateExpiryDate:
          detail.certificateExpiryDate ?? certificateExpiryDate,
      referenceDocuments: detail.referenceDocuments ?? referenceDocuments,
      uploadedIdOrLicenseDocument:
          detail.uploadedIdOrLicenseDocument ?? uploadedIdOrLicenseDocument,
      workHistoryDescription:
          detail.workHistoryDescription ?? workHistoryDescription,
      statusUpdatedByAdmin: detail.statusUpdatedByAdmin ?? statusUpdatedByAdmin,
      docxOk: detail.docxOk ?? docxOk,
      connectorLinkUrl: detail.connectorLinkUrl ?? connectorLinkUrl,
      documentTypeId: detail.documentTypeId?.id ?? documentTypeId,
      documentExpiryDate: detail.documentExpiryDate ?? documentExpiryDate,
      coiExpiryDate: detail.coiExpiryDate ?? coiExpiryDate,
      serviceAreasJson: detail.serviceAreas != null
          ? jsonEncode(detail.serviceAreas)
          : serviceAreasJson,

      documentsJson: detail.documents != null
          ? jsonEncode(detail.documents)
          : documentsJson,
    );
  }
}
//  certificateTypeId: {_id: 69156b84aabe487380eadfd5, name: Soils & Foundations, status: 1},from the respons eu can see, certificate type id is not a string isnrtadf a map, sometimes it can be setring but fro this it is map. and need id from that 