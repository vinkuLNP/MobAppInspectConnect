import 'dart:io';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
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
                        const SectionTitle('Additional Details'),
                        const SizedBox(height: 8),

                        _section(
                          title: 'Profile Image(Optional)',
                          child: _imageUploader(
                            context: context,
                            files: prov.profileImageUrl != null
                                ? [prov.profileImageUrl!]
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
                          title: 'Upload ID / License(Optional)',
                          child: _imageUploader(
                            context: context,
                            files: prov.idLicenseUrl != null
                                ? [prov.idLicenseUrl!]
                                : [],
                            maxFiles: 1,
                            onAdd: () => prov.pickFile(context, 'id'),
                            onRemove: (index) => prov.removeIdImage(index),
                          ),
                        ),

                        _section(
                          title: 'Upload Reference Letters(Optional)',
                          child: _imageUploader(
                            context: context,
                            files: prov.referenceLettersUrls,
                            maxFiles: 5,
                            onAdd: () => prov.pickFile(context, 'ref'),
                            onRemove: (index) =>
                                prov.removeReferenceLetterImage(index),
                          ),
                        ),

                        const SizedBox(height: 12),

                        AppInputField(
                          controller: prov.workHistoryController,
                          label: 'Work History Description(Optional)',
                          maxLines: 4,
                          hint: 'Enter work experience details...',
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
                            text: 'I agree to the Terms and Conditions.',
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
                            text: 'I confirm all information is truthful.',
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

    if (path.startsWith('http://') || path.startsWith('https://')) {
      return Image.network(
        path,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) =>
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
      errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
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
                text: allowOnlyImages
                    ? "Tap to upload image"
                    : "Tap to upload file (image or PDF)",
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
      height: rowCount * (itemHeight + spacing + 10),
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
            final isImage = [
              'jpg',
              'jpeg',
              'png',
              'heic',
              'gif',
              'bmp',
            ].contains(ext);

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
