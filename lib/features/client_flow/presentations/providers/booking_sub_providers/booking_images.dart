import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';
import 'package:inspect_connect/features/client_flow/presentations/providers/booking_provider.dart';

class BookingImagesService {
  final BookingProvider provider;

  BookingImagesService(this.provider);

  Future<void> uploadImage(BuildContext context) async {
    try {
      if (provider.images.length >= 5) return;
      provider.setProcessing(true);

      final XFile? picked = await provider.picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (picked == null) {
        provider.setProcessing(false);
        return;
      }

      final file = File(picked.path);
      if (await file.length() > 4 * maxFileSizeInBytes) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: textWidget(
                text: fileMstBeUnder2Txt,
                color: AppColors.backgroundColor,
              ),
            ),
          );
        }
        provider.setProcessing(false);
        return;
      }

      final uploadImage = UploadImageDto(filePath: file.path);
      final uploadImageUseCase = locator<UploadImageUseCase>();
      final result = await provider
          .executeParamsUseCase<UploadImageResponseModel, UploadImageParams>(
            useCase: uploadImageUseCase,
            query: UploadImageParams(uploadImageDto: uploadImage),
            launchLoader: true,
          );

      result?.when(
        data: (response) {
          provider.uploadedUrls.add(response.fileUrl);
          provider.images.add(file);
          provider.notify();
        },
        error: (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: e.message ?? imageUploadFailed,
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      log(e.toString());
    } finally {
      provider.setProcessing(false);
    }
  }

  void removeImageAt(int idx) {
    if (idx >= 0 && idx < provider.images.length) {
      provider.images.removeAt(idx);
      provider.notify();
    }
  }

  void removeExistingImageAt(int idx) {
    if (idx >= 0 && idx < provider.existingImageUrls.length) {
      provider.existingImageUrls.removeAt(idx);
      if (idx < provider.uploadedUrls.length) {
        provider.uploadedUrls.removeAt(idx);
      }
      provider.notify();
    }
  }
}
