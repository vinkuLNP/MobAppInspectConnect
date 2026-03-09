import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/helpers/app_logger/app_logger.dart';
import 'package:inspect_connect/core/utils/toast_service/toast_service.dart';
import 'package:inspect_connect/features/common_features/data/dto/upload_image_dto.dart';
import 'package:inspect_connect/features/common_features/domain/entities/upload_image_entity.dart';
import 'package:inspect_connect/features/common_features/domain/params/upload_image_params.dart';
import 'package:inspect_connect/features/common_features/domain/usecases/upload_image_usecase.dart';

class CommonViewModel extends BaseViewModel {
  final CommonUploadImageUseCase _uploadImageUseCase;

  CommonViewModel({
    required CommonUploadImageUseCase uploadImageUseCase,
  }) : 
       _uploadImageUseCase = uploadImageUseCase;
  bool isProcessing = false;
  
  Future<void> uploadDocument({
    required Function(File file, String url, FilePickerResult result) onSuccess,
    List<String>? allowedExtensions,
  }) async {
    isProcessing = true;
    notifyListeners();
    final picker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowedExtensions ?? certificateExtensions,
    );
    try {
      if (picker == null || picker.files.single.path == null) return;
      final file = File(picker.files.single.path.toString());
      if (await file.length() > maxFileSizeInBytes) {
        ToastService.warning(fileMstBeUnder2Txt);
        return;
      }
      final uploadImage = UploadImageDto(filePath: file.path);
      final result =
          await executeParamsUseCase<UploadImageEntity, UploadImageParams>(
            useCase: _uploadImageUseCase,
            query: UploadImageParams(uploadImageDto: uploadImage),
            launchLoader: true,
          );

      result?.when(
        data: (response) {
          onSuccess(file, response.fileUrl, picker);
          isProcessing = false;
          notifyListeners();
        },
        error: (e) {
          ToastService.error(e.message ?? 'Image upload failed');
        },
      );
    } catch (e) {
      AppLogger.error('Error picking file: $e');
    } finally {
      isProcessing = false;
      notifyListeners();
    }
  }
}
