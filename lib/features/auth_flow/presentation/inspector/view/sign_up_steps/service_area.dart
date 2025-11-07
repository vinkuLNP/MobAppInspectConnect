import 'package:country_state_city_pro/country_state_city_pro.dart';
import 'package:flutter/material.dart';
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/core/utils/presentation/app_text_style.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:provider/provider.dart';

class ServiceAreaStep extends StatefulWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;

  const ServiceAreaStep(this.vm, this.formKey, {super.key});

  @override
  State<ServiceAreaStep> createState() => _ServiceAreaStepState();
}

class _ServiceAreaStepState extends State<ServiceAreaStep> {


  String? validateMailingAddress(String? value) {
    if (value == null || value.isEmpty) return 'Please enter mailing address';
    return null;
  }

  String? validateZipCode(String? value) {
    if (value == null || value.isEmpty) return null; 
    final numeric = RegExp(r'^[0-9]+$');
    if (!numeric.hasMatch(value)) return 'Zip code must be numeric';
    return null;
  }

  void saveDataToProvider() {
    widget.vm.country = widget.vm.countryController.text;
    widget.vm.state = widget.vm.stateController.text;
    widget.vm.city = widget.vm.cityController.text;
    widget.vm.zipCode = widget.vm.zipController.text;
    widget.vm.mailingAddress =widget.vm. mailingAddressController.text;
  }

  @override
  Widget build(BuildContext context) {
 
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle('Address Details'),
            const SizedBox(height: 8),
            Text(
              'Select your Service Area',
              style: appTextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 8),

         
                Consumer<InspectorViewModelProvider>(
                  builder: (_, vm, _) =>   FormField<String>(
              validator: (_) {
                final country = vm.countryController.text;
                final state = vm.stateController.text;
                final city = vm.cityController.text;
                if (country.isEmpty) return 'Please select a country';
                if (state.isEmpty) return 'Please select a state';
                if (city.isEmpty) return 'Please select a city';
                return null;
              },
              builder: (field) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CountryStateCityPicker(
                      country: vm.countryController,
                      state: vm.stateController,
                      city: vm.cityController,
                      dialogColor: Colors.grey.shade50,
                      textFieldDecoration: InputDecoration(
                        filled: true,
                        suffixIcon: const Icon(Icons.arrow_drop_down_rounded),
                        fillColor: Colors.grey.shade50,
                        errorStyle: appTextStyle(
                          fontSize: 12,
                          color: Colors.red,
                        ),
                        hintStyle: appTextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
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
                          borderSide: BorderSide(
                            color: AppColors.authThemeColor,
                          ),
                        ),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 4, left: 12),
                        child:  textWidget(
                              text:  field.errorText!,
                            color: Colors.red,
                            fontSize: 12,
                        ),
                      ),
                  ],
                );
              },
       ),
                ),

            const SizedBox(height: 8),
            AppInputField(
              label: 'Zip Code',
              hint: '123232',
              controller: widget.vm.zipController,
              keyboardType: TextInputType.number,
              validator: validateZipCode,
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 8),
            AppInputField(
              label: 'Enter your Mailing Address',
              hint: 'Mailing address',
              controller:widget.vm. mailingAddressController,
              validator: validateMailingAddress,
              onChanged: (_) => setState(() {}),
            ),
          ],
        );
  }
}
