import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/get_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/multipart_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_context.dart';
import 'package:inspect_connect/features/common_features/data/dto/upload_image_dto.dart';
import 'package:inspect_connect/features/common_features/data/models/certificate_inspector_type_datamodel.dart';
import 'package:inspect_connect/features/common_features/data/models/upload_image_model.dart';

abstract class CommonRemoteDataSource {
  Future<ApiResultModel<List<CertificateInspectorTypeModelData>>>
  fetchCertificateTypes();

  Future<ApiResultModel<UploadImageResponseModel>> uploadImage({
    required UploadImageDto uploadImageDto,
  });
}

class CommonRemoteDataSourceImpl implements CommonRemoteDataSource {
  final HttpRequestContext _ctx;

  CommonRemoteDataSourceImpl(this._ctx);

  @override
  Future<ApiResultModel<List<CertificateInspectorTypeModelData>>>
  fetchCertificateTypes() async {
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
          message: networkError,
          statusCode: 500,
        ),
      );
    }
  }

  @override
  Future<ApiResultModel<UploadImageResponseModel>> uploadImage({
    required UploadImageDto uploadImageDto,
  }) async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: uploadImageEndPoint,
        httpRequestStrategy: MultipartPostRequestStrategy(),
        headers: {"Content-Type": "multipart/form-data"},
        requestData: uploadImageDto.toJson(),
      );
      return res.when(
        success: (http.Response response) {
          final Map<String, dynamic> root = response.body.isEmpty
              ? {}
              : (jsonDecode(response.body) as Map<String, dynamic>);
          final data = root['body'] as Map<String, dynamic>? ?? {};
          final dto = UploadImageResponseModel.fromJson(data);
          return ApiResultModel<UploadImageResponseModel>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<UploadImageResponseModel>.failure(
              errorResultEntity: e,
            ),
      );
    } catch (e) {
      log('upload image error------> $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: networkError,
          statusCode: 500,
        ),
      );
    }
  }
}
