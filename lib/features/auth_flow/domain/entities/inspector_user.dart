import 'package:equatable/equatable.dart';
import 'package:inspect_connect/features/auth_flow/data/models/user_document_data_model.dart';

class InspectorUser extends Equatable {
  final String id;
  final int role;
  final String email;
  final String name;
  final String profileImage;
  final int status;
  final String phoneNumber;
  final String countryCode;
  final bool bookingInProgress;
  final bool isDeleted;
  final String country;
  final String state;
  final String city;
  final Map<String, dynamic> location;
  final String mailingAddress;
  final String certificateTypeId;
  final List<String> certificateAgencyIds;
  final List<String> certificateDocuments;
  final String certificateExpiryDate;
  final List<String> referenceDocuments;
  final UserDocumentDataModel? uploadedIdOrLicenseDocument;
  final String? workHistoryDescription;
  final bool phoneOtpVerified;
  final bool emailOtpVerified;
  final bool agreedToTerms;
  final bool isTruthfully;
  final String? stripeCustomerId;
  final String? authToken;

  const InspectorUser({
    required this.id,
    required this.role,
    required this.email,
    required this.name,
    required this.profileImage,
    required this.status,
    required this.phoneNumber,
    required this.countryCode,
    required this.bookingInProgress,
    required this.isDeleted,
    required this.country,
    required this.state,
    required this.city,
    required this.location,
    required this.mailingAddress,
    required this.certificateTypeId,
    required this.certificateAgencyIds,
    required this.certificateDocuments,
    required this.certificateExpiryDate,
    required this.referenceDocuments,
    required this.uploadedIdOrLicenseDocument,
    required this.workHistoryDescription,
    required this.phoneOtpVerified,
    required this.emailOtpVerified,
    required this.agreedToTerms,
    required this.isTruthfully,
    required this.stripeCustomerId,
    required this.authToken,
  });

  factory InspectorUser.fromJson(Map<String, dynamic> json) => InspectorUser(
    id: json["_id"],
    role: json["role"],
    email: json["email"],
    name: json["name"],
    profileImage: json["profileImage"],
    status: json["status"],
    phoneNumber: json["phoneNumber"],
    countryCode: json["countryCode"],
    bookingInProgress: json["bookingInProgress"],
    isDeleted: json["isDeleted"],
    country: json["country"],
    state: json["state"],
    city: json["city"],
    location: json["location"],
    mailingAddress: json["mailingAddress"],
    certificateTypeId: json["certificateTypeId"],
    certificateAgencyIds: List<String>.from(json["certificateAgencyIds"] ?? []),
    certificateDocuments: List<String>.from(json["certificateDocuments"] ?? []),
    certificateExpiryDate: json["certificateExpiryDate"],
    referenceDocuments: List<String>.from(json["referenceDocuments"] ?? []),
    uploadedIdOrLicenseDocument: json['uploadedIdOrLicenseDocument'] != null
        ? UserDocumentDataModel.fromJson(json['uploadedIdOrLicenseDocument'])
        : null,

    workHistoryDescription: json["workHistoryDescription"],
    phoneOtpVerified: json["phoneOtpVerified"],
    emailOtpVerified: json["emailOtpVerified"],
    agreedToTerms: json["agreedToTerms"],
    isTruthfully: json["isTruthfully"],
    stripeCustomerId: json["stripeCustomerId"],
    authToken: json["authToken"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "role": role,
    "email": email,
    "name": name,
    "profileImage": profileImage,
    "status": status,
    "phoneNumber": phoneNumber,
    "countryCode": countryCode,
    "bookingInProgress": bookingInProgress,
    "isDeleted": isDeleted,
    "country": country,
    "state": state,
    "city": city,
    "location": location,
    "mailingAddress": mailingAddress,
    "certificateTypeId": certificateTypeId,
    "certificateAgencyIds": certificateAgencyIds,
    "certificateDocuments": certificateDocuments,
    "certificateExpiryDate": certificateExpiryDate,
    "referenceDocuments": referenceDocuments,
    "uploadedIdOrLicenseDocument": uploadedIdOrLicenseDocument,
    "workHistoryDescription": workHistoryDescription,
    "phoneOtpVerified": phoneOtpVerified,
    "emailOtpVerified": emailOtpVerified,
    "agreedToTerms": agreedToTerms,
    "isTruthfully": isTruthfully,
    "stripeCustomerId": stripeCustomerId,
    "authToken": authToken,
  };

  @override
  List<Object?> get props => [
    id,
    role,
    email,
    name,
    profileImage,
    status,
    phoneNumber,
    countryCode,
    bookingInProgress,
    isDeleted,
    country,
    state,
    city,
    location,
    mailingAddress,
    certificateTypeId,
    certificateAgencyIds,
    certificateDocuments,
    certificateExpiryDate,
    referenceDocuments,
    uploadedIdOrLicenseDocument,
    workHistoryDescription,
    phoneOtpVerified,
    emailOtpVerified,
    agreedToTerms,
    isTruthfully,
    stripeCustomerId,
    authToken,
  ];
}

extension InspectorUserMapping on InspectorUser {
  InspectorUser toLocalEntity() {
    return InspectorUser(
      id: id,
      bookingInProgress: bookingInProgress,
      certificateAgencyIds: certificateAgencyIds,
      certificateDocuments: certificateDocuments,
      certificateExpiryDate: certificateExpiryDate,
      isDeleted: isDeleted,
      location: location,
      referenceDocuments: referenceDocuments,
      role: role,
      status: status,
      authToken: authToken,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      countryCode: countryCode,
      mailingAddress: mailingAddress,
      profileImage: profileImage,
      certificateTypeId: certificateTypeId,
      country: country,
      state: state,
      city: city,
      phoneOtpVerified: phoneOtpVerified,
      emailOtpVerified: emailOtpVerified,
      agreedToTerms: agreedToTerms,
      isTruthfully: isTruthfully,
      stripeCustomerId: stripeCustomerId,
      uploadedIdOrLicenseDocument: uploadedIdOrLicenseDocument,
      workHistoryDescription: workHistoryDescription,
    );
  }
}
