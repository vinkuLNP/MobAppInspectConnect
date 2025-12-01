import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_agency_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';

abstract class AuthRepository {
   Future<ApiResultModel<List<CertificateInspectorTypeEntity>>>  getCertificateTypes();
    Future<ApiResultModel<List<AgencyEntity>>>  getCertificateAgency();
  Future<ApiResultModel<AuthUser>> signIn({
    required String email,
    required String password,
    required String deviceToken,
    required String deviceType,
  });

   Future<ApiResultModel<AuthUser>> signUp({
    required int role,
  required String email,
  required String name,
  required String phoneNumber,
  required String countryCode,
  required String password,
  required String deviceToken,
  required String deviceType,
  required String mailingAddress,
  required bool agreedToTerms,
  required bool isTruthfully,
  required Map<String, dynamic> location,
  });
 Future<ApiResultModel<AuthUser>> verifyOtp({
    required String phoneOtp,
    required String phoneNumber,
    required String countryCode,
  });

   Future<ApiResultModel<AuthUser>> inspectorSignUp({
    required InspectorSignUpLocalEntity inspectorSignUpLocalEntity
  });

   Future<ApiResultModel<AuthUser>> resendOtp({
    required String phoneNumber,
    required String countryCode,
  });

       Future<ApiResultModel<AuthUser>>changePassword({
    required String currentPassword,
    required String newPassword,
  });

       Future<ApiResultModel<UserDetail>>fetchUserDetail(
        {
    required String userId,
  });
      Future<ApiResultModel<AuthUser>>updateProfile({
    required String name,
  });

}