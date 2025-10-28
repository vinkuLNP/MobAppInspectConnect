import 'dart:convert';
import 'dart:developer';

import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/features/client_flow/presentations/providers/session_manager.dart';

extension ExtensionOnHttpResponse on http.Response {
  ApiResultModel<http.Response> performHttpRequest({
    bool enableAutoLogout = true,
  }) {
    if (statusCode >= 200 && statusCode < 300) {
      log('✅ SUCCESS ru[${statusCode}] → ${request?.url}');
      return ApiResultModel<http.Response>.success(data: this);
    } else {
      log('❌ ERROR [${statusCode}] → ${request?.url}');
      log('📨 Response Body: $body');

      String? message;

      try {
        if (body.isNotEmpty) {
          final dynamic decoded = jsonDecode(body);

          log('body.isNotEmpty 1');

          if (decoded is Map<String, dynamic>) {
            log('body.isNotEmpty 12');

            // look for common keys like 'message', 'error', or 'detail'
            message =
                decoded['message'] ??
                decoded['error'] ??
                decoded['detail'] ??
                'Unknown error';
          } else {
            log('body.isNotEmpty 123, $body');

            message = body; // fallback raw string
          }
        } else {
          message = 'Empty response from server';
        }
      } catch (e) {
        log('⚠️ Failed to parse error body: $e');
        message = reasonPhrase ?? 'Unexpected server error';
      }
      if (enableAutoLogout &&
          (message?.toLowerCase().contains('invalid token.') == true ||
              message?.toLowerCase().contains('expired token.') == true)) {
        SessionManager().logout(reason: message);
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
