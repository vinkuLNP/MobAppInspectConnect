import 'dart:async';
import 'dart:developer';


import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/extension_functions/extension_functions.dart';
import 'package:inspect_connect/core/utils/helpers/extension_functions/http_response_extensions.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_strategy.dart';
import 'package:http/http.dart' as http;

class GetRequestStrategy implements HttpRequestStrategy {
  @override
  Future<ApiResultModel<http.Response>> executeRequest({
    required String uri,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> requestData = const <String, dynamic>{},
  }) async {
    log('uri------<Uri---$uri');
    
    log('token------<Uri---$headers');
    
    log('-----uri.parseUri(params: requestData)-----${uri.parseUri(params: requestData)}');
    log(uri);

    final http.Response response = await http
        .get(uri.parseUri(params: requestData), headers: headers)
        .timeout(timeOutDuration);
    return response.performHttpRequest();
  }
}
