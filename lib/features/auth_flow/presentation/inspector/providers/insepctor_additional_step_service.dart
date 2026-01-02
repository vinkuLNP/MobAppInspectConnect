import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/models/inspector_document_types_model.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_documents_type.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/document_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';

class InsepctorAdditionalStepService {
  final InspectorViewModelProvider provider;
  InsepctorAdditionalStepService(this.provider);

  Future<void> pickFile(
    BuildContext context,
    String type, {
    bool allowOnlyImages = false,
  }) async {
    try {
      provider.setProcessing(true);
      log("1---profileImage------>${provider.profileImage.toString()}");
      if (allowOnlyImages) {
        log("--2-profileImage------>${provider.profileImage.toString()}");
        final picked = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );

        if (picked == null) return;
        log("-3--profileImage------>${provider.profileImage.toString()}");
        final file = File(picked.path);
        if (await file.length() > 2 * 1024 * 1024) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: 'File must be under 2 MB',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          }
          return;
        }
        log("-4--profileImage------>${provider.profileImage.toString()}");
        final uploadImage = UploadImageDto(filePath: file.path);
        final uploadImageUseCase = locator<UploadImageUseCase>();
        final result = await provider
            .executeParamsUseCase<UploadImageResponseModel, UploadImageParams>(
              useCase: uploadImageUseCase,
              query: UploadImageParams(filePath: uploadImage),
              launchLoader: true,
            );
        log("--5-profileImage------>${provider.profileImage.toString()}");
        result?.when(
          data: (response) {
            provider.profileImageUrl = response.fileUrl;
            provider.profileImage = file;
            provider.notify();
            log("--6-profileImage------>${provider.profileImage.toString()}");
            log(
              "-7--profileImageUrl------>${provider.profileImageUrl.toString()}",
            );
          },
          error: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: e.message ?? 'Image upload failed',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          },
        );
      } else {
        provider.setProcessing(true);
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
        );
        if (result == null && result!.files.single.path == null) return;
        final file = File(result.files.single.path.toString());
        if (await file.length() > 2 * 1024 * 1024) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: 'File must be under 2 MB',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          }
          return;
        }
        final uploadImage = UploadImageDto(filePath: file.path);
        final uploadImageUseCase = locator<UploadImageUseCase>();
        final responseResult = await provider
            .executeParamsUseCase<UploadImageResponseModel, UploadImageParams>(
              useCase: uploadImageUseCase,
              query: UploadImageParams(filePath: uploadImage),
              launchLoader: true,
            );

        responseResult?.when(
          data: (response) {
            if (type == 'id') {
              // provider.idLicense = file;
              // provider.idLicenseUrl = File(response.fileUrl);
              provider.idDocumentFile = file;
              provider.idDocumentUploadedUrl = response.fileUrl;
            } else if (type == 'ref') {
              provider.referenceLetters.add(file);
              provider.referenceLettersUrls.add(response.fileUrl);
            } else if (type == 'coi') {
              provider.coiFile = file;
              provider.coiUploadedUrl = response.fileUrl;
            }
            provider.notify();
          },
          error: (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: textWidget(
                  text: e.message ?? 'File upload failed',
                  color: AppColors.backgroundColor,
                ),
              ),
            );
          },
        );
      }
    } catch (e) {
      log('Error picking file: $e');
    } finally {
      provider.setProcessing(false);
    }
  }

  Future<void> saveAdditionalStep({
    String? profileImageUrlOrPath,
    String? idLicenseUrlOrPath,
    String? workHistoryDescription,

    List<String>? referenceDocs,
    bool? agreed,
    bool? truthful,
  }) async {
    log(provider.idDocumentUploadedUrl.toString());
    await provider.localDs.updateFields({
      if (profileImageUrlOrPath != null) 'profileImage': profileImageUrlOrPath,
      if (idLicenseUrlOrPath != null)
        'uploadedIdOrLicenseDocument': idLicenseUrlOrPath,
      "documentTypeId": provider.selectedIdDocType?.id,
      "documentExpiryDate": provider.selectedIdDocExpiry?.toIso8601String(),
      if (referenceDocs != null) 'referenceDocuments': referenceDocs,
      'uploadedCoiDocument': provider.coiUploadedUrl,
      'coiExpiryDate': provider.coiExpiry?.toIso8601String(),
      if (workHistoryDescription != null)
        'workHistoryDescription': workHistoryDescription,

      if (agreed != null) 'agreedToTerms': agreed,
      if (truthful != null) 'isTruthfully': truthful,
    });
  }

  Future<void> fetchDocumentTypes() async {
    try {
      provider.setProcessing(true);

      final getSubTypesUseCase = locator<GetInspectorDocumentsTypeUseCase>();

      final state = await provider
          .executeParamsUseCase<
            List<InspectorDocumentsTypeEntity>,
            GetInspectorDocumentsTypeParams
          >(useCase: getSubTypesUseCase, launchLoader: true);

      state?.when(
        data: (response) {
          final modelList = response
              .map(
                (e) => InspectorDocumentTypesDataModel(
                  id: e.id,
                  name: e.name,
                  isDeleted: e.isDeleted,
                  status: e.status,
                  createdAt: e.createdAt,
                  updatedAt: e.updatedAt,
                  v: e.v,
                ),
              )
              .toList();

          provider.inspectorDocumentsType = modelList
              .where((e) => e.name.toLowerCase() != 'icc')
              .toList();

          provider.notify();
        },
        error: (e) {
          log("Error fetching certificate types: $e");
        },
      );
    } catch (e) {
      log("Exception in fetchCertificateTypes: $e");
    } finally {
      provider.setProcessing(false);
    }
  }
}
