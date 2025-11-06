import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:provider/provider.dart';

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
    provider = InspectorViewModelProvider();
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.grey.shade50,
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    ),
  );

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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SectionTitle('Additional Details'),
                      const SizedBox(height: 8),
                      _section(
                        title: 'Profile Image',
                        child: GestureDetector(
                          onTap: () => prov.pickImage(context, 'profile'),
                          child: Container(
                            width: double.infinity,
                            height: 130,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                style: BorderStyle.solid,
                              ),
                              color: Colors.grey.shade50,
                            ),
                            child: prov.profileImage == null
                                ? Center(
                                    child: textWidget(
                                      text:
                                          'No profile image uploaded.\n            Tap to upload',
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      prov.profileImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),

                      _uploadButton(
                        title: 'Upload ID / License',
                        onTap: () => prov.pickImage(context, 'id'),
                      ),
                      _uploadButton(
                        title: 'Upload Reference Letters',
                        onTap: () => prov.pickImage(context, 'ref'),
                      ),

                      AppInputField(
                        controller: prov.workHistoryController,
                        label: 'Work History Description',
                        maxLines: 4,

                        // decoration: _inputDecoration(
                        hint: 'Enter work experience details...',
                        // ),
                      ),

                      CheckboxListTile(
                        value: prov.agreedToTerms,
                        onChanged: prov.toggleTerms,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: textWidget(
                          text: 'I agree to the Terms and Conditions.',
                          fontSize: 12,
                        ),
                      ),
                      CheckboxListTile(
                        value: prov.confirmTruth,
                        onChanged: prov.toggleTruth,
                        visualDensity: VisualDensity.compact,
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,

                        title: textWidget(
                          text: 'I confirm all information is truthful.',
                          fontSize: 12,
                        ),
                      ),
                    ],
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
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          textWidget(text: title, fontWeight: FontWeight.w600, fontSize: 14),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }

  Widget _uploadButton({required String title, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: BorderSide(color: Colors.grey.shade400),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        icon: const Icon(Icons.cloud_upload_outlined),
        label: textWidget(text: title),
      ),
    );
  }
}
