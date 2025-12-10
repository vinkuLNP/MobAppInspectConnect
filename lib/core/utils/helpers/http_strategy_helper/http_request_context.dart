import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/app_configurations_helper/app_configurations_helper.dart';
import 'package:inspect_connect/core/utils/helpers/connectivity_helper/connectivity_helper/connectivity_checker_helper.dart';
import 'package:inspect_connect/core/utils/helpers/custom_exceptions/custom_connection_exception.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_strategy.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';

@injectable
class HttpRequestContext {
  HttpRequestContext(this.connectivityCheckerHelper);

  final ConnectivityCheckerHelper connectivityCheckerHelper;
  final String? baseUrl = locator<AppConfigurations>().baseUrl;

  Map<String, String> _sharedDefaultHeader = <String, String>{};

  Future<void> initSharedDefaultHeader([
    String contentValue = contentTypeValue,
  ]) async {
    _sharedDefaultHeader = <String, String>{};
    _sharedDefaultHeader.addAll(<String, String>{contentTypeKey: contentValue});
  }

  Future<bool> _getConnectionState() async {
    final bool result = await connectivityCheckerHelper.checkConnectivity();
    log('Connectivity check result: $result');
    return result;
  }

  Future<ApiResultModel<http.Response>> makeRequest({
    required String uri,
    required HttpRequestStrategy httpRequestStrategy,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> requestData = const <String, dynamic>{},
  }) async {
    await initSharedDefaultHeader();
    _sharedDefaultHeader.addAll(headers);
    if (!await _getConnectionState()) {
        log('⚠️ Connectivity not detected, but attempting network call anyway (possible simulator case)');
}
      try {
        log('=====baseUrl====>$baseUrl');
        log('====uri=====>$uri');

        final String url = '$baseUrl$uri';
        log('=========>$url');

        return await httpRequestStrategy.executeRequest(
          uri: url,
          headers: _sharedDefaultHeader,
          requestData: requestData,
        );
      } on TimeoutException catch (e) {
        log('timout cexpetio----------?>>>>e$e');
        return const ApiResultModel<http.Response>.failure(
          errorResultEntity: ErrorResultModel(
            message: commonErrorUnexpectedMessage,
            statusCode: timeoutRequestStatusCode,
          ),
        );
      } on IOException catch (e) {
        log('io cexpetio----------?>>>>e$e');

        throw CustomConnectionException(
          exceptionMessage: commonConnectionFailedMessage,
          exceptionCode: ioExceptionStatusCode,
        );
      }
   } 
}
