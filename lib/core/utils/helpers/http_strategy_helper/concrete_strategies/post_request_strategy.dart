import 'dart:convert';
import 'dart:developer';

import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/extension_functions/http_response_extensions.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_strategy.dart';
import 'package:http/http.dart' as http;
class PostRequestStrategy implements HttpRequestStrategy {
  @override
  Future<ApiResultModel<http.Response>> executeRequest({
    required String uri,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> requestData = const <String, dynamic>{},
  }) async {
    final String encodedJson = json.encode(requestData);
    log('--------->encoded json----->$encodedJson');
    final http.Response response = await http
        .post(
          Uri.parse(uri),
          headers: headers,
          body: encodedJson,
          encoding: utf8,
        )
        .timeout(timeOutDuration);
    log('------------resosponse-----${response.body.toString()}');

    return response.performHttpRequest();
  }
}
