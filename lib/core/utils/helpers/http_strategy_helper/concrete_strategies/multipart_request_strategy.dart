import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/error_result_model.dart';
import 'package:inspect_connect/core/utils/constants/app_constants.dart';
import 'package:inspect_connect/core/utils/helpers/extension_functions/http_response_extensions.dart';
import 'package:inspect_connect/core/utils/helpers/http_strategy_helper/http_request_strategy.dart';

class MultipartPostRequestStrategy implements HttpRequestStrategy {
  @override
  Future<ApiResultModel<http.Response>> executeRequest({
    required String uri,
    Map<String, String> headers = const <String, String>{},
    Map<String, dynamic> requestData = const <String, dynamic>{},
  }) async {
    try {
      final filePath = requestData['filePath'] as String?;
      if (filePath == null || filePath.isEmpty) {
        throw Exception("File path is missing in requestData");
      }

      final file = File(filePath);
      final request = http.MultipartRequest('POST', Uri.parse(uri));

      request.headers.addAll({
        ...headers,
      });

      // ✅ Add file
      final multipartFile = await http.MultipartFile.fromPath('file', file.path);
      request.files.add(multipartFile);

      log('Uploading file: ${file.path}');
      final streamedResponse =
          await request.send().timeout(timeOutDuration);

      final response = await http.Response.fromStream(streamedResponse);
      log('Upload Response: ${response.body}');

      return response.performHttpRequest();
    } catch (e) {
      log('❌ Multipart upload error: $e');
      return const ApiResultModel.failure(
        errorResultEntity: ErrorResultModel(
          message: "Multipart upload failed",
          statusCode: 500,
        ),
      );
    }
  }
}
