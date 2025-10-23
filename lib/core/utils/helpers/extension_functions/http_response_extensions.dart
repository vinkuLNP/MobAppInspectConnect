import 'dart:convert';
import 'dart:developer';

import 'package:clean_architecture/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:clean_architecture/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:http/http.dart' as http;

extension ExtensionOnHttpResponse on http.Response {
  ApiResultModel<http.Response> performHttpRequest() {
    if (statusCode >= 200 && statusCode < 300) {
      log('✅ SUCCESS [${statusCode}] → ${request?.url}');
      return ApiResultModel<http.Response>.success(data: this);
    } else {
      log('❌ ERROR [${statusCode}] → ${request?.url}');
      log('📨 Response Body: $body');

      String? message;

      try {
        if (body.isNotEmpty) {
          final dynamic decoded = jsonDecode(body);
          if (decoded is Map<String, dynamic>) {
            // look for common keys like 'message', 'error', or 'detail'
            message = decoded['message'] ??
                decoded['error'] ??
                decoded['detail'] ??
                'Unknown error';
          } else {
            message = body; // fallback raw string
          }
        } else {
          message = 'Empty response from server';
        }
      } catch (e) {
        log('⚠️ Failed to parse error body: $e');
        message = reasonPhrase ?? 'Unexpected server error';
      }

      return ApiResultModel<http.Response>.failure(
        errorResultEntity: ErrorResultModel(
          message: message,
          statusCode: statusCode,
        ),
      );
    }
  }
}

