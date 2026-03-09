import 'dart:io';
import 'package:inspect_connect/core/basecomponents/base_view_model.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';

class FileUploadProvider extends BaseViewModel {
  // final UploadFileUseCase uploadFileUseCase;

  // FileUploadProvider({required this.uploadFileUseCase});

  List<UploadedFileEntity> files = [];
  String? errorMessage;
  bool isUploading = false;

  static const int maxSize = 2 * 1024 * 1024;

  bool _isImage(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp'].contains(ext);
  }

  Future<void> pickAndUploadFile({
    required File file,
    required int maxFiles,
  }) async {
    errorMessage = null;

    if (files.length >= maxFiles) {
      errorMessage = "Maximum $maxFiles files allowed";
      notifyListeners();
      return;
    }

    final size = await file.length();

    if (size > maxSize) {
      errorMessage = "File must be under 2MB";
      notifyListeners();
      return;
    }

    final ext = file.path.split('.').last.toLowerCase();
    if (!['jpg', 'jpeg', 'png', 'webp', 'pdf'].contains(ext)) {
      errorMessage = "Only image or PDF allowed";
      notifyListeners();
      return;
    }

    isUploading = true;
    notifyListeners();
    final uploadImageUseCase = locator<UploadImageUseCase>();
    // final result = await uploadFileUseCase(
    //   UploadFileParams(filePath: file.path),
    // );
    final uploadImage = UploadImageDto(filePath: file.path);
    final result =
        await executeParamsUseCase<UploadImageResponseModel, UploadImageParams>(
          useCase: uploadImageUseCase,
          query: UploadImageParams(uploadImageDto: uploadImage),
          launchLoader: true,
        );
    result?.when(
      error: (e) {
        final failure = e;
        errorMessage = failure.message;
      },
      data: (response) {
        files.add(
          UploadedFileEntity(
            url: response.fileUrl,
            name: file.path.split('/').last,
            isImage: _isImage(file.path),
          ),
        );
      },
    );

    isUploading = false;
    notifyListeners();
  }

  void removeFile(int index) {
    files.removeAt(index);
    notifyListeners();
  }
}

class UploadedFileEntity {
  final String url;
  final String name;
  final bool isImage;

  UploadedFileEntity({
    required this.url,
    required this.name,
    required this.isImage,
  });
}
