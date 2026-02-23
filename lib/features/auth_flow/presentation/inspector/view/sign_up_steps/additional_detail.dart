import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_strings.dart';
import 'package:inspect_connect/core/utils/helpers/app_common_functions/app_common_functions.dart';
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
  final bool isAccountScreen;

  const AdditionalDetailsStep(
    this.vm,
    this.formKey, {
    super.key,
    this.isAccountScreen = false,
  });

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
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SectionTitle(additionalDetails),
                const SizedBox(height: 8),

                _section(
                  title: profileImageOptional,
                  child: imageUploader(
                    context: context,
                    files: prov.profileImage != null
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
                  title:
                      '${widget.isAccountScreen ? '' : uploadtxt} $uploadIdLicense',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      documentTypeDropdown(prov),

                      const SizedBox(height: 8),

                      imageUploader(
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
                  title:
                      '${widget.isAccountScreen ? '' : uploadtxt} $uploadCoiDocument',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      imageUploader(
                        context: context,
                        files: prov.coiUploadedUrl != null
                            ? [
                                File(
                                  prov.coiUploadedUrl!.documentUrl.toString(),
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
                  title:
                      '${widget.isAccountScreen ? '' : uploadtxt} $uploadReferenceLetters',

                  child: imageUploader(
                    context: context,
                    files: prov.referenceLetters,
                    existingUrls: prov.referenceLettersUrls,
                    maxFiles: 5,
                    onAdd: () => prov.pickFile(context, 'ref'),
                    onRemove: (index) => prov.removeReferenceLetterImage(index),
                    onRemoveExisting: (index) =>
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
                if (!widget.isAccountScreen) ...[
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
                      color: prov.showValidationError && !prov.agreedToTerms
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
                      color: prov.showValidationError && !prov.confirmTruth
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                ],
              ],
            ),
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
}
