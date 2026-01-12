import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/remote_datasources/auth_remote_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/models/change_password_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/profile_update_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/resend_otp_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/signin_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/signup_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/user_detail_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/verify_otp_request_model.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/auth_user.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_agency_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_documents_type.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/jurisdiction_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/settings_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';
import 'package:inspect_connect/features/auth_flow/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  AuthRepositoryImpl(this._remote);

  @override
  Future<ApiResultModel<List<CertificateInspectorTypeEntity>>>
  getCertificateTypes() {
    return _remote.getCertificateType();
  }

  @override
  Future<ApiResultModel<List<JurisdictionEntity>>> getJurisdictionCities() {
    return _remote.getJurisdictionCities();
  }

  @override
  Future<ApiResultModel<SettingEntity>> getSettings(String type) {
    return _remote.getSettings(type);
  }

  @override
  Future<ApiResultModel<List<InspectorDocumentsTypeEntity>>>
  getIsnpectorDocumentsType() {
    return _remote.getIsnpectorDocumentsType();
  }

  @override
  Future<ApiResultModel<List<AgencyEntity>>> getCertificateAgency() {
    return _remote.getCertificateAgency();
  }

  @override
  Future<ApiResultModel<AuthUser>> signIn({
    required String email,
    required String password,
    required String deviceToken,
    required String deviceType,
  }) async {
    final res = await _remote.signIn(
      SignInRequestDto(
        email: email,
        password: password,
        deviceToken: deviceToken,
        deviceType: deviceType,
      ),
    );

    return res.when(
      success: (data) {
        try {
          final user = data.toEntity();
          return ApiResultModel<AuthUser>.success(data: user);
        } catch (e) {
          return const ApiResultModel.failure(
            errorResultEntity: ErrorResultModel(
              message: "Parsing error",
              statusCode: 500,
            ),
          );
        }
      },
      failure: (err) =>
          ApiResultModel<AuthUser>.failure(errorResultEntity: err),
    );
  }

  @override
  Future<ApiResultModel<AuthUser>> inspectorSignUp({
    required InspectorSignUpLocalEntity inspectorSignUpLocalEntity,
  }) async {
    final res = await _remote.inspectorSignUp(inspectorSignUpLocalEntity);

    return res.when(
      success: (dto) {
        try {
          final user = dto.toEntity();
          return ApiResultModel.success(data: user);
        } catch (e) {
          return const ApiResultModel.failure(
            errorResultEntity: ErrorResultModel(
              message: "Parsing error",
              statusCode: 500,
            ),
          );
        }
      },
      failure: (err) =>
          ApiResultModel<AuthUser>.failure(errorResultEntity: err),
    );
  }

  @override
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
    required String zip,
    required bool agreedToTerms,
    required bool isTruthfully,
    required Map<String, dynamic> location,
  }) async {
    final res = await _remote.signUp(
      SignUpRequestDto(
        role: role,
        email: email,
        name: name,
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        password: password,
        deviceToken: deviceToken,
        deviceType: deviceType,
        mailingAddress: mailingAddress,
        zip: zip,
        agreedToTerms: agreedToTerms,
        isTruthfully: isTruthfully,
        location: location,
      ),
    );

    return res.when(
      success: (dto) {
        try {
          return ApiResultModel.success(data: dto.toEntity());
        } catch (e) {
          return const ApiResultModel.failure(
            errorResultEntity: ErrorResultModel(
              message: "Parsing error",
              statusCode: 500,
            ),
          );
        }
      },
      failure: (err) =>
          ApiResultModel<AuthUser>.failure(errorResultEntity: err),
    );
  }

  @override
  Future<ApiResultModel<AuthUser>> verifyOtp({
    required String countryCode,
    required String phoneNumber,
    required String phoneOtp,
  }) async {
    final res = await _remote.verifyOtp(
      VerifyOtpRequestDto(
        countryCode: countryCode,
        phoneNumber: phoneNumber,
        phoneOtp: phoneOtp,
      ),
    );

    return res.when(
      success: (data) {
        try {
          return ApiResultModel.success(data: data.toEntity());
        } catch (e) {
          return const ApiResultModel.failure(
            errorResultEntity: ErrorResultModel(
              message: "Parsing error",
              statusCode: 500,
            ),
          );
        }
      },
      failure: (err) =>
          ApiResultModel<AuthUser>.failure(errorResultEntity: err),
    );
  }

  @override
  Future<ApiResultModel<AuthUser>> resendOtp({
    required String countryCode,
    required String phoneNumber,
  }) async {
    final res = await _remote.resendOtp(
      ResendOtpRequestDto(countryCode: countryCode, phoneNumber: phoneNumber),
    );

    return res.when(
      success: (data) {
        try {
          return ApiResultModel.success(data: data.toEntity());
        } catch (e) {
          return const ApiResultModel.failure(
            errorResultEntity: ErrorResultModel(
              message: "Parsing error",
              statusCode: 500,
            ),
          );
        }
      },
      failure: (err) =>
          ApiResultModel<AuthUser>.failure(errorResultEntity: err),
    );
  }

  @override
  Future<ApiResultModel<AuthUser>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final res = await _remote.changePassword(
      ChangePasswordDto(
        password: newPassword,
        currentPassword: currentPassword,
      ),
    );

    return res.when(
      success: (data) {
        try {
          return ApiResultModel.success(data: data.toEntity());
        } catch (e) {
          return const ApiResultModel.failure(
            errorResultEntity: ErrorResultModel(
              message: "Parsing error",
              statusCode: 500,
            ),
          );
        }
      },
      failure: (err) =>
          ApiResultModel<AuthUser>.failure(errorResultEntity: err),
    );
  }

  @override
  Future<ApiResultModel<AuthUser>> updateProfile({required String name}) async {
    final res = await _remote.updateProfile(ProfileUpdateDto(name: name));

    return res.when(
      success: (data) {
        try {
          return ApiResultModel.success(data: data.toEntity());
        } catch (e) {
          return const ApiResultModel.failure(
            errorResultEntity: ErrorResultModel(
              message: "Parsing error",
              statusCode: 500,
            ),
          );
        }
      },
      failure: (err) =>
          ApiResultModel<AuthUser>.failure(errorResultEntity: err),
    );
  }

  @override
  Future<ApiResultModel<UserDetail>> fetchUserDetail({
    required String userId,
  }) async {
    final res = await _remote.fetchUserDetail(UserDetailDto(userID: userId));

    return res.when(
      success: (data) {
        try {
          return ApiResultModel.success(data: data);
        } catch (e) {
          return const ApiResultModel.failure(
            errorResultEntity: ErrorResultModel(
              message: "Parsing error",
              statusCode: 500,
            ),
          );
        }
      },
      failure: (err) =>
          ApiResultModel<UserDetail>.failure(errorResultEntity: err),
    );
  }
}
