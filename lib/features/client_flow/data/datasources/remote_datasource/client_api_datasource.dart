import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/get_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/multipart_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/post_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_context.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/certificate_subtype_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';

abstract class BookingRemoteDataSource {
  Future<ApiResultModel<List<CertificateSubTypeModel>>> getCertificateSubTypes();
  Future<ApiResultModel<UploadImageResponseModel>>  uploadImage(UploadImageDto filePath);
  Future<ApiResultModel<CreateBookingResponseModel>> createBooking( BookingEntity bookingEnity);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl(this._ctx);
  final HttpRequestContext _ctx;




  @override

  Future<ApiResultModel<List<CertificateSubTypeModel>>> getCertificateSubTypes() async {
    try {
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: getCertificateSubTypesEndPoint,
        httpRequestStrategy: GetRequestStrategy(),
        // headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
        // requestData: dto.toJson(),
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
                final List<dynamic> list = body['certificateSubTypes'] ?? [];

        final List<CertificateSubTypeModel> dtoList = list
            .map((e) => CertificateSubTypeModel.fromJson(e))
            .toList();

          return ApiResultModel<List<CertificateSubTypeModel>>.success(data: dtoList);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<List<CertificateSubTypeModel>>.failure(errorResultEntity: e),
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
  Future<ApiResultModel<UploadImageResponseModel>> uploadImage(UploadImageDto dto) async {
    try {
         final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: uploadImageEndPoint,
        httpRequestStrategy: MultipartPostRequestStrategy(),
        // headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
        requestData: dto.toJson(),
         headers: {
          'Authorization': 'Bearer ${user.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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
          final dto = UploadImageResponseModel.fromJson(body);
          return ApiResultModel<UploadImageResponseModel>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<UploadImageResponseModel>.failure(errorResultEntity: e),
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
Future<ApiResultModel<CreateBookingResponseModel>> createBooking(BookingEntity dto) async {
  try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
    final ApiResultModel<http.Response> res = await _ctx.makeRequest(
      uri: createBookingEndPoint,
       headers: {
          'Authorization': 'Bearer ${user.token}',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
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

        final dto = CreateBookingResponseModel.fromJson(body);
        return ApiResultModel<CreateBookingResponseModel>.success(data: dto);
      },
      failure: (ErrorResultModel e) =>
          ApiResultModel<CreateBookingResponseModel>.failure(errorResultEntity: e),
    );
  } catch (e) {
    log('createBooking error: $e');
    return const ApiResultModel.failure(
      errorResultEntity: ErrorResultModel(
        message: "Network error occurred",
        statusCode: 500,
      ),
    );
  }
}




}




  // @override
  // Future<ApiResultState<String>> uploadImage(String filePath) async {
  //   final request = http.MultipartRequest(
  //     'POST',
  //     Uri.parse('$baseUrl/api/v1/uploads'),
  //   )
  //     ..headers['Authorization'] = 'Bearer $token'
  //     ..files.add(await http.MultipartFile.fromPath('file', filePath));

  //   final response = await request.send();
  //   final resBody = await response.stream.bytesToString();

  //   if (response.statusCode == 200) {
  //     final json = jsonDecode(resBody);
  //     return json['body']['fileUrl'];
  //   } else {
  //     throw Exception('Image upload failed');
  //   }
  // }

  // @override
  // Future<ApiResultState<CreateBookingResponseModel>> createBooking (BookingEntity bookingEntity) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/api/v1/bookings'),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //     body: jsonEncode(payload),
  //   );

  //   if (response.statusCode == 200) {
  //     return ApiResultState.data(data: true);
  //   } else {
  //     throw Exception('Booking creation failed');
  //   }
  // }



  // @override
  // Future<ApiResultModel<CreateBookingResponseModel>> createBooking(BookingEntity dto) async {
  //   try {
  //     final ApiResultModel<http.Response> res = await _ctx.makeRequest(
  //       uri: signInEndPoint,
  //       httpRequestStrategy: PostRequestStrategy(),
  //       // headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
  //       requestData: dto.toJson(),
  //     );

  //     return res.when(
  //       success: (http.Response response) {
  //         final Map<String, dynamic> root = response.body.isEmpty
  //             ? {}
  //             : (jsonDecode(response.body) as Map<String, dynamic>);
  //         // Backend shape:
  //         // { "success": true, "message": "...", "body": { ... user object ... } }
  //         final Map<String, dynamic> body =
  //             (root['body'] as Map?)?.cast<String, dynamic>() ??
  //             <String, dynamic>{};
  //         final dto = CreateBookingResponseModel.fromJson(body);
  //         return ApiResultModel<CreateBookingResponseModel>.success(data: dto);
  //       },
  //       failure: (ErrorResultModel e) =>
  //           ApiResultModel<CreateBookingResponseModel>.failure(errorResultEntity: e),
  //     );
  //   } catch (e) {
  //     log('autoremoteresopoonse------> $e');
  //     return const ApiResultModel.failure(
  //       errorResultEntity: ErrorResultModel(
  //         message: "Network error occurred",
  //         statusCode: 500,
  //       ),
  //     );
  //   }
  // }

