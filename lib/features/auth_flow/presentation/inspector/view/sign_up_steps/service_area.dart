import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';

class ServiceAreaStep extends StatefulWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;

  const ServiceAreaStep(this.vm, this.formKey, {super.key});

  @override
  State<ServiceAreaStep> createState() => _ServiceAreaStepState();
}

class _ServiceAreaStepState extends State<ServiceAreaStep> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Service Area',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        SelectState(
          onCountryChanged: (value) {
            setState(() {
              countryValue = value;
            });
          },
          onStateChanged: (value) {
            setState(() {
              stateValue = value;
            });
          },
          onCityChanged: (value) {
            setState(() {
              cityValue = value;
            });
          },
        ),
       
        AppInputField(label: 'ZIP Code', hint:'123232', controller: TextEditingController())
       
      ],
    );
  }
}