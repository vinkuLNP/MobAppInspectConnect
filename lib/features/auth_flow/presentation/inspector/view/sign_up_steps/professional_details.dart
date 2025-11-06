import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/certificate_agency_entity.dart';
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
              Text(
                'Professional Details',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              _section(
                title: 'Certificate Type',
                child: _inspectionTypeDropdown(prov),
              ),
              const SizedBox(height: 6),

              _section(
                title: 'Certifying Agencies ',
                child: _agencyTypeDropdown(prov),
              ),
              const SizedBox(height: 6),

              _section(
                title: 'Select Expiration Date',
                child: IgnorePointer(
                  ignoring: false,
                  // widget.isReadOnly,
                  child: DateTimePickerWidget(
                    showTimePicker: false,
                    initialDateTime: DateTime.now(),
                    // prov.selectedDate.add(
                    //   Duration(
                    //     hours:
                    //         prov.selectedTime?.hour ??
                    //         TimeOfDay.now().hour,
                    //     minutes:
                    //         prov.selectedTime?.minute ??
                    //         TimeOfDay.now().minute,
                    //   ),
                    // ),
                    onDateTimeSelected: (dt) {
                      // prov.setDate(dt);
                      // prov.setTime(TimeOfDay.fromDateTime(dt));
                    },
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _section(
                title: 'Upload Certification Documents (max 5)',
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
          // textWidget(text: title, fontWeight: FontWeight.w600, fontSize: 12),
          // const SizedBox(height: 3),
          textWidget(text: title, fontWeight: FontWeight.w400, fontSize: 14),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

   Widget _agencyTypeDropdown(InspectorViewModelProvider prov) {
    return DropdownButtonFormField<AgencyEntity>(
      decoration: _inputDecoration('Select Certifying Agencies'),
      initialValue: prov.agencyTypeData,
      style: appTextStyle(fontSize: 12),
      items: prov.agencyType
          .map(
            (subType) => DropdownMenuItem<AgencyEntity>(
              value: subType,
              child: textWidget(text: subType.name, fontSize: 12),
            ),
          )
          .toList(),
      onChanged:  prov.setAgencyType,
    );}

  Widget _inspectionTypeDropdown(InspectorViewModelProvider prov) {
    return DropdownButtonFormField<CertificateInspectorTypeEntity>(
      decoration: _inputDecoration('Select Certificate Type'),
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
      onChanged:  prov.setCertificateType,
    );
    // return DropdownButtonFormField<String>(
    //   decoration: _inputDecoration('Select inspection type'),
    //   initialValue: 'type 1',
    //   style: appTextStyle(fontSize: 12),
    //   items: ['type 1', 'type 2', 'type 3']
    //       .map(
    //         (subType) => DropdownMenuItem<String>(
    //           value: subType,
    //           child: textWidget(text: subType, fontSize: 12),
    //         ),
    //       )
    //       .toList(),
    //   // prov.subTypes
    //   //     .map(
    //   //       (subType) => DropdownMenuItem<CertificateSubTypeEntity>(
    //   //         value: subType,
    //   //         child: textWidget(text: subType.name, fontSize: 12),
    //   //       ),
    //   //     )
    //   //     .toList(),
    //   // onChanged:  prov.setInspectionType,
    //   onChanged: (value) {},
    // );
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
    final totalDocs = prov.documents.length;
    final canAddMore = totalDocs < 5;

    if (totalDocs == 0) {
      return GestureDetector(
        onTap: () => prov.uploadDocument(context),
        child: Container(
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
                text: "Upload Document",
                color: Colors.grey,
                fontSize: 12,
              ),
            ],
          ),
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
        // Existing documents (URLs)
        if (i < prov.existingDocumentUrls.length) {
          final url = prov.existingDocumentUrls[i];
          final name = url.split('/').last;

          return _documentTile(
            name: name,
            onDelete: () => prov.removeExistingDocumentAt(i),
            onTap: () => prov.openDocument(url),
          );
        }

        // Newly added documents (File objects)
        final docIndex = i - prov.existingDocumentUrls.length;
        if (docIndex < prov.documents.length) {
          final file = prov.documents[docIndex];
          final name = file.path.split('/').last;

          return _documentTile(
            name: name,
            onDelete: () => prov.removeDocumentAt(docIndex),
            onTap: () => prov.openLocalDocument(file),
          );
        }

        // Upload button
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
