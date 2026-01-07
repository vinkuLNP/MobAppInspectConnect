import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/commondomain/entities/based_api_result/api_result_state.dart';
import 'package:inspect_connect/core/di/app_component/app_component.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/data/models/certificate_inspector_type_datamodel.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/domain/usecases/certificate_type_usecase.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/client_flow/data/models/upload_image_model.dart';
import 'package:inspect_connect/features/client_flow/domain/entities/upload_image_dto.dart';
import 'package:inspect_connect/features/client_flow/domain/usecases/upload_image_usecase.dart';

class InspectorProfessionalStepService {
  final InspectorViewModelProvider provider;
  InspectorProfessionalStepService(this.provider);

  void setDate(DateTime d) {
    provider.certificateExpiryDateShow = DateTime(d.year, d.month, d.day);
    provider.certificateExpiryDate = provider.certificateExpiryDateShow
        .toIso8601String()
        .split('T')
        .first;
    provider.notify();
  }

  bool validateProfessionalDetails() {
    final totalDocs =
        provider.documents.length + provider.existingDocumentUrls.length;

    if (provider.certificateInspectorType == null) {
      provider.errorMessage = "Please select a certificate type";
      provider.notify();
      return false;
    }

    if (totalDocs == 0 || provider.uploadedCertificateUrls == []) {
      provider.errorMessage =
          "Please upload at least one certification document";
      provider.notify();
      return false;
    }

    provider.errorMessage = null;
    return true;
  }

  Future<void> uploadDocument(BuildContext context) async {
    final picker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    try {
      provider.setProcessing(true);
      if (picker == null && picker!.files.single.path == null) return;
      final file = File(picker.files.single.path.toString());
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
      final result = await provider
          .executeParamsUseCase<UploadImageResponseModel, UploadImageParams>(
            useCase: uploadImageUseCase,
            query: UploadImageParams(filePath: uploadImage),
            launchLoader: true,
          );

      result?.when(
        data: (response) {
          provider.documents.add(
            picker.files.single.path != null
                ? File(picker.files.single.path!)
                : file,
          );
          provider.uploadedCertificateUrls.add(response.fileUrl);
          provider.notify();
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
    } catch (e) {
      log('Error picking file: $e');
    } finally {
      provider.setProcessing(false);
    }
  }

  void removeDocumentAt(int index) {
    if (index < provider.uploadedCertificateUrls.length) {
      provider.uploadedCertificateUrls.removeAt(index);
    }
    if (index < provider.documents.length) {
      provider.documents.removeAt(index);
    }
    provider.notify();
  }

  void removeExistingDocumentAt(int index) {
    provider.existingDocumentUrls.removeAt(index);
    provider.uploadedCertificateUrls.removeAt(index);
    provider.notify();
  }

  void setCertificateType(CertificateInspectorTypeEntity? t) {
    provider.userCertificateInspectorType = t;
    provider.selectedCertificateTypeId = t?.id;
    log('------------id. ${t!.id.toString()}');
    log('------------name. ${t.name.toString()}');

    provider.notify();
  }

  Future<void> fetchCertificateTypes({String? savedId}) async {
    try {
      provider.setProcessing(true);

      final getSubTypesUseCase = locator<GetCertificateTypeUseCase>();

      final state = await provider
          .executeParamsUseCase<
            List<CertificateInspectorTypeEntity>,
            GetCertificateInspectorTypesParams
          >(useCase: getSubTypesUseCase, launchLoader: true);

      state?.when(
        data: (response) {
          final modelList = response
              .map(
                (e) => CertificateInspectorTypeModelData(
                  id: e.id,
                  name: e.name,
                  status: e.status,
                  createdAt: e.createdAt,
                  updatedAt: e.updatedAt,
                  v: e.v,
                ),
              )
              .toList();

          provider.certificateType = modelList;

          CertificateInspectorTypeModelData selectedType;
          if (savedId != null) {
            log(savedId);
            selectedType = modelList.firstWhere(
              (e) => e.id == savedId,
              orElse: () => modelList.first,
            );
          } else {
            selectedType = modelList.first;
          }

          setCertificateType(selectedType);
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

  Future<void> saveProfessionalStep({
    required String certificateTypeId,
    required String certificateExpiryDate,
    List<String>? uploadedCertificateUrls,
    List<String>? agencyIds,
  }) async {
    await provider.localDs.updateFields({
      'certificateTypeId': certificateTypeId,
      'certificateExpiryDate': certificateExpiryDate,
      'certificateDocuments': uploadedCertificateUrls ?? [],
      // 'certificateAgencyIds': agencyIds ?? [],
    });
  }
}
