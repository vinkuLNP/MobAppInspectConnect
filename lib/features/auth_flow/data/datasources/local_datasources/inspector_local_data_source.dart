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
        // final entity = InspectorSignUpLocalEntity()..id = 1;
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
        // personal
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

        // professional
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

        // service area
        case 'country':
          entity.country = v as String?;
          break;
        case 'state':
          entity.state = v as String?;
          break;
        case 'city':
          entity.city = v as String?;
          break;

        // additional
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

        // location
        case 'locationType':
          entity.locationType = v as String?;
          break;
        case 'locationName':
          entity.locationName = v as String?;
          break;
        case 'latitude':
          entity.latitude = (v is double) ? v : (v != null ? double.parse(v.toString()) : null);
          break;
        case 'longitude':
          entity.longitude = (v is double) ? v : (v != null ? double.parse(v.toString()) : null);
          break;

        // common
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

    _database.insert(entity); // insert will update if id present
 log('✅ After update: ${entity.name.toString()}');
  }

  /// 🔍 Get final record
  Future<InspectorSignUpLocalEntity?> getFullData() async {
    final list = await _database.getAll<InspectorSignUpLocalEntity>();
    if (list != null && list.isNotEmpty) {
      return list.first;
    }
    return null;
  }

  /// ❌ Clear all inspector signup data
  Future<void> clear() async {
    _database.clear<InspectorSignUpLocalEntity>();
  }
}


// Future<void> updateStepData({
//   required Map<String, dynamic> data,
// }) async {
//   final entity = await _getOrCreate();

//   data.forEach((key, value) {
//     switch (key) {
//       case 'name':
//         entity.name = value;
//         break;
//       case 'email':
//         entity.email = value;
//         break;
//       case 'password':
//         entity.password = value;
//         break;
//       case 'phoneNumber':
//         entity.phoneNumber = value;
//         break;
//       case 'countryCode':
//         entity.countryCode = value;
//         break;
//       case 'certificateTypeId':
//         entity.certificateTypeId = value;
//         break;
//       case 'certificateExpiryDate':
//         entity.certificateExpiryDate = value;
//         break;
//       case 'certificateDocuments':
//         entity.certificateDocuments = List<String>.from(value);
//         break;
//       case 'certificateAgencyIds':
//         entity.certificateAgencyIds = List<String>.from(value);
//         break;
//       case 'country':
//         entity.country = value;
//         break;
//       case 'state':
//         entity.state = value;
//         break;
//       case 'city':
//         entity.city = value;
//         break;
//       case 'mailingAddress':
//         entity.mailingAddress = value;
//         break;
//       case 'uploadedIdOrLicenseDocument':
//         entity.uploadedIdOrLicenseDocument = value;
//         break;
//       case 'referenceDocuments':
//         entity.referenceDocuments = List<String>.from(value);
//         break;
//       case 'profileImage':
//         entity.profileImage = value;
//         break;
//       case 'agreedToTerms':
//         entity.agreedToTerms = value;
//         break;
//       case 'isTruthfully':
//         entity.isTruthfully = value;
//         break;
//       case 'role':
//         entity.role = value;
//         break;
//       case 'deviceType':
//         entity.deviceType = value;
//         break;
//       case 'deviceToken':
//         entity.deviceToken = value;
//         break;
//       case 'locationType':
//         entity.locationType = value;
//         break;
//       case 'locationName':
//         entity.locationName = value;
//         break;
//       case 'latitude':
//         entity.latitude = value;
//         break;
//       case 'longitude':
//         entity.longitude = value;
//         break;
//     }
//   });

//   _database.insert(entity);
// }

// // import 'package:injectable/injectable.dart';
// // import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/app_local_database.dart';
// // import 'inspector_signup_local_entity.dart';

// // @injectable
// // class InspectorSignUpLocalDataSource {
// //   final AppLocalDatabase _db;
// //   InspectorSignUpLocalDataSource(this._db);

// //   /// get existing or create a new single record
// //   Future<InspectorSignUpLocalEntity> _getOrCreate() async {
// //     final list = await _db.getAll<InspectorSignUpLocalEntity>();
// //     if (list != null && list.isNotEmpty) return list.first;
// //     final e = InspectorSignUpLocalEntity();
// //     _db.insert(e);
// //     final created = await _db.getAll<InspectorSignUpLocalEntity>();
// //     return created!.first;
// //   }

// //   /// Update only provided fields, preserving the rest.
// //   Future<void> updateFields(Map<String, dynamic> fields) async {
// //     final entity = await _getOrCreate();

// //     fields.forEach((k, v) {
// //       switch (k) {
// //         // personal
// //         case 'name':
// //           entity.name = v as String?;
// //           break;
// //         case 'phoneNumber':
// //           entity.phoneNumber = v as String?;
// //           break;
// //         case 'countryCode':
// //           entity.countryCode = v as String?;
// //           break;
// //         case 'email':
// //           entity.email = v as String?;
// //           break;
// //         case 'password':
// //           entity.password = v as String?;
// //           break;
// //         case 'mailingAddress':
// //           entity.mailingAddress = v as String?;
// //           break;

// //         // professional
// //         case 'certificateTypeId':
// //           entity.certificateTypeId = v as String?;
// //           break;
// //         case 'certificateExpiryDate':
// //           entity.certificateExpiryDate = v as String?;
// //           break;
// //         case 'certificateDocuments':
// //           entity.certificateDocuments = List<String>.from(v as Iterable);
// //           break;
// //         case 'certificateAgencyIds':
// //           entity.certificateAgencyIds = List<String>.from(v as Iterable);
// //           break;

// //         // service area
// //         case 'country':
// //           entity.country = v as String?;
// //           break;
// //         case 'state':
// //           entity.state = v as String?;
// //           break;
// //         case 'city':
// //           entity.city = v as String?;
// //           break;

// //         // additional
// //         case 'profileImage':
// //           entity.profileImage = v as String?;
// //           break;
// //         case 'uploadedIdOrLicenseDocument':
// //           entity.uploadedIdOrLicenseDocument = v as String?;
// //           break;
// //         case 'referenceDocuments':
// //           entity.referenceDocuments = List<String>.from(v as Iterable);
// //           break;
// //         case 'agreedToTerms':
// //           entity.agreedToTerms = v as bool?;
// //           break;
// //         case 'isTruthfully':
// //           entity.isTruthfully = v as bool?;
// //           break;

// //         // location
// //         case 'locationType':
// //           entity.locationType = v as String?;
// //           break;
// //         case 'locationName':
// //           entity.locationName = v as String?;
// //           break;
// //         case 'latitude':
// //           entity.latitude = (v is double) ? v : (v != null ? double.parse(v.toString()) : null);
// //           break;
// //         case 'longitude':
// //           entity.longitude = (v is double) ? v : (v != null ? double.parse(v.toString()) : null);
// //           break;

// //         // common
// //         case 'role':
// //           entity.role = v as int?;
// //           break;
// //         case 'deviceType':
// //           entity.deviceType = v as String?;
// //           break;
// //         case 'deviceToken':
// //           entity.deviceToken = v as String?;
// //           break;
// //       }
// //     });

// //     _db.insert(entity); // insert will update if id present
// //   }

// //   Future<InspectorSignUpLocalEntity?> getFullData() async {
// //     final list = await _db.getAll<InspectorSignUpLocalEntity>();
// //     return (list != null && list.isNotEmpty) ? list.first : null;
// //   }

// //   Future<void> clear() async {
// //     _db.clear<InspectorSignUpLocalEntity>();
// //   }
// // }
