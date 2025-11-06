import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
class ServiceAreaStep extends StatefulWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;

  const ServiceAreaStep(this.vm, this.formKey, {super.key});

  @override
  State<ServiceAreaStep> createState() => _ServiceAreaStepState();
}

class _ServiceAreaStepState extends State<ServiceAreaStep> {
  TextEditingController country = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController city = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         const SectionTitle('Address Details'),
        const SizedBox(height: 8),
        Text(
          'Select your Service Area',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        CountryStateCityPicker(
          country: country,
          state: state,
          city: city,
          dialogColor: Colors.grey.shade50,
          textFieldDecoration: InputDecoration(
            filled: true,
            suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
            fillColor: Colors.grey.shade50,
            errorStyle: appTextStyle(fontSize: 12, color: Colors.red),
            hintStyle: appTextStyle(fontSize: 12, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 16,
            ),
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
          ),
        ),
        SizedBox(height: 8),
        AppInputField(
          label: 'Zip Code',
          hint: '123232',
          controller: TextEditingController(),
        ),
        SizedBox(height: 8),

         AppInputField(
          label: 'Enter your Mailing Address',
          hint: 'mailing address',
          controller: TextEditingController(),
        ),

      ],
    );
  }
}
