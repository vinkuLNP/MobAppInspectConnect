import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/delete_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/get_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/multipart_put_request_startegy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/multipart_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/post_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/concrete_strategies/put_request_strategy.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_context.dart';
import 'package:inspect_connect/features/auth_flow/data/datasources/local_datasources/auth_local_datasource.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_detail_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_list_response_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/booking_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/certificate_subtype_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/user_payment_list_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/wallet_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/booking_entity.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';

abstract class BookingRemoteDataSource {
  Future<ApiResultModel<List<CertificateSubTypeModel>>>
  getCertificateSubTypes();
  Future<ApiResultModel<UploadImageResponseModel>> uploadImage(
    UploadImageDto filePath,
  );
  Future<ApiResultModel<CreateBookingResponseModel>> createBooking(
    BookingEntity bookingEnity,
  );
  Future<ApiResultModel<List<BookingListModel>>> getBookingList({
    required int page,
    required int perPageLimit,
    String? search,
    String? sortBy,
    String? sortOrder,
    int? status,
  });
   Future<ApiResultModel<WalletModel>>  getUserWalletAmount();
    Future<ApiResultModel<PaymentsBodyModel>>  getUserPaymentList({
   required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
 });
    Future<ApiResultModel<BookingDetailModel>> getBookingDetail(String bookingId);
  Future<ApiResultModel<bool>> deleteBooking(String bookingId);
  Future<ApiResultModel<BookingData>> updateBooking(String bookingId, BookingEntity bookingEntity);

}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  BookingRemoteDataSourceImpl(this._ctx);
  final HttpRequestContext _ctx;

  @override
  Future<ApiResultModel<List<CertificateSubTypeModel>>>
  getCertificateSubTypes() async {
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

          return ApiResultModel<List<CertificateSubTypeModel>>.success(
            data: dtoList,
          );
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<List<CertificateSubTypeModel>>.failure(
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
  Future<ApiResultModel<WalletModel>>
  getUserWalletAmount() async {
    try {
       final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: getCertificateSubTypesEndPoint,
        httpRequestStrategy: GetRequestStrategy(),
         headers: {
          'Authorization': 'Bearer ${user.token}',
          "Content-Type": "multipart/form-data",
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

          final WalletModel data = WalletModel.fromJson(body);

          return ApiResultModel<WalletModel>.success(
            data: data,
          );
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<WalletModel>.failure(
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
  Future<ApiResultModel<PaymentsBodyModel>> getUserPaymentList({
    required int page,
    required int limit,
    String? search,
    String? sortBy,
    String? sortOrder,
    int? status,
  }) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      final queryParams = {
        'page': page.toString(),
        'limit': limit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sortOrder': sortOrder,
      };

      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: createBookingEndPoint,
        requestData: queryParams,
        httpRequestStrategy: GetRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.token}',
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
            final dto = PaymentsBodyModel.fromJson(body);

          return ApiResultModel<PaymentsBodyModel>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<PaymentsBodyModel>.failure(
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
  Future<ApiResultModel<UploadImageResponseModel>> uploadImage(
    UploadImageDto dto,
  ) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: uploadImageEndPoint,
        httpRequestStrategy: MultipartPostRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.token}',
          "Content-Type": "multipart/form-data",
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
          final dto = UploadImageResponseModel.fromJson(body);
          return ApiResultModel<UploadImageResponseModel>.success(data: dto);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<UploadImageResponseModel>.failure(
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
  Future<ApiResultModel<CreateBookingResponseModel>> createBooking(
    BookingEntity dto,
  ) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      log(dto.certificateSubTypeId.toString());
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
            ApiResultModel<CreateBookingResponseModel>.failure(
              errorResultEntity: e,
            ),
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

  @override
  Future<ApiResultModel<List<BookingListModel>>> getBookingList({
    required int page,
    required int perPageLimit,
    String? search,
    String? sortBy,
    String? sortOrder,
    int? status,
  }) async {
    try {
      final user = await locator<AuthLocalDataSource>().getUser();
      if (user == null || user.token == null) {
        throw Exception('User not found in local storage');
      }
      final queryParams = {
        'page': page.toString(),
        'perPageLimit': perPageLimit.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        if (sortBy != null && sortBy.isNotEmpty) 'sortBy': sortBy,
        if (sortOrder != null && sortOrder.isNotEmpty) 'sortOrder': sortOrder,
        if (status != null) 'status': status.toString(),
      };
      final uri = Uri.parse(
        '$createBookingEndPoint',
      ).replace(queryParameters: queryParams);

      final ApiResultModel<http.Response> res = await _ctx.makeRequest(
        uri: createBookingEndPoint,
        requestData: queryParams,
        httpRequestStrategy: GetRequestStrategy(),
        headers: {
          'Authorization': 'Bearer ${user.token}',
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
          final List<dynamic> list = body['users'] ?? [];

          final List<BookingListModel> dtoList = list
              .map((e) => BookingListModel.fromJson(e))
              .toList();

          return ApiResultModel<List<BookingListModel>>.success(data: dtoList);
        },
        failure: (ErrorResultModel e) =>
            ApiResultModel<List<BookingListModel>>.failure(
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
Future<ApiResultModel<BookingDetailModel>> getBookingDetail(String bookingId) async {
  try {
    final user = await locator<AuthLocalDataSource>().getUser();
    if (user == null || user.token == null) {
      throw Exception('User not found in local storage');
    }

    final ApiResultModel<http.Response> res = await _ctx.makeRequest(
      uri: "$createBookingEndPoint/$bookingId",
      httpRequestStrategy: GetRequestStrategy(),
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Accept': 'application/json',
      },
    );

    return res.when(
      success: (response) {
        final Map<String, dynamic> root = response.body.isEmpty
            ? {}
            : (jsonDecode(response.body) as Map<String, dynamic>);
        final Map<String, dynamic> body =
            (root['body'] as Map?)?.cast<String, dynamic>() ?? {};
        final model = BookingDetailModel.fromJson(body);
        return ApiResultModel<BookingDetailModel>.success(data: model);
      },
      failure: (e) => ApiResultModel<BookingDetailModel>.failure(errorResultEntity: e),
    );
  } catch (e) {
    log('getBookingDetail error: $e');
    return const ApiResultModel.failure(
      errorResultEntity: ErrorResultModel(message: "Network error occurred", statusCode: 500),
    );
  }
}



@override
Future<ApiResultModel<bool>> deleteBooking(String bookingId) async {
  try {
    final user = await locator<AuthLocalDataSource>().getUser();
    if (user == null || user.token == null) {
      throw Exception('User not found in local storage');
    }

    final ApiResultModel<http.Response> res = await _ctx.makeRequest(
      uri: "$createBookingEndPoint/$bookingId",
      httpRequestStrategy: DeleteRequestStrategy(),
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Accept': 'application/json',
      },
    );

    return res.when(
      success: (response) => const ApiResultModel<bool>.success(data: true),
      failure: (e) => ApiResultModel<bool>.failure(errorResultEntity: e),
    );
  } catch (e) {
    log('deleteBooking error: $e');
    return const ApiResultModel.failure(
      errorResultEntity: ErrorResultModel(message: "Network error occurred", statusCode: 500),
    );
  }
}

@override
Future<ApiResultModel<BookingData>> updateBooking(String bookingId, BookingEntity booking) async {
  try {
    final user = await locator<AuthLocalDataSource>().getUser();
    if (user == null || user.token == null) {
      throw Exception('User not found in local storage');
    }

    final ApiResultModel<http.Response> res = await _ctx.makeRequest(
      uri: "$createBookingEndPoint/$bookingId",
      httpRequestStrategy: PutRequestStrategy(),
      headers: {
        'Authorization': 'Bearer ${user.token}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      requestData: booking.toJson(),
    );

    return res.when(
      success: (response) {
        final Map<String, dynamic> root = response.body.isEmpty
            ? {}
            : (jsonDecode(response.body) as Map<String, dynamic>);
        final Map<String, dynamic> body =
            (root['body'] as Map?)?.cast<String, dynamic>() ?? {};
        final dto = BookingData.fromJson(body);
        return ApiResultModel<BookingData>.success(data: dto);
      },
      failure: (e) => ApiResultModel<BookingData>.failure(errorResultEntity: e),
    );
  } catch (e) {
    log('updateBooking error: $e');
    return const ApiResultModel.failure(
      errorResultEntity: ErrorResultModel(message: "Network error occurred", statusCode: 500),
    );
  }
}

}
