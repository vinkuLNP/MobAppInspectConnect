import 'dart:convert';
import 'dart:developer';

import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/post_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_context.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_user_local_entity.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/auth_flow/data/models/auth_user_dto.dart';
import 'package:inspect_connect/features/auth_flow/data/models/resend_otp_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/signin_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/signup_request_model.dart';
import 'package:inspect_connect/features/auth_flow/data/models/verify_otp_request_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<ApiResultModel<AuthUserDto>> signIn(SignInRequestDto dto);
  Future<ApiResultModel<AuthUserDto>> signUp(SignUpRequestDto dto);
  Future<ApiResultModel<AuthUserDto>> verifyOtp(VerifyOtpRequestDto dto);
  Future<ApiResultModel<AuthUserDto>> resendOtp(ResendOtpRequestDto dto);
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
        // headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          // Backend shape:
          // { "success": true, "message": "...", "body": { ... user object ... } }
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
            token: dto.authToken,
            name: dto.name,
            email: dto.emailHashed,
            phoneNumber: dto.phoneNumber,
            countryCode: dto.countryCode,
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
  Future<ApiResultModel<AuthUserDto>> verifyOtp(VerifyOtpRequestDto dto) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      log('------>user------------->$user');
      log('------>user-------token------>${user.token}');
      log('------>user-------phone------>${user.phoneNumber}');
      log('------>user-------code------>${user.countryCode}');

      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: verifyOtpndPoint,
        httpRequestStrategy: PostRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.token}',
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
  Future<ApiResultModel<AuthUserDto>> resendOtp(ResendOtpRequestDto dto) async {
    try {
       final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      log('------>user------------->$user');
      log('------>user-------token------>${user.token}');
      log('------>user-------phone------>${user.phoneNumber}');
      log('------>user-------code------>${user.countryCode}');
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: resendOtpEndPoint,
        httpRequestStrategy: PostRequestStrategy(),
         headers: {
          'Authorization': 'Bearer ${user.token}',
          'Content-Type': 'application/json',
         },
        requestData: dto.toJson(),
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          // Backend shape:
          // { "success": true, "message": "...", "body": { ... user object ... } }
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
}
