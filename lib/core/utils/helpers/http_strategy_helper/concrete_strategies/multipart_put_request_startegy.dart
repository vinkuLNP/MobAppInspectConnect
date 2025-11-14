import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/extension_functions/http_response_extensions.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_strategy.dart';
import 'package:mime/mime.dart';

class MultipartPutRequestStrategy implements HttpRequestStrategy {
  @override
  Future<ApiResultModel<http.Response>> executeRequest({
    required String uri,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> requestData = const <String, dynamic>{},
  }) async {
    try {
      log('📤 MultipartPutRequestStrategy.executeRequest called');
      log('➡️ URI: $uri');
      log('➡️ Headers: $headers');
      log('➡️ RequestData: $requestData');

      final request = http.MultipartRequest('PUT', Uri.parse(uri));
      request.headers.addAll(headers);

      // Attach normal fields (everything except "images")
      requestData.forEach((key, value) {
        if (key != 'images') {
          request.fields[key] = value.toString();
        }
      });

      // Handle "images" separately
      final images = requestData['images'];
      if (images != null && images is List && images.isNotEmpty) {
        for (var img in images) {
          if (img is String) {
            if (img.startsWith('http')) {
              // Already uploaded image → send as text field
              request.fields.putIfAbsent('images[]', () => img);
              log('🌐 Existing image URL kept: $img');
            } else {
              final file = File(img);
              if (file.existsSync()) {
                final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
                final parts = mimeType.split('/');
                final multipartFile = await http.MultipartFile.fromPath(
                  'images',
                  file.path,
                  contentType: MediaType(parts[0], parts[1]),
                );
                request.files.add(multipartFile);
                log('📎 Attached local image file: ${file.path}');
              } else {
                log('⚠️ Skipping non-existent local image path: $img');
              }
            }
          }
        }
      }

      final streamedResponse = await request.send().timeout(timeOutDuration);
      final response = await http.Response.fromStream(streamedResponse);
      log('✅ Upload Response: ${response.statusCode} ${response.body}');

      return response.performHttpRequest();
    } catch (e) {
      log('❌ Multipart PUT error: $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Multipart PUT failed",
          statusCode: 500,
        ),
      );
    }
  }
}
