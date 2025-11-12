import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/app_local_database.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';

@injectable
class InspectorSignUpLocalDataSource {
  final AppLocalDatabase _database;

  InspectorSignUpLocalDataSource(this._database);

  Future<InspectorSignUpLocalEntity> _getOrCreate() async {
    final list = await _database.getAll<InspectorSignUpLocalEntity>();
    if (list != null && list.isNotEmpty) {
      return list.first;
    } else {
      final entity = InspectorSignUpLocalEntity();
      _database.insert(entity);
      return entity;
    }
  }

  Future<void> updateFields(Map<String, dynamic> fields) async {
    final entity = await _getOrCreate();

    log('📝 Before update: ${entity.name.toString()}');
    log('Updating fields: $fields');
    fields.forEach((k, v) {
      switch (k) {
        case 'name':
          entity.name = v as String?;
          break;
        case 'phoneNumber':
          entity.phoneNumber = v as String?;
          break;
        case 'countryCode':
          entity.countryCode = v as String?;
          break;
        case 'email':
          entity.email = v as String?;
          break;
        case 'password':
          entity.password = v as String?;
          break;
        case 'mailingAddress':
          entity.mailingAddress = v as String?;
          break;
        case 'certificateTypeId':
          entity.certificateTypeId = v as String?;
          break;
        case 'certificateExpiryDate':
          entity.certificateExpiryDate = v as String?;
          break;
        case 'certificateDocuments':
          entity.certificateDocuments = List<String>.from(v as Iterable);
          break;
        case 'certificateAgencyIds':
          entity.certificateAgencyIds = List<String>.from(v as Iterable);
          break;
        case 'country':
          entity.country = v as String?;
          break;
        case 'zipCode':
          entity.zipCode = v as String?;
          break;
        case 'workHistoryDescription':
          entity.workHistoryDescription = v as String?;
          break;
        case 'state':
          entity.state = v as String?;
          break;
        case 'city':
          entity.city = v as String?;
          break;
        case 'profileImage':
          entity.profileImage = v as String?;
          break;
        case 'uploadedIdOrLicenseDocument':
          entity.uploadedIdOrLicenseDocument = v as String?;
          break;
        case 'referenceDocuments':
          entity.referenceDocuments = List<String>.from(v as Iterable);
          break;
        case 'agreedToTerms':
          entity.agreedToTerms = v as bool?;
          break;
        case 'isTruthfully':
          entity.isTruthfully = v as bool?;
          break;
        case 'locationType':
          entity.locationType = v as String?;
          break;
        case 'locationName':
          entity.locationName = v as String?;
          break;
        case 'latitude':
          entity.latitude = (v is double)
              ? v
              : (v != null ? double.parse(v.toString()) : null);
          break;
        case 'longitude':
          entity.longitude = (v is double)
              ? v
              : (v != null ? double.parse(v.toString()) : null);
          break;
        case 'role':
          entity.role = v as int?;
          break;
        case 'deviceType':
          entity.deviceType = v as String?;
          break;
        case 'deviceToken':
          entity.deviceToken = v as String?;
          break;
      }
    });

    _database.insert(entity);
    log(
      '✅ After update: ${entity.name.toString()}-----zipcode ${entity.zipCode.toString()}',
    );
  }

  Future<InspectorSignUpLocalEntity?> getFullData() async {
    final list = await _database.getAll<InspectorSignUpLocalEntity>();
    if (list != null && list.isNotEmpty) {
      log(
        '🔍 Retrieved inspector signup data: ${jsonEncode(list.first.toJson())}',
      );
      return list.first;
    }
    return null;
  }

  Future<void> clear() async {
    _database.clear<InspectorSignUpLocalEntity>();
  }
}
