import 'dart:convert';
import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/app_local_database.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/icc_document_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/service_area_entity.dart';

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

    entity.serviceAreas.length;
    if (entity.iccDocuments.isNotEmpty) {
      log(
        'Before update:  ${entity.name.toString()} ----- icc doc: ${entity.iccDocuments[0].documentUrl.toString()}    ${entity.iccDocuments[0].serviceCity.toString()} ----- zipcode : ${entity.serviceAreas[0].cityName.toString()} zipcode : ${entity.serviceAreas[0].zipCode.toString()}  certificate dfocuments ${entity.certificateDocuments}',
      );
    }

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
        case 'zip':
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
          if (v != null) entity.profileImage = v as String?;
          break;
        case 'uploadedIdOrLicenseDocument':
          if (v != null) entity.uploadedIdOrLicenseDocument = v as String?;
          break;
        case 'documentTypeId':
          if (v != null) entity.documentTypeId = v as String?;
          break;
        case 'documentExpiryDate':
          if (v != null) entity.documentExpiryDate = v as String?;
          break;
        case 'uploadedCoiDocument':
          if (v != null) entity.uploadedCoiDocument = v as String?;
          break;
        case 'coiExpiryDate':
          if (v != null) entity.coiExpiryDate = v as String?;
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
          entity.latitude = (v is double) ? v : double.tryParse(v.toString());
          break;
        case 'longitude':
          entity.longitude = (v is double) ? v : double.tryParse(v.toString());
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

        case 'iccDocuments':
          entity.iccDocuments.clear();
          for (final d in v) {
            entity.iccDocuments.add(
              IccDocumentLocalEntity(
                serviceCity: d['serviceCity'],
                documentUrl: d['documentUrl'],
                expiryDate: d['expiryDate'],
              ),
            );
          }
          break;
        case 'serviceAreas':
          if (v is Iterable) {
            for (var old in entity.serviceAreas) {
              _database.removeServiceArea(old.id);
            }

            entity.serviceAreas.clear();
            for (var s in v) {
              final loc = s['location'] as Map<String, dynamic>?;

              final sa = ServiceAreaLocalEntity(
                countryCode: s['countryCode'] as String?,
                stateCode: s['stateCode'] as String?,
                cityName: s['cityName'] as String?,
                zipCode: s['zipCode'] as String?,
                locationType: loc?['type'] as String?,
                latitude: (loc != null)
                    ? double.tryParse(loc['coordinates'][1].toString())
                    : null,
                longitude: (loc != null)
                    ? double.tryParse(loc['coordinates'][0].toString())
                    : null,
              );

              sa.inspector.target = entity;
              _database.saveServiceArea(sa);
              entity.serviceAreas.add(sa);
            }
          }
          break;
      }
    });

    _database.saveInspector(entity);
    if (entity.iccDocuments.isNotEmpty) {
      log(
        'After update:   ${entity.name.toString()} ----- icc doc: ${entity.iccDocuments[0].documentUrl.toString()}    ${entity.iccDocuments[0].serviceCity.toString()} ----- zipcode : ${entity.serviceAreas[0].cityName.toString()} zipcode : ${entity.serviceAreas[0].zipCode.toString()}  certificate dfocuments ${entity.certificateDocuments}',
      );
    }
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
