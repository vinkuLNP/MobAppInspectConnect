import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/get_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/post_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_context.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/payment_intent_response_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/data/models/user_subscription_model.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/payment_intent_dto.dart';
import 'package:inspect_connect/features/inspector_flow/domain/entities/user_subscription_by_id.dart';

abstract class InspectorRemoteDataSource {
  Future<ApiResultModel<List<SubscriptionPlanModel>>> fetchSubscriptionPlans();
  Future<ApiResultModel<UserSubscriptionModel>> getUserSubscriptionModel({
    required UserSubscriptionByIdDto userSubscriptionById,
  });
  Future<ApiResultModel<PaymentIntentModel>> getPaymentIntent({
    required CreatePaymentIntentDto paymentIntentDto,
  });
}

class InspectorRemoteDataSourceImpl implements InspectorRemoteDataSource {
  InspectorRemoteDataSourceImpl(this._ctx);
  final HttpRequestContext _ctx;

  @override
  Future<ApiResultModel<List<SubscriptionPlanModel>>>
  fetchSubscriptionPlans() async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: subscriptionEndPoint,
        httpRequestStrategy: GetRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.authToken}',
          'Accept': 'application/json',
        },
      );

      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final List<dynamic> bodyList = root['body'] as List<dynamic>? ?? [];

          final List<SubscriptionPlanModel> dtoList = bodyList
              .map((e) => SubscriptionPlanModel.fromJson(e))
              .toList();

          return ApiResultModel<List<SubscriptionPlanModel>>.success(
            data: dtoList,
          );
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<List<SubscriptionPlanModel>>.failure(
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
  Future<ApiResultModel<UserSubscriptionModel>> getUserSubscriptionModel({
    required UserSubscriptionByIdDto userSubscriptionById,
  }) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: userSubscriptionByIdEndPoint,
        httpRequestStrategy: PostRequestStrategy(),
        requestData: userSubscriptionById.toJson(),
        headers: {
          'Authorization': 'Bearer ${user.authToken}',
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
          final UserSubscriptionModel userSubscriptionModel =
              UserSubscriptionModel.fromJson(body);

          return ApiResultModel<UserSubscriptionModel>.success(
            data: userSubscriptionModel,
          );
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<UserSubscriptionModel>.failure(errorResultEntity: e),
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
  Future<ApiResultModel<PaymentIntentModel>> getPaymentIntent({
    required CreatePaymentIntentDto paymentIntentDto,
  }) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.authToken == null) {
        throw Exception('User not found in local storage');
      }

      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: paymentIntentEndPOint,
        httpRequestStrategy: PostRequestStrategy(),
        requestData: paymentIntentDto.toJson(),
        headers: {
          'Authorization': 'Bearer ${user.authToken}',
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
          final PaymentIntentModel paymentIntentModel =
              PaymentIntentModel.fromJson(body);

          return ApiResultModel<PaymentIntentModel>.success(
            data: paymentIntentModel,
          );
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<PaymentIntentModel>.failure(errorResultEntity: e),
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
