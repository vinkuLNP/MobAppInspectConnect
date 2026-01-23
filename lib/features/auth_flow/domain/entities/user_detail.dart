import 'package:inspect_connect/features/auth_flow/data/models/document_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/service_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/user_document_data_model.dart';

class UserDetail {
  final String id;
  final String userId;
  final String? role;
  final String? email;
  final String? name;
  final int? status;
  final bool? statusUpdatedByAdmin;
  final String? phoneNumber;
  final String? countryCode;
  final bool? bookingInProgress;
  final bool? isDeleted;
  final String? country;
  final String? state;
  final String? city;
  final String? zip;
  final String? mailingAddress;

  final CertificateType? certificateTypeId;
  final List<CertificateAgency>? certificateAgencyIds;
  final List<String>? certificateDocuments;
  final String? certificateExpiryDate;
  final List<String>? referenceDocuments;
  final UserDocumentDataModel? uploadedIdOrLicenseDocument;
  final String? workHistoryDescription;

  final bool? phoneOtpVerified;
  final bool? emailOtpVerified;
  final bool? agreedToTerms;
  final bool? isTruthfully;
  final String? loginTime;
  final String? stripeSubscriptionStatus;
  final CurrentSubscription? currentSubscriptionId;
  final int? currentSubscriptionTrialDays;
  final int? currentSubscriptionAutoRenew;
  final int? certificateApproved;
  final String? rejectedReason;
  final String? stripeAccountId;
  final String? connectorLinkUrl;
  final String? walletId;
  final bool? stripePayoutsEnabled;
  final bool? stripeTransfersEnabled;
  final List<Device>? devices;
  final Location? location;
  final String? createdAt;
  final String? updatedAt;
  final String? phoneOtpExpiryTime;
  final String? stripeCustomerId;
  final bool? docxOk;
  final CertificateType? documentTypeId;
  final String? documentExpiryDate;
  final String? coiExpiryDate;
  final List<ServiceArea>? serviceAreas;
  final List<UserDocument>? documents;

  const UserDetail({
    required this.id,
    required this.userId,
    this.role,
    this.email,
    this.name,
    this.status,
    this.statusUpdatedByAdmin,
    this.phoneNumber,
    this.countryCode,
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
    this.phoneOtpVerified,
    this.emailOtpVerified,
    this.agreedToTerms,
    this.isTruthfully,
    this.loginTime,
    this.stripeSubscriptionStatus,
    this.currentSubscriptionId,
    this.currentSubscriptionTrialDays,
    this.currentSubscriptionAutoRenew,
    this.certificateApproved,
    this.rejectedReason,
    this.stripeAccountId,
    this.connectorLinkUrl,
    this.walletId,
    this.stripePayoutsEnabled,
    this.stripeTransfersEnabled,
    this.devices,
    this.location,
    this.createdAt,
    this.updatedAt,
    this.phoneOtpExpiryTime,
    this.stripeCustomerId,
    this.docxOk,
    this.documentTypeId,
    this.documentExpiryDate,
    this.coiExpiryDate,
    this.serviceAreas,
    this.documents,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) {
    final body = json['body'] ?? json;
    return UserDetail(
      id: body['_id'] ?? '',
      userId: body['_id'] ?? '',

      role: body['role']?.toString(),
      email: body['email'],
      name: body['name'],
      status: body['status'],
      statusUpdatedByAdmin: body['statusUpdatedByAdmin'],
      phoneNumber: body['phoneNumber'],
      countryCode: body['countryCode'],
      bookingInProgress: body['bookingInProgress'],
      isDeleted: body['isDeleted'],
      country: body['country'],
      state: body['state'],
      city: body['city'],
      zip: body['zip'],
      mailingAddress: body['mailingAddress'],
      certificateTypeId: body['certificateTypeId'] != null
          ? CertificateType.fromJson(body['certificateTypeId'])
          : null,
      certificateAgencyIds: (body['certificateAgencyIds'] as List?)
          ?.map((e) => CertificateAgency.fromJson(e))
          .toList(),
      certificateDocuments: (body['certificateDocuments'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      certificateExpiryDate: body['certificateExpiryDate'],
      referenceDocuments: (body['referenceDocuments'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      uploadedIdOrLicenseDocument: body['uploadedIdOrLicenseDocument'] != null
          ? UserDocumentDataModel.fromJson(body['uploadedIdOrLicenseDocument'])
          : null,

      workHistoryDescription: body['workHistoryDescription'],
      phoneOtpVerified: body['phoneOtpVerified'],
      emailOtpVerified: body['emailOtpVerified'],
      agreedToTerms: body['agreedToTerms'],
      isTruthfully: body['isTruthfully'],
      loginTime: body['loginTime'],
      stripeSubscriptionStatus: body['stripeSubscriptionStatus'],
      currentSubscriptionId: body['currentSubscriptionId'] != null
          ? (body['currentSubscriptionId'] is String
                ? CurrentSubscription(id: body['currentSubscriptionId'])
                : CurrentSubscription.fromJson(body['currentSubscriptionId']))
          : null,

      currentSubscriptionTrialDays: body['currentSubscriptionTrialDays'],
      currentSubscriptionAutoRenew: body['currentSubscriptionAutoRenew'],
      certificateApproved: body['certificateApproved'],
      rejectedReason: body['rejectedReason'],
      stripeAccountId: body['stripeAccountId'],
      connectorLinkUrl: body['connectorLinkUrl'],
      walletId: body['walletId'],
      stripePayoutsEnabled: body['stripePayoutsEnabled'],
      stripeTransfersEnabled: body['stripeTransfersEnabled'],
      devices: (body['devices'] as List?)
          ?.map((e) => Device.fromJson(e))
          .toList(),
      location: body['location'] != null
          ? Location.fromJson(body['location'])
          : null,
      createdAt: body['createdAt'],
      updatedAt: body['updatedAt'],
      phoneOtpExpiryTime: body['phoneOtpExpiryTime'],
      stripeCustomerId: body['stripeCustomerId'],
      docxOk: body['docxOk'],

      documentTypeId: body['documentTypeId'] != null
          ? CertificateType.fromJson(body['documentTypeId'])
          : null,

      documentExpiryDate: body['documentExpiryDate'],
      coiExpiryDate: body['coiExpiryDate'],

      // serviceAreas: body['serviceAreas'],
      // documents: body['documents'],
      serviceAreas: body['serviceAreas'] != []
          ? (body['serviceAreas'] as List?)
                ?.map((e) => ServiceArea.fromJson(e))
                .toList()
          : [],

      documents: body['documents'] != []
          ? (body['documents'] as List?)
                ?.map((e) => UserDocument.fromJson(e))
                .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'role': role,
      'email': email,
      'name': name,
      'status': status,
      'statusUpdatedByAdmin': statusUpdatedByAdmin,
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'bookingInProgress': bookingInProgress,
      'isDeleted': isDeleted,
      'country': country,
      'state': state,
      'city': city,
      'zip': zip,
      'mailingAddress': mailingAddress,
      'certificateTypeId': certificateTypeId?.toJson(),
      'certificateAgencyIds': certificateAgencyIds
          ?.map((e) => e.toJson())
          .toList(),
      'certificateDocuments': certificateDocuments,
      'certificateExpiryDate': certificateExpiryDate,
      'referenceDocuments': referenceDocuments,
      'uploadedIdOrLicenseDocument': uploadedIdOrLicenseDocument,
      'workHistoryDescription': workHistoryDescription,
      'phoneOtpVerified': phoneOtpVerified,
      'emailOtpVerified': emailOtpVerified,
      'agreedToTerms': agreedToTerms,
      'isTruthfully': isTruthfully,
      'loginTime': loginTime,
      'stripeSubscriptionStatus': stripeSubscriptionStatus,
      'currentSubscriptionId': currentSubscriptionId?.toJson(),
      'currentSubscriptionTrialDays': currentSubscriptionTrialDays,
      'currentSubscriptionAutoRenew': currentSubscriptionAutoRenew,
      'certificateApproved': certificateApproved,
      'rejectedReason': rejectedReason,
      'stripeAccountId': stripeAccountId,
      'connectorLinkUrl': connectorLinkUrl,
      'walletId': walletId,
      'stripePayoutsEnabled': stripePayoutsEnabled,
      'stripeTransfersEnabled': stripeTransfersEnabled,
      'devices': devices?.map((e) => e.toJson()).toList(),
      'location': location?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'phoneOtpExpiryTime': phoneOtpExpiryTime,
      'stripeCustomerId': stripeCustomerId,
      'docxOk': docxOk,
      'documentTypeId': documentTypeId?.toJson(),
      'documentExpiryDate': documentExpiryDate,
      'coiExpiryDate': coiExpiryDate,
      'serviceAreas': serviceAreas,
      'documents': documents,
    };
  }
}

class Location {
  final String? type;
  final String? locationName;
  final List<double>? coordinates;

  Location({this.type, this.locationName, this.coordinates});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    type: json['type'],
    locationName: json['locationName'],
    coordinates: (json['coordinates'] as List?)
        ?.map((e) => (e as num).toDouble())
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'type': type,
    'locationName': locationName,
    'coordinates': coordinates,
  };
}

class CertificateType {
  final String? id;
  final String? name;
  final int? status;

  CertificateType({this.id, this.name, this.status});

  factory CertificateType.fromJson(Map<String, dynamic> json) =>
      CertificateType(
        id: json['_id'],
        name: json['name'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'status': status};
}

class CertificateAgency {
  final String? id;
  final String? name;
  final int? status;

  CertificateAgency({this.id, this.name, this.status});

  factory CertificateAgency.fromJson(Map<String, dynamic> json) =>
      CertificateAgency(
        id: json['_id'],
        name: json['name'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'status': status};
}

class CurrentSubscription {
  final String? id;
  final Plan? planId;

  final int? startDate;
  final int? endDate;
  final int? trialStart;
  final int? trialEnd;

  final double? amount;
  final String? currency;
  final String? interval;

  const CurrentSubscription({
    required this.id,
    this.planId,
    this.startDate,
    this.endDate,
    this.trialStart,
    this.trialEnd,
    this.amount,
    this.currency,
    this.interval,
  });

  factory CurrentSubscription.fromJson(Map<String, dynamic> json) {
    return CurrentSubscription(
      id: json['_id'].toString(),
      planId: json['planId'] != null ? Plan.fromJson(json['planId']) : null,
      startDate: json['startDate'],
      endDate: json['endDate'],
      trialStart: json['trialStart'],
      trialEnd: json['trialEnd'],

      amount: (json['amount'] as num?)?.toDouble(),
      currency: json['currency'],
      interval: json['interval'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'planId': planId?.toJson(),
    'startDate': startDate,
    'endDate': endDate,
    'trialStart': trialStart,
    'trialEnd': trialEnd,
    'amount': amount,
    'currency': currency,
    'interval': interval,
  };
}

class Plan {
  final String? id;
  final String? name;
  final int? status;

  Plan({this.id, this.name, this.status});

  factory Plan.fromJson(Map<String, dynamic> json) =>
      Plan(id: json['_id'], name: json['name'], status: json['status']);

  Map<String, dynamic> toJson() => {'_id': id, 'name': name, 'status': status};
}

class Device {
  final String? deviceToken;
  final String? deviceType;

  Device({this.deviceToken, this.deviceType});

  factory Device.fromJson(Map<String, dynamic> json) =>
      Device(deviceToken: json['deviceToken'], deviceType: json['deviceType']);

  Map<String, dynamic> toJson() => {
    'deviceToken': deviceToken,
    'deviceType': deviceType,
  };
}
