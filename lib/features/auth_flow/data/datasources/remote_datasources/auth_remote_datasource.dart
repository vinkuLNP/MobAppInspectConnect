import 'dart:convert';
import 'dart:developer';

import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/get_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/post_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/put_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_context.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/models/agency_certificate_data_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/auth_user_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/certificate_inspector_type_datamodel.dart';
import 'package:inspect_connect/features/auth_flow/data/models/change_password_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/inspector_document_types_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/jurisdiction_data_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/profile_update_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/resend_otp_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/signin_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/signup_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/user_detail_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/verify_otp_request_model.dart';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_sign_up_entity.dart';

import 'package:inspect_connect/features/auth_flow/domain/entities/user_detail.dart';

abstract class AuthRemoteDataSource {
  Future<ApiResultModel<AuthUserDto>> signIn(SignInRequestDto dto);
  Future<ApiResultModel<AuthUserDto>> signUp(SignUpRequestDto dto);
  Future<ApiResultModel<AuthUserDto>> verifyOtp(VerifyOtpRequestDto dto);
  Future<ApiResultModel<AuthUserDto>> resendOtp(ResendOtpRequestDto dto);
  Future<ApiResultModel<AuthUserDto>> changePassword(ChangePasswordDto dto);
  Future<ApiResultModel<AuthUserDto>> inspectorSignUp(
    InspectorSignUpLocalEntity dto,
  );

  Future<ApiResultModel<AuthUserDto>> updateProfile(ProfileUpdateDto dto);

  Future<ApiResultModel<UserDetail>> fetchUserDetail(UserDetailDto dto);

  Future<ApiResultModel<List<CertificateInspectorTypeModelData>>>
  getCertificateType();
  Future<ApiResultModel<List<JurisdictionDataModel>>> getJurisdictionCities();
  Future<ApiResultModel<List<InspectorDocumentTypesDataModel>>>
  getIsnpectorDocumentsType();
  Future<ApiResultModel<List<AgencyModel>>> getCertificateAgency();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._ctx);
  final HttpRequestContext _ctx;

  @override
  Future<ApiResultModel<AuthUserDto>> signIn(SignInRequestDto dto) async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: signInEndPoint,
        httpRequestStrategy: PostRequestStrategy(),
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final Map<String, dynamic> body =
              (root['body'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{};
          log('--------------->body$body');
          final dto = AuthUserDto.fromBody(body);
          return ApiResultModel<AuthUserDto>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<AuthUserDto>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<AuthUserDto>> signUp(SignUpRequestDto dto) async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: signUpEndPoint,
        httpRequestStrategy: PostRequestStrategy(),
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final Map<String, dynamic> body =
              (root['body'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{};
          final dto = AuthUserDto.fromBody(body);
          final localEntity = AuthUserLocalEntity(
            authToken: dto.authToken,
            name: dto.name,
            email: dto.email,
            phoneNumber: dto.phoneNumber,
            countryCode: dto.countryCode,
            userId: dto.userId,
          );
          locator<AuthLocalDataSource>().saveUser(localEntity);
          log('------>local user----> localEntity');
          return ApiResultModel<AuthUserDto>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<AuthUserDto>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('signup error: $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<AuthUserDto>> inspectorSignUp(
    InspectorSignUpLocalEntity dto,
  ) async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: signUpEndPoint,
        httpRequestStrategy: PostRequestStrategy(),
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final Map<String, dynamic> body =
              (root['body'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{};
          final dto = AuthUserDto.fromBody(body);
          log('------>local user----> localEntity');
          return ApiResultModel<AuthUserDto>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<AuthUserDto>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('signup error: $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<AuthUserDto>> verifyOtp(VerifyOtpRequestDto dto) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }
      log('------>user------------->$user');
      log('------>user-------token------>${user.authToken}');
      log('------>user-------phone------>${user.phoneNumber}');
      log('------>user-------code------>${user.countryCode}');

      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: verifyOtpndPoint,
        httpRequestStrategy: PostRequestStrategy(),
        headers: {
          'Authorization': '${user.authToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          Map<String, dynamic>? user = root['body']?['user'] ?? root['body'];
          final dto = AuthUserDto.fromBody(user!);
          return ApiResultModel<AuthUserDto>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<AuthUserDto>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<UserDetail>> fetchUserDetail(UserDetailDto dto) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }
      log('------>user---user ca;;ed---------->$user');
      log('------>user-------token------>${user.authToken}');
      log('------>user-------phone------>${user.phoneNumber}');
      log('------>user-------code------>${user.countryCode}');

      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: updateUser,
        httpRequestStrategy: GetRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.authToken}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final Map<String, dynamic> body =
              (root['body'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{};
          log('----------datat calling----->${body.toString()}');

          log(
            '----------datat calling----->${jsonDecode(response.body).toString()}',
          );

          final dto = UserDetail.fromJson(body);
          return ApiResultModel<UserDetail>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<UserDetail>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<AuthUserDto>> resendOtp(ResendOtpRequestDto dto) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }
      log('------>user------------->$user');
      log('------>user-------token------>${user.authToken}');
      log('------>user-------phone------>${user.phoneNumber}');
      log('------>user-------code------>${user.countryCode}');
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: resendOtpEndPoint,
        httpRequestStrategy: PostRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.authToken}',
          'Content-Type': 'application/json',
        },
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final Map<String, dynamic> body =
              (root['body'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{};
          final dto = AuthUserDto.fromBody(body);
          return ApiResultModel<AuthUserDto>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<AuthUserDto>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<AuthUserDto>> changePassword(
    ChangePasswordDto dto,
  ) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }
      log('------>user------------->$user');
      log('------>user-------token------>${user.authToken}');
      log('------>user-------phone------>${user.phoneNumber}');
      log('------>user-------dto------>${dto.toJson()}');
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: changePasswordEndPoint,
        httpRequestStrategy: PutRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.authToken}',
          'Content-Type': 'application/json',
        },
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final Map<String, dynamic> body =
              (root['body'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{};
          final dto = AuthUserDto.fromBody(body);
          return ApiResultModel<AuthUserDto>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<AuthUserDto>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<AuthUserDto>> updateProfile(
    ProfileUpdateDto dto,
  ) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }
      log('------>user------------->$user');
      log('------>user-------token------>${user.authToken}');
      log('------>user-------phone------>${user.phoneNumber}');
      log('------>user-------dto------>${dto.toJson()}');
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: updateUser,
        httpRequestStrategy: PutRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.authToken}',
          'Content-Type': 'application/json',
        },
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final Map<String, dynamic> body =
              (root['body'] as Map?)?.cast<String, dynamic>() ??
              <String, dynamic>{};
          final dto = AuthUserDto.fromBody(body);
          return ApiResultModel<AuthUserDto>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<AuthUserDto>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<List<JurisdictionDataModel>>>
  getJurisdictionCities() async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: getJurisdictionCitiesEndPoint,
        httpRequestStrategy: GetRequestStrategy(),
      );
      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final List<dynamic> list =
              (root['body']['jurisdictions'] as List?) ?? [];

          final List<JurisdictionDataModel> dtoList = list
              .map((e) => JurisdictionDataModel.fromJson(e))
              .toList();

          return ApiResultModel<List<JurisdictionDataModel>>.success(
            data: dtoList,
          );
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<List<JurisdictionDataModel>>.failure(
              errorResultEntity: e,
            ),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<List<InspectorDocumentTypesDataModel>>>
  getIsnpectorDocumentsType() async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: getInspectorDocumentTypeEndPoint,
        httpRequestStrategy: GetRequestStrategy(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final List<dynamic> list = (root['body'] as List?) ?? [];

          final List<InspectorDocumentTypesDataModel> dtoList = list
              .map((e) => InspectorDocumentTypesDataModel.fromJson(e))
              .toList();

          return ApiResultModel<List<InspectorDocumentTypesDataModel>>.success(
            data: dtoList,
          );
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<List<InspectorDocumentTypesDataModel>>.failure(
              errorResultEntity: e,
            ),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<List<CertificateInspectorTypeModelData>>>
  getCertificateType() async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: getInspectorCertificateTypesEndPoint,
        httpRequestStrategy: GetRequestStrategy(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final List<dynamic> list = (root['body'] as List?) ?? [];

          final List<CertificateInspectorTypeModelData> dtoList = list
              .map((e) => CertificateInspectorTypeModelData.fromJson(e))
              .toList();

          return ApiResultModel<
            List<CertificateInspectorTypeModelData>
          >.success(data: dtoList);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<List<CertificateInspectorTypeModelData>>.failure(
              errorResultEntity: e,
            ),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<List<AgencyModel>>> getCertificateAgency() async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: getInspectorCertificateTAgenciesEndPoint,
        httpRequestStrategy: GetRequestStrategy(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final List<dynamic> list = (root['body'] as List?) ?? [];

          final List<AgencyModel> dtoList = list
              .map((e) => AgencyModel.fromJson(e))
              .toList();

          return ApiResultModel<List<AgencyModel>>.success(data: dtoList);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<List<AgencyModel>>.failure(errorResultEntity: e),
      );
    } catch (e) {
      log('autoremoteresopoonse------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Network error occurred",
          statusCode: 500,
        ),
      );
    }
  }
}
