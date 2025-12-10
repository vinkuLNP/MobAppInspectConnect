import 'package:flutter/material.dart';
import 'package:country_state_city/country_state_city.dart' as csc;
import 'package:inspect_connect/core/utils/constants/app_colors.dart';
import 'package:inspect_connect/core/utils/presentation/app_common_text_widget.dart';
import 'package:inspect_connect/features/auth_flow/presentation/client/widgets/input_fields.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/inspector_view_model.dart';
import 'package:inspect_connect/features/auth_flow/presentation/inspector/widgets/stepper_header.dart';
import 'package:provider/provider.dart';
import '../../widgets/app_selector_field.dart';
import '../../widgets/country_state_cities_dialog.dart';

class ServiceAreaStep extends StatefulWidget {
  final InspectorViewModelProvider vm;
  final GlobalKey<FormState> formKey;

  const ServiceAreaStep(this.vm, this.formKey, {super.key});

  @override
  State<ServiceAreaStep> createState() => _ServiceAreaStepState();
}

class _ServiceAreaStepState extends State<ServiceAreaStep> {
  void openCitySelectionDialog() async {
    final vm = widget.vm;

    if (vm.selectedCountryCode == null || vm.selectedStateCode == null) return;

    final cities = (vm.cachedCities[widget.vm.selectedCountryCode] ?? [])
        .where((c) => c.stateCode == vm.selectedStateCode)
        .toList();

    final selected = await showMultiSelectSearchDialog<csc.City>(
      context: context,
      items: cities,
      itemAsString: (c) => c.name,
      title: "Select Cities",
      initiallySelected: cities
          .where((c) => vm.selectedCityNames.contains(c.name))
          .toList(),
    );

    vm.selectedCityNames = selected.map((c) => c.name).toList();

    vm.selectedCities
      ..clear()
      ..addAll(vm.selectedCityNames);

    if (vm.selectedCityNames.isNotEmpty) {
      vm.clearCityErrors();
    }
    vm.selectCities(selected.map((c) => c.name).toList());
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InspectorViewModelProvider>(
      builder: (_, vm, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle("Address Details"),
            const SizedBox(height: 10),

            textWidget(
              text: "Select your Service Area",
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSelectorField(
                  label: "Country",
                  value: vm.selectedCountryCode == null
                      ? "Select Country"
                      : vm.cachedCountries!
                            .firstWhere(
                              (c) => c.isoCode == vm.selectedCountryCode!,
                            )
                            .name,
                  onTap: () async {
                    if (vm.cachedCountries == null) return;

                    final selected =
                        await showSearchableListDialog<csc.Country>(
                          context: context,
                          items: vm.cachedCountries!,
                          itemAsString: (c) => c.name,
                          title: "Country",
                        );

                    if (selected != null) {
                      vm.selectCountry(selected.isoCode);
                      await vm.loadStates(selected.isoCode);
                      await vm.loadCities(selected.isoCode);
                      widget.vm.setCountry(selected.isoCode);
                    }
                  },
                ),
                if (vm.countryError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: textWidget(
                      text: vm.countryError!,
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSelectorField(
                  label: "State",
                  value: vm.selectedStateCode == null
                      ? "Select State"
                      : vm.cachedStates[vm.selectedCountryCode]!
                            .firstWhere(
                              (s) => s.isoCode == vm.selectedStateCode!,
                            )
                            .name,
                  onTap: () async {
                    if (vm.selectedCountryCode == null) return;

                    final states =
                        vm.cachedStates[vm.selectedCountryCode] ?? [];
                    if (states.isEmpty) return;

                    final selected = await showSearchableListDialog<csc.State>(
                      context: context,
                      items: states,
                      itemAsString: (s) => s.name,
                      title: "State",
                    );

                    if (selected != null) {
                      vm.selectState(selected.isoCode);
                      vm.selectedStateCode = selected.isoCode;
                      vm.selectedCityNames.clear();
                      widget.vm.setState(selected.isoCode);
                    }
                  },
                ),
                if (vm.stateError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: textWidget(
                      text: vm.stateError!,
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),

            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textWidget(
                      text: "Select Cities",
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                    GestureDetector(
                      onTap: openCitySelectionDialog,
                      child: textWidget(
                        text: "Add / Edit",
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.authThemeColor,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: vm.selectedCityNames.isEmpty
                      ? textWidget(
                          text: "No cities selected",
                          color: Colors.grey,
                        )
                      : Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: vm.selectedCityNames.map((city) {
                            return Chip(
                              backgroundColor: AppColors.selectionColor,
                              label: textWidget(text: city),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                vm.removeCity(city);
                                vm.selectedCityNames.remove(city);
                                widget.vm.selectedCities.remove(city);
                                if (vm.selectedCityNames.isNotEmpty) {
                                  widget.vm.clearCityErrors();
                                } else {
                                  widget.vm.validateServiceArea();
                                }
                              },
                            );
                          }).toList(),
                        ),
                ),

                if (vm.cityError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4, left: 4),
                    child: textWidget(
                      text: vm.cityError!,
                      color: Colors.red,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 18),

            AppInputField(
              label: "Zip Code",
              hint: "123232",
              controller: vm.zipController,
              keyboardType: TextInputType.number,
              validator: (_) => vm.zipError,
              onChanged: (_) => vm.validateServiceArea(),
            ),
            const SizedBox(height: 12),

            AppInputField(
              label: "Enter your Mailing Address",
              hint: "Mailing address",
              controller: vm.mailingAddressController,
              validator: (_) => vm.mailingAddressError,
              onChanged: (_) => vm.validateServiceArea(),
            ),
          ],
        );
      },
    );
  }
}
