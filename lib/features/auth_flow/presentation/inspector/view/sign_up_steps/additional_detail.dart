import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';

class AdditionalDetailsStep extends StatelessWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;

  const AdditionalDetailsStep(this.vm, this.formKey, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Additional Details', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        TextFormField(
          // controller: vm.notesCtrl,
          decoration: const InputDecoration(labelText: 'Notes / Special Info'),
          maxLines: 4,
        ),
      ],
    );
  }
}
