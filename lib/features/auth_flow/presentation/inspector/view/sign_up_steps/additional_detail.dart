import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/features/auth_flow/domain/entities/inspector_documents_type.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:inspect_connect/features/auth_flow/utils/text_editor_controller.dart';
import 'package:provider/provider.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';

class AdditionalDetailsStep extends StatefulWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;

  const AdditionalDetailsStep(this.vm, this.formKey, {super.key});

  @override
  State<AdditionalDetailsStep> createState() => _AdditionalDetailsStepState();
}

class _AdditionalDetailsStepState extends State<AdditionalDetailsStep> {
  late InspectorViewModelProvider provider;

  @override
  void initState() {
    super.initState();
    provider = widget.vm;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: provider,
      child: Consumer<InspectorViewModelProvider>(
        builder: (context, prov, _) {
          return Stack(
            children: [
              AbsorbPointer(
                absorbing: prov.isProcessing,
                child: Opacity(
                  opacity: prov.isProcessing ? 0.6 : 1.0,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SectionTitle(additionalDetails),
                        const SizedBox(height: 8),

                        _section(
                          title: profileImageOptional,
                          child: _imageUploader(
                            context: context,
                            files: prov.profileImageUrl != null
                                ? [prov.profileImage!]
                                : [],
                            maxFiles: 1,
                            allowOnlyImages: true,
                            onAdd: () => prov.pickFile(
                              context,
                              'profile',
                              allowOnlyImages: true,
                            ),
                            onRemove: (index) => prov.removeProfileImage(),
                          ),
                        ),
                        _section(
                          title: uploadIdLicense,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              documentTypeDropdown(prov),

                              const SizedBox(height: 8),

                              _imageUploader(
                                context: context,
                                files: prov.idDocumentFile != null
                                    ? [prov.idDocumentFile!]
                                    : [],
                                maxFiles: 1,
                                onAdd: () => prov.pickFile(context, 'id'),
                                onRemove: (_) => prov.removeIdImage(0),
                              ),

                              const SizedBox(height: 6),

                              expiryPicker(
                                context,
                                label: idLicenseExpiryDate,
                                date: prov.selectedIdDocExpiry,
                                onPick: (date) {
                                  prov.selectedIdDocExpiry = date;
                                  prov.notify();
                                },
                              ),
                            ],
                          ),
                        ),
                        _section(
                          title: uploadCoiDocument,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _imageUploader(
                                context: context,
                                files: prov.coiUploadedUrl != null
                                    ? [
                                        File(
                                          prov.coiUploadedUrl!.documentUrl
                                              .toString(),
                                        ),
                                      ]
                                    : [],
                                maxFiles: 1,
                                onAdd: () => prov.pickFile(context, 'coi'),
                                onRemove: (_) => prov.removeCoi(),
                              ),

                              const SizedBox(height: 6),

                              expiryPicker(
                                context,
                                label: coiDocumentExpiryDate,
                                date: prov.coiExpiry,
                                onPick: (date) {
                                  prov.coiExpiry = date;
                                  prov.notify();
                                },
                              ),
                            ],
                          ),
                        ),

                        _section(
                          title: uploadReferenceLetters,
                          child: _imageUploader(
                            context: context,
                            files: prov.referenceLetters,
                            maxFiles: 5,
                            onAdd: () => prov.pickFile(context, 'ref'),
                            onRemove: (index) =>
                                prov.removeReferenceLetterImage(index),
                          ),
                        ),

                        const SizedBox(height: 12),

                        AppInputField(
                          controller: inspWorkHistoryController,
                          label: workHistoryDescription,
                          maxLines: 4,
                          hint: workHistoryHint,
                        ),

                        CheckboxListTile(
                          value: prov.agreedToTerms,
                          onChanged: (val) {
                            prov.toggleTerms(val);
                            setState(() => prov.showValidationError = false);
                          },
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: textWidget(
                            text: agreeToTerms,
                            fontSize: 12,
                            color:
                                prov.showValidationError && !prov.agreedToTerms
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                        CheckboxListTile(
                          value: prov.confirmTruth,
                          onChanged: (val) {
                            prov.toggleTruth(val);
                            setState(() => prov.showValidationError = false);
                          },
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: textWidget(
                            text: informationTruthful,
                            fontSize: 12,
                            color:
                                prov.showValidationError && !prov.confirmTruth
                                ? Colors.red
                                : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (prov.isProcessing)
                const Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  Widget expiryPicker(
    BuildContext context, {
    required String label,
    required DateTime? date,
    required Function(DateTime) onPick,
  }) {
    final isSelected = date != null;

    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date ?? DateTime.now().add(Duration(days: 30)),
          firstDate: DateTime.now().add(Duration(days: 30)),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          onPick(picked);
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade400,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              isSelected ? _numericDate(date) : selectExpiryDate,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _numericDate(DateTime date) {
    log(date.toString());
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day-$month-$year';
  }

  Widget _section({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(text: title, fontWeight: FontWeight.w500, fontSize: 13),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _buildImageWidget(File file) {
    final path = file.path;

    if (path.startsWith(httpProtocol) || path.startsWith(httpsProtocol)) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, _, _) =>
            const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
      );
    }

    return Image.file(
      file,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, _, _) =>
          const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
    );
  }

  Widget documentTypeDropdown(InspectorViewModelProvider prov) {
    return DropdownButtonFormField<InspectorDocumentsTypeEntity>(
      initialValue: prov.selectedIdDocType,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: documentType,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 1.5,
          ),
        ),
      ),
      items: prov.inspectorDocumentsType.map((doc) {
        return DropdownMenuItem(value: doc, child: Text(doc.name));
      }).toList(),
      onChanged: (val) {
        prov.selectedIdDocType = val;
        prov.notify();
      },
      validator: (val) => val == null ? pleaseSelectDocumentType : null,
    );
  }

  Widget _imageUploader({
    required BuildContext context,
    required List<File> files,
    required int maxFiles,
    required VoidCallback onAdd,
    required void Function(int index) onRemove,
    bool allowOnlyImages = false,
  }) {
    final canAddMore = files.length < maxFiles;

    if (files.isEmpty) {
      return GestureDetector(
        onTap: onAdd,
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
            color: Colors.grey.shade50,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.add_a_photo, color: Colors.grey, size: 30),
              const SizedBox(height: 8),
              textWidget(
                text: allowOnlyImages ? tapToUploadImage : tapToUploadFile,
                color: Colors.grey,
                fontSize: 12,
              ),
            ],
          ),
        ),
      );
    }

    final itemCount = canAddMore ? files.length + 1 : files.length;
    const crossAxisCount = 3;
    const spacing = 8.0;
    const itemHeight = 80.0;
    final rowCount = (itemCount / crossAxisCount).ceil();

    return SizedBox(
      height: rowCount * (itemHeight + spacing + 20),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: spacing,
          crossAxisSpacing: spacing,
          childAspectRatio: 1,
        ),
        itemCount: itemCount,
        itemBuilder: (ctx, i) {
          if (i < files.length) {
            final file = files[i];
            final ext = file.path.split('.').last.toLowerCase();
            final isImage = imageExtensions.contains(ext);

            return ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  Container(
                    color: Colors.grey.shade100,
                    child: isImage
                        ? _buildImageWidget(file)
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.insert_drive_file,
                                  size: 32,
                                  color: Colors.blueGrey,
                                ),
                                const SizedBox(height: 6),
                                textWidget(
                                  text: file.path.split('/').last,
                                  fontSize: 10,
                                  maxLine: 2,
                                  alignment: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () => onRemove(i),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return GestureDetector(
              onTap: onAdd,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.grey.shade50,
                ),
                child: const Center(child: Icon(Icons.add_a_photo)),
              ),
            );
          }
        },
      ),
    );
  }
}
