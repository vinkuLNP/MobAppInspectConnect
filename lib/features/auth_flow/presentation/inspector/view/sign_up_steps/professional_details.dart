import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/helpers/app_common_functions/app_common_functions.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_type_entity.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:inspect_connect/features/client_flow/presentations/widgets/select_time_widget.dart';
import 'package:provider/provider.dart';

class ProfessionalDetailsStep extends StatelessWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;
  final bool isAccountScreen;
  const ProfessionalDetailsStep(
    this.vm,
    this.formKey, {
    super.key,
    this.isAccountScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: vm,
      child: Consumer<InspectorViewModelProvider>(
        builder: (context, prov, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionTitle(professionalDetails),
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
                title:
                    '${isAccountScreen ? '' : uploadtxt} $certificationDocuments',
                child: imageUploader(
                  context: context,
                  files: prov.documents,
                  existingUrls: prov.existingDocumentUrls,
                  maxFiles: 4,
                  onAdd: () => prov.uploadDocument(context),
                  onRemove: (i) => prov.removeDocumentAt(i),
                  onRemoveExisting: (i) => prov.removeExistingDocumentAt(i),
                ),
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
}
