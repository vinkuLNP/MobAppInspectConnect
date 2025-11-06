import 'package:objectbox/objectbox.dart';

@Entity()
class InspectorSignUpLocalEntity {
  int id = 0;

  // --- Step 0: Personal Details ---
  String? name;
  String? email;
  String? password;
  String? phoneNumber;
  String? countryCode;
  String? isoCode;


  // --- Step 2: Professional Details ---
  String? certificateTypeId;
  String? certificateExpiryDate;
  List<String>? certificateDocuments;
  List<String>? certificateAgencyIds;

  // --- Step 3: Service Area ---
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? mailingAddress;

  // --- Step 4: Additional Details ---
  String? uploadedIdOrLicenseDocument;
  List<String>? referenceDocuments;
  String? profileImage;
  bool? agreedToTerms;
  bool? isTruthfully;

  // --- Common Fields ---
  int? role;
  String? deviceType;
  String? deviceToken;

  // --- Geo Location ---
  String? locationType; // e.g. "Point"
  String? locationName;
  double? latitude;
  double? longitude;

  InspectorSignUpLocalEntity({
    this.id = 0,
    this.name,
    this.email,
    this.password,
    this.phoneNumber,
    this.countryCode,
    this.certificateTypeId,
    this.certificateExpiryDate,
    this.certificateDocuments,
    this.certificateAgencyIds,
    this.country,
    this.state,
    this.city,
    this.mailingAddress,
    this.uploadedIdOrLicenseDocument,
    this.referenceDocuments,
    this.profileImage,
    this.agreedToTerms,
    this.isTruthfully,
    this.role,
    this.deviceType,
    this.deviceToken,
    this.locationType,
    this.locationName,
    this.latitude,
    this.isoCode,
    this.longitude,
  });
  
}
extension InspectorSignUpEntityMapper on InspectorSignUpLocalEntity {
  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "isoCode":isoCode,
        "certificateTypeId": certificateTypeId,
        "certificateExpiryDate": certificateExpiryDate,
        "certificateDocuments": certificateDocuments,
        "certificateAgencyIds": certificateAgencyIds,
        "country": country,
        "state": state,
        "city": city,
        "mailingAddress": mailingAddress,
        "uploadedIdOrLicenseDocument": uploadedIdOrLicenseDocument,
        "referenceDocuments": referenceDocuments,
        "profileImage": profileImage,
        "agreedToTerms": agreedToTerms,
        "isTruthfully": isTruthfully,
        "role": role,
        "deviceType": deviceType,
        "deviceToken": deviceToken,
        "location": {
          "type": locationType,
          "locationName": locationName,
          "coordinates": [latitude, longitude],
        },
      };
}
