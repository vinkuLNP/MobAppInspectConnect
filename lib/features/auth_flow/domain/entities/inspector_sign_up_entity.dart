import 'package:objectbox/objectbox.dart';

@Entity()
class InspectorSignUpLocalEntity {
  int id = 0;

  String? name;
  String? email;
  String? password;
  String? phoneNumber;
  String? countryCode;
  String? isoCode;
  String? certificateTypeId;
  String? certificateExpiryDate;
  List<String>? certificateDocuments;
  List<String>? certificateAgencyIds;
  String? country;
  String? state;
  String? city;
  String? zipCode;
  String? mailingAddress;
  String? uploadedIdOrLicenseDocument;
  String? workHistoryDescription;
  List<String>? referenceDocuments;
  String? profileImage;
  bool? agreedToTerms;
  bool? isTruthfully;
  int? role;
  String? deviceType;
  String? deviceToken;
  String? locationType; 
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
    this.workHistoryDescription,
    this.zipCode,
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
Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
        "name": name,
        "email": email,
        "password": password,
        "phoneNumber": phoneNumber,
        "countryCode": countryCode,
        "certificateTypeId": certificateTypeId,
        "certificateExpiryDate": certificateExpiryDate,
        "certificateDocuments": certificateDocuments,
        "certificateAgencyIds": certificateAgencyIds,
        "country": country,
        "state": state,
        "city": city,
        "workHistoryDescription": workHistoryDescription,
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
    map.removeWhere((k, v) => v == null);

    return map;
}}
