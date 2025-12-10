import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
class InspectorSignUpLocalEntity {
  int id;

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

  @Backlink('inspector')
  final serviceAreas = ToMany<ServiceAreaLocalEntity>();

  InspectorSignUpLocalEntity({
    this.id = 0,
    this.name,
    this.email,
    this.password,
    this.phoneNumber,
    this.countryCode,
    this.isoCode,
    this.certificateTypeId,
    this.certificateExpiryDate,
    this.certificateDocuments,
    this.certificateAgencyIds,
    this.country,
    this.state,
    this.city,
    this.zipCode,
    this.mailingAddress,
    this.uploadedIdOrLicenseDocument,
    this.workHistoryDescription,
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
      "isoCode": isoCode,
      "certificateTypeId": certificateTypeId,
      "certificateExpiryDate": certificateExpiryDate,
      "certificateDocuments": certificateDocuments,
      "certificateAgencyIds": certificateAgencyIds,
      "country": country,
      "state": state,
      "city": city,
      "zip": zipCode,
      "mailingAddress": mailingAddress,
      "uploadedIdOrLicenseDocument": uploadedIdOrLicenseDocument,
      "workHistoryDescription": workHistoryDescription,
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
        "coordinates": [longitude, latitude],
      },

      "serviceAreas": serviceAreas.map((s) {
        return {
          "countryCode": s.countryCode,
          "stateCode": s.stateCode,
          "cityName": s.cityName,
          "location": {
            "type": s.locationType,
            "coordinates": [s.longitude, s.latitude],
          }
        };
      }).toList(),
    };

    map.removeWhere((k, v) => v == null);
    return map;
  }
}
