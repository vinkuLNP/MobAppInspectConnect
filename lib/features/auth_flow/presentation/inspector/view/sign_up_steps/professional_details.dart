import 'dart:io';

import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/select_time_widget.dart';
import 'package:provider/provider.dart';

class ProfessionalDetailsStep extends StatelessWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;

  const ProfessionalDetailsStep(this.vm, this.formKey, {super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<InspectorViewModelProvider>(
        builder: (context, prov, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textWidget(
                text: professionalDetails,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              const SizedBox(height: 8),
              _section(
                title: certificateType,
                child: _inspectionTypeDropdown(prov),
              ),

              const SizedBox(height: 6),

              _section(
                title: selectExpirationDate,
                child: IgnorePointer(
                  ignoring: false,
                  child: DateTimePickerWidget(
                    showTimePicker: false,
                    initialDateTime: prov.certificateExpiryDateShow,
                    onDateTimeSelected: (dt) {
                      prov.setDate(dt);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _section(
                title: uploadCertificationDocuments,
                child: _documentGrid(prov, context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(text: title, fontWeight: FontWeight.w400, fontSize: 14),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  bool _isImage(String path) {
    final ext = path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext);
  }

  Widget _buildImagePreview(File file) {
    return Image.file(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
    );
  }

  Widget _buildNetworkImage(String url) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
      loadingBuilder: (c, w, p) {
        if (p == null) return w;
        return const Center(child: CircularProgressIndicator(strokeWidth: 2));
      },
    );
  }

  Widget _inspectionTypeDropdown(InspectorViewModelProvider prov) {
    return DropdownButtonFormField<CertificateInspectorTypeEntity>(
      decoration: _inputDecoration(selectCertificateType),
      initialValue: prov.certificateInspectorType,
      style: appTextStyle(fontSize: 12),
      items: prov.certificateType
          .map(
            (subType) => DropdownMenuItem<CertificateInspectorTypeEntity>(
              value: subType,
              child: textWidget(text: subType.name, fontSize: 12),
            ),
          )
          .toList(),
      onChanged: prov.setCertificateType,
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey.shade50,
    errorStyle: appTextStyle(fontSize: 12, color: Colors.red),
    hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),

    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.authThemeColor),
    ),
  );

  Widget _documentGrid(InspectorViewModelProvider prov, BuildContext context) {
    final totalDocs = prov.documents.length + prov.existingDocumentUrls.length;
    final canAddMore = totalDocs < 4;

    if (totalDocs == 0) {
      return GestureDetector(
        onTap: () => prov.uploadDocument(context),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
                color: Colors.grey.shade50,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.upload_file, size: 32, color: Colors.grey),
                  const SizedBox(height: 8),
                  textWidget(
                    text: uploadDocument,
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ],
              ),
            ),
            if (prov.errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  prov.errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
          ],
        ),
      );
    }
    const spacing = 8.0;

    return GridView.builder(
      padding: EdgeInsets.zero,

      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: spacing,
        crossAxisSpacing: spacing,
        childAspectRatio: 3,
      ),
      itemCount: canAddMore ? totalDocs + 1 : totalDocs,
      itemBuilder: (ctx, i) {
        if (i < prov.existingDocumentUrls.length) {
          final url = prov.existingDocumentUrls[i];
          final name = url.split('/').last;

          if (_isImage(url)) {
            return _imageTile(
              child: _buildNetworkImage(url),
              onDelete: () => prov.removeExistingDocumentAt(i),
            );
          }

          return _documentTile(
            name: name,
            onDelete: () => prov.removeExistingDocumentAt(i),
          );
        }
        final docIndex = i - prov.existingDocumentUrls.length;
        if (docIndex < prov.documents.length) {
          final file = prov.documents[docIndex];
          final name = file.path.split('/').last;

          if (_isImage(file.path)) {
            return _imageTile(
              child: _buildImagePreview(file),
              onDelete: () => prov.removeDocumentAt(docIndex),
            );
          }

          return _documentTile(
            name: name,
            onDelete: () => prov.removeDocumentAt(docIndex),
          );
        }

        return GestureDetector(
          onTap: () => prov.uploadDocument(ctx),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey.shade50,
            ),
            child: const Center(
              child: Icon(Icons.upload_file, size: 28, color: Colors.grey),
            ),
          ),
        );
      },
    );
  }

  Widget _imageTile({required Widget child, required VoidCallback onDelete}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          Container(color: Colors.grey.shade100, child: child),
          Positioned(
            top: 4,
            right: 4,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _documentTile({
    required String name,
    VoidCallback? onDelete,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        child: Row(
          children: [
            const Icon(Icons.insert_drive_file, color: Colors.blueAccent),
            const SizedBox(width: 8),
            Expanded(
              child: textWidget(
                text: name,
                fontSize: 13,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
            if (onDelete != null)
              GestureDetector(
                onTap: onDelete,
                child: const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(Icons.close, size: 18, color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
